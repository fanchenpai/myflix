Fabricator(:video) do
  title Faker::Lorem::words.to_s
  description Faker::Lorem::paragraph
  category
end
