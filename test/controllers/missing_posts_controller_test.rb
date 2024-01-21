require "test_helper"

class MissingPostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @missing_post = missing_posts(:one)
  end

  test "should get index" do
    get missing_posts_url
    assert_response :success
  end

  test "should get new" do
    get new_missing_post_url
    assert_response :success
  end

  test "should create missing_post" do
    assert_difference("MissingPost.count") do
      post missing_posts_url, params: { missing_post: { age: @missing_post.age, breed: @missing_post.breed, gender: @missing_post.gender, name: @missing_post.name, size: @missing_post.size, zone: @missing_post.zone } }
    end

    assert_redirected_to missing_post_url(MissingPost.last)
  end

  test "should show missing_post" do
    get missing_post_url(@missing_post)
    assert_response :success
  end

  test "should get edit" do
    get edit_missing_post_url(@missing_post)
    assert_response :success
  end

  test "should update missing_post" do
    patch missing_post_url(@missing_post), params: { missing_post: { age: @missing_post.age, breed: @missing_post.breed, gender: @missing_post.gender, name: @missing_post.name, size: @missing_post.size, zone: @missing_post.zone } }
    assert_redirected_to missing_post_url(@missing_post)
  end

  test "should destroy missing_post" do
    assert_difference("MissingPost.count", -1) do
      delete missing_post_url(@missing_post)
    end

    assert_redirected_to missing_posts_url
  end
end
