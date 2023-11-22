require "application_system_test_case"

class WalkersTest < ApplicationSystemTestCase
  setup do
    @walker = walkers(:one)
  end

  test "visiting the index" do
    visit walkers_url
    assert_selector "h1", text: "Walkers"
  end

  test "should create walker" do
    visit walkers_url
    click_on "New walker"

    fill_in "Email", with: @walker.email
    fill_in "End", with: @walker.end
    fill_in "Name", with: @walker.name
    fill_in "Phonenum", with: @walker.phoneNum
    fill_in "Start", with: @walker.start
    fill_in "Surname", with: @walker.surname
    fill_in "User", with: @walker.user_id
    fill_in "Zone", with: @walker.zone
    click_on "Create Walker"

    assert_text "Walker was successfully created"
    click_on "Back"
  end

  test "should update Walker" do
    visit walker_url(@walker)
    click_on "Edit this walker", match: :first

    fill_in "Email", with: @walker.email
    fill_in "End", with: @walker.end
    fill_in "Name", with: @walker.name
    fill_in "Phonenum", with: @walker.phoneNum
    fill_in "Start", with: @walker.start
    fill_in "Surname", with: @walker.surname
    fill_in "User", with: @walker.user_id
    fill_in "Zone", with: @walker.zone
    click_on "Update Walker"

    assert_text "Walker was successfully updated"
    click_on "Back"
  end

  test "should destroy Walker" do
    visit walker_url(@walker)
    click_on "Destroy this walker", match: :first

    assert_text "Walker was successfully destroyed"
  end
end
