class VacunasController < ApplicationController
  before_action :set_vacuna, only: %i[ show edit update destroy ]

  # GET /vacunas or /vacunas.json
  def index
    @vacunas = Vacuna.all
  end

  # GET /vacunas/1 or /vacunas/1.json
  def show
  end

  # GET /vacunas/new
  def new
    @vacuna = Vacuna.new
  end

  # GET /vacunas/1/edit
  def edit
    @vacuna = Vacuna.find(params[:id])
  end
  
  def edit2
    @vacuna = Vacuna.find(params[:id])
  end
  
  def confirm_delete
    @vacuna = Vacuna.find(params[:id])
  end

  def confirm_delete2
    @vacuna = Vacuna.find(params[:id])
  end

  # POST /vacunas or /vacunas.json
  def create
    @vacuna = Vacuna.new(vacuna_params)
    respond_to do |format|
      if @vacuna.save
        format.html { redirect_to dogs_path, notice: "La consulta ha sido creada exitosamente." }
        format.json { render :show, status: :created, location: @vacuna }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @vacuna.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vacunas/1 or /vacunas/1.json
  def update
    respond_to do |format|
      if @vacuna.update(vacuna_params)
        format.html { redirect_to dogs_path, notice: "La vacuna ha sido editada exitosamente." }
        format.json { render :show, status: :ok, location: @vacuna }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @vacuna.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vacunas/1 or /vacunas/1.json
  def destroy
    @vacuna.destroy
    respond_to do |format|
      format.html { redirect_to dogs_path, notice: "La vacuna ha sido eliminada exitosamente." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vacuna
      @vacuna = Vacuna.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def vacuna_params
      params.require(:vacuna).permit(:fechaAct, :tipoVacuna, :peso, :enfermedad, :dosis, :medicacion, :fechaProx, :description, :dog_id, :age)
    end
end
