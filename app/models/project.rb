class Project < ActiveRecord::Base
  validates :name, format: {with: Patterns::NAME}

  has_many :versions, dependent: :destroy

  def latest_version
    versions.last
  end

  def to_s
    name
  end
end
