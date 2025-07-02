from models.base import AzureResource

class StorageAccount(AzureResource):
    def __init__(self, name, location,tier):
        super().__init__(name, location)
        self.tier = tier

    def to_dict(self):
        return {
            "type": "StorageAccount",
            "name": self.name,
            "location": self.location,
            "tier": self.tier
        }
    @classmethod    
    def from_dict(cls, data):
       return cls(name=data['name'], location=data['location'], tier=data['tier'])
    
    def __str__(self):
        return f"Storage Account: ({self.name}) Location: ({self.location}) Tier: ({self.tier})"
    