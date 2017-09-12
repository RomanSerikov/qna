Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  concern :votable do
    member do
      post :voteup
      post :votedown
    end
  end

  resources :questions, concerns: [:votable] do
    resources :answers, concerns: [:votable] do
      patch :best, on: :member
    end
  end

  mount ActionCable.server => '/cable'
end
