class Version < ActiveRecord::Base
  belongs_to :project

  validates :number, format: {with: Patterns::VERSION}

  delegate :name, to: :project
end
