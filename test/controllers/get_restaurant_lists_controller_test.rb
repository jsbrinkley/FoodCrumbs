require 'test_helper'

class GetRestaurantListsControllerTest < ActionController::TestCase
  setup do
    @get_restaurant_list = get_restaurant_lists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:get_restaurant_lists)
  end

  test "should create get_restaurant_list" do
    assert_difference('GetRestaurantList.count') do
      post :create, get_restaurant_list: { errorCode: @get_restaurant_list.errorCode, googleRoute: @get_restaurant_list.googleRoute, listOfRestaurants: @get_restaurant_list.listOfRestaurants, message: @get_restaurant_list.message }
    end

    assert_response 201
  end

  test "should show get_restaurant_list" do
    get :show, id: @get_restaurant_list
    assert_response :success
  end

  test "should update get_restaurant_list" do
    put :update, id: @get_restaurant_list, get_restaurant_list: { errorCode: @get_restaurant_list.errorCode, googleRoute: @get_restaurant_list.googleRoute, listOfRestaurants: @get_restaurant_list.listOfRestaurants, message: @get_restaurant_list.message }
    assert_response 204
  end

  test "should destroy get_restaurant_list" do
    assert_difference('GetRestaurantList.count', -1) do
      delete :destroy, id: @get_restaurant_list
    end

    assert_response 204
  end
end
