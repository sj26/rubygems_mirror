Rails.application.routes.draw do
  resources :projects, path: :gems, only: [:index]

  root to: "home#show"
end
