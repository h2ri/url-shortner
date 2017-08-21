class UrlsController < ApplicationController
  before_action :find_url, only: [:show]

  $chars = ['0'..'9', 'A'..'Z', 'a'..'z'].map { |range| range.to_a }.flatten
  def index
    @urls = Url.all
  end

  def show
    redirect_to url_for(@url.original_url)
  end

  def new
    @url = Url.new
  end


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
  end


  def find_url
    #get the id from short_url_text
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
