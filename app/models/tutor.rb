# app/models/tutor.rb
class Tutor < ApplicationRecord
  belongs_to :course

  validates :name, presence: true

  # Validate that a tutor can teach only one course
  validates_uniqueness_of :course_id
end
