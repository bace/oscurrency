class OffersController < ApplicationController

  respond_to :html, :xml, :json, :js

  before_action :login_required
  load_resource :group
  load_and_authorize_resource :offer, :through => :group, :shallow => true
  before_action :correct_person_required, :only => [:edit, :update, :destroy]

  def index
    @selected_category = params[:category_id].nil? ? nil : Category.find(params[:category_id])
    @selected_neighborhood = params[:neighborhood_id].nil? ? nil : Neighborhood.find(params[:neighborhood_id])

    @authorized = @group.authorized_to_view_offers?(current_person)
    if @authorized
      @offers = Offer.custom_search(@selected_neighborhood || @selected_category,
                                  @group,
                                  active=params[:scope].nil?, # if a scope is not passed, just return actives
                                  params[:page],
                                  ajax_posts_per_page,
                                  params[:search]
                                  ).order("offers.expiration_date")
    else
      flash[:notice] = t('notice_member_to_view_offers')
      @offers = Offer.where('1=0').paginate(:page => 1, :per_page => ajax_posts_per_page)
    end

    respond_with @offers do |format|
      format.js {render :action => 'reject' if not request.xhr?}
    end
  end

  def show
    @group = @offer.group
    if @group.authorized_to_view_offers?(current_person)
      respond_with @offer do |format|
        format.js {render :action => 'reject' if not request.xhr?}
      end
    else
      raise CanCan::AccessDenied.new("Not authorized!", :read, Offer)
    end
  end

  def new
    @all_categories = Category.by_long_name
    @all_neighborhoods = Neighborhood.by_long_name
    @selected_neighborhoods = current_person.neighborhoods
    @photo = @offer.photos.build
    respond_to do |format|
      format.js {render :action => 'reject' if not request.xhr?}
      format.html { redirect_to group_path(@group, :anchor => 'offers/new') }
    end
  end

  def create
    @offer.group = @group
    @offer.person = current_person
    @all_categories = Category.by_long_name
    @all_neighborhoods = Neighborhood.by_long_name

    respond_to do |format|
      format.js do
        if @offer.save
          flash[:notice] = t('success_offer_created')
          @offers = Offer.custom_search(nil,@group,active=true,page=1,ajax_posts_per_page,nil).order("updated_at desc")
        else
          @photo = @offer.photos.build if @offer.photos.blank?
          render :action => "new"
        end
      end
    end
  end

  def edit
    @group = @offer.group
    @all_categories = Category.by_long_name
    @all_neighborhoods = Neighborhood.by_long_name
    @selected_neighborhoods = @offer.neighborhoods
    @photo = @offer.photos.build if @offer.photos.blank?
    respond_to do |format|
      format.js {render :action => 'reject' if not request.xhr?}
    end
  end

  def update
    #@offer = Offer.new(offer_params)
    @group = @offer.group
    @all_categories = Category.by_long_name
    @all_neighborhoods = Neighborhood.by_long_name

    respond_to do |format|
      if @offer.update_attributes(offer_params)
        flash[:notice] = t('notice_offer_updated')
        @offers = Offer.custom_search(nil,@group,active=true,page=1,ajax_posts_per_page,nil).order("updated_at desc")
        #format.html { redirect_to(@offer) }
        format.js
        format.xml  { head :ok }
      else
        @photo = @offer.photos.build if @offer.photos.blank?
        #format.html { render :action => "edit" }
        format.js {render :action => 'edit'}
        format.xml  { render :xml => @offer.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @offer = Offer.find(params[:id])
    if can?(:destroy, @offer)
      flash[:notice] = t('success_offer_destroyed')
      @offer.destroy
    else
      flash[:error] = t('error_offer_cannot_be_deleted')
    end

    respond_to do |format|
      format.xml  { head :ok }
      format.js
    end
  end

  def new_photo
    @photo = Photo.new
    respond_to do |format|
      format.html
    end
  end

  def save_photo
    if params[:photo].nil?
      # This is mainly to prevent exceptions on iPhones.
      flash[:error] = t('error_browser_upload_fail')
      redirect_to(offer_path(@offer)) and return
    end
    if params[:commit] == "Cancel"
      flash[:notice] = t('notice_upload_canceled')
      redirect_to(offer_path(@offer)) and return
    end
    
    @photo = Photo.new(photo_params)
    @photo.photoable = @offer
    @photo.primary = @offer.photos.empty?
    
    respond_to do |format|
      if @photo.save
        flash[:success] = t('success_photo_uploaded')
        redirect_to offer_path(@offer) and return
      else
        format.html { render :action => "new_photo" }
      end
    end
  end

  private
  def offer_params
    params.require(:offer).permit(:name, :description, :price, :expiration_date, :available_count, {:category_ids => [], :neighborhood_ids => [], :photos_attributes => [:picture]})
  end

  def correct_person_required
    redirect_to home_url unless ( current_person.admin? or Offer.find(params[:id]).person == current_person )
  end
end
