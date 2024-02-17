# app/controllers/api/v1/courses_controller.rb
module Api
  module V1
    class CoursesController < ApplicationController
      # POST /api/v1/courses
      # Create a new course with associated tutors.
      def create
        course = Course.new(course_params)

        if course.save
          render json: course, status: :created
        else
          render json: { errors: course.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # GET /api/v1/courses
      # List all courses along with their tutors.
      def index
        courses = Course.includes(:tutors)
        render json: courses, include: [:tutors]
      end

      private

      # Strong parameters for creating a course with associated tutors.
      def course_params
        params.require(:course).permit(:name, tutors_attributes: [:name])
      end
    end
  end
end
