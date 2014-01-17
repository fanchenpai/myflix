Fabricator(:review) do
  user
  video
  rating { [1,2,3,4,5].sample }
  title { Faker::Lorem::words(5).join(' ') }
  detail { Faker::Lorem::paragraph(10) }
end
