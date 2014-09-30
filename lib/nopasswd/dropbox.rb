require "dropbox_sdk"

module NoPasswd
  # Should inherit from a common class for all sync classes
  class Dropbox

    def initialize
      @flow = DropboxOAuth2FlowNoRedirect.new(
        NoPasswd.config[:dropbox][:app_key],
        NoPasswd.config[:dropbox][:app_secret]
      )
    end

    def authorize
      authorize_url = @flow.start()
      access_token = ask "Please go to #{@flow.authorize_url} and enter the code: "
    end

    def sync
      file = open("#{NoPasswd.config[:config_path]}/data")
      response = client.put_file('/data', file)
    end
  end
end
