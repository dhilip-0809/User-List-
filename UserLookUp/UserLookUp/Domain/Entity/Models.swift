//
//  Models.swift
//  UserLookUp
//
//  Created by Dhilip R on 23/10/25.
//

import Foundation

public struct User: Codable, Identifiable {
    public let id: Int
    public let name: String
    public let username: String
    public let email: String
    public let phone: String
    public let website: String
    public let address: Address
    public let company: Company
    
    public init(id: Int, name: String, username: String, email: String, phone: String, website: String, address: Address, company: Company) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.phone = phone
        self.website = website
        self.address = address
        self.company = company
    }
}

public struct Address: Codable {
    public let street: String
    public let suite: String
    public let city: String
    public let zipcode: String
    
    public init(street: String, suite: String, city: String, zipcode: String) {
        self.street = street
        self.suite = suite
        self.city = city
        self.zipcode = zipcode
    }
}

public struct Company: Codable {
    public let name: String
    public let catchPhrase: String
    public let bs: String
    
    public init(name: String, catchPhrase: String, bs: String) {
        self.name = name
        self.catchPhrase = catchPhrase
        self.bs = bs
    }
}

public struct Post: Codable, Identifiable {
    public let id: Int
    public let userId: Int
    public let title: String
    public let body: String
    
    public init(id: Int, userId: Int, title: String, body: String) {
        self.id = id
        self.userId = userId
        self.title = title
        self.body = body
    }
}
