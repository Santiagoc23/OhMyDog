class DonationsController < ApplicationController
  # require 'mercadopago'

  before_action :authenticate_user!, except: [:index, :donate, :confirm_donate]
  before_action :authenticate_admin, only: [:show, :new, :create, :edit, :update, :destroy, :confirm_delete]
  before_action :set_donation, only: %i[ show edit update destroy]

  # GET /donations or /donations.json
  def index
    @donations = Donation.all
  end

  # GET /donations/1 or /donations/1.json
  def show
  end

  # GET /donations/new
  def new
    @donation = Donation.new
  end

  # GET /donations/1/edit
  def edit
  end

  # POST /donations or /donations.json
  def create
    @donation = Donation.new(donation_params)

    respond_to do |format|
      if @donation.save
        format.html { redirect_to donation_url(@donation), notice: "Donation was successfully created." }
        format.json { render :show, status: :created, location: @donation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @donation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /donations/1 or /donations/1.json
  def update
    respond_to do |format|
      if @donation.update(donation_params)
        format.html { redirect_to donation_url(@donation), notice: "Donation was successfully updated." }
        format.json { render :show, status: :ok, location: @donation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @donation.errors, status: :unprocessable_entity }
      end
    end  
  end

  # DELETE /donations/1 or /donations/1.json
  def destroy
    @donation.destroy

    respond_to do |format|
      format.html { redirect_to donations_url, notice: "Donation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def confirm_delete
    @donation = Donation.find(params[:id])
  end

  def donate
    # SDK de Mercado Pago
    require 'mercadopago'
    # Agrega credenciales
    @sdk = Mercadopago::SDK.new(ENV['MERCADOPAGO_ACCESS_TOKEN'])

    # Obtén el monto de la donación desde los parámetros del formulario
    amount = params[:amount].to_f
     # Obtén el título de la publicación desde los parámetros del formulario
    donation_title = params[:donation_title] || "Colaboración a campaña de donación"

    preference_response = @sdk.preference.create(preference_params(donation_title, amount))
    @preference_id = preference_response[:response]['id']
    puts "Preference ID: #{@preference_id}"
    redirect_to confirm_donate_donation_path(id: @preference_id)

    #preference = preference_response[:response]

    # Este valor substituirá a string "<%= @preference_id %>" no seu HTML
    #@preference_id = preference['id'] 

    # Redirige al usuario a la página de pago de MercadoPago
    # redirect_to preference['sandbox_init_point'],allow_other_host: true
    #redirect_to confirm_donate_donation_path(id: @preference_id )
  end

  def confirm_donate
    # Verifica que @sdk esté inicializado antes de usarlo
    if @sdk.nil?
      # Puedes inicializar @sdk aquí si no lo has hecho ya
      @sdk = Mercadopago::SDK.new(ENV['MERCADOPAGO_ACCESS_TOKEN'])
    end
    # Usa @sdk para acceder a la variable de instancia definida en donate
    preference_response = @sdk.preference.get(params[:id])
    preference = preference_response[:response]
    @donation_title = preference['items'].first['title']
    @amount = preference['items'].first['unit_price']
    @sandbox_init_point = preference['sandbox_init_point']
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_donation
      @donation = Donation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def donation_params
      params.require(:donation).permit(:title, :description, :closing_date, :target_amount)
    end

    def preference_params(donation_title, amount)
      {
        items: [{
          title: donation_title,
          quantity: 1,
          currency_id: 'ARS', # Puedes ajustar la moneda según tu necesidad
          unit_price: amount
        }]
      }
    end
end
