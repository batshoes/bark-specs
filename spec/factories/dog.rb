FactoryGirl.define do
  factory :dog do
    name 'Fido'
    birthday DateTime.now
    city 'New York'
    state 'New York'

    sequence :email do |n|
      "fido#{n}@dogz.com"
    end

    password '12345678'

    #after(:create) do |dog, evaluator|
      #statuses = build_list(:status, 3)
      #statuses.each do |s|
        #s.dog = dog
        #s.save
      #end
    #end
  end
end
