require "ynab_sync/settings"
require "ynab_sync/version"
require "ynab_sync/plaid"
require "ynab"

module YnabSync
  class Error < StandardError; end

  class << self
    def sync
      self.dump_ynab_accounts
    end

    def dump_ynab_accounts
      settings = YnabSync::Settings.get["ynab"]
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
