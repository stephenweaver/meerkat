class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    omni = request.env["omniauth.auth"]
    user = User.from_omniauth(omni)
    auth = Authentication.from_omniauth(omni)
    if user.persisted?
      flash.notice = "Signed in!"
      sign_in_and_redirect user
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to new_user_registration_url
    end
  end
  alias_method :twitter, :all
  
  def facebook
     
     user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

     if user.persisted?
       sign_in_and_redirect user, :event => :authentication #this will throw if @user is not activated
       set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
     else
       session["devise.user_attributes"] = user.attributes
       redirect_to new_user_registration_url
     end
   end
end