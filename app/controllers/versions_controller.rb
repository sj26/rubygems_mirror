class VersionsController < ApplicationController
  before_action :redirect_bare_project

  def show
  end

private

  def redirect_bare_project
    if project = Project.find_by_name(params[:id])
      redirect_to project.latest_version
    end
  end
end
