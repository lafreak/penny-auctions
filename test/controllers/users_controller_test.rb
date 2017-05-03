require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = "Penny Auctions"
  end

  test "should get sign_in" do
    get new_user_session_path
    assert_response :success
    assert_select "title", "Log in | #{@base_title}"
    assert_select "form", { count: 2 }, 
      "This page must have one form for standard login and one for facebook"
    assert_select "a" do
      assert_select "[href=?]", new_user_registration_path, 2,
        "This page must have 2 link to sign up page"
    end
  end

  test "should get sign_up" do
    get new_user_registration_path
    assert_response :success
    assert_select "title", "Sign up | #{@base_title}"
    assert_select "form", { count: 2 },
      "This page must have one form for standard registration and one for facebook"
    assert_select "a" do
      assert_select "[href=?]", new_user_session_path, 2,
        "This page must have 2 links to log in page"
    end
  end

end
