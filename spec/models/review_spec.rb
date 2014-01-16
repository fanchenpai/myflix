require 'spec_helper'

describe Review do
  it { should belong_to :user }
  it { should belong_to :video }
  it { should validate_presence_of :rating }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :video_id }
  it { should validate_presence_of :detail }
  it 'should require case sensitive unique value for video_id scoped to user_id' do
    Fabricate(:review)
    should validate_uniqueness_of(:user_id).scoped_to(:video_id)
  end


end
