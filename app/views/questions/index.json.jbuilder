json.array!(@questions) do |question|
  json.extract! question, :id, :title, :description, :upvotes
  json.url question_url(question, format: :json)
end
