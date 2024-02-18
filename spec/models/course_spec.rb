# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Course, type: :model do
  describe 'associations' do
    it { should have_many(:tutors) }
    it { should accept_nested_attributes_for(:tutors) }
  end

  describe 'validation' do
    it { should validate_presence_of(:name) }
    it 'validates associated tutors' do
      course = Course.new(name: 'Math')
      tutor = course.tutors.build(name: 'John Doe')

      expect(course.valid?).to be_truthy
      expect(tutor.valid?).to be_truthy
    end
  end
end
