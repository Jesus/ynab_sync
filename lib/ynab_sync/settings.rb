require 'singleton'
require 'yaml'

CONFIG_FILE = "credentials.yml"

class YnabSync::Settings
  include Singleton

  attr_reader :settings

  def self.get
    self.instance.settings
  end

  def initialize
    @settings = YAML.load_file(CONFIG_FILE)
  end
end
