require "test_helper"

class MedicalStoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @medical_story = medical_stories(:one)
  end

  test "should get index" do
    get medical_stories_url
    assert_response :success
  end

  test "should get new" do
    get new_medical_story_url
    assert_response :success
  end

  test "should create medical_story" do
    assert_difference("MedicalStory.count") do
      post medical_stories_url, params: { medical_story: {  } }
    end

    assert_redirected_to medical_story_url(MedicalStory.last)
  end

  test "should show medical_story" do
    get medical_story_url(@medical_story)
    assert_response :success
  end

  test "should get edit" do
    get edit_medical_story_url(@medical_story)
    assert_response :success
  end

  test "should update medical_story" do
    patch medical_story_url(@medical_story), params: { medical_story: {  } }
    assert_redirected_to medical_story_url(@medical_story)
  end

  test "should destroy medical_story" do
    assert_difference("MedicalStory.count", -1) do
      delete medical_story_url(@medical_story)
    end

    assert_redirected_to medical_stories_url
  end
end
