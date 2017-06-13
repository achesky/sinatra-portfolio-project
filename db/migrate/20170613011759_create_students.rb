class CreateStudents < ActiveRecord::Migration[5.1]
  def change
      create_table :students do |c|
        c.string :username
        c.string :email
        c.string :password
      end
  end
end
