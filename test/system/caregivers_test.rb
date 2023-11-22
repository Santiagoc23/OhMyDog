require "application_system_test_case"

class CaregiversTest < ApplicationSystemTestCase
  setup do
    @caregiver = caregivers(:one)
  end

  test "visiting the index" do
    visit caregivers_url
    assert_selector "h1", text: "Caregivers"
  end

  test "should create caregiver" do
    visit caregivers_url
    click_on "New caregiver"

    fill_in "Email", with: @caregiver.email
    fill_in "Name", with: @caregiver.name
    fill_in "Phonenum", with: @caregiver.phoneNum
    fill_in "Surname", with: @caregiver.surname
    click_on "Create Caregiver"

    assert_text "Caregiver was successfully created"
    click_on "Back"
  end

  test "should update Caregiver" do
    visit caregiver_url(@caregiver)
    click_on "Edit this caregiver", match: :first

    fill_in "Email", with: @caregiver.email
    fill_in "Name", with: @caregiver.name
    fill_in "Phonenum", with: @caregiver.phoneNum
    fill_in "Surname", with: @caregiver.surname
    click_on "Update Caregiver"

    assert_text "Caregiver was successfully updated"
    click_on "Back"
  end

  test "should destroy Caregiver" do
    visit caregiver_url(@caregiver)
    click_on "Destroy this caregiver", match: :first

    assert_text "Caregiver was successfully destroyed"
  end
end
