class Mailer < ActionMailer::Base
  default from: "from@example.com"
  
  def send_login_email(user, url)
    @url = url
    mail(:to => user.email, :subject => "The Comparitor: Login Information")
  end
end
