class ProductsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]

  expose(:category)
  expose(:products)
  expose(:product)
  expose(:review) { Review.new }
  expose_decorated(:reviews, ancestor: :product)

  def index
  end

  def show
  end

  def new
  end

  def edit
        if self.product.user != current_user
          redirect_to category_product_url(category, product)
          flash[:error] = "You are not allowed to edit this product."
        end
  end

  def create
    self.product = Product.new(product_params)
    self.product.user = current_user

    if product.save
      category.products << product
      redirect_to category_product_url(category, product), notice: 'Product was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if self.product.user == current_user
      if self.product.update(product_params)
        redirect_to category_product_url(category, product), notice: 'Product was successfully updated.'
      else
        render action: 'edit'
      end
    else
       redirect_to category_product_url(category, product)
       flash[:error] = "You are not allowed to edit this product."
    end
  end

  # DELETE /products/1
  def destroy
    product.destroy
    redirect_to category_url(product.category), notice: 'Product was successfully destroyed.'
  end

  private
    def product_params
      params.require(:product).permit(:title, :description, :price, :breed, :gender, :YoB, :color, :height, :category_id, :picture)
    end
end
