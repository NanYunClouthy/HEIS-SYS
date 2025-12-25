import requests
import json
from datetime import datetime

# 配置
BASE_URL = "http://localhost:8080/api"
USERNAME = "patient1"
PASSWORD = "123456"

# 创建 Session 以保持 Cookie
session = requests.Session()

def print_step(step_name):
    print(f"\n{'='*20} {step_name} {'='*20}")

def login():
    print_step("Step 1: 登录")
    url = f"{BASE_URL}/auth/login"
    payload = {
        "username": USERNAME,
        "password": PASSWORD
    }
    
    try:
        response = session.post(url, json=payload)
        print(f"Status Code: {response.status_code}")
        if response.status_code == 200:
            print("登录成功!")
            print("Response:", response.json())
            return True
        else:
            print("登录失败!")
            print("Response:", response.text)
            return False
    except Exception as e:
        print(f"请求异常: {e}")
        return False

def get_patient_info():
    print_step("Step 2: 获取患者信息 (/patients/me)")
    url = f"{BASE_URL}/patients/me"
    
    try:
        response = session.get(url)
        print(f"Status Code: {response.status_code}")
        
        if response.status_code == 200:
            patient_data = response.json()
            print("获取成功!")
            print(f"Patient ID: {patient_data.get('patId')}")
            print(f"Patient Name: {patient_data.get('patName')}")
            return patient_data
        else:
            print("获取失败!")
            print("Response:", response.text)
            return None
    except Exception as e:
        print(f"请求异常: {e}")
        return None

def create_opd(pat_id):
    print_step("Step 3: 创建挂号 (/opds)")
    url = f"{BASE_URL}/opds"
    
    # 构造当前时间
    now = datetime.now().isoformat()
    
    payload = {
        "opdDate": now,
        "opdTime": now,
        "opdDept": "内科",
        "patient": {
            "patId": pat_id
        },
        "opdStats": 1
    }
    
    print("发送 Payload:", json.dumps(payload, indent=2, ensure_ascii=False))
    
    try:
        response = session.post(url, json=payload)
        print(f"Status Code: {response.status_code}")
        
        if response.status_code == 201: # Created
            print("挂号成功!")
            print("Response:", response.json())
        else:
            print("挂号失败!")
            print("Response:", response.text)
    except Exception as e:
        print(f"请求异常: {e}")

def main():
    print("开始 API 检查流程...")
    
    if not login():
        return
        
    patient_data = get_patient_info()
    if not patient_data:
        return
        
    pat_id = patient_data.get('patId')
    if not pat_id:
        print("未找到 Patient ID，无法进行挂号测试")
        return
        
    create_opd(pat_id)

if __name__ == "__main__":
    main()
