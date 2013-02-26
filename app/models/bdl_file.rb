require 'parser'
class BdlFile < ActiveRecord::Base
  has_many :instructions
  validates :filename, :presence => true, :uniqueness => true
  validates :data, :presence => true

  # remove comments and create instructions
  def parse
    self.data = BdlFile.strip_comments self.data
    save!
    tokenize
    Instruction.create_references!
  end

  # instructions delimited by ".."
  def tokenize
    instruction_blobs = self.data.split("..")
    ActiveRecord::Base.transaction do
      instruction_blobs.each do |instruction_blob|
        Instruction.create_with_data! instruction_blob, self.id
      end
    end
  end

  # comments start with $ and end with a new line
  def self.strip_comments data
    new_data = ""
    data.each_line { |line| new_data << line if line.strip.match(/^\$/).nil? }
    new_data
  end


  def delete_instructions
    self.instructions.each { |instruction| instruction.destroy }
  end


end
