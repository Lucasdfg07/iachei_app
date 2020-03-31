class User < ApplicationRecord
	belongs_to :city, optional: true
	
	has_many :establishments, dependent: :destroy

	enum role: [:client, :shopkeeper, :admin]

  	devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2, :facebook]

 	def self.from_omniauth(auth)
	    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
	      user.email = auth.info.email
	      user.name = auth.info.name
	      user.password = Devise.friendly_token[0,20]
	    end
  	end

  	
  	def set_role(role)
  		self.update(role: role)
  	end

  	def set_city(city)
  		self.update(city_id: city.id)
  	end

    def is_establshment_present(establishment)
      self.establishments.each do |self_establishment|
        if self_establishment == establishment
          return true
        end
      end
    end
end
