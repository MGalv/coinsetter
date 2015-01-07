module Coinsetter
  class ClientSession < Coinsetter::Model
    attr_accessor :uuid, :user_name, :customer_uuid

    def destroy!
      parse call("LOGOUT")
    end

    def heartbeat
      parse call("HEARTBEAT")
    end

    def path
      "clientSession/#{uuid}"
    end

    def call(action='HEARTBEAT')
      Coinsetter::Net.put(
        path,
        {action: action},
        {"coinsetter-client-session-id" => uuid}
      )
    end

    def parse(string)
      Coinsetter::Helper.parse_message! string
    end
  end
end
