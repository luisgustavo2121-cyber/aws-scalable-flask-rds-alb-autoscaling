#!/bin/bash
set -e

# Log completo do user-data
exec > /var/log/user-data.log 2>&1

echo "==== INICIO USER DATA ===="

# Atualizar pacotes essenciais
dnf install -y python3 python3-pip

# Garantir pip funcional
python3 -m ensurepip --upgrade

# Instalar dependências no Python correto
python3 -m pip install flask psycopg2-binary python-dotenv

# Criar diretório da aplicação
APP_DIR="/opt/flask-app"
mkdir -p $APP_DIR

# Criar aplicação Flask (sem HEREDOC problemático)
cat > $APP_DIR/app.py << 'EOF'
from flask import Flask, request
import psycopg2
import os
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)

DB_HOST = os.getenv("DB_HOST")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASS = os.getenv("DB_PASS")

def get_connection():
    return psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASS
    )

@app.route("/")
def home():
    return "Servidor " + os.uname()[1]

@app.route("/add", methods=["POST"])
def add():
    data = request.form.get("data")
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("INSERT INTO items (name) VALUES (%s)", (data,))
    conn.commit()
    cur.close()
    conn.close()
    return "Inserido!"

@app.route("/list")
def list_items():
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("SELECT * FROM items")
    rows = cur.fetchall()
    cur.close()
    conn.close()
    return str(rows)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
EOF

# Criar arquivo de variáveis
cat > $APP_DIR/.env << EOF
DB_HOST=ENDPOINT-RDS
DB_NAME=postgres
DB_USER=postgres
DB_PASS=DB-pass
EOF

# Permissões
chown -R ec2-user:ec2-user $APP_DIR

# Criar serviço systemd (PONTO MAIS IMPORTANTE)
cat > /etc/systemd/system/flask-app.service << EOF
[Unit]
Description=Flask App
After=network.target

[Service]
User=ec2-user
WorkingDirectory=$APP_DIR
EnvironmentFile=$APP_DIR/.env
ExecStart=/usr/bin/python3 $APP_DIR/app.py
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Recarregar systemd
systemctl daemon-reexec
systemctl daemon-reload

# Habilitar serviço no boot
systemctl enable flask-app

# Iniciar aplicação
systemctl start flask-app

echo "==== FIM USER DATA ===="
