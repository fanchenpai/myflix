module ApplicationHelper

  def image_src(filename)
    unless filename.nil?
      asset_path("covers/#{filename}")
    else
      asset_path('no-image.jpg')
    end
  end

end
