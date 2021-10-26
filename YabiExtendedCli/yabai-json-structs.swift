//
//  yabai-json-structs.swift
//  YabiExtendedCli
//
//  Created by Nils Bergmann on 14/06/2021.
//

import Foundation

struct Window: Decodable {
    let id: Int;
    let grabbed: Bool;
    
    enum CodingKeys: String, CodingKey {
        case id
        case grabbed = "is-grabbed"
    }
}

struct Display: Decodable {
    let id: Int;
    let index: Int;
    let uuid: String;
}

struct Space: Decodable {
    let id: Int;
    let index: Int;
    let focused: Bool;
    let visible: Bool;
    
    enum CodingKeys: String, CodingKey {
        case id
        case index
        case focused = "has-focus"
        case visible = "is-visible"
    }
}
