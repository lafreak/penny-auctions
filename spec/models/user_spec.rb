require 'rails_helper'

RSpec.describe User, :type => :model do
  let(:user) { 
    User.new(
      name: 'Jan Kowalski',
      email: 'test@email.com',
      password: '123password',
      encrypted_password: User.new.send(:password_digest, '123password')
    )
  }

  it "is valid" do
    expect(user).to be_valid
  end

  it "is invalid due to missing name" do
    user.name = nil
    expect(user).not_to be_valid
  end

  it "is invalid due to password too short" do
    user.password = '123'
    user.encrypted_password = User.new.send(:password_digest, '123')
    expect(user).not_to be_valid
  end

  it "is invalid due to email format" do
    user.email = 'bad_email'
    expect(user).not_to be_valid
  end

  it "is invalid due to negative balance" do
    user.balance = BigDecimal.new -0.5, 2
    expect(user).not_to be_valid
  end

  it "has default balance" do
    expect(user.balance).to eq 0
  end

  it "is unblocked by default" do
    expect(user.blocked).to eq false
  end

  it "is not admin nor moderator by default" do
    expect(user.role).to eq 0
  end

  it "has no premium by default" do
    expect(user.premium).to eq DateTime.new(2000, 1, 1)
  end
end