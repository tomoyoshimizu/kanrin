class Public::ProjectsController < ApplicationController
  include TagEditor

  def index
    @projects = Project.all
  end

  def create
    project = Project.new(project_params)
    project.user_id = current_user.id

    if project.save
      edit_tags(project, params[:project][:tags])
      redirect_to project_url(project)#, notice: "Project was successfully created."
    else
      @new_project = project
      render :new, status: :unprocessable_entity
    end
  end

  def new
    @new_project = Project.new
  end

  def bookmarks
    @project = project_matched_id
  end

  def edit
    @project = project_matched_id
    @tags = project_matched_id.tags.map{|tag| tag.name}.join(",")
  end

  def show
    @project = project_matched_id
  end

  def update
    project = project_matched_id
    if project.update(project_params)
      edit_tags(project, params[:project][:tags])
      redirect_to project_url(project)#, notice: "Project was successfully updated."
    else
      @project = project
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    project_matched_id.destroy
    redirect_to user_path(current_user)#, notice: "Project was successfully destroyed."
  end

  private
    def project_matched_id
      Project.find(params[:id])
    end

    def project_params
      params.require(:project).permit(:title, :description, :status, :visibility)
    end
end
