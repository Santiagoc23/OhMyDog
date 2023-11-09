class UserMailer < ApplicationMailer
  default from:"noreply@ohmydogapp.com"
  def notify_by_email(name, lastname, phone, mail, dogname, dogmail)
    @name= name
    @lastname= lastname
    @phone= phone
    @mail= mail
    asunto= name + ' quiere contactarse para adoptar a ' + dogname + '!'
    mail(to: dogmail, subject: asunto)
  end
end
