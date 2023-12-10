class AdminMailer < ApplicationMailer
  default from:"noreply@ohmydogapp.com"
  def notify_by_email(user, adoption, name, lastname, phone, mail, dogname, dogmail, dni) #es para adoptar
    @name= name
    @lastname= lastname
    @phone= phone
    @mail= mail
    @dni= dni
    @adoption= adoption
    @user= user
    asunto= '[CONTACTO] '+ name + ' quiere contactarse para adoptar a ' + dogname + '!'
    mail(to: dogmail, subject: asunto)
  end

  def contact_by_email(user, missing_post, name, lastname, phone, mail, dogname, dogmail, dni) #es para adoptar
    @name= name
    @lastname= lastname
    @phone= phone
    @mail= mail
    @dni= dni
    @missing_post= missing_post
    @user= user
    asunto= '[CONTACTO] '+ name + ' vio la publicación del extravió de ' + dogname + ' y quiere contactarse!'
    mail(to: dogmail, subject: asunto)
  end

  def caregiver_notify_by_email(caregiver, name, surname, phoneNum, email, vetemail, mensaje, dni)
    @name= name
    @lastname= surname
    @phone= phoneNum
    @mail= email
    @mensaje= mensaje
    @dni= dni
    @caregiver= caregiver
    asunto= '[CONTACTO] '+ name + ' quiere contactarse para solicitar un servicio de cuidado canino!'
    mail(to: vetemail, subject: asunto)
  end

  def caregiver_report_by_email(caregiver, name, surname, phoneNum, email, vetemail, mensaje, dni)
    @name= name
    @lastname= surname
    @phone= phoneNum
    @mail= email
    @mensaje= mensaje
    @dni= dni
    @caregiver= caregiver
    asunto= '[REPORTE] '+ name + ' está reportando al cuidador/a ' + caregiver.name + " " + caregiver.surname
    mail(to: vetemail, subject: asunto)
  end

  def walker_notify_by_email(walker, name, surname, phoneNum, email, vetemail, mensaje, dni)
    @name= name
    @lastname= surname
    @phone= phoneNum
    @mail= email
    @mensaje= mensaje
    @dni= dni
    @walker= walker
    asunto= '[CONTACTO] '+ name + ' quiere contactarse para solicitar un servicio de paseo canino!'
    mail(to: vetemail, subject: asunto)
  end

  def walker_report_by_email(walker, name, surname, phoneNum, email, vetemail, mensaje, dni)
    @name= name
    @lastname= surname
    @phone= phoneNum
    @mail= email
    @mensaje= mensaje
    @dni= dni
    @walker= walker
    asunto= '[REPORTE] '+ name + ' está reportando al paseador/a ' + walker.name + " " + walker.surname
    mail(to: vetemail, subject: asunto)
  end

end
