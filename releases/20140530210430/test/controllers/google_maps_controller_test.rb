require 'test_helper'

class GoogleMapsControllerTest < ActionController::TestCase
  setup do
    @google_map = google_maps(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:google_maps)
  end

  test "should create google_map" do
    assert_difference('GoogleMap.count') do
      post :create, google_map: {  }
    end

    assert_response 201
  end

  test "should show google_map" do
    get :show, id: @google_map
    assert_response :success
  end

  test "should update google_map" do
    put :update, id: @google_map, google_map: {  }
    assert_response 204
  end

  test "should destroy google_map" do
    assert_difference('GoogleMap.count', -1) do
      delete :destroy, id: @google_map
    end

    assert_response 204
  end
end
