class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
            :recoverable, :rememberable, :validatable


    # User Email Validation
    validates :email, format: URI::MailTo::EMAIL_REGEXP


    # Enum to represent User Roles - Default is set to 0 (:user) when Devise User account is first created
    enum role: %i[user, admin]




    # Authenticate Method taken from the Devise documentation
    def self.authenticate(email, password)
        user = User.find_for_authentication(email: email)
        # Check if User exists and Valid Password exists
        user&.valid_password?(password) ? user : nil
    end

end
