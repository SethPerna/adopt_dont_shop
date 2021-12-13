require 'rails_helper'
describe 'application show page' do
  before do
    @shelter1 = Shelter.create!(foster_program: true, name:" Shelter ", city: "Denver", rank: 2)
    @pet1 = @shelter1.pets.create!(adoptable: true, age: 5, breed:"Pitt Bull", name:"Penelope")
    @pet2 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Husky X", name:"Lily")
    @pet3 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Husky X", name:"Bruno")
    @application1 = Application.create!(name:'Seth', address: '123 test st', city: 'Denver', state: 'Colorado', zip: '22835', description: "Gimme the doggos", status: 'in progress' )
    @application_pet = PetApplication.create!(pet_id: @pet1.id, application_id: @application1.id)
    visit "/applications/#{@application1.id}"


  end
  it ' I see name, address, description, status' do
    expect(page).to have_content(@application1.name)
    expect(page).to have_content(@application1.address)
    expect(page).to have_content(@application1.city)
    expect(page).to have_content(@application1.state)
    expect(page).to have_content(@application1.description)
    expect(page).to have_content(@application1.status)
    expect(page).to have_link(@pet1.name)
  end

  it 'pet name is link' do

    expect(page).to have_link("#{@pet1.name}", href: "/pets/#{@pet1.id}")
    click_link "#{@pet1.name}"
    expect(current_path).to eq("/pets/#{@pet1.id}")
  end

  it "has section to add pet to application" do
    expect(page).to have_content("Add a Pet to this Application")
    expect(page).to have_button("Search")
    fill_in('Pet name', with: "#{@pet2.name}")
    click_button "Search"
    expect(current_path).to eq("/applications/#{@application1.id}")
    expect(page).to have_content(@pet2.name)
    fill_in('Pet name', with: "#{@pet3.name}")
    click_button "Search"
    expect(current_path).to eq("/applications/#{@application1.id}")
    expect(page).to have_content(@pet3.name)
  end

  it 'adds pet after clicking adopt this pet' do
    fill_in('Pet name', with: "#{@pet2.name}")
    click_button "Search"

    click_button "Adopt this Pet"
    expect(current_path).to eq("/applications/#{@application1.id}")
    expect(page).to have_content("Pets: #{@pet2.name}")
  end
end
