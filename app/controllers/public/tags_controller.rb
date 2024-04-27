class Public::TagsController < ApplicationController
  before_action :get_tag_matched_id

  def index
    @search_word = params[:search_word] || ""
    scoped_tags = Tag.usage
    scoped_tags = scoped_tags.searched_with(@search_word) if @search_word.present?
    @tags = scoped_tags.page(params[:page])
    @count = scoped_tags.length
  end

  def show
    scoped_projects = @tag.projects.visible.valid.desc
    @projects = scoped_projects.page(params[:page])
    @count = scoped_projects.count
  end

  private
    def get_tag_matched_id
      if params[:id]
        @tag = Tag.find(params[:id])
        redirect_to tags_path if @tag.nil?
      end
    end
end
