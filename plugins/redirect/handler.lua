local RedirectHandler = {
  VERSION  = "1.0.0",
  PRIORITY = 2490,
}

function RedirectHandler:access(config)
  kong.response.exit(config.status, "Redirect",{["Location"] = config.url });
end

return RedirectHandler
