Rails.application.routes.draw do

  resources :committee_members
  resources :committees
  resources :committee_designations
  resources :recent_events
  resources :photo_galleries
  resources :settings
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
      get 'students', to: 'users#request_student', as: :request_student
      get 'ex-students', to: 'users#ex_students', as: :ex_students
      get 'alumni', to: 'users#alumni', as: :alumni
      post 'create', to: 'users#create', as: :create_user
      get 'list', to: 'users#index', as: :user_list
      get ':id', to: 'users#show', as: :user_show
      get 'edit/:id', to: 'users#edit', as: :edit_user
      patch 'update/:id', to: 'users#update', as: :user_update
      delete ':id', to: 'users#destroy', as: :delete_user
    end

   get 'dashboard', to: 'home#index', as: :dashboard
  get 'profile', to: 'users#profile', as: :profile
  get 'student_registration', to: 'home#student_registration', as: :student_registration
  post 'submit_registration', to: 'home#submit_registration', as: :submit_registration
  get 'edit_profile', to: 'users#edit_profile', as: :edit_profile
   patch 'update_profile', to: 'users#update_profile', as: :update_profile
  # get '/', to: 'home#landing_page', as: :landing_page
  root 'home#landing_page'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
