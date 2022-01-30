Rails.application.routes.draw do

    # devise_for :users
   #devise_for :users, :controllers => { :sessions => "users/sessions" }
   devise_for :users, controllers: {
     sessions: 'users/sessions',
     registrations: 'users/registrations',
     passwords: 'users/passwords',
     confirmations: 'users/confirmations'
  }
    # resources :users
    scope :users do
      get 'new', to: 'users#new', as: :new_user
      post 'create', to: 'users#create', as: :create_user
      get 'list', to: 'users#index', as: :user_list
      get ':id', to: 'users#show', as: :user_show
      get 'edit/:id', to: 'users#edit', as: :edit_user
      patch 'update/:id', to: 'users#update', as: :user_update
      delete ':id', to: 'users#destroy', as: :delete_user
    end

   get 'dashboard', to: 'home#index', as: :dashboard
  get 'profile', to: 'users#profile', as: :profile
  get 'edit_profile', to: 'users#edit_profile', as: :edit_profile
   patch 'update_profile', to: 'users#update_profile', as: :update_profile
  # get '/', to: 'home#landing_page', as: :landing_page
  root 'home#landing_page'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
