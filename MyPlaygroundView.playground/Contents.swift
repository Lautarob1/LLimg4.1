//: A Cocoa based Playground to present user interface

//import AppKit
//import PlaygroundSupport
import Swift

Path { path in
   path.move(to: CGPoint(x: 20, y: 0))
   path.addLine(to: CGPoint(x: 20, y: 200))
   path.addLine(to: CGPoint(x: 220, y: 200))
   path.addLine(to: CGPoint(x: 220, y: 0))
}

