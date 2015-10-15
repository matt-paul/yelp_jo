class Restaurant < ActiveRecord::Base
  belongs_to :user
  has_many :reviews, dependent: :destroy
  validates :name, length: {minimum: 3}, uniqueness: true

  def create_review(params,user)
    self.reviews.create(thoughts: params["thoughts"], rating: params["rating"], user_id: user.id)
  end

end
