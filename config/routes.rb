Rails.application.routes.draw do
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root to: "home#show"

  resource :session, only: [:new, :create, :destroy]
  resource :password, only: [:edit, :update]
  resource :profile, only: [:edit, :update]

  resources :password_resets, only: [:new, :create, :show]

  resources :time_entries, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :statements, only: [:index, :show]

  # For time entries 
  namespace :api do
    resources :tasks, only: [:index]
    resources :projects, only: [:index]
    resources :time_entries, only: [:create, :update, :destroy, :index]
  end
  
  namespace :reports do
    get 'entries' => 'entries#show'
  end

  namespace :admin do
    resources :statements
    resources :users, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :projects, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :tasks, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :locations, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :statement_periods, only: [:index, :show, :edit, :update, :new]
    namespace :reports do
      get 'payroll' => 'payroll#show'
      get 'summary' => 'summary#show'
    end
  end

end
