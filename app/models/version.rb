class Version < ActiveRecord::Base
  belongs_to :project

  validates :number, format: {with: Patterns::VERSION}

  delegate :name, to: :project

  def version
    number
  end

  def full_name
    if platform == Gem::Platform::RUBY || platform.nil?
      "#{name}-#{version}"
    else
      "#{name}-#{version}-#{platform}"
    end
  end

  def to_param
    full_name
  end
end
