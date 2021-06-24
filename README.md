# Bootrap Alchemy Template #
                           
This template is used for create project that use [AlchemyCMS](https://github.com/AlchemyCMS/alchemy_cms) as CMS.
The template install Alchemy, other gems and other "snippets" that [Archimedia](https://www.archimedianet.it) often use into it's projects. 

# Steps

``` rails _5.2.4.5_ new <project_name> -d postgresql ```

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


# Manual steps

rails new -d postgresql -m https://raw.githubusercontent.com/AlchemyCMS/rails-templates/master/all.rb <MY-PROJECT-NAME>

Update Alchemy Gems
    gem 'alchemy_cms', '~> 5.1', '>= 5.1.2'
    gem 'alchemy-devise', '~> 5.1'

Copy 
    .dockerignore 
    .docker-compose.yml
    Dockerfile
docker-compose up

Change .gitignore
    /vendor/development_bundler
    /docker_volumes
    /uploads

Add gems
    gem 'alchemy_i18n', '~> 2.1'
    gem 'js-routes'
    gem 'friendly_id', '~> 5.2', '>= 5.2.4'
    gem 'rails-i18n', '~> 6.0'
    group :development do
        gem 'i18n-debug'
        gem 'httplog'
    end
    gem 'bootstrap', '~> 4.1', '>= 4.1.3'
    gem 'font-awesome-rails'
    gem 'recaptcha', '~> 4.14', require: 'recaptcha/rails'
    gem 'i18n-js', '~> 3.2'
    gem 'friendly_id-globalize', '1.0.0.alpha3'
    gem 'sentry-raven'
    gem 'activerecord-nulldb-adapter', require: ENV.fetch("RAILS_DB_ADAPTER", 'postgresql') == 'nulldb'
    gem 'rack-cache','~> 1.12'
docker-compose down
docker-compose up
docker-compose exec app bundle exec rails generate friendly_id
docker-compose exec app bundle exec rails g alchemy_i18n:install --locales=it
Change config/application.rb
```
    config.action_controller.include_all_helpers=false
    config.i18n.default_locale = :it
    config.time_zone = 'Rome'
    if Rails.application.credentials[Rails.env.to_sym] and Rails.application.credentials[Rails.env.to_sym][:default_url_options]
        config.action_mailer.default_url_options = Rails.application.credentials[Rails.env.to_sym][:default_url_options]
        config.action_mailer.asset_host = Rails.application.
        credentials[Rails.env.to_sym][:default_url_options][:protocol] + "://" +
        Rails.application.credentials[Rails.env.to_sym][:default_url_options][:host] + ":" + Rails.application.
        credentials[Rails.env.to_sym][:default_url_options][:port]
    end

    config.to_prepare do
        # Load application's model / class decorators
        Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
          Rails.configuration.cache_classes ? require(c) : load(c)
        end
    end
    
    smtp_settings = Rails.application.credentials.dig(Rails.env.to_sym,:smtp_settings)
    if smtp_settings
        config.action_mailer.delivery_method = :smtp
        config.action_mailer.smtp_settings = smtp_settings
    end
```
Configure credentials for SMTP
Change
    ```
    items_per_page: 100 into config/alchemy/config.yml:
    config.cache_store = :file_store, Rails.root.join('tmp', 'cache') into config/environment/production.rb
    config.log_level =  ENV.fetch("RAILS_LOG_LEVEL","debug").to_sym into config/environment/production.rb
    ```
Change into production.rb and development.rb
    ```
      config.action_dispatch.rack_cache = {
        verbose: true,
        metastore: "file:#{Rails.root.join('tmp', 'cache', 'rack', 'meta')}",
        entitystore: "file:#{Rails.root.join('tmp', 'cache', 'rack', 'body')}"
      }
    ```
Copy
    config/database.yml
    config/initializers/recaptcha.rb
    config/initializers/static_assets_cache.rb
    config/initializers/tinymce.rb
    config/locales/devise.it.yml
    lib/tasks/alchemy_cache_clear.rake
    config/puma.rb
    app/assets/stylesheets/tinymce/
    vendor/assets/javascripts/tinymce

Modify config/initializers/assets.rb
    Rails.application.config.assets.precompile += %w( tinymce/plugins/alchemy_file_selector/plugin.min.js
        tinymce/plugins/image/plugin.min.js
        tinymce/skins/custom/skin.min.css
        tinymce/skins/custom/content.min.css
        tinymce/langs/*.js
    )

Add gems
    gem 'alchemy-ajax-form', '~> 2.0'
    gem 'alchemy-custom-model', '~> 3.0'
    gem 'alchemy_file_selector', '~> 0.1.4'
    gem 'alchemy-crop-image', github: 'ArchimediaZerogroup/alchemy-crop-image', branch: 'master'

docker-compose exec app bundle exec rails alchemy_custom_model:install
docker-compose exec app bundle exec rails generate alchemy:crop:image:install
