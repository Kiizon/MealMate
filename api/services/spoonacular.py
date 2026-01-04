import requests
import os
from dotenv import load_dotenv

load_dotenv()

SPOONACULAR_API_KEY = os.getenv("SPOONACULAR_API_KEY")
SPOONACULAR_BASE_URL = "https://api.spoonacular.com"

class SpoonacularService:
    def __init__(self):
        self.api_key = SPOONACULAR_API_KEY

    def find_recipes_by_ingredients(self, ingredients: list[str], number: int = 10, ranking: int = 2, ignore_pantry: bool = True):
        url = f"{SPOONACULAR_BASE_URL}/recipes/findByIngredients"
        
        params = {
            "apiKey": self.api_key,
            "ingredients": ",".join(ingredients),
            "number": number,
            "ranking": ranking,
            "ignorePearsons": ignore_pantry,
        }

        response = requests.get(url, params = params)
        response.raise_for_status()
        return response.json()

    def get_recipe_information(self, recipe_id: int):
        url = f"{SPOONACULAR_BASE_URL}/recipes/{recipe_id}/information"

        params = {
            "apiKey": self.api_key,
            "includeNutrition": True,
        }

        response = requests.get(url, params = params)
        response.raise_for_status()
        return response.json()