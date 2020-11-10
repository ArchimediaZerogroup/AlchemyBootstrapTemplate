require 'open-uri'
require 'fileutils'

REPOSITORY_URL = "https://github.com/ArchimediaZerogroup/AlchemyBootstrapTemplate/raw/master"

namespace :alchemy do
  namespace :backend do

    desc "Prepare environmente"
    task prepare_environment: [:environment] do
      ["config/database.yml",
        "Dockerfile",
        "docker-compose.yml",
        ".dockerignore"
      ].each do |ftd|
        download(ftd, REPOSITORY_URL, ftd)
      end

      open('.gitignore', 'a') { |f|
        f << ".generators\n"
        f << "dump.sql\n"
        f << "vendor/development_bundler\n"
        f << ".idea\n"
        f << "TAGS\n"
        f << "docker_volumes/\n"
        f << "uploads/\n"
      }
    end

    desc "Add selected gems"
    task selected_gems: [:environment] do
      open('Gemfile', 'a') { |f|
        f << "gem 'jquery-rails'\n"
        f << "gem 'jquery-ui-rails'\n"
        f << "gem 'alchemy_cms', '~> 4.6', '>= 4.6.2'\n"
        f << "gem 'alchemy-devise', '~> 4.6'\n"
        f << "gem 'alchemy_i18n', '~> 2.1'\n"
        f << "gem 'autoprefixer-rails', '~> 9.1', '>= 9.1.4'\n"
        f << "gem 'js-routes'\n"
        f << "gem 'friendly_id', '~> 5.2', '>= 5.2.4'\n"
        f << "gem 'rails-i18n', '~> 5.1'\n"
        f << "group :development do\n"
        f << "gem 'i18n-debug'\n"
        f << "gem 'httplog'\n"
        f << "end\n"
        f << "gem 'bootstrap', '~> 4.1', '>= 4.1.3'\n"
        f << "gem 'font-awesome-rails'\n"
        f << "gem 'recaptcha', '~> 4.14', require: 'recaptcha/rails'\n"
        f << "group :production do\n"
        f << "gem 'redis-rack-cache'\n"
        f << "  gem 'redis-rails'\n"
        f << "end\n"
        f << "gem 'i18n-js', '~> 3.2'\n"
        f << "gem 'friendly_id-globalize', '1.0.0.alpha3'\n"
        f << "gem 'webpacker'\n"
        f << "gem \"sentry-raven\"\n"
      }

    end

    desc "Add custom gems"
    task custom_gems: [:environment] do

      puts "Change file config/application.rb with this (press any key when done):"

      puts <<-RAVEN
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
      RAVEN

      a = gets.chomp



      open('Gemfile', 'a') { |f|
        f << "gem 'alchemy-ajax-form', '~> 1.1', '>= 1.1.2'\n"
        f << "gem 'alchemy-custom-model', '~> 2.2'\n"
        f << "gem 'alchemy_file_selector', '~> 0.1.4'\n"
        f << "gem 'alchemy-crop-image', github: 'ArchimediaZerogroup/alchemy-crop-image', branch: 'master'\n"
      }
    end

    desc "Configs"
    task configs: [:environment] do
      puts "Change 'items_per_page: 100' into config/alchemy/config.yml (press any key when done):"
      a = gets.chomp

      ["config/initializers/recaptcha.rb",
        "config/locales/devise.it.yml",
        "lib/tasks/alchemy_cache_clear.rake",
        "config/initializers/static_assets_cache.rb",
        "config/puma.rb"
      ].each do |ftd|
        download(ftd, REPOSITORY_URL, ftd)
      end

      open('config/environments/production.rb', 'a') { |f|
        f << "Rails.application.configure do\n"
        f << "config.cache_store = :redis_store, \"redis://redis:6379/0/cache\", { expires_in: 90.minutes }\n"
        f << "config.action_dispatch.rack_cache = {\n"
        f << "metastore: \"redis://redis:6379/1/metastore\",\n"
        f << "entitystore: \"redis://redis:6379/1/entitystore\"\n"
        f << "}\n"
        f << "end\n"        
      }




    end

    desc "Backend Improvements"
    task improvements: [:environment] do
      system "yarn add simplebar"

      ["app/assets/javascripts/mega-menu.js.erb",
        "app/assets/stylesheets/backend.scss",
        "config/initializers/tinymce.rb",
        "app/assets/stylesheets/tinymce/skins/custom/content.min.css.scss",
        "app/assets/stylesheets/tinymce/skins/custom/skin.min.css.scss",
        "app/assets/stylesheets/tinymce/skins/custom/fonts/tinymce-small.svg",
        "app/assets/stylesheets/tinymce/skins/custom/fonts/tinymce-small.ttf",
        "app/assets/stylesheets/tinymce/skins/custom/fonts/tinymce-small.woff",
        "app/assets/stylesheets/tinymce/skins/custom/fonts/tinymce.svg",
        "app/assets/stylesheets/tinymce/skins/custom/fonts/tinymce.ttf",
        "app/assets/stylesheets/tinymce/skins/custom/fonts/tinymce.woff",
        "app/assets/stylesheets/tinymce/skins/custom/img/anchor.gif",
        "app/assets/stylesheets/tinymce/skins/custom/img/loader.gif",
        "app/assets/stylesheets/tinymce/skins/custom/img/object.gif",
        "app/assets/stylesheets/tinymce/skins/custom/img/trans.gif"
      ].each do |ftd|
        download(ftd, REPOSITORY_URL, ftd)
      end

      open('vendor/assets/javascripts/alchemy/admin/all.js', 'a') { |f|
        f << "//= require mega-menu\n"
        f << "//= require simplebar/dist/simplebar.js\n"
        f << "//= require alchemy_file_selector/alchemy_admin_require.js\n"
      }

      open('vendor/assets/stylesheets/alchemy/admin/all.css', 'a') { |f|
        f << "/*\n"
        f << "*= require backend\n"
        f << "*= require simplebar/dist/simplebar.css\n"
        f << "*= require alchemy-custom-model/manifest.css\n"
        f << "*/\n"
      }

      open('config/initializers/assets.rb', 'a') { |f|
        f << "Rails.application.config.assets.precompile += %w( tinymce/plugins/alchemy_file_selector/plugin.min.js\n"
        f << "tinymce/plugins/image/plugin.min.js\n"
        f << "tinymce/skins/custom/skin.min.css\n"
        f << "tinymce/skins/custom/content.min.css\n"
        f << "tinymce/langs/*.js\n"
        f << ")\n"
      }

    end

    desc "Bootstrap template"
    task bootstrap_template: [:environment] do
      
      open('config/alchemy/elements.yml', 'a') { |f|
        f << "- name: single_image\n"
        f << "  unique: true\n"
        f << "  contents:\n"
        f << "  - name: image\n"
        f << "    type: EssencePicture\n"
        f << "- name: single_text\n"
        f << "  unique: true\n"
        f << "  contents:\n"
        f << "  - name: text\n"
        f << "    type: EssenceRichtext\n"
        f << "- name: contenitore_colonne\n"
        f << "  hint: false\n"
        f << "  contents:\n"
        f << "  - name: classi_css\n"
        f << "    type: EssenceText\n"
        f << "    default: \"mx-3 my-3 mx-lg-5 my-lg-5\"\n"
        f << "  nestable_elements:\n"
        f << "  - colonna_bootstrap\n"
        f << "- name: colonna_bootstrap\n"
        f << "  hint: false\n"
        f << "  contents:\n"
        f << "  - name: larghezza\n"
        f << "    type: EssenceSelect\n"
        f << "    settings:\n"
        f << "      select_values: [1,2,3,4,5,6,7,8,9,10,11,12]\n"
        f << "  - name: classi_css\n"
        f << "    type: EssenceText\n"
        f << "    default: \"px-2 py-2 px-lg-3 py-lg-0\"\n"
        f << "  nestable_elements: <%= AlchemyBootstrapGrid.column_elements %>\n"
        f << "\n"
      }

      open('config/alchemy/page_layouts.yml', 'a') { |f|
        f << "- name: landing_page\n"
        f << "  elements: [header_landing,contenitore_colonne]\n"
        f << "\n"
      }


      ["app/assets/stylesheets/_landing_page.scss",
        "app/lib/alchemy_bootstrap_grid/col_options_builder.rb",
        "app/lib/alchemy_bootstrap_grid/row_options_builder.rb",
        "app/views/alchemy/elements/_colonna_bootstrap_editor.html.erb",
        "app/views/alchemy/elements/_colonna_bootstrap_view.html.erb",
        "app/views/alchemy/elements/_contact_landing_form_view.html.erb",
        "app/views/alchemy/elements/_contenitore_colonne_editor.html.erb",
        "app/views/alchemy/elements/_contenitore_colonne_view.html.erb",
        "app/views/alchemy/elements/_single_image_editor.html.erb",
        "app/views/alchemy/elements/_single_image_view.html.erb",
        "app/views/alchemy/elements/_single_text_editor.html.erb",
        "app/views/alchemy/elements/_single_text_view.html.erb",
        "app/views/alchemy/elements/_text_landing_view.html.erb",
        "config/initializers/alchemy_bootstrap_grid.rb",
        "config/initializers/recaptcha.rb"
      ].each do |ftd|
        download(ftd, REPOSITORY_URL, ftd)
      end      

    end

  end
end

def download(src,repo_url,dest)
  read_image = open( "#{repo_url}/#{src}").read
  
  dirname = File.dirname(dest)
  unless File.directory?(dirname)
    FileUtils.mkdir_p(dirname)
  end

  File.open(dest, 'wb') do |file|
    file.write read_image
  end  
end
