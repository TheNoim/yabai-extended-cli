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
    
    if input == "first" {
        focusSpace(index: try! getFirstSpaceIndexForDisplay())
    } else if input == "last" {
        focusSpace(index: try! getLastSpaceIndexForDisplay());
    } else {
        let currentSpace = try! getCurrentSpaceForDisplay();
        
        if input == "next" {
            let lastSpace = try! getLastSpaceIndexForDisplay();
            if currentSpace == lastSpace {
                focusSpace(index: try! getFirstSpaceIndexForDisplay())
            } else {
                focusSpace(index: currentSpace + 1)
            }
        } else if input == "back" {
            let firstSpace = try! getFirstSpaceIndexForDisplay();
            if currentSpace == firstSpace {
                focusSpace(index: try! getLastSpaceIndexForDisplay());
            } else {
                focusSpace(index: currentSpace - 1);
            }
        }
    }

    if grabbedIndex != nil {
        focusWindow(index: grabbedIndex!);
    }
    
} catch {
    print("Error: \(error)");
    exit(1);
}



