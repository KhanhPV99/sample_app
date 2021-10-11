class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create)
  before_action :load_user, except: %i(new create index)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users =
      User.all.page(params[:page]).per(Settings.validations.length.digit_20)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "pages.send_mail.message_check_email"
      redirect_to root_url
    else
      flash.now[:danger] = t("pages.signup.message_fail")
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t("pages.edit_user.message_update_success")
      redirect_to @user
    else
      render :edit
    end
  end

  def show; end

  def destroy
    if @user&.destroy
      flash[:success] = t("pages.edit_user.delete_success")
    else
      flash[:danger] = t("pages.edit_user.delete_fail")
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit User::SIGNUP_ATTRS
  end

  # Before filters
  # Confirms a logged-in user
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t("pages.edit_user.please_log_in")
    redirect_to login_url
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash.now[:danger] = t("pages.signup.message_nil")
    redirect_to root_url
  end

  # Confirms the correct user.
  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
