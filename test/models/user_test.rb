require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      name: 'Jan Kowalski',
      email: 'test@email.com',
      password: '123password',
      encrypted_password: User.new.send(:password_digest, '123password')
    )
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "should be invalid due to missing name" do
    @user.name = nil
    assert_not @user.valid?
  end

  test "should be invalid due to password too short" do
    @user.password = '123'
    @user.encrypted_password = User.new.send(:password_digest, '123')

    assert_not @user.valid?
  end

  test "should be invalid due to email format" do
    @user.email = 'bad_email'
    assert_not @user.valid?  
  end

  test "should be invalid due to negative balance" do
    @user.balance = BigDecimal.new(-0.5, 2)
    assert_not @user.valid?
  end

  test "should have default balance" do
    assert_equal 0, @user.balance
  end

  test "should not be blocked by default" do
    assert_not @user.blocked
  end
  
  test "should not be moderator nor admin by default" do
    assert_equal 0, @user.role
  end

  test "should assign premium to Jan 1 2000" do
    assert_equal DateTime.new(2000, 1, 1), @user.premium
  end

end
