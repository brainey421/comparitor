class Mailer < ActionMailer::Base
  default from: "thecomparitor@gmail.com"
  
  def send_login_email(user, url)
    @url = url
    mail(:to => user.email, :subject => "The Comparitor: Login Information")
  end
end
