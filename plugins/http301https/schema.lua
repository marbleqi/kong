local typedefs = require "kong.db.schema.typedefs"

return {
  name = "http301https",
  fields = {
    {
      consumer = typedefs.no_consumer
    },
    {
      protocols = typedefs.protocols_http
    },
    {
      config = {
        type = "record",
        fields = {
          -- Describe your plugin's configuration's schema here.        
        },
      },
    },
  },
  entity_checks = {
    -- Describe your plugin's entity validation rules
  },
}