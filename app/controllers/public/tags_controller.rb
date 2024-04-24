class Public::TagsController < ApplicationController
  before_action :get_tag_matched_id

  def index
    @search_word = params[:search_word] || ""
    scoped_tags = @search_word.present? ? Tag.searched_with(@search_word).usage : Tag.usage
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
        if @tag.nil?
          redirect_to tags_path
        end
      end
    end
end
