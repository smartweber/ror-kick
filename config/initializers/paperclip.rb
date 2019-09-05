Paperclip::Attachment.default_options[:url] = ':s3_alias_url'

Paperclip::Attachment.default_options[:s3_host_alias] = case true
  when Rails.env.production?
    's3.kickparty.com'
  when Rails.env.test?
    's3-test.kickparty.com'
  when Rails.env.development?
    's3-dev.kickparty.com'
  else
    's3-test.kickparty.com'
end

Paperclip::Attachment.default_options[:path] = '/:class/:attachment/:id_partition/:style/:filename'
