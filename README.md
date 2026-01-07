# MealMate

## Overview

MealMate is a budget-conscious recipe generator that helps users save money by creating meal plans based on local grocery deals. Born from the motivation to be frugal and make the most of every dollar, it transforms weekly flyer discounts into practical, cost-effective recipes. Simply enter your postal code and let MealMate do the work of finding deals and suggesting what to cook.

### Running the Frontend
```bash
go into xcode and build
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


