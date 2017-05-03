require "spec_helper"

describe "the account managing process", :type => :feature do
  before :each do
    u1 = User.create!(
      name: 'User', 
      email: 'user@example.com',
      password: '123password',
      password_confirmation: '123password',
      balance: 18.20
    )

    u2 = User.create!(
      name: 'Administrator', 
      email: 'administrator@example.com',
      password: '123password',
      password_confirmation: '123password',
      balance: 58.20,
      role: 2
    )

    a1 = Auction.create!(name: 'MacBook', finish_at: DateTime.now + 24.hours)
    a2 = Auction.create!(name: 'iPad', finish_at: DateTime.now + 12.hours)
    a3 = Auction.create!(name: 'iPhone', finish_at: DateTime.now - 5.minutes)

    a2.bids.create!(user: u1, price: 0.01)
    a2.bids.create!(user: u2, price: 0.02)
    a2.bids.create!(user: u1, price: 0.03)
  end

  describe "as a basic user" do
    it "view all accounts" do
      sign_in_as_user 
      visit root_path
      click_link "Accounts"
      expect(page).to have_content "You are not authorized to perform this action."
    end
  end

  describe "as moderator" do
    it "view all accounts" do
      sign_in_as_administrator
      visit root_path
      click_link "Accounts"
      expect(page).to have_content "user@example.com"
      expect(page).to have_content "administrator@example.com"
      expect(page).to have_content "$18.20"
      expect(page).to have_content "$58.20"
    end

    it "edit user info" do
      sign_in_as_administrator
      visit root_path
      click_link "Accounts"
      expect(page).not_to have_content 'John Smith'
      expect(page).not_to have_content 'ul. Niepodległości'
      expect(page).not_to have_content '$200.00'
      first(:link, "Edit").click
      within(".edit_user") do
        fill_in 'user_name', with: "John Smith"
        fill_in 'user_address', with: "ul. Niepodległości"
        fill_in 'user_balance', with: "200.00"
      end
      click_button "Update"
      expect(page).to have_content 'User has been saved.'
      expect(page).to have_content 'John Smith'
      expect(page).to have_content 'ul. Niepodległości'
      expect(page).to have_content '$200.00'
    end

    it "block user" do
      sign_in_as_administrator
      visit root_path
      click_link "Accounts"
      expect(page).not_to have_content 'Blocked'
      first(:link, "Block").click
      expect(page).to have_content 'Blocked'
    end

    it "delete user" do
      sign_in_as_administrator
      visit root_path
      click_link "Accounts"
      expect(page).to have_content 'user@example.com'
      first(:link, "Delete").click
      expect(page).not_to have_content 'user@example.com'
    end

    it "change role" do
      sign_in_as_administrator
      visit root_path
      click_link "Accounts"
      within(first(".role")) do
        expect(find('a[text()="Moderator"]')).not_to be_nil
        expect(find('a[text()="Standard"]')).to raise_error CapyBara::ElementNotFound
      end
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

  def sign_in_as_administrator
    visit new_user_session_path
    within("#new_user") do
      fill_in 'user_email', with: 'administrator@example.com'
      fill_in 'user_password', with: '123password'
    end
    click_button 'Log in'
  end
end