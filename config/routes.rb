LaserShark::Application.routes.draw do

  get '/i/:code', to: 'invitations#show' # student/teacher invitation handler

  get 'prep'  => 'setup#show' # temporary
  get 'setup' => 'setup#show' # temporary

  root to: 'home#show'
  get '/welcome', to: 'welcome#show'

  # STUDENT / TEACHER AUTH
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/github', as: 'github_session'
  resource :session, :only => [:new, :destroy]
  resource :registration, only: [:new, :create]
  resource :profile, only: [:edit, :update]

  resources :assistance_requests, only: [:index, :create, :destroy] do
    collection do
      delete :cancel
      get :status
    end
    member do
      post :start_assistance
    end
  end

  resources :students, only: [:index] do
    resources :assistances, only: [:create]
  end

  resources :assistances, only: [] do
    member do
      post :end
    end
  end

  #CREATING ACTIVITIES FOR TEACHERS
  resource :activities, only: [:new, :create]

  # CONTENT BROWSING
  resources :days, param: :number, only: [:show] do
    resources :activities, only: [:show, :edit, :update, :delete, :destroy]
    resources :feedbacks, only: [:create, :new], controller: :day_feedbacks
  end

  resources :activities, only: [] do
    resource :activity_submission, only: [:create, :destroy]
    resources :messages, only: [:new, :edit, :update, :create, :index], controller: 'activity_messages'
  end

  resources :cohorts, only: [] do
    resources :students, only: [:index]    # cohort_students_path(@cohort)
    put :switch_to, on: :member
  end

  resources :recordings, only: [:show]

  resources :streams, only: [:index, :show]

  # ADMIN
  namespace :admin do
    root to: 'dashboard#show'
    resources :students, only: [:index]
    resources :cohorts, only: [:index]
  end

  # To test 500 error notifications on production
  get 'error-test' => 'test_errors#create'

end
