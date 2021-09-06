require 'rails_helper'

RSpec.describe 'application show' do
  describe "application info" do
    before :each do
      @app = Application.create!(name: "Laura", street: "123 This one street", city: "Orlando", state: "FL", zip: 32819, message: "I like pets")
      @shelter = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      @pet_1 = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: @shelter.id)
      @pet_2 = Pet.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: @shelter.id)
      ApplicationPet.create!(application: @app, pet: @pet_1)
      ApplicationPet.create!(application: @app, pet: @pet_2)

      visit "/applications/#{@app.id}"
    end

    it 'displays application info' do
      expect(page).to have_content(@app.name)
      expect(page).to have_content(@app.street)
      expect(page).to have_content(@app.city)
      expect(page).to have_content(@app.state)
      expect(page).to have_content(@app.zip)
      expect(page).to have_content(@app.message)
      expect(page).to have_content(@app.status)
    end

    it 'displays links to pets they are applying for' do
      within("#app_pets-#{@pet_1.id}") do
        expect(page).to have_link("#{@pet_1.name}")
      end
      within("#app_pets-#{@pet_2.id}") do
        expect(page).to have_link("#{@pet_2.name}")
      end
    end
  end

  describe "adding pets" do
    before :each do
      @app = Application.create!(name: "Laura", street: "123 This one street", city: "Orlando", state: "FL", zip: 32819, message: "I like pets")
      @shelter = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      @pet_1 = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: @shelter.id)
      @pet_2 = Pet.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: @shelter.id)
      visit "/applications/#{@app.id}"
    end

    it 'adds a pet via search bar' do
      expect(page).to have_content("Add a Pet to this Application")
      fill_in "search", with: "Luc"
      click_button("Search")
      expect(current_path).to eq("/applications/#{@app.id}")
      expect(page).to have_content(@pet_1.name)
    end

    it 'adds a pet to application' do
      fill_in "search", with: "Luc"
      click_button("Search")

      expect(page).to have_button("Adopt this Pet")
      expect(current_path).to eq("/applications/#{@app.id}")
      expect(page).to have_content(@pet_1.name)
    end

    it 'submits an application' do
      fill_in "search", with: "Luc"
      click_button("Search")

      within("#pets-#{@pet_1.id}") do
        click_button("Adopt this Pet")
      end

      expect(current_path).to eq("/applications/#{@app.id}")
      expect(page).to have_content(@pet_1.name)

      fill_in "message", with: "I like aminals."
      click_button("Submit Application")
      expect(current_path).to eq("/applications/#{@app.id}")
      expect(page).to have_content("Pending")

      expect(page).to have_content(@pet_1.name)
      expect(page).to_not have_content("Add a Pet to this Application")
      expect(page).to_not have_content("Tell us why you'd make a good owner")
      expect(page).to have_content("I like aminals")
    end

    it 'does not show submit section without selecting pets' do
      expect(page).to_not have_content(@pet_1.name)
      expect(page).to_not have_content("Tell us Why you'd make a good owner")

      fill_in "search", with: "Luc"
      click_button("Search")

      click_button("Adopt this Pet")
      expect(current_path).to eq("/applications/#{@app.id}")
      expect(page).to have_content(@pet_1.name)
      click_button("Submit Application")
      expect(page).to_not have_content("Search")
      expect(page).to_not have_content("Submit Application")
    end
  end
end
