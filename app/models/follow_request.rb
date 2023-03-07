class FollowRequest < ApplicationRecord
  belongs_to :recipient, class_name: "User"
  belongs_to :sender, class_name: "User"
  validates :recipient_id, uniqueness: { scope: :sender_id, message: "already requested" }
  validate :users_cant_follow_themselves

  enum status: { pending: "pending", rejected: "rejected", accepted: "accepted" }

  def users_cant_follow_themselves
    if sender_id == recipient_id
      errors.add(:sender_id, "can't follow themselves")
    end
  end
end
