Rails.application.routes.draw do
  # URLs are carefully designed, resource helpers don't suit.

  get "gems", to: "projects#index", as: :projects
  get "search", to: "projects#search", as: :search_projects

  get "gems/:id", to: "versions#show", as: :version, constraints: {id: Patterns::NONGREEDY_SLUG, format: /html|json|gem|gemspec|yaml/}
  get "gems/:id/other", to: "versions#other", as: :other_version, constraints: {id: Patterns::NONGREEDY_SLUG}

  get "gems/:version_id/browse(/*path)", to: "packages#browse", as: :browse_version, constraints: {version_id: Patterns::NONGREEDY_SLUG, path: /.+/}
  get "gems/:version_id/raw(/*path)", to: "packages#raw", as: :raw_version, constraints: {version_id: Patterns::NONGREEDY_SLUG, path: /.+/}

  root to: "home#show"
end
