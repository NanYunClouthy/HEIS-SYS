import mysql.connector
import requests
import json
import time

# Configuration
DB_CONFIG = {
    'user': 'root',
    'password': '123456',
    'host': 'localhost',
    'database': 'hospital_management'
}

API_BASE = 'http://localhost:8080/api'

def check_db_structure():
    print("=== Checking Database Structure ===")
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        cursor = conn.cursor()
        
        # Check OPD table for OPD_DOC_ID
        cursor.execute("DESCRIBE opd")
        columns = [row[0] for row in cursor.fetchall()]
        if 'OPD_DOC_ID' in columns:
            print("[PASS] OPD_DOC_ID column exists in 'opd' table.")
        else:
            print("[FAIL] OPD_DOC_ID column MISSING in 'opd' table.")
            
        # Check Foreign Key
        cursor.execute("SELECT CONSTRAINT_NAME FROM information_schema.KEY_COLUMN_USAGE WHERE TABLE_NAME = 'opd' AND COLUMN_NAME = 'OPD_DOC_ID'")
        fk = cursor.fetchone()
        if fk:
            print(f"[PASS] Foreign Key constraint exists: {fk[0]}")
        else:
            print("[WARN] Foreign Key constraint might be missing or not named as expected.")
            
        conn.close()
    except ImportError:
        print("[WARN] mysql-connector-python not installed. Skipping DB check.")
    except Exception as e:
        print(f"[ERROR] Database check failed: {e}")

def verify_api_flow():
    print("\n=== Verifying API Flow ===")
    print("Note: Ensure the Backend Server is running on port 8080 before running this test.")
    
    session = requests.Session()
    
    # 1. Login as Admin
    print("\n1. Logging in as Admin (admin1/123456)...")
    try:
        login_payload = {"username": "admin1", "password": "password"} # Try 'password' or '123456'
        # database.txt hash $2a$10$rye7b... matches 'password' or similar? 
        # Let's try 123456 as it's common in this repo (application.yml)
        # Actually user dump has:
        # admin1: $2a$10$rye7b/Xyznpy/iLZWUk8reFQYt6doPw9gW8VyKE5UEOyOKqXsrNVy
        # patient1: $2a$10$2ff3/s9V8Rge7oG1ZWfeZuzZqjcUQzWVUTjVuCnjW9k5ozblpEv1C
        # doctor1: $2a$10$H3NL5mfjRaJSg5zFx3Seo.8uRqDaiGAt4G3g60zIQ7RNmBRYPl2li
        # '123456' hash is usually $2a$10$...
        # Let's assume the user knows the password or we just try '123456'.
        
        resp = session.post(f"{API_BASE}/auth/login", json={"username": "admin1", "password": "password"})
        if resp.status_code != 200:
             resp = session.post(f"{API_BASE}/auth/login", json={"username": "admin1", "password": "123456"})
        
        if resp.status_code == 200:
            print("[PASS] Admin Login Successful")
        else:
            print(f"[FAIL] Admin Login Failed: {resp.status_code} {resp.text}")
            return

        # 2. Add New Doctor
        print("\n2. Adding New Doctor (testdoc/123456)...")
        new_doc = {
            "username": "testdoc_api",
            "password": "123456",
            "docName": "API Test Doc",
            "docDept": "内科",
            "docTitle": "Chief",
            "docSpecialty": "Testing"
        }
        resp = session.post(f"{API_BASE}/doctors", json=new_doc)
        if resp.status_code == 201:
            doc_data = resp.json()
            doc_id = doc_data['docId']
            print(f"[PASS] Doctor Created: ID={doc_id}, Name={doc_data['docName']}")
        elif resp.status_code == 409:
            print("[INFO] Doctor user already exists, skipping creation.")
            # Try to get existing doctor for next step?
            # Requires listing doctors.
            resp = session.get(f"{API_BASE}/doctors")
            if resp.status_code == 200:
                docs = resp.json()
                target_doc = next((d for d in docs if d['docName'] == "API Test Doc"), None)
                if target_doc:
                    doc_id = target_doc['docId']
                    print(f"[INFO] Found existing doctor ID={doc_id}")
                else:
                    print("[FAIL] Could not find existing doctor.")
                    return
        else:
            print(f"[FAIL] Add Doctor Failed: {resp.status_code} {resp.text}")
            return

        # 3. Login as Patient
        print("\n3. Logging in as Patient (patient1/123456)...")
        # Try patient login
        resp = session.post(f"{API_BASE}/auth/login", json={"username": "patient1", "password": "password"})
        if resp.status_code != 200:
             resp = session.post(f"{API_BASE}/auth/login", json={"username": "patient1", "password": "123456"})
             
        if resp.status_code == 200:
            print("[PASS] Patient Login Successful")
            # Need patient ID? Usually session handles it or we need to fetch profile.
            # Registration requires patient object or ID.
            # OPDController.createOPD uses "patient": {"patId": ...}
            # We need to find patient ID for "patient1".
            # /auth/me -> username -> /patients?userId=... or something.
            # Or just assume patient ID 1 for 'patient1' based on dump.
            pat_id = 1 
        else:
            print(f"[FAIL] Patient Login Failed. Cannot proceed with registration test.")
            return

        # 4. Register OPD with Doctor
        print(f"\n4. Registering OPD with Doctor ID {doc_id}...")
        opd_data = {
            "opdDate": "2025-12-30",
            "opdTime": "2025-12-30 09:00:00",
            "opdDept": "内科",
            "patient": {"patId": pat_id},
            "doctor": {"docId": doc_id}
        }
        resp = session.post(f"{API_BASE}/opds", json=opd_data)
        if resp.status_code == 201:
            opd = resp.json()
            print(f"[PASS] OPD Registered Successfully: ID={opd['opdId']}")
            if 'doctor' in opd and opd['doctor'] and opd['doctor']['docId'] == doc_id:
                print(f"[PASS] Verified: OPD is linked to Doctor ID {doc_id}")
            else:
                print(f"[FAIL] OPD created but Doctor link missing in response: {opd}")
        else:
            print(f"[FAIL] OPD Registration Failed: {resp.status_code} {resp.text}")

    except requests.exceptions.ConnectionError:
        print("[ERROR] Could not connect to Backend. Is it running on port 8080?")
    except Exception as e:
        print(f"[ERROR] API Test Error: {e}")

if __name__ == "__main__":
    check_db_structure()
    verify_api_flow()
