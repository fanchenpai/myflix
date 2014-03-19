# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

comedy = Category.create(name: 'Comedy')
drama = Category.create(name: 'Drama')
family = Category.create(name: 'Kids & Family')
action = Category.create(name: 'Action')
romance = Category.create(name: 'Romance')

Category.all.each do |c|
  7.times { Fabricate(:video, category: c) }
end

user1 = User.create(full_name: 'Alice Wonderland', email:'alice@test.com',password:'password', password_confirmation:'password')
user2 = User.create(full_name: 'Bob Doe', email: 'bob@test.com', password:'password',password_confirmation:'password')
user3 = Fabricate(:user)
user4 = Fabricate(:user)

Video.first(7).each do |v|
  Fabricate(:review, user: user2, video: v)
  Fabricate(:review, user: user3, video: v)
end

Category.all.each do |c|
  Fabricate(:review, user: user1, video: c.videos.first) unless c.videos.nil?
  Fabricate(:review, user: user4, video: c.videos.last) unless c.videos.nil?
end
