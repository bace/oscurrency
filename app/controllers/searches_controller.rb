class SearchesController < ApplicationController
  include ApplicationHelper

  # see app/helpers/searches_helper.rb
  #SEARCHABLE_CLASSES = [Person, Req, Offer, Message, ForumPost, Category, Group]
  SEARCHABLE_CLASSES = [Person, Req, Offer, ForumPost, Category, Group]

  before_filter :login_required

  def index
    
    redirect_to(home_url) and return if params[:q].nil?
    
    query = params[:q].strip
    model = params[:model]
    klass = nil
    if !model.blank?
      begin
        klass = model.constantize
      rescue NameError => e
        klass = nil
      end
      unless SEARCHABLE_CLASSES.include?(klass)
       flash[:error] = "Invalid search"
       redirect_to home_url and return
      end
    end
    page  = params[:page] || 1

    @results = []
    for klass in klass ? [klass] : SEARCHABLE_CLASSES
      @results.concat(klass.search(query))
    end
    # I'd like to sort the list here, but each search comes back rank ordered and I hate to throw that away...we could sort by time though

    @page_results = @results.paginate(:page=> page, :per_page => 10)
  end
  
  private
    
end
