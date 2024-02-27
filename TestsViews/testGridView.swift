//
//  testGridView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 2/10/24.
//

import SwiftUI

struct testGridView: View {
    var body: some View {
        LazyVGrid(columns: [GridItem(.fixed(275)),
                            GridItem(.fixed(275)),
                            GridItem(.fixed(275))],
                  spacing: 0) {
            ForEach(0..<2) { rowIndex in
                ForEach(0..<3) { columnIndex in
                    if rowIndex == 0 {
                        Rectangle()
                            .fill(Color.blue)
                            .frame(height: 30)
                            .padding(0)
                    } else {
                        Rectangle()
                            .fill(Color.red)
                            .frame(height: 170)
                            .padding(0)
                    }
                }
//                .padding(0)
            }
            .padding(0)
        }
        .padding(0)
    }
}

#Preview {
    testGridView()
}
