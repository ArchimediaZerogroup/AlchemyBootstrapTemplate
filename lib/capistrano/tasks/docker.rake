require 'json'
namespace :docker do
  namespace :db do
    desc "Uploads DB development.sqlite3 to remote servers {{stage}}.sqlite3"
    task :push do
      ask(:conferma_upload_e_override_del_db, false)
      if fetch(:conferma_upload_e_override_del_db)
        on release_roles :all do
          within shared_path do
            upload! "./db/development.sqlite3", "#{shared_path}/db_volume/#{fetch(:stage)}.sqlite3"
          end
        end
      end
    end

    desc "Download remote DB {{stage}}.sqlite3 to local development.sqlite3"
    task :pull do
      ask(:conferma_download_e_override_del_db, true)
      if fetch(:conferma_download_e_override_del_db)
        on release_roles :all do
          within shared_path do
            download! "#{shared_path}/db_volume/#{fetch(:stage)}.sqlite3", "./db/development.sqlite3"
          end
        end
      end
    end
  end


end