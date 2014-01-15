class VideosController < ApplicationController
  before_action :require_user

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
    @review = Review.new
  end

  def search
    @videos = Video.search_by_title(params[:search_term])
  end

end
