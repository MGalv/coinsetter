module Coinsetter
  class Collection
    attr_accessor :module, :name, :model, :path, :response, :session_uuid

    def initialize(uuid=nil)
      self.session_uuid = uuid ? {'coinsetter-client-session-id' => uuid} : {}
      self.module = self.class.name.singularize.underscore
      split_module = self.module.split('/')
      split_module.shift
      self.name   = split_module.join('/')
      self.model  = self.module.camelize.constantize
      last = split_module.pop
      self.path = (split_module + [last.camelize(:lower)]).join('/')
    end

    def create(options={}, route=path, headers={})
      headers.merge!(session_uuid)
      self.response = Coinsetter::Net.post(route, options, headers)

      parse
    end

    def list(route=path, options={}, headers={})
      headers.merge!(session_uuid)
      self.response = Coinsetter::Net.get(route, options, headers)

      parse_collection
    end

    def get(id, route=path, options={}, headers={})
      headers.merge!(session_uuid)
      self.response = Coinsetter::Net.get("#{route}/#{id}", options, headers)

      parse
    end

    def example
      JSON.generate({error: "Something went wrong."})
    end

    private
    def parse
      if response.include? "\"response\":\"error\""
        Coinsetter::Helper.parse_message! response
      else
        Coinsetter::Helper.parse_object! response, model
      end
    end

    def parse_collection
      @collection ||= Coinsetter::Helper.parse_objects! response, model
    end
  end
end
