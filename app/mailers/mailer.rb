class Mailer < ActionMailer::Base
  default from: "rank-wiki@cs.purdue.edu"
  
  def send_login_email(user, url)
    @url = url
    @name = user.name
    mail(:to => user.email, :subject => "The Comparitor: Login Information")
  end
end
