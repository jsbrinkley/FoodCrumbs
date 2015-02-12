require 'test_helper'

class TestingAlgorithmsControllerTest < ActionController::TestCase
  setup do
    @testing_algorithm = testing_algorithms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:testing_algorithms)
  end

  test "should create testing_algorithm" do
    assert_difference('TestingAlgorithm.count') do
      post :create, testing_algorithm: {  }
    end

    assert_response 201
  end

  test "should show testing_algorithm" do
    get :show, id: @testing_algorithm
    assert_response :success
  end

  test "should update testing_algorithm" do
    put :update, id: @testing_algorithm, testing_algorithm: {  }
    assert_response 204
  end

  test "should destroy testing_algorithm" do
    assert_difference('TestingAlgorithm.count', -1) do
      delete :destroy, id: @testing_algorithm
    end

    assert_response 204
  end
end
