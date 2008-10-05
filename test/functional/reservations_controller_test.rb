require 'test_helper'

class ReservationsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:reservations)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_reservation
    assert_difference('Reservation.count') do
      post :create, :reservation => { }
    end

    assert_redirected_to reservation_path(assigns(:reservation))
  end

  def test_should_show_reservation
    get :show, :id => reservations(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => reservations(:one).id
    assert_response :success
  end

  def test_should_update_reservation
    put :update, :id => reservations(:one).id, :reservation => { }
    assert_redirected_to reservation_path(assigns(:reservation))
  end

  def test_should_destroy_reservation
    assert_difference('Reservation.count', -1) do
      delete :destroy, :id => reservations(:one).id
    end

    assert_redirected_to reservations_path
  end
end
