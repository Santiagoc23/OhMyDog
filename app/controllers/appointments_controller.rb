class AppointmentsController < ApplicationController
  before_action :set_appointment, only: %i[ edit update destroy confirm_delete confirm_cancel update_cancel]

  # GET /appointments or /appointments.json
  def index
    Appointment.where("time < ?", DateTime.now).destroy_all
    @appointments = Appointment.order(:time)
  end

  def index_requests
    Appointment.where("time < ?", DateTime.now).destroy_all
    @appointments = Appointment.order(:time)
  end

  def index_confirmed
    Appointment.where("time < ?", DateTime.now).destroy_all
    @appointments = Appointment.order(:time)
  end

  # GET /appointments/1 or /appointments/1.json
  def show
    begin
      @appointment = Appointment.find(params[:id])
      # Resto del código para mostrar la vista
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "El turno solicitado no existe o ha sido eliminado."
      redirect_to appointments_path
    end
  end

  def show_request
    begin
      @appointment = Appointment.find(params[:id])
      # Resto del código para mostrar la vista
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "El turno solicitado no existe o ha sido eliminado."
      redirect_to requests_path # O cualquier otra acción que desees
    end
  end

  def show_confirmed
    begin
      @appointment = Appointment.find(params[:id])
      # Resto del código para mostrar la vista
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "El turno solicitado no existe o ha sido eliminado."
      redirect_to confirmed_path # O cualquier otra acción que desees
    end
  end

  def confirm_user_edit
    @appointment = Appointment.find(params[:id])
    @appointment.update(state: 1)
    redirect_to requests_path
  end

  def confirm_admin_edit
    @appointment = Appointment.find(params[:id])
    @appointment.update(state: 1)
    redirect_to appointments_path
  end

  def confirm_cancel
    @from = params[:source]
  end

  # GET /appointments/new
  def new
    @appointment = Appointment.new
  end

  # GET /appointments/1/edit
  def edit
    @from = params[:source]
  end

  # POST /appointments or /appointments.json
  def create
    @appointment = Appointment.new(appointment_params)
    @appointment.user_id = 1 #1 VA DE EJEMPLO, ACA VA EL COMANDO PARA CONSEGUIR EL USUARIO AUTOMATICAMENTE DEL QUE LO CREA
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
          @appointment.state= ant #vuelve al estado anterior porque algo salió mal
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
          @appointment.state= ant #vuelve al estado anterior porque algo salió mal
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
    @appointment.destroy

    respond_to do |format|
      format.html { redirect_to appointments_url, notice: "Turno eliminado." }
      format.json { head :no_content }
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
