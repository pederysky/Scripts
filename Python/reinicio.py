from flask import Flask, jsonify
from flask_httpauth import HTTPBasicAuth
import subprocess

app = Flask(__name__)
auth = HTTPBasicAuth()

# Diccionario de usuarios (nombre de usuario, contraseña)
users = {
    "admin": "admin"
}

@auth.verify_password
def verify_password(username, password):
    if users.get(username) == password:
        return username

@app.route('/reiniciar', methods=['POST'])
def reiniciar_servidor():
    try:
        # Detener Tomcat
        subprocess.run('net stop Tomcat9', check=True, shell=True)
        # Iniciar Tomcat
        subprocess.run('net start Tomcat9', check=True, shell=True)

        return jsonify({"status": "Tomcat reiniciado correctamente"}), 200

    except subprocess.CalledProcessError as e:
        return jsonify({"error": f"Error al reiniciar Tomcat: {e}"}), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8081)
