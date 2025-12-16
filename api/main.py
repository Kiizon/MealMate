from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import Optional, List
import os

app = FastAPI(title="MealMate API", description="Backend for MealMate")

class DealRequest(BaseModel):
    postal_code: str
    preferences: Optional[str] = None

class MealResponse(BaseModel):
    deals: List[dict]
    recipes: List[dict]
    assistant_message: str

@app.get("/")
def read_root():
    return {"message": "Welcome to MealMate API"}

@app.get("/health")
def health_check():
    return {"status": "ok"}

@app.post("/api/get-meals", response_model=MealResponse)
async def get_meals(request: DealRequest):
    """
    Main endpoint:
    1. Aggregates grocery deals for the postal code (from Firestore/Scraper).
    2. Generates budget-optimized recipes via Gemini.
    3. Returns combined response.
    """
    # Placeholder logic
    # TODO: Implement scraping/lookup logic
    # TODO: Implement Gemini AI logic
    
    return {
        "deals": [{"item": "Placeholder Deal", "price": 0.00}],
        "recipes": [{"name": "Placeholder Recipe", "ingredients": ["Item A"]}],
        "assistant_message": f"Deals found for {request.postal_code}. enjoy!"
    }


if __name__ == "__main__":
    import uvicorn
    # process.env.PORT is for Cloud Run/Functions often, default to 8000 locally
    port = int(os.environ.get("PORT", 8000))
    uvicorn.run(app, host="0.0.0.0", port=port)
