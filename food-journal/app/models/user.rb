class User < ActiveRecord::Base
    has_secure_password
    has_many :meals
    validates :username, :email, :password, presence: true
end
