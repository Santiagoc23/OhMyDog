require "application_system_test_case"

class MedicalStoriesTest < ApplicationSystemTestCase
  setup do
    @medical_story = medical_stories(:one)
  end

  test "visiting the index" do
    visit medical_stories_url
    assert_selector "h1", text: "Medical stories"
  end

  test "should create medical story" do
    visit medical_stories_url
    click_on "New medical story"

    click_on "Create Medical story"

    assert_text "Medical story was successfully created"
    click_on "Back"
  end

  test "should update Medical story" do
    visit medical_story_url(@medical_story)
    click_on "Edit this medical story", match: :first

    click_on "Update Medical story"

    assert_text "Medical story was successfully updated"
    click_on "Back"
  end

  test "should destroy Medical story" do
    visit medical_story_url(@medical_story)
    click_on "Destroy this medical story", match: :first

    assert_text "Medical story was successfully destroyed"
  end
end
