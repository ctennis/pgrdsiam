# frozen_string_literal: true

# :nodoc:
# This file monkey patches the version included by Rails

require "active_record/connection_adapters/postgresql_adapter"

module ActiveRecord
  # :nodoc:
  module ConnectionHandling
    alias old_postgresql_connection postgresql_connection

    def postgresql_connection(config)
      new_config = config.dup
      if config[:use_iam]
        db = PGRDSIAM::Database.new(config: config)
        new_config = db.generate_config
      end

      old_postgresql_connection(new_config)
    end
  end
end
