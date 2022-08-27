//
//  ContentView.swift
//  notepaxx
//
//  Created by Brian Angulo on 8/22/22.
//

import SwiftUI

struct ContentView: View {
    @Binding var stringHolder: String
    var body: some View {
        TextEditor(text: $stringHolder)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    @State static var previewStringHolder: String = ""
    static var previews: some View {
        ContentView(stringHolder: $previewStringHolder)
    }
}
