# maintain name-value pairs for an instruction
class NameValue < ActiveRecord::Base
  belongs_to :instruction
  validates :instruction_id, :presence => true
  validates :name, :presence => true
  validates :value, :presence => true
end