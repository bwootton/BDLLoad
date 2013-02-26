Factory.define :instruction do |ins|
  ins.i_type "a_type"
  ins.data "some_data"
end

Factory.define :instruction_with_uname, :parent => :instruction do |ins|
  ins.sequence(:uname){|i| "uname_#{i.to_s}"}
end
