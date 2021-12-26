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

let grabbedDispatchQueue = DispatchQueue(label: "grabbed-window");
let focusDispatchQueue = DispatchQueue(label: "focus-queue");
let currentDisplayQueue = DispatchQueue(label: "currentDisplay");
let currentSpaceQueue = DispatchQueue(label: "currentDisplay");
let lastSpaceQueue = DispatchQueue(label: "last-space");
let firstSpaceQueue = DispatchQueue(label: "first-space");

let grabbedIndexSemaphore = DispatchSemaphore(value: 0);
let currentDisplaySemaphore = DispatchSemaphore(value: 0);
let currentSpaceSemaphore = DispatchSemaphore(value: 0);
let currentFocusedWindowSemaphore = DispatchSemaphore(value: 0);

let lastSpaceSemaphore = DispatchSemaphore(value: 0);
let firstSpaceSemaphore = DispatchSemaphore(value: 0);

var targetSpaceIndex: Int = 0;

var currentSpace: Int = 0;

let event = CGEvent(source: nil)

var grabbedIndex: Int?;

var lastSpace: Int?;
var firstSpace: Int?;

do {
    guard let input = main.arguments.first else {
        throw MyError.runtimeError("Missing argument");
    }
    
    currentSpaceQueue.async {
        currentSpace = try! getCurrentSpaceForDisplay();
        currentSpaceSemaphore.signal();
    }
    
    if input != "nextMoveWindow" && input != "backMoveWindow" {
        grabbedDispatchQueue.async {
            grabbedIndex = getGrabbedWindow();
            currentSpaceSemaphore.wait();
            grabbedIndexSemaphore.signal();
        }
    } else {
        grabbedDispatchQueue.async {
            var display: Int?;
            currentDisplayQueue.async {
                display = try! getCurrentDisplay();
                currentDisplaySemaphore.signal();
            }
            var focusedWindow: Window?;
            focusDispatchQueue.async {
                focusedWindow = try! getFocusedWindow();
                currentFocusedWindowSemaphore.signal();
            }
            currentDisplaySemaphore.wait();
            currentSpaceSemaphore.wait();
            currentFocusedWindowSemaphore.wait();
            if focusedWindow!.display == display && focusedWindow!.space == currentSpace {
                grabbedIndex = focusedWindow!.id;
            }
            grabbedIndexSemaphore.signal();
        }
    }
    
    lastSpaceQueue.async {
        lastSpace = try! getLastSpaceIndexForDisplay();
        lastSpaceSemaphore.signal();
    }
    firstSpaceQueue.async {
        firstSpace = try! getFirstSpaceIndexForDisplay();
        firstSpaceSemaphore.signal();
    }
    
    grabbedIndexSemaphore.wait();
    
    if input == "first" {
        targetSpaceIndex = try! getFirstSpaceIndexForDisplay();
    } else if input == "last" {
        targetSpaceIndex = try! getLastSpaceIndexForDisplay();
    } else {
        if input == "next" || input == "nextMoveWindow"  {
            lastSpaceSemaphore.wait();
            if currentSpace == lastSpace! {
                firstSpaceSemaphore.wait();
                targetSpaceIndex = firstSpace!;
            } else {
                targetSpaceIndex = currentSpace + 1;
            }
        } else if input == "back" || input == "backMoveWindow"  {
            firstSpaceSemaphore.wait();
            if currentSpace == firstSpace! {
                lastSpaceSemaphore.wait();
                targetSpaceIndex = lastSpace!;
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
        
    if event != nil {
        CGWarpMouseCursorPosition(event!.location);
    }
    
} catch {
    print("Error: \(error)");
    exit(1);
}



