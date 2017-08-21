class ApplicationController < ActionController::Base
  before_action :cors_filter

  def cors_filter
    headers['Access-Control-Allow-Origin'] = request.headers['Origin']
    headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, PATCH, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Authorization, Accept, X-Requested-With'
    headers['Access-Control-Max-Age'] = '1728000'
    headers['Access-Control-Allow-Credentials'] = true
  end
end
