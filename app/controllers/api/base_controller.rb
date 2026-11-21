module Api
  class BaseController < ActionController::API
    rescue_from Books::BookNotFound do |error|
      render json: { error: error.message }, status: :not_found
    end

    rescue_from Books::InvalidBook do |error|
      render json: { errors: error.errors }, status: :unprocessable_content
    end
  end
end
