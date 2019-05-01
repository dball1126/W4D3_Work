class User < ApplicationRecord
    attr_reader :password

    validates :password_digest, presence: { message: "Password can't be blank"}
    validates :session_token, :user_name, presence: true, uniqueness: true
    validates :password,  length: { minimum: 6, allow_nil: true} 

    after_initialize :ensure_session_token

    has_many :cats,
        foreign_key: :user_id,
        class_name: 'Cat'

    has_many :cat_rental_requests,
        foreign_key: :user_id,
        class_name: :CatRentalRequest

    def self.generate_session_token
        SecureRandom::urlsafe_base64(16)
    end
    
    def self.find_by_credentials(user_name, password)
        user = User.find_by(user_name: user_name)

        return nil if user == nil

        user.is_password?(password) ? user : nil
    end

    def reset_session_token!
        self.session_token = self.class.generate_session_token
        self.save!

        self.session_token
    end

    def password=(password)
        self.password_digest = BCrypt::Password.create(password)

        @password = password
    end

    def is_password?(password)
        actual_password = BCrypt::Password.new(self.password_digest)
        actual_password.is_password?(password)
    end

    private

    def ensure_session_token
        self.session_token ||= self.class.generate_session_token
    end


end