require 'test_helper'

class EventIncomesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get event_incomes_create_url
    assert_response :success
  end

  test "should get update" do
    get event_incomes_update_url
    assert_response :success
  end

  test "should get destroy" do
    get event_incomes_destroy_url
    assert_response :success
  end

end
