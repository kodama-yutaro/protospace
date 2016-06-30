class TagsController < ApplicationController
  def index
    @tags = ActsAsTaggableOn::Tag.most_used
  end

  def show
    @tag = ActsAsTaggableOn::Tag.find_by(name: params[:id])
    @products = Product.tagged_with(@tag.name).includes([:user, :tags])
  end
end
