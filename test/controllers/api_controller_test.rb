require "test_helper"

class ApiControllerTest < ActionDispatch::IntegrationTest
  test "should get features" do
    get api_features_url
    assert_response :success
  end
end
