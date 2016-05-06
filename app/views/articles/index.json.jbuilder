json.array!(@articles) do |article|
  json.extract! article, :id, :title, :text, :category
  json.url article_url(article, format: :json)
end
