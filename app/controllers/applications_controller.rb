class ApplicationsController < ApplicationController
  before_action :current_app, only: [:show, :update]

  def show
    if params[:search]
      @pets = Pet.search(params[:search])
    end
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

  def update
    @app.update(message: params[:message], status: 'Pending')
    if @app.save
      redirect_to "/applications/#{@app.id}"
    else
      flash[:alert] = "Error: description must be longer than 10 characters"
      redirect_to "/applications/#{@app.id}"
    end
  end

private
  def app_params
    params.permit(:name, :street, :city, :state, :zip)
  end

  def current_app
    @app = Application.find(params[:id])
  end
end
