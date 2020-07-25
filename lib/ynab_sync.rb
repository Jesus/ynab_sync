require "ynab_sync/account_sync"
require "ynab_sync/plaid_account"
require "ynab_sync/settings"
require "ynab_sync/settings"
require "ynab"

module YnabSync
  class << self
    def sync
      plaid_settings = YnabSync::Settings.instance.settings["plaid"]
      Settings.instance.accounts_in_sync.each do |account|
        AccountSync.perform(
          plaid_account: YnabSync::PlaidAccount.new(
            client_id: plaid_settings["client_id"],
            secret: plaid_settings["secret"],
            access_token: account[:plaid_access_token]
          ),
          ynab_budget_id: account[:budget_id],
          ynab_account_id: account[:account_id]
        )
      end
    end

    def dump_ynab_accounts
      settings = YnabSync::Settings.instance.settings["ynab"]
      ynab = YNAB::API.new settings["access_token"]

      budget_response = ynab.budgets.get_budgets
      budgets = budget_response.data.budgets

      budgets.each do |budget|
        puts "Budget: #{budget.name} (id: #{budget.id})"
        account_response = ynab.accounts.get_accounts budget.id
        accounts = account_response.data.accounts
        accounts.each do |account|
          puts "  #{account.name} (id: #{account.id})"
        end
      end
    end
  end
end
