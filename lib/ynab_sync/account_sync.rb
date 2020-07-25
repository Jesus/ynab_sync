require 'ynab_sync/plaid_account'

class YnabSync::AccountSync
  def self.perform(**kwargs)
    syncer = new(**kwargs)
    syncer.perform
  end

  def initialize(plaid_account:, ynab_budget_id:, ynab_account_id:)
    @plaid_account = plaid_account
    init_ynab_client
    @ynab_budget_id = ynab_budget_id
    @ynab_account_id = ynab_account_id
  end

  private def init_ynab_client
    settings = YnabSync::Settings.instance.settings["ynab"]
    @ynab_client = YNAB::API.new settings["access_token"]
  end

  def perform
    response = @ynab_client.transactions.get_transactions_by_account(
      @ynab_budget_id,
      @ynab_account_id
    )
    ynab_transactions = response.data.transactions

    ynab_transactions.each do |t|
      puts t
      puts ""
    end

    # For each transaction in the bank account, see if it exists in YNAB
    @plaid_account.transactions.reverse.each do |transaction|
      # transaction: Plaid::Models::Transaction
      puts transaction
      puts ""
    end
  end
end
# I think they common id key for transactions in YNAB-Plaid should be a
# combo of: date-amount-memo, and we should generate the memo as
# some extra info such as location
