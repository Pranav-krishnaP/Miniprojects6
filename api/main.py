import os
import cv2
from fastapi import FastAPI, File, Form, UploadFile
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
import numpy as np
from io import BytesIO
from PIL import Image
import tensorflow as tf

currentdirectory = os.getcwd()
print(currentdirectory)

app = FastAPI()

origins = [
    "http://localhost",
    "http://localhost:3000",
]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


classes = {
    "Potato": ["Early Blight", "Late Blight", "Healthy"],
    "Pepper": ["Bacterial_Fault", "Healthy"]
}


@app.get("/ping")
async def ping():
    return "Hello, I am alive"


def read_file_as_image(data) -> np.ndarray:
    image = np.array(Image.open(BytesIO(data)))
    return image


@app.post("/predict")
async def predict(
    file: UploadFile = File(...),
    classname: str = Form(...)
):
    image = read_file_as_image(await file.read())
    image = cv2.resize(image, (256, 256), interpolation=cv2.INTER_AREA)
    img_batch = np.expand_dims(image, 0)
    print(img_batch)
    MODEL = tf.keras.models.load_model(f"../models/{classname}/1")
    CLASS_NAMES = classes[f"{classname}"]
    predictions = MODEL.predict(img_batch[0:255][0:255])
    predicted_class = CLASS_NAMES[np.argmax(predictions[0])]
    confidence = np.max(predictions[0])
    return {
        'class': predicted_class,
        'confidence': float(confidence)
    }

if __name__ == "__main__":
    uvicorn.run(app, host='0.0.0.0', port=8000)
