class User < ActiveRecord::Base
	has_many :products
	has_many :comments
	has_many :likes
end
