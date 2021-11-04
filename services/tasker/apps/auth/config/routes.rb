# Configure your routes here
# See: https://guides.hanamirb.org/routing/overview
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }
get '/auth/:provider/callback', to: "oauth_session#create"
post '/oauth_session', to: 'oauth_session#create'
get '/signin', to: 'signin#index'
delete '/oauth_session/:id', to: 'oauth_session#destroy'
