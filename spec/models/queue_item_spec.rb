require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  #it { should validate_uniqueness_of(:position).scoped_to(:user_id) }

  describe '#video_title' do
    it 'returns title of the associated video' do
      video1 = Fabricate(:video, title: 'test video title')
      queue_item1 = Fabricate(:queue_item, video: video1)
      expect(queue_item1.video_title).to eq 'test video title'
    end
  end

  describe '#category_name' do
    it 'returns category name of the associated video' do
      category1 = Fabricate(:category, name: 'Drama')
      video1 = Fabricate(:video, category: category1)
      queue_item1 = Fabricate(:queue_item, video: video1)
      expect(queue_item1.category_name).to eq 'Drama'
    end
  end

  describe '#category' do
    it 'returns the category object of the associated video' do
      category1 = Fabricate(:category)
      video1 = Fabricate(:video, category: category1)
      queue_item1 = Fabricate(:queue_item, video: video1)
      expect(queue_item1.category).to eq category1
    end
  end

  describe '#rating' do
    let (:video1) { Fabricate(:video) }
    let (:user1) { Fabricate(:user) }
    let (:queue_item1) { Fabricate(:queue_item, video: video1, user: user1) }
    it 'returns the user given rating of the associated video' do
      review1 = Fabricate(:review, user: user1, video: video1, rating: 3)
      expect(queue_item1.rating).to eq 3
    end
    it 'returns nil if no reviews were found for the given user id' do
      expect(queue_item1.rating).to be_nil
    end
  end

  describe '.update_position' do
    let! (:user1) { Fabricate(:user) }
    let! (:item1) { Fabricate(:queue_item, user: user1, position: 1) }
    let! (:item2) { Fabricate(:queue_item, user: user1, position: 2) }
    it 'updates position of the queue item' do
      QueueItem.update_position(item1.id, 5)
      expect(item1.reload.position).to eq 5
    end
    it 'does not do anything if no queue item can be found by the id' do
      expect { QueueItem.update_position(999, 5) }.to raise_error(ActiveRecord::RecordNotFound)
    end
    # it 'does not update the position if that particular position number is taken' do
    #   QueueItem.update_position(item1.id, item2.position)
    #   expect(item1.reload.position).to eq 1
    # end
    # it 'returns false if update failed' do
    #   expect(QueueItem.update_position(item1.id, item2.position)).to be false
    # end
  end
end
