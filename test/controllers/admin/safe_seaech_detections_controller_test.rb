require "test_helper"

class Admin::SafeSeaechDetectionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_safe_seaech_detections_index_url
    assert_response :success
  end
end
