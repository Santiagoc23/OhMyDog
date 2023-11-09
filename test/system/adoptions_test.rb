require "application_system_test_case"

class AdoptionsTest < ApplicationSystemTestCase
  setup do
    @adoption = adoptions(:one)
  end

  test "visiting the index" do
    visit adoptions_url
    assert_selector "h1", text: "Adoptions"
  end

  test "should create adoption" do
    visit adoptions_url
    click_on "New adoption"

    fill_in "Description", with: @adoption.description
    fill_in "Name", with: @adoption.name
    fill_in "Race", with: @adoption.race
    fill_in "Sex", with: @adoption.sex
    fill_in "Situation", with: @adoption.situation
    fill_in "Size", with: @adoption.size
    fill_in "User", with: @adoption.user_id
    click_on "Create Adoption"

    assert_text "Adoption was successfully created"
    click_on "Back"
  end

  test "should update Adoption" do
    visit adoption_url(@adoption)
    click_on "Edit this adoption", match: :first

    fill_in "Description", with: @adoption.description
    fill_in "Name", with: @adoption.name
    fill_in "Race", with: @adoption.race
    fill_in "Sex", with: @adoption.sex
    fill_in "Situation", with: @adoption.situation
    fill_in "Size", with: @adoption.size
    fill_in "User", with: @adoption.user_id
    click_on "Update Adoption"

    assert_text "Adoption was successfully updated"
    click_on "Back"
  end

  test "should destroy Adoption" do
    visit adoption_url(@adoption)
    click_on "Destroy this adoption", match: :first

    assert_text "Adoption was successfully destroyed"
  end
end
