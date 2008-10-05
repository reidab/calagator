class Account::ReservationsController < ApplicationController
  before_filter :login_required

  def index
    @reservations = current_user.reservations.sort_by{|t| - t.event.end_time.to_i}
  end
end
