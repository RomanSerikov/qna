Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :questions do
    resources :answers do
      patch :best, on: :member
    end
  end
end
