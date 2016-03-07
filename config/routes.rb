Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: {omniauth_callbacks: 'omniauth_callbacks'}
  root to: "questions#index"


  resources :questions do
    resources :answers, shallow: true
    resources :comments, only: [:new, :create]
    post :vote_up, on: :member
    post :vote_down, on: :member
    delete :cancel_vote, on: :member
  end

  resources :answers, only: [] do
    resources :comments, only: [:new, :create]
    post :vote_up, on: :member
    post :vote_down, on: :member
    delete :cancel_vote, on: :member
  end

  resources :attachments, only: [:destroy]

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
        get :others, on: :collection
      end

      resources :questions do
        resources :answers, shallow: true
      end
    end
  end


end
