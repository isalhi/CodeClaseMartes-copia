require 'digest/sha1'

class User < ActiveRecord::Base
    validates :name, :presence => true, :uniqueness => true
    validates :password, :confirmation => true
    validates_presence_of :password, :password_confirmation, :salt
    validate :password_must_be_present
    
    
    def User.authenticate(name, password)
        if user = find_by_name(name)
            if user.hashed_password == encrypt_password(password, user.salt)
                user
            end
        end
    end
    
    
    def self.encrypt(password, salt)
    Digest::SHA1.hexdigest(password+salt)
end
    # 'password' is a virtual attribute
    
    
def password=(password)
    @password = password
    if @password.present?
        generate_salt
        self.hashed_password = self.class.encrypt_password(@password, salt)
    end
end
    
    private
    
    def password_must_be_present
        errors.add(:password, "Missing password" ) unless hashed_password.present?
    end
    
def generate_salt
    self.salt = self.object_id.to_s + rand.to_s
end

end
    
    