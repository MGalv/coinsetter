require "coinsetter/version"

require 'json'
require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'active_model'
require 'rest_client'

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
    session = Coinsetter::ClientSessions.new
    client_session = session.create(credentials)

    if client_session.kind_of? Coinsetter::ClientSession
      yield client_session if block_given?
    end

    client_session.destroy!
  end

  def self.orders
    @@orders ||= Coinsetter::Orders.new
  end

  def self.add_order(side='BUY', options={})
    with_session do |client_session|
      params = default_options.merge(options)
      params.merge!(side: side,
                    customerUuid: client_session.customer_uuid)
      orders.create(params)
    end
  end

  # Required Order Params
  # requestedQuantity, requestedPrice, accountUuid
  def self.buy_order(amount, price, account_uuid, options={})
    add_order('BUY', options.merge(required_params(amount, price, account_uuid)))
  end

  def self.sell_order(amount, price, account_uuid, options={})
    add_order('BUY', options.merge(required_params(amount, price, account_uuid)))
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
