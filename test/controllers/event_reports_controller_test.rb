require 'test_helper'

class EventReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get event_reports_index_url
    assert_response :success
  end

  test "should get expenses_report" do
    get event_reports_expenses_report_url
    assert_response :success
  end

  test "should get incomes_report" do
    get event_reports_incomes_report_url
    assert_response :success
  end

  test "should get financial_summary" do
    get event_reports_financial_summary_url
    assert_response :success
  end

  test "should get export_pdf" do
    get event_reports_export_pdf_url
    assert_response :success
  end

  test "should get export_excel" do
    get event_reports_export_excel_url
    assert_response :success
  end

end
