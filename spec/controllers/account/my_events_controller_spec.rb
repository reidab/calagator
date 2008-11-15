require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Account::ReservationsController do

  #Delete these examples and add some real ones
  it "should use Account::ReservationsController" do
    controller.should be_an_instance_of(Account::ReservationsController)
  end


  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end
end
