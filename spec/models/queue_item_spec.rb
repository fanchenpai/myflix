require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }

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
end
