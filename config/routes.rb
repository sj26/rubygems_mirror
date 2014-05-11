Rails.application.routes.draw do
  resources :projects, path: :gems, only: [:index]

  resources :versions, path: :gems, only: [:show], constraints: {id: Patterns::NONGREEDY_SLUG, format: /html|json|gem|gemspec/} do
    member do
      get :other
      get :browse, path: "browse(/*path)"
      get :raw, path: "raw/*path"
    end
  end

  root to: "home#show"
end
