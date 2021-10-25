# syntax = docker/dockerfile:experimental
# CONFIGURAZIONE
ARG node_version="mhart/alpine-node:12"
ARG ruby_version="ruby:2.7-alpine"

# Root applicazione rails
ARG rails_root=/usr/share/www
ARG rails_env=production

#pacchetti necessari a tutte le immagini
ARG base_packets="alpine-conf bash"
# pacchetti necessari alla build e installazione gemme
ARG build_packages="build-base curl-dev git yaml-dev zlib-dev"
# Default editor, e pacchetto da installare nell'immagine di sviluppo
ARG default_editor="nano"
# pacchetti generali per sviluppo e produzione
#
# imagemagick => imagemagick  # se usate dragonfly o vecchi paperclip o rails
# mimemagik => shared-mime-info
# postgresql(sviluppo) => postgresql-dev
# postgresql(produzione) => postgresql-client
ARG app_dev_dependency="tzdata shared-mime-info postgresql-dev imagemagick curl"
ARG app_deploy_dependency="tzdata shared-mime-info postgresql-client imagemagick"


ARG bundler_version="2.1.4"

# immagine fasulla per ovviare al problema di clonazione node da immagine versionata
FROM $node_version as node_source


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

# INSTALLAZIONE DI NODEJS
COPY --from=node_source ["/usr/bin/node","/usr/bin/npm","/usr/bin/"]
COPY --from=node_source /usr/local/share/yarn /usr/local/share/yarn
RUN ln -s /usr/local/share/yarn/bin/yarn /usr/local/bin/yarn \
    && ln -s /usr/local/share/yarn/bin/yarnpkg /usr/local/bin/yarnpkg \
    && touch /.yarnrc && chmod 777 /.yarnrc && mkdir -p /.cache/yarn && chmod 777 -R /.cache

#------------------------------------------------------------


# immagine di sviluppo e build
FROM start_image as development_image

# dobbiamo richiamare qua le variabili che ci interessano
ARG base_packets
ARG build_packages
ARG app_dev_dependency

RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache  \
    $base_packets  \
    $build_packages  \
    $app_dev_dependency

RUN setup-timezone -z 'Europe/Rome'

#FROM reg.gitlab.archimedianet.it/docker_images/rails/2.7-je/pg13:0.1 as dependency_image
ARG bundler_version
RUN gem install bundler -v "$bundler_version"

ARG default_editor
RUN apk add --update --no-cache $default_editor
#questo serve per editare le credentials
ENV EDITOR='nano'
# helper per webpacker
RUN touch /.yarnrc && chmod 777  /.yarnrc


#------------------------------------------------------------
# IMMAGINE COMPILAZIONE
FROM development_image as build_image

COPY package.json yarn.lock $rails_root/
# install rubygem
COPY Gemfile Gemfile.lock $rails_root/

RUN bundle config --global frozen 1 \
    && bundle install --without development:test:assets -j4 --retry 3 --path=vendor/bundle \
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