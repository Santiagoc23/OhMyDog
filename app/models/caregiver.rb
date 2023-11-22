class Caregiver < ApplicationRecord
  validates :phoneNum, presence: true, format: { with: /\A\d+\z/, message: "El télefono solo puede números, revise el campo e inténtelo nuevamente. "}
  has_many :users, dependent: :nullify
end
