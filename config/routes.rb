Rails.application.routes.draw do
   # devise_for :users
   devise_for :users, :controllers => { :sessions => "users/sessions" }
  resources :users
  # devise_for :users, controllers: {
  #   sessions: 'users/sessions',
  #   registrations: 'users/registrations',
  #   passwords: 'users/passwords',
  #   confirmations: 'users/confirmations'
  # }
  get 'dashboard', to: 'home#index', as: :dashboard
  # get '/', to: 'home#landing_page', as: :landing_page
  root 'home#landing_page'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
