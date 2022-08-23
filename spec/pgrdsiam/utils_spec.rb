# frozen_string_literal: true

require "spec_helper"

describe PGRDSIAM::Utils do
  describe ".credentials" do
    context "AWS environment variables are set" do
      before do
        ENV["AWS_ACCESS_KEY_ID"] = "access-key"
        ENV["AWS_SECRET_ACCESS_KEY"] = "secret-key"
        ENV["AWS_SESSION_TOKEN"] = "session-token"
      end

      it "gets credentials an Aws::Credentials object" do
        expect(Aws::Credentials).to receive(:new).with(
          ENV["AWS_ACCESS_KEY_ID"],
          ENV["AWS_SECRET_ACCESS_KEY"],
          ENV["AWS_SESSION_TOKEN"]
        )

        described_class.credentials
      end
    end

    context "when no AWS environment variables are set" do
      before do
        ENV["AWS_ACCESS_KEY_ID"] = nil
      end

      it "gets credentials from the instance profile" do
        expect(Aws::InstanceProfileCredentials).to receive(:new)
        described_class.credentials
      end
    end
  end
end
