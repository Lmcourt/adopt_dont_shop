class Admin::ApplicationsController < ApplicationController

  def show
    @app = Application.find(params[:id])
  end

  def update
    app = Application.find(params[:id])
    app_pet = ApplicationPet.find_app(params[:id], params[:pet_id])
    app_pet.update(status: params[:status])
    redirect_to "/admin/applications/#{app.id}"
  end
end
