class CreateCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :courses do |c|
      c.string :review
      c.integer :course_id
    end
  end
end
