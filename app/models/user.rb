class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable
  has_many :access_grants,
            class_name:'Doorkeeper::AccessGrant',
            foreign_key: :resource_owner_id,
            dependent: :delete_all
  has_many :access_tokens,
            class_name:'Doorkeeper::AccessToken',
            foreign_key: :resource_owner_id,
            dependent: :delete_all

  has_many :guests, foreign_key: :added_by
  has_many :events

  validates :email, presence: true, email: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.authenticate(email, password)
    user = User.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end
end





# class User < ApplicationRecord
#   # Include default devise modules. Others available are:
#   # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
#   devise :database_authenticatable, :registerable,
#         :recoverable, :rememberable, :validatable



#   attr_writer :login

#   def login
#     @login || self.username || self.email
#   end


#   def self.find_for_database_authentication(warden_conditions)
#     conditions = warden_conditions.dup
#     if (login = conditions.delete(:login))
#       where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
#     elsif conditions.has_key?(:username) || conditions.has_key?(:email)
#       where(conditions.to_h).first
#     end
#   end
  
  
# end
