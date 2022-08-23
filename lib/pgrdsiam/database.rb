# frozen_string_literal: true

require "aws-sdk-rds"
require "resolv"

module PGRDSIAM
  class Database
    def initialize(config:, credentials: PGRDSIAM::Utils.credentials)
      @config = config
      @generator = Aws::RDS::AuthTokenGenerator.new(credentials: credentials)

      @config[:port] ||= 5432
      @config[:certificate_name] ||= "rds-ca-2019"
    end

    def generate_config(resolved_host: nil)
      duped_config = @config.dup
      resolved_host ||= duped_config[:host]

      if resolved_host =~ /\.([\w-]+)\.rds\.amazonaws\.com/
        region = Regexp.last_match(1)
        endpoint = resolved_host + ":" + duped_config[:port].to_s
        duped_config[:host]        = resolved_host
        duped_config[:sslmode]     = "verify-full"
        duped_config[:sslrootcert] =
          PGRDSIAM::Utils.certificate_pem(duped_config[:certificate_name])
        duped_config[:password]    =
          @generator.auth_token(region: region, endpoint: endpoint,
                                user_name: duped_config[:username])
      else
        r = resolve_cname(host: duped_config[:host])
        return generate_config(resolved_host: r)
      end

      duped_config
    end

    private

    def resolve_cname(host:)
      r = Resolv::DNS.open do |dns|
        dns.getresource(host, Resolv::DNS::Resource::IN::CNAME)
      end
      r.name.to_s # => return alias domain
    rescue Resolv::ResolvError
      raise "Unable to resolve CNAME: #{host}"
    end
  end
end
