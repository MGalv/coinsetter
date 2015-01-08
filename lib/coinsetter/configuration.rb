module Coinsetter
  class Configuration
    attr_accessor :username, :password, :ip_address, :staging

    def initialize
      @staging = false
    end

    def uri
      "https://#{'staging-' if staging}api.coinsetter.com/v1/"
    end
  end
end
