require 'spec_helper'

describe BdlFile do

  let(:some_instructions) { "a = b \r\n $----- \r\n some_data = a .. \r\n c d .. e .." }
  let(:string_instruction) { " \"a string name\" = a_type \r\n.." }
  let(:room) {"\"5-ST2 Stair 2\" = SPACE
     HEIGHT           = 8.75
     SHAPE            = POLYGON
     FLOOR-WEIGHT     = 0
     FURNITURE-TYPE   = LIGHT
     FURN-FRACTION    = 0.2
     ZONE-TYPE        = UNCONDITIONED
     PEOPLE-SCHEDULE  = \"Office2\"
     LIGHTING-SCHEDUL = ( \"Office2\" )
     EQUIP-SCHEDULE   = ( \"Office2\" )
     LIGHTING-TYPE    = ( SUS-FLUOR )
     LIGHTING-W/AREA  = ( 1 )
     EQUIPMENT-W/AREA = ( 1 )
     FURN-WEIGHT      = 2.5
     AREA/PERSON      = 100
     POLYGON          = \"5-ST2 Stair 2 pg\"
     C-SUB-AREA       = ( 146.817 )
     C-OCC-TYPE       = ( 49 )
     .."}

  describe "with room description" do
    before do
      @bdl_file = Factory :bdl_file, :data => room
      @bdl_file.parse
    end

    it "should find polygon name" do
      @bdl_file.instructions[0].name_values.find_by_name('POLYGON').value.should eq "5-ST2_Stair_2_pg"
    end
  end
  describe "comment stripping" do
    it "should strip comments from data" do
      BdlFile.strip_comments("a b \r\n $comment \r\n c d ..").should eq "a b \r\n c d .."
    end

    it "should strip a single comment" do
      BdlFile.strip_comments("$hello").length.should eq 0
    end
  end


  describe "bdl_file" do
    describe "with a string token" do
      before do
        @bdl_file = Factory :bdl_file, :data => string_instruction
        @bdl_file.parse
      end

      it "should have a single instruction" do
        puts @bdl_file.instructions.inspect
        @bdl_file.instructions.count.should eq 1
      end

      it "should have a type and uname" do
        @bdl_file.instructions[0].i_type.should eq "a_type"
        @bdl_file.instructions[0].uname.should eq "a_string_name"
        @bdl_file.instructions[0].data.should eq "a_string_name = a_type"
      end
    end

    describe "with input" do
      before do
        @bdl_file = Factory :bdl_file, :data => some_instructions
        @bdl_file.parse
      end

      it "should parse and persist the instructions" do
        @bdl_file.instructions.count.should eq 3
        @bdl_file.instructions[0].data.should eq "a = b \r\n some_data = a"
        @bdl_file.instructions[1].data.should eq "c d"
        @bdl_file.instructions[2].data.should eq "e"
      end

    end


    it "should delete old instructions" do
      bdl_file = Factory :bdl_file_with_instruction
      bdl_file.should_not eq nil
      bdl_file.delete_instructions
      bdl_file.instructions.count.should eq 0
    end
  end


end