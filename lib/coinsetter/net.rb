module Coinsetter
  module Net
    def self.uri
      Coinsetter.configuration.uri
    end

    def self.get(path, args={}, headers={})
      res = connection.get do |req|
        req.url path, args
        req.headers["Accept"] = "application/json"
        req.headers.merge!(headers)
      end

      body(res)
    end

    def self.post(path, args={}, headers={})
      res = connection.post do |req|
        req.url path
        req.headers['Content-Type'] = 'application/json'
        req.headers.merge!(headers)
        req.body =  JSON.generate(args)
      end

      body(res)
    end

    def self.put(path, args={}, headers={})
      res = connection.put do |req|
        req.url path, args
        req.headers['Content-Type'] = 'application/json'
        req.headers.merge!(headers)
      end

      body(res)
    end

    def self.delete(path, headers={})
      res = connection.delete do |req|
        req.url path
        req.headers["Accept"] = "application/json"
        req.headers.merge!(headers)
      end

      body(res)
    end

    def self.body(res)
      if res.status == 200
        res.body
      else
        JSON.generate({response: "error", status: res.status, message: res.body})
      end
    end

    def self.connection
      @@connection ||= Faraday.new(url: uri) do |faraday|
        faraday.request  :url_encoded
        faraday.response :logger
        faraday.adapter  Faraday.default_adapter
      end
    end
  end
end
