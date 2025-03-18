require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get custom" do
    get pages_custom_url
    assert_response :success
  end
end
