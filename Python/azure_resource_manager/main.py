from models.virtual_machine import VirtualMachine
from models.storage_account import StorageAccount
from models.sql_database import SQLDatabase
from models.resource_group import ResourceGroup
from utils.file_handler import save_resources, load_resources, search_by_name
from utils.validators import validate_location, validate_name
from utils.formatter import print_banner, divider

def display_menu():
    options = [
        "Create Virtual Machine",
        "Create Storage Account",
        "Create SQL Database",
        "Create Resource Group",
        "Assign Resource to Resource Group",
        "List Resources and Resource Groups",
        "Save Resources",
        "Load Resources",
        "Delete Resource",
        "Search Resource by Name",
        "Exit",
        "View Logs"
    ]
    for i, opt in enumerate(options):
        print(f"{i + 1}. {opt}")

def create_resource(resource_class, extra_field_name=None):
    name = input("Enter name: ")
    location = input("Enter location: ")
    if not (validate_name(name) and validate_location(location)):
        return None

    print(f"Creating {resource_class.__name__}...")
    extra_field = None
    if extra_field_name:
        extra_field = input(f"Enter {extra_field_name}: ")
        divider()
        return resource_class(name, location, extra_field)
        divider()
    divider()
    return resource_class(name, location)

def main():
    resources, resource_groups = [], []

    while True:
        display_menu()
        try:
            choice = int(input("Enter your choice (1-12): "))
            match choice:
                case 1:
                    divider()
                    vm = create_resource(VirtualMachine, "tier (Standard/Premium)")
                    if vm: resources.append(vm)
                    divider()
                case 2:
                    divider()
                    sa = create_resource(StorageAccount, "tier (Standard/Premium)")
                    if sa: resources.append(sa)
                    divider()
                case 3:
                    divider()
                    db = create_resource(SQLDatabase, "edition (Basic/Standard/Premium)")
                    if db: resources.append(db)
                    divider()
                case 4:
                    divider()
                    rg = create_resource(ResourceGroup)
                    if rg: resource_groups.append(rg)
                    divider()
                case 5:
                    divider()
                    group_name = input("Enter Resource Group name: ")
                    resource_name = input("Enter Resource name: ")
                    divider()
                    rg = next((g for g in resource_groups if g.name == group_name), None)
                    res = next((r for r in resources if r.name == resource_name), None)
                    divider()
                    if not rg or not res:
                        print("Resource or group not found.")
                        divider()
                    else:
                        try:
                            rg.add_resource(res)
                            print(f"{res.name} added to {rg.name}")
                            save_resources(resources + resource_groups)
                            divider()
                        except ValueError as e:
                            divider()
                            print(f"Error: {e}")
                case 6:
                    divider()
                    print("\nResources:")
                    for r in resources:
                        print(f"{r}")
                    divider()    
                    print("\nResource Groups:")
                    for rg in resource_groups:
                        print(rg)
                    divider()    
                case 7:
                    divider()
                    save_resources(resources + resource_groups)
                    divider()
                case 8:
                    print("\nResources:")
                    for res in resources:
                        divider()
                        output = f"{res.__class__.__name__}: {res.name} - {res.location}"
                        if hasattr(res, "tier"):
                            output += f" - {res.tier}"
                        elif hasattr(res, "edition"):
                            output += f" - {res.edition}"
                        print(output)
                    divider()

                case 9:
                    name = input("Enter resource name to delete: ")
                    res = next((r for r in resources if r.name == name), None)
                    if res:
                        for rg in resource_groups:
                            if res in rg.resources:
                                rg.resources.remove(res)
                        resources.remove(res)
                        save_resources(resources + resource_groups)
                        divider()
                        print(f"{name} deleted.")
                        divider()
                    else:
                        divider()
                        print("Resource not found.")
                        divider()
                case 10:
                    query = input("Enter resource name to search: ")
                    for r in search_by_name(resources, query):
                        divider()
                        print(r)
                        divider()
                case 11:
                    divider()
                    print("Exiting...")
                    divider()
                    break
                case 12:                
                    
                    divider()
                    try:
                        with open('data/logs.txt', 'r') as log_file:
                            content = log_file.read()
                            if content:
                                print(content)
                            else:
                                print("Log file is empty.")
                    except FileNotFoundError:
                        print("Log file not found.")
                    divider()

                case _:
                    divider()
                    print("Invalid option.")
                    divider()
        except ValueError:
            divider()
            print("Invalid input. Please enter a number.")
            divider()
if __name__ == "__main__":
    main()
