class Api::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.save
      params = { token: JsonWebToken.encode('user' => @user.email) }
    else
      params = { oauth: 'error' }
    end

    # If the request has an origin header it must have came from the web client
    if request.env['omniauth.origin']
      redirect_to(["#{CLIENTS['web_client_url']}?", params.to_query].join)
    else
      url = ["#{CLIENTS['mobile_client_url']}?", params.to_query].join
      render html: mobile_redirect(url), content_type: 'text/html'
    end
  rescue
    render body: nil, status: 500
  end

  private

  def mobile_redirect(url)
    html = <<-HTML
      <html><head>
        <script type="text/javascript">
          window.open("#{url}","_self");
        </script>
      </head></html>
    HTML
    html.html_safe
  end

  def set_flash_message(key, kind, options = {})
  end
end
