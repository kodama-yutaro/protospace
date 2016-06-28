class Products::PopularController < ProductsController
  def index
    @products = Product.order(likes_count: :DESC).includes(:user)
    render :index
  end
end
