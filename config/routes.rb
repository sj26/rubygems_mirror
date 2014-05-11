Rails.application.routes.draw do
  resources :projects, path: :gems, only: [:index]

  resources :versions, path: :gems, only: [:show], constraints: {id: Patterns::NONGREEDY_SLUG, format: /html|json|gem|gemspec/} do
    get :other, on: :member

    resource :package, path: "", only: [] do
      get :browse, path: "browse(/*path)"
    end
  end

  root to: "home#show"
end
