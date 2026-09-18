import os
from pydantic import BaseModel, Field

class Settings(BaseModel):
    # SQL Server Settings
    SQL_SERVER: str = Field(default_factory=lambda: os.getenv("SQL_SERVER", "192.168.20.68"))
    SQL_PORT: int = Field(default_factory=lambda: int(os.getenv("SQL_PORT", "1433")))
    SQL_DATABASE: str = Field(default_factory=lambda: os.getenv("SQL_DATABASE", "SBPAPAJOHNS"))
    SQL_USER: str = Field(default_factory=lambda: os.getenv("SQL_USER", "upapajohns"))
    SQL_PASSWORD: str = Field(default_factory=lambda: os.getenv("SQL_PASSWORD", "Pla!npart17"))
    
    # BigQuery Settings
    GCP_PROJECT_ID: str = Field(default_factory=lambda: os.getenv("GCP_PROJECT_ID", "papajohnsec"))
    BQ_DATASET_ID: str = Field(default_factory=lambda: os.getenv("BQ_DATASET_ID", "papajohns_loyalty_ec"))
    BQ_LOCATION: str = Field(default_factory=lambda: os.getenv("BQ_LOCATION", "US"))
    
    # Execution Settings
    CHUNK_SIZE: int = Field(default_factory=lambda: int(os.getenv("CHUNK_SIZE", "10000")))

settings = Settings()
