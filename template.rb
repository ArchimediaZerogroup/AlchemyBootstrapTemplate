require "open-uri"
require 'yaml'

version = %x(bin/rails version).gsub("\n", "").gsub("Rails", "")
gem_version = Gem::Version.new(version)
REPOSITORY_URL = "https://github.com/ArchimediaZerogroup/AlchemyBootstrapTemplate/raw/master"

ask("RICORDATI!!!! DISABLE_SPRING=true anteposto al comando")

def download_file(source_path, destination: nil,repository_url:REPOSITORY_URL)

  destination = destination || source_path
  get "#{repository_url}/#{source_path}", destination

end


if gem_version <= Gem::Version.new("5.2")


  gem 'jquery-rails'
  gem 'jquery-ui-rails'


  application_js = 'app/assets/javascripts/application.js'
  inject_into_file application_js, before: '//= require_tree .' do
    "\n//= require jquery3\n//= require jquery_ujs\n//= require jquery-ui\n"
  end

  application_css = 'app/assets/stylesheets/application.css'
  inject_into_file application_css, :before => " */" do
    "\n  *= require sass_requires\n"
  end

  sass_requires = 'app/assets/stylesheets/sass_requires.scss'

  file sass_requires, <<-CODE
//
  CODE


  if yes?("Vuoi Bourbon?(fratello di compass)")
    gem 'bourbon'

    inject_into_file sass_requires, before: '//= require_tree .' do
      "\n  @import \"bourbon\";\n"
    end

  end

  if yes?("Vuoi owlcarousel2?")
    gem 'owlcarousel2'
    inject_into_file sass_requires, before: '//= require_tree .' do
      "\n  @import \"owlcarousel2/owl.carousel\";\n  @import \"owlcarousel2/owl.theme.default\";\n"
    end

    inject_into_file application_js, before: '//= require_tree .' do
      "\n//= require owlcarousel2/owl.carousel\n"
    end
  end

  if yes?("Vuoi Bootstrap(4)?")
    gem 'bootstrap', '~> 4.0.0.beta3'
    inject_into_file sass_requires, before: '//= require_tree .' do
      "\n  @import \"bootstrap\";\n"
    end
    inject_into_file application_js, before: '//= require_tree .' do
      "\n//= require popper\n//= require bootstrap\n"
    end

  end

  if yes?("Vuoi le icone di font awesome?")
    gem "font-awesome-rails"

    inject_into_file application_css, :before => " */" do
      "\n  *= require font-awesome\n"
    end

  end


  installed_cookie_law = false
  if yes?("Vuoi la gemma per cookie law ?")
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

    say "Ricordati che devi completare l'installazione configurando l'inizializzatore config/initializers/cookie_law.rb", [:red, :on_white, :bold]

    installed_cookie_law = true
  end


  if yes?("Vuoi installare l'inizializzatore per gestire i login falliti con Fail2Ban?")

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

    say "Ricordati che devi completare l'installazione configurando fail2ban, guarda in config/initializers/fail2ban.rb che c'è un esempio", [:red, :on_white, :bold]

  end

  if yes?("Vuoi installare Re-Captcha?")
    gem "recaptcha", require: "recaptcha/rails"

    file "config/initializers/recaptcha.rb", <<-CODE
Recaptcha.configure do |config|
  config.site_key  = Rails.application.secrets.recaptcha.nil? ? "" : Rails.application.secrets.recaptcha[:site_key]
  config.secret_key = Rails.application.secrets.recaptcha.nil? ? "" : Rails.application.secrets.recaptcha[:secret_key]
end
    CODE

    say "Ricordati che devi completare l'installazione configurando Re-Captcha con le API-KEY in config/initializers/recaptcha.rb", [:red, :on_white, :bold]

  end


  if yes?("Vuoi installare Airbrake?")
    gem 'airbrake', '~> 5.0'

    say "Ricordati che devi completare la configurazione", [:red, :on_white, :bold]
  end


  gem 'js-routes'
  inject_into_file application_js, before: "//= require_tree ." do
    "\n//= require js-routes\n"
  end

  if yes?("Vuoi predisporre la cache in produzione per utilizzare rack-cache con redis come backend?")
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

    say "Ricordati poi che hai bisogno del servizio redis online, se utilizzerai il deploy con docker avrai già tutto configurato"


  end

  gem 'alchemy_cms', '~> 4.0'
  gem 'alchemy-devise', '~> 4.0'

  deploy_with_docker = false
  capistrano_installed = false
  if yes?("Vuoi installare capistrano per il deploy?")

    if yes?("Vorrai eseguire il deploy tramite Docker?")
      deploy_with_docker = true
    end

    capistrano_installed = true
    gem_group :development do
      gem 'capistrano'
      gem 'capistrano-db-tasks', require: false

      if deploy_with_docker
        gem 'capose', require: false
      else
        gem 'capistrano-rails'
        gem 'capistrano-rvm'
        gem 'capistrano-rails-console', '~> 1.0.0'
        gem 'capistrano-rails-tail-log'
        gem 'capistrano-passenger'
      end

    end


  end

  lang = ask('Definisci la lingua di default[it]')
  lang = 'it' if lang.blank?

  timezone = ask('Definisci Timezone[Rome]')
  timezone = 'Rome' if timezone.blank?

  file 'config/initializers/base_setup.rb', <<-CODE
Rails.application.config.time_zone = '#{timezone}'
Rails.application.config.i18n.default_locale = :#{lang}

Rails.application.config.action_mailer.delivery_method = :smtp
Rails.application.config.action_mailer.smtp_settings = Rails.application.secrets.smtp
  CODE


  after_bundle do

    if capistrano_installed
      run "bundle exec cap install"
      if deploy_with_docker

        append_to_file 'config/deploy.rb' do
          "\n
set :assets_dir, %w(public/system/. uploads/. public/pages/. public/noimage/.)
set :local_assets_dir, %w(../../shared/public/system ../../shared/uploads ../../shared/public/pages ../../shared/public/noimage)
set :capose_copy, %w(config/secrets.yml)
set :capose_commands, ['build', 'run --rm app rails assets:precompile', 'run --rm app rails db:migrate', 'up -d']
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
require 'capose'\n\n"
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

    rails_command 'alchemy:install'
    generate 'alchemy:devise:install'

    generate 'cookie_law:install' if installed_cookie_law


    if yes?("Vuoi l'helper per i 'link url per lingua' nell'head?")
      download_file "app/helpers/link_languages_helper_decorator.rb"
      say "Creato helper 'language_links_by_page' da inserire nel layouts (<%= language_links_by_page(@page)  %>)", [:red, :on_white, :bold]
    end


    if yes?("Vuoi avere la base per la form contatti e la registrazione e-mail (per newsletter?)")

      download_file "config/locales/user_registration.it.yml"

      download_file "app/controllers/admin/user_site_registrations_controller.rb"

      download_file "app/controllers/admin/contact_forms_controller.rb"

      download_file "app/controllers/admin/form_newsletters_controller.rb"

      download_file "app/controllers/alchemy/base_controller_decorator.rb"

      download_file "app/controllers/concerns/forms_concern.rb"

      download_file "app/lib/user_site_resource.rb"

      download_file "app/mailers/user_data_registration_mailer.rb"

      download_file  "app/models/contact_form.rb"

      download_file "app/models/form_newsletter.rb"

      download_file "app/models/user_site_registration.rb"

      download_file "app/models/user_site_registration_ability.rb"

      download_file "app/views/alchemy/elements/_form_contatti_editor.html.erb"

      download_file "app/views/alchemy/elements/_form_contatti_view.html.erb"

      download_file "app/views/alchemy/elements/_form_iscrizione_newsletter_editor.html.erb"

      download_file "app/views/alchemy/elements/_form_iscrizione_newsletter_view.html.erb"

      download_file "app/views/user_data_registration_mailer/_contact_form.html.erb"

      download_file "app/views/user_data_registration_mailer/_form_newsletter.html.erb"

      download_file "app/views/user_data_registration_mailer/notify_registration.html.erb"

      download_file "images/user_site_registrations_module.png"

      download_file "config/initializers/alchemy_user_site_registrations.rb"

      append_to_file "config/alchemy/elements.yml", <<-CODE
- name: form_iscrizione_newsletter
  hint: "Form per l'iscrizione della newsletter"
  unique: true
  contents:
    - name: title
      type: EssenceText
      default: 'Resta Aggiornato sulle nostre novita'
    - name: bottone
      type: EssenceText
      default: "Iscriviti"
    - name: email_destinatario_notifica
      type: EssenceText
      default: "info@example.com"
    - name: pagina_privacy
      type: EssenceText
      settings:
        linkable: true

- name: form_contatti
  hint: "Form dei contatti per il sito"
  unique: true
  contents:
    - name: pagina_privacy
      type: EssenceText
      settings:
        linkable: true
    - name: email_destinatario_notifica
      type: EssenceText
      default: "info@example.com"

      CODE

      inject_into_file "config/routes.rb", before: 'mount Alchemy::Engine' do
        <<-CODE
namespace :admin do
    resources :user_site_registrations
    resources :form_newsletters
    resources :contact_forms
end
        CODE
      end

      download_file "db/migrate/20180102112803_create_user_site_registrations.rb"


      rails_command 'db:migrate'

    end


  end
else
  raise "Alchemy 4.0 è compatibile con Rails <=5.1"
end
