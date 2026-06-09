# Self-healing: detect and restart (MySQL)
import subprocess
import time

import mysql.connector


def check_and_heal():
    try:
        conn = mysql.connector.connect(
            host="localhost",
            port=3306,
            user="victor",
            password="alchemy97",
            connection_timeout=3,
        )
        conn.close()
        print("Database is healthy")
        return
    except Exception as e:
        print(f"Database unhealthy: {e}")
        print("Attempting restart...")
        for svc in ["mysql", "mariadb", "mysqld"]:
            result = subprocess.run(
                ["systemctl", "restart", svc], capture_output=True, text=True
            )
            if result.returncode == 0:
                break
        else:
            print(f"Failed to restart: no mysql/mariadb service found")
        time.sleep(10)
        # Verify
        check_and_heal()


if __name__ == "__main__":
    check_and_heal()
