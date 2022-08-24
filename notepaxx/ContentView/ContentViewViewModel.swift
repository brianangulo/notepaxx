//
//  ContentViewViewModel.swift
//  notepaxx
//
//  Created by Brian Angulo on 8/22/22.
//

import Foundation

extension ContentView {
    class ContentViewViewModel: ObservableObject {
        @Published var text: String = ""
        
        func handleSave() -> Void {
            print("foo")
        }
    }
}
