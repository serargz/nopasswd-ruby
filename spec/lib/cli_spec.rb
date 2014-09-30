require 'spec_helper'

describe NoPasswd::CLI do

  before :all do
    # In order to test the CLI, we reset
    # the $0 variable and argv.
    $0 = "nopasswd"
    ARGV.clear
  end

  let(:config_path) { NoPasswd.config[:config_path] }
  let(:data_path) { "#{config_path}/data" }

  describe "add" do
    context "when nopasswd is being used for the first time" do
      let(:add) { NoPasswd::CLI.start(["add"]) }

      it "shows a message to configure nopasswd" do
        results = capture(:stdout) { add }
        expect(results).to match /it seems it's the first time you run nopasswd/i
        expect(results).to match /Awesome! your master password has been set/i
      end
    end
  end

  describe "get" do
    context "when credentials are passed" do
      let(:get) { NoPasswd::CLI.start(["get", "--username=test", "--service=service"]) }
      before { create_fake_data({service: {test: "thepassword"}}, "master_password") }

      it "shows a message to configure nopasswd" do
        results = capture(:stdout) { get }
        expect(results).to match /Your password for test:service is in the clipboard/i
        expect(Clipboard.paste).to eq("thepassword")
      end
    end
  end

  describe "sync" do
    let(:sync) { NoPasswd::CLI.start(["sync"]) }
    it "shows and authorization url" do
      results = capture(:stdout) { sync }
      expect(results).to match /Please go to: .+/
    end
  end
end
