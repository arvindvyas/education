# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tutor, type: :model do
  describe 'associations' do
    it { should belong_to(:course) }
  end

  describe 'validation' do
    it { should validate_presence_of(:name) }
    it 'validates uniqueness of course_id' do
      # Create a course
      course = Course.create(name: 'Math')

      # Create tutors with the same course_id
      Tutor.create(name: 'John Doe', course_id: course.id)
      tutor = Tutor.new(name: 'Jane Doe', course_id: course.id)

      # Expect the tutor to be invalid due to the uniqueness validation
      expect(tutor).not_to be_valid
      expect(tutor.errors[:course_id]).to include('has already been taken')
    end
  end
end
