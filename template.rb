require "open-uri"
require 'yaml'






def default_patch(sass_requires,application_js, application_css)
  
  inject_into_file application_js, before: '//= require_tree .' do
    "\n//= require jquery3\n//= require jquery_ujs\n"
  end
  
  inject_into_file application_css, :before => " */" do
    "\n  *= require sass_requires\n"
  end
  

  file sass_requires, <<-CODE
//
  CODE

  inject_into_file application_js, before: "//= require_tree ." do
    "\n//= require js-routes\n"
  end

  append_to_file 'config/environments/production.rb', <<-CODE
Rails.application.configure do
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = Rails.application.credentials[Rails.env.to_sym][:smtp_settings]
end

CODE

  append_to_file 'config/environments/development.rb', <<-CODE
Rails.application.configure do
  config.action_mailer.delivery_method = :letter_opener
end
CODE

end

def bootstrap4(sass_requires,application_js)
  gem 'bootstrap', '~> 4.1', '>= 4.1.3'
  inject_into_file sass_requires, before: '//= require_tree .' do
    "\n  @import \"bootstrap\";\n"
  end
  inject_into_file application_js, before: '//= require_tree .' do
    "\n//= require popper\n//= require bootstrap\n"
  end
end

def fontawesome(application_css)
  gem "font-awesome-rails"

  inject_into_file application_css, :before => " */" do
    "\n  *= require font-awesome\n"
  end
end

def cookie_law(application_css, application_js)
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
end

def recaptcha_gem
  gem "recaptcha", require: "recaptcha/rails"

  file "config/initializers/recaptcha.rb", <<-CODE
Recaptcha.configure do |config|
  config.site_key  = Rails.application.credentials.recaptcha.nil? ? "" : Rails.application.credentials.recaptcha[:site_key]
  config.secret_key = Rails.application.credentials.recaptcha.nil? ? "" : Rails.application.credentials.recaptcha[:secret_key]
  config.skip_verify_env += ["development"]
end
    CODE

  say "Remember! You must complete configuration into initializer config/initializers/recaptcha.rb with API-KEY ", [:red, :on_white, :bold]
end

def redis_backend
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

def alchemy_custom_model
  gem 'alchemy-custom-model', '~> 2.1', '>= 2.1.1'  

  inject_into_file 'config/application.rb', after: "config.load_defaults 5.2\n" do <<-CODE
    #in modo da far funzionare correttamente l'override degli helper come per i controller
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
  CODE
  end

  return true
end

def default_gems(deploy_with_docker=true)
  gem 'jquery-rails'
  gem 'jquery-ui-rails'  
  gem 'alchemy_cms', '~> 4.4', '>= 4.4.4'
  gem 'alchemy-devise', '~> 4.4'
  gem 'alchemy_i18n', '~> 2.0'
  gem 'letter_opener'
  gem 'autoprefixer-rails', '~> 9.1', '>= 9.1.4'
  gem 'js-routes'
  gem 'friendly_id', '~> 5.2', '>= 5.2.4'
  gem 'rails-i18n', '~> 5.1'

  gem_group :development do
    gem 'capistrano'
    gem 'capistrano-db-tasks', require: false

    if deploy_with_docker
      gem 'stackose', '~> 0.3', require: false
    else
      gem 'capistrano-rails'
      gem 'capistrano-rvm'
      gem 'capistrano-rails-console', '~> 1.0.0'
      gem 'capistrano-rails-tail-log'
      gem 'capistrano-passenger'
    end
  end
  gem 'alchemy-ajax-form', github: "ArchimediaZerogroup/alchemy-ajax-form"

end

def download_file(source_path, destination=nil, repository_url="")
  destination = destination || source_path
  get "#{repository_url}/#{source_path}", destination
end

def pg_search_finalize(repository_url)
  generate 'pg_search:migration:multisearch'
  download_file "app/lib/search_result.rb",nil,repository_url
  download_file "app/models/alchemy/content_decorator.rb",nil,repository_url
  download_file "app/models/alchemy/essence_html_decorator.rb",nil,repository_url
  download_file "app/models/alchemy/essence_richtext_decorator.rb",nil,repository_url
  download_file "app/models/alchemy/essence_text_decorator.rb",nil,repository_url
  download_file "app/models/alchemy/page_decorator.rb",nil,repository_url
  download_file "app/models/concerns/alchemy/content_dec.rb",nil,repository_url
  download_file "app/models/concerns/alchemy/essence_html_dec.rb",nil,repository_url
  download_file "app/models/concerns/alchemy/essence_richtext_dec.rb",nil,repository_url
  download_file "app/models/concerns/alchemy/essence_text_dec.rb",nil,repository_url
  download_file "app/models/concerns/alchemy/page_dec.rb",nil,repository_url
  download_file "app/models/concerns/searchable.rb",nil,repository_url
  download_file "app/views/alchemy/search/_form.html.erb",nil,repository_url
  download_file "app/views/alchemy/search/_result.html.erb",nil,repository_url
  download_file "app/views/alchemy/search/_results.html.erb",nil,repository_url
  download_file "db/migrate/20180405200556_add_searchable_to_alchemy_essence_texts.alchemy_pg_search.rb",nil,repository_url
  download_file "db/migrate/20180405200557_add_searchable_to_alchemy_essence_richtexts.alchemy_pg_search.rb",nil,repository_url
  download_file "db/migrate/20180405200558_add_searchable_to_alchemy_essence_pictures.alchemy_pg_search.rb",nil,repository_url
  download_file "config/initializers/archimedia_pgsearch.rb",nil,repository_url
  download_file "config/initializers/pg_search.rb",nil,repository_url
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

def capistrano_finalize(deploy_with_docker=true, repository_url="")
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
      download_file(f,nil,repository_url)
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


def bootstrap_template(repository_url)
  # Configure generic template Bootstrap based
  append_to_file "config/alchemy/elements.yml", <<-CODE
- name: single_image
  unique: true
  contents:
  - name: image
    type: EssencePicture

- name: single_text
  unique: true
  contents:
  - name: text
    type: EssenceRichtext

- name: contenitore_colonne
  hint: false
  contents:
  - name: classi_css
    type: EssenceText
    default: "mx-3 my-3 mx-lg-5 my-lg-5"
  nestable_elements:
  - colonna_bootstrap

- name: colonna_bootstrap
  hint: false
  contents:
  - name: larghezza
    type: EssenceSelect
  - name: classi_css
    type: EssenceText
    default: "px-2 py-2 px-lg-3 py-lg-0"
  nestable_elements: <%= AlchemyBootstrapGrid.column_elements %>
          
                CODE
    
  append_to_file "config/alchemy/page_layouts.yml", <<-CODE
- name: landing_page
  elements: [header_landing,contenitore_colonne]      
            CODE

  download_file "app/assets/stylesheets/_landing_page.scss",nil,repository_url
  download_file "app/lib/alchemy_bootstrap_grid/col_options_builder.rb",nil,repository_url
  download_file "app/lib/alchemy_bootstrap_grid/row_options_builder.rb",nil,repository_url
  download_file "app/views/alchemy/elements/_colonna_bootstrap_editor.html.erb",nil,repository_url
  download_file "app/views/alchemy/elements/_colonna_bootstrap_view.html.erb",nil,repository_url
  download_file "app/views/alchemy/elements/_contact_landing_form_view.html.erb",nil,repository_url
  download_file "app/views/alchemy/elements/_contenitore_colonne_editor.html.erb",nil,repository_url
  download_file "app/views/alchemy/elements/_contenitore_colonne_view.html.erb",nil,repository_url
  download_file "app/views/alchemy/elements/_single_image_editor.html.erb",nil,repository_url
  download_file "app/views/alchemy/elements/_single_image_view.html.erb",nil,repository_url
  download_file "app/views/alchemy/elements/_single_text_editor.html.erb",nil,repository_url
  download_file "app/views/alchemy/elements/_single_text_view.html.erb",nil,repository_url
  download_file "app/views/alchemy/elements/_text_landing_view.html.erb",nil,repository_url
  download_file "config/initializers/alchemy_bootstrap_grid.rb",nil,repository_url
  download_file "config/initializers/recaptcha.rb" ,nil,repository_url

  inject_into_file 'config/application.rb', after: "config.load_defaults 5.2" do
    "\nconfig.time_zone = 'Rome'"
    "\nconfig.i18n.default_locale = :it"
  end
end

def carousel(application_js, application_css)
  run "yarn add tiny-slider"
  inject_into_file application_js, before: '//= require_tree .' do
    "\n//= require tiny-slider/dist/tiny-slider\n//= require tiny-slider/dist/tiny-slider.helper.ie8\n"
  end
  
  inject_into_file application_css, :before => " */" do
    "\n*= require tiny-slider/dist/tiny-slider\n"
  end

end

def update_gitignore  
  append_to_file ".gitignore", <<-CODE
uploads/
  CODE
end

def alchemy_backend_improvements(repository_url)
  download_file "app/assets/javascripts/mega-menu.js.erb",nil,repository_url
  download_file "app/assets/stylesheets/backend.scss",nil,repository_url
  run "yarn add simplebar"

  append_to_file "vendor/assets/javascripts/alchemy/admin/all.js", <<-CODE
//= require mega-menu
//= require simplebar/dist/simplebar.js
  CODE

  append_to_file "vendor/assets/stylesheets/alchemy/admin/all.css", <<-CODE
*= require backend
*= require simplebar/dist/simplebar.css
  CODE

end


version = %x(bin/rails version).gsub("\n", "").gsub("Rails", "")
gem_version = Gem::Version.new(version)
REPOSITORY_URL = "https://github.com/ArchimediaZerogroup/AlchemyBootstrapTemplate/raw/master"

sass_requires = 'app/assets/stylesheets/sass_requires.scss'
application_js = 'app/assets/javascripts/application.js'
application_css = 'app/assets/stylesheets/application.css'
pg_search = false


ask("Remeber!!!! DISABLE_SPRING=true before command.")
say "You are using Rails #{gem_version.inspect}"

  
default_gems(true)
default_patch(sass_requires, application_js, application_css)
bootstrap4(sass_requires,application_js)
fontawesome(application_css)
cookie_law(application_css, application_js)
recaptcha_gem
redis_backend
alchemy_custom_model

if pg_search
  gem 'pg_search'
end

after_bundle do
  rails_command 'alchemy:install'
  generate 'friendly_id'
  generate 'cookie_law:install'
  rails_command 'alchemy_custom_model:install'
  download_file "config/locales/devise.it.yml",nil,REPOSITORY_URL
  download_file "config/puma.rb",nil,REPOSITORY_URL

  if pg_search
    pg_search_finalize(REPOSITORY_URL)
  end

  capistrano_finalize(true,REPOSITORY_URL)
  bootstrap_template(REPOSITORY_URL)

  download_file "app/helpers/link_languages_helper_decorator.rb",nil,REPOSITORY_URL
  say "Created 'language_links_by_page' helper that must be insert into layouts (<%= language_links_by_page(@page)  %>)", [:red, :on_white, :bold]

  generate 'alchemy_i18n:install --locales=it'

  #Configure Alchemy defaults
  append_to_file "config/alchemy/config.yml" do
    "\nitems_per_page: 100"
  end
  #Cache assets initializer
  download_file "config/initializers/static_assets_cache.rb",nil,REPOSITORY_URL
  # Add devise css require
  generate 'alchemy:devise:install'
  rails_command "alchemy_custom_model:install"
  
  ["lib/tasks/alchemy_cache_clear.rake"].each do |f|
    download_file f,nil,REPOSITORY_URL
  end

  carousel(application_js, application_css)
  
  alchemy_backend_improvements(REPOSITORY_URL)

  update_gitignore
end  





  



