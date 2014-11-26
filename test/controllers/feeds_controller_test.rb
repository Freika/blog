require 'test_helper'

class FeedsControllerTest < ActionController::TestCase
  test "should get rss" do
    get :rss
    assert_response :success
  end

end
