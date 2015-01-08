require "coinsetter/version"

require 'json'
require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'active_model'
require 'faraday'

require "coinsetter/configuration"
require "coinsetter/net"
require "coinsetter/helper"
require "coinsetter/model"
require "coinsetter/collection"
require "coinsetter/customer/accounts"
require "coinsetter/customer/account"
require "coinsetter/client_sessions"
require "coinsetter/client_session"
require "coinsetter/orders"
require "coinsetter/order"

String.send(:include, ActiveSupport::Inflector)

module Coinsetter
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.configured?
    configuration.username && configuration.password && configuration.ip_address
  end

  def self.with_session
    if client_session.kind_of? ClientSession
      yield client_session if block_given?
    else
      destroy_client_session!
      {error: 'No Client Session available.'}
    end
  end

  def self.client_session
    @client_session ||= ClientSessions.new.create(credentials)
  end

  def self.get_account(account_uuid)
    Customer::Accounts.new(client_session.uuid).get(account_uuid)
  end

  def self.destroy_client_session!
    client_session.destroy!
    @client_session = nil
  end

  def self.orders(uuid=nil)
    Orders.new(uuid || client_session.uuid)
  end

  def self.accounts(uuid=nil)
    Customer::Accounts.new(uuid || client_session.uuid)
  end

  def self.list_orders(account_id, view="OPEN")
    orders.list("customer/account/#{account_id}/order", view: view)
  end

  def self.list_accounts
    accounts.list
  end

  def self.get_order(order_uuid)
    orders.get(order_uuid)
  end

  def self.add_order_with_new_session(side='BUY', options={})
    order = with_session do |client_session|
      params = default_options.merge(options)
      params.merge!(side: side,
                    customerUuid: client_session.customer_uuid)
      orders.create(params)
    end

    order.kind_of?(Order) ? Coinsetter.get_order(order.uuid) : nil
  end

  def self.add_order(side='BUY', options={})
    params = default_options.merge(options)
    params.merge!(side: side,
                  customerUuid: client_session.customer_uuid)
    orders.create(params)
  end

  # Required Order Params
  # requestedQuantity, requestedPrice, accountUuid
  def self.buy_order(amount, price, account_uuid, options={})
    add_order('BUY', options.merge(required_params(amount, price, account_uuid)))
  end

  def self.sell_order(amount, price, account_uuid, options={})
    add_order('SELL', options.merge(required_params(amount, price, account_uuid)))
  end

  def self.default_options
    {
      symbol: "BTCUSD",
      orderType: ("LIMIT"),
      routingMethod: 2
    }
  end

  def self.required_params(amount, price, account_uuid)
    {
      requestedQuantity: amount,
      requestedPrice: price,
      accountUuid: account_uuid
    }
  end

  private

  def self.credentials
    {
      username: configuration.username,
      ipAddress: configuration.ip_address,
      password: configuration.password
    }
  end
end
