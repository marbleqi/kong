local typedefs = require "kong.db.schema.typedefs"

return {
  name = "redirect",
  fields = {
    { protocols = typedefs.protocols_http },
    {
      config = {
        type = "record",
        fields = {
          { status = { type = "number", one_of = { 301, 302 }, }, },
          { url = typedefs.url, },
        },
      },
    },
  },
}