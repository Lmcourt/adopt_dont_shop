require 'rails_helper'

RSpec.describe 'admin application show page' do
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
    visit "/admin/applications/#{@app_1.id}"
  end

  it 'approves a pet for adoption' do
    expect(page).to have_content("Pending")
    within("#approval-#{@pet_1.id}") do
      click_on("Approve Pet")
      expect(page).to have_current_path("/admin/applications/#{@app_1.id}")
      expect(page).to_not have_content("Approve Pet")
      expect(page).to have_content("Approved")
    end
  end

  it 'rejects pets for adoption' do
    expect(page).to have_content("Pending")
    within("#approval-#{@pet_1.id}") do
      click_on("Reject Pet")
      expect(page).to have_current_path("/admin/applications/#{@app_1.id}")
      expect(page).to_not have_content("Reject Pet")
      expect(page).to have_content("Rejected")
    end
  end

#   As a visitor
# When a pet has an "Approved" application on them
# And when the pet has a "Pending" application on them
# And I visit the admin application show page for the pending application
# Then next to the pet I do not see a button to approve them
# And instead I see a message that this pet has been approved for adoption
# And I do see a button to reject them


end
