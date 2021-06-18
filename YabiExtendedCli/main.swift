//
//  main.swift
//  YabiExtendedCli
//
//  Created by Nils Bergmann on 14/06/2021.
//

import Foundation
import SwiftShell

enum MyError: Error {
    case runtimeError(String)
}

do {
    guard let input = main.arguments.first else {
        throw MyError.runtimeError("Missing argument");
    }
    
    let grabbedIndex: Int? = getGrabbedWindow();
    
    var targetSpaceIndex: Int = 0;
    
    if input == "first" {
        targetSpaceIndex = try! getFirstSpaceIndexForDisplay();
    } else if input == "last" {
        targetSpaceIndex = try! getLastSpaceIndexForDisplay();
    } else {
        let currentSpace = try! getCurrentSpaceForDisplay();
        
        if input == "next" {
            let lastSpace = try! getLastSpaceIndexForDisplay();
            if currentSpace == lastSpace {
                targetSpaceIndex = try! getFirstSpaceIndexForDisplay();
            } else {
                targetSpaceIndex = currentSpace + 1;
            }
        } else if input == "back" {
            let firstSpace = try! getFirstSpaceIndexForDisplay();
            if currentSpace == firstSpace {
                targetSpaceIndex = try! getLastSpaceIndexForDisplay();
            } else {
                targetSpaceIndex = currentSpace - 1;
            }
        }
    }
    
    focusSpace(index: targetSpaceIndex)

    if grabbedIndex != nil {
        moveWindowToSpace(windowIndex: grabbedIndex!, spaceIndex: targetSpaceIndex);
        focusWindow(index: grabbedIndex!);
    }
    
} catch {
    print("Error: \(error)");
    exit(1);
}



