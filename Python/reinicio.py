from flask import Flask, jsonify
from flask_httpauth import HTTPBasicAuth
import os
import subprocess

app = Flask(__name__)

@app.route('/reiniciar', methods=['POST'])
def reiniciar_servidor():
    try:
        # Reiniciar Tomcat (suponiendo que Tomcat está como servicio)
        # Cambia el nombre del servicio según tu configuración
        subprocess.run(["net", "stop", "Tomcat9"], check=True)  # Detener Tomcat
        subprocess.run(["net", "start", "Tomcat9"], check=True)  # Iniciar Tomcat

        # Reiniciar el sistema Windows
        subprocess.run(["shutdown", "/r", "/f", "/t", "0"], check=True)

        return jsonify({"status": "servidores reiniciados correctamente"}), 200

    except subprocess.CalledProcessError as e:
        return jsonify({"error": f"Error al reiniciar: {e}"}), 500


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8080)
