class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: @user.email, subject: t("pages.send_mail.account_activation")
  end

  def password_reset user
    @user = user
    mail to: @user.email, subject: t("pages.reset_password.password_reset")
  end
end
