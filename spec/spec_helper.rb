require 'chefspec'

Dir["./cookbooks/*/spec/support/**/*.rb"].sort.each {|f| require f}
