class Instruction < ActiveRecord::Base
  belongs_to :bdl_file
  validates :i_type, :presence => true
  has_many :name_values
  has_many :references

  def self.create_with_data!(instruction_blob, parent_id)
    instruction_blob = Instruction.sanitize_strings instruction_blob
    #instruction_blob = instruction_blob.gsub("\r\n", " ")
    instruction_blob = Instruction.sanitize_lists instruction_blob
    t_n = Instruction.get_type(instruction_blob)
    instruction = nil
    #ActiveRecord::Base.transaction do
    begin
      instruction = Instruction.create! :bdl_file_id => parent_id, :i_type => t_n[:type],
                                        :uname => t_n[:name], :data => instruction_blob
      instruction.set_name_values if !instruction.nil?
    rescue => e
      Rails.logger.warn e.message
    end
    #end
    #Instruction.create_references!
    instruction
  end


  # embedded strings can have spaces and must be normalized
  # replace spaces in strings with underscores.
  def self.sanitize_strings(instruction_blob)
    instruction_strings = instruction_blob.scan(/\".+\"/)
    instruction_strings.each do |a_string|
      b_string = a_string.gsub(" ", "_")
      instruction_blob = instruction_blob.gsub(a_string, b_string)
    end
    instruction_blob=instruction_blob.gsub("\"","")
    instruction_blob.strip
  end

  # lists are parenthesis surrounded and comma separated.
  # we remove spaces for easy tokenization
  def self.sanitize_lists(instruction_blob)
    lists = instruction_blob.scan(/\(.+\)/)
    lists.each do |a_string|
      b_string = a_string.gsub(" ", "")
      instruction_blob = instruction_blob.gsub(a_string, b_string)
    end
    instruction_blob
  end

  # instruction => [<type> || <U-name> = <type>]
  def self.get_type(instruction)
    tokens = instruction.split
    return {:type => tokens[0], :name => nil} if tokens.length < 2
    (tokens[1] == "=") ? {:type => tokens[2], :name => tokens[0]} : {:type => tokens[0], :name => nil}
  end

  # we assume all nv pairs are of the form name = value
  def set_name_values
    tokens = data.split("=")
    split_tokens = tokens.inject([]) { |current, token| current += token.split; current }
    puts "st #{split_tokens.inspect}"
    if (split_tokens.length > 2)
      index = 2
      while (index <= split_tokens.length-2) do
        NameValue.create! :instruction_id => self.id, :name => split_tokens[index], :value => split_tokens[index+1]
        index += 2
      end
    end
  end

  # search all currently created instructions and create
  # references if the uname of an instruction is referred to by the
  # value of a name_value
  def self.create_references!
    ActiveRecord::Base.transaction do
      NameValue.find_each do |name_value|
        ref_instruction = Instruction.find_by_uname name_value.value
        if (!ref_instruction.nil?)
          existing_reference = Reference.where("instruction_id = ?  and child_id = ?", name_value.instruction_id, ref_instruction.id)
          Reference.create! :instruction_id => name_value.instruction_id, :child_id => ref_instruction.id if existing_reference.empty?

        end
      end
    end
  end




end
