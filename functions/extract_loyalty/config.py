import os
from dataclasses import dataclass, field

@dataclass
class Settings:
    # SQL Server Settings
    SQL_SERVER: str = field(default_factory=lambda: os.getenv("SQL_SERVER", "192.168.20.68"))
    SQL_PORT: int = field(default_factory=lambda: int(os.getenv("SQL_PORT", "1433")))
    SQL_DATABASE: str = field(default_factory=lambda: os.getenv("SQL_DATABASE", "SBPAPAJOHNS"))
    SQL_USER: str = field(default_factory=lambda: os.getenv("SQL_USER", "upapajohns"))
    SQL_PASSWORD: str = field(default_factory=lambda: os.getenv("SQL_PASSWORD", "Pla!npart17"))
    
    # BigQuery Settings
    GCP_PROJECT_ID: str = field(default_factory=lambda: os.getenv("GCP_PROJECT_ID", "papajohnsec"))
    BQ_DATASET_ID: str = field(default_factory=lambda: os.getenv("BQ_DATASET_ID", "papajohns_loyalty_ec"))
    BQ_LOCATION: str = field(default_factory=lambda: os.getenv("BQ_LOCATION", "US"))
    
    # Execution Settings
    CHUNK_SIZE: int = field(default_factory=lambda: int(os.getenv("CHUNK_SIZE", "10000")))

settings = Settings()
