class Product < ActiveRecord::Base
  belongs_to :user
  has_many   :product_images, dependent: :destroy
  has_many   :likes, dependent: :destroy
  has_many   :comments, dependent: :destroy
  accepts_nested_attributes_for :product_images
  acts_as_taggable
  validates :title, :catch_copy, :concept, :created_at, presence: true

  def like_user(user)
    likes.find_by(user_id: user.id)
  end

end
