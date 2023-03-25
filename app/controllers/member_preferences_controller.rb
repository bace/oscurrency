class MemberPreferencesController < ApplicationController
  before_action :login_required
  authorize_resource

  # GET /member_preferences/1
  # GET /member_preferences/1.xml
  def show
    @member_preference = MemberPreference.find(params[:id])
    @group = @member_preference.membership.group

    respond_to do |format|
      format.js {render :action => 'reject' if not request.xhr?}
    end
  end

  # GET /member_preferences/1/edit
  def edit
    @member_preference = MemberPreference.find(params[:id])
    @group = @member_preference.membership.group
    respond_to do |format|
      format.js {render :action => 'reject' if not request.xhr?}
    end
  end

  # PUT /member_preferences/1
  # PUT /member_preferences/1.xml
  def update
    @member_preference = MemberPreference.find(params[:id])
    @group = @member_preference.membership.group

    respond_to do |format|
      if @member_preference.update_attributes(member_preference_params)
        flash[:success] = t('success_preferences_updated')
        format.js
      else
        format.js { render :partial => "edit" }
      end
    end
  end

  private
    def member_preference_params
      params.require(:member_preference).permit!
    end
end
