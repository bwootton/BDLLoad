FactoryGirl.define do
  factory :bdl_file do |bf|
    bf.filename "file.bdl"
    bf.data "a b .. c d .."
  end

  factory :bdl_file_with_instruction, :parent => :bdl_file do
    after_create do |bf|
      FactoryGirl.create(:instruction, :bdl_file => bf)
    end
  end
end