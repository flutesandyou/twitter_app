class User < ActiveRecord::Base
	has_many :microposts
	validates :name, presence: true, length: { maximum: 50 }
	validates :email, presence: true, length: { maximum: 255 }
	validates :email, format: { with: /<regular expression>/ }
end
