class UrlsController < ApplicationController
  #before_action :set_url, only: [:show, :edit, :update, :destroy]
  before_action :find_url, only: [:show]

  $chars = ['0'..'9', 'A'..'Z', 'a'..'z'].map { |range| range.to_a }.flatten
  # GET /urls
  # GET /urls.json
  def index
    @urls = Url.all
  end

  # GET /urls/1
  # GET /urls/1.json
  def show
    redirect_to url_for(@url.original_url)
  end

  # GET /urls/new
  def new
    @url = Url.new
  end

  # GET /urls/1/edit
  def edit
  end

  def generate_base62_short_url(short_url_generator_id)
    short_url = ""
    while short_url_generator_id > 0 do
      short_url << $chars[short_url_generator_id % 62]
      short_url_generator_id = short_url_generator_id / 62
    end
    short_url
  end

  # POST /urls
  # POST /urls.json
  def create
    @url = Url.new(url_params)

    Url.transaction do
      @url.save
      #write base 62 method
      @url.short_url = generate_base62_short_url(@url.id)
      if @url.save
        render json: @url, status: :created, root: :url
      else
        render json: @url.errors, status: :unprocessable_entity
      end
    end
    #respond_to do |format|
    #if @url.save
      # format.html { redirect_to @url, notice: 'Url was successfully created.' }
      # format.json { render :show, status: :created, location: @url }

    #else
      # format.html { render :new }
      # format.json { render json: @url.errors, status: :unprocessable_entity }
      #render json: @url.errors, status: :unprocessable_entity
    #end
  end

  # PATCH/PUT /urls/1
  # PATCH/PUT /urls/1.json
  def update
    respond_to do |format|
      if @url.update(url_params)
        format.html { redirect_to @url, notice: 'Url was successfully updated.' }
        format.json { render :show, status: :ok, location: @url }
      else
        format.html { render :edit }
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /urls/1
  # DELETE /urls/1.json
  def destroy
    @url.destroy
    respond_to do |format|
      format.html { redirect_to urls_url, notice: 'Url was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def find_url
    #get the id from slug
    count = 0
    params[:id].reverse.split("").each { |x| count = count * 62 + $chars.index(x)  }
    @url = Url.find_by_short_url(params[:id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_url
      @url = Url.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def url_params
      params.permit(:original_url)
    end
end
