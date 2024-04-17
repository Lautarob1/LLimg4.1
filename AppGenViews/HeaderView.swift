//
//  HeaderView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/26/23.
//

import SwiftUI

struct HeaderView: View {
    @State private var searchText = ""
    @State private var showAbout: Bool = false
    @State private var isHoverAbout: Bool = false
    @State private var isHoverHelp: Bool = false
    

    var body: some View {
        VStack {
//            Spacer()
        ZStack {
            Image("LLimager_Window2") // header_w120
                .resizable()
                .frame(minHeight: 100)
                .scaledToFit()
            
            // Alignment of the text
            
            HStack {
                Spacer()
                Text("Version 4.0")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(width: 300, alignment: .leading)
                //            Spacer()
                HStack {
                    ZStack {
                        Button(action: {showAbout = true}) {
                            Image(systemName: "person.fill.questionmark")
                                .imageScale(.large)
                                .foregroundColor(Color("LL_blue"))
                                .font(.title)
                                .background(Color("LL_orange"))
                        }
                        .buttonStyle(PlainButtonStyle())
                        .background(Color("LL_orange"))
                        .onHover(perform: { hovering in
                            isHoverAbout = hovering
                        })
                        .sheet(isPresented: $showAbout) {
                            AboutView(onOK: {showAbout = false })
                        }
                        if isHoverAbout {
                            Text("About")
                                .foregroundColor(.white)
                                .padding(5)
                                .background(Color.black.opacity(0.5))
                                .transition(.opacity)
                                .animation(.easeInOut, value: isHoverAbout)
                        }
                    }
                    Spacer().frame(width: 30)
                    ZStack {
                        Button(action: showPDF) {
                            Image(systemName: "book.pages.fill")
                                .imageScale(.large)
                                .foregroundColor(Color("LL_blue"))
                                .font(.title)
                                .background(Color("LL_orange"))
                            
                        }
                        .buttonStyle(PlainButtonStyle())
                        .background(Color("LL_orange"))
                        .onHover(perform: { hovering in
                            isHoverHelp = hovering
                        })
                        if isHoverHelp {
                            Text("Help")
                                .foregroundColor(.white)
                                .padding(5)
                                .background(Color.black.opacity(0.5))
                                .transition(.opacity)
                                .animation(.easeInOut, value: isHoverHelp)
                        }
                        
                    }
                    Spacer().frame(width: 30)
                }
                
                
            }
        }
        .padding(.vertical, 0)
        .frame(minWidth: 900)
    }
//        Spacer()
    }
    
    func showPDF() {
        let pdfPath = "/Volumes/llimager/llimager/llimager-manual.pdf"
        let pdfUrl = URL(fileURLWithPath: pdfPath)
            openPDFInNewWindow(url: pdfUrl)
  
    }
    
//    func showAbout() {
//        let pdfPath = "/Volumes/llimager/AboutUS_draft_2BRevised.pdf"
//        let pdfUrl = URL(fileURLWithPath: pdfPath)
//            openPDFInNewWindow(url: pdfUrl)
//    }
    
    func openPDFInNewWindow(url: URL) {
        let pdfViewer = pdfViewerView(pdfURL: url)
        let hostingView = NSHostingView(rootView: pdfViewer)
        
        let window = NSWindow(
            contentRect: NSRect(x: 25, y: 25, width: 600, height: 600),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.center()
        window.setFrameAutosaveName("PDF Viewer")
        window.contentView =  NSHostingView(rootView: pdfViewer)
        window.makeKeyAndOrderFront(nil)
    }
}

#Preview {
    HeaderView()
}
