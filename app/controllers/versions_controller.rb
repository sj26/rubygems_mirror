class VersionsController < ApplicationController
  before_action :redirect_bare_project, only: [:show]
  before_action :prepare_version

  respond_to :html, :json

  def show
    respond_with @version
  end

  def other
    respond_with @version.other_versions
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
