class Public::TagsController < ApplicationController
  def search
  end

  def index
  end

  def show
    @projects = tag_matched_id.projects
  end

  private
    def tag_matched_id
      Tag.find(params[:id])
    end
end
