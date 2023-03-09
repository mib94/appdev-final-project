class Movie < ApplicationRecord
  has_many :comments
  has_many :reviews

  scope :discover, -> { joins(:reviews).distinct }

  def average_rating
    return reviews.sum(:rating) / reviews.count if reviews.present?

    0
  end
end
