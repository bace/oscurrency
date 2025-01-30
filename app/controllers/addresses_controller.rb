class AddressesController < ApplicationController
  before_action :login_required
  before_action :correct_user_required

  def index
    @addresses = current_person.addresses.all
    respond_to do |format|
      format.xml { render :xml => @addresses }
    end
  end

  def new
    @states = State.all.order("name").collect {|s| [s.name, s.id]}
    @address = Address.new
  end

  def edit
    @states = State.all.order("name").collect {|s| [s.name, s.id]}
    @address = current_person.addresses.find(params[:id])
  end

  def create
    @address = Address.new(address_params)
    begin
      if current_person.addresses << @address
        redirect_to person_url(current_person)
      else
        @states = State.all.order("name").collect {|s| [s.name, s.id]}
        render :action => :new
      end
    rescue
      @states = State.all.order("name").collect {|s| [s.name, s.id]}
      flash[:error] = t("error_geocoding_failed")
      render :action => :new
    end
  end

  def update
    @address = current_person.addresses.find(params[:id])
    begin
      if @address.update(address_params)
        redirect_to person_url(current_person)
      else
        @states = State.all.order("name").collect {|s| [s.name, s.id]}
        render :action => :edit
      end
    rescue
      @states = State.all.order("name").collect {|s| [s.name, s.id]}
      flash[:error] = t("error_geocoding_failed")
      render :action => :edit
    end
  end

  def destroy
    if current_person.addresses.length > 1
      @address = current_person.addresses.find(params[:id])
      @address.destroy
    else
      flash[:error] = t("error_at_least_one_address")
    end

    respond_to do |format|
      format.html { redirect_to(person_url(current_person)) }
      format.xml  { head :ok }
    end
  end

  def choose
    @address = current_person.addresses.find(params[:id])
    @old_primary_addresses = current_person.addresses.where(primary: true).all
    respond_to do |format|
      if @address.update!(primary: true)
        @old_primary_addresses.each {|a| a.update(primary: false)}
        flash[:success] = t('success_profile_updated')
      else
        flash[:error] = t('error_invalid_action')
      end
      format.html { redirect_to(edit_person_path(current_person)) }
    end
  end

private
  def correct_user_required
    redirect_to home_url unless Person.find(params[:person_id]) == current_person
  end

  def address_params
    params.require(:address).permit(:address_line_1, :address_line_2, :address_line_3, :city, :state_id, :zipcode_plus_4, :address_privacy)
  end
end
