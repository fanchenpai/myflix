require 'spec_helper'

describe VideoDecorator do
  describe '#rating' do
    it "returns N/A when no ratings available" do
      video1 = Fabricate(:video)
      expect(video1.decorate.rating).to eq "N/A"
    end
    it "returns average rating when there are ratings present" do
      video1 = Fabricate(:video)
      review1 = Fabricate(:review, video: video1, rating: 4)
      review2 = Fabricate(:review, video: video1, rating: 5)
      expect(video1.decorate.rating).to eq '4.5/5.0'
    end
  end

end
