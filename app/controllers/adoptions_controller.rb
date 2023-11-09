class AdoptionsController < ApplicationController
  before_action :set_adoption, only: %i[ show edit update destroy ]

  # GET /adoptions or /adoptions.json
  def index
    @adoptions = Adoption.order(created_at: :desc) # MAS RECIENTE AL MAS VIEJO
    @finished_adoptions = @adoptions.select { |adoption| adoption.finished? }

    if @finished_adoptions.count >= 5
      @finished_adoptions = @finished_adoptions.sort_by { |adoption| adoption.confirmed_at }
      @finished_adoptions.reverse!
      excess_adoptions = @finished_adoptions[5..-1] # Obtén las adopciones adicionales
      excess_adoptions.each do |adoption|
        adoption.destroy
      end
    end
  end

  def confirm
    @adoption = Adoption.find(params[:id])
    @adoption.update(adoption_params)
    redirect_to @adoption
  end

  # GET /adoptions/1 or /adoptions/1.json
  def show

  end

  # GET /adoptions/new
  def new
    @adoption = Adoption.new
  end

  # GET /adoptions/1/edit
  def edit
  end

  # POST /adoptions or /adoptions.json
  def create
    @adoption = Adoption.new(adoption_params)

    respond_to do |format|
      if @adoption.save
        format.html { redirect_to adoption_url(@adoption), notice: "Adoption was successfully created." }
        format.json { render :show, status: :created, location: @adoption }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @adoption.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /adoptions/1 or /adoptions/1.json
  def update
    respond_to do |format|
      if @adoption.update(adoption_params)
        format.html { redirect_to adoption_url(@adoption), notice: "Adoption was successfully updated." }
        format.json { render :show, status: :ok, location: @adoption }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @adoption.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /adoptions/1 or /adoptions/1.json
  def destroy
    @adoption.destroy

    respond_to do |format|
      format.html { redirect_to adoptions_url, notice: "Adoption was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def solicitar
    @adoption = Adoption.find(params[:id])


    #NOTA IMPORTANTE, ACA HAY QUE CAMBIAR 2, QUE ES DE PRUEBA, POR EL ID DEL USUARIO ACTUAL, TAMBIEN TIENE QUE DETECTAR SI
    #NO ESTÁ REGISTRADO Y NO HACER EL FIND, EN SU LUGAR PONER LOS CAMPOS NAME, LASTNAME, PHONE Y MAIL VACIOS

    user = User.find(2)

    #ELEGÍ EVITAR VERIFICAR SI EL CORREO O EL TELEFONO SON UNICOS, ESTO PUEDE FILTRAR INFORMACION SOBRE QUIEN USA LA APLICACION
    #Y NO TENDRIA NINGUN OBJETIVO ESPECIAL


    @name = user.name
    @lastname = user.lastname
    @phone = user.phone
    @mail = user.mail
    if request.post?
      modified_name = params[:name]
      modified_lastname = params[:lastname]
      modified_phone = params[:phone]
      modified_mail = params[:mail]
      dogname= @adoption.name
      dogmail= User.find(@adoption.user_id).mail
      omd_notifications_mail= "vete0hmydog@gmail.com" #PREGUNTAR SI TIENEN ALGUNO

      UserMailer.notify_by_email(modified_name, modified_lastname, modified_phone, modified_mail, dogname, dogmail).deliver_now
      UserMailer.notify_by_email(modified_name, modified_lastname, modified_phone, modified_mail, dogname, omd_notifications_mail).deliver_now

      mensaje= 'Adopción solicitada exitosamente, espere el contacto!'
      redirect_to adoptions_path, notice: mensaje
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_adoption
      @adoption = Adoption.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def adoption_params
      params.require(:adoption).permit(:name, :race, :size, :sex, :description, :situation, :user_id, :finished, :confirmed_at)
    end

end
