class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] =
        t("pages.reset_password.message_password_reset_instructions")
      redirect_to root_url
    else
      flash.now[:danger] = t("pages.reset_password.message_email_not_found")
      render :new
    end
  end

  def edit; end

  def update
    if user_params[:password].empty?
      @user.errors.add(:password, t("pages.reset_password.message_not_empty"))
      render :edit
    elsif @user.update user_params
      log_in @user
      flash[:success] = t("pages.reset_password.message_reset_password_success")
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def get_user
    @user = User.find_by email: params[:email]
    return if @user

    flash.now[:danger] = t("pages.signup.message_nil")
    redirect_to root_url
  end

  def valid_user
    return if @user.activated && @user.authenticated?(:reset, params[:id])

    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t("pages.reset_password.message_password_reset_expired")
    redirect_to new_password_reset_url
  end
end
