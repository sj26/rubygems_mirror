class ProjectsController < ApplicationController
  before_action :prepare_projects

  def index
    @projects = @projects.page(page_param)
  end

  def search
    @projects = @projects.fuzzy_search(query_param).page(page_param)
  end

private

  helper_method def page_param
    @page_param ||= params[:page]
  end

  helper_method def query_param
    @query_param ||= params.require(:q)
  end

  def prepare_projects
    @projects = Project.all
  end
end
