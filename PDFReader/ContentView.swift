//
//  ContentView.swift
//  PDFReader
//
//  Created by Roman Vasyliev on 18/08/2023.
//

import SwiftUI
import PDFKit

struct PDFKitView: UIViewRepresentable {
    let pdfDocument: PDFDocument
    @Binding var selectedPage: Int
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = pdfDocument
        pdfView.autoresizesSubviews = true
        pdfView.minScaleFactor = pdfView.scaleFactorForSizeToFit
        pdfView.maxScaleFactor = 4.0
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleTopMargin, .flexibleLeftMargin]
        pdfView.displayDirection = .horizontal
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displaysPageBreaks = true
        pdfView.usePageViewController(true, withViewOptions: [:])
        
        // ... (rest of code for thumbnailView)
        
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        pdfView.document = pdfDocument
        
        if (1...pdfDocument.pageCount).contains(selectedPage) {
            if let page = pdfDocument.page(at: selectedPage - 1) {
                pdfView.go(to: PDFDestination(page: page, at: CGPoint(x: 0, y: page.bounds(for: .cropBox).maxY)))
            }
        }
    }
}

struct PDFKitViewWithPageSelection: View {
    @State private var selectedPage: Int = 1
    let pdfDocument: PDFDocument
    
    var body: some View {
        VStack {
            PDFKitView(pdfDocument: pdfDocument, selectedPage: $selectedPage)
                .frame(maxHeight: .infinity)
            
            HStack {
                Text("GoTo page:")
                TextField("Page", value: $selectedPage, formatter: NumberFormatter())
                    .frame(width: 50)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(" Go ", action: {
                    // selectedPage will change due to the Binding, causing the PDFKitView to update
                })
            }
            .padding()
        }
    }
}

struct ContentView: View {
    var body: some View {
        if let url = Bundle.main.url(forResource: "sample", withExtension: "pdf"),
           let pdfDocument = PDFDocument(url: url) {
            PDFKitViewWithPageSelection(pdfDocument: pdfDocument)
        } else {
            Text("Failed to load PDF")
        }
    }
}
