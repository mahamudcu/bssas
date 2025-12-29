require 'test_helper'

class EventExpensesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get event_expenses_create_url
    assert_response :success
  end

  test "should get update" do
    get event_expenses_update_url
    assert_response :success
  end

  test "should get destroy" do
    get event_expenses_destroy_url
    assert_response :success
  end

end
