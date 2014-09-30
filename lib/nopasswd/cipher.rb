class NoPasswd::Cipher

  def initialize(passwd)
    @passwd = passwd
  end

  def load
    # TODO Check the file exists
    encrypted_data = File.read("#{NoPasswd.config[:config_path]}/data")

    begin
      data_json = NoPasswd::AES.decrypt(encrypted_data, @passwd)
    rescue OpenSSL::Cipher::CipherError => e
      return false
    end
    return JSON.parse(data_json)
  end

  def store(data)
    # TODO Check the file exists
    File.open("#{NoPasswd.config[:config_path]}/data", "w") do |f|
      f.write(NoPasswd::AES.encrypt(data.to_json, @passwd))
    end
  end
end
