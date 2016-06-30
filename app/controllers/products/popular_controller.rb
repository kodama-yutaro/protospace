class Products::PopularController < ProductsController
  def index
    @products = Product.order(likes_count: :DESC).includes([:user, :tags])
    render :index
  end
end
