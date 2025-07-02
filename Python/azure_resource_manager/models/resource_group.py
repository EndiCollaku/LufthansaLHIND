from models.base import AzureResource
from models.virtual_machine import VirtualMachine
from models.storage_account import StorageAccount
from models.sql_database import SQLDatabase


class ResourceGroup(AzureResource):
    def __init__(self, name, location):
        super().__init__(name, location)
        self.resources = []

    def add_resource(self, resource):
        self.resources.append(resource)

    def to_dict(self):
        """Convert the ResourceGroup to a dictionary representation."""
        return {
            "type": "ResourceGroup",
            "name": self.name,
            "location": self.location,
            "resources": [r.to_dict() for r in self.resources]
        }

    @classmethod
    def from_dict(cls, data):
        rg = cls(data["name"], data["location"])
        for r in data.get("resources", []):
            t = r.get("type")
            if t == "VirtualMachine":
                rg.add_resource(VirtualMachine.from_dict(r))
            elif t == "StorageAccount":
                rg.add_resource(StorageAccount.from_dict(r))
            elif t == "SQLDatabase":
                rg.add_resource(SQLDatabase.from_dict(r))
        return rg

    def __str__(self):
        res_str = "\n  ".join(str(r) for r in self.resources) if self.resources else "No resources"
        return f"Resource Group: {self.name} ({self.location})\n  {res_str}"
