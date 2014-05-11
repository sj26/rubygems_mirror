class Project < ActiveRecord::Base
  validates :name, format: {with: Patterns::NAME}

  has_many :versions, dependent: :destroy
end
