# maintains a child-parent relationship between two instructions
class Reference < ActiveRecord::Base
  belongs_to :instruction
  validates :instruction_id, :presence => true
  validates :child_id, :presence => true
end