class Exercise < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :instructions, presence: true
end
