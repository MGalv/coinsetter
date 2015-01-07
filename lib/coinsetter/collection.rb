module Coinsetter
  class Collection
    attr_accessor :module, :name, :model, :path, :response

    def initialize
      self.module = self.class.name.singularize.underscore
      split_module = self.module.split('/')
      split_module.shift
      self.name   = split_module.join('/')
      self.model  = self.module.camelize.constantize
      last = split_module.pop
      self.path   = split_module.join('/') + last.camelize(:lower)
    end

    def create(options={}, route=path)
      if Coinsetter.configured?
        self.response = Coinsetter::Net.post(route, options)
      else
        self.response = example
      end

      parse
    end

    def list(route=path, options={})
      if Coinsetter.configured?
        self.response = Coinsetter::Net.get(route, options)
      else
        self.response = example
      end

      parse_collection
    end

    def get(id, route=path, options={})
      self.response = Coinsetter::Net.get("#{route}/#{id}", options)
      parse
    end

    def example
      JSON.generate({error: "Something went wrong."})
    end

    private
    def parse
      @parsed ||=
        if response.include? "\"requestStatus\":\"SUCCESS\""
          Coinsetter::Helper.parse_object! response, model
        else
          Coinsetter::Helper.parse_message! response
        end
    end

    def parse_collection
      @collection ||= Coinsetter::Helper.parse_objects! response, model
    end
  end
end
