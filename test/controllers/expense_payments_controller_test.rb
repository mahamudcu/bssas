require 'test_helper'

class ExpensePaymentsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get expense_payments_create_url
    assert_response :success
  end

  test "should get destroy" do
    get expense_payments_destroy_url
    assert_response :success
  end

end
