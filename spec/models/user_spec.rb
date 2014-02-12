require 'spec_helper'

describe User do
  it { should have_db_column(:id)}
  it { should have_db_column(:full_name) }
  it { should have_db_column(:email) }
  it { should have_db_column(:password_digest) }
  it { should have_many(:reviews).order('created_at DESC') }
  it { should have_many(:queue_items).order('position') }
  it { should have_many(:followerships) }
  it { should have_many(:followers).order('created_at DESC').through(:followerships) }
  it { should have_many(:leaderships).class_name('Followership') }
  it { should have_many(:leaders).order('created_at DESC').through(:leaderships) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password_digest) }
  it { should validate_presence_of(:full_name) }
  it { should have_secure_password }
  it { should ensure_length_of(:password).is_at_least(3) }
  it "should require unique value for email" do
    # Need to create a record first for the validation to work.
    # See: https://github.com/thoughtbot/shoulda-matchers/issues/371
    Fabricate(:user)
    should validate_uniqueness_of(:email).case_insensitive
  end

  describe '#update_queue_item' do
    let (:user1) { Fabricate(:user) }
    let (:item1) { Fabricate(:queue_item, user: user1, position: 3) }

    it 'updates queue items position' do
      user1.update_queue_item(item1.id, 1)
      expect(QueueItem.first.position).to eq 1
    end
    it 'updates rating if a review exists' do
      review1 = Fabricate(:review, user: user1, video: item1.video, rating: 3)
      user1.update_queue_item(item1.id, 1, 5)
      expect(QueueItem.first.rating).to eq 5
    end
    it 'creates a review if new rating is passed in and no review exists yet' do
      user1.update_queue_item(item1.id, 1, 5)
      expect(Review.count).to eq 1
    end
    it 'raises error when a user try to update a queue item that is not in her/his queue' do
      item2 = Fabricate(:queue_item)
      expect{ user1.update_queue_item(item2.id, 1, 5) }.to raise_error
    end
  end

  describe '#queued_video?' do
    let (:user1) { Fabricate(:user) }
    it 'return true if video is already queued' do
      video1 =  Fabricate(:video)
      Fabricate(:queue_item, user: user1, video: video1)
      expect(user1.queued_video?(video1)).to be_true
    end
    it 'return false if video is not yet queued' do
      video2 = Fabricate(:video)
      expect(user1.queued_video?(video2)).to be_false
    end
  end

end
