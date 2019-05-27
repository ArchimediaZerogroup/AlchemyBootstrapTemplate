require "open-uri"
require 'yaml'

version = %x(bin/rails version).gsub("\n", "").gsub("Rails", "")
gem_version = Gem::Version.new(version)
REPOSITORY_URL = "https://github.com/ArchimediaZerogroup/AlchemyBootstrapTemplate/raw/master"


ask("Remeber!!!! DISABLE_SPRING=true before command.")

def download_file(source_path, destination: nil, repository_url: REPOSITORY_URL)

  destination = destination || source_path
  get "#{repository_url}/#{source_path}", destination

end

say "You are using Rails #{gem_version.inspect}"

if gem_version <= Gem::Version.new("5.2.3")


  gem 'jquery-rails'
  gem 'jquery-ui-rails'
  gem 'alchemy_cms', '~> 4.2.0.rc1'
  gem 'alchemy-devise', github: 'AlchemyCMS/alchemy-devise', branch: '4.2-stable'


  application_js = 'app/assets/javascripts/application.js'
  inject_into_file application_js, before: '//= require_tree .' do
    "\n//= require jquery3\n//= require jquery_ujs\n"
  end

  application_css = 'app/assets/stylesheets/application.css'
  inject_into_file application_css, :before => " */" do
    "\n  *= require sass_requires\n"
  end

  sass_requires = 'app/assets/stylesheets/sass_requires.scss'

  file sass_requires, <<-CODE
//
  CODE


  if yes?("Do you want to use 'Autoprefixer'?  ")
    gem 'autoprefixer-rails', '~> 9.1', '>= 9.1.4'
  end

  if yes?("Vuoi owlcarousel2?")
    gem 'rails-assets-OwlCarousel2', source: 'https://rails-assets.org'

    inject_into_file application_js, before: '//= require_tree .' do
      "\n//= require OwlCarousel2\n"
    end

    inject_into_file application_css, :before => " */" do
      "\n//= require OwlCarousel2\n"
    end
  end


  if yes?("Do you want to use 'Bootstrap 4'? (https://getbootstrap.com/)  ")
    gem 'bootstrap', '~> 4.1', '>= 4.1.3'
    inject_into_file sass_requires, before: '//= require_tree .' do
      "\n  @import \"bootstrap\";\n"
    end
    inject_into_file application_js, before: '//= require_tree .' do
      "\n//= require popper\n//= require bootstrap\n"
    end

  end

  if yes?("Do you want to use 'Font awesome'? (https://fontawesome.com/)")
    gem "font-awesome-rails"

    inject_into_file application_css, :before => " */" do
      "\n  *= require font-awesome\n"
    end

  end


  installed_cookie_law = false
  if yes?("Do you want to use 'cookie_law' gem? (https://github.com/coders51/cookie_law) ")
    gem "cookie_law"

    inject_into_file application_css, :before => " */" do
      "\n  *= require cookie_law\n"
    end

    inject_into_file application_js, before: '//= require_tree .' do
      "\n//= require js.cookie\n//= require cookie_law\n"
    end

    inject_into_file "app/views/layouts/application.html.erb", :before => "</body>" do
      "<%= cookie_law! %>"
    end

    say "Remember! You must complete configuration with initializer config/initializers/cookie_law.rb", [:red, :on_white, :bold]

    installed_cookie_law = true
  end


  if yes?("Do you want to use Fail2Ban script ?")

    file "config/initializers/fail2ban.rb", <<-CODE
module Fail2ban

  LOGGER = Logger.new(Rails.root.join('log', 'logins.log'), 'weekly')

  ATTEMPT_PATHS = ["/admin/login",
                   "/users/sign_in"]

  Warden::Manager.before_failure do |env, opts|
    if opts[:action] == 'unauthenticated' and Fail2ban::ATTEMPT_PATHS.include?(opts[:attempted_path])
      ip = env['action_dispatch.remote_ip'] || env['REMOTE_ADDR']
      user = env['action_dispatch.request.parameters']['user']['email'] rescue 'unknown'

      Fail2ban::LOGGER.error "Failed login for '" + user + "' from " + ip + " at " + Time.now.utc.iso8601
    end
  end


### Fail2Ban config
## /etc/fail2ban/filter.d/your-rails-app.conf

#[INCLUDES]
#before = common.conf
#[Definition]
#failregex = ^\s*(\[.+?\] )*Failed login for '.*' from <HOST> at $


##/etc/fail2ban/jail.local

#[your-rails-app]
#enabled = true
#filter  = your-rails-app
#port    = http,https
#logpath = /path/to/your/production.log

end

    CODE

    say "Remember! You must complete fail2ban configuration with initializer config/initializers/fail2ban.rb", [:red, :on_white, :bold]

  end

  if yes?("Do you want to use Re-Captcha gem? (http://github.com/ambethia/recaptcha) ")
    gem "recaptcha", require: "recaptcha/rails"

    file "config/initializers/recaptcha.rb", <<-CODE
Recaptcha.configure do |config|
  config.site_key  = Rails.application.secrets.recaptcha.nil? ? "" : Rails.application.secrets.recaptcha[:site_key]
  config.secret_key = Rails.application.secrets.recaptcha.nil? ? "" : Rails.application.secrets.recaptcha[:secret_key]
  config.skip_verify_env += ["development"]
end
    CODE


    say "Remember! You must complete configuration into initializer config/initializers/recaptcha.rb with API-KEY ", [:red, :on_white, :bold]

  end

  airbrake_installed=false
  if yes?("Do you want to use Airbrake gem? (https://github.com/airbrake/airbrake)")
    gem 'airbrake', '~> 5.0'

    say "Remember! You must complete Airbrake configuration.", [:red, :on_white, :bold]
    airbrake_installed=true
  end


  gem 'js-routes'
  inject_into_file application_js, before: "//= require_tree ." do
    "\n//= require js-routes\n"
  end

  if yes?("Do you want to use production cache with rack-cache and with redis as backend?")
    gem_group :production do
      gem 'redis-rack-cache'
      gem 'redis-rails'
    end

    append_to_file 'config/environments/production.rb', <<-CODE
Rails.application.configure do
     config.cache_store = :redis_store, "redis://redis:6379/0/cache", { expires_in: 90.minutes }
     
     config.action_dispatch.rack_cache = {
       metastore: "redis://redis:6379/1/metastore",
       entitystore: "redis://redis:6379/1/entitystore"
     }
end
    CODE

    say "Remeber! You need Redis service in production environment. If you use docker deploy you will have already configured..", [:red, :on_white, :bold]


  end


  gem 'friendly_id', '~> 5.2', '>= 5.2.4'
  gem 'rails-i18n', '~> 5.1'

  deploy_with_docker = false
  capistrano_installed = false
  if yes?("Do you want to use Capistrano for deploy task?")

    if yes?("Do you want to use Docker for deploy task?")
      deploy_with_docker = true
    end

    capistrano_installed = true
    gem_group :development do
      gem 'capistrano'
      gem 'capistrano-db-tasks', require: false

      if deploy_with_docker
        gem 'stackose', '~> 0.1.1', require: false
      else
        gem 'capistrano-rails'
        gem 'capistrano-rvm'
        gem 'capistrano-rails-console', '~> 1.0.0'
        gem 'capistrano-rails-tail-log'
        gem 'capistrano-passenger'
      end

    end
  end


  alchemy_custom_model=false
  if yes?("Do you want extended module with custom model?")
    gem 'alchemy-custom-model', '~> 2.0', '>= 2.0.3'
    alchemy_custom_model=true
  end

  if yes?("Do you want ajax submit form ?")
    gem 'alchemy-ajax-form', github: "ArchimediaZerogroup/alchemy-ajax-form", branch: "custom_message_response"
  end


  pg_search = false
  if yes?("Do you want pg_search gem for full text search? It work only if use Postrgresql as DBMS.")
    gem 'pg_search'
    pg_search = true
  end




  after_bundle do

    generate 'alchemy:devise:install'
    rails_command 'alchemy:install'


    if capistrano_installed
      run "bundle exec cap install"
      if deploy_with_docker

        append_to_file 'config/deploy.rb' do
          "\n
set :assets_dir, %w(public/system/. uploads/. public/pages/. public/noimage/.)
set :local_assets_dir, %w(../../shared/public/system ../../shared/uploads ../../shared/public/pages ../../shared/public/noimage)

set :stackose_copy, %w[config/secrets.yml]

set :stackose_commands, ['run --rm --no-deps app rails assets:precompile', 'run --rm  --no-deps app rails db:migrate']

set :stackose_linked_folders, ['public/system',
                               'public/pictures',
                               'public/attachments',
                               'public/pages',
                               'public/assets',
                               'uploads',
                               :'__shared_path__/db_volume' => '/usr/share/application_storage',
                               :\"/var/log/dockerized/__application__\"=>\"__capose_docker_mount_point__/log\"
]

\n\n"
        end

        [
          "lib/capistrano/tasks/docker.rake",
          "Dockerfile",
          "docker-compose.yml",
          ".dockerignore"
        ].each do |f|
          download_file f
        end

        inject_into_file 'Capfile', :before => "# Load custom " do
          "\nrequire 'capistrano-db-tasks'
require 'stackose'\n\n"
        end

      else
        inject_into_file 'Capfile', :before => "# Load custom " do
          "\nrequire 'capistrano/rvm'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano/passenger'
require 'capistrano-db-tasks'\n\n"
        end
      end
    end


    generate 'friendly_id'

    generate 'cookie_law:install' if installed_cookie_law

    rails_command 'alchemy_custom_model:install' if alchemy_custom_model


    generate 'airbrake 0123 abcd' if airbrake_installed

    download_file "config/locales/devise.it.yml"

    download_file "config/puma.rb"

    generate 'pg_search:migration:multisearch' if pg_search


    if pg_search

      download_file "app/lib/search_result.rb"

      download_file "app/models/alchemy/content_decorator.rb"

      download_file "app/models/alchemy/essence_html_decorator.rb"

      download_file "app/models/alchemy/essence_richtext_decorator.rb"

      download_file "app/models/alchemy/essence_text_decorator.rb"

      download_file "app/models/alchemy/page_decorator.rb"

      download_file "app/models/concerns/alchemy/content_dec.rb"

      download_file "app/models/concerns/alchemy/essence_html_dec.rb"

      download_file "app/models/concerns/alchemy/essence_richtext_dec.rb"

      download_file "app/models/concerns/alchemy/essence_text_dec.rb"

      download_file "app/models/concerns/alchemy/page_dec.rb"

      download_file "app/models/concerns/searchable.rb"

      download_file "app/views/alchemy/search/_form.html.erb"

      download_file "app/views/alchemy/search/_result.html.erb"

      download_file "app/views/alchemy/search/_results.html.erb"

      download_file "db/migrate/20180405200556_add_searchable_to_alchemy_essence_texts.alchemy_pg_search.rb"

      download_file "db/migrate/20180405200557_add_searchable_to_alchemy_essence_richtexts.alchemy_pg_search.rb"

      download_file "db/migrate/20180405200558_add_searchable_to_alchemy_essence_pictures.alchemy_pg_search.rb"

      download_file "config/initializers/archimedia_pgsearch.rb"

      download_file "config/initializers/pg_search.rb"

      append_to_file "config/alchemy/elements.yml", <<-CODE
- name: search_form
  hint: false
  contents: []

      CODE

      append_to_file "config/alchemy/page_layouts.yml", <<-CODE
- name: search_results
  searchresults: true
  unique: true

      CODE

      rails_command 'db:migrate'
    end


    if yes?("Do you want use 'language link url' helper into head?")
      download_file "app/helpers/link_languages_helper_decorator.rb"
      say "Created 'language_links_by_page' helper that must be insert into layouts (<%= language_links_by_page(@page)  %>)", [:red, :on_white, :bold]
    end


    if yes?("Do you want download IT locales ?")
      get "https://github.com/AlchemyCMS/alchemy_i18n/raw/master/config/locales/alchemy.it.yml", "config/locales/alchemy.it.yml"
      download_file "vendor/assets/javascripts/tinymce/langs/it.js"
      get "https://raw.githubusercontent.com/AlchemyCMS/alchemy_i18n/master/app/assets/javascripts/alchemy_i18n/it.js", "app/assets/javascript/alchemy_i18n/it.js"

    end


    #Configure Alchemy defaults

    append_to_file "config/alchemy/config.yml" do
      "\nitems_per_page: 100"
    end

    #Cache assets initializer
    download_file "config/initializers/static_assets_cache.rb"



  end


else
  raise "Alchemy 4.1 it's not compatible with Rails version"
end
