class ReservationsController < ApplicationController
  # TODO Should anyone ever be allowed to manipulate anyone else's
  # reservations? If not, remove all these unnecessary actions.
  before_filter :bounce_to_root_url, :except => [:create_or_update]

  before_filter :login_required, :only => [:create_or_update]

  # GET /reservations
  # GET /reservations.xml
  def index
    @reservations = Reservation.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reservations }
    end
  end

  # GET /reservations/1
  # GET /reservations/1.xml
  def show
    @reservation = Reservation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @reservation }
    end
  end

  # GET /reservations/new
  # GET /reservations/new.xml
  def new
    @reservation = Reservation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @reservation }
    end
  end

  # GET /reservations/1/edit
  def edit
    @reservation = Reservation.find(params[:id])
  end

  # POST /reservations
  # POST /reservations.xml
  def create
    @reservation = Reservation.new(params[:reservation])

    respond_to do |format|
      if @reservation.save
        flash[:notice] = 'Reservation was successfully created.'
        format.html { redirect_to(@reservation) }
        format.xml  { render :xml => @reservation, :status => :created, :location => @reservation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @reservation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /reservations/1
  # PUT /reservations/1.xml
  def update
    @reservation = Reservation.find(params[:id])

    respond_to do |format|
      if @reservation.update_attributes(params[:reservation])
        flash[:notice] = 'Reservation was successfully updated.'
        format.html { redirect_to(@reservation) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @reservation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /reservations/1
  # DELETE /reservations/1.xml
  def destroy
    @reservation = Reservation.find(params[:id])
    @reservation.destroy

    respond_to do |format|
      format.html { redirect_to(reservations_url) }
      format.xml  { head :ok }
    end
  end

  def create_or_update
    if reservation = current_user.reservations.find_by_event_id(params[:event_id])
      # Update
      reservation.update_attribute(:status, params[:status])
    else
      # Create
      current_user.reservations.create!(:status => params[:status], :event_id => params[:event_id])
    end

    unless request.xhr?
      redirect_to(event_url(params[:event_id]))
    end
  end

protected

  def bounce_to_root_url
    flash[:failure] = "Access forbidden to /reservations"
    redirect_to root_url
  end

end
