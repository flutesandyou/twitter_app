class User < ActiveRecord::Base
	has_many :microposts
<<<<<<< HEAD
	validates :name,  presence: true, length: { maximum: 50 }
	validates :email, presence: true, length: { maximum: 255 }
=======
	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255 },
								    format: { with: VALID_EMAIL_REGEX },
										uniqueness: { case_sensitive: false }
>>>>>>> 5afd8dca288033c3bbf4bcb4791390229ae9b912
end
