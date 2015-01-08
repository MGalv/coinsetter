module Coinsetter
  module Customer
    class Account < Coinsetter::Model
      attr_accessor :account_uuid, :customer_uuid, :account_number, :name, :description, :btc_balance
      attr_accessor :usd_balance, :account_class, :active_status, :approved_margin_ratio, :create_date

    end
  end
end
