# frozen_string_literal: true

class Course < ApplicationRecord
  ## Associations
  has_many :tutors, dependent: :destroy

  ### Validations
  validates :name, presence: true

  # Validate that a course can have many tutors
  validates_associated :tutors

  # Add this line to accept nested attributes for tutors
  accepts_nested_attributes_for :tutors
end
