class AdoptionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :solicitar]
  before_action :require_owner_or_admin, only: [:edit, :update, :confirm, :destroy  ]
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
    @adoption.user_id = current_user.id 
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

    if user_signed_in?
      user = User.find(current_user.id)
      @name = user.name
      @lastname = user.surname
      @phone = user.phoneNum
      @mail = user.email
    else
      @name = ""
      @lastname = ""
      @phone = ""
      @mail = ""
    end

    if request.post?
      modified_name = params[:name]
      modified_lastname = params[:lastname]
      modified_phone = params[:phone]
      modified_mail = params[:mail]
      dogname= @adoption.name
      dogmail= User.find(@adoption.user_id).email
      omd_notifications_mail= "vete0hmydog@gmail.com" #PREGUNTAR SI TIENEN ALGUNO

      UserMailer.notify_by_email(modified_name, modified_lastname, modified_phone, modified_mail, dogname, dogmail).deliver_later
      UserMailer.notify_by_email(modified_name, modified_lastname, modified_phone, modified_mail, dogname, omd_notifications_mail).deliver_later

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

    def require_owner_or_admin
      @adoption = Adoption.find(params[:id])
      # Verifica si el usuario es el propietario del recurso o es un administrador
      unless current_user && (current_user.id == @adoption.user_id || current_user.admin?)
        redirect_to dashboard_home_path
      end
    end

end
