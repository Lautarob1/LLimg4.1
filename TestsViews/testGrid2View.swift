//
//  testGrid2View.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 2/10/24.
//

import SwiftUI

//struct testGrid2View: View {
//    var body: some View {
//        LazyVGrid(columns: [GridItem(.fixed(280)),
//                            GridItem(.fixed(280)),
//                            GridItem(.fixed(280))],
//                  spacing: 20) {
//            ForEach(0..<2) { rowIndex in
//                ForEach(0..<3) { columnIndex in
//                    if rowIndex == 0 {
//                        if columnIndex == 0 {
//                            Text("0,0")
//                        } else if columnIndex == 1 {
//                            Text("Max size=500G")
//                        } else if columnIndex == 2 {
//                            Text("Time elapsed")
//                        }
//                    } else {
//                        if columnIndex == 0 {
//                            Text("Size indic")
//                        } else if columnIndex == 1 {
//                            GaugeView() // Replace with your actual Gauge view
//                        } else if columnIndex == 2 {
//                            ProgressView()
//                        }
//                    }
//                }
//                .frame(height: rowIndex == 0 ? 30 : 170)
//            }
//        }
//        .padding()
//    }
//}

//struct GaugeView: View {
//    var body: some View {
//        // Your custom Gauge view goes here.
//        // Placeholder view for demonstration:
//        Circle()
//            .stroke(lineWidth: 20)
//            .foregroundColor(.blue)
//    }
//}
//
//#Preview {
////    testGrid2View()
//}
