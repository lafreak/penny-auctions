require 'test_helper'

class AuctionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = "Penny Auctions"
  end

  test "should get index" do
    get auctions_index_path
    assert_response :success
    assert_select "title", "Auctions | #{@base_title}"
  end
end
