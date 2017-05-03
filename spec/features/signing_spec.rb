require "spec_helper"

describe "the signing process", :type => :feature do
  before :each do
    User.create!(
      name: 'Jan Kowalski', 
      email: 'user@example.com',
      password: '123password',
      password_confirmation: '123password'
    )
  end

  scenario "login with valid email and password" do
    visit new_user_session_path
    within("#new_user") do
      fill_in 'user_email', with: 'user@example.com'
      fill_in 'user_password', with: '123password'
    end
    click_button 'Log in'
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario "login with valid email and invalid pasword" do
    visit new_user_session_path
    within("#new_user") do
      fill_in 'user_email', with: 'user@example.com'
      fill_in 'user_password', with: 'bad_passord'
    end
    click_button 'Log in'
    expect(page).to have_content 'Invalid Email or password.'
  end

  scenario "register with valid params" do 
    visit new_user_registration_path
    within("#new_user") do
      fill_in 'user_name', with: 'Andrzej Nowak'
      fill_in 'user_email', with: 'email@email.com'
      fill_in 'user_password', with: '123password'
      fill_in 'user_password_confirmation', with: '123password'
    end
    click_button 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario "register with no name" do
    visit new_user_registration_path
    within("#new_user") do
      fill_in 'user_email', with: 'email@email.com'
      fill_in 'user_password', with: '123password'
      fill_in 'user_password_confirmation', with: '123password'
    end
    click_button 'Sign up'
    expect(page).to have_content "Name can't be blank"
  end

  scenario "register with email that already exist" do
    visit new_user_registration_path
    within("#new_user") do
      fill_in 'user_name', with: 'Andrzej Nowak'
      fill_in 'user_email', with: 'user@example.com'
      fill_in 'user_password', with: '123password'
      fill_in 'user_password_confirmation', with: '123password'
    end
    click_button 'Sign up'
    expect(page).to have_content "Email has already been taken"
  end

end