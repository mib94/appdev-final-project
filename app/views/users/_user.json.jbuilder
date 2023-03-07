json.extract! user, :id, :email, :username, :bio, :created_at, :updated_at
json.url user_url(user, format: :json)
json.favorited_movies do
  json.array! user.favorited_movies, partial: "movies/movie", as: :movie
end
