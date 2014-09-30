require 'helpers'
require 'nopasswd'
require 'pry'
require 'faker'

NoPasswd.configure do |config|
  config[:config_path] = File.expand_path("../support/tmp/.passwd", __FILE__)
end

RSpec.configure do |config|
  config.include Helpers
  # ...

  config.before do
    Thor::LineEditor.stub(:readline) do |message, options|
      case message
      when /Please type your master password:/
        "master_password"
      when /Ok, please type it again:/
        "master_password"
      when /Service:/
        Faker::Internet.domain_name
      when /username:/
        Faker::Internet.free_email
      else
        Faker::Lorem.word
      end
    end
  end

  config.after(:all) do
    FileUtils.rm_rf(File.expand_path("../support/tmp", __FILE__))
  end
end
