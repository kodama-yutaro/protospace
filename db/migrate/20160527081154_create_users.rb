class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string     :avatar
      t.string     :nickname
      t.string     :title
      t.text       :profile
      t.text       :work
      t.timestamps
    end
  end
end
