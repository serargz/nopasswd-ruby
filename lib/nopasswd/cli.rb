require 'thor'
require 'json'
require 'clipboard'

# TODO: Refactoring, extract all the logic to classes

module NoPasswd
  class CLI < Thor

    # Adds a new account to the (encrypted) data file
    desc "add", "Adds a new account to store in nopasswd"
    method_option :service, type: :string, desc: "Service (e.g. Gmail)"
    method_option :username, type: :string, desc: "Username"
    def add
      if NoPasswd.first_run?
        invoke :config
      end

      request_access

      service, username = options[:service], options[:username]

      service = ask("Service: ") unless service
      raise Thor::Error, "Please enter the service to associate the account" if service.empty?

      username = ask("Username: ") unless username
      raise Thor::Error, "Please enter the username associated" if username.empty?

      say "Generating new password for #{username} in #{service}..."
      @data['accounts'][service] = {} unless @data['accounts'].key?(service)
      @data['accounts'][service][username] = Passwd.generate

      @cipher.store(@data)

      say "Done."
    end

    # Gets the password for the account, from the (encrypted) data file
    desc "get", "Gets the password for the site and account given"
    method_option :service, type: :string, desc: "Service (e.g. Gmail)"
    method_option :username, type: :string, desc: "Username"
    def get(service, username)

      request_access

      if @data['accounts'].key?(service) && @data['accounts'][service].key?(username)
        #
        # TODO: Delete password from clipboard after 20 seconds.
        #
        Clipboard.copy(@data['accounts'][service][username])
        say "Your password for #{service}:#{username} is in the clipboard"
        return
      end

      say "Sorry, #{username}:#{service} was not found."
    end

    desc "sync", "Syncronizes the encrypted file with dropbox"
    def sync
      @data['config']['dropbox']
      dropbox = NoPasswd::Dropbox.new
      dropbox.authorize unless dropbox.authorized?
    end

    # Decrypt and lists all the accounts stored in the file
    desc "list", "Lists all the account names stored"
    def list
      request_access

      @data["accounts"].each do |service, accounts|
        say "#{service}:"
        accounts.each do |account, pass|
          say "  #{account}"
        end
      end
    end

    # Configures the master password and creates an empty data file
    desc "config", "Configures the master password."
    def config
      say "It seems it's the first time you run nopasswd... #{NoPasswd.config[:config_path]}"
      passwd = ask("Please type your master password: ")
      passwd_confirmation = ask("Ok, please type it again: ")

      if passwd == passwd_confirmation
        FileUtils.mkdir_p NoPasswd.config[:config_path]
        File.open("#{NoPasswd.config[:config_path]}/data", "w") do |f|
          default_data = { 'accounts' => {}, 'config' => {} }
          f.write(AES.encrypt(default_data.to_json, passwd))
        end

        say "Awesome! your master password has been set, now you can store your passwords securely!"
        return
      end

      raise Thor::Error, "The passwords do not match!"
    end

  private

    def request_access
      passwd = ask("Please type your master password: ")
      @cipher = Cipher.new(passwd)
      @data = @cipher.load

      return if @data
      raise Thor::Error, "The master password is wrong"
    end

    def dropbox_auth(dropbox)

    end
  end
end
