class RestaurantsController < ApplicationController

  before_action :authenticate_user!, :except => [:index, :show]

  def index
    @restaurants = Restaurant.all
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    # @restaurant = Restaurant.new(restaurant_params)
    # @restaurant.user_id = current_user.id
    # if @restaurant.save
    #   redirect_to restaurants_path
    # else
    #   render :new
    # end

    @restaurant = current_user.restaurants.new(restaurant_params)
    if @restaurant.save
      redirect_to restaurants_path
    else
      render :new
    end

  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
  end

  def update
    Restaurant.find(params[:id]).update(restaurant_params)
    redirect_to '/restaurants'
  end

  def destroy
    if current_user == Restaurant.find(params[:id]).user
      Restaurant.find(params[:id]).destroy
      flash[:notice] = 'Restaurant deleted successfully'
      redirect_to '/restaurants'
    else
      redirect_to '/restaurants'
    end
  end

  def restaurant_params
    params.require(:restaurant).permit(:name)
  end

end
