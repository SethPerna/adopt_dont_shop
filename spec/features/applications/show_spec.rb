require 'rails_helper'
describe 'application show page' do

  it ' I see name, address, description, status' do
    @shelter1 = Shelter.create!(foster_program: true, name:" Shelter ", city: "Denver", rank: 2)
    @pet1 = @shelter1.pets.create!(adoptable: true, age: 5, breed:"Pitt Bull", name:"Penelope")
    @pet2 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Husky X", name:"Lily")
    @pet3 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Husky X", name:"Bruno")
    @pet4 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Basset", name:"Herb")
    @application1 = Application.create!(name:'Seth', address: '123 test st', city: 'Denver', state: 'Colorado', zip: '22835' )
    @application_pet = PetApplication.create!(pet_id: @pet1.id, application_id: @application1.id)
    visit "/applications/#{@application1.id}"
    within "#application-#{@application1.id}" do
      expect(page).to have_content(@application1.name)
      expect(page).to have_content(@application1.address)
      expect(page).to have_content(@application1.city)
      expect(page).to have_content(@application1.state)
      #expect(page).to have_link(@pet1.name)
    end
  end

  it 'pet name is link' do
    @shelter1 = Shelter.create!(foster_program: true, name:" Shelter ", city: "Denver", rank: 2)
    @pet1 = @shelter1.pets.create!(adoptable: true, age: 5, breed:"Pitt Bull", name:"Penelope")
    @pet2 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Husky X", name:"Lily")
    @pet3 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Husky X", name:"Bruno")
    @pet4 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Basset", name:"Herb")
    @application1 = Application.create!(name:'Seth', address: '123 test st', city: 'Denver', state: 'Colorado', zip: '22835' )
    @application_pet = PetApplication.create!(pet_id: @pet1.id, application_id: @application1.id)
    visit "/applications/#{@application1.id}"
    expect(page).to have_link("#{@pet1.name}", href: "/pets/#{@pet1.id}")
    click_link "#{@pet1.name}"
    expect(current_path).to eq("/pets/#{@pet1.id}")
  end

  it "has section to add pet to application" do
    @shelter1 = Shelter.create!(foster_program: true, name:" Shelter ", city: "Denver", rank: 2)
    @pet1 = @shelter1.pets.create!(adoptable: true, age: 5, breed:"Pitt Bull", name:"Penelope")
    @pet2 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Husky X", name:"Lily")
    @pet3 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Husky X", name:"Bruno")
    @pet4 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Basset", name:"Herb")
    @application1 = Application.create!(name:'Seth', address: '123 test st', city: 'Denver', state: 'Colorado', zip: '22835' )
    @application_pet = PetApplication.create!(pet_id: @pet1.id, application_id: @application1.id)
    visit "/applications/#{@application1.id}"
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
    @shelter1 = Shelter.create!(foster_program: true, name:" Shelter ", city: "Denver", rank: 2)
    @pet1 = @shelter1.pets.create!(adoptable: true, age: 5, breed:"Pitt Bull", name:"Penelope")
    @pet2 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Husky X", name:"Lily")
    @pet3 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Husky X", name:"Bruno")
    @pet4 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Basset", name:"Herb")
    @application1 = Application.create!(name:'Seth', address: '123 test st', city: 'Denver', state: 'Colorado', zip: '22835' )
    @application_pet = PetApplication.create!(pet_id: @pet1.id, application_id: @application1.id)
    visit "/applications/#{@application1.id}"
    fill_in('Pet name', with: "#{@pet2.name}")
    click_button "Search"

    click_button "Adopt this Pet"
    expect(current_path).to eq("/applications/#{@application1.id}")
    expect(page).to have_content("Pets: #{@pet1.name} #{@pet2.name}")
  end

  it 'After I have I added pet(s) I see a section to submit my application' do
    @shelter1 = Shelter.create!(foster_program: true, name:" Shelter ", city: "Denver", rank: 2)
    @pet1 = @shelter1.pets.create!(adoptable: true, age: 5, breed:"Pitt Bull", name:"Penelope")
    @pet2 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Husky X", name:"Lily")
    @pet3 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Husky X", name:"Bruno")
    @pet4 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Basset", name:"Herb")
    @application1 = Application.create!(name:'Seth', address: '123 test st', city: 'Denver', state: 'Colorado', zip: '22835' )
    visit "/applications/#{@application1.id}"
    expect(page).to_not have_content("Why I would be a good owner")
    fill_in('Pet name', with: "#{@pet2.name}")
    click_button "Search"
    click_button "Adopt this Pet"
    expect(page).to have_content("Why I would be a good owner?")
    expect(page).to have_button('Submit my application')
    fill_in('Description', with: 'I love dogs')
    click_button("Submit my application")
    expect(page).to have_content("Status: Pending")
    expect(page).to_not have_content("Status: In Progress")
    expect(page).to_not have_button("Search")
    expect(page).to_not have_button("Submit my application")
  end

  it 'when I search pets it returns all pets wohse name partially matches the search' do
    @shelter1 = Shelter.create!(foster_program: true, name:" Shelter ", city: "Denver", rank: 2)
    @pet1 = @shelter1.pets.create!(adoptable: true, age: 5, breed:"Pitt Bull", name:"Penelope")
    @pet2 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Husky X", name:"Lily")
    @pet3 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Husky X", name:"Lilac")
    @pet4 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Basset", name:"Herb")
    @application1 = Application.create!(name:'Seth', address: '123 test st', city: 'Denver', state: 'Colorado', zip: '22835' )
    visit "/applications/#{@application1.id}"
    fill_in('Pet name', with: "Li")
    click_button("Search")
    expect(page).to have_content(@pet2.name)
    expect(page).to have_content(@pet3.name)
  end
  it 'when I partial search the returns are case insensitive' do
    @shelter1 = Shelter.create!(foster_program: true, name:" Shelter ", city: "Denver", rank: 2)
    @pet1 = @shelter1.pets.create!(adoptable: true, age: 5, breed:"Pitt Bull", name:"Penelope")
    @pet2 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Husky X", name:"Lily")
    @pet3 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Husky X", name:"Lilac")
    @pet4 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Basset", name:"Herb")
    @application1 = Application.create!(name:'Seth', address: '123 test st', city: 'Denver', state: 'Colorado', zip: '22835' )
    visit "/applications/#{@application1.id}"
    fill_in('Pet name', with: "li")
    click_button("Search")
    expect(page).to have_content(@pet2.name)
    expect(page).to have_content(@pet3.name)
  end
end
