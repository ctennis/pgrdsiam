# frozen_string_literal: true

require "spec_helper"

# frozen_string_literal: true

require "spec_helper"

describe PGRDSIAM::Database do
  describe ".generate_config" do
    let(:host) { "database.funkystring.us-east-1.rds.amazonaws.com" }
    let(:port) { 5432 }
    let(:user) { "dbuser" }
    let(:dbconfig) do
      {
        adapter: "postgresql",
        host: host,
        port: port,
        username: user,
        password: "doesntmatter",
        database: "dbname"
      }
    end
    let(:auth_token) { "auth-token" }

    before do
      @token_generator = double(Aws::RDS::AuthTokenGenerator)
      expect(Aws::RDS::AuthTokenGenerator).to receive(:new).and_return(@token_generator)
      expect(PGRDSIAM::Utils).to receive(:credentials)
      allow(@token_generator).to receive(:auth_token).and_return(auth_token)
      expect(@token_generator).to receive(:auth_token).with(
        region: "us-east-1",
        endpoint: host + ":" + port.to_s,
        user_name: user
      )
    end

    it "generates an override configuration with a dynamic auth token" do
      resulting_config = described_class.new(config: dbconfig).generate_config

      expect(resulting_config).to include(
        host: dbconfig[:host], sslmode: "verify-full", password: auth_token
      )
      expect(resulting_config).to include(:sslrootcert)
    end
  end
end
