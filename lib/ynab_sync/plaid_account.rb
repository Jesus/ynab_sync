require 'singleton'
require 'date'
require 'plaid'

class YnabSync::PlaidAccount
  def initialize(client_id:, secret:, access_token:)
    @client = ::Plaid::Client.new(
      env: :development,
      client_id: client_id,
      secret: secret
    )
    @access_token = access_token
  end

  def transactions(from: Date.today - 7, to: Date.today + 1)
    @client.transactions.get(@access_token, from.to_s, to.to_s).transactions
  end
end
