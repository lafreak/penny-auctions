require "spec_helper"

describe "the browsing auctions process", :type => :feature do
  before :each do
    u1 = User.create!(
      name: 'User', 
      email: 'user@example.com',
      password: '123password',
      password_confirmation: '123password',
      balance: 58.20
    )

    u2 = User.create!(
      name: 'Moderator', 
      email: 'moderator@example.com',
      password: '123password',
      password_confirmation: '123password',
      balance: 58.20,
      role: 1
    )

    a1 = Auction.create!(name: 'MacBook', finish_at: DateTime.now + 24.hours)
    a2 = Auction.create!(name: 'iPad', finish_at: DateTime.now + 12.hours)
    a3 = Auction.create!(name: 'iPhone', finish_at: DateTime.now - 5.minutes)

    a2.bids.create!(user: u1, price: 0.01)
    a2.bids.create!(user: u2, price: 0.02)
    a2.bids.create!(user: u1, price: 0.03)
  end

  describe "as a visitor" do
    scenario "view auctions" do
      visit auctions_index_path
      expect(page).to have_content 'MacBook'
      expect(page).to have_content 'iPad'
      expect(page).to have_content 'iPhone'
    end

    scenario "display auction properties" do
      visit auctions_index_path
      click_link 'iPad'
      expect(page).to have_content '$0.01 - User'
      expect(page).to have_content '$0.02 - Moderator'
      expect(page).to have_content '$0.03 - User'
    end

    scenario "add new auction" do
      visit auctions_index_path
      click_link 'Add auction'
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

    scenario "edit auction" do
      visit auctions_index_path
      first(:link, 'Edit').click
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

    scenario "delete auction" do
      visit auctions_index_path
      first(:link, 'Delete').click
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

  describe "as a signed in user" do
    scenario "bid auction" do
      sign_in_as_user
      visit auctions_index_path
      expect(page).not_to have_content 'Last bidder: User'
      page.all('a[text()="Bid"]')[1].click
      expect(page).to have_content 'Last bidder: User'
    end
  end

  describe "as a moderator" do
    scenario "add auction" do
      sign_in_as_moderator
      visit auctions_index_path
      click_link "Add auction"
      expect(page).to have_content 'New auction'
      within("#new_auction") do
        fill_in 'auction_name', with: 'Blender'
        fill_in 'datetimepicker4', with: '2117-05-04 21:12'
      end
      click_button 'Create'
      expect(page).to have_content 'Blender'
    end

    scenario "edit auction" do
      sign_in_as_moderator
      visit auctions_index_path
      first(:link, "Edit").click
      expect(page).to have_content 'Edit auction'
      within('.edit_auction') do
        fill_in 'auction_name', with: 'Playstation'
      end
      click_button 'Save'
      expect(page).to have_content 'Auction has been updated.'
      visit auctions_index_path
      expect(page).to have_content 'Playstation'
    end

    scenario "delete auction" do
      sign_in_as_moderator
      visit auctions_index_path
      expect(page).to have_content "iPhone"
      first(:link, "Delete").click
      expect(page).not_to have_content "iPhone"
      expect(page).to have_content "Auction has been removed."
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