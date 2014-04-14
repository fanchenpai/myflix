class VideoDecorator < Draper::Decorator
  delegate_all

  def rating
    if object.reviews.any?
      "#{object.average_rating}/5.0"
    else
      "N/A"
    end
  end
end
