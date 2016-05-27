class Product < ActiveRecord::Base
	belongs_to :user
	has_many   :comments
	has_many   :product_images
	has_many   :likes
end
