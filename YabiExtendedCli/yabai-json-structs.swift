//
//  yabai-json-structs.swift
//  YabiExtendedCli
//
//  Created by Nils Bergmann on 14/06/2021.
//

import Foundation

struct Window: Decodable {
    let id: Int;
    let grabbed: Int;
}

struct Display: Decodable {
    let id: Int;
    let index: Int;
}

struct Space: Decodable {
    let id: Int;
    let index: Int;
    let focused: Int;
}
