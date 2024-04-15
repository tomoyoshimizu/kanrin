class Public::TagsController < ApplicationController
  before_action :get_tag_matched_id

  def index
    @search_word = params[:search_word] || ""
    @tags = @search_word.present? ? Tag.search(@search_word) : Tag.all
    @count = @tags.count
  end

  def show
    @projects = tag_matched_id.projects.visible.valid.desc
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
