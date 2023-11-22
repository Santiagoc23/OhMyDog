class CaregiversController < ApplicationController
  before_action :authenticate_user!
  before_action :set_caregiver, only: %i[ show edit update destroy ]
  before_action :authenticate_admin, only: [:index, :show, :new, :edit, :create, :update, :destroy]

  # GET /caregivers or /caregivers.json
  def index
    @caregivers = Caregiver.all
  end

  def index_user
    @caregivers = Caregiver.all
  end

  # GET /caregivers/1 or /caregivers/1.json
  def show
  end

  # GET /caregivers/new
  def new
    @caregiver = Caregiver.new
  end

  # GET /caregivers/1/edit
  def edit
  end

  # POST /caregivers or /caregivers.json
  def create
    @caregiver = Caregiver.new(caregiver_params)

    respond_to do |format|
      if @caregiver.save
        format.html { redirect_to caregiver_url(@caregiver), notice: "Cuidador creado exitosamente." }
        format.json { render :show, status: :created, location: @caregiver }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @caregiver.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /caregivers/1 or /caregivers/1.json
  def update
    respond_to do |format|
      if @caregiver.update(caregiver_params)
        format.html { redirect_to caregiver_url(@caregiver), notice: "Cuidador editado exitosamente." }
        format.json { render :show, status: :ok, location: @caregiver }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @caregiver.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /caregivers/1 or /caregivers/1.json
  def destroy
    @caregiver.destroy
    respond_to do |format|
      format.html { redirect_to caregivers_url, notice: "Cuidador eliminado exitosamente." }
      format.json { head :no_content }
    end
  end

  def reportar
    @caregiver = Caregiver.find(params[:id])
    user = User.find(current_user.id)
    @name = user.name
    @lastname = user.surname
    @phone = user.phoneNum
    @mail = user.email
    if request.post?
      modified_name = params[:name]
      modified_lastname = params[:lastname]
      modified_phone = params[:phone]
      modified_mail = params[:mail]
      mensaje= params[:mensaje]
      omd_notifications_mail= "vete0hmydog@gmail.com"

      dni = user.dni
      AdminMailer.caregiver_report_by_email(@caregiver, modified_name, modified_lastname, modified_phone, modified_mail, omd_notifications_mail, mensaje, dni).deliver_later

      redirect_to index_user_caregiver_path, notice: 'Reporte enviado.'
    end
  end

  def solicitar
    @caregiver = Caregiver.find(params[:id])
    user = User.find(current_user.id)
    @name = user.name
    @lastname = user.surname
    @phone = user.phoneNum
    @mail = user.email

    if request.post?
      current_user.caregivers << @caregiver
      current_user.save
      modified_name = params[:name]
      modified_lastname = params[:lastname]
      modified_phone = params[:phone]
      modified_mail = params[:mail]
      caremail= @caregiver.email
      mensaje= params[:mensaje]
      omd_notifications_mail= "vete0hmydog@gmail.com"

      UserMailer.caregiver_notify_by_email(modified_name, modified_lastname, modified_phone, modified_mail, caremail, mensaje).deliver_later
      dni = user.dni
      AdminMailer.caregiver_notify_by_email(@caregiver, modified_name, modified_lastname, modified_phone, modified_mail, omd_notifications_mail, mensaje, dni).deliver_later

      redirect_to index_user_caregiver_path, notice: 'Servicio solicitado exitosamente, espere el contacto a traves de su correo electrónico o teléfono!'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_caregiver
      @caregiver = Caregiver.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def caregiver_params
      params.require(:caregiver).permit(:name, :surname, :phoneNum, :email, :zone, :services)
    end


end
