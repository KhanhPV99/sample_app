class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = t("pages.signup.message_success")
      redirect_to @user
    else
      flash.now[:danger] = t("pages.signup.message_fail")
      render :new
    end
  end

  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash.now[:danger] = t("pages.signup.message_nil")
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit User::SIGNUP_ATTRS
  end
end
