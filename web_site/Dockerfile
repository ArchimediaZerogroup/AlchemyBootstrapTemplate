# syntax = docker/dockerfile:experimental
FROM reg.gitlab.archimedianet.it/docker_images/rails/2.7-je/pg13:0.1 as dependency_image

RUN mkdir -p /usr/share/www
WORKDIR /usr/share/www

# Check to see if server.pid already exists. If so, delete it.
RUN test -f tmp/pids/server.pid && rm -f tmp/pids/server.pid; true

##
# Immagine di sviluppo
FROM dependency_image as development_image
# fino a quando non abbiamo le gemme compilate dobbiamo fare così:
RUN apt update && apt install -y nano
#questo serve per editare le credentials
ENV EDITOR='nano'

RUN touch /.yarnrc && chmod 777  /.yarnrc

FROM dependency_image as base_image
ADD Gemfile .
ADD Gemfile.lock .


# Bundle
RUN bundle install --full-index --jobs $(nproc)

ADD package.json .
ADD yarn.lock .

RUN yarn
RUN chmod 777 node_modules

CMD ["rails","server","--port 3000","--binding 0.0.0.0"]
EXPOSE 3000

# imposto la shell di default
SHELL ["/bin/bash", "-c"]

# utilizzato per impostare l'environment nella build, il file in gitlab-ci ha
# dentro la configurazione per utilizzare questi argomenti
ARG rails_env=development
ENV RAILS_ENV=$rails_env


#aggiungo tutta la struttura dell'applicativo nell'immagine prima di precompilare
ADD . .

# se impostata la master key, viene configurata ed utilizzata per poi eseguire precompilazione con secrets,
# viene utilizzato quando nella precompilazione si vuole iniettare l'env e quindi la rails env è impostata correttamente
ARG master_key=false
RUN --mount=type=secret,id=auto-devops-build-secrets . /run/secrets/auto-devops-build-secrets \
    && RAILS_ENV=${CI_ENVIRONMENT_NAME:=production} \
    && echo "ENV=${RAILS_ENV}" \
    && env \
    && RAILS_DB_ADAPTER=nulldb bundle exec rails assets:precompile \
    && mkdir -p public/assets/img \
    && mkdir -p public/assets/alchemy/img \
    && RAILS_DB_ADAPTER=nulldb bundle exec rails runner "FileUtils.cp_r(Dir.glob(File.join(Gem.loaded_specs['alchemy-custom-model'].full_gem_path,'vendor','elfinder','img','*')),Rails.root.join('public','assets','img'))" \
    && RAILS_DB_ADAPTER=nulldb bundle exec rails runner "FileUtils.cp_r(Dir.glob(File.join(Gem.loaded_specs['alchemy-custom-model'].full_gem_path,'vendor','elfinder','img','*')),Rails.root.join('public','assets','alchemy','img'))" \
    && RAILS_DB_ADAPTER=nulldb bundle exec rails runner "FileUtils.cp_r(Dir.glob(File.join(Gem.loaded_specs['alchemy-custom-model'].full_gem_path,'vendor','elfinder','img','*')),Rails.root.join('public','assets','alchemy','img'))" \
    && rm -fr tmp/cache log/* \
    && chmod 777 tmp && chmod 777 log
