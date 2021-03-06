require "faraday_middleware/aws_signers_v4"

Searchkick.client =
  Elasticsearch::Client.new(
    url: ENV["ELASTICSEARCH_URL"],
    transport_options: {request: {timeout: 25}}
  ) do |f|
    f.request :aws_signers_v4, {
      credentials: Aws::Credentials.new(ENV["AWS_ACCESS_KEY_ID"], ENV["AWS_SECRET_ACCESS_KEY"]),
      service_name: "es",
      region: ENV['AWS_SEARCH_REGION']
    }
  end
