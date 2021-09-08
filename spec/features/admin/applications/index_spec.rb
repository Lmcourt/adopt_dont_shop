require 'rails_helper'

RSpec.describe 'admin application index page' do
  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
    @app_1 = Application.create!(name: "Laura", street: "123 This one street", city: "Orlando", state: "FL", zip: 32819, message: "I like pets", status: "Pending")
    @app_2 = Application.create!(name: "ME", street: "123 ", city: "City", state: "FL", zip: 32802, message: "PETS", status: "Pending")
    @pet_1 = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: @shelter_1.id)
    @pet_2 = Pet.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: @shelter_2.id)
    @app_pet_1 = ApplicationPet.create!(application: @app_1, pet: @pet_1) #pending shelter_1
    @app_pet_2 = ApplicationPet.create!(application: @app_2, pet: @pet_1) #approved shelter_2

    visit '/admin/applications'
  end

  it 'shows all applications' do
    expect(page).to have_link(@app_1.name)
    expect(page).to have_link(@app_2.name)
  end
end
