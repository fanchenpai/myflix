class ReviewsController < AuthenticatedController

  def create
    @video = Video.find(params[:video_id])
    @review = @video.reviews.new(review_params)
    @review.user = current_user
    if @review.save
      flash[:notice] = "Your review has been submitted. Thank you."
      redirect_to video_path(@video)
    else
      @video.reviews.reload
      render 'videos/show'
    end

  end

  private

  def review_params
    params.require(:review).permit(:rating,:title,:detail)
  end

end
