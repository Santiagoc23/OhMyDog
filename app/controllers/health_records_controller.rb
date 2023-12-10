class HealthRecordsController < ApplicationController
  before_action :set_health_record, only: %i[ show edit update destroy ]

  # GET /health_records or /health_records.json

  def index
    if params[:dog_id].present?
      @dogData = Dog.find(params[:dog_id])
      @vacunasDog = Vacuna.select { |vacuna| vacuna.dog_id.to_i == params[:dog_id].to_i }
      @vacunasDog = @vacunasDog.sort_by(&:fechaAct)
    end
  end
  
  def downloadLS
    @dogData = Dog.find(params[:dog_id])
    @vacunasDog = Vacuna.select { |vacuna| vacuna.dog_id.to_i == params[:dog_id].to_i }
    @vacunasDog = @vacunasDog.sort_by(&:fechaAct)
  
    pdf = Prawn::Document.new
  
    respond_to do |format|
      format.pdf do
        pdf.text 'Libreta única sanitaria canina', size: 23, style: :bold
        pdf.move_down 20  
 
        pdf.text 'Datos del perro:', size: 15, style: :bold
        pdf.move_down 5
        pdf.text "Nombre: #{@dogData.name}"
        pdf.text "Raza: #{@dogData.breed}"
        pdf.text "Sexo: #{@dogData.gender}"
        pdf.text "Edad: #{@dogData.age}"
        pdf.text "Fecha de nacimiento: #{@dogData.birthdate.strftime('%d/%m/%Y')}"
  
     
        pdf.move_down 20
        pdf.text 'Listado del plan de vacunación:', size: 15, style: :bold
  
  
        pdf.move_down 5


  @vacunasDog.each do |vacuna|
    if ((vacuna.tipoVacuna == "Vacunación tipo A (enfermedad)") || (vacuna.tipoVacuna == "Vacunación tipo B (antiparasitaria)") || (vacuna.tipoVacuna == "Vacunación tipo B (antirrábica)"))
      if vacuna.tipoVacuna == "Vacunación tipo A (enfermedad)"
        vacuna.fechaProx = @dogData.age < 4 ? vacuna.fechaAct + 21.days : vacuna.fechaAct + 1.year
      elsif vacuna.tipoVacuna == "Vacunación tipo B (antiparasitaria)" || vacuna.tipoVacuna == "Vacunación tipo B (antirrábica)"
        vacuna.fechaProx = vacuna.fechaAct + 1.year
      end
        pdf.text "Fecha de vacunación: #{vacuna.fechaAct.strftime('%Y-%m-%d')}"
        pdf.text "Tipo de vacuna: #{vacuna.tipoVacuna}"
        pdf.text "Peso de #{@dogData.name}: #{vacuna.peso}"
        pdf.text "Enfermedad: #{vacuna.enfermedad}"
        pdf.text "Cantidad de dosis: #{vacuna.dosis}"
        pdf.text "Medicación: #{vacuna.medicacion}"
        pdf.text "Próxima fecha de vacunación: #{vacuna.fechaProx.strftime('%Y-%m-%d')}"
        pdf.move_down 15
       end
    end.compact
          send_data(pdf.render, filename: 'libreta_sanitaria.pdf', type: 'application/pdf')
        end
      end
    end

  # GET /health_records/1 or /health_records/1.json
  def show
  end

  # GET /health_records/new
  def new
    @health_record = HealthRecord.new
  end

  # GET /health_records/1/edit
  def edit
  end

  # POST /health_records or /health_records.json
  def create
    @health_record = HealthRecord.new(health_record_params)

    respond_to do |format|
      if @health_record.save
        format.html { redirect_to health_record_url(@health_record), notice: "Health record was successfully created." }
        format.json { render :show, status: :created, location: @health_record }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @health_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /health_records/1 or /health_records/1.json
  def update
    respond_to do |format|
      if @health_record.update(health_record_params)
        format.html { redirect_to health_record_url(@health_record), notice: "Health record was successfully updated." }
        format.json { render :show, status: :ok, location: @health_record }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @health_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /health_records/1 or /health_records/1.json
  def destroy
    @health_record.destroy

    respond_to do |format|
      format.html { redirect_to health_records_url, notice: "Health record was successfully destroyed." }
      format.json { head :no_content }
    end
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_health_record
      @health_record = HealthRecord.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def health_record_params
      params.fetch(:health_record, {})
    end
end
