# MealMate

MealMate is an intelligent grocery deal aggregator and recipe generator. It finds local deals based on postal codes and suggests budget-friendly recipes using AI.

## Project Structure

The project is divided into two main components:

### 1. Frontend (`/frontend`)
- **Technology**: Next.js 14+ (App Router), TypeScript, Tailwind CSS, Shadcn UI, Framer Motion.
- **Purpose**: Provides a responsive, modern UI for users to input their location and view deals/recipes.
- **Key Directories**:
  - `src/app`: Page routes and layouts.
  - `src/components/ui`: Reusable UI components (Shadcn).
  - `src/lib`: Utilities.

### 2. Backend API (`/api`)
- **Technology**: FastAPI, Python, Google Cloud (Firestore, Functions, Gemini).
- **Purpose**: Handles deal aggregation, caching, and AI logic.
- **Key Files**:
  - `main.py`: Entry point for the API.
  - `functions_framework`: (Optional) For Cloud Function compatibility.
  - `services/`: Placeholder for Deals logic and AI providers.

## Getting Started

### Prerequisites
- Node.js & npm
- Python 3.9+
- Google Cloud Credentials (for Firestore/Gemini)

### Running the Frontend
```bash
cd frontend
npm install
npm run dev
# Front end will be available at http://localhost:3000
```

### Running the Backend
```bash
cd api
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --reload
# API will be available at http://localhost:8000
# Documentation at http://localhost:8000/docs
```

## Migration Notes
- Legacy code has been moved to `_legacy/` for reference.
- Next.js and FastAPI scaffolds are set up as fresh starting points.

## Architecture
1. **User** enters postal code on Frontend.
2. **Frontend** sends request to `/api/get-meals`.
3. **Backend** checks **Firestore** cache for deals in that area.
   - If missing, triggers **Scraper** (Cloud Function logic) to get fresh deals.
4. **Backend** uses **Gemini AI** to generate recipes based on those deals.
5. **Backend** returns combined JSON to Frontend.
6. **Frontend** renders deals and recipes.

