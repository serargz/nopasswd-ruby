class NoPasswd::Account

  attr_accessor :site, :username, :passwd

  def initialize(site, username, passwd_size = nil)
    @site     = site
    @username = username
    @passwd   = Passwd.generate(passwd_size)
  end

end
