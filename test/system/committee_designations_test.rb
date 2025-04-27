require "application_system_test_case"

class CommitteeDesignationsTest < ApplicationSystemTestCase
  setup do
    @committee_designation = committee_designations(:one)
  end

  test "visiting the index" do
    visit committee_designations_url
    assert_selector "h1", text: "Committee Designations"
  end

  test "creating a Committee designation" do
    visit committee_designations_url
    click_on "New Committee Designation"

    fill_in "Description", with: @committee_designation.description
    fill_in "Title", with: @committee_designation.title
    click_on "Create Committee designation"

    assert_text "Committee designation was successfully created"
    click_on "Back"
  end

  test "updating a Committee designation" do
    visit committee_designations_url
    click_on "Edit", match: :first

    fill_in "Description", with: @committee_designation.description
    fill_in "Title", with: @committee_designation.title
    click_on "Update Committee designation"

    assert_text "Committee designation was successfully updated"
    click_on "Back"
  end

  test "destroying a Committee designation" do
    visit committee_designations_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Committee designation was successfully destroyed"
  end
end
