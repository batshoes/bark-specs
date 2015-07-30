class Dog < ActiveRecord::Base

  has_secure_password

  validates_presence_of :name, :birthday, :city, :state, :email

  validates_length_of :state, minimum: 2

  validates_uniqueness_of :email

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  has_many :statuses

  scope :newsletter_subscribers, -> { where(newsletter: true)}

  def birthday?
    birthday.month == Time.now.month && birthday.day == Time.now.day
  end

  attr_writer :lat, :long
  def geolocate(address)
    geocoder = Geocoder.new
    self.lat = geocoder.position(address)[:lat]
    self.long = geocoder.position(address)[:long]
  end

  def age
    age = Time.now.year - birthday.year
    months = Time.now.month - birthday.month
        if months < 0 
          age = age - 1
        end
    age
  end

  def location
    city + ", " + state
  end

  def puppy?
    age < 1
  end

  def age_in_dog_years
    age * 7
  end

  def subscribe_to_newsletter
    self.newsletter = true
    save
  end

  def unsubscribe_from_newsletter
    self.newsletter = false
    save
  end

end
