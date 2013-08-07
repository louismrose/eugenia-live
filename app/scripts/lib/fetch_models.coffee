model_names = ["palette_specification", "palette", "link_shape",
          "node_shape", "drawing", "node", "link"]
          
for model_name in model_names
  model = require("models/#{model_name}")
  model.extend(Spine.Model.Local) unless model_name is "palette_specification"
  model.fetch()