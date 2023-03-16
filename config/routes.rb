Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  root to: 'application#website'

  devise_for :users, defaults: { format: :json }, skip: :all
  devise_scope :user do
    # If you change these urls and helpers, you must change these files too:
    # - config/initializers/devise.rb#JWT Devise
    # - spec/support/authentication_helper.rb
    post '/users/login' => 'sessions#create', as: :user_session
    delete '/users/logout' => 'sessions#destroy', as: :destroy_user_session
    post '/users/signup' => 'registrations#create', as: :user_registration
  end

  namespace :api do
    namespace :v1 do
      resources :tokens do
        collection do
          get :get
        end
      end
      resources :users do
        collection do
          get :me
          # get :go_on_call
          # get :go_off_call
          # get :current_info
          # get :oncall
          post :invite
        end
      end
      resources :lines
      resources :conversationcategories
      resources :languages
      resources :tagcategories do
        collection do
          get :all_with_tags
        end
      end
      resources :tags
      resources :conversations do
        collection do
          get :unlogged
          get :recent
          get :by_day
          get :by_dow
          get :by_time_of_day
          get :by_category
        end
      end
    end
  end

  post 'incoming_call', to: 'incoming#voice'
  post 'incoming_sms', to: 'incoming#sms'

  get '/panel(/*path)', to: 'application#panel', as: :panel
  get '/(*path)', to: 'application#website', as: :website
end
