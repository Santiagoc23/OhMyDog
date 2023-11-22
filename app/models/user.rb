class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :appointments
  has_many :adoptions
  has_many :dogs
  
  validates :dni, presence: true, uniqueness: true, 
  length: { in: 7..8 }, format: { with: /\A\d+\z/, message: "debe contener solo números" }
  
  validates :phoneNum, presence: true, format: { with: /\A\d+\z/, message: "Solo puede contener digitos" }
  
  
  enum role: [:user, :admin]
    after_initialize :set_default_role, if: :new_record?
  def set_default_role
    self.role ||= :user
  end
end
