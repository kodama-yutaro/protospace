class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string     :title
      t.references :user
      t.text       :concept
      t.text       :catch_copy
      t.timestamps
    end
  end
end
