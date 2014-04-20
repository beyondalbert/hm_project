require 'records'
  class Base < Grape::API
    mount Records
  end
