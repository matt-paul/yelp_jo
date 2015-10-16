class Restaurant < ActiveRecord::Base
  belongs_to :user
  has_many :reviews, dependent: :destroy
  validates :name, length: {minimum: 3}, uniqueness: true

  def user_review_on_restaurant(user)
    self.reviews.each do |review|
      return review if review.user_id == user.id
    end
    return nil
  end

  def create_review(params,user)
    self.reviews.create(thoughts: params["thoughts"], rating: params["rating"], user_id: user.id)
  end

  def average_rating
    #return "N/A" if self.reviews.length == 0
    return "N/A" if !self.reviews
    sum_of_reviews = 0
    self.reviews.each do |review|
      sum_of_reviews += review.rating
    end
    return sum_of_reviews / self.reviews.length
  end
end

# restaurant.user_review_on_restaurant(user)
