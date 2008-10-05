class AccountsController < ApplicationController
  before_filter :login_required

  def show
    redirect_to account_reservations_url
  end

end
