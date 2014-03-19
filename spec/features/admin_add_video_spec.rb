require 'spec_helper'

feature 'admin add video' do
  let!(:action) { Fabricate(:category, name: 'Action') }
  let!(:drama) { Fabricate(:category, name: 'Comedy') }
  let!(:admin1) { Fabricate(:admin) }
  let!(:user1) { Fabricate(:user) }

  scenario 'admin successfully adds a video' do
    sign_in(admin1)
    visit new_admin_video_path
    fill_in 'Title', with: 'Big Bang Theory'
    select 'Comedy', from: 'Category'
    fill_in 'Description', with: 'A show full of a bunch of nerds!'
    attach_file 'Large cover', 'spec/support/uploads/big_bang_theory_large.jpg'
    attach_file 'Small cover', 'spec/support/uploads/big_bang_theory_small.jpg'
    fill_in'Video URL', with: 'http://myflix.com/big_bang_theory.mp4'
    click_on 'Add Video'
    expect(page).to have_content 'Big Bang Theory'
    expect(page).to have_content 'Comedy'
    link = page.find_link('Play')
    expect(link[:href]).to eq 'http://myflix.com/big_bang_theory.mp4'
    sign_out

    sign_in(user1)
    video = Video.first
    expect(page).to have_content 'Big Bang Theory'
    expect(page).to have_selector "img[src='/uploads/video/small_cover/#{video.id}/big_bang_theory_small.jpg']"
    visit video_path(video)
    expect(page).to have_selector "img[src='/uploads/video/large_cover/#{video.id}/big_bang_theory_large.jpg']"
    expect(page).to have_selector "a[href='http://myflix.com/big_bang_theory.mp4']"
  end

end
