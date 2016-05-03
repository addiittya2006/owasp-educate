json.array!(@pictures) do |picture|
  json.extract! picture, :id, :filename, :content_type, :data
  json.url picture_url(picture, format: :json)
end
