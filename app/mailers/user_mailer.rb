class UserMailer < ActionMailer::Base
  default from: "hello@flickflow.me"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.reset_password_email.subject
  #
  def reset_password_email(user)
    @user = user
    
    mail to: @user.email, subject: 'Forgot your flickflow password?'
  end
end
