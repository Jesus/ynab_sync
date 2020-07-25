require 'singleton'
require 'yaml'

CONFIG_FILE = "credentials.yml"

class YnabSync::Settings
  include Singleton

  attr_reader :settings,
              :accounts_in_sync

  def initialize
    @settings = YAML.load_file(CONFIG_FILE)
    @accounts_in_sync = @settings["ynab"]["accounts"].map do |account_settings|
      plaid_account = @settings["plaid"]["accounts"].find do |account|
        account["account_ref"] == account_settings["plaid_account_ref"]
      end
      raise "Access token not found" if plaid_account.nil?

      {
        budget_id: account_settings["budget_id"],
        account_id: account_settings["account_id"],
        plaid_access_token: plaid_account["access_token"]
      }
    end
  end
end
