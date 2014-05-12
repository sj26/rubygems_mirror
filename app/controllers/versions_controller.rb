class VersionsController < ApplicationController
  before_action :redirect_bare_project, only: [:show]
  before_action :prepare_version

  def show
    respond_to do |format|
      format.html
      format.json { render json: @version }
      format.gem { send_file @version.package_path }
      format.gemspec { send_data @version.package.metadata_ruby, disposition: :inline }
      format.yaml { send_data @version.package.metadata_yaml }
    end
  end

  def other
    respond_to do |format|
      format.html
      format.json { render json: @version.other_versions }
    end
  end

private

  def redirect_bare_project
    if project = Project.find_by_name(params[:id])
      redirect_to project.latest_version
    end
  end

  def version_param
    params.require(:id)
  end

  def prepare_version
    @version = Version.find_by_full_name!(version_param)
  end
end
