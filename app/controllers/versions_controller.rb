class VersionsController < ApplicationController
  before_action :redirect_bare_project
  before_action :prepare_version
  before_action :prepare_package, only: [:browse, :raw]

  def show
    respond_to do |format|
      format.html
      format.gem { send_file @version.package_path }
      format.gemspec { send_data @version.package.specification.to_ruby, type: :gemspec }
    end
  end

  def other
  end

  def browse
  end

  def raw
    @package.data_file(@path) do |file|
      send_data file.data, filename: file.name, type: file.content_type, disposition: file.disposition
    end
  end

private

  def redirect_bare_project
    if project = Project.find_by_name(params[:id])
      redirect_to project.latest_version
    end
  end

  def prepare_version
    @version = Version.find_by_full_name!(params[:id])
  end

  def prepare_package
    @package = @version.package
    @path = request.path_parameters[:path].to_s
    @entry = @package[@path]
    raise "not found" unless @entry.present?
  end
end
