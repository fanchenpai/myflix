Fabricator(:queue_item) do
  video
  position { [1,2,3].sample }
end
