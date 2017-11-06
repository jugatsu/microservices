def healthcheck(post_host, post_port, comment_host, comment_port)
  begin
    post_service = JSON.parse(RestClient::Request.execute(method: :get, url: "http://#{post_host}:#{post_port}/healthcheck", timeout: 2))
  rescue
    post_status = 0
  else
    post_status = post_service['status']
  end

  begin
    comment_service = JSON.parse(RestClient::Request.execute(method: :get, url: "http://#{comment_host}:#{comment_port}/healthcheck", timeout: 2))
  rescue
    comment_status = 0
  else
    comment_status = comment_service['status']
  end

  if comment_status == 1 && post_status == 1
    status = 1
  else
    status = 0
  end

  version = File.read('VERSION')

  healthcheck= {
    status: status,
    dependent_services: {
      comment: comment_status,
      post:    post_status
    },
    version: version.strip
  }
  healthcheck.to_json
end
