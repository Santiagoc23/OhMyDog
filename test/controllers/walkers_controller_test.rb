require "test_helper"

class WalkersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @walker = walkers(:one)
  end

  test "should get index" do
    get walkers_url
    assert_response :success
  end

  test "should get new" do
    get new_walker_url
    assert_response :success
  end

  test "should create walker" do
    assert_difference("Walker.count") do
      post walkers_url, params: { walker: { email: @walker.email, end: @walker.end, name: @walker.name, phoneNum: @walker.phoneNum, start: @walker.start, surname: @walker.surname, user_id: @walker.user_id, zone: @walker.zone } }
    end

    assert_redirected_to walker_url(Walker.last)
  end

  test "should show walker" do
    get walker_url(@walker)
    assert_response :success
  end

  test "should get edit" do
    get edit_walker_url(@walker)
    assert_response :success
  end

  test "should update walker" do
    patch walker_url(@walker), params: { walker: { email: @walker.email, end: @walker.end, name: @walker.name, phoneNum: @walker.phoneNum, start: @walker.start, surname: @walker.surname, user_id: @walker.user_id, zone: @walker.zone } }
    assert_redirected_to walker_url(@walker)
  end

  test "should destroy walker" do
    assert_difference("Walker.count", -1) do
      delete walker_url(@walker)
    end

    assert_redirected_to walkers_url
  end
end
