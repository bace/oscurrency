class AddRespondByDateToReqs < ActiveRecord::Migration[4.2]
  def change
    add_column :reqs, :respond_by_date, :datetime
  end
end
