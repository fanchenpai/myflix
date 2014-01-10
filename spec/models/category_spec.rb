require 'spec_helper'

describe Category do

  it { should have_many(:videos).order('title') }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).case_insensitive }

  describe '#recent_videos' do
    let (:comedy) { Category.create(name: 'Comedy')}
    let (:drama) { Category.create(name: 'Drama') }
    let (:family) { Category.create(name: 'Family')}
    let! (:video1) { Video.create(title: 'Video 1', category: comedy, created_at: 7.day.ago) }
    let! (:video2) { Video.create(title: 'Video 2', category: comedy, created_at: 6.day.ago) }
    let! (:video3) { Video.create(title: 'Video 3', category: comedy, created_at: 5.day.ago) }
    let! (:video4) { Video.create(title: 'Video 4', category: comedy, created_at: 4.day.ago) }
    let! (:video5) { Video.create(title: 'Video 5', category: comedy, created_at: 3.day.ago) }
    let! (:video6) { Video.create(title: 'Video 6', category: comedy, created_at: 2.day.ago) }
    let! (:video7) { Video.create(title: 'Video 7', category: comedy, created_at: 1.day.ago) }
    let! (:video8) { Video.create(title: 'Video 8', category: family, created_at: 2.day.ago)}
    let! (:video9) { Video.create(title: 'Video 9', category: family, created_at: 3.day.ago)}
    let! (:video10) { Video.create(title: 'Video 10', category: family, created_at: 1.day.ago)}
    it 'should return an empty array if a category has no videos' do
      expect(drama.recent_videos).to eq([])
    end
    it 'should return all the videos if there are less than 6 videos' do
      expect(family.recent_videos).to include(video8,video9,video10)
      expect(family.recent_videos.size).to eq(3)
    end
    it 'should return no more than 6 videos in result' do
      expect(comedy.recent_videos.size).to be <= 6

    end
    it 'should return videos in a category in reverse chronological order' do
      expect(comedy.recent_videos).to eq([video7,video6,video5,video4,video3,video2])
      expect(family.recent_videos).to eq([video10,video8,video9])
    end


  end

end