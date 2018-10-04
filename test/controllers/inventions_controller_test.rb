require 'test_helper'

class InventionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get inventions_index_url
    assert_response :success
  end

  test "should get show" do
    get inventions_show_url
    assert_response :success
  end

  test "should get update" do
    get inventions_update_url
    assert_response :success
  end

  test "should get destroy" do
    get inventions_destroy_url
    assert_response :success
  end

  test "should get create" do
    get inventions_create_url
    assert_response :success
  end

end
