require "spec_helper"

describe "the premium account process", :type => :feature do
  before :each do
    u1 = User.create!(
      name: 'User', 
      email: 'user@example.com',
      password: '123password',
      password_confirmation: '123password',
      balance: 18.20
    )

    a1 = Auction.create!(name: 'MacBook', finish_at: DateTime.now + 24.hours, premium: true)
  end

  describe "as a basic user" do
    scenario "cannot bid premium accounts" do
      sign_in_as_user
      visit auctions_index_path
      click_link "Bid"
      expect(page).to have_content "You are not authorized to perform this action."
    end

    scenario "buy premium account and bid premium auction" do
      sign_in_as_user
      expect(page).not_to have_content 'Premium ends:'
      visit buy_premium_path
      click_link 'Buy premium ($10.00)'
      expect(page).to have_content 'You have premium account now.'
      expect(page).to have_content 'Premium ends:'
      click_link 'Auctions'
      click_link "Bid"
      expect(page).to have_content 'Last bidder: User'
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
end