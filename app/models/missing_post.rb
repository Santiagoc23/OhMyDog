class MissingPost < ApplicationRecord
    belongs_to :user
    validates :name, presence: true
    validates :breed, presence: true
    validates :gender, presence: true
    validates :description, presence: true
    validates :age, presence: true
    validates :size, presence: true
    validates :zone, presence: true
    has_one_attached :image
  end
