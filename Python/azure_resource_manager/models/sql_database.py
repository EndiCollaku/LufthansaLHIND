from models.base import AzureResource

class SQLDatabase(AzureResource):
    def __init__(self, name, location, edition):
        super().__init__(name, location)
        self.edition = edition

    def to_dict(self):
        return {
            "type": "SQLDatabase",
            "name": self.name,
            "location": self.location,
            "edition": self.edition
        }
    @classmethod
    def from_dict(cls, data):
        return cls(name=data['name'], location=data['location'], edition=data['edition'])
    
    def __str__(self):
        return f"SQL Database: ({self.name}) Location: ({self.location}) Edition: ({self.edition})"