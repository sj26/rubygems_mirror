Rails.application.routes.draw do
  # URLs are carefully designed, resource helpers don't suit.

  get "gems", to: "projects#index", as: :projects

  get "gems/:id(.:format)", to: "versions#show", as: :version, constraints: {id: Patterns::NONGREEDY_SLUG, format: /html|json/}
  get "gems/:id(.:format)/other", to: "versions#other", as: :other_version, constraints: {id: Patterns::NONGREEDY_SLUG, format: /html|json/}

  get "gems/:version_id(.:format)", to: "package#show", as: :version_package, defaults: {format: "gem"}, constraints: {version_id: Patterns::NONGREEDY_SLUG, format: /gem/}
  get "gems/:version_id(.:format)", to: "package#specification", as: :version_specification, defaults: {format: "gemspec"}, constraints: {version_id: Patterns::NONGREEDY_SLUG, format: /gemspec|ya?ml/}
  get "gems/:version_id/browse(/*path)", to: "packages#browse", as: :browse_version, constraints: {version_id: Patterns::NONGREEDY_SLUG, path: /.+/}
  get "gems/:version_id/raw(/*path)", to: "packages#raw", as: :raw_version, constraints: {version_id: Patterns::NONGREEDY_SLUG, path: /.+/}

  root to: "home#show"
end
