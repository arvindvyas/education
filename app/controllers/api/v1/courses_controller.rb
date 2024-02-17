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
        # Assuming you have pagy set up for the Course model
        page = params[:page].to_i
        items_per_page = params[:per_page].to_i
        page = DEFAULT_PAGE if page.zero? # Default to page 1 if page is not provided
        items_per_page = DEFAULT_ITEMS_PER_PAGE if items_per_page.zero? # Default to 10 items per page if not provided

        # Paginate using pagy
        pagy, courses = pagy(Course.includes(:tutors).all, page: page, items: items_per_page)

        render json: {
          data: courses.as_json(
            only: %i[id name],
            include: {
              tutors: { only: %i[id name] }
            }
          ),
          meta: {
            pagination: {
              current_page: pagy.page,
              next_page: pagy.next,
              prev_page: pagy.prev,
              total_pages: pagy.pages,
              total_entries: pagy.count
            }
          }
        }
      end

      private

      # Strong parameters for creating a course with associated tutors.
      def course_params
        params.require(:course).permit(:name, tutors_attributes: [:name])
      end
    end
  end
end
