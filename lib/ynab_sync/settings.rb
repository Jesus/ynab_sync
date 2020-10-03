require 'singleton'
require 'yaml'

CONFIG_FILE = "credentials.yml"
CATEGORIES_FILE = "categories.yml"

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
        account_ref: account_settings["plaid_account_ref"],
        budget_id: account_settings["budget_id"],
        account_id: account_settings["account_id"],
        plaid_access_token: plaid_account["access_token"],
        delay_days: account_settings["delay_days"] || 0
      }
    end
  end

  def categories(budget_id)
    config_entry = @settings["ynab"]["categorizations"]
      .find { |x| x["budget_id"] == budget_id }

    raise "No categorization file found for #{budget_id}" if config_entry.nil?

    YAML.load_file(config_entry["file"])
  end
end
