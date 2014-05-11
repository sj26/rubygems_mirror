class Project < ActiveRecord::Base
  validates :name, format: {with: Patterns::NAME}

  has_many :versions, dependent: :destroy

  def to_s
    name
  end
end
