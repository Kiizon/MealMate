import re

FOOD_PATTERNS = {
    'proteins': [
        'chicken', 'beef', 'pork', 'lamb', 'turkey', 'salmon', 'shrimp',
        'fish', 'tuna', 'bacon', 'sausage', 'ham', 'steak', 'ribs',
    ],
    'dairy': [
        'milk', 'cheese', 'yogurt', 'butter', 'cream', 'egg', 'eggs',
    ],
    'produce': [
        'apple', 'banana', 'orange', 'tomato', 'potato', 'onion',
        'garlic', 'carrot', 'lettuce', 'spinach', 'broccoli', 'avocado',
    ],
    'grains': [
        'bread', 'rice', 'pasta', 'flour', 'cereal', 'tortilla', 'oat',
    ],
    'pantry': [
        'sauce', 'salsa', 'soup', 'oil', 'vinegar', 'honey',
    ],
}

def compile_patterns(categories: dict[str, list[str]]):
    """Compile food patterns into regex objects."""
    patterns = []
    
    for items in categories.values():
        # Escape special characters in each item
        escaped = []
        for item in items:
            escaped.append(re.escape(item))
        
        # Build the pattern with word boundaries and optional 's' for plurals
        pattern = r'\b(' + '|'.join(escaped) + r')s?\b'
        patterns.append(re.compile(pattern, re.IGNORECASE))
    
    return patterns


COMPILED_PATTERNS = compile_patterns(FOOD_PATTERNS)


def is_food_item(name: str, description: str = ""):
    """Check if an item matches any food pattern."""
    text = f"{name} {description}".lower()
    
    # Check each pattern for a match
    for pattern in COMPILED_PATTERNS:
        if pattern.search(text):
            return True
    
    return False


def filter_food_deals(deals: list[dict]):
    """Filter deals to include only food items."""
    food_deals = []
    
    for deal in deals:
        name = deal.get('name', '')
        description = deal.get('description', '')
        
        if is_food_item(name, description):
            food_deals.append(deal)
    
    return food_deals


def extract_ingredients(deals: list[dict]):
    """Extract unique ingredient names from food deals for Spoonacular API."""
    ingredients = set()
    
    for deal in deals:
        name = deal.get('name', '').lower()
        
        for pattern in COMPILED_PATTERNS:
            matches = pattern.findall(name)
            
            for match in matches:
                # Clean up whitespace
                clean = re.sub(r'\s+', ' ', match.strip())
                
                if clean:
                    ingredients.add(clean)
    
    # Convert set to sorted list
    result = []
    for ingredient in ingredients:
        result.append(ingredient)
    
    result.sort()
    return result