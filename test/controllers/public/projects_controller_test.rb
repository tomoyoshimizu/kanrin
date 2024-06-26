require "test_helper"

class Public::ProjectsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_projects_index_url
    assert_response :success
  end

  test "should get bookmarks" do
    get public_projects_bookmarks_url
    assert_response :success
  end

  test "should get edit" do
    get public_projects_edit_url
    assert_response :success
  end

  test "should get show" do
    get public_projects_show_url
    assert_response :success
  end
end
