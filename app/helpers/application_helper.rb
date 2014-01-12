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

end
