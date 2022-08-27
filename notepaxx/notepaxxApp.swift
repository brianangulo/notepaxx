//
//  notepaxxApp.swift
//  notepaxx
//
//  Created by Brian Angulo on 8/13/22.
//

import SwiftUI
import AppKit

@main
struct notepaxxApp: App {
    @ObservedObject var viewModel = NotepaxxAppViewModel()
    @NSApplicationDelegateAdaptor private var appDelegate: AppDelegate
    var body: some Scene {
        WindowGroup {
            ContentView(stringHolder: $viewModel.text)
                .onAppear {
                    // adds subscription to the delegate for when files get opened while its active
                    appDelegate.subscribeToFileContentLoaded(callback: viewModel.loadFileContent)
                    // calling on appear for when app is coming from background and delegate function is called before callback ins instantiated
                    viewModel.loadFileContent(content: appDelegate.openedFileContent)
                    // disable multitab
                    NSWindow.allowsAutomaticWindowTabbing = false
                }
        }
        .handlesExternalEvents(matching: [])
        .commands {
            CommandGroup(replacing: .newItem) {
                 Button("Save") {
                     viewModel.save()
                 }
             }
        }
    }
}

extension notepaxxApp {
    class NotepaxxAppViewModel: ObservableObject {
        @Published var text: String = ""
        // checks if needed to load file content content should come from appDelegate
        // this function is designed to be used as a callback for appdelegate
        func loadFileContent(content: String) -> Void {
            if (!content.isEmpty) {
                self.text = content
                self.bringToFocus()
            }
        }
        
        // if the app is hidden it will bring it to focus
        func bringToFocus() -> Void {
            if !(NSApp.windows.first?.isVisible ?? false) {
                NSApp.windows.first?.orderFrontRegardless()
            }
        }
        
        func save() -> Void {
            let savePanel = NSSavePanel()
            savePanel.allowedContentTypes = [.plainText]
            savePanel.canCreateDirectories = true
            savePanel.isExtensionHidden = false
            savePanel.title = "Save note to file"
            savePanel.message = "Choose a folder and a name to your text note."
            savePanel.nameFieldLabel = "Note file name:"
            // prompt the user
            let response = savePanel.runModal()
            if (response == .OK && (savePanel.url != nil)) {
                do {
                   try self.text.write(to: savePanel.url!, atomically: true, encoding: .ascii)
                } catch {
                    print(error)
                }
            }
        }
    }
}
