json.array!(@features) do |feature|
  json.extract! feature, :id, :name, :count
  json.url feature_url(feature, format: :json)
end
