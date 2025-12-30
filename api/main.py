from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from services.flipp import get_deals_for_postal_code
import re
import os
app = FastAPI(title  = "MealMate API", description = "Backend for MealMate")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_credentials=True,
    allow_headers=["*"]
)

def validate_postal_code(postal_code: str) -> bool:
    pattern = r'^[A-Za-z]\d[A-Za-z]\s?\d[A-Za-z]\d$'
    if re.match(pattern, postal_code):
        return True
    else:
        return False
    
@app.get("/")
def read_root():
    return {"message": "Welcome to the MealMate API"}

@app.get("/health")
def health_check():
    return {"status": "a-ok!"}

@app.get("/api/deals/{postal_code}")
def get_deals(postal_code: str):
    postal_code = postal_code.replace(" ", "").upper()

    if not validate_postal_code(postal_code):
        raise HTTPException(
            status_code = 400,
            detail = "Invalid postal code format. Use Use format like M5V2H1"
            )
    deals = get_deals_for_postal_code(postal_code)
    return {
        "postal_code": postal_code,
        "count": len(deals),
        "deals": deals
    }
    
if __name__ == "__main__":
    import uvicorn
    port = int(os.eviron.get("PORT", 8000))
    uvicorn.run(app, host = "0.0.0.0", port = port, reload = True)