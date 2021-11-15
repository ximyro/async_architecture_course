# Configure your routes here
# See: https://guides.hanamirb.org/routing/overview
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }
get '/', to: 'home#index'
get '/tasks/new', to: 'tasks#new'
post '/tasks', to: 'tasks#create'
post '/tasks/:id/complete', to: 'tasks#complete'
post '/tasks/assign', to: 'tasks#assign'
