Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root to: "home#show"

  resource :session, only: [:new, :create, :destroy]

  resource :profile, only: [:new, :create]
  resources :time_entries, only: [:index, :new, :create, :edit, :update, :destroy]
  namespace :api do
    resources :users, only: [:index]
    resources :tasks, only: [:index]
    resources :projects, only: [:index]
    resources :time_entries, only: [:create, :update, :destroy]
    get 'profile/time_entries'
  end
  namespace :reports do
    get 'entries' => 'entries#show'
  end
  namespace :admin do
    resources :users, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :projects, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :tasks, only: [:index, :new, :create, :edit, :update, :destroy]
    namespace :reports do
      get 'payroll' => 'payroll#show'
      get 'summary' => 'reports#summary'
      get 'user' => 'reports#user'
    end
  end
end
