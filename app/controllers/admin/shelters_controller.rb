class Admin::SheltersController < ApplicationController

  def index
    @shelters = Shelter.alphabetical_shelters
  end
end
