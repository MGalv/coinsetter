module Coinsetter
  class Configuration
    attr_accessor :username, :password, :ip_address, :uri

    def initialize
      @uri = 'https://api.coinsetter.com/v1/'
    end
  end
end
