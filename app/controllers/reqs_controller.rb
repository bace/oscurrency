class ReqsController < ApplicationController
  prepend_before_filter :login_required, :except =>[:index]
  before_filter :group_membership_required, :only => [:show], :if => :private_group_req?
  before_filter :correct_person_and_no_accept_required, :only => [ :edit, :update ]
  before_filter :correct_person_and_no_commitment_required, :only => [ :destroy ]

  # GET /reqs
  # GET /reqs.xml
  def index
    @reqs = Req.current_and_active_paginated(params[:page],params[:category_id])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reqs }
    end
  end

  # GET /reqs/1
  # GET /reqs/1.xml
  def show
    @bid = Bid.new
    @bid.estimated_hours = @req.estimated_hours

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @req }
    end
  end

  # GET /reqs/new
  # GET /reqs/new.xml
  def new
    @req = Req.new
    @all_categories = Category.all
    @groups = current_person.groups

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @req }
    end
  end

  # GET /reqs/1/edit
  def edit
    @req = Req.find(params[:id])
    @all_categories = Category.all
  end

  # POST /reqs
  # POST /reqs.xml
  def create
    @req = Req.new(params[:req])

    if @req.due_date.blank?
      @req.due_date = 7.days.from_now
    else
      @req.due_date += 1.day - 1.second # make due date at end of day
    end
    @req.person_id = current_person.id

    respond_to do |format|
      if @req.save
        flash[:notice] = 'Request was successfully created.'
        format.html { redirect_to(@req) }
        format.xml  { render :xml => @req, :status => :created, :location => @req }
      else
        @all_categories = Category.all
        @groups = current_person.groups
        format.html { render :action => "new" }
        format.xml  { render :xml => @req.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /reqs/1
  # PUT /reqs/1.xml
  def update
    @req = Req.find(params[:id])

#    @req.person_id = current_person.id

    respond_to do |format|
      if @req.update_attributes(params[:req])
        flash[:notice] = 'Request was successfully updated.'
        format.html { redirect_to(@req) }
        format.xml  { head :ok }
      else
        @all_categories = Category.all
        format.html { render :action => "edit" }
        format.xml  { render :xml => @req.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /reqs/1
  # DELETE /reqs/1.xml
  def destroy
    @req = Req.find(params[:id])
    @req.destroy

    respond_to do |format|
      format.html { redirect_to(reqs_url) }
      format.xml  { head :ok }
    end
  end 

  def private_group_req?
    @req = Req.find(params[:id])
    @req.group && @req.group.private?
  end

  private

  def group_membership_required
    #login_required
    redirect_to home_url unless @req.viewable?(current_person)
  end

  def correct_person_and_no_accept_required
    request = Req.find(params[:id])
    redirect_to home_url unless request.person == current_person
    redirect_to home_url if request.has_accepted_bid?
  end

  def correct_person_and_no_commitment_required
    request = Req.find(params[:id])
    redirect_to home_url unless request.person == current_person
    redirect_to home_url if request.has_commitment? || request.has_approved?
  end
end
