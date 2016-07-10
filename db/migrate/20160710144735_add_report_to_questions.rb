class AddReportToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :report, :boolean
  end
end
