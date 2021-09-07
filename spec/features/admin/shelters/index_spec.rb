require 'rails_helper'

RSpec.describe 'admin index page' do
  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
    @app_1 = Application.create!(name: "Laura", street: "123 This one street", city: "Orlando", state: "FL", zip: 32819, message: "I like pets", status: "Pending")
    @app_2 = Application.create!(name: "ME", street: "123 ", city: "City", state: "FL", zip: 32802, message: "PETS", status: "Approved")
    @pet_1 = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: @shelter_1.id)
    @pet_2 = Pet.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: @shelter_2.id)
    ApplicationPet.create!(application: @app_1, pet: @pet_1) #pending shelter_1
    ApplicationPet.create!(application: @app_2, pet: @pet_2) #approved shelter_2
    visit '/admin/shelters'
  end

  it 'shows shelters in reverse alphabetical order' do
      expect(@shelter_2.name).to appear_before(@shelter_3.name)
      expect(@shelter_3.name).to appear_before(@shelter_1.name)
  end

  it 'shows shelters with pending applications' do
    expect(page).to have_content("Shelter's with Pending Applications")
    within("#pending-#{@shelter_1.id}") do
      expect(page).to have_content(@shelter_1.name)
      expect(page).to_not have_content(@shelter_2.name)
    end
  end
end
