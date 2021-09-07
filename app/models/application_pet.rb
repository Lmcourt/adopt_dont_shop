class ApplicationPet < ApplicationRecord
  belongs_to :application
  belongs_to :pet

  def self.find_app(app_id, pet_id)
    where(application_id: app_id, pet_id: pet_id).first
  end

end
