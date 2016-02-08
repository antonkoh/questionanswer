Rails.application.routes.draw do
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

end
