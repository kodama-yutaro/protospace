== README

## products table  

### association  

* product belongs_to :user  
* product has_many   :comments  
* product has_many   :product_images  
* product has_many   :likes  

### column  

* t.integer :id  
* t.references :user_id  
* t.string :title  
* t.text :text  
* t.text :concept  
* t.text :catch_copy  
* t.timestamps  

## users table  

### association  

* user has_many :products  
* user has_many :comments  
* user has_many :likes   

### column  

* t.integer :id  
* t.string :avatar 
* t.string :nickname  
* t.string :title  
* t.text :profile  
* t.text :work  
* t.timestamps  

## comments table  

### association  

* comment belongs_to :user  
* comment belongs_to :product  

### column  

* t.integer :id  
* t.references :user_id  
* t.references :product_id  
* t.text :text  
* t.timestamps  

## product_images table  

### association  

* product_image belongs_to :product  

### column  

* t.integer :id  
* t.text :image  
* t.integer :status  
* t.references :product_id  
* t.timestamps  

## likes table  
  
### association  
* like belongs_to :user  
* like belongs_to :product  

### column  
* t.integer :id  
* t.references :user_id  
* t.references :product_id  
* t.timestamps  





