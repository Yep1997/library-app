module Api
  class BaseController < ActionController::API
    rescue_from Books::BookNotFound do |error|
      render json: { error: error.message }, status: :not_found
    end
  end
end
