import requests
import json

# 配置
BASE_URL = "http://localhost:8080/api"
ADMIN_USERNAME = "admin1"
ADMIN_PASSWORD = "123456"

session = requests.Session()

def print_step(step_name):
    print(f"\n{'='*20} {step_name} {'='*20}")

def login_as_admin():
    print_step("Step 1: 管理员登录")
    url = f"{BASE_URL}/auth/login"
    payload = {
        "username": ADMIN_USERNAME,
        "password": ADMIN_PASSWORD
    }
    try:
        response = session.post(url, json=payload)
        if response.status_code == 200:
            print("登录成功!")
            return True
        else:
            print(f"登录失败! Status: {response.status_code}")
            return False
    except Exception as e:
        print(f"请求异常: {e}")
        return False

def list_drugs():
    print_step("Step 2: 获取药品列表")
    url = f"{BASE_URL}/drugs"
    try:
        response = session.get(url)
        if response.status_code == 200:
            drugs = response.json()
            print(f"获取成功! 共 {len(drugs)} 种药品")
            for drug in drugs[:3]: # 打印前3个
                print(f"- {drug['drugName']} (库存: {drug['drugStock']})")
            return drugs
        else:
            print(f"获取失败! Status: {response.status_code}")
            return None
    except Exception as e:
        print(f"请求异常: {e}")
        return None

def create_drug():
    print_step("Step 3: 添加新药品")
    url = f"{BASE_URL}/drugs"
    new_drug = {
        "drugName": "测试新药A",
        "drugCode": "TEST001",
        "drugPrice": 10.5,
        "drugStock": 100,
        "drugUnit": "盒",
        "drugSpec": "10mg*10片"
    }
    try:
        response = session.post(url, json=new_drug)
        if response.status_code == 201:
            print("添加成功!")
            created_drug = response.json()
            print(f"新药ID: {created_drug['drugId']}")
            return created_drug
        else:
            print(f"添加失败! Status: {response.status_code}")
            print(response.text)
            return None
    except Exception as e:
        print(f"请求异常: {e}")
        return None

def update_drug(drug_id):
    print_step("Step 4: 更新药品库存")
    url = f"{BASE_URL}/drugs/{drug_id}"
    update_data = {
        "drugName": "测试新药A",
        "drugCode": "TEST001",
        "drugPrice": 12.0, # 涨价
        "drugStock": 200,  # 补货
        "drugUnit": "盒",
        "drugSpec": "10mg*10片"
    }
    try:
        response = session.put(url, json=update_data)
        if response.status_code == 200:
            print("更新成功!")
            updated_drug = response.json()
            print(f"更新后库存: {updated_drug['drugStock']}, 价格: {updated_drug['drugPrice']}")
            return True
        else:
            print(f"更新失败! Status: {response.status_code}")
            return False
    except Exception as e:
        print(f"请求异常: {e}")
        return False

def delete_drug(drug_id):
    print_step("Step 5: 删除药品")
    url = f"{BASE_URL}/drugs/{drug_id}"
    try:
        response = session.delete(url)
        if response.status_code == 204:
            print("删除成功!")
            return True
        else:
            print(f"删除失败! Status: {response.status_code}")
            return False
    except Exception as e:
        print(f"请求异常: {e}")
        return False

def main():
    if not login_as_admin():
        return

    # 初始列表
    list_drugs()

    # 增
    new_drug = create_drug()
    if not new_drug:
        return

    # 改
    update_drug(new_drug['drugId'])

    # 删
    delete_drug(new_drug['drugId'])

    # 最终验证
    print("\n验证最终状态...")
    list_drugs()

if __name__ == "__main__":
    main()
