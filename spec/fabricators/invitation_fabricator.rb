Fabricator(:invitation) do
  full_name { Faker::Name::name }
  email { Faker::Internet::email }
  message { Faker::Lorem::paragraph(1) }
  user
end
