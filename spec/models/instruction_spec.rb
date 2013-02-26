require 'spec_helper'
describe Instruction do
  let(:data_normal) { "\"a name\"=a_type \r\nfield1 = value1 \r\nfield2 = value2 field3 =  \"a value3\"" }
  let(:data_child) { "value1 = b_type field1b = value1b" }
  let(:data_list) { "a = b c = ( 1, 2, 3) d = f" }
  let(:vertices) { "\"201A Lounge pg\" = POLYGON
     V1               = ( 82.75, 62 )
     V2               = ( 79.8201, 54.5958 )
     V3               = ( 98, 48.25 )
     V4               = ( 101.5, 58.75 )
     V5               = ( 102, 61.25 )
     V6               = \"( 95.75, 63.5 )\"" }

  describe "string sanitizer" do
    it "should keep strings together" do
      sanitized = Instruction.sanitize_strings data_normal
      puts sanitized
      sanitized.scan("a_value3").length.should eq 1
      sanitized.scan("a_name").length.should eq 1
    end
  end

  describe "data normal instruction" do
    before do
      @instruction = Instruction.create_with_data! data_normal, 1
    end

    it "should have 3 token pairs" do
      @instruction.name_values.count.should eq 3
    end

    describe "with a child instruction" do
      before do
        @child_instruction = Instruction.create_with_data! data_child, 1
      end

      it "should have a single reference" do
        #@instruction.references.count.should eq 1
        #@instruction.references[0].child_id.should eq @child_instruction.id
        #@instruction.references[0].instruction_id.should eq @instruction.id
      end
    end
  end

  describe "data with list" do
    before do
      @instruction = Instruction.create_with_data! data_list, 1
    end

    it "should have 2 token pairs" do
      @instruction.name_values.count.should eq 2
    end
  end

  describe "data with vertices" do
    before do
      @instruction = Instruction.create_with_data! vertices, 1
    end

    it "should have 2 token pairs" do
      @instruction.name_values.count.should eq 6
      @instruction.name_values.each{|an| puts an.inspect}
    end

  end
end
