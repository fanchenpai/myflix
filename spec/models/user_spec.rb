require 'spec_helper'

describe User do
  it { should have_db_column(:id)}
  it { should have_db_column(:full_name) }
  it { should have_db_column(:email) }
  it { should have_db_column(:password_digest) }
  it { should have_many(:reviews).order('created_at DESC') }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password_digest) }
  it { should validate_presence_of(:full_name) }
  it { should have_secure_password }
  it { should ensure_length_of(:password).is_at_least(3) }
  it { should allow_value('test@test.com', 'test+it@test.com','test_it@test.com').for(:email) }
  it { should_not allow_value('aweoijf','weoij jio@test.com','eioew@test,com').for(:email) }
  it "should require unique value for email" do
    # Need to create a record first for the validation to work.
    # See: https://github.com/thoughtbot/shoulda-matchers/issues/371
    Fabricate(:user)
    should validate_uniqueness_of(:email).case_insensitive
  end

end
