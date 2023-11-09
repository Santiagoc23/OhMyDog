class Adoption < ApplicationRecord
  belongs_to :user
  #puede no tener nombre, en el index se mostrara "Sin nombre"
  validates :race, presence: true
  validates :sex, presence: true
  validates :description, presence: true
  validates :situation, presence: true
  validates :size, presence: true
end
