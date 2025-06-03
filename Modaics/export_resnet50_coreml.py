# file: export_resnet50_coreml.py

import torch
import torchvision.models as models
import coremltools as ct

# 1) Load pretrained ResNet50, strip classifier
resnet = models.resnet50(pretrained=True)
resnet.fc = torch.nn.Identity()
resnet.eval()

# 2) Trace the model with a dummy input
example_input = torch.rand(1, 3, 224, 224)  # dummy batch
traced_model = torch.jit.trace(resnet, example_input)

# 3) Convert to Core ML
mlmodel = ct.convert(
    traced_model,
    inputs=[ct.ImageType(name="input_image",
                         shape=example_input.shape,
                         scale=1/255.0,
                         bias=[0.485, 0.456, 0.406])]
)

# 4) (Optional) Rename output feature for clarity
mlmodel.short_description = "ResNet50 feature extractor (outputs 2048-d embedding)"
mlmodel.input_description["input_image"] = "Input image of size 224x224"
mlmodel.output_description["output"] = "2048-dimensional image embedding"

# 5) Save Core ML model
mlmodel.save("models/ResNet50Embedding.mlmodel")
print("Saved Core ML ResNet50 embedding model to /models/ResNet50Embedding.mlmodel")
