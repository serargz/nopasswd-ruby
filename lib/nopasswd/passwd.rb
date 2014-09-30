class NoPasswd::Passwd
  def self.generate(passwd_size = 20)
    # TODO: Extract somewhere
    charset = ('A'..'Z').to_a + ('a'..'z').to_a
    special_chars = %w($ % # @ * & ^ { } | + - / ~ \( \) . , ? ; : " ' [ ] \\)
    charset += special_chars

    passwd = ""
    passwd_size.times { passwd << charset[rand(charset.size)] }

    return passwd
  end
end
