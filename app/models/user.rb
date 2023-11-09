class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :appointments

  validates :dni, presence: true, uniqueness: true,
    length: { is: 8 },
    format: {
      with: /\A[0-9]+\z/,
      message: :invalid
    }
  
  
  enum role: [:user, :admin]
    after_initialize :set_default_role, if: :new_record?
  def set_default_role
    self.role ||= :user
  end
end
