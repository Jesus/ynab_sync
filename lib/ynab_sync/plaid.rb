require 'singleton'
require 'plaid'

class YnabSync::Plaid
  include Singleton

  def initialize
    settings = YnabSync::Settings.get["plaid"]
    @client = Plaid::Client.new(
      env: :development,
      client_id: settings["client_id"],
      secret: settings["secret"]
    )
    @access_token = settings["accounts"][0]["access_token"]
  end

  def get_transactions
    @client.transactions.get(@access_token, '2020-07-01', '2020-07-31')
  end
end
