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
    let space: Int;
    let display: Int;
}

struct Display: Decodable {
    let id: Int;
    let index: Int;
    let uuid: String;
}

struct Space: Decodable {
    let id: Int;
    let index: Int;
    let focused: Int;
    let visible: Int;
}
