# frozen_string_literal: true

# app/controllers/api/v1/courses_controller.rb
module Api
  module V1
    class CoursesController < ApplicationController
      DEFAULT_ITEMS_PER_PAGE = 10
      DEFAULT_PAGE = 1
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
        pagy, courses = pagy_with_pagination(Course.includes(:tutors).all)

        render json: {
          data: courses.as_json(only: %i[id name], include: { tutors: { only: %i[id name] } }),
          meta: { pagination: pagy_metadata(pagy) }
        }
      end

      private

      # Strong parameters for creating a course with associated tutors.
      def course_params
        params.require(:course).permit(:name, tutors_attributes: [:name])
      end

      def pagy_with_pagination(scope)
        page = params.fetch(:page, DEFAULT_PAGE).to_i
        items_per_page = params.fetch(:per_page, DEFAULT_ITEMS_PER_PAGE).to_i
        pagy(scope, page: page, items: items_per_page)
      end

      def pagy_metadata(pagy)
        {
          current_page: pagy.page,
          next_page: pagy.next,
          prev_page: pagy.prev,
          total_pages: pagy.pages,
          total_entries: pagy.count
        }
      end
    end
  end
end
