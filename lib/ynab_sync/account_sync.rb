require 'ynab_sync/plaid_account'
require 'ynab_sync/transaction'

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
    n_imported_transactions = 0
    response = @ynab_client.transactions.get_transactions_by_account(
      @ynab_budget_id,
      @ynab_account_id
    )
    ynab_transactions = response.data.transactions.map do |transaction|
      YnabSync::YnabTransaction.new transaction
    end

    # For each transaction in the bank account, see if it exists in YNAB
    @plaid_account.transactions.reverse.each do |plaid_transaction|
      transaction = YnabSync::PlaidTransaction.new plaid_transaction

      # This transaction already exists in YNAB, skip to next
      next if ynab_transactions.any? { |t| t == transaction }

      # This transaction is a transfer, we don't support importing these yet
      next if transaction.is_transfer?

      @ynab_client.transactions.create_transaction @ynab_budget_id, {
        transaction: {
          account_id: @ynab_account_id,
          date: transaction.date,
          memo: transaction.memo,
          amount: transaction.amount
        }
      }
      n_imported_transactions += 1
      puts "Created #{transaction.id}: #{plaid_transaction}"
      puts ""
    end

    puts "Summary: #{n_imported_transactions} transaction(s) imported"
  end
end
