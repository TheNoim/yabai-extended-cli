//
//  yabai.swift
//  YabiExtendedCli
//
//  Created by Nils Bergmann on 14/06/2021.
//

import Foundation
import SwiftShell

func getCurrentDisplay() throws -> Int {
    let result = run("/usr/local/bin/yabai", "-m", "query", "--displays", "--display", "mouse");
    if !result.succeeded {
        throw MyError.runtimeError("Can not find current display. Yabai exited with non zero error code");
    }
    guard let jsonData = result.stdout.data(using: .utf8) else {
        throw MyError.runtimeError("Can not find current display. Can not convert output to data");
    }
    guard let decoded = try? JSONDecoder().decode(Display.self, from: jsonData) else {
        throw MyError.runtimeError("Can not find current display. Can not parse json");
    }
    return decoded.index;
}

var cachedDisplayMouseQuery: RunOutput = {
    run("/usr/local/bin/yabai", "-m", "query", "--spaces", "--display", "mouse")
}();

func getCurrentSpaceForDisplay() throws -> Int {
    let result = cachedDisplayMouseQuery;
    if !result.succeeded {
        throw MyError.runtimeError("Can not find current space for display. Yabai exited with non zero error code");
    }
    guard let jsonData = result.stdout.data(using: .utf8) else {
        throw MyError.runtimeError("Can not find current space for display. Can not convert output to data");
    }
    guard let decoded = try? JSONDecoder().decode([Space].self, from: jsonData) else {
        throw MyError.runtimeError("Can not find current space for display. Can not parse json");
    }
    return decoded.filter({ $0.focused == 1 }).first!.index;
}

func getFirstSpaceIndexForDisplay() throws -> Int {
    let result = cachedDisplayMouseQuery;
    if !result.succeeded {
        throw MyError.runtimeError("Can not find current space for display. Yabai exited with non zero error code");
    }
    guard let jsonData = result.stdout.data(using: .utf8) else {
        throw MyError.runtimeError("Can not find current space for display. Can not convert output to data");
    }
    guard let decoded = try? JSONDecoder().decode([Space].self, from: jsonData) else {
        throw MyError.runtimeError("Can not find current space for display. Can not parse json");
    }
    return decoded.first!.index;
}

func getLastSpaceIndexForDisplay() throws -> Int {
    let result = cachedDisplayMouseQuery;
    if !result.succeeded {
        throw MyError.runtimeError("Can not find current space for display. Yabai exited with non zero error code");
    }
    guard let jsonData = result.stdout.data(using: .utf8) else {
        throw MyError.runtimeError("Can not find current space for display. Can not convert output to data");
    }
    guard let decoded = try? JSONDecoder().decode([Space].self, from: jsonData) else {
        throw MyError.runtimeError("Can not find current space for display. Can not parse json");
    }
    return decoded.last!.index;
}

func focusSpace(index: Int) {
    run("/usr/local/bin/yabai", "-m", "space", "--focus", index);
}

func focusWindow(index: Int) {
    run("/usr/local/bin/yabai", "-m", "window", "--focus", index);
}

func getGrabbedWindow() -> Int? {
    var grabbedIndex: Int?;
    
    let mouseOutput = run("/usr/local/bin/yabai", "-m", "query", "--windows", "--window", "mouse")

    if mouseOutput.succeeded {
        if let jsonData = mouseOutput.stdout.data(using: .utf8) {
            let decoded = try! JSONDecoder().decode(Window.self, from: jsonData);
            if decoded.grabbed > 0 {
                grabbedIndex = decoded.id;
            }
        }
    }
    
    return grabbedIndex;
}
