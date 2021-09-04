class ApplicationsController < ApplicationController

  def show
    @app = Application.find(params[:id])
  end

  def new

  end

  def create
    app = Application.new(app_params)

    if app.save
      redirect_to "/applications/#{app.id}"
    else
      flash[:alert] = "Error: #{error_message(app.errors)}"
      redirect_to "/applications/new"
    end
  end

private
  def app_params
    params.permit(:name, :street, :city, :state, :zip)
  end
end
