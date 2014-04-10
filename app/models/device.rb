class Device < ActiveRecord::Base
  validates_presence_of :serial_num
  validates_uniqueness_of :serial_num
end
