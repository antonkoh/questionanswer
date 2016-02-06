Rails.application.routes.draw do
  devise_for :users
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
