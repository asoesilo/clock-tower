class StatementTimeEntry < ActiveRecord::Base
  belongs_to :time_entry
  belongs_to :statement
end
