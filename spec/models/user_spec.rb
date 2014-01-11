require 'spec_helper'

describe User do
  it { should have_db_column(:id)}
  it { should have_db_column(:full_name) }
  it { should have_db_column(:email) }
  it { should have_db_column(:password_digest) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password_digest) }
  it { should validate_presence_of(:full_name) }
  it { should have_secure_password }
  it "should require unique value for email" do
    # Need to create a record first for the validation to work.
    # See: https://github.com/thoughtbot/shoulda-matchers/issues/371
    User.create(
      full_name: "Rspec Test",
      email: "test@test.com",
      password: "test",
      password_confirmation: "test"
    )
    should validate_uniqueness_of(:email).case_insensitive
  end
end