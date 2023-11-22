require "test_helper"

class CaregiversControllerTest < ActionDispatch::IntegrationTest
  setup do
    @caregiver = caregivers(:one)
  end

  test "should get index" do
    get caregivers_url
    assert_response :success
  end

  test "should get new" do
    get new_caregiver_url
    assert_response :success
  end

  test "should create caregiver" do
    assert_difference("Caregiver.count") do
      post caregivers_url, params: { caregiver: { email: @caregiver.email, name: @caregiver.name, phoneNum: @caregiver.phoneNum, surname: @caregiver.surname } }
    end

    assert_redirected_to caregiver_url(Caregiver.last)
  end

  test "should show caregiver" do
    get caregiver_url(@caregiver)
    assert_response :success
  end

  test "should get edit" do
    get edit_caregiver_url(@caregiver)
    assert_response :success
  end

  test "should update caregiver" do
    patch caregiver_url(@caregiver), params: { caregiver: { email: @caregiver.email, name: @caregiver.name, phoneNum: @caregiver.phoneNum, surname: @caregiver.surname } }
    assert_redirected_to caregiver_url(@caregiver)
  end

  test "should destroy caregiver" do
    assert_difference("Caregiver.count", -1) do
      delete caregiver_url(@caregiver)
    end

    assert_redirected_to caregivers_url
  end
end
