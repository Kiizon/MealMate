# MealMate

## Overview

MealMate is a budget-conscious recipe generator that helps users save money by creating meal plans based on local grocery deals. Born from the motivation to be frugal and make the most of every dollar, it transforms weekly flyer discounts into practical, cost-effective recipes. Simply enter your postal code and let MealMate do the work of finding deals and suggesting what to cook.

<!-- Main page screenshot -->
![MealMate Main Page](images/main-page.png)

## Technical Information

MealMate uses a React frontend that sends postal-code–based requests to a GCP Cloud Function, which handles all backend logic including deal aggregation, caching, and AI orchestration. The Cloud Function scrapes localized grocery deals, stores and reuses them in Firestore, and generates budget-optimized recipes via Gemini only when needed. The combined deals and recipes are then returned as a single response for efficient client-side rendering.

![Architecture Diagram](images/architecture-diagram.png)

## Future Outlook

- Meal planning calendar with weekly budget tracking
- User accounts to save favorite recipes and preferred stores
- Nutritional information and dietary preference filters
- Price comparison across multiple stores
- Shopping list generation and export
