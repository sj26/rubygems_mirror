Rails.application.routes.draw do
  resources :projects, path: :gems, only: [:index]

  resources :versions, path: :gems, only: [:show], constraints: {id: Patterns::NONGREEDY_SLUG, format: /html|json|gem|gemspec/} do
    get :other, on: :member

    resource :package, path: "browse", only: [] do
      get :browse, path: "(*path)"
    end
  end

  root to: "home#show"
end
