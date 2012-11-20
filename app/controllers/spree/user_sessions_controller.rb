class Spree::UserSessionsController < Devise::SessionsController
  include Spree::Core::ControllerHelpers

  helper 'spree/users', 'spree/base'
  if defined?(Spree::Dash)
    helper 'spree/analytics'
  end

  ssl_required :new, :create, :destroy, :update
  ssl_allowed :login_bar

  def nav_bar
    render :partial => 'spree/shared/nav_bar'
  end

  protected  
  def after_sign_in_path_for(resource)
    respond_with(resource) do |format|
      format.html do
        flash.notice = t(:logged_in_succesfully)
        return_path = session["user_return_to"] || spree.root_path 
        session["user_return_to"] = nil
        return_path
      end
      format.js do
        user = resource.record
        render :json => {:ship_address => user.ship_address, :bill_address => user.bill_address}.to_json
      end
    end
  end

  def after_sign_out_path_for(resource)
    spree.root_path
  end

  private
  def accurate_title
    t(:login)
  end
end
