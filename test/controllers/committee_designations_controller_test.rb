require 'test_helper'

class CommitteeDesignationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @committee_designation = committee_designations(:one)
  end

  test "should get index" do
    get committee_designations_url
    assert_response :success
  end

  test "should get new" do
    get new_committee_designation_url
    assert_response :success
  end

  test "should create committee_designation" do
    assert_difference('CommitteeDesignation.count') do
      post committee_designations_url, params: { committee_designation: { description: @committee_designation.description, title: @committee_designation.title } }
    end

    assert_redirected_to committee_designation_url(CommitteeDesignation.last)
  end

  test "should show committee_designation" do
    get committee_designation_url(@committee_designation)
    assert_response :success
  end

  test "should get edit" do
    get edit_committee_designation_url(@committee_designation)
    assert_response :success
  end

  test "should update committee_designation" do
    patch committee_designation_url(@committee_designation), params: { committee_designation: { description: @committee_designation.description, title: @committee_designation.title } }
    assert_redirected_to committee_designation_url(@committee_designation)
  end

  test "should destroy committee_designation" do
    assert_difference('CommitteeDesignation.count', -1) do
      delete committee_designation_url(@committee_designation)
    end

    assert_redirected_to committee_designations_url
  end
end
