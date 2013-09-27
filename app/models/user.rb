class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable, :omniauthable,
	# :registerable, :recoverable, :rememberable, :validatable
	devise :database_authenticatable, :registerable

	has_many :products, :dependent => :destroy
	has_many :transactions
	has_one :image, :as => :attachable, :dependent => :destroy

	validates :password, :length => { :within => Devise.password_length }, :allow_blank => true

	%W(admin user).each do |type|
		define_method "is_#{type}?".to_sym do
			self.role == type
		end
	end

	def self.find_or_create_by_facebook(args)
		return nil if args[:fb_token].blank?

		response = FacebookHelper.me(args[:fb_token], %W(email id username name first_name middle_name last_name gender birthday picture.type(large)))

		return nil if response.empty?

		user = User.find_by_facebook_id(response[:id])

		user_parameters = {
			:email => response[:email],
			:username => response[:username],
			:full_name => response[:name],
			:first_name => response[:first_name],
			:middle_name => response[:middle_name],
			:last_name => response[:last_name],
			:gender => response[:gender],
			:birthday => response[:birthday]
		}
		user_parameters[:udid] = args[:udid] if args[:udid].present?

		if user.blank?
			user_parameters.merge!({
				:facebook_id => response[:id],
				:image => Image.create(:content => response[:picture])
			})

			user = User.create(user_parameters)
		else
			user.image.update_attributes(:content => response[:picture])
		end

		return user
	end
end
