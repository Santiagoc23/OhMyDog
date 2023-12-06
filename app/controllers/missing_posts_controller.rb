class MissingPostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :solicitar]
  before_action :require_owner_or_admin, only: [:edit, :update, :confirm, :destroy, :confirm_delete]
  before_action :set_missing_post, only: %i[ show edit update destroy ]

  # GET /missing_posts or /missing_posts.json
  def index
    @missing_posts = MissingPost.order(created_at: :desc) # MAS RECIENTE AL MAS VIEJO
    @finished_missing_posts = @missing_posts.select { |missing_post| missing_post.finished? }

    if @finished_missing_posts.count >= 5
      @finished_missing_posts = @finished_missing_posts.sort_by { |missing_post| missing_post.confirmed_at }
      @finished_missing_posts.reverse!
      excess_missing_posts = @finished_missing_posts[5..-1] # Obtén las adopciones adicionales
      excess_missing_posts.each do |missing_post|
        missing_post.destroy
      end
    end
  end

  def confirm
    @missing_post = MissingPost.find(params[:id])
    @missing_post.update(missing_post_params)
    redirect_to @missing_post
  end

  # GET /missing_posts/1 or /missing_posts/1.json
  def show

  end

  # GET /missing_posts/new
  def new
    @missing_post = MissingPost.new
  end

  # GET /missing_posts/1/edit
  def edit

  end

  # POST /missing_posts or /missing_posts.json
  def create
    @missing_post = MissingPost.new(missing_post_params)
    @missing_post.user_id = current_user.id
    if @missing_post.name.blank?
      @missing_post.name= "Sin nombre"
    end
    respond_to do |format|
      if @missing_post.save
        format.html { redirect_to missing_post_url(@missing_post), notice: "Publicación exitosa." }
        format.json { render :show, status: :created, location: @missing_post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @missing_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /missing_posts/1 or /missing_posts/1.json
  def update
    respond_to do |format|
      if @missing_post.update(missing_post_params)
        format.html { redirect_to missing_post_url(@missing_post), notice: "Publicación editada." }
        format.json { render :show, status: :ok, location: @missing_post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @missing_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /missing_posts/1 or /missing_posts/1.json
  def destroy
    @missing_post.destroy

    respond_to do |format|
      format.html { redirect_to missing_posts_url, notice: "Publicación eliminada." }
      format.json { head :no_content }
    end
  end

  def confirm_delete

  end

  def solicitar
    @missing_post = MissingPost.find(params[:id])

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
      dogname= @missing_post.name
      dogmail= User.find(@missing_post.user_id).email
      omd_notifications_mail= "vete0hmydog@gmail.com" #PREGUNTAR SI TIENEN ALGUNO

      UserMailer.notify_by_email(modified_name, modified_lastname, modified_phone, modified_mail, dogname, dogmail).deliver_later

      if user_signed_in?
        dni = User.find(current_user.id).dni
      else
        dni = -1
      end
      user= User.find(@missing_post.user_id)
      AdminMailer.notify_by_email(user, @missing_post, modified_name, modified_lastname, modified_phone, modified_mail, dogname, omd_notifications_mail, dni).deliver_later

      mensaje= 'Adopción solicitada exitosamente, espere el contacto!'
      redirect_to missing_posts_path, notice: mensaje
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_missing_post
      @missing_post = MissingPost.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def missing_post_params
      params.require(:missing_post).permit(:name, :breed, :size, :gender, :description, :zone, :user_id, :finished, :confirmed_at, :age)
    end

    def require_owner_or_admin
      @missing_post = MissingPost.find(params[:id])
      # Verifica si el usuario es el propietario del recurso o es un administrador
      unless current_user && (current_user.id == @missing_post.user_id || current_user.admin?)
        redirect_to dashboard_home_path
      end
    end

end
