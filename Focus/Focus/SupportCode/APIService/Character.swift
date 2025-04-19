//
//  Character.swift
//  Focus
//
//  Created by Ryan Thomas on 4/19/25.
//

import Foundation
import SwiftUI

struct CharacterResponse: Codable {
    let message: String
    let result: CharacterResult
    let apiVersion: String
    let timestamp: String
    let support: Support
    let social: Social
}

struct CharacterResult: Codable {
    let properties: Character
    let _id: String
    let description: String
    let uid: String
    let __v: Int
}

struct Character: Codable {
    let name: String
    let gender: String
    let skin_color: String
    let hair_color: String
    let height: String
    let eye_color: String
    let mass: String
    let homeworld: String
    let birth_year: String
    let url: String
    let created: String
    let edited: String
}

struct Support: Codable {
    let contact: String
    let donate: String
    let partnerDiscounts: PartnerDiscounts
}

struct PartnerDiscounts: Codable {
    let saberMasters: Partner
    let heartMath: Partner
}

struct Partner: Codable {
    let link: String
    let details: String
}

struct Social: Codable {
    let discord: String
    let reddit: String
    let github: String
}
