Fabricator(:user) do
  full_name Faker::Name::name
  email { sequence(:email) { |i| "#{i}#{Faker::Internet::email}" } }
  password 'password'
  password_confirmation 'password'
end
