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
                    appDelegate.addCallback(cb: viewModel.shouldLoadFileContent)
                }
        }
        .handlesExternalEvents(matching: [])
        .commands {
            CommandGroup(after: CommandGroupPlacement.newItem) {
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
        func shouldLoadFileContent(content: String) -> Void {
            if (!content.isEmpty) {
                self.text = content
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
