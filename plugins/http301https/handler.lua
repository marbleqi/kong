local BasePlugin = require "kong.plugins.base_plugin"

local Http301HttpsHandler = BasePlugin:extend()

Http301HttpsHandler.VERSION  = "1.0.0"
Http301HttpsHandler.PRIORITY = 500

function Http301HttpsHandler:new()
  Http301HttpsHandler.super.new(self, "http301https")
end

function Http301HttpsHandler:access(conf)
  Http301HttpsHandler.super.access(self)
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
