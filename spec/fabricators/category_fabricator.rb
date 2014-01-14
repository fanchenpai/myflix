Fabricator(:category) do
  name { sequence(:category) { |i| "#{Faker::Lorem::word}#{i}" } }
end
