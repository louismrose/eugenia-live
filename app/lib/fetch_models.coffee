models = ["palette_specification", "palette", "link_shape",
          "node_shape", "drawing", "node", "link"]
          
for model in models
  require("models/#{model}").fetch()