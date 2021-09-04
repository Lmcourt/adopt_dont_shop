require 'rails_helper'

RSpec.describe 'application show' do
  before :each do
    @app = Application.create!(name: "Laura", street: "123 This one street", city: "Orlando", state: "FL", zip: 32819, message: "I like pets", status: "Accepted")
    @shelter = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @pet_1 = @app.pets.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: @shelter.id)
    @pet_2 = @app.pets.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: @shelter.id)
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
    within("#pets-#{@pet_1.id}") do
      expect(page).to have_link("#{@pet_1.name}")
    end
    within("#pets-#{@pet_2.id}") do
      expect(page).to have_link("#{@pet_2.name}")
    end
  end

  it 'adds a pet via search bar' do
    expect(page).to have_content("Add a Pet to this Application")
    fill_in "search", with: "Luc"
    click_button("Search")
    expect(current_path).to eq("/applications/#{@app.id}")
    expect(page).to have_content(@pet_1.name)
  end

#   As a visitor
# When I visit an application's show page
# And I search for a Pet by name
# And I see the names Pets that match my search
# Then next to each Pet's name I see a button to "Adopt this Pet"
# When I click one of these buttons
# Then I am taken back to the application show page
# And I see the Pet I want to adopt listed on this application

  it 'adds a pet to application' do
    fill_in "search", with: "Luc"
    click_button("Search")

    expect(page).to have_button("Adopt this Pet")
    expect(current_path).to eq("/applications/#{@app.id}")
    expect(page).to have_content(@pet_1.name)
  end
end
