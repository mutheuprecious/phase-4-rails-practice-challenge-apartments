class LeasesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found_exception
rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_exception
  def create
    new_lease = Lease.create!(lease_params)
    render json: new_lease
  end

  def destroy
    Lease.find(params[:id]).destroy
    render json: {}, status: :ok
  end

  private

  def lease_params
    params.require(:lease).permit(:rent, :apartment_id, :tenant_id)
  end

  def render_record_not_found_exception
    render json: { error: "Lease data not found" }, status: :not_found
  end

  def render_unprocessable_entity_exception(exception)
    render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end
end
