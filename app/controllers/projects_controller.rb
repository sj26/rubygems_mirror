class ProjectsController < ApplicationController
  before_action :prepare_projects

  def index
    @projects = @projects.page(params[:page])
  end

private

  def prepare_projects
    @projects = Project.all
  end
end
