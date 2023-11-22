class UserMailer < ApplicationMailer
  default from:"noreply@ohmydogapp.com"
  def notify_by_email(name, lastname, phone, mail, dogname, dogmail) #es para adoptar
    @name= name
    @lastname= lastname
    @phone= phone
    @mail= mail
    asunto= name + ' quiere contactarse para adoptar a ' + dogname + '!'
    mail(to: dogmail, subject: asunto)
  end

  def caregiver_notify_by_email(name, surname, phoneNum, email, caremail, mensaje)
    @name= name
    @lastname= surname
    @phone= phoneNum
    @mail= email
    @mensaje= mensaje
    asunto= name + ' quiere contactarse para solicitar tus servicios de CUIDADO canino!'
    mail(to: caremail, subject: asunto)
  end

  def walker_notify_by_email(name, surname, phoneNum, email, walkmail, mensaje)
    @name= name
    @lastname= surname
    @phone= phoneNum
    @mail= email
    @mensaje= mensaje
    asunto= name + ' quiere contactarse para solicitar tus servicios de PASEO canino!'
    mail(to: walkmail, subject: asunto)
  end

end
