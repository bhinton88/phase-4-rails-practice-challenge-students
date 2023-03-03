class InstructorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :instructor_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_data_error

  def index
    instructors = Instructor.all
    render json: instructors
  end

  def show
    instructor = find_instructor
    render json: instructor
  end

  def create
    new_instructor = Instructor.create!(instructor_params)
    render json: new_instructor, status: :created
  end

  def update
    instructor = find_instructor
    instructor.update!(instructor_params)
    render json: instructor
  end

  def destroy
    instructor = find_instructor
    instructor.destroy
    head :no_content
  end


  private

  def instructor_params
    params.permit(:name)
  end

  def find_instructor
    Instructor.find_by(id: params[:id])
  end

  def instructor_not_found
    render json: {error: "Instructor not found"}, status: :not_found
  end

  def handle_invalid_data_error(e)
    render json: {errors: e.record.errors.full_messages}, status: :unprocessable_entity
  end

end
