class AppartmentsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_exception
rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_exception
rescue_from ActionController::UnpermittedParameters, with: :unpermitted_params_exception

  def index
    render json: Apartment.all
  end

  def show
    render json: find_apartment
  end

  def create
    new_apartment = Apartment.create(apartment_params)
    render json: new_apartment
  end

  def update
    updated = find_apartment.update(apartment_params)
    byebug
    if updated
      render json: find_apartment
    else
      render json: {error: "Could not update record" }, status: :forbidden
    end
  end

  def destroy
    find_apartment.destroy
    render json: {}, status: :ok
  end

  private

  def find_apartment
    Apartment.find(params[:id])
  end
  
  def apartment_params
    params.require(:apartment).permit(:number)
  end

  def render_unprocessable_entity_exception(exception)
    render json: {errors: exception.record.errors.full_messages}, status: :unprocessable_entity
  end

  def render_record_not_found_exception
    render json: { error: "Apartment data not found" }, status: :not_found
  end

  def unpermitted_params_exception
    render json: {error: "unpermitted parameters present"}
  end
end
