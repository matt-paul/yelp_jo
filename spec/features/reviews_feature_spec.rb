require 'rails_helper'

feature 'reviews' do

  before { Restaurant.create name: 'KFC' }
  scenario 'allow user to leave a review' do
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in "Thoughts", with: "so so"
    select '3', from: 'Rating'
    click_button 'Leave review'
    expect(current_path).to eq '/restaurants'
    expect(page).to have_content('so so')
  end

end
