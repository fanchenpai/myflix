class VideosController < ApplicationController
  def index
    @videos = Video.all
    @categories = Category.all
  end

  def index_by_category
    @category = Category.find(params[:id])
    render :genre
  end

  def show
    @video = Video.find(params[:id])
  end

end