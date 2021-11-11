Rails.application.routes.draw do
  use_doorkeeper
  scope 'admin' do
    resources :users do
      collection do
        get :me
      end
    end
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  use_doorkeeper

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
