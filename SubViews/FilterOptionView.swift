//
//
//
//  OptionButtonsView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/29/23.
//

import SwiftUI

//let messages: [String: String] = [
//        "Accessed": "Last time the file was accessed",
//        "Modified": "Last time the content of the file was modified",
//        "Inode Δ": "inode  changes: permissions, location or content",
//        "Created": "Creation timestamp for the file"]

struct FilterOptionView: View {
    let buttonNames = ["Accessed", "Modified", "Inode Δ", "Created"]
    let messages: [String: String] = [
            "Accessed": "Last time accessed",
            "Modified": "Last time modified",
            "Inode Δ": "inode  changes",
            "Created": "Creation timestamp"]
    @State private var hoveredName: String?
    @State private var name: String?
//    @Binding var name: String?
    @ObservedObject var filterSelection = FilterSelection.shared
    
    var body: some View {
        HStack {
            ForEach(buttonNames, id: \.self) { name in
                Button(action: {
                    self.filterSelection.whichDateFilterIsApplied = name
                }) {
                    Circle()
                        .fill(FilterSelection.shared.whichDateFilterIsApplied == name ? Color("LL_orange") : Color.gray)
                        .frame(width: 15, height: 20)

                    Text(name)
                    .frame(width: 50, height: 20)
                    .font(.caption)
                    .overlay(tooltipOverlay(for: name))

                }
                .padding(3)
                .onHover { isHovered in
                    if isHovered {
                        self.hoveredName = name
                    } else {
                        self.hoveredName = nil
                    }
                }
//                .overlay(
//                    Text(self.hoveredName == name ? messages[name] ?? "" : "")
//                        .frame(width: 120, Height: 30)
//                        .background(Color(.orange))
//                        .font(.caption)
//                        .foregroundColor(.black)
//                        .padding(3)
//                        .offset(y: 50)
//                    )
            }
        }
//        .frame(width: 400, height: 100)
    }
    
    private func tooltipOverlay(for name: String) -> some View {
        Group {
            if self.hoveredName == name {
                Text(messages[name] ?? "nothing to show")
                .font(.caption2)
                .lineLimit(nil)
                .padding(2)
                .frame(width: 90, height: 50)
                .background(Color.black.opacity(0.5))
                .foregroundColor(.white)
                .cornerRadius(7.0)
                .offset(y: 10.0)
            }
        }
    }
}
//import SwiftUI



#Preview {
    FilterOptionView()
}
