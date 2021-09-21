class SessionsController < ApplicationController
  before_action :load_user, only: :create

  def new; end

  def create
    check_authenticate @user
  end

  def destroy
    log_out
    redirect_to root_url
  end

  private

  def load_user
    @user = User.find_by email: params[:session][:email].downcase
    return if @user

    flash.now[:danger] = t("pages.log_in.invalid_email_or_password")
    render :new
  end

  def check_authenticate user
    if user.try(:authenticate, params[:session][:password])
      log_in user
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash.now[:danger] = t("pages.log_in.invalid_email_or_password")
      render :new
    end
  end
end
