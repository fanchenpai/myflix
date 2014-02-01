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

    expect_add_to_queue_link(video1, false)

    visit my_queue_path
    save_and_open_page
  end
end

private

def add_to_queue_and_expect_title(video)
  visit video_path(video)
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
