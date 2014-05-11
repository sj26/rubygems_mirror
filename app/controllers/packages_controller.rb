class PackagesController < ApplicationController
  before_action :prepare_version
  before_action :prepare_package
  before_action :prepare_entry

  def browse
  end

private

  def prepare_version
    @version = Version.find_by_full_name!(params[:version_id])
  end

  def prepare_package
    @package = @version.package
  end

  def prepare_entry
    @path = params[:path].to_s
    @entry = @package[@path]
    raise "not found" unless @entry.present?
  end
end
