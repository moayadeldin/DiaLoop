from flask import Flask, request, jsonify
from tensorflow.keras.models import load_model
import numpy as np

app = Flask(__name__)

# Load your trained model
model = load_model(r"E:\Work\Graduation Project\Last Semester isA Work\app-diabetes-monitoring\flask-app\NN_deployed_in_app.h5")

@app.route('/predict', methods=['POST'])
def predict():
    # Get data from POST request
    data = request.get_json()

    # Turn data into numpy array
    input_data = np.array(data['input']).reshape((1, 9))  # Assumes 9 input features

    prediction = model.predict(input_data)
    
    # Convert numpy single valued array to native Python type
    prediction_value = prediction.item()

    # Return prediction
    return jsonify({'prediction': prediction_value})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001, debug=False)
