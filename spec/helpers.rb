module Helpers

  # To test the CLI, we need to capture
  # the output to assert from it.
  def capture(stream)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end

    result
  end

  def create_fake_data(data={}, passwd)
    FileUtils.mkdir_p(NoPasswd.config[:config_path])
    cipher = NoPasswd::Cipher.new(passwd)
    cipher.store(data)
  end

end
