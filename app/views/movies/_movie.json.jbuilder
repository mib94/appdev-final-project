json.extract! movie, :id, :title, :description, :created_at, :updated_at, :average_rating
json.url movie_url(movie, format: :json)
json.comments do
  json.array! movie.comments, partial: "comments/comment", as: :comment
end
json.reviews do
  json.array! movie.reviews, partial: "reviews/review", as: :review
end
json.favorited current_user.favorites.find_by_movie_id(movie.id).present?
json.rated current_user.reviews.find_by_movie_id(movie.id).present?
