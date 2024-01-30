# Diabetes Monitoring App

Android/iOS Application offering diabetes monitoring, management and prediction allowing the patient to actively get insights of his current health state. 

The implementation ensured deploying Deep Learning techniques to enhance the prediction ability based on the patient data.

## Features

1. Authentication (UI-based implementation)
2. Monitor the reading from the Continuous Glucose Monitor (CGM) device or potentially any other sensor (UI-based implementation)
3. Manage your dates with potential caretakers (UI-based implementation)
4. Predict your current Diabetic status by providing BGL, age, temperature and a set of other features.

## Installation

In order to run the app, follow these steps:
1. Clone repository
2. Change directory to project's directory
`git clone https://github.com/moayadeldin/app-diabetes-monitoring` then `cd app-diabetes-monitoring`
3. You need to have Flutter installed in your device in order to run the application properly, if not you can follow with their documentation [here](https://docs.flutter.dev/get-started/install)
4. In order to use the predictive ML-based feature, you need to install Flask API and the required packages.
   
   4.1 Change directory to flask-api directory through `cd flask-app`

   4.2 Install the required packages through the command `pip install -r requirements.txt` 

   Note:  For step 4.2 it is recommended to use a virtual environment in order to avoid any OS-related errers.
   
## Usage

* To start the app by typing `flutter run` command, it is recommended to run it through an android emulator in order to visualize the UI properly.
* In a different terminal, run `cd flask-app` command (activate the virtual envrionment before if you use any) then type `python app.py`


## Citation

Deepali Javale, Sharmishta Desai, July 7, 2021, "Dataset for People for their Blood Glucose Level with their Superficial body feature readings.", IEEE Dataport, doi: https://dx.doi.org/10.21227/c4pp-6347.
