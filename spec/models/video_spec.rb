require 'spec_helper'

describe Video do

  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:category_id) }
  it { should respond_to(:category_name) }

  describe '#self.search_by_title' do
    let (:comedy) { Category.create(name:'Comedy')  }
    let! (:video1) { Video.create(title:'Big Bang Theory Season 1', category: comedy) }
    let! (:video2) { Video.create(title:'Big Bang Theory Season 2', category: comedy)}
    it 'returns an empty array when no videos are found with that title' do
      expect(Video.search_by_title('xyz')).to eq([])
    end
    it 'returns a video in array when one video is found' do
      expect(Video.search_by_title(video1.title)).to eq([video1])
    end
    it 'returns several videos in array when several videos are found' do
      expect(Video.search_by_title('Big Bang')).to include(video1, video2)
    end
  end
end