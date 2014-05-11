require "rubygems/package"

class Package
  include ActiveModel::Model

  def initialize(path)
    raise ArgumentError, "doesn't exist" unless File.exists? path

    @path = path
    @package = Gem::Package.new(path)
  end

  def specification
    @package.spec
  end
end
