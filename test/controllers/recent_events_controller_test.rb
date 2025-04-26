require 'test_helper'

class RecentEventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @recent_event = recent_events(:one)
  end

  test "should get index" do
    get recent_events_url
    assert_response :success
  end

  test "should get new" do
    get new_recent_event_url
    assert_response :success
  end

  test "should create recent_event" do
    assert_difference('RecentEvent.count') do
      post recent_events_url, params: { recent_event: { description: @recent_event.description, image: @recent_event.image, title: @recent_event.title } }
    end

    assert_redirected_to recent_event_url(RecentEvent.last)
  end

  test "should show recent_event" do
    get recent_event_url(@recent_event)
    assert_response :success
  end

  test "should get edit" do
    get edit_recent_event_url(@recent_event)
    assert_response :success
  end

  test "should update recent_event" do
    patch recent_event_url(@recent_event), params: { recent_event: { description: @recent_event.description, image: @recent_event.image, title: @recent_event.title } }
    assert_redirected_to recent_event_url(@recent_event)
  end

  test "should destroy recent_event" do
    assert_difference('RecentEvent.count', -1) do
      delete recent_event_url(@recent_event)
    end

    assert_redirected_to recent_events_url
  end
end
