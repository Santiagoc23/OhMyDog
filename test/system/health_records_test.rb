require "application_system_test_case"

class HealthRecordsTest < ApplicationSystemTestCase
  setup do
    @health_record = health_records(:one)
  end

  test "visiting the index" do
    visit health_records_url
    assert_selector "h1", text: "Health records"
  end

  test "should create health record" do
    visit health_records_url
    click_on "New health record"

    click_on "Create Health record"

    assert_text "Health record was successfully created"
    click_on "Back"
  end

  test "should update Health record" do
    visit health_record_url(@health_record)
    click_on "Edit this health record", match: :first

    click_on "Update Health record"

    assert_text "Health record was successfully updated"
    click_on "Back"
  end

  test "should destroy Health record" do
    visit health_record_url(@health_record)
    click_on "Destroy this health record", match: :first

    assert_text "Health record was successfully destroyed"
  end
end
