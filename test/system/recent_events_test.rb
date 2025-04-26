require "application_system_test_case"

class RecentEventsTest < ApplicationSystemTestCase
  setup do
    @recent_event = recent_events(:one)
  end

  test "visiting the index" do
    visit recent_events_url
    assert_selector "h1", text: "Recent Events"
  end

  test "creating a Recent event" do
    visit recent_events_url
    click_on "New Recent Event"

    fill_in "Description", with: @recent_event.description
    fill_in "Image", with: @recent_event.image
    fill_in "Title", with: @recent_event.title
    click_on "Create Recent event"

    assert_text "Recent event was successfully created"
    click_on "Back"
  end

  test "updating a Recent event" do
    visit recent_events_url
    click_on "Edit", match: :first

    fill_in "Description", with: @recent_event.description
    fill_in "Image", with: @recent_event.image
    fill_in "Title", with: @recent_event.title
    click_on "Update Recent event"

    assert_text "Recent event was successfully updated"
    click_on "Back"
  end

  test "destroying a Recent event" do
    visit recent_events_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Recent event was successfully destroyed"
  end
end
