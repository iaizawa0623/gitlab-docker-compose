
external_url "https://#{ENV['GITLAB_HOSTNAME']}"

gitlab_rails['time_zone'] = 'Tokyo'

gitlab_rails['initial_root_password'] = ENV['GITLAB_ROOT_PASSWORD']

gitlab_rails['db_adapter'] = "postgresql"
gitlab_rails['db_database'] = "gitlab"
gitlab_rails['db_username'] = "gitlab"
gitlab_rails['db_password'] = ENV['DB_PASSWORD']
gitlab_rails['db_host'] = "db"
gitlab_rails['db_port'] = 5432

nginx['enable'] = true
nginx['client_max_body_size'] = '250m'
nginx['redirect_http_to_https'] = true
nginx['redirect_http_to_https_port'] = 80

##! Most root CA's are included by default
nginx['ssl_client_certificate'] = "/etc/gitlab/ssl/#{ENV['CA_CERT']}"

nginx['ssl_certificate'] = "/etc/gitlab/ssl/#{node['fqdn']}.crt"
nginx['ssl_certificate_key'] = "/etc/gitlab/ssl/#{node['fqdn']}.key"

nginx['ssl_protocols'] = "TLSv1.2 TLSv1.3"

nginx['ssl_session_cache'] = "shared:SSL:10m"

nginx['ssl_session_tickets'] = "off"

nginx['listen_port'] = 443
