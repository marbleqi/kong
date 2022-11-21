local BasePlugin = require "kong.plugins.base_plugin"

local RedirectHandler = BasePlugin:extend()

RedirectHandler.VERSION  = "1.0.0"
RedirectHandler.PRIORITY = 501

function RedirectHandler:new()
  RedirectHandler.super.new(self, "redirect")
end

function RedirectHandler:access(conf)
  RedirectHandler.super.access(self)
  kong.response.exit(conf.status,"Redirect",{["Location"] = conf.url });
end

return RedirectHandler
