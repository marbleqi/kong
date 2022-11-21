local Http301HttpsHandler = {
  VERSION  = "1.0.0",
  PRIORITY = 2480,
}

function Http301HttpsHandler:access(config)
  schema=kong.request.get_scheme()
  if ( schema == "http" )
  then
    path_with_query = kong.request.get_path_with_query()
    host = kong.request.get_host()
    https_url = "https://" .. host .. path_with_query
    kong.response.exit(301,"Redirect to https",{["Location"] = https_url });
  end
end

return Http301HttpsHandler
