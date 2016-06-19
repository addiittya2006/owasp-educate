json.array!(@articles) do |article|
  json.extract! article, :id, :title, :text, :category, :pictures, :tags
  json.url article_url(article, format: :json)
end
