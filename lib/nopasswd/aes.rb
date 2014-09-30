require 'openssl'

class NoPasswd::AES
  ITERATIONS = 20000

  def self.encrypt(message, passwd)
    update(:encrypt, message, passwd)
  end

  def self.decrypt(encrypted_message, passwd)
    update(:decrypt, encrypted_message, passwd)
  end


  private
    def self.key(passwd)
      key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(passwd, NoPasswd.config[:cipher][:salt], ITERATIONS, 256/8)
    end

    def self.update(action, data, passwd)
      cipher = OpenSSL::Cipher::AES256.new(:CBC)
      action == :encrypt ? cipher.encrypt : cipher.decrypt
      cipher.iv = NoPasswd.config[:cipher][:iv]
      cipher.key = self.key(passwd)

      return cipher.update(data) + cipher.final
    end
end
