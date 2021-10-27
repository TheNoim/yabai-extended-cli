//
//  yabai.swift
//  YabiExtendedCli
//
//  Created by Nils Bergmann on 14/06/2021.
//

import Foundation
import SwiftShell
import AppKit

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

func getDisplayByUUID(uuid: String) throws -> Display? {
    let result = run("/usr/local/bin/yabai", "-m", "query", "--displays");
    if !result.succeeded {
        throw MyError.runtimeError("Can not find current display. Yabai exited with non zero error code");
    }
    guard let jsonData = result.stdout.data(using: .utf8) else {
        throw MyError.runtimeError("Can not find current display. Can not convert output to data");
    }
    guard let decoded = try? JSONDecoder().decode([Display].self, from: jsonData) else {
        throw MyError.runtimeError("Can not find current display. Can not parse json");
    }
    return decoded.first { $0.uuid == uuid };
}

var cachedDisplayMouseQuery: RunOutput = {
    let screen = getScreenWithMouse()
    if screen != nil {
        let display = try? getDisplayByUUID(uuid: screen!.identifier);
        if display != nil {
            return run("/usr/local/bin/yabai", "-m", "query", "--spaces", "--display", display!.index)
        }
    }
    
    return run("/usr/local/bin/yabai", "-m", "query", "--spaces", "--display", "mouse")
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
    return decoded.filter({ $0.visible || $0.focused }).first!.index;
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

func getFocusedWindow() throws -> Window {
    let result = run("/usr/local/bin/yabai", "-m", "query", "--windows", "--window");
    if !result.succeeded {
        throw MyError.runtimeError("Can not find focused window. Yabai exited with non zero error code");
    }
    guard let jsonData = result.stdout.data(using: .utf8) else {
        throw MyError.runtimeError("Can not find focused window. Can not convert output to data");
    }
    guard let decoded = try? JSONDecoder().decode(Window.self, from: jsonData) else {
        throw MyError.runtimeError("Can not find focused window. Can not parse json");
    }
    return decoded;
}

func focusSpace(index: Int) {
    run("/usr/local/bin/yabai", "-m", "space", "--focus", index);
}

func moveWindowToSpace(windowIndex: Int, spaceIndex: Int) {
    run("/usr/local/bin/yabai", "-m", "window", windowIndex, "--space", spaceIndex);
}

func focusWindow(index: Int) {
    run("/usr/local/bin/yabai", "-m", "window", "--focus", index);
}

func getScreenWithMouse() -> NSScreen? {
    let mouseLocation = NSEvent.mouseLocation
    let screens = NSScreen.screens
    
    let screenWithMouse = (screens.first { NSMouseInRect(mouseLocation, $0.frame, false) })
    
    return screenWithMouse;
}

func getGrabbedWindow() -> Int? {
    var grabbedIndex: Int?;
    
    let mouseOutput = run("/usr/local/bin/yabai", "-m", "query", "--windows", "--window", "mouse")

    if mouseOutput.succeeded {
        if let jsonData = mouseOutput.stdout.data(using: .utf8) {
            let decoded = try! JSONDecoder().decode(Window.self, from: jsonData);
            if decoded.grabbed {
                grabbedIndex = decoded.id;
            }
        }
    }
    
    return grabbedIndex;
}

private let NSScreenNumberKey = NSDeviceDescriptionKey("NSScreenNumber")

extension NSScreen {
    public var identifier: String {
        guard let number = deviceDescription[NSScreenNumberKey] as? NSNumber else {
            return ""
        }

        let uuid = CGDisplayCreateUUIDFromDisplayID(number.uint32Value).takeRetainedValue()
        return CFUUIDCreateString(nil, uuid) as String
    }
}
