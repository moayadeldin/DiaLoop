from flask import Flask, jsonify
import serial
from serial.serialutil import SerialException

app = Flask(__name__)
numbers_received = []

# Setup the serial connection when the script starts
try:
    ser = serial.Serial('COM11', 38400)
    ser.flushInput()
except SerialException as e:
    print(f"Failed to connect to the serial port: {e}")
    ser = None

@app.route('/random_number', methods=['GET'])
def read_from_bluetooth():
    if ser:
        try:
            line = ser.readline().decode('iso8859-1').strip()
            # Convert the line to float and handle infinity
            number_float = float(line)
            if number_float == float('inf'):
                number_float = 0
            number_int = int(number_float)
            numbers_received.append(number_int)
            return jsonify({'concentration_reading': number_int})
        except SerialException as e:
            # Log an error message or handle it appropriately
            print(f"Error reading from the serial port: {e}")
            return jsonify({'error': 'Error reading from the serial port'}), 500
        except ValueError as e:
            print(f"Error of couldn't convert string to float: {e}")
            return jsonify({'error': 'Invalid data format'}), 400
    else:
        return jsonify({'error': 'Serial port not connected'}), 503

if __name__ == '__main__':
    try:
        app.run(debug=False)
    finally:
        # Close the serial connection when the script ends
        if ser and ser.is_open:
            ser.close()
