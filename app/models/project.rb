class Project < ActiveRecord::Base
  validates :name, format: {with: Patterns::NAME}
end
