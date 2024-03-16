//
//  TestGradientView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 2/2/24.
//

import SwiftUI

struct TestGradientView: View {
    var body: some View {
        VStack {
            let radialGradient = RadialGradient(gradient: Gradient(colors: [Color.red, Color.blue]),
                                center: .center,
                                startRadius: 20,
                                endRadius: 100)
            Text("hola")
                .frame(width: 200, height: 200)
                .background(radialGradient)
                .cornerRadius(20)
            
            let gradient = LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]),
                              startPoint: .top,
                              endPoint: .bottom)
            Text("Gradient")
                .frame(width: 200, height: 200)
                .background(gradient)
                .cornerRadius(20)
            let angularGradient = AngularGradient(gradient: Gradient(colors: [Color.red, Color.blue]),
                              center: .center)
            Text("Angular")
                .frame(width: 200, height: 200)
                .background(angularGradient)
                .cornerRadius(20)
        }
    }
}

#Preview {
    TestGradientView()
}
