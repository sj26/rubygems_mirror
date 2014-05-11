class VersionsController < ApplicationController
  before_action :redirect_bare_project
  before_action :prepare_version

  def show
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
