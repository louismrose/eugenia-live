models = ["palette_specification", "palette", "link_shape",
          "node_shape", "drawing", "node", "link"]
          
for model in models
  model = require("models/#{model}")
  model.extend(Spine.Model.Local)
  model.fetch()