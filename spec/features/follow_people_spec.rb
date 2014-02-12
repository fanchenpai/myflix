require 'spec_helper'

feature 'user can follow other people' do
  given!(:current_user) { Fabricate(:user) }
  given!(:leader) { Fabricate(:user) }
  given!(:review1) { Fabricate(:review, user: leader)}

  scenario 'follow and unfollow' do

    user_sign_in(current_user)
    locate_and_click_user_page_link
    expect_follow_link
    click_link('Follow')
    expect_follow_link(false)
    click_link('People')
    expect_leader_link
    expect_follower_count
    unfollow
    expect_leader_link(false)
    expect_not_able_to_follow_self

  end

  private

  def locate_and_click_user_page_link
    visit video_path(review1.video.id)
    find("a[href='/users/#{leader.id}']").click
  end

  def expect_follow_link(can_follow=true)
    if can_follow
      expect(page).to have_link('Follow')
    else
      expect(page).not_to have_link('Follow')
    end
  end

  def expect_leader_link(following=true)
    if following
      expect(page).to have_link(leader.full_name)
    else
      expect(page).not_to have_link(leader.full_name)
    end
  end

  def expect_follower_count
    within("#leader_#{leader.id}") do
      expect(find('td.followers').text).to eq '1'
    end
  end

  def unfollow
    within("#leader_#{leader.id}") do
      find(:xpath, "//td/a[@class='unfollow']").click
    end
  end

  def expect_not_able_to_follow_self
    visit user_path(current_user.id)
    expect(page).not_to have_link('Follow')
  end
end
