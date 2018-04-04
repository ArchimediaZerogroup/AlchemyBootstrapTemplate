require 'json'
namespace :docker do
  namespace :db do
    desc "Uploads DB development.sqlite3 to remote servers {{stage}}.sqlite3"
    task :push do
      on release_roles :all do
        within shared_path do
          upload! "./db/development.sqlite3", "#{shared_path}/db_volume/#{fetch(:stage)}.sqlite3"
        end
      end
    end

    desc "Download remote DB {{stage}}.sqlite3 to local development.sqlite3"
    task :pull do
      on release_roles :all do
        within shared_path do
          download! "#{shared_path}/db_volume/#{fetch(:stage)}.sqlite3", "./db/development.sqlite3"
        end
      end
    end
  end

  desc "Create online docker-compose file"
  task :create_online_docker_compose_file do

    ask(:exposed_port, 30000)
    ask(:server_name, 'example.tld')

    ask(:need_redis_service, true)

    log_folder = "/var/log/dockerized/#{fetch(:application)}"

    puts "Ricorda di generare la cartella #{log_folder}"

    compose_production = {
      version: '3',
      services: {
        app: {
          build: '.',
          command: 'rails server --port 3000 --binding 0.0.0.0',
          restart: 'unless-stopped',
          environment: {:RAILS_ENV => fetch(:rails_env).to_s,
                        :RAILS_SERVE_STATIC_FILES => 'true',
                        :RAILS_MAX_THREADS => 5,
                        :WEB_CONCURRENCY => 1},
          volumes: ['.:/usr/share/www',
                    "#{shared_path}/db_volume:/usr/share/application_storage",
                    "#{log_folder}/:/usr/share/www/log",
                    "#{shared_path}/tmp/pids:/usr/share/www/tmp/pids",
                    "#{shared_path}/tmp/cache:/usr/share/www/tmp/cache",
                    "#{shared_path}/tmp/sockets:/usr/share/www/tmp/sockets",
                    "#{shared_path}/public/system:/usr/share/www/public/system",
                    "#{shared_path}/public/pictures:/usr/share/www/public/pictures",
                    "#{shared_path}/public/attachments:/usr/share/www/public/attachments",
                    "#{shared_path}/public/pages:/usr/share/www/public/pages",
                    "#{shared_path}/public/assets:/usr/share/www/public/assets",
                    "#{shared_path}/uploads:/usr/share/www/uploads"],
          ports: ["#{fetch(:exposed_port)}:3000"]
        }
      }
    }

    if fetch(:need_redis_service)
      compose_production[:services][:redis] = {
        restart: 'unless-stopped',
        image: 'redis',
        volumes: ["./config/redis.conf:/usr/local/etc/redis/redis.conf"]
      }

      File.open("config/redis.conf", 'w') {|file| file.write("maxmemory 50mb\nmaxmemory-policy allkeys-lfu")}
    end

    nginx_config = "server {
      listen       80;
      server_name  #{fetch(:server_name)};
      location / {
          proxy_pass         http://0.0.0.0:#{fetch(:exposed_port)}/;
          proxy_redirect     off;

          proxy_set_header   Host             $host;
          proxy_set_header   X-Real-IP        $remote_addr;
          proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;

          client_max_body_size       10m;
          client_body_buffer_size    128k;

          proxy_connect_timeout      90;
          proxy_send_timeout         90;
          proxy_read_timeout         90;

          proxy_buffer_size          4k;
          proxy_buffers              4 32k;
          proxy_busy_buffers_size    64k;
          proxy_temp_file_write_size 64k;
       }
     }"

    puts "Configurazione NGINX:"
    puts nginx_config
    puts "Ricorda di cambiare anche la configurazione del database.yml per l'env specificato"
    puts "
    production:
      <<: *default
      pool: <%= ENV.fetch(\"RAILS_MAX_THREADS\") {5} %>
      database: /usr/share/application_storage/production.sqlite3
    "

    File.open("docker-compose-production.yml", 'w') {|file| file.write(JSON[compose_production.to_json].to_yaml)}
  end

end