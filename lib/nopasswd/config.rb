module NoPasswd
  @config = {
    config_path: File.expand_path("~/.nopasswd"),
    cipher: {
      iv: "\x85\xF1\xAF\xE3\xC3\xC7\xBAdU\xDE\fj\x81J\x16\xA9",
      salt: "8w\\\xF5\x8A\x9A\x92\b\xAEb\x05#i/22"
    },
    dropbox: {
      app_key: "3a1idjr37id2htw",
      app_secret: "zmidtftuafrfw6x"
    }
  }

  def self.configure(&block)
    yield @config
  end

  def self.config
    @config
  end
end
