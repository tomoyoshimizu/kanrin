class Public::BookmarksController < ApplicationController
  before_action :authenticate_user!

  def create
    @project = Project.find(params[:project_id])
    current_user.bookmarks.create(project_id: @project.id)
    render "replace_btn"
  end

  def destroy
    @project = Project.find(params[:project_id])
    current_user.bookmarks.find_by(project_id: @project.id).destroy
    render "replace_btn"
  end
end
