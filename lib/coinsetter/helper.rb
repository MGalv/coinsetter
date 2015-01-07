module Coinsetter
  module Helper
    def self.parse_objects!(string, klass)
      string = "{\"empty\":[]}" if string == ""

      objects = JSON.parse(string).first.last
      objects.collect do |t_json|
        parse_object!(t_json, klass)
      end
    end

    def self.parse_object!(object, klass)
      object = JSON.parse(object) if object.is_a? String

      klass.new(object)
    end

    def self.parse_message!(string)
      string = "[]" if string == ""

      JSON.parse(string)
    end
  end
end
