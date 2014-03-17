module ApplicationHelper

  def image_src(filename)
    unless filename.nil?
      asset_path("covers/#{filename}")
    else
      asset_path('no-image.jpg')
    end
  end

  def bootstrap_class(flash_type)
    { success: 'alert-success',
      notice: 'alert-info',
      alert: 'alert-warning',
      error: 'alert-danger' }[flash_type.to_sym] || 'alert-warning'
  end

  def options_for_video_rating(selected=nil)
    options_for_select([5,4,3,2,1].map { |i| [pluralize(i,'Star'), i] }, selected)
  end

  def options_for_category(selected=nil)
    options_for_select(Category.all.map {|c| [c.name, c.id]}, selected)
  end

  def gravatar(email)
    image_tag("http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.downcase)}?s=40")
  end
end
