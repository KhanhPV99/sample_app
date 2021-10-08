class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate(params[:session][:password])
      check_activated user
    else
      flash.now[:danger] = t "pages.log_in.invalid_email_or_password"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  private

  def check_activated user
    if user.activated
      log_in user
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash[:warning] = t "pages.send_mail.message_not_activated"
      redirect_to root_url
    end
  end
end
