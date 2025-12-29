require 'test_helper'

class AlumniEventsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get alumni_events_index_url
    assert_response :success
  end

  test "should get show" do
    get alumni_events_show_url
    assert_response :success
  end

  test "should get new" do
    get alumni_events_new_url
    assert_response :success
  end

  test "should get create" do
    get alumni_events_create_url
    assert_response :success
  end

  test "should get edit" do
    get alumni_events_edit_url
    assert_response :success
  end

  test "should get update" do
    get alumni_events_update_url
    assert_response :success
  end

  test "should get destroy" do
    get alumni_events_destroy_url
    assert_response :success
  end

  test "should get financial_summary" do
    get alumni_events_financial_summary_url
    assert_response :success
  end

end
