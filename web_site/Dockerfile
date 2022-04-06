# syntax = docker/dockerfile:experimental
# CONFIGURAZIONE
ARG ruby_version="ruby:2.7-alpine3.14"

# Root applicazione rails
ARG rails_root=/usr/share/www
ARG rails_env=production

#pacchetti necessari a tutte le immagini
ARG base_packets="alpine-conf bash tzdata"

# pacchetti necessari alla build e installazione gemme
ARG build_packages="build-base curl-dev git yaml-dev zlib-dev yarn nodejs"

# Default editor, e pacchetto da installare nell'immagine di sviluppo
ARG default_editor="nano"

# Pacchetti generali per sviluppo e produzione, aggiungere o togliere rispetto alle esigenze,
# cercare di tener solo lo stretto necessario
#
# imagemagick => imagemagick  # se usate dragonfly o vecchi paperclip o rails
# mimemagik => shared-mime-info
# postgresql(sviluppo) => postgresql-dev
# postgresql(produzione) => postgresql-client
ARG app_dev_dependency="shared-mime-info postgresql-dev imagemagick curl yarn nodejs"
ARG app_deploy_dependency="shared-mime-info postgresql-client imagemagick yarn nodejs"


ARG bundler_version="2.3.9"

#---------------------------------------------
# INIZIO GENERAZIONE IMMAGINE


# immagine base uguale per build e development
FROM $ruby_version as start_image

ARG rails_root
RUN mkdir -p $rails_root
WORKDIR $rails_root
ENV RAILS_ROOT=$rails_root

ARG rails_env
ENV RAILS_ENV=$rails_env
ENV NODE_ENV=$RAILS_ENV
ENV BUNDLE_APP_CONFIG="$RAILS_ROOT/.bundle"


RUN gem update --system # c'è un warning se non aggiorniamo la versione
ARG bundler_version
RUN gem install --default -v "$bundler_version" bundler

ARG base_packets
RUN --mount=type=cache,sharing=locked,target=/etc/apk/cache apk update  \
    && apk upgrade && apk add $base_packets
RUN setup-timezone -z 'Europe/Rome'

##
# stage per installare i componenti che servono allo sviluppo e all'immagine di build
# ma non in produzione
FROM start_image as development_build_image_dependency
# dobbiamo richiamare qua le variabili che ci interessano
ARG build_packages
ARG app_dev_dependency

RUN --mount=type=cache,sharing=locked,target=/etc/apk/cache  \
    apk add --update $build_packages $app_dev_dependency
RUN ln -s /usr/bin/python2 /usr/local/bin/python

#------------------------------------------------------------
# IMMAGINE DI SVILUPPO
FROM development_build_image_dependency as development_image

ARG default_editor
RUN --mount=type=cache,sharing=locked,target=/etc/apk/cache \
    apk add --update $default_editor
#questo serve per editare le credentials
ENV EDITOR='nano'
# helper per webpacker
RUN touch /.yarnrc && chmod 777 /.yarnrc
RUN mkdir /.cache && chmod 777 /.cache

# install rubygem
COPY Gemfile Gemfile.lock $rails_root/
RUN bundle

#------------------------------------------------------------
# IMMAGINE COMPILAZIONE
FROM development_build_image_dependency as build_image

COPY package.json yarn.lock $rails_root/
# install rubygem
COPY Gemfile Gemfile.lock $rails_root/

RUN bundle config --global frozen 1 \
    && bundle config set without development:test:assets \
    && bundle config set path $RAILS_ROOT/vendor/bundle \
    && bundle install -j4 --retry 3 \
    # Remove unneeded files (cached *.gem, *.o, *.c)
    && rm -rf vendor/bundle/ruby/*/cache/*.gem \
    && find vendor/bundle/ruby/*/gems/ -name "*.c" -delete \
    && find vendor/bundle/ruby/*/gems/ -name "*.o" -delete
RUN yarn install --production
COPY . .

## se impostata la master key, viene configurata ed utilizzata per poi eseguire precompilazione con secrets,
## viene utilizzato quando nella precompilazione si vuole iniettare l'env e quindi la rails env è impostata correttamente
ARG master_key=false
RUN --mount=type=secret,id=auto-devops-build-secrets . /run/secrets/auto-devops-build-secrets \
    && echo "ENV=${RAILS_ENV}" \
    && env \
    && RAILS_DB_ADAPTER=nulldb bundle exec rails assets:precompile \
    && mkdir -p public/assets/img \
    && mkdir -p public/assets/alchemy/img \
    && RAILS_DB_ADAPTER=nulldb bundle exec rails runner "FileUtils.cp_r(Dir.glob(File.join(Gem.loaded_specs['alchemy-custom-model'].full_gem_path,'vendor','elfinder','img','*')),Rails.root.join('public','assets','img'))" \
    && RAILS_DB_ADAPTER=nulldb bundle exec rails runner "FileUtils.cp_r(Dir.glob(File.join(Gem.loaded_specs['alchemy-custom-model'].full_gem_path,'vendor','elfinder','img','*')),Rails.root.join('public','assets','alchemy','img'))" \
    && rm -fr tmp/cache log/* node_modules app/assets vendor/assets spec test \
    && chmod 777 tmp && chmod 777 log
##
# Attenzione che se siete in una versione >= della 4 di sprockets,
# non dovrete cancellare la cartella app/assets/config,
# quindi potrete cancellare tutto il resto ma non quella.
##

#------------------------------------------------------------
# IMMAGINE DI PRODUZIONE
FROM start_image

ARG base_packets
ARG app_deploy_dependency

RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache  \
    $base_packets  \
    $app_deploy_dependency

COPY --from=build_image $rails_root $rails_root
EXPOSE 3000
SHELL ["/bin/bash", "-c"]
CMD ["rails", "server", "-b", "0.0.0.0"]