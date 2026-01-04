//
//  Models.swift
//  MealMate
//
//  Created by Kish Dizon on 2025-12-30.
//

import Foundation

// MARK: - Deal models
struct DealsResponse: Codable {
    let postalCode: String
    let count: Int
    let deals: [Deal]
    
    enum CodingKeys: String, CodingKey {
        case postalCode = "postal_code"
        case count, deals
        
    }
}

struct Deal: Codable, Identifiable {
    var id: String { "\(merchant)-\(name)" }
    
    let merchant: String
    let name: String
    let description: String
    let price: String
    let pre_price: String
    let validFrom: String
    let validTo: String
    
    enum CodingKeys: String, CodingKey {
        case merchant, name, description, price
        case pre_price = "pre_price"
        case validFrom = "valid_from"
        case validTo = "valid_to"
        
    }
}

// MARK: - Store models

struct StoresResponse: Codable {
    let postalCode: String
    let stores: [Store]
    
    enum CodingKeys: String, CodingKey {
        case postalCode = "postal_code"
        case stores
    }
    
}

struct Store: Codable, Identifiable {
    var id: String { name }
    
    let name: String
    let flyerId: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case flyerId = "flyer_id"
    }
}

// MARK: - Recipe models

struct RecipesResponse: Codable {
    let postalCode: String
    let merchant: String
    let ingredientsOnSale: [String]
    let recipes: [Recipe]
    
    enum CodingKeys: String, CodingKey {
        case postalCode = "postal_code"
        case ingredientsOnSale = "ingredients_on_sale"
        case merchant, recipes
    }
}

struct Recipe: Codable, Identifiable {
    let id: Int
    let title: String
    let image: String
    let usedIngredientCount: Int
    let missedIngredientCount: Int
    let usedIngredients: [RecipeIngredient]
    let missedIngredients: [RecipeIngredient]
    
    enum CodingKeys: String, CodingKey {
        case id, title, image
        case usedIngredientCount = "usedIngredientCount"
        case missedIngredientCount = "missedIngredientCount"
        case usedIngredients, missedIngredients
    }
}

struct RecipeIngredient: Codable, Identifiable {
    var id: Int { Int.random(in: 0...999999) } // Spoonacular doesn't always provide id
    let name: String
    let amount: Double
    let unit: String
    let original: String

    enum CodingKeys: String, CodingKey {
        case name, amount, unit, original
    }
}

