class UserMailer < ApplicationMailer
  # default from: 'noreplylienexpos@gmail.com'
  default from: 'cucseaa@gmail.com'
  layout 'mailer'

  def welcome_email(user)
    @user = user
    @url  = root_url
    mail(to: @user.email, subject: 'Welcome to test email!')
  end
end
