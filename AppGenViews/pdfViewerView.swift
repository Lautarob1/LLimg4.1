//
//  pdfViewerView.swift
//  LLimg_4
//
//  Created by EFI-Admin on 3/7/24.
//

import SwiftUI
import PDFKit

struct PDFViewer: NSViewRepresentable {
    var url: URL
    @Binding var searchText: String

    func makeNSView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: url)
        return pdfView
    }

    func updateNSView(_ nsView: PDFView, context: Context) {
        // Update the view if needed.
    }
    func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
    class Coordinator: NSObject, PDFDocumentDelegate {
        var parent: PDFViewer

        init(_ parent: PDFViewer) {
            self.parent = parent
        }
    }
}

struct pdfViewerView: View {
//    private let pdfURL = Bundle.main.url(forResource: "/Volumes/llimager/llimager-manual.pdf", withExtension: "pdf")!
//    let pdfURL = URL(fileURLWithPath: "/Volumes/llimager/llimager-manual.pdf")
    let pdfURL: URL
    @State private var searchText = ""
    
    var body: some View {
        VStack {
//            TextField("Search", text: $searchText)
//            .textFieldStyle(RoundedBorderTextFieldStyle())
//            .padding()
            PDFViewer(url: pdfURL, searchText: $searchText)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }

    }
}

#Preview {
//    let pdfURL = URL(fileURLWithPath: "/Volumes/llimager/llimager-manual.pdf") (thrown an error!)
    pdfViewerView(pdfURL: URL(fileURLWithPath: "/Volumes/llimager/llimager-manual.pdf"))
}
