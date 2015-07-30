require 'rails_helper'

RSpec.describe Dog, :type => :model do

  let!(:test_dog){ create(:dog) }

  it "has statuses" do
    test_dog.statuses
  end

  describe "validations" do
    [:name, :email, :birthday, :city, :state].each do |attr|
      it "is invalid without #{attr}" do
        test_dog.send("#{attr}=", nil)
        expect(test_dog).to_not be_valid
      end
    end

    it "is invalid if it has a duplicate email" do
      dog_attrs  = test_dog.attributes
      dog_attrs.delete("id")
      new_dog = Dog.new dog_attrs
      expect(new_dog).to_not be_valid
    end

    it "is in valid if state is less than 2 characters" do
      test_dog.state = "N"
      expect(test_dog).not_to be_valid
    end

  end

  describe '#age_in_dog_years' do
   it "returns the dog's age multiplied by 7" do
     test_dog.birthday = 2.years.ago
     expect(test_dog.age_in_dog_years).to eq(14)
   end
  end


  describe "#puppy?" do
    it "returns true if the dog is less than one year old" do
      test_dog.birthday = 1.month.ago
      expect(test_dog.puppy?).to eq(true)
    end
  end

  describe "geolocate" do
    let(:geocoder) { double }

    before do
      class Geocoder; end
      allow(geocoder).to receive(:position) { {lat: 40, long: 60} }
      allow(Geocoder).to receive(:new)      { geocoder }
    end

    it "returns the current lat long of the dog" do
      test_dog.geolocate('40 Bark Ave')
    end
  end


  describe '#age' do
    it "returns the dog's age in years" do
      test_dog.birthday = 5.years.ago
      expect(test_dog.age).to eq(5)
    end

    it "returns correct age even if a < 1 year period overlaps Jan 1" do
      test_dog.birthday = 8.months.ago
      expect(test_dog.age).to eq(0)
    end
  end

  describe "#location" do
    it "should return the dog city & state, seperated by a comma" do
      #specifying these here in case someone changes the test dog's
      #initial values
      test_dog.city = "Charlotte"
      test_dog.state = "North Carolina"
      expect(test_dog.location).to eq("Charlotte, North Carolina")
    end
  end

  describe '#birthday?' do
    it "should return true if today is the dog's birthday" do
      expect(test_dog.birthday?).to be true
    end

    it "return false if today is not the dog's birthday" do
      other_dog = create(:dog, birthday: 2.days.ago)
      expect(other_dog.birthday?).to be false
    end
  end


end
