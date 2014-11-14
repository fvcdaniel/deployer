require 'capistrano/console' 
 
role :app, %w{jboss@201.18.100.14}
server '201.18.100.14', user: 'jboss', roles: %w{app}, tipo: 'jboss', ssh_options: {keys: %w(~/.ssh/id_rsa), port: 2214, forward_agent: false, auth_methods: %w(publickey password)}
