class VersionsController < ApplicationController
  before_action :redirect_bare_project
  before_action :prepare_version

  def show
    respond_to do |format|
      format.html
      format.gem { send_file @version.package_path }
      format.gemspec { send_data @version.package.specification.to_ruby, type: :gemspec }
    end
  end

  def other
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
end
