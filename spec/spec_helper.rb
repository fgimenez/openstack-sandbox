require 'chefspec'

RSpec.configure do |config|
  config.platform = 'ubuntu'

  config.version = '12.04'
end

Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].sort.each {|f| require f}
