//
//  ToggleStyles.swift
//  LLIMAGER
//
//  Created by EFI-Admin on 5/6/24.
//

import Foundation
import SwiftUI

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
                .foregroundColor(.primary)
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 2)
                    .fill(configuration.isOn ? Color.black : Color.gray) // Change black to any color you want
                    .frame(width: 20, height: 20) // Adjust size as needed
                RoundedRectangle(cornerRadius: 3)
                    .stroke(Color.primary, lineWidth: 2)
                    .frame(width: 20, height: 20) // Adjust size as needed
                if configuration.isOn {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                }
            }
            .onTapGesture { configuration.isOn.toggle() }
        }
        .padding()
    }
}

struct CustomToggleStyle2: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(configuration.isOn ? Color.black : Color.gray) // Change black to any color you want
                    .frame(width: 17, height: 17) // Adjust size as needed
                if configuration.isOn {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(Font.body.weight(.bold)) // Make the checkmark bolder
                }
            }
            .onTapGesture { configuration.isOn.toggle() }
            
            configuration.label
                .foregroundColor(.primary)
                .padding(.leading, 4) // Add some leading padding to separate the text from the checkmark
                .frame(maxWidth: .infinity, alignment: .leading) // Align the text to the leading edge
        }
//        .padding()
    }
}

struct CustomToggleStyle3: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 8) { // Reduce spacing between elements
            Button(action: {
                configuration.isOn.toggle()
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(configuration.isOn ? Color.black : Color.gray) // Change black to any color you want
                        .frame(width: 30, height: 30) // Adjust size as needed
                    Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20) // Adjust size of checkmark
                }
            }
            
            configuration.label
                .foregroundColor(.primary)
        }
        .padding(.vertical, 8) // Add vertical padding
        .padding(.horizontal, 12) // Add horizontal padding
    }
}

struct CustomToggleStyle4: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(configuration.isOn ? Color.black : Color.gray)
                    .frame(width: 17, height: 17) // Adjust size to closely match the default toggle
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 17, height: 17) // Adjust size of the checkmark to closely match the default
                    .foregroundColor(.white)
            }
            .onTapGesture { configuration.isOn.toggle() }
            .padding(.trailing, 5) // Add some trailing padding to separate the toggle elements
            
            configuration.label
                .foregroundColor(.primary)
        }
        .padding(.vertical, 6) // Add vertical padding
        .padding(.horizontal, 10) // Add horizontal padding
    }
}

