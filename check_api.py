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
            print(f"Patient ID: {patient_data.get('patId')}")
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
    now = datetime.now().isoformat()
    
    payload = {
        "opdDate": now,
        "opdTime": now,
        "opdDept": "内科",
        "patient": {"patId": pat_id},
        "opdStats": 1
    }
    
    try:
        response = session.post(url, json=payload)
        print(f"Status Code: {response.status_code}")
        if response.status_code == 201:
            print("挂号成功!")
            return response.json()
        else:
            print("挂号失败:", response.text)
            return None
    except Exception as e:
        print(f"请求异常: {e}")
        return None

def create_visit_record(pat_id):
    print_step("Step 4: 创建就诊记录 (/opd-visit-histories)")
    url = f"{BASE_URL}/opd-visit-histories"
    now = datetime.now().isoformat()
    
    payload = {
        "patient": {"patId": pat_id},
        "visDocId": 1,
        "visCaseDesc": "患者自述头痛发热",
        "visDiagnosis": "上呼吸道感染",
        "visCreatedBy": "Doctor1",
        "visCreatedDate": now,
        "visLastModifiedBy": "Doctor1",
        "visLastModifiedDate": now,
        "visNote": "建议休息"
    }
    
    try:
        response = session.post(url, json=payload)
        print(f"Status Code: {response.status_code}")
        if response.status_code == 201:
            print("就诊记录创建成功!")
            return response.json()
        else:
            print("就诊记录创建失败:", response.text)
            return None
    except Exception as e:
        print(f"请求异常: {e}")
        return None

def get_drug_list():
    print_step("Step 5: 获取药品列表 (/drugs)")
    url = f"{BASE_URL}/drugs"
    
    try:
        response = session.get(url)
        print(f"Status Code: {response.status_code}")
        if response.status_code == 200:
            drugs = response.json()
            print(f"获取到 {len(drugs)} 种药品")
            if drugs:
                print(f"第一个药品: {drugs[0]['drugName']}, 库存: {drugs[0]['drugStock']}")
                return drugs[0]
            else:
                print("药品列表为空!")
                return None
        else:
            print("获取药品失败:", response.text)
            return None
    except Exception as e:
        print(f"请求异常: {e}")
        return None

def create_prescription(vis_id, drug_id, quantity):
    print_step("Step 6: 开具处方 (/prescriptions)")
    url = f"{BASE_URL}/prescriptions"
    
    payload = {
        "visId": vis_id,
        "items": [
            {
                "drugId": drug_id,
                "quantity": quantity
            }
        ]
    }
    
    try:
        response = session.post(url, json=payload)
        print(f"Status Code: {response.status_code}")
        if response.status_code == 201:
            print("处方创建成功!")
            print("Response:", response.json())
            return response.json()
        else:
            print("处方创建失败:", response.text)
            return None
    except Exception as e:
        print(f"请求异常: {e}")
        return None

def verify_stock(drug_id, expected_stock):
    print_step("Step 7: 验证库存扣减 (/drugs/{id})")
    url = f"{BASE_URL}/drugs/{drug_id}"
    
    try:
        response = session.get(url)
        if response.status_code == 200:
            drug = response.json()
            current_stock = drug['drugStock']
            print(f"当前库存: {current_stock}, 预期库存: {expected_stock}")
            if current_stock == expected_stock:
                print("库存验证通过! ✅")
            else:
                print("库存验证失败! ❌")
        else:
            print("获取药品详情失败:", response.text)
    except Exception as e:
        print(f"请求异常: {e}")

def main():
    print("开始全流程测试...")
    
    if not login(): return
    
    patient = get_patient_info()
    if not patient: return
    pat_id = patient['patId']
    
    # 挂号
    opd = create_opd(pat_id)
    if not opd: return
    
    # 就诊
    visit = create_visit_record(pat_id)
    if not visit: return
    vis_id = visit['visId']
    
    # 选药
    drug = get_drug_list()
    if not drug: return
    drug_id = drug['drugId']
    initial_stock = drug['drugStock']
    quantity = 2
    
    # 开方
    pres = create_prescription(vis_id, drug_id, quantity)
    if not pres: return
    
    # 验库存
    verify_stock(drug_id, initial_stock - quantity)

if __name__ == "__main__":
    main()
