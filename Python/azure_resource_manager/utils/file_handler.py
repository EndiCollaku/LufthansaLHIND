import json
import os
from datetime import datetime
from models.virtual_machine import VirtualMachine
from models.storage_account import StorageAccount
from models.sql_database import SQLDatabase
from models.resource_group import ResourceGroup
from utils.validators import validate_location, validate_name


def log_action(action_type, message, log_file="data/logs.txt"):
    os.makedirs(os.path.dirname(log_file), exist_ok=True)
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    log_entry = f"[{timestamp}] [{action_type}] {message}\n"
    with open(log_file, "a") as f:
        f.write(log_entry)




def serialize_resources(obj):
    if isinstance(obj, list):
        return [serialize_resources(item) for item in obj]
    elif isinstance(obj, dict):
        return {key: serialize_resources(value) for key, value in obj.items()}
    elif hasattr(obj, "to_dict"):
        return obj.to_dict()
    else:
        return obj


def save_resources(resources, filename="data/resources.json"):
    os.makedirs(os.path.dirname(filename), exist_ok=True)

    valid = [
        res for res in resources
        if validate_name(res.name) and validate_location(res.location)
    ]

    with open(filename, "w") as f:
        json.dump(serialize_resources(valid), f, indent=4)

    if valid:
        latest = valid[-1]
        latest_desc = f"{latest.__class__.__name__.replace('_', ' ')}: ({latest.name}) Location: ({latest.location})"

        if hasattr(latest, "tier"):
            latest_desc += f"  Tier: ({latest.tier})"
        elif hasattr(latest, "edition"):
            latest_desc += f"  Edition: ({latest.edition})"

        print(f"\nLatest created: {latest}")
        print(f"Saved {len(valid)} resources to {filename}")

        log_action("SAVE_RESOURCES", f"Saved {len(valid)} resources to {filename}. Latest created: {latest_desc}")
    else:
        print("No valid resources to save.")
        log_action("SAVE_RESOURCES", "Attempted to save resources, but none were valid.")



def load_resources(filename='data/resources.json'):
    if not os.path.exists(filename):
        print("[INFO] No resource file found.")
        log_action(f"Resource file not found: {filename}")
        return []

    try:
        with open(filename, "r") as f:
            data = json.load(f)
    except json.JSONDecodeError:
        print("Error loading JSON.")
        log_action(f"Failed to load resources due to JSON error in {filename}")
        return []

    result = []
    for item in data:
        t = item.get("type")
        if t == "VirtualMachine":
            result.append(VirtualMachine.from_dict(item))
        elif t == "StorageAccount":
            result.append(StorageAccount.from_dict(item))
        elif t == "SQLDatabase":
            result.append(SQLDatabase.from_dict(item))
        elif t == "ResourceGroup":
            result.append(ResourceGroup.from_dict(item))

    log_action(f"Loaded {len(result)} resources from {filename}")
    return result



def search_by_name(resources, query):
    return [r for r in resources if query in r.name.lower()]
