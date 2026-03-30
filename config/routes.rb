Rails.application.routes.draw do

  # Accounts & Payment Module Routes
  namespace :admin do
    resources :payments, only: [:index, :show, :new, :create] do
      member do
        patch :approve
        patch :reject
      end
    end
    resources :subscriptions
    resources :transactions, only: [:index]
    resources :collections, only: [:index] do
      collection do
        get :monthly_report
        get :member_wise
        get :event_wise
      end
    end
  end

  namespace :member do
    resources :payments, only: [:index] do
      collection do
        get :pay_membership
        post :create_membership_payment
        get :events
        get :pay_event
        post :create_event_payment
      end
    end
  end

  # SSLCommerz Callbacks
  post 'sslcommerz/success', to: 'sslcommerz#success', as: :sslcommerz_success
  post 'sslcommerz/fail', to: 'sslcommerz#fail', as: :sslcommerz_fail
  post 'sslcommerz/cancel', to: 'sslcommerz#cancel', as: :sslcommerz_cancel
  post 'sslcommerz/ipn', to: 'sslcommerz#ipn', as: :sslcommerz_ipn

  # Alumni Event Management System Routes
  resources :alumni_events do
    member do
      get 'financial_summary'
    end
    resources :event_expenses, only: [:create, :update, :destroy]
    resources :event_incomes, only: [:create, :update, :destroy]
  end

  resources :event_expenses, only: [] do
    resources :expense_payments, only: [:create, :destroy]
  end

  resources :event_reports, only: [:index] do
    collection do
      get 'expenses_report'
      get 'incomes_report'
      get 'financial_summary'
      get 'export_pdf'
      get 'export_excel'
    end
  end

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
   patch 'make_as_alumni', to: 'users#make_as_alumni', as: :make_as_alumni
  # get '/', to: 'home#landing_page', as: :landing_page
  root 'home#landing_page'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
