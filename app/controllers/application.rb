# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include ExceptionNotifiable

  session :session_key => 'nines_inbox'

  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '6e39f6bfbad56fc8890e523d3df6b68d'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  def has_permission?
    if current_user == nil
      redirect_to ('/')
    end
  end

  def must_be_editor
    if current_user == nil || !current_user.is_editor
      redirect_to ('/')
      return false
    end
    return true
  end

#private
#  def local_request?
#    false
#  end
end
