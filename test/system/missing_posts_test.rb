require "application_system_test_case"

class MissingPostsTest < ApplicationSystemTestCase
  setup do
    @missing_post = missing_posts(:one)
  end

  test "visiting the index" do
    visit missing_posts_url
    assert_selector "h1", text: "Missing posts"
  end

  test "should create missing post" do
    visit missing_posts_url
    click_on "New missing post"

    fill_in "Age", with: @missing_post.age
    fill_in "Breed", with: @missing_post.breed
    fill_in "Gender", with: @missing_post.gender
    fill_in "Name", with: @missing_post.name
    fill_in "Size", with: @missing_post.size
    fill_in "Zone", with: @missing_post.zone
    click_on "Create Missing post"

    assert_text "Missing post was successfully created"
    click_on "Back"
  end

  test "should update Missing post" do
    visit missing_post_url(@missing_post)
    click_on "Edit this missing post", match: :first

    fill_in "Age", with: @missing_post.age
    fill_in "Breed", with: @missing_post.breed
    fill_in "Gender", with: @missing_post.gender
    fill_in "Name", with: @missing_post.name
    fill_in "Size", with: @missing_post.size
    fill_in "Zone", with: @missing_post.zone
    click_on "Update Missing post"

    assert_text "Missing post was successfully updated"
    click_on "Back"
  end

  test "should destroy Missing post" do
    visit missing_post_url(@missing_post)
    click_on "Destroy this missing post", match: :first

    assert_text "Missing post was successfully destroyed"
  end
end
