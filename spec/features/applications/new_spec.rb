require 'rails_helper'

RSpec.describe "new application" do

  it 'creates a form' do
    visit "/applications/new"

    fill_in(:name, with: "Laura")
    fill_in(:street, with: "123 This one street")
    fill_in(:city, with: "Orlando")
    fill_in(:state, with: "FL")
    fill_in(:zip, with: 32819)
    click_button("Submit")

    expect(current_path).to eq("/applications/#{Application.last.id}")
    expect(page).to have_content("Laura")
    expect(page).to have_content("Orlando")
    expect(page).to have_content("FL")
    expect(page).to have_content(32819)
  end
end
