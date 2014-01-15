Fabricator(:review) do
  user
  video
  rating 5
  title Faker::Lorem::words(5).join(' ')
  detail Faker::Lorem::paragraph(10)
end
