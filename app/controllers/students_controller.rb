class StudentsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :student_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_data_error

  def index
    students = Student.all
    render json: students
  end

  def show
    student = find_student
    render json: student
  end

  def create
    instructor = find_instructor

    new_student = instructor.students.create!(student_params)

    render json: new_student, status: :created
  end

  # do we use the ! here?
  # Must be associated with an instructor.. not sure how we make this happen?
  def update
    instructor = find_instructor

    student = find_student
    student.update!(student_params)
    render json: updated_student
  end

  def destroy
    student = find_student
    student.destroy
    head :no_content
  end

  private
  
  def student_params
    params.permit(:name, :major, :age)
  end

  def find_instructor
    Instructor.find_by(id: params[:instructor_id])
  end

  def find_student
    Student.find_by(id: params[:id])
  end

  def student_not_found
    render json: {error: "Student not found"}, status: :not_found
  end

  def handle_invalid_data_error(e)
    render json: {errors: e.record.errors.full_messages}, status: :unprocessable_entity
  end
end
