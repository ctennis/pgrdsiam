# frozen_string_literal: true

require_relative "version"

module PGRDSIAM
  module Utils
    def self.certificate_pem(name)
      if name == "rds-ca-2015"
        "#{File.dirname(__FILE__)}/../../certs/rds-ca-2015-root.pem"
      elsif name == "rds-ca-2019"
        "#{File.dirname(__FILE__)}/../../certs/rds-ca-2019-root.pem"
      end
    end

    def self.credentials
      if ENV["AWS_ACCESS_KEY_ID"]
        return Aws::Credentials.new(ENV["AWS_ACCESS_KEY_ID"],
                                    ENV["AWS_SECRET_ACCESS_KEY"],
                                    ENV["AWS_SESSION_TOKEN"])
      elsif ENV["AWS_CONTAINER_CREDENTIALS_RELATIVE_URI"]
        return Aws::ECSCredentials.new
      end

      Aws::InstanceProfileCredentials.new
    end
  end
end
