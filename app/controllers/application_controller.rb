# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  helper_method :viewable_group?
  include AuthenticatedSystem
  include SharedHelper
  include PreferencesHelper
  include ExceptionNotifiable

  filter_parameter_logging :password

  before_filter  :require_activation,  :admin_warning
#  :create_page_view, 

  ActiveScaffold.set_defaults do |config|
    config.ignore_columns.add [ :created_at, :updated_at ]
  end

# auditing turned off for now because it is causing odd problems and uses lots of db space (mt 9/12/2010)
#  audit Req, Offer, Bid, Exchange, Account, Person, :only => [:create, :update, :destroy]

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '71a8c82e6d248750397d166001c5e308'

  protected
    def viewable_group?(group)
      group.public? or Membership.connected?(current_person,group) or current_person.admin?
    end

    def current_user
      current_person 
    end

    def authorized?
      logged_in? and ( current_person.active? or current_person.admin? )
    end
  private

    def admin_required
      unless current_person.admin?
        flash[:error] = "Admin access required"
        redirect_to home_url
      end
    end
  
    # no longer used
    # Create a Scribd-style PageView.
    # See http://www.scribd.com/doc/49575/Scaling-Rails-Presentation
    def create_page_view
      if request.format.html?
        #PageView.create(:person_id => session[:person_id],
        #                :request_url => request.request_uri,
        #                :ip_address => request.remote_ip,
        #                :referer => request.env["HTTP_REFERER"],
        #                :user_agent => request.env["HTTP_USER_AGENT"])
        if logged_in?
          # last_logged_in_at actually captures site activity, so update it now.
          current_person.last_logged_in_at = Time.now
          current_person.save
        end
      end
    end
  
    def require_activation
      if logged_in?
        unless current_person.active? or current_person.admin?
          redirect_to logout_url
        end
      end
    end
    
    # Warn the admin if his email address or password is still the default.
    def admin_warning
      if request.format.html?
        default_domain = "example.com"
        default_password = "admin"
        if logged_in? and current_person.admin? 
          if current_person.email =~ /@#{default_domain}$/
            flash[:notice] = %(Warning: your email address is still at 
              #{default_domain}.
              <a href="#{edit_person_path(current_person)}">Change it here</a>.)
          end
          if current_person.crypted_password == current_person.encrypt(default_password)
            flash[:error] = %(Warning: your password is still the default.
              <a href="#{edit_person_path(current_person)}">Change it here</a>.)          
          end
        end
      end
    end
end
