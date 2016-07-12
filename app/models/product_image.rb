class ProductImage < ActiveRecord::Base
  belongs_to :product
  mount_uploader :image, ImageUploader
  enum status: %i(main sub)
  validates :image, :status, presence: true
end
