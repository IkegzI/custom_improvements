class CreateTrackerChecks < ActiveRecord::Migration
  def change
    create_table :tracker_checks do |t|
      t.references :tracker, foreign_key: true
    end
  end
end
