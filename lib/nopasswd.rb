require 'nopasswd/config'
require 'nopasswd/cli'
require 'nopasswd/aes'
require 'nopasswd/passwd'
require 'nopasswd/cipher'
require 'nopasswd/dropbox'

module NoPasswd
  def self.first_run?
    if !Dir.exists?(NoPasswd.config[:config_path]) ||
       !File.exists?(NoPasswd.config[:config_path] + "/data")
      return true
    end
    return false
  end
end

