//
//  AppDelegate.swift
//  notepaxx
//
//  Created by Brian Angulo on 8/23/22.
//

import Foundation
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    @Published var openedFileContent = ""
    var callback: (String) -> Void = {
        (content: String) in print("empty")
    }
    
    func addCallback(cb: @escaping (String) -> Void) -> Void {
        self.callback = cb
    }
    
    func application(_ application: NSApplication, open urls: [URL]) {
        print(">> \(urls)")
        print(">> \(application)")
        // only getting the first one since each application can only deal with one
        if (urls.count > 0) {
            let fileUrl: URL = urls[0]
            do {
                try self.openedFileContent = String(contentsOf: fileUrl)
            } catch {
                print("Error trying to read file", error, separator: " -> ")
                // if an error occurs set to empty
                self.openedFileContent = ""
            }
        } else if (!self.openedFileContent.isEmpty) {
            self.openedFileContent = ""
        }
        // this calls function from main scene viewmodel which handles updating the view state
        self.callback(self.openedFileContent)
    }
}
