# Bootrap Alchemy Template #
                           
This template is used for create project that use [AlchemyCMS](https://github.com/AlchemyCMS/alchemy_cms) as CMS.
The template install Alchemy, other gems and other "snippets" that [Archimedia](https://www.archimedianet.it) often use into it's projects. 

# Steps

``` rails _5.2.4.3_ new <project_name> -d postgresql ```

Comment out this gem from Gemfile #gem 'spring-watcher-listen', '~> 2.0.0'. There's a knownn bug for readonly folder watch.

Change ruby version in Gemfile to be like version on Dockerfile

```
cd <project_name>
curl -L https://github.com/ArchimediaZerogroup/AlchemyBootstrapTemplate/raw/master/lib/tasks/bootstrap_utility.rake -o lib/tasks/bootstrap_utility.rake
bundle exec rails alchemy:backend:prepare_environment

docker-compose up
docker-compose exec app bundle exec rails alchemy:backend:selected_gems
docker-compose down
rm -rf Gemfile.lock
docker-compose up
docker-compose down

docker-compose run app bin/rails webpacker:install
docker-compose up
```

# http://0.0.0.0:3000 Yay! You’re on Rails!

```
docker-compose exec app bundle exec rails alchemy:install
docker-compose down
docker-compose up
docker-compose exec app bundle exec rails g alchemy:devise:install
docker-compose down
docker-compose up
```

# http://0.0.0.0:3000 Yay! Alchemy CMS Ready!

```
docker-compose exec app bundle exec rails g alchemy_i18n:install --locales=it
```

Comment out //= require alchemy/alchemy.translations  from vendor/assets/javascripts/alchemy_i18n/it.js

```
docker-compose exec app bundle exec rails generate friendly_id
docker-compose exec app bundle exec rails alchemy:backend:custom_gems

docker-compose down
docker-compose up

docker-compose exec app bundle exec rails generate alchemy:crop:image:install
docker-compose exec app bundle exec rails alchemy_custom_model:install
docker-compose exec app bundle exec rails alchemy:backend:configs
docker-compose exec app bundle exec rails alchemy:backend:improvements
docker-compose exec app bundle exec rails alchemy:backend:bootstrap_template
```

