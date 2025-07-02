class AzureResource:
    def __init__(self,name,location):
        self.name = name
        self.location = location
    
    def __str__(self):
        return f"{self.__class__.__name__}: {self.name} - Location: {self.location}"