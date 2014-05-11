Rails.application.routes.draw do
  resources :projects, path: :gems, only: [:index]
  resources :versions, path: :gems, only: [:show], constraints: {id: /[^\/]*?/, format: /html|json|gem/}

  root to: "home#show"
end
