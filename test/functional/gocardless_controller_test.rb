require 'test_helper'
require 'mocha/setup'

class GocardlessControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_select "h1", "GoCardless sample application"
  end

  test "should post buy" do
    post :buy, {
      amount: 10,
      name: "Purchase"
    }
    assert_response :redirect
    assert @response.header["Location"].include?(
      "https://sandbox.gocardless.com/connect/bills/new"
    )
  end

  test "should post subscribe" do
    post :subscribe, {
      amount: 10,
      interval_unit: 1,
      interval_length: "month",
      name: "Subscription"
    }
    assert_response :redirect
    assert @response.header["Location"].include?(
      "https://sandbox.gocardless.com/connect/subscriptions/new"
    )
  end

  test "should post preauth" do
    post :preauth, {
      amount: 100,
      interval_length: 3,
      interval_unit: "month",
      name: "Sample preauthorization"
    }
    assert_response :redirect
    assert @response.header["Location"].include?(
      "https://sandbox.gocardless.com/connect/pre_authorizations/new"
    )
  end

  test "should get success on confirmation" do
    GoCardless.stubs(:confirm_resource).returns
    get :confirm
    assert_response :success
    assert_select "h3", "Your purchase has been verified! Thanks!"
  end

  test "should get error on confirmation" do
    GoCardless.stubs(:confirm_resource).raises(GoCardless::ApiError, @response)
    get :confirm
    assert_response :success
    assert "h3", "Could not confirm purchase. Details: GoCardless::ApiError [200]"
  end

end
