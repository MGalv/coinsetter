module Bitstamp
  module Net
    def self.uri(path)
      return "#{Bitstamp.uri}#{path}"
    end

    def self.get(path, headers={})
      RestClient.get(uri(path), headers)
    end

    def self.post(path, args={}, headers={})
      RestClient.post(uri(path), args, headers)
    end

    def self.put(path, args={}, headers={})
      RestClient.put(uri(path), args, headers)
    end

    def self.delete(path, headers={})
      RestClient.delete(uri(path), headers)
    end
  end
end
