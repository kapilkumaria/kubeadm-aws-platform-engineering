#!/usr/bin/env python3

import subprocess
import json
import time
import sys
import os

# Path to Terraform working directory
TF_DIR = "../../infra/terraform/envs/dev"

# Path where inventory.ini will be stored
INVENTORY_PATH = "../inventory/dev/inventory.ini"


def get_ansible_inventory_from_terraform(retries=5, delay=5):
    """Fetches the 'ansible_inventory' output from Terraform with retry logic."""
    for attempt in range(1, retries + 1):
        try:
            output = subprocess.check_output(
                ["terraform", "output", "-json", "ansible_inventory"],
                cwd=TF_DIR
            )
            return json.loads(output)
        except subprocess.CalledProcessError:
            print(f"⚠️ 'ansible_inventory' not found (attempt {attempt}/{retries})...")
            if attempt < retries:
                time.sleep(delay)
            else:
                print("❌ Error: 'ansible_inventory' output not found in Terraform state.")
                sys.exit(1)


def write_inventory_file(data):
    """Generate inventory.ini with Kubernetes group structure."""
    bastion = data.get("bastion", "")
    master = data.get("master", "")
    workers = data.get("workers", [])

    content = "[bastion]\n"
    if bastion:
        content += f"{bastion} ansible_user=ubuntu\n"

    content += "\n[master]\n"
    if master:
        content += f"{master} ansible_user=ubuntu\n"

    content += "\n[workers]\n"
    for worker in workers:
        content += f"{worker} ansible_user=ubuntu\n"

    # 💥 <- Add Kubernetes parent group
    content += "\n[kubernetes:children]\nmaster\nworkers\n"

    content += "\n[all:vars]\nansible_python_interpreter=/usr/bin/python3\n"

    # Ensure folder exists
    os.makedirs(os.path.dirname(INVENTORY_PATH), exist_ok=True)

    with open(INVENTORY_PATH, "w") as f:
        f.write(content)

    print(f"✅ Inventory successfully written to {INVENTORY_PATH}")


if __name__ == "__main__":
    tf_output = get_ansible_inventory_from_terraform()
    write_inventory_file(tf_output)
