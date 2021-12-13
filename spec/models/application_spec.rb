require 'rails_helper'

describe Application do
  before do
    @shelter1 = Shelter.create!(foster_program: true, name:" Shelter ", city: "Denver", rank: 2)
    @pet1 = @shelter1.pets.create!(adoptable: true, age: 5, breed:"Pitt Bull", name:"Penelope")
    @pet2 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Husky X", name:"Lily")
    @pet3 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Husky X", name:"Bruno")
    @pet4 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Basset", name:"Herb")
    @application1 = Application.create!(name:'Seth', address: '123 test st', city: 'Denver', state: 'Colorado', zip: '22835')
    @application2 = Application.create!(name:'Sam', address: '123 test st', city: 'Denver', state: 'Colorado', zip: '22835')

    @application_pet = PetApplication.create!(pet_id: @pet1.id, application_id: @application1.id)
  end
  describe 'relationship' do
    it {should have_many(:pet_applications)}
    it {should have_many(:pets).through(:pet_applications)}
  end

  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
  end
end
