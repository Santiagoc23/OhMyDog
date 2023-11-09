class AppointmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_appointment, only: %i[ edit update destroy confirm_delete confirm_cancel update_cancel]

  # GET /appointments or /appointments.json
  def index
    if current_user.role == 'user'
      Appointment.where("time < ?", DateTime.now).destroy_all
      @appointments = Appointment.order(:time)
    else
      redirect_to dashboard_home_path
    end
  end

  def index_requests
    if current_user.admin?
      Appointment.where("time < ?", DateTime.now).destroy_all
      #@appointments = Appointment.order(:time)
      @appointments = Appointment.where.not(state: [1, 4]).order(time: :asc)
    else
      redirect_to dashboard_home_path
    end
  end

  def index_confirmed
    if current_user.admin?
      Appointment.where("time < ?", DateTime.now).destroy_all
      @appointments = Appointment.where(state: [1]).order(time: :asc)
    else
      redirect_to dashboard_home_path
    end
  end

  # GET /appointments/1 or /appointments/1.json
  def show
    if current_user.role == 'user'
      begin
        @appointment = Appointment.find(params[:id])
        # Resto del código para mostrar la vista
      rescue ActiveRecord::RecordNotFound
        flash[:alert] = "El turno solicitado no existe o ha sido eliminado."
        redirect_to appointments_path
      end
    else
      redirect_to dashboard_home_path
    end
  end

  def show_request
    if current_user.admin?
      begin
        @appointment = Appointment.find(params[:id])
        # Resto del código para mostrar la vista
      rescue ActiveRecord::RecordNotFound
        flash[:alert] = "El turno solicitado no existe o ha sido eliminado."
        redirect_to requests_path # O cualquier otra acción que desees
      end
    else
      redirect_to dashboard_home_path
    end
    
  end

  def show_confirmed
    if current_user.admin?
      begin
        @appointment = Appointment.find(params[:id])
        # Resto del código para mostrar la vista
      rescue ActiveRecord::RecordNotFound
        flash[:alert] = "El turno solicitado no existe o ha sido eliminado."
        redirect_to confirmed_path # O cualquier otra acción que desees
      end
    else
      redirect_to dashboard_home_path
    end
  end

  def confirm_user_edit
    if current_user.admin?
      @appointment = Appointment.find(params[:id])
      @appointment.update(state: 1)
      redirect_to requests_path
    else
      redirect_to dashboard_home_path
    end
  end

  def confirm_admin_edit
    if current_user.role == 'user'
      @appointment = Appointment.find(params[:id])
      @appointment.update(state: 1)
      redirect_to appointments_path
    else
      redirect_to dashboard_home_path
    end
  end

  def confirm_cancel
    if current_user.admin?
      @from = params[:source]
    else
      redirect_to dashboard_home_path
    end
  end

  # GET /appointments/new
  def new
    if current_user.role == 'user'
      @appointment = Appointment.new
     else
      redirect_to dashboard_home_path
    end
  end

  # GET /appointments/1/edit
  def edit
    @from = params[:source]
  end

  # POST /appointments or /appointments.json
  def create
    @appointment = Appointment.new(appointment_params)
    @appointment.user_id = current_user.id 
    respond_to do |format|
      if @appointment.save
        format.html { redirect_to appointment_url(@appointment), notice: "Solicitud de turno enviada, espere la confirmacion desde la veterinaria." }
        format.json { render :show, status: :created, location: @appointment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /appointments/1 or /appointments/1.json
  def update
    respond_to do |format|
      ant= @appointment.state

      if params[:appointment][:source] == "request" #el admin quiere actualizar
        @appointment.state= 3

        if @appointment.update(appointment_params)
          format.html { redirect_to requests_path, notice: "Turno actualizado, espere la confirmación." }
          format.json { render :show, status: :ok, location: @appointment }
        else
          @appointment.state= ant 

          # set value for @source here, ex:
          @source = params[:appointment][:source]

          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @appointment.errors, status: :unprocessable_entity }
        end

      elsif params[:appointment][:source] == "confirmed"
          @appointment.state= 3

          if @appointment.update(appointment_params)
            format.html { redirect_to confirmed_path, notice: "Turno actualizado, espere la confirmación." }
            format.json { render :show, status: :ok, location: @appointment }
          else
            @appointment.state= ant #vuelve al estado anterior porque algo salió mal
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @appointment.errors, status: :unprocessable_entity }
          end

      elsif params[:appointment][:source] == "user"
        if @appointment.state==1 || @appointment.state==3 #el usuario quiere actualizar (solo se pone en reprog si estaba confirm o repr por vete)
          @appointment.state= 2
        end

        if @appointment.update(appointment_params)
          format.html { redirect_to appointment_url(@appointment), notice: "Turno actualizado, espere la confirmación." }
          format.json { render :show, status: :ok, location: @appointment }
        else
          @appointment.state= ant 

          # set value for @source here, ex:
          @source = params[:appointment][:source]

          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @appointment.errors, status: :unprocessable_entity }
        end

      elsif params[:appointment][:source] == "cancel_from_request" #actualizacion para cancelar desde solicitudes por el admin
        @appointment.state = 4
        @appointment.update(appointment_params)
        format.html { redirect_to requests_path, notice: "Turno cancelado." }
      elsif params[:appointment][:source] == "cancel_from_confirmed" #actualizacion para cancelar desde confirmados por el admin
        @appointment.state = 4
        @appointment.update(appointment_params)
        format.html { redirect_to confirmed_path, notice: "Turno cancelado." }
      end
    end
  end

  # DELETE /appointments/1 or /appointments/1.json
  def destroy
    if current_user.role == 'user'
      @appointment.destroy
      respond_to do |format|
        format.html { redirect_to appointments_url, notice: "Turno eliminado." }
        format.json { head :no_content }
      end
    else
      redirect_to dashboard_home_path
    end
  end

  def confirm_delete

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def appointment_params
      params.require(:appointment).permit(:time, :state, :message, :user_id)
    end
end
