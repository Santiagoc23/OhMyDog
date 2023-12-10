class MedicalStoriesController < ApplicationController
  before_action :set_medical_story, only: %i[ show edit update destroy ]

  # GET /medical_stories or /medical_stories.json
  def index
    if params[:dog_id].present?
      @dogData = Dog.find(params[:dog_id])
      @vacunasDog = Vacuna.select { |vacuna| vacuna.dog_id.to_i == params[:dog_id].to_i }
      @vacunasDog = @vacunasDog.sort_by(&:fechaAct)
    end
  end
  
  def downloadHC
    @dogData = Dog.find(params[:dog_id])
    @vacunasDog = Vacuna.select { |vacuna| vacuna.dog_id.to_i == params[:dog_id].to_i }
    @vacunasDog = @vacunasDog.sort_by(&:fechaAct)
  
    pdf = Prawn::Document.new
  
    respond_to do |format|
      format.pdf do
        pdf.text 'Historia clínica canina', size: 23, style: :bold
        pdf.move_down 20  

        pdf.text 'Datos del perro:', size: 15, style: :bold
        pdf.move_down 5
        pdf.text "Nombre: #{@dogData.name}"
        pdf.text "Raza: #{@dogData.breed}"
        pdf.text "Sexo: #{@dogData.gender}"
        pdf.text "Edad: #{@dogData.age}"
        pdf.text "Fecha de nacimiento: #{@dogData.birthdate.strftime('%d/%m/%Y')}"
  
        pdf.move_down 20
        pdf.text 'Listado de las consultas:', size: 15, style: :bold
  
        pdf.move_down 5

  @vacunasDog.each do |vacuna|
        pdf.text "Fecha de consulta: #{vacuna.fechaAct.strftime('%Y-%m-%d')}"
        pdf.text "Tipo de consulta: #{vacuna.tipoVacuna}"
        pdf.text "Peso de #{@dogData.name}: #{vacuna.peso}"
        pdf.text "Descripcion de la consulta: #{vacuna.description}"
        pdf.move_down 15
  end
          send_data(pdf.render, filename: 'historia_clinica.pdf', type: 'application/pdf')
        end
      end
    end
  
  # GET /medical_stories/1 or /medical_stories/1.json
  def show
  end

  # GET /medical_stories/new
  def new
    @medical_story = MedicalStory.new
  end

  # GET /medical_stories/1/edit
  def edit
  end

  # POST /medical_stories or /medical_stories.json
  def create
    @medical_story = MedicalStory.new(medical_story_params)

    respond_to do |format|
      if @medical_story.save
        format.html { redirect_to medical_story_url(@medical_story), notice: "Medical story was successfully created." }
        format.json { render :show, status: :created, location: @medical_story }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @medical_story.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /medical_stories/1 or /medical_stories/1.json
  def update
    respond_to do |format|
      if @medical_story.update(medical_story_params)
        format.html { redirect_to medical_story_url(@medical_story), notice: "Medical story was successfully updated." }
        format.json { render :show, status: :ok, location: @medical_story }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @medical_story.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /medical_stories/1 or /medical_stories/1.json
  def destroy
    @medical_story.destroy

    respond_to do |format|
      format.html { redirect_to medical_stories_url, notice: "Medical story was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_medical_story
      @medical_story = MedicalStory.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def medical_story_params
      modified_params = params.require(:medical_story).permit()
    end
end
