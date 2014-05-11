class Version < ActiveRecord::Base
  belongs_to :project

  validates :number, format: {with: Patterns::VERSION}
  validates :platform, format: {with: Patterns::PLATFORM}
  validates :full_name, uniqueness: true

  before_save :cache_full_name

  delegate :name, to: :project

  def version
    number
  end

  def platform
    super || Gem::Platform::RUBY
  end

  def platform?
    platform != Gem::Platform::RUBY
  end

  def full_name
    if platform?
      "#{name}-#{version}-#{platform}"
    else
      "#{name}-#{version}"
    end
  end

  def to_s
    full_name
  end

  def to_param
    full_name
  end

  def package_path
    Rails.root.join("public", "gems", "#{full_name}.gem")
  end

  def package
    @package ||= Package.new(package_path)
  end

  def specification
    package.specification
  end

private

  def cache_full_name
    self.full_name = full_name
  end
end
