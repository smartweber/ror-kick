module ShortenerHelper
  # generate a url from a url string
  def short_url(url, owner: nil, custom_key: nil, expires_at: nil, fresh: false, url_options: {})
    short_url = Shortener::ShortenedUrl.generate(url,
                                                  owner:      owner,
                                                  custom_key: custom_key,
                                                  expires_at: expires_at,
                                                  fresh:      fresh
                                                )

    if short_url
      (Rails.env.development? ? "http://host.kick.party:3001" : (Rails.env.test? ? "http://test.kick.party" : "http://kick.party")) + "/" + short_url.unique_key
    else
      url
    end
  end

end
