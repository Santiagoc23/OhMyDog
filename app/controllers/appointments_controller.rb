class AppointmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_appointment, only: %i[ edit update destroy confirm_delete confirm_cancel update_cancel]

  # GET /appointments or /appointments.json
  def index
    if current_user.role == 'user'
      Appointment.where("time < ?", DateTime.now).destroy_all
      @appointments = current_user.appointments.order(:time)
    else
      redirect_to dashboard_home_path
    end
  end

  def index_requests
    if current_user.admin?
      Appointment.where("time < ?", DateTime.now).destroy_all
      #@appointments = Appointment.order(:time)
      @appointments = Appointment.where.not(state: [1, 4, 5, 44]).order(time: :asc)

      @ux1= Appointment.where("DATE(time) = ? AND state = ?", Date.today, 0).count
      @ux2= Appointment.where("DATE(time) = ? AND state = ?", Date.today, 2).count
      @ux3= Appointment.where("DATE(time) = ? AND state = ?", Date.today, 3).count
      @dx1= Appointment.where("DATE(time) = ? AND state = ?", Date.tomorrow, 0).count
      @dx2= Appointment.where("DATE(time) = ? AND state = ?", Date.tomorrow, 2).count
      @dx3= Appointment.where("DATE(time) = ? AND state = ?", Date.tomorrow, 3).count
      @tx1= Appointment.where("DATE(time) = ? AND state = ?", Date.tomorrow + 1, 0).count
      @tx2= Appointment.where("DATE(time) = ? AND state = ?", Date.tomorrow + 1, 2).count
      @tx3= Appointment.where("DATE(time) = ? AND state = ?", Date.tomorrow + 1, 3).count

    else
      redirect_to dashboard_home_path
    end
  end

  def index_confirmed
    if current_user.admin?
      Appointment.where("time < ?", DateTime.now).destroy_all

      @ux1= Appointment.where("DATE(time) = ? AND state = ?", Date.today, 1).count
      @ux2= Appointment.where("DATE(time) = ? AND state = ?", Date.tomorrow, 1).count
      @ux3= Appointment.where("DATE(time) = ? AND state = ?", Date.tomorrow + 1, 1).count
      @ux4= Appointment.where("DATE(time) = ? AND state = ?", Date.tomorrow + 2, 1).count
      @ux5= Appointment.where("DATE(time) = ? AND state = ?", Date.tomorrow + 3, 1).count

      @appointments = Appointment.where(state: [1, 5, 4]).order(time: :asc)
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
      if @appointment.state == 0
        @appointment.update(state: 1)
      else
        @appointment.update(state: 5)
      end
      redirect_to requests_path
      flash[:notice] = "Turno confirmado"
      vacuna = Vacuna.new(
        fechaAct: @appointment.time,
        tipoVacuna: @appointment.query_type,
        dog_id: @appointment.dog_id,
      )
      vacuna.save
      vacuna
      redirect_to appointments_path
    else
      redirect_to dashboard_home_path
    end
  end

  def confirm_admin_edit
    if current_user.role == 'user'
      @appointment = Appointment.find(params[:id])
      @appointment.update(state: 5)
      vacuna = Vacuna.new(
        fechaAct: @appointment.time,
        tipoVacuna: @appointment.query_type,
        dog_id: @appointment.dog_id,
      )
      vacuna.save
      vacuna
      redirect_to appointments_path
    else
      redirect_to dashboard_home_path
    end
  end

  def remove_cancel
    @appointment = Appointment.find(params[:id])
    @appointment.update(state: 44)
    redirect_to confirmed_path
  end

  def confirm_cancel
    @from = params[:source]
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
    @appointment.dog_id = (@appointment.dog_id == 0) ? nil : @appointment.dog_id

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
      case params[:appointment][:source]
      when "request"
        @appointment.state = 3
        if @appointment.update(appointment_params)
          format.html { redirect_to (params[:appointment][:source] == "request") ? requests_path : confirmed_path, notice: "Turno actualizado, en espera de confirmación." }
          format.json { render :show, status: :ok, location: @appointment }
        else
          @source = params[:appointment][:source]
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @appointment.errors, status: :unprocessable_entity }
        end

      when "confirmed"

        @appointment.state= 3

        if @appointment.update(appointment_params)
          format.html { redirect_to confirmed_path, notice: "Turno actualizado, en espera de confirmación." }
          format.json { render :show, status: :ok, location: @appointment }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @appointment.errors, status: :unprocessable_entity }
        end

      when "user"
        if @appointment.state == 1 || @appointment.state == 3
          @appointment.state = 2
        end
        modified_params = appointment_params
        modified_params[:dog_id] = nil if modified_params[:dog_id].to_i == 0

        if @appointment.update(modified_params)
          format.html { redirect_to appointment_url(@appointment), notice: "Turno actualizado, en espera de confirmación." }
          format.json { render :show, status: :ok, location: @appointment }
        else
          @source = params[:appointment][:source]
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @appointment.errors, status: :unprocessable_entity }
        end

      when "cancel_from_user"
        if @appointment.state == 1
          @appointment.state = 4 #aparece en el listado de confirmados
        else
          @appointment.state = 44 #no aparece pq no estaba confirmado
        end
        @appointment.update(appointment_params)
        format.html { redirect_to appointments_path, notice: "Turno cancelado." }

      when "cancel_from_request"
        @appointment.state = 4
        @appointment.update(appointment_params)
        format.html { redirect_to requests_path, notice: "Turno cancelado." }

      when "cancel_from_confirmed"
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
      params.require(:appointment).permit(:time, :state, :message, :user_id, :query_type, :dog_id)
    end


end
