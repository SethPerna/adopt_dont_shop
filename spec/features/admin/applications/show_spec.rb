require 'rails_helper'
describe 'When I visit admin application show page' do
  it 'for every submitted application for pet(s) I see a button to approve that specific pet' do
    @shelter1 = Shelter.create!(foster_program: true, name:" Shelter ", city: "Denver", rank: 2)
    @pet1 = @shelter1.pets.create!(adoptable: true, age: 5, breed:"Pitt Bull", name:"Penelope")
    @pet2 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Husky X", name:"Lily")
    @pet3 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Husky X", name:"Bruno")
    @pet4 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Basset", name:"Herb")
    @application_1 = Application.create!(name:'Seth', address: '123 test st', city: 'Denver', state: 'Colorado', zip: '22835', description: 'Hello', status: 'Pending')
    @application_2 = Application.create!(name:'John', address: '123 test st', city: 'Denver', state: 'Colorado', zip: '22835', description: 'Bye', status: 'Pending')
    @application_pet = PetApplication.create!(pet_id: @pet1.id, application_id: @application_1.id)
    @application_pet = PetApplication.create!(pet_id: @pet2.id, application_id: @application_1.id)
    @application_pet = PetApplication.create!(pet_id: @pet3.id, application_id: @application_2.id)

    visit "/admin/applications/#{@application_1.id}"

    expect(page).to have_button("Approve #{@pet1.name}")
    expect(page).to have_button("Approve #{@pet2.name}")
    expect(page).to_not have_button("Approve #{@pet3.name}")
  end

  it 'when I click that button I am taken back to admin application show page' do
    @shelter1 = Shelter.create!(foster_program: true, name:" Shelter ", city: "Denver", rank: 2)
    @pet1 = @shelter1.pets.create!(adoptable: true, age: 5, breed:"Pitt Bull", name:"Penelope")
    @pet2 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Husky X", name:"Lily")
    @pet3 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Husky X", name:"Bruno")
    @pet4 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Basset", name:"Herb")
    @application_1 = Application.create!(name:'Seth', address: '123 test st', city: 'Denver', state: 'Colorado', zip: '22835', description: 'Hello', status: 'Pending')
    @application_2 = Application.create!(name:'John', address: '123 test st', city: 'Denver', state: 'Colorado', zip: '22835', description: 'Bye', status: 'Pending')
    @application_pet = PetApplication.create!(pet_id: @pet1.id, application_id: @application_1.id)
    visit "/admin/applications/#{@application_1.id}"

    click_button("Approve #{@pet1.name}")
    expect(current_path).to eq("/admin/applications/#{@application_1.id}")
  end

  it 'after clicking approve pet I do not see the approve button and an indicator that the pet has been approved' do
    @shelter1 = Shelter.create!(foster_program: true, name:" Shelter ", city: "Denver", rank: 2)
    @pet1 = @shelter1.pets.create!(adoptable: true, age: 5, breed:"Pitt Bull", name:"Penelope")
    @pet2 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Husky X", name:"Lily")
    @pet3 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Husky X", name:"Bruno")
    @pet4 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Basset", name:"Herb")
    @application_1 = Application.create!(name:'Seth', address: '123 test st', city: 'Denver', state: 'Colorado', zip: '22835', description: 'Hello', status: 'Pending')
    @application_2 = Application.create!(name:'John', address: '123 test st', city: 'Denver', state: 'Colorado', zip: '22835', description: 'Bye', status: 'Pending')
    @application_pet = PetApplication.create!(pet_id: @pet1.id, application_id: @application_1.id)
    visit "/admin/applications/#{@application_1.id}"

    click_button("Approve #{@pet1.name}")
    expect(current_path).to eq("/admin/applications/#{@application_1.id}")
    expect(page).to_not have_button("Approve #{@pet1.name}")
    expect(page).to have_content("Approved Pets: #{@pet1.name}")
  end

  it 'denies pets if deny button is clicked and I see an indicator that the pet has been denied' do
    @shelter1 = Shelter.create!(foster_program: true, name:" Shelter ", city: "Denver", rank: 2)
    @pet1 = @shelter1.pets.create!(adoptable: true, age: 5, breed:"Pitt Bull", name:"Penelope")
    @pet2 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Husky X", name:"Lily")
    @pet3 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Husky X", name:"Bruno")
    @pet4 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Basset", name:"Herb")
    @application_1 = Application.create!(name:'Seth', address: '123 test st', city: 'Denver', state: 'Colorado', zip: '22835', description: 'Hello', status: 'Pending')
    @application_2 = Application.create!(name:'John', address: '123 test st', city: 'Denver', state: 'Colorado', zip: '22835', description: 'Bye', status: 'Pending')
    @application_pet = PetApplication.create!(pet_id: @pet1.id, application_id: @application_1.id)
    visit "/admin/applications/#{@application_1.id}"
    expect(page).to have_button("Deny #{@pet1.name}")
    click_button("Deny #{@pet1.name}")
    expect(current_path).to eq("/admin/applications/#{@application_1.id}")
    expect(page).to_not have_button("Deny #{@pet1.name}")
    expect(page).to have_content("Denied Pets: #{@pet1.name}")
  end

  it 'Approved or denied pets on one application do not effect another application' do
    @shelter1 = Shelter.create!(foster_program: true, name:" Shelter ", city: "Denver", rank: 2)
    @pet_1 = @shelter1.pets.create!(adoptable: true, age: 5, breed:"Pitt Bull", name:"Penelope")
    @pet_2 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Husky X", name:"Lily")
    @pet_3 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Husky X", name:"Bruno")
    @pet_4 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Basset", name:"Herb")
    @application_1 = Application.create!(name:'Seth', address: 'Da Crib', city: 'Xzibit', state: 'CA', zip: '90210', description: 'Da best', status: 'Pending')
    @application_2 = Application.create!(name:'John', address: '123 test st', city: 'Denver', state: 'Colorado', zip: '22835', description: 'Bye', status: 'Pending')
    @pet_application_3 = PetApplication.create!(pet_id: @pet_1.id, application_id: @application_1.id)
    @pet_application_4 = PetApplication.create!(pet_id: @pet_1.id, application_id: @application_2.id)

    visit "/admin/applications/#{@application_1.id}"
    click_button "Approve #{@pet_1.name}"
    visit "/admin/applications/#{@application_2.id}"
    save_and_open_page
    expect(page).to have_button("Approve #{@pet_1.name}")
    expect(page).to_not have_content("Approved pets: #{@pet_1.name}")
  end
end
