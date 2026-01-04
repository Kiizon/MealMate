from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from services.flipp import get_raw_deals_for_postal_code, get_grocery_flyer_ids
from services.normalizer import filter_food_deals, extract_ingredients
from services.spoonacular import SpoonacularService
import re
import os
from dotenv import load_dotenv

load_dotenv()

app = FastAPI(title  = "MealMate API", description = "Backend for MealMate")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_credentials=True,
    allow_headers=["*"]
)

spoonacular = SpoonacularService()

def validate_postal_code(postal_code: str):
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
    uncleaned_deals = get_raw_deals_for_postal_code(postal_code)
    filtered_food_deals = filter_food_deals(uncleaned_deals)
    ingredients = extract_ingredients(filtered_food_deals)
    
    return {
        "postal_code": postal_code,
        "total_raw": len(uncleaned_deals),
        "count": len(filtered_food_deals),
        "ingredients": ingredients,
        "deals": filtered_food_deals
    }

@app.get("/api/recipes/{postal_code}")
def get_recipes(postal_code: str, limit: int = 8):
    postal_code = postal_code.replace(" ", "").upper()

    if not validate_postal_code(postal_code):
        raise HTTPException(status_code = 400, detail = "Invalid Postal Code")

    unclean_deals = get_raw_deals_for_postal_code(postal_code)
    filtered_food_deals = filter_food_deals(unclean_deals)
    ingredients = extract_ingredients(filtered_food_deals)

    if not ingredients:
        return {"recipes": [], "message": "No ingredients found"}
    
    recipes = spoonacular.find_recipes_by_ingredients(ingredients, number = limit)  

    return {
        "postal_code": postal_code,
        "ingredients": ingredients,
        "recipes": recipes,
    }

@app.get("/api/stores/{postal_code}")
def get_stores(postal_code: str):
    """Get grocery stores with flyers for a postal code."""
    postal_code = postal_code.replace(" ", "").upper()

    if not validate_postal_code(postal_code):
        raise HTTPException(status_code=400, detail="Invalid postal code")

    flyers = get_grocery_flyer_ids(postal_code)

    if not flyers:
        return {"stores": []}

    # Get unique merchants
    stores = [{"name": f["merchant"], "flyer_id": f["id"]} for f in flyers]

    return {
        "postal_code": postal_code,
        "stores": stores,
    }

@app.get("/api/recipes/{postal_code}/{merchant}")
def get_recipes_by_merchant(postal_code: str, merchant: str, limit: int = 10):
    """Get recipes based on a specific store's deals."""
    postal_code = postal_code.replace(" ", "").upper()

    if not validate_postal_code(postal_code):
        raise HTTPException(status_code=400, detail="Invalid postal code")

    raw_deals = get_raw_deals_for_postal_code(postal_code, merchant = merchant)
    filtered_food_deals = filter_food_deals(raw_deals)
    ingredients = extract_ingredients(filtered_food_deals)

    if not ingredients:
        return {"recipes": [], "ingredients_on_sale": [], "message": "No food ingredients found"}

    recipes = spoonacular.find_recipes_by_ingredients(ingredients, number=limit)

    return {
        "postal_code": postal_code,
        "merchant": merchant,
        "ingredients_on_sale": ingredients,
        "deals_count": len(filtered_food_deals),
        "recipes": recipes,
    }
    
if __name__ == "__main__":
    import uvicorn
    port = int(os.environ.get("PORT", 8000))
    uvicorn.run(app, host = "0.0.0.0", port = port, reload = True)