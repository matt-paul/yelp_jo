require 'rails_helper'

feature 'restaurants' do

  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      user = create(:user)
      sign_in(user)
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurants have been added' do
    scenario 'display restaurants' do
      user = create(:user)
      sign_in(user)
      user.restaurants.create(name: 'KFC')
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do

    scenario 'does not allow restaurant to be created if not logged in' do
      visit '/restaurants'
      expect(page).not_to have_content 'Add a restaurant'
      expect(page).to have_content "Please sign in to add a restaurant"
    end

    scenario 'prompts user to fill out a form, then displays the new restaurant' do
      visit '/restaurants'
      user = create(:user)
      sign_in(user)
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq '/restaurants'
      expect(user.restaurants.first.name).to eq 'KFC'
    end

    scenario 'does not allow you to submit a name that is too short' do
      visit '/restaurants'
      user = create(:user)
      sign_in(user)
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'kf'
      click_button 'Create Restaurant'
      expect(page).not_to have_content 'kf'
      expect(page).to have_content 'Name is too short (minimum is 3 characters)'
    end
  end

  context 'viewing restaurants' do
    scenario 'lets a user view a restaurant' do
      user = create(:user)
      sign_in(user)
      user.restaurants.create(name: 'KFC')
      kfc = user.restaurants.first
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq "/restaurants/#{kfc.id}"
    end
  end

  context 'editing restaurants' do
    scenario "restaurant creator can edit the restaurant" do
     user = create(:user)
     sign_in(user)
     click_link 'Add a restaurant'
     fill_in 'Name', with: 'KFC'
     click_button 'Create Restaurant'
     click_link 'Edit KFC'
     fill_in 'Name', with: 'Kentucky Fried Chicken'
     click_button 'Update Restaurant'
     expect(page).to have_content 'Kentucky Fried Chicken'
     expect(current_path).to eq '/restaurants'
    end

    scenario "non restaurant creator can't edit the restaurant" do
      user = create(:user)
      sign_in(user)
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      click_link 'Sign out'
      user2 = User.create(email: 'benny@example.com', password: '12344321', password_confirmation: '12344321')
      sign_in(user2)
      visit '/restaurants'
      expect(page).not_to have_content('Edit KFC')
    end
  end

  context 'deleting restaurants' do
    scenario 'restaurant creator can delete the restaurant' do
      user = create(:user)
      sign_in(user)
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end

    scenario 'non restaurant creator cannot delete the restaurant' do
      user = create(:user)
      sign_in(user)
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      click_link 'Sign out'
      user2 = User.create(email: 'benny@example.com', password: '12344321', password_confirmation: '12344321')
      sign_in(user2)
      visit '/restaurants'
      expect(page).not_to have_content 'Delete KFC'
    end
  end

end
