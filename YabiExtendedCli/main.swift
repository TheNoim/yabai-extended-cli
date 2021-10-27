//
//  main.swift
//  YabiExtendedCli
//
//  Created by Nils Bergmann on 14/06/2021.
//

import Foundation
import SwiftShell
import AppKit

enum MyError: Error {
    case runtimeError(String)
}

do {
    guard let input = main.arguments.first else {
        throw MyError.runtimeError("Missing argument");
    }
    
    var grabbedIndex: Int? = getGrabbedWindow();
    
    var targetSpaceIndex: Int = 0;
    
    var currentSpace: Int = 0;
    
    let event = CGEvent(source: nil)
    
    if input == "first" {
        targetSpaceIndex = try! getFirstSpaceIndexForDisplay();
    } else if input == "last" {
        targetSpaceIndex = try! getLastSpaceIndexForDisplay();
    } else {
        currentSpace = try! getCurrentSpaceForDisplay();
        
        if input == "next" || input == "nextMoveWindow"  {
            let lastSpace = try! getLastSpaceIndexForDisplay();
            if currentSpace == lastSpace {
                targetSpaceIndex = try! getFirstSpaceIndexForDisplay();
            } else {
                targetSpaceIndex = currentSpace + 1;
            }
        } else if input == "back" || input == "backMoveWindow"  {
            let firstSpace = try! getFirstSpaceIndexForDisplay();
            if currentSpace == firstSpace {
                targetSpaceIndex = try! getLastSpaceIndexForDisplay();
            } else {
                targetSpaceIndex = currentSpace - 1;
            }
        }
    }
    
    if input == "nextMoveWindow" || input == "backMoveWindow" {
        let display = try! getCurrentDisplay();
        let focusedWindow = try! getFocusedWindow();
        if focusedWindow.display == display && focusedWindow.space == currentSpace {
            grabbedIndex = focusedWindow.id;
        }
    }
    
    focusSpace(index: targetSpaceIndex)

    if grabbedIndex != nil {
        moveWindowToSpace(windowIndex: grabbedIndex!, spaceIndex: targetSpaceIndex);
        focusWindow(index: grabbedIndex!);
        focusWindow(index: grabbedIndex!);
        focusWindow(index: grabbedIndex!);
    }
        
    if event != nil {
        CGWarpMouseCursorPosition(event!.location);
    }
    
} catch {
    print("Error: \(error)");
    exit(1);
}



