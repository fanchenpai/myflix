Fabricator(:queue_item) do
  video
  user
  position { [1,2,3].sample }
end
