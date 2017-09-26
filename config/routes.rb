Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  root to: "questions#index"

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

  mount ActionCable.server => '/cable'
end
