require "test_helper"

class Public::UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_users_index_url
    assert_response :success
  end

  test "should get followee" do
    get public_users_followee_url
    assert_response :success
  end

  test "should get follower" do
    get public_users_follower_url
    assert_response :success
  end

  test "should get bookmarks" do
    get public_users_bookmarks_url
    assert_response :success
  end

  test "should get notifications" do
    get public_users_notifications_url
    assert_response :success
  end

  test "should get edit" do
    get public_users_edit_url
    assert_response :success
  end

  test "should get show" do
    get public_users_show_url
    assert_response :success
  end
end
