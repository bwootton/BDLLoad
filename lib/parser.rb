module BDL
  class Parser
    attr :data, :instructions
    attr :t_hash, :i_hash

    # get data from a file
    def set_file(filename)
      @data = ""
      File.open(filename, "r") do |file|
        file.each_line do |line|
          @data << line if line.strip.match(/^\$/).nil?
        end
      end
    end

    # get data from a data stream
    def set_data(data)
      @data = data
    end


    # instructions delimited by ".."
    def tokenize
      @i_hash = Hash.new
      @t_hash = Hash.new

      @instructions = data.split("..")
      @instructions.each do |instruction|
        instruction = sanitize_strings instruction
        instruction = instruction.gsub("\r\n", " ")
        t_n = get_type(instruction)
        @t_hash[t_n[:type]] ||= []
        @t_hash[t_n[:type]] << instruction
        @i_hash[t_n[:name]] = instruction if !t_n[:name].nil?
      end
    end

    # embedded strings can have spaces and must be normalized
    # replace spaces in strings with underscores.
    def sanitize_strings instruction
      instruction_strings = instruction.scan(/\".+\"/)
      instruction_strings.each do |a_string|
        b_string = a_string.gsub(" ", "_")
        instruction = instruction.gsub(a_string, b_string)
      end
      instruction.strip
    end

    # instruction => [<type> || <U-name> = <type>] 
    def get_type(instruction)
      tokens = instruction.split
      return {:type => tokens[0], :name => nil} if tokens.length < 2
      (tokens[1] == "=") ? {:type => tokens[2], :name => tokens[0]} : {:type => tokens[0], :name => nil}
    end


  end

end
        
