class PeopleController < ApplicationController

  skip_before_filter :require_activation, :only => :verify_email
  skip_before_filter :admin_warning, :only => [ :show, :update ]
  before_filter :login_required, :except => [:new, :create, :verify_email]
  before_filter :correct_person_required, :only => [ :edit, :update ]

  def index
    if params[:sort]
      if "alpha" == params[:sort]
        @people = Person.
          by_first_letter.
          mostly_active.
          paginate(:page => params[:page], :per_page => RASTER_PER_PAGE, :group_by => "first_letter")
        @people.add_missing_links(('A'..'Z').to_a)
      end
    else
      @people = Person.
        by_newest.
        mostly_active.
        paginate(:page => params[:page], :per_page => RASTER_PER_PAGE)
    end

    respond_to do |format|
      format.html
    end
  end

  def show
    person_id = ( 0 == params[:id].to_i ) ? current_person.id : params[:id]
    @person = Person.find(person_id)
    unless @person.active? || current_person.admin? || (global_prefs.whitelist? && current_person.activator?)
      flash[:error] = t('error_person_inactive')
      redirect_to home_url and return
    end
    respond_to do |format|
      format.html
      if current_person == @person
        format.json { render :json => @person.as_json( :methods => :icon, :only => [:id, :name, :description, :created_at, :identity_url,:icon], :include => {:accounts => {:only => [:balance_with_initial_offset,:group_id]}, :groups => {:only => [:id,:name]}, :own_groups => { :methods => [:icon,:thumbnail], :only => [:id,:name,:mode,:icon,:thumbnail] } }) }
        format.xml { render :xml => @person.to_xml( :methods => :icon, :only => [:id, :name, :description, :created_at, :identity_url,:icon], :include => {:accounts => {:only => [:balance_with_initial_offset,:group_id]}, :groups => {:only => [:id,:name]}, :own_groups => { :methods => [:icon,:thumbnail], :only => [:id,:name,:mode,:icon,:thumbnail] }}) }
      else
        format.json { render :json => @person.as_json( :methods => :icon, :only => [:id, :name, :description, :created_at, :identity_url,:icon], :include => {:accounts => {:only => [:balance_with_initial_offset,:group_id]}, :groups_not_hidden => {:only => [:id,:name]}}) }
        format.xml { render :xml => @person.to_xml( :methods => :icon, :only => [:id, :name, :description, :created_at, :identity_url,:icon], :include => {:accounts => {:only => [:balance_with_initial_offset,:group_id]}, :groups_not_hidden => {:only => [:id,:name]}}) }
      end
    end
  end

  def new
    @body = "register single-col"
    @person = Person.new
    @all_categories = Category.all.order("parent_id, name").sort_by { |a| a.long_name }
    @all_neighborhoods = Neighborhood.all.order("parent_id, name").sort_by { |a| a.long_name }
    respond_to do |format|
      format.html
    end
  end

  def create
    @person = Person.new(person_params)
    @person.email_verified = false if global_prefs.email_verifications?
    respond_to do |format|
      format.html do
        if @person.save
          if global_prefs.can_send_email? && !global_prefs.new_member_notification.blank?
            PersonMailerQueue.registration_notification(@person)
          end
          if global_prefs.email_verifications?
            @person.deliver_email_verification!
            flash[:notice] = t('notice_thanks_for_signing_up_check_email')
          else
            flash[:notice] = t('notice_thanks_for_signing_up')
          end
          redirect_to(home_url)
        else
          @body = "register single-col"
          @all_categories = Category.find(:all, :order => "parent_id, name").sort_by { |a| a.long_name }
          @all_neighborhoods = Neighborhood.find(:all, :order => "parent_id, name").sort_by { |a| a.long_name }
          render :action => 'new'
        end
      end
    end
  rescue ActiveRecord::StatementInvalid
    # Handle duplicate email addresses gracefully by redirecting.
    redirect_to home_url
  rescue ActionController::InvalidAuthenticityToken
    # Experience has shown that the vast majority of these are bots
    # trying to spam the system, so catch & log the exception.
    warning = "ActionController::InvalidAuthenticityToken: #{params.inspect}"
    logger.warn warning
    redirect_to home_url
  end

  def verify_email
    person = Person.find_using_perishable_token(params[:id])
    unless person
      flash[:error] = t('error_invalid_email_verification_code')
      redirect_to home_url
    else
      person.email_verified = true
      person.save!
      if Person.global_prefs.whitelist?
        flash[:success] = t('success_email_verified_whitelist')
      else
        flash[:success] = t('success_email_verified')
      end
      redirect_to login_url
    end
  end

  def edit
    @category = Category.new
    @all_categories = Category.find(:all, :order => "parent_id, name").sort_by { |a| a.long_name }
    @all_neighborhoods = Neighborhood.find(:all, :order => "parent_id, name").sort_by { |a| a.long_name }
    respond_to do |format|
      format.html
    end
  end

  def update
    if cancel?
      flash[:notice] = "#{CGI.escapeHTML @person.display_name} " + t('cancelled')
      redirect_to person_path(@person)
      return
    end

    unless(params[:task].blank?)
      @person.toggle!(params[:task])
      if 'deactivated' == params[:task]
        @person.update_attributes!(:sponsor => current_person)
      end
      flash[:success] = "#{CGI.escapeHTML @person.display_name} " + t('success_updated')
      redirect_to person_path(@person)
      return
    end

    case params[:type]
    when 'info_edit'
      respond_to do |format|
        if @person.update_attributes(person_params)
          flash[:success] = t('success_profile_updated')
          format.html { redirect_to(@person) }
        else
          @all_categories = Category.find(:all, :order => "parent_id, name").sort_by { |a| a.long_name }
          @all_neighborhoods = Neighborhood.find(:all, :order => "parent_id, name").sort_by { |a| a.long_name }
          format.html { render :action => "edit" }
        end
      end
    when 'password_edit'
      if global_prefs.demo?
        flash[:error] = t('error_password_cant_be_changed')
        redirect_to @person and return
      end
      respond_to do |format|
        if @person.change_password?(params[:person])
          flash[:success] = t('success_password_changed')
          format.html { redirect_to(@person) }
        else
          @all_categories = Category.find(:all, :order => "parent_id, name").sort_by { |a| a.long_name }
          @all_neighborhoods = Neighborhood.find(:all, :order => "parent_id, name").sort_by { |a| a.long_name }
          format.html { render :action => "edit" }
        end
      end
      #when 'openid_edit'
    else
      @person.attributes = person_params
      @person.save do |result|
        respond_to do |format|
          if result
            flash[:success] = t('success_profile_updated')
            format.html { redirect_to(@person) }
            format.js
          else
            @all_categories = Category.find(:all, :order => "parent_id, name").sort_by { |a| a.long_name }
            @all_neighborhoods = Neighborhood.find(:all, :order => "parent_id, name").sort_by { |a| a.long_name }
            format.html { render :action => "edit" }
            format.js
          end
        end
      end
    end
  end

  def invite
    @person = Person.find(params[:id])
    @groups = current_person.own_groups
  end

  def send_invite
    @person = Person.find(params[:id])
    @group = Group.find(params[:group_id])
    if Membership.mem(@person,@group).nil?
      Membership.invite(@person,@group)
      flash[:success] = "Invitation sent"
    end
    redirect_to person_path(@person)
  end

  def su
    @person = Person.find(params[:id])
    if can?(:su, @person)
      session[:su_person] = current_person.id
      @person_session = PersonSession.create(@person)
    else
      flash[:error] = t('error_admin_access_required')
    end

    respond_to do |format|
      format.html { redirect_to(@person) }
    end
  end

  def unsu
    if(session.has_key?(:su_person))
      @person_session = PersonSession.create(Person.find session[:su_person])
      session.delete :su_person
    else
      flash[:error] = t('error_account_locate')
    end
    redirect_to '/'
  end

  private
    def correct_person_required
      @person = Person.find(params[:id])
      unless(params[:task].blank?)
        can_change_status = case params[:task]
        when 'deactivated'
          current_person.admin? || (global_prefs.whitelist? && current_person.activator?)
        when 'activator'
          current_person.admin?
        end
        flash[:error] = t('error_admin_access_required') unless can_change_status
        redirect_to person_path(@person) unless can_change_status
      else
        redirect_to home_url unless ( current_person.admin? or Person.find(params[:id]) == current_person )
      end
    end

    def cancel?
      params["commit"] == t('button_cancel');
    end

    def person_params
      params.require(:person).permit(:email, :password, :password_confirmation, :name, :business_name, :legal_business_name, :business_type_id, :title, :activity_status_id, :plan_type_id, :support_contact_id, :description, :connection_notifications, :message_notifications, :category_ids, :address_ids, :neighborhood_ids, :zipcode, :phone, :phoneprivacy, :accept_agreement, :language, :time_zone, :date_style, :openid_identifier, :sponsor, :broadcast_emails, :web_site_url, :org, :posts_per_page, :deactivated)
    end
end
