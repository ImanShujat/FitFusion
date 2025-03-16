from flask import Flask, request, jsonify
from flask_cors import CORS
import joblib
import pandas as pd
import numpy as np

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Load the pre-trained model
try:
    model = joblib.load('C:/Users/786/Documents/Imanpython/model.pkl')
    print("Model loaded successfully!")
except Exception as e:
    print(f"Error loading model: {e}")
    model = None

# Route for API Home
@app.route('/')
def home():
    return "Welcome to the BMI, BMR, and Calorie Calculator API"

# Route to calculate BMI, BMR, and predict calorie needs
@app.route('/predict', methods=['POST'])
def predict():
    if model is None:
        return jsonify({'error': 'Model not loaded properly'}), 500

    try:
        # Get the input data from the request
        data = request.get_json()
        if not data:
            return jsonify({'error': 'Invalid or missing data'}), 400

        # Extract and validate input data
        try:
            age = int(data.get('age', 0))
            weight_kg = float(data.get('weight_kg', 0))
            height_cm = float(data.get('height_cm', 0))
            gender = data.get('gender', 'M').upper()
            activity_level = int(data.get('activity_level', 1))
        except ValueError:
            return jsonify({'error': 'Invalid data types provided'}), 400

        if age <= 0 or weight_kg <= 0 or height_cm <= 0 or activity_level not in [1, 2, 3, 4, 5]:
            return jsonify({'error': 'Invalid input values'}), 400

        # Convert height from cm to m
        height_m = height_cm / 100

        # Calculate BMI
        BMI = weight_kg / (height_m ** 2)

        # Calculate BMR
        if gender == 'M':
            BMR = 10 * weight_kg + 6.25 * height_cm - 5 * age + 5
        elif gender == 'F':
            BMR = 10 * weight_kg + 6.25 * height_cm - 5 * age - 161
        else:
            return jsonify({'error': 'Invalid gender provided. Use "M" or "F"'}), 400

        # Assign BMI tags
        if BMI < 18.5:
            label = 'Underweight'
        elif 18.5 <= BMI < 25:
            label = 'Normal weight'
        elif 25 <= BMI < 30:
            label = 'Overweight'
        else:
            label = 'Obese'

        # Map activity multipliers
        activity_multipliers = {
            1: 1.2,   # Sedentary
            2: 1.375, # Lightly Active
            3: 1.55,  # Moderately Active
            4: 1.725, # Very Active
            5: 1.9    # Extra Active
        }
        activity_multiplier = activity_multipliers[activity_level]

        # Adjust caloric needs
        adjusted_calories = BMR * activity_multiplier

        # Prepare input features for the model
        input_data = pd.DataFrame({
            'age': [age],
            'weight_kg': [weight_kg],
            'height_cm': [height_cm],
            'BMI': [BMI],
            'gender_M': [1 if gender == 'M' else 0],
            'gender_F': [1 if gender == 'F' else 0],
            'activity_level_1': [1 if activity_level == 1 else 0],
            'activity_level_2': [1 if activity_level == 2 else 0],
            'activity_level_3': [1 if activity_level == 3 else 0],
            'activity_level_4': [1 if activity_level == 4 else 0],
            'activity_level_5': [1 if activity_level == 5 else 0],
            'BMI_tags_Underweight': [1 if label == 'Underweight' else 0],
            'BMI_tags_Normal weight': [1 if label == 'Normal weight' else 0],
            'BMI_tags_Overweight': [1 if label == 'Overweight' else 0],
            'BMI_tags_Obese': [1 if label == 'Obese' else 0]
        })

        # Predict calories to maintain weight
        predicted_calories = model.predict(input_data)[0]

        return jsonify({
            'BMI': round(BMI, 2),
            'BMR': round(BMR, 2),
            'daily_caloric_needs': round(adjusted_calories, 2),
            'predicted_calories': round(predicted_calories, 2),
            'label': label
        }), 200

    except Exception as e:
        print(f"Error processing request: {e}")
        return jsonify({'error': 'An error occurred while processing the request'}), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
