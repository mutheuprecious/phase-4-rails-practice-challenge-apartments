class TenantsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found_exception
rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_exception
  def index
    render json: Tenant.all
  end

  def show
    render json: find_tenant, status: :ok
  end

  def create
    new_tenant = Tenant.create!(tenant_params)
    render json: new_tenant, status: :created
  end

  def update
    updated = find_tenant.update(tenant_params)
    if updated
      render json: find_tenant, status: :ok
    else
      render json: {error: "Could not update tenant" }, status: :forbidden
    end
  end

  def destroy
    find_tenant.destroy
    render json: {}, status: :ok
  end

  private

  def tenant_params
    params.require(:tenant).permit(:name, :age)
  end

  def find_tenant
    Tenant.find(params[:id])
  end

  def render_record_not_found_exception
    render json: { error: "Tenant data not found" }, status: :not_found
  end

  def render_unprocessable_entity_exception(exception)
    render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end
end
