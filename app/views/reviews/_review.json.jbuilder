json.extract! review, :id, :user_id, :movie_id, :rating, :text, :created_at, :updated_at
json.url review_url(review, format: :json)
json.user do
  json.user_id review.user.id
  json.username review.user.username
end
