# frozen_string_literal: true

# spec/controllers/api/v1/courses_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::CoursesController, type: :controller do
  describe 'POST #create' do
    it 'creates a course with tutors' do
      post :create, params: {
        course: {
          name: 'Math',
          tutors_attributes: [
            { name: 'John Doe' }
          ]
        }
      }

      expect(response).to have_http_status(:created)

      # Reload the course from the database to get the updated association
      course = Course.last
      expect(course.tutors.count).to eq(1)
      expect(course.tutors.first.name).to eq('John Doe')
    end

    it 'returns error response if there are validation errors' do
      # Assuming there's a validation error in the course creation
      allow_any_instance_of(Course).to receive(:save).and_return(false)

      post :create, params: {
        course: {
          name: '',
          tutors_attributes: [
            { name: 'John Doe' }
          ]
        }
      }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET #index' do
    describe 'GET #index' do
      it 'lists all courses with tutors' do
        # Create some courses with associated tutors
        course1 = Fabricate(:course, name: 'Math')
        Fabricate(:tutor, name: 'John Doe', course: course1)

        course2 = Fabricate(:course, name: 'Science')
        Fabricate(:tutor, name: 'Jane Doe', course: course2)

        get :index

        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response.length).to eq(2)

        # Check the first course and its tutor
        expect(json_response[0]['name']).to eq('Math')
        expect(json_response[0]['tutors'].length).to eq(1)
        expect(json_response[0]['tutors'][0]['name']).to eq('John Doe')

        # Check the second course and its tutor
        expect(json_response[1]['name']).to eq('Science')
        expect(json_response[1]['tutors'].length).to eq(1)
        expect(json_response[1]['tutors'][0]['name']).to eq('Jane Doe')
      end
    end
  end
end
