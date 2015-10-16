require 'rails_helper'

feature 'reviews' do

  context 'creating reviews for restaurant' do

    scenario 'User who created the restaurant can review it' do
      user = create(:user)
      sign_in(user)
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      visit '/restaurants'
      click_link 'Review KFC'
      fill_in "Thoughts", with: "unhealthy"
      select '3', from: 'Rating'
      click_button 'Leave review'
      expect(current_path).to eq('/restaurants')
      expect(page).to have_content('unhealthy')
    end

    scenario 'Other users review any Restaurant' do
      user = create(:user)
      sign_in(user)
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      click_link 'Sign out'
      user2 = User.create(email: 'benny@example.com', password: '12344321', password_confirmation: '12344321')
      sign_in(user2)
      visit '/restaurants'
      click_link 'Review KFC'
      fill_in "Thoughts", with: "unhealthy"
      select '3', from: 'Rating'
      click_button 'Leave review'
      expect(current_path).to eq('/restaurants')
      expect(page).to have_content('unhealthy')
    end

    scenario 'A user can only review a restaurant once' do
      user = create(:user)
      sign_in(user)
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      click_link 'Review KFC'
      fill_in "Thoughts", with: "unhealthy"
      select '3', from: 'Rating'
      click_button 'Leave review'
      expect(page).not_to have_content('Review KFC')
    end

    scenario 'User who created the review can delete it' do
      user = create(:user)
      sign_in(user)
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      visit '/restaurants'
      click_link 'Review KFC'
      fill_in "Thoughts", with: "unhealthy"
      select '3', from: 'Rating'
      click_button 'Leave review'
      expect(page).to have_content('Delete review')
    end

    scenario 'User who did not created the review cannot delete it' do
      user = create(:user)
      sign_in(user)
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      visit '/restaurants'
      click_link 'Review KFC'
      fill_in "Thoughts", with: "unhealthy"
      select '3', from: 'Rating'
      click_button 'Leave review'
      click_link 'Sign out'
      user2 = User.create(email: 'benny@example.com', password: '12344321', password_confirmation: '12344321')
      sign_in(user2)
      visit '/restaurants'
      expect(page).not_to have_content('Delete review')
    end

    scenario 'displays an average rating for all reviews' do
      user = create(:user)
      sign_in(user)
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      visit '/restaurants'
      click_link 'Review KFC'
      fill_in "Thoughts", with: "unhealthy"
      select '3', from: 'Rating'
      click_button 'Leave review'
      click_link 'Sign out'
      user2 = User.create(email: 'benny@example.com',password: '12344321',password_confirmation: '12344321')
      sign_in(user2)
      visit '/restaurants'
      click_link 'Review KFC'
      fill_in "Thoughts", with: "yuck"
      select '1', from: 'Rating'
      click_button 'Leave review'
      expect(current_path).to eq('/restaurants')
      expect(page).to have_content('Average rating: 2')
    end
  end

end
