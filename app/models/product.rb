class Product < ActiveRecord::Base
  belongs_to :user
  has_many   :product_images
  has_many   :likes, dependent: :destroy
  accepts_nested_attributes_for :product_images

  def like_user(user)
    likes.find_by(user_id: user.id)
  end

end
