class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :appointments
  has_many :adoptions
  has_many :dogs
  has_many :caregivers, dependent: :nullify
  has_many :walkers, dependent: :nullify

  has_many :reported_caregiver_associations, class_name: 'ReportedCaregiver', foreign_key: 'user_id'
  has_many :reported_caregivers, through: :reported_caregiver_associations, source: :caregiver, dependent: :nullify

  has_many :reported_walker_associations, class_name: 'ReportedWalker', foreign_key: 'user_id'
  has_many :reported_walkers, through: :reported_walker_associations, source: :walker, dependent: :nullify

  validates :dni, presence: true, uniqueness: true,
  length: { in: 7..8 }, format: { with: /\A\d+\z/, message: "debe contener solo números" }

  validates :phoneNum, presence: true, format: { with: /\A\d+\z/, message: "Solo puede contener digitos" }


  enum role: [:user, :admin]
    after_initialize :set_default_role, if: :new_record?
  def set_default_role
    self.role ||= :user
  end
end
