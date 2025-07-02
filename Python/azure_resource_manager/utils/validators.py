import re

valid_location = {"east-us", "west-us", "central-us", "west-europe", "north-europe"}

def validate_location(location: str) -> bool:
    if location.lower() not in valid_location:
        print(f"Invalid location: {location}. Valid locations are: {', '.join(valid_location)}")
        return False
    return True

def validate_name(name: str) -> bool:
    if not (1 <= len(name) <= 90):
        print("Name must be between 1 and 90 characters.")
        return False
    
    if not re.match(r"^[a-zA-Z][a-zA-Z0-9\-]*[a-zA-Z0-9]$", name):
        print("Invalid name.")
        return False
    
    return True
