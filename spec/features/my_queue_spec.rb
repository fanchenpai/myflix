require 'spec_helper'

feature 'my queue' do
  given!(:user1) { Fabricate(:user) }
  given!(:video1) { Fabricate(:video) }
  given!(:video2) { Fabricate(:video) }
  given!(:video3) { Fabricate(:video) }

  scenario 'user interact with queue items' do
    user_sign_in(user1)

    expect_add_to_queue_link(video1)

    add_to_queue_and_expect_title(video1)
    add_to_queue_and_expect_title(video2)
    add_to_queue_and_expect_title(video3)

    expect_user_page_to_have_videos(user1, [video1,video2,video3])

    expect_add_to_queue_link(video1, false)

    visit my_queue_path

    fill_in_new_position(video1, '3')
    fill_in_new_position(video2, '1')
    fill_in_new_position(video3, '2')

    select_video_rating(video1, '3')
    select_video_rating(video2, '4')
    select_video_rating(video3, '5')

    click_on('Update Instant Queue')

    expect_new_position(video1, '3')
    expect_new_position(video2, '1')
    expect_new_position(video3, '2')

    expect_video_rating(video1, '3 Stars')
    expect_video_rating(video2, '4 Stars')
    expect_video_rating(video3, '5 Stars')

  end
end

private

def fill_in_new_position(video, position)
  within("#video_#{video.id}") do
    fill_in('queue_items[][position]', with: position)
  end
end

def expect_new_position(video, position)
  within("#video_#{video.id}") do
    expect(find_field('queue_items[][position]').value).to eq position
  end
end

def add_to_queue_and_expect_title(video)
  visit root_path
  find("a[href='/videos/#{video.id}']").click
  click_link('+ My Queue')
  expect(page).to have_link(video.title)
end

def expect_add_to_queue_link(video, not_queued=true)
  visit video_path(video1)
  if not_queued
    expect(page).to have_link('+ My Queue')
  else
    expect(page).not_to have_link('+ My Queue')
  end
end

def select_video_rating(video, rating)
  within("#video_#{video.id}") do
    select(rating, from: 'queue_items[][rating]')
  end
end

def expect_video_rating(video, rating_text)
  within("#video_#{video.id}") do
    expect(has_select?('queue_items[][rating]', selected: rating_text)).to be_true
  end
end

def select_video_rating(video, rating)
  within("#video_#{video.id}") do
    select(rating, from: 'queue_items[][rating]')
  end
end

def expect_video_rating(video, rating_text)
  within("#video_#{video.id}") do
    expect(has_select?('queue_items[][rating]', selected: rating_text)).to be_true
  end
end

def expect_user_page_to_have_videos(user, videos)
  visit user_path(user.id)
  videos.each do |video|
    expect(page).to have_link(video.title)
  end
end
