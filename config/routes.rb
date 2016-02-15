Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: {omniauth_callbacks: 'omniauth_callbacks'}
  root to: "questions#index"


  resources :questions do
    resources :answers, shallow: true
    resources :comments, only: [:new, :create]
  end

  resources :answers, only: [] do
    resources :comments, only: [:new, :create]
  end

  resources :attachments, only: [:destroy]

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end

      resources :questions
    end
  end


end
