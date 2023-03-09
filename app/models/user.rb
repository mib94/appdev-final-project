class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  acts_as_token_authenticatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :comments, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_movies, through: :favorites, class_name: "Movie", source: :movie
  has_many :sent_follow_requests, foreign_key: :sender_id, class_name: "FollowRequest", dependent: :destroy
  has_many :accepted_sent_follow_requests, -> { accepted }, foreign_key: :sender_id, class_name: "FollowRequest"
  has_many :received_follow_requests, foreign_key: :recipient_id, class_name: "FollowRequest", dependent: :destroy
  has_many :accepted_received_follow_requests, -> { accepted }, foreign_key: :recipient_id, class_name: "FollowRequest"
  has_many :pending_received_follow_requests, -> { pending }, foreign_key: :recipient_id, class_name: "FollowRequest"
  has_many :leaders, through: :accepted_sent_follow_requests, source: :recipient
  has_many :own_movies, through: :reviews, class_name: "Movie", source: :movie
  has_many :discover, -> { distinct }, through: :leaders, source: :own_movies
  has_many :feed, -> { distinct }, through: :leaders, source: :own_movies
  has_many :followers, through: :accepted_received_follow_requests, source: :sender
  has_many :pending, through: :pending_received_follow_requests, source: :sender

  validates :username,
    presence: true,
    uniqueness: true,
    format: {
      with: /\A[\w_\.]+\z/i,
      message: "can only contain letters, numbers, periods, and underscores"
    }
end
