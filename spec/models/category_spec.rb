require 'spec_helper'

describe Category do

  it { should have_many(:videos).order('title') }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).case_insensitive }

end