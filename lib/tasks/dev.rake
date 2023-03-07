desc "Fill the database tables with some sample data"
task sample_data: :environment do
  starting = Time.now

  FollowRequest.delete_all
  Favorite.delete_all
  Comment.delete_all
  Movie.delete_all
  Review.delete_all
  User.delete_all

  people = Array.new(10) do
    {
      first_name: Faker::Name.first_name,
    }
  end

  movies = Array.new(100) do
    {
      title: Faker::Movie.title,
      description: Faker::Lorem.paragraph(sentence_count: 5)
    }
  end

  people << { first_name: "Alice" }
  people << { first_name: "Bob" }
  people << { first_name: "Carol" }
  people << { first_name: "Doug" }

  ## Create Users
  people.each do |person|
    username = person.fetch(:first_name).downcase

    user = User.create(
      email: "#{username}@example.com",
      password: "password",
      username: username.downcase,
      bio: Faker::Lorem.paragraph(
        sentence_count: 2,
        supplemental: true,
        random_sentences_to_add: 4
      )
    )

    p user.errors.full_messages
  end

  ## Create Movies
  movies.each do |movie_params|
    movie = Movie.create(movie_params)

    p movie.errors.full_messages
  end

  users = User.all
  movies = Movie.all

  ## Create FollowRequests
  users.each do |first_user|
    users.each do |second_user|
      if rand < 0.75
        first_user_follow_request = first_user.sent_follow_requests.create(
          recipient: second_user,
          status: FollowRequest.statuses.values.sample
        )

        p first_user_follow_request.errors.full_messages
      end

      if rand < 0.75
        second_user_follow_request = second_user.sent_follow_requests.create(
          recipient: first_user,
          status: FollowRequest.statuses.values.sample
        )

        p second_user_follow_request.errors.full_messages
      end
    end
  end

  ## Create Reviews for movies against multiple random users and creates favorite for random users

  movies.each do |movie|
    users.sample(rand(10..20)).each do |user|
      if rand < 0.5
        fav = user.favorites.create(movie: movie)
        p fav.errors.full_messages
      end
      review = user.reviews.create(rating: rand(1..5), text: Faker::Lorem.paragraph(sentence_count: 2), movie: movie)

      p review.errors.full_messages
    end
  end

  ending = Time.now
  p "It took #{(ending - starting).to_i} seconds to create sample data."
  p "There are now #{User.count} users."
  p "There are now #{FollowRequest.count} follow requests."
  p "There are now #{Movie.count} movies."
  p "There are now #{Favorite.count} favorites."
  p "There are now #{Review.count} reviews."
end
