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
        expect(json_response['data'][0]['name']).to eq('Math')
        expect(json_response['data'][0]['tutors'].length).to eq(1)
        expect(json_response['data'][0]['tutors'][0]['name']).to eq('John Doe')

        # Check the second course and its tutor
        expect(json_response['data'][1]['name']).to eq('Science')
        expect(json_response['data'][1]['tutors'].length).to eq(1)
        expect(json_response['data'][1]['tutors'][0]['name']).to eq('Jane Doe')
      end

      it 'returns paginated courses with metadata' do
        # Create some test data using Fabrication
        Fabricate.times(15, :course)

        # Make a request with pagination parameters
        get :index, params: { page: 2, per_page: 5 }

        # Parse JSON response
        json_response = JSON.parse(response.body)

        # Assertions
        expect(response).to have_http_status(:ok)
        expect(json_response).to have_key('data')
        expect(json_response['data']).to be_an(Array)

        # Check the number of returned records
        expect(json_response['data'].count).to eq(5)

        # Check pagination metadata
        expect(json_response).to have_key('meta')
        expect(json_response['meta']).to have_key('pagination')
        expect(json_response['meta']['pagination']).to include(
          'current_page' => 2,
          'next_page' => 3,
          'prev_page' => 1,
          'total_pages' => 3,
          'total_entries' => 15
        )
      end
    end
  end
end
