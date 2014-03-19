require 'spec_helper'

feature "admin add video" do

  scenario "admin successfully adds a video" do
    admin1 = Fabricate(:admin)
    sign_in(admin1)
    click_on('Admin')


  end

end
