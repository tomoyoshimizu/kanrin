class Public::TagsController < ApplicationController
  before_action :get_tag_matched_id

  def index
    @search_word = params[:search_word] || ""
    scoped_tags = @search_word.present? ? Tag.search(@search_word) : Tag.all
    @tags = Tag.usage(scoped_tags)
    @count = @tags.count
  end

  def show
    @projects = @tag.projects.visible.valid.desc
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
