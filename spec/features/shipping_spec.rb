require "spec_helper"

describe "the shipping process", :type => :feature do
  before :each do
    u1 = User.create!(
      name: 'User', 
      email: 'user@example.com',
      password: '123password',
      password_confirmation: '123password',
      balance: 18.20
    )

    u2 = User.create!(
      name: 'Moderator', 
      email: 'moderator@example.com',
      password: '123password',
      password_confirmation: '123password',
      balance: 58.20,
      role: 1
    )

    u1.auctions.create!(name: 'MacBook', finish_at: DateTime.now - 24.hours, top_price: 7.20)
    u1.auctions.create!(name: 'iPhone', finish_at: DateTime.now - 24.hours, top_price: 12.20, paid: true)
  end

  describe "as a basic user" do
    scenario "pay for item" do
      sign_in_as_user
      click_link "My wins"
      expect(page).to have_content "Your wins"
      expect(page).to have_content "MacBook"
      expect(page).to have_link "Pay"
      click_link "Pay"
      expect(page).to have_content "Auction has been paid. Your item is on the way."
      expect(page).to have_content "Paid, waiting for shipping"
    end
  end

  describe "as a moderator" do
    scenario "flag item as sent" do
      sign_in_as_moderator
      click_link "Shipping"
      expect(page).to have_content "Items ready for shipping"
      expect(page).to have_content "iPhone"
      expect(page).to have_link "Set as shipped"
      click_link "Set as shipped"
      expect(page).to have_content "Auction has been set as shipped."
      expect(page).to have_content "Shipped"
    end
  end

  def sign_in_as_user    
    visit new_user_session_path
    within("#new_user") do
      fill_in 'user_email', with: 'user@example.com'
      fill_in 'user_password', with: '123password'
    end
    click_button 'Log in'
  end

  def sign_in_as_moderator
    visit new_user_session_path
    within("#new_user") do
      fill_in 'user_email', with: 'moderator@example.com'
      fill_in 'user_password', with: '123password'
    end
    click_button 'Log in'
  end
end