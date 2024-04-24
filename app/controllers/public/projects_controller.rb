class Public::ProjectsController < ApplicationController
  include TagEditor

  before_action :get_project_matched_id
  before_action :authenticate_user!,        only: [:create, :new, :edit, :update, :destroy]
  before_action :prohibited_illegal_access, only: [:edit, :update, :destroy]

  def index
    @search_word = params[:search_word] || ""
    scoped_projects = Project.visible.valid.desc
    scoped_projects = scoped_projects.searched_with(@search_word) if @search_word.present?
    @projects = scoped_projects.page(params[:page]).per(6)
    @count = scoped_projects.length
  end

  def create
    @new_project = Project.new(project_params)
    @new_project.user_id = current_user.id

    if @new_project.save
      edit_tags(@new_project, params[:project][:tags])
      redirect_to project_url(@new_project)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def new
    @new_project = Project.new
  end

  def edit
    @tags = @project.tags.map{|tag| tag.name}.join(",")
  end

  def show
    @posts = @project.posts.desc.page(params[:page]).per(6)
  end

  def update
    if @project.update(project_params)
      edit_tags(@project, params[:project][:tags])
      redirect_to project_url(@project)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    delete_all_tags(@project)
    @project.destroy
    redirect_to user_path(current_user)
  end

  private
    def get_project_matched_id
      if params[:id]
        @project = Project.find_by(id: params[:id])
        if @project.nil?
          redirect_to projects_path
        end
        unless admin_signed_in? || @project.user.is_active
          redirect_to projects_path
        end
      end
    end

    def prohibited_illegal_access
      unless current_user == @project.user
        redirect_to user_path(current_user)
      end
    end

    def project_params
      params.require(:project).permit(:title, :description, :status, :visibility)
    end
end
