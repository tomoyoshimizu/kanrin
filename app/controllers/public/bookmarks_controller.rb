class Public::BookmarksController < ApplicationController
  before_action :get_project_matched_id
  before_action :authenticate_user!

  def create
    current_user.bookmarks.create(project_id: @project.id)
    render "replace_btn"
  end

  def destroy
    current_user.bookmarks.find_by(project_id: @project.id).destroy
    render "replace_btn"
  end

  private
    def get_project_matched_id
      if params[:project_id]
        @project = Project.find_by(id: params[:project_id])
        if @project.nil? || !@project.user.is_active
          redirect_to projects_path
        end
      end
    end
end
