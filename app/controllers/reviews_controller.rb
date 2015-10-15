class ReviewsController < ApplicationController

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new
  end

  def create
    Restaurant.find(params[:restaurant_id]).create_review(review_params,current_user)
    redirect_to restaurants_path
  end

  def review_params
    params.require(:review).permit(:thoughts, :rating)
  end

  def destroy
    review = Review.find(params[:id])
    if current_user == review.user
      review.destroy
      flash[:notice] = 'Review deleted successfully'
    end
    redirect_to restaurants_path
  end

end
