class DogsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin, except: [:index, :show]
  before_action :set_dog, only: %i[ show edit update destroy ]

  # GET /dogs or /dogs.json
  def index
    if current_user.admin?
      @dogs = if params[:dni_search].present?
                Dog.joins(:user).where(users: {dni: params[:dni_search]})
              else
                Dog.all
              end
    else
      @user = User.find(current_user.id)
      @dogs = @user.dogs
    end
  end

  def index_user_dogs
    @user = User.find(params[:id])
    @dogs = @user.dogs
  end

  # GET /dogs/1 or /dogs/1.json
  def show
  end

  # GET /dogs/new
  def new
    @dog = Dog.new
  end

  # GET /dogs/1/edit
  def edit
  end

  # POST /dogs or /dogs.json
  def create
    # Encuentra el usuario utilizando el DNI de los parámetros
    user = User.find_by(dni: params[:dog][:dni])
    # Excluye el DNI de los parámetros antes de construir el objeto Dog
    dog_params_without_dni = dog_params.except(:dni)
    @dog = Dog.new(dog_params_without_dni)

    if params[:dog][:birthdate].blank? && params[:dog][:age].present?
      calculate_birthdate
    end

    # Asigna el usuario al perro
    @dog.user = user if user
      
    respond_to do |format|
      if @dog.save
        format.html { redirect_to dog_url(@dog), notice: "El perro fue agregado exitosamente." }
        format.json { render :show, status: :created, location: @dog }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dogs/1 or /dogs/1.json
  def update
    respond_to do |format|
      if @dog.update(dog_params)
        format.html { redirect_to dog_url(@dog), notice: "El perro se ha actualizado con éxito." }
        format.json { render :show, status: :ok, location: @dog }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dogs/1 or /dogs/1.json
  def destroy
    @dog.destroy

    respond_to do |format|
      format.html { redirect_to dogs_url, notice: "El perro se ha eliminado exitosamente." }
      format.json { head :no_content }
    end
  end

  def confirm_delete
    @dog = Dog.find(params[:id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dog
      @dog = Dog.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def dog_params
      params.require(:dog).permit(:name, :dni, :breed, :gender, :birthdate, :age)
    end
    
    def calculate_birthdate
      age = params[:dog][:age].to_i
      @dog.birthdate = Date.current - age.years
    end
end
