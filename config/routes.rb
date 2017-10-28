Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  root to: "questions#index"

  devise_scope :user do
    post '/register' => 'omniauth_callbacks#register'
  end

  concern :votable do
    member do
      post :voteup
      post :votedown
    end
  end

  concern :commentable do
    resources :comments, only: [:create]
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, concerns: [:votable, :commentable], shallow: true do
      patch :best, on: :member
    end
  end

  resources :subscriptions, only: [:create, :destroy]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end
      resources :questions, only: [:index, :show, :create] do
        resources :answers, only: [:index, :show, :create], shallow: true
      end
    end
  end

  mount ActionCable.server => '/cable'
end
