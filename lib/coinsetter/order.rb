module Coinsetter
  class Order < Coinsetter::Model
    attr_accessor :uuid, :account_uuid, :cost_basis, :customer_uuid, :filled_quantity, :open_quantity
    attr_accessor :order_number, :order_ype, :stage, :requested_uantity, :requested_price, :side
    attr_accessor :routing_method, :create_date, :symbol

    def destroy!(client_session_uuid)
      call = Coinsetter::Net.delete(path, {"coinsetter-client-session-id" => client_session_uuid})
      parse call
    end

    def path
      "order/#{uuid}"
    end

    def parse(string)
      Coinsetter::Helper.parse_message! string
    end
  end
end
