require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @base_title = "Penny Auctions"
  end

  test "should get index" do
    get root_path
    assert_response :success
    assert_select "title", "Home | #{@base_title}"
    assert_select "form", false, "This page must contain no forms"
    assert_select "div.jumbotron", true, "This page must contain jumbotron"
    assert_select "div.jumbotron h1", @base_title, 
      "This page must contain title as jumbotron header"
  end

  test "should redirect get premium if not logged in" do
    get buy_premium_path
    assert_response :redirect
  end

end
