class CreateProductImages < ActiveRecord::Migration
  def change
    create_table :product_images do |t|
      t.text       :image
      t.integer    :status
      t.references :product
      t.timestamps
    end
  end
end
