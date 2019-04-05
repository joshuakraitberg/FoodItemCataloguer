//
//  DataModelClasses.swift
//  Purpose - Classes and structs that describe the shape of entities
//

import Foundation

// MARK: - Constructs for importing data

// Write a struct or class to describe the shape of each imported or externally-sourced entity

// Example shape for a "Country" entity
struct Country: Decodable {
    let name: String
    let capital: String
    let region: String
}

// MARK: - Constructs for data within the app

struct ExampleAdd {
    let name: String
    let quantity: Int
}

// Write a struct or class (below) to describe the shape of each entity

// JSON from https://api.nal.usda.gov/ndb/search/?max=25&api_key=YOUR_API_KEY&q=butter
class NdbSearchPackage: Decodable {
    var list: NdbSearchList!
}


class NdbSearchList: Decodable {
    var q: String!
    var sr: String!
    var ds: String!
    var start: Int!
    var total: Int!
    var group: String!
    var sort: String!
    var item: [NdbSearchListItem]!
}


class NdbSearchListItem: Decodable {
    var offset: Int!
    var group: String!
    var name: String!
    var ndbno: String!
    var ds: String!
    var manu: String!
}
