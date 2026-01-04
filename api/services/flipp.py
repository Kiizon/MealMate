import requests
import random
from typing import Optional

FLYERS_URL = 'https://flyers-ng.flippback.com/api/flipp/data?locale=en&postal_code={}&sid={}'
FLYER_ITEMS_URL = 'https://flyers-ng.flippback.com/api/flipp/flyers/{}/flyer_items?locale=en&sid={}'
GROCERY_STORES = {'No Frills', 'FreshCo', 'Walmart', 'Loblaws'}


def generate_sid() -> str:
    """Generate a random session ID for Flipp API."""
    return ''.join(str(random.randint(0, 9)) for _ in range(16))


def get_flyers_by_postal_code(postal_code: str) -> dict:
    """Fetch flyer data from Flipp API for a postal code."""
    sid = generate_sid()
    url = FLYERS_URL.format(postal_code, sid)
    response = requests.get(url)
    response.raise_for_status()
    return response.json()


def get_grocery_flyer_ids(postal_code: str) -> Optional[list[dict]]:
    """Return flyer IDs for grocery stores in the given postal code."""
    response_data = get_flyers_by_postal_code(postal_code)

    if 'flyers' not in response_data:
        return None

    grocery_flyers = []
    for flyer in response_data['flyers']:
        merchant = flyer.get('merchant')
        categories = flyer.get('categories', [])

        if isinstance(categories, str):
            categories = [cat.strip() for cat in categories.split(',')]

        if merchant in GROCERY_STORES and 'Groceries' in categories:
            grocery_flyers.append({
                'id': flyer['id'],
                'merchant': merchant
            })

    return grocery_flyers if grocery_flyers else None


def get_flyer_items(flyer_id: int) -> list[dict]:
    """Fetch all items from a specific flyer."""
    sid = generate_sid()
    url = FLYER_ITEMS_URL.format(flyer_id, sid)
    response = requests.get(url)
    response.raise_for_status()
    return response.json()


def get_raw_deals_for_postal_code(postal_code: str) -> list[dict]:
    """
    Main function: Get all grocery deals for a postal code.
    Returns a list of deal dictionaries.
    """
    grocery_flyers = get_grocery_flyer_ids(postal_code)

    if not grocery_flyers:
        return []

    all_deals = []
    for flyer in grocery_flyers:
        items = get_flyer_items(flyer['id'])

        for item in items:
            all_deals.append({
                'merchant': flyer['merchant'],
                'name': item.get('name', ''),
                'description': item.get('description', ''),
                'price': item.get('price', ''),
                'pre_price': item.get('pre_price_text', ''),
                'valid_from': item.get('valid_from', ''),
                'valid_to': item.get('valid_to', ''),
            })

    return all_deals
