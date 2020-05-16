class User < ActiveRecord::Base
    has_many :meals
    validates :username, :email, :password, presence: true
    has_secure_password
end
