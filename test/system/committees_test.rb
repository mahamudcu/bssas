require "application_system_test_case"

class CommitteesTest < ApplicationSystemTestCase
  setup do
    @committee = committees(:one)
  end

  test "visiting the index" do
    visit committees_url
    assert_selector "h1", text: "Committees"
  end

  test "creating a Committee" do
    visit committees_url
    click_on "New Committee"

    check "Active" if @committee.active
    fill_in "Clossing date", with: @committee.clossing_date
    fill_in "Committee designation", with: @committee.committee_designation_id
    fill_in "Description", with: @committee.description
    fill_in "Duration", with: @committee.duration
    fill_in "Duration date", with: @committee.duration_date
    fill_in "Stablish date", with: @committee.stablish_date
    fill_in "Title", with: @committee.title
    click_on "Create Committee"

    assert_text "Committee was successfully created"
    click_on "Back"
  end

  test "updating a Committee" do
    visit committees_url
    click_on "Edit", match: :first

    check "Active" if @committee.active
    fill_in "Clossing date", with: @committee.clossing_date
    fill_in "Committee designation", with: @committee.committee_designation_id
    fill_in "Description", with: @committee.description
    fill_in "Duration", with: @committee.duration
    fill_in "Duration date", with: @committee.duration_date
    fill_in "Stablish date", with: @committee.stablish_date
    fill_in "Title", with: @committee.title
    click_on "Update Committee"

    assert_text "Committee was successfully updated"
    click_on "Back"
  end

  test "destroying a Committee" do
    visit committees_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Committee was successfully destroyed"
  end
end
