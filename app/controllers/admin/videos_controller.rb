class Admin::VideosController < AdminsController

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      flash[:notice] = "Video created."
      redirect_to admin_videos_path
    else
      render :new
    end
  end

  def index
    @videos = Video.all
  end

  private

  def video_params
    params.require(:video)
          .permit(:title, :category_id, :description, :large_cover, :small_cover, :video_url)
  end

end
