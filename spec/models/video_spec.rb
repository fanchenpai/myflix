require 'spec_helper'

describe Video do

  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:category_id) }
  it { should respond_to(:category_name) }
  it { should have_many(:reviews).order('created_at DESC') }

  describe '.search_by_title' do
    let (:comedy) { Category.create(name:'Comedy')  }
    let! (:video1) { Video.create(title:'Big Bang Theory Season 1', category: comedy, created_at: 1.day.ago) }
    let! (:video2) { Video.create(title:'Big Bang Theory Season 2', category: comedy) }
    let! (:video3) { Video.create(title:'How I met your mother Season 1', category: comedy) }
    it 'returns an empty array when no videos are found with that title' do
      expect(Video.search_by_title('xyz')).to eq([])
    end
    it 'returns an array of one video when one video is found with exact title' do
      expect(Video.search_by_title(video1.title)).to eq([video1])
    end
    it 'returns an array of videos ordered by create time when several videos are found' do
      expect(Video.search_by_title('Big Bang')).to include(video1, video2)
      expect(Video.search_by_title('Big Bang')).to eq([video2, video1])
    end
    it 'returns empty array when the search term is empty' do
      expect(Video.search_by_title('')).to eq([])
      expect(Video.search_by_title(' ')).to eq([])
      expect(Video.search_by_title(nil)).to eq([])
    end
  end

  describe '#average_rating' do
    it 'returns nil if there is no reviews' do
      video1 = Fabricate(:video)
      expect(video1.average_rating).to be_nil
    end
    it 'returns average rating of a video' do
      video1 = Fabricate(:video)
      review1 = Fabricate(:review, video: video1, rating: 4)
      review2 = Fabricate(:review, video: video1, rating: 5)
      expect(video1.average_rating).to eq '4.5'
    end
  end
end
