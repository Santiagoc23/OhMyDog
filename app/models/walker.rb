class Walker < ApplicationRecord
  validates :phoneNum, presence: true, format: { with: /\A\d+\z/, message: "El télefono solo puede números, revise el campo e inténtelo nuevamente. "}
  has_many :users, dependent: :nullify

  has_many :reported_walker_associations, class_name: 'Reportedwalker', foreign_key: 'walker_id'
  has_many :reporting_users, through: :reported_walker_associations, dependent: :nullify
end
