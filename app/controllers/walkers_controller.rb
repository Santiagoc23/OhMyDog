class WalkersController < ApplicationController
  before_action :authenticate_user!, except: [:index_user, :solicitar]
  before_action :set_walker, only: %i[ show edit update destroy]
  before_action :authenticate_admin, only: [:index, :show, :new, :edit, :create, :update, :destroy, :confirm_delete]
  before_action :only_user, only: [:reportar]


  # GET /walkers or /walkers.json
  def index
    @walkers = Walker.all
  end

  def index_user
    @walkers = Walker.all
  end

  # GET /walkers/1 or /walkers/1.json
  def show
  end

  # GET /walkers/new
  def new
    @walker = Walker.new
  end

  # GET /walkers/1/edit
  def edit
  end

  # POST /walkers or /walkers.json
  def create
    @walker = Walker.new(walker_params)

    respond_to do |format|
      if @walker.save
        format.html { redirect_to walker_url(@walker), notice: "Paseador creado exitosamente." }
        format.json { render :show, status: :created, location: @walker }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @walker.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /walkers/1 or /walkers/1.json
  def update
    respond_to do |format|
      if @walker.update(walker_params)
        format.html { redirect_to walker_url(@walker), notice: "Paseador editado exitosamente." }
        format.json { render :show, status: :ok, location: @walker }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @walker.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /walkers/1 or /walkers/1.json
  def destroy
    @walker.destroy
    respond_to do |format|
      format.html { redirect_to walkers_url, notice: "Paseador eliminado exitosamente." }
      format.json { head :no_content }
    end
  end

  def confirm_delete
    @walker = Walker.find(params[:id])
  end

  def reportar
    @walker = Walker.find(params[:id])
    user = User.find(current_user.id)
    @name = user.name
    @lastname = user.surname
    @phone = user.phoneNum
    @mail = user.email
    if request.post?
      current_user.reported_walkers << @walker
      current_user.save
      modified_name = params[:name]
      modified_lastname = params[:lastname]
      modified_phone = params[:phone]
      modified_mail = params[:mail]
      mensaje= params[:mensaje]
      omd_notifications_mail= "vete0hmydog@gmail.com"

      dni = user.dni
      AdminMailer.walker_report_by_email(@walker, modified_name, modified_lastname, modified_phone, modified_mail, omd_notifications_mail, mensaje, dni).deliver_later

      redirect_to index_user_walker_path, notice: 'Reporte enviado.'
    end
  end

  def solicitar
    @walker = Walker.find(params[:id])
    if user_signed_in?
      user = User.find(current_user.id)
      dni = user.dni
      @name = user.name
      @lastname = user.surname
      @phone = user.phoneNum
      @mail = user.email
    else
      @name = " "
      @lastname = " "
      @phone = " "
      @mail = " "
    end

    if request.post?
      if user_signed_in?
        current_user.walkers << @walker
        current_user.save
      end
      modified_name = params[:name]
      modified_lastname = params[:lastname]
      modified_phone = params[:phone]
      modified_mail = params[:mail]
      walkmail= @walker.email
      mensaje= params[:mensaje]
      omd_notifications_mail= "vete0hmydog@gmail.com"

      UserMailer.walker_notify_by_email(modified_name, modified_lastname, modified_phone, modified_mail, walkmail, mensaje).deliver_later
      AdminMailer.walker_notify_by_email(@walker, modified_name, modified_lastname, modified_phone, modified_mail, omd_notifications_mail, mensaje, dni).deliver_later

      redirect_to index_user_walker_path, notice: 'Servicio solicitado exitosamente, espere el contacto a traves de su correo electrónico o teléfono!'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_walker
      @walker = Walker.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def walker_params
      params.require(:walker).permit(:name, :surname, :phoneNum, :email, :zone, :start, :end)
    end
end
