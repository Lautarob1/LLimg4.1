//
//  FilterSelectView.swift
//  LLIMAGER
//
//  Created by EFI-Admin on 4/27/24.
//

import SwiftUI


class FilterSelection: ObservableObject {
    static let shared = FilterSelection()
    init() {}
    
    @Published var applySpreadsheetFilter = false
    @Published var applyDocumentFilter = false
    @Published var applyMediaFilter = false
    @Published var applyCustomFilter = false
    @Published var applyDateFilter = false
    @Published var isSpreadSheetFilterApplied = false
    @Published var isDocumentFilterApplied = false
    @Published var isMediaFilterApplied  = false
    @Published var isCustomFilterApplied  = false
    @Published var isDateFilterApplied  = false
    @Published var whichDateFilterIsApplied: String = "Modified"
    @Published var profileFilterUsed: String = ""
    
    
    @Published var spreadSheetTypes = [".xls*", ".xlt*", ".numbers", ".csv", ".ods*", ".gnumeric", ".gsheet"]
    @Published var mediaTypes = [".mp3", ".wav", ".mp4", ".mov", ".flv", ".3gp", ".mpeg", ".jpg", ".png", ".gif", ".psd", ".bmp",  ".tga", ".tif*", ".heic", ".jpeg", ".H264", ".av1"]
    @Published var documentTypes = [".doc*", ".dot*", ".pdf", ".ppt*", ".pages", ".rtf", ".txt", ".odp", ".keynote"]
    @Published var customTypes: [String] = []
    var customExtValue: String = ""
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var dateFilterType: String = ""
    @Published var selectedSpreadsheetTypes: [String] = [".xls*", ".xlt*", ".numbers", ".csv", ".ods*", ".gnumeric", ".gsheet"]
    @Published var selectedMediaTypes: [String] = [".mp3", ".wav", ".mp4", ".mov", ".flv", ".3gp", ".mpeg", ".jpg", ".png", ".gif", ".psd", ".bmp",  ".tga", ".tif*", ".heic", ".jpeg", ".H264", ".av1"]
    @Published var selectedDocumentTypes: [String] = [".doc*", ".dot*", ".pdf", ".ppt*", ".pages", ".rtf", ".txt", ".odp", ".keynote"]
    @Published var selectedCustomTypes: [String] = []
    @Published var selectedDateParam: [String] = []
    @Published var selectedAllTypes: [String] = []
    @Published var dateFilterApplied: [String] = []
}


struct FilterSelectView: View {
    @Binding var isFilterSelecVisible: Bool
    @Binding var appliedFilter: Bool
    @Binding var isFilterBeingApplied: Bool

    @StateObject var filterSelection = FilterSelection.shared
    @State private var showSubview = false
    @State private var customInput = ""
    @State private var applySpreadsheetFilter = false
    @State private var applyDocumentFilter = false
    @State private var applyMediaFilter = false
    @State private var applyCustomFilter = false
    
    @State private var isSpreadSheetFilterApplied = false
    @State private var isDocumentFilterApplied = false
    @State private var isMediaFilterApplied  = false
    @State private var isCustomFilterApplied  = false
    
    @State private var customExtValue: String = ""
    @State private var initialDate: Date = Date()
    @State private var finalDate: Date = Date()
    @State private var isProfileApplied: Bool = false
    @State private var profileApplied: String = ""
    let gradient = LinearGradient(gradient: Gradient(colors: [Color("LL_orange"), Color(.gray)]),
                                  startPoint: .top,
                                  endPoint: .bottom)
    @State var isFilterDetailVisible: Bool = false
    @State var showEnterName: Bool = false
    @State var profileName: String = "Enter a valid file name"
    var body: some View {
        VStack {

            HStack  {
                VStack (alignment: .leading) {
                    HStack {
                        VStack (alignment: .leading) {
                            HStack(alignment: .top) {
                                Image("img_but2")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(15)
                                    .padding(.bottom)
                                if isProfileApplied {
                                    VStack {
                                        Text("profile Applied")
                                            .font(.caption)
                                        Text(FilterSelection.shared.profileFilterUsed)
                                    }
                                    .frame(width: 100, height: 50)
                                    
                                }
                                Spacer()  // Pushes the image & text to the left
                            }

                            Text("Filter by Category")
                                .font(.system(size: 14, weight: .bold))
                            if !filterSelection.isSpreadSheetFilterApplied {
                                Toggle("Spreadsheet", isOn: $filterSelection.applySpreadsheetFilter)
                                    .padding(.leading, 5)
                            }
                            else {
                                if #available(macOS 12.0, *) {
                                    Toggle("Spreadsheet Filter Applied", isOn: $filterSelection.isSpreadSheetFilterApplied)
                                        .padding(.leading, 5)
                                        .frame(width: 200, height: 20, alignment: .leading)
                                        .foregroundColor(.white)
                                        .background(Color("LL_orange"))
                                        .cornerRadius(6)
                                    //                                .padding(.leading)
                                } else {
                                    Toggle("Spreadsheet Filter Applied", isOn: $filterSelection.isSpreadSheetFilterApplied)
                                        .padding(.leading, 5)
                                        .frame(width: 200, height: 20, alignment: .leading)
                                        .foregroundColor(.yellow)
                                    //                                .padding(.leading)
                                }
                                
                            }
                            if !filterSelection.isDocumentFilterApplied {
                                Toggle("documents", isOn: $filterSelection.applyDocumentFilter)
                                    .padding(.leading, 5)
                            }
                            else {
                                if #available(macOS 12.0, *) {
                                    Toggle("Document Filter Applied", isOn: $filterSelection.isDocumentFilterApplied)
                                        .padding(.leading, 5)
                                        .frame(width: 200, height: 20, alignment: .leading)
                                        .foregroundColor(.white)
                                        .background(Color("LL_orange"))
                                        .cornerRadius(6)
                                    //                                .padding(.leading)
                                } else {
                                    Toggle("Document Filter Applied", isOn: $filterSelection.isDocumentFilterApplied)
                                        .padding(.leading, 5)
                                        .frame(width: 200, height: 20, alignment: .leading)
                                        .foregroundColor(.yellow)
                                    //                                .padding(.leading)
                                }
                            }
                            if !isFilterBeingApplied {
                                Toggle("Multi-media", isOn: $filterSelection.applyMediaFilter)
                                    .padding(.leading, 5)
                            }
                            else {
                                if #available(macOS 12.0, *) {
                                    Toggle("Media Filter Applied", isOn: $filterSelection.isMediaFilterApplied)
                                        .padding(.leading, 5)
                                        .frame(width: 200, height: 20, alignment: .leading)
                                        .foregroundColor(.white)
                                        .background(Color("LL_orange"))
                                        .cornerRadius(6)
                                } else {
                                    Toggle("Media Filter Applied", isOn: $filterSelection.isMediaFilterApplied)
                                        .padding(.leading, 5)
                                        .frame(width: 200, height: 20, alignment: .leading)
                                        .foregroundColor(.yellow)
                                }
                            }
                        }
                        Spacer()
                            VStack {
                                if filterSelection.applySpreadsheetFilter {
                                    FilterDetailViewSSh(filterSelection: filterSelection, applySpreadsheetFilter: $filterSelection.applySpreadsheetFilter)
                                }
                                if filterSelection.applyDocumentFilter {
                                    FilterDetailViewDoc(filterSelection: filterSelection, applyDocumentFilter: $applyDocumentFilter)
                                }
                                if filterSelection.applyMediaFilter {
                                    FilterDetailViewMed(filterSelection: filterSelection, applyMediaFilter: $filterSelection.applyMediaFilter)
                                }
                            }

                    }
                    HStack {
                        VStack (alignment: .leading) {
                        if !filterSelection.isCustomFilterApplied {
                            Toggle("Custom", isOn: $filterSelection.applyCustomFilter)
                                .padding(.leading, 5)
                        }
                        else {
                            if #available(macOS 12.0, *) {
                                Toggle("Custom Filter Applied", isOn: $filterSelection.isCustomFilterApplied)
                                    .padding(.leading, 5)
                                    .frame(width: 200, height: 20, alignment: .leading)
                                    .foregroundColor(.white)
                                    .background(Color("LL_orange"))
                                    .cornerRadius(6)
                            } else {
                                Toggle("Custom Filter Applied", isOn: $filterSelection.isCustomFilterApplied)
                                    .padding(.leading, 5)
                                    .frame(width: 200, height: 20, alignment: .leading)
                                    .foregroundColor(.yellow)
                                //                                .padding(.leading)
                            }
                        }
                        if filterSelection.applyCustomFilter {
                            VStack {
                                HStack {
                                    TextField("enter custom extension", text: $customExtValue)
                                        .foregroundColor(.black)
                                        .padding(.leading, 5)
                                        .cornerRadius(5)
                                    Button("Add filter") {
                                        print("addded filter \(customExtValue)")
                                        if customExtValue != "" {
                                            filterSelection.selectedCustomTypes.append(customExtValue)
                                        }
                                        customExtValue = ""
                                        // code for add to list of custom extensions
                                    }
                                    Button("Done") {
                                        if filterSelection.selectedCustomTypes.count > 0 {
                                            filterSelection.isCustomFilterApplied = true
                                        }
                                        filterSelection.applyCustomFilter = false
                                        print("filters so far: \(filterSelection.selectedCustomTypes)")
                                        print("Count filters so far: \(filterSelection.selectedCustomTypes.count)")
                                        FilterSelection.shared.selectedCustomTypes = filterSelection.selectedCustomTypes
                                        FilterSelection.shared.selectedAllTypes = filterSelection.selectedAllTypes
                                    }
                                    .padding(.horizontal, 15)
                                }
                                .padding(.top, 7)
                                
                                Text("Add extensions  one by one by clicking add filter and click done when finish")
                                    .font(.caption)
                            }
                            .frame(width: 430)
                            .background(gradient)
                            .cornerRadius(10)
                        }
                        Text("Filter by Date")
                            .font(.system(size: 14, weight: .bold))
                        if !filterSelection.isDateFilterApplied {
                            Toggle("Date Filter", isOn: $filterSelection.applyDateFilter)
                                .padding(.leading, 5)
                        }
                        else {
                            if #available(macOS 12.0, *) {
                                Toggle("Date Filter Applied", isOn: $filterSelection.isDateFilterApplied)
                                    .padding(.leading, 5)
                                    .frame(width: 200, height: 20, alignment: .leading)
                                    .foregroundColor(.white)
                                    .background(Color("LL_orange"))
                                    .cornerRadius(6)
                            } else {
                                Toggle("Date Filter Applied", isOn: $filterSelection.isDateFilterApplied)
                                    .padding(.leading, 5)
                                    .frame(width: 200, height: 20, alignment: .leading)
                                    .foregroundColor(.yellow)
                            }
                        }
                    }
                }
                    .padding(.top, 7)
            }
//                Spacer()
            }
            Spacer()

            if filterSelection.applyDateFilter {
                ScrollView {
                    VStack (alignment: .leading, spacing: nil) {
                        Text("Choose the time filter you want to apply from the MacOS timestamps available:")
                            .font(.caption)
                            .padding(.vertical, 0)
                        FilterOptionView()
                            .padding(.vertical, 0)
                        HStack {
                            DatePicker("Start Date", selection: $initialDate, displayedComponents: .date)
                                .padding(5)
                            Spacer()
                            DatePicker("End Date", selection: $finalDate, displayedComponents: .date)
                                .padding(5)
                            
                        }
                        HStack {
                            Spacer()
                            Button("Cancel filter") {
                                filterSelection.applyDateFilter = false
                            }
                            Spacer()
                            Button("Apply Filter") {
                                if initialDate != finalDate {
                                    filterSelection.isDateFilterApplied = true
                                }
                                filterSelection.applyDateFilter = false
                                FilterSelection.shared.startDate = self.initialDate
                                FilterSelection.shared.endDate = self.finalDate
                                FilterSelection.shared.whichDateFilterIsApplied = filterSelection.whichDateFilterIsApplied
//                                filterSelection.dateFilterApplied = [filterSelection.whichDateFilterIsApplied, String(self.initialDate), String(self.endDate)]
                                
                            }
                            Spacer()
//                            .padding(.bottom, 5)
                        }
                        .padding(.bottom, 5)
                    }
                    .padding(5)
                }
                .frame(width: 425, height: 140)
                .background(gradient)
                .cornerRadius(10)
            }
            HStack {
                HStack {
                Button("Cancel") {
//                    print(" cancel det apply filter \(applySpreadsheetFilter)")
                    print(" cancel det types \(filterSelection.spreadSheetTypes)")
                    self.isFilterSelecVisible = false
                    self.isFilterBeingApplied = false
                    self.appliedFilter = false
                }
                .padding()
                
                
                Button("Submit") {
                    FilterSelection.shared.isSpreadSheetFilterApplied = filterSelection.isSpreadSheetFilterApplied
                    FilterSelection.shared.isDocumentFilterApplied = filterSelection.isDocumentFilterApplied
                    FilterSelection.shared.isMediaFilterApplied = filterSelection.isMediaFilterApplied
                    FilterSelection.shared.isCustomFilterApplied = filterSelection.isCustomFilterApplied
                    FilterSelection.shared.isDateFilterApplied = filterSelection.isDateFilterApplied

                    FilterSelection.shared.customExtValue = self.customExtValue
  
                    filterSelection.selectedAllTypes = filterSelection.selectedSpreadsheetTypes + filterSelection.selectedDocumentTypes +
                        filterSelection.selectedMediaTypes +
                        filterSelection.selectedCustomTypes
                    FilterSelection.shared.selectedAllTypes = filterSelection.selectedAllTypes
                    
                    self.isFilterSelecVisible = false
                    self.isFilterBeingApplied = true
                    print("Submit FilterSelectedSh \(filterSelection.spreadSheetTypes)")
                    print("Submit FilterCustom \(filterSelection.customTypes)")
                    print("Submit FilterSelectedSh.shared \(FilterSelection.shared.spreadSheetTypes)")
                    print("SubmitFilterCustom.shared \(FilterSelection.shared.customTypes)")
                    print("FilterSelection.shared.startDate \(FilterSelection.shared.startDate)")
                    print("FilterSelection.shared.endDate \(FilterSelection.shared.endDate)")
                    print("FilterSelection.share which F \(FilterSelection.shared.whichDateFilterIsApplied)")
                    
                }
                .padding()
                }
                Spacer()
                ZStack {
                    HStack {
                        Button("Load Profile") {
                            processSelectedJsonFile()
                            isProfileApplied = true
                            if FilterSelection.shared.profileFilterUsed != "invalid" {
                                if FilterSelection.shared.selectedSpreadsheetTypes.count > 0 {
                                filterSelection.selectedSpreadsheetTypes = FilterSelection.shared.selectedSpreadsheetTypes
                                filterSelection.applySpreadsheetFilter = false
                                filterSelection.isSpreadSheetFilterApplied = true
                                FilterSelection.shared.isSpreadSheetFilterApplied = true
                            }
                            if FilterSelection.shared.selectedDocumentTypes.count > 0 {
                                filterSelection.selectedDocumentTypes = FilterSelection.shared.selectedDocumentTypes
                                filterSelection.applyDocumentFilter = false
                                filterSelection.isDocumentFilterApplied = true
                                FilterSelection.shared.isDocumentFilterApplied = true
                            }
                            if FilterSelection.shared.selectedMediaTypes.count > 0 {
                                filterSelection.selectedMediaTypes = FilterSelection.shared.selectedMediaTypes
                                filterSelection.applyMediaFilter = false
                                filterSelection.isMediaFilterApplied = true
                                FilterSelection.shared.isMediaFilterApplied = true
                            }
                            if FilterSelection.shared.selectedCustomTypes.count > 0 {
                                filterSelection.applyCustomFilter = false
                                filterSelection.isCustomFilterApplied = true
                                FilterSelection.shared.isCustomFilterApplied = true
                            }
                            if FilterSelection.shared.selectedDateParam.count > 0 {
                                filterSelection.whichDateFilterIsApplied = filterSelection.whichDateFilterIsApplied
                                let dateFilterType = FilterSelection.shared.selectedDateParam[0]
                                filterSelection.whichDateFilterIsApplied = dateFilterType
                                FilterSelection.shared.whichDateFilterIsApplied = dateFilterType
                                let dateI = FilterSelection.shared.selectedDateParam[1]
                                initialDate = dateString2Date (dateStr: dateI)
                                let dateF = FilterSelection.shared.selectedDateParam[2]
                                finalDate = dateString2Date (dateStr: dateF)
                                FilterSelection.shared.startDate = initialDate
                                FilterSelection.shared.endDate = finalDate
                                filterSelection.applyDateFilter = false
                                filterSelection.isDateFilterApplied = true
                                FilterSelection.shared.isDateFilterApplied = true
                            }
                        }
                            else {
                                FilterSelection.shared.profileFilterUsed += " JSON"
                            }
                        
                    }
                    .font(.footnote)
                    .padding()
                    
                    
                    Button("Save Profile") {
                        print("button Save Profile pressed")
                        showEnterName = true
                        
                        createJsonFilter(spreadSh: FilterSelection.shared.selectedSpreadsheetTypes,
                                         docs: FilterSelection.shared.selectedDocumentTypes,
                                         media: FilterSelection.shared.selectedMediaTypes,
                                         custom: FilterSelection.shared.selectedCustomTypes,
                                         date: FilterSelection.shared.selectedDateParam,
                                         fileName: profileName
                                            )
     
                    }
                    .padding()
                    .font(.footnote)
                    }
                    if showEnterName {
                        FilterNameEnterView(showAlert: $showEnterName, name: $profileName)
                    }
                }
                
            }
    }
        .frame(width: 430, height: 470)
        .padding()
        .background(Color("LL_blue"))
        .foregroundColor(.white)
        .cornerRadius(15)
        
        .onAppear {
            // Reset isVisible when the view appears
            self.isFilterSelecVisible = true
        }
    }

}
    
    

#Preview {
    FilterSelectView(isFilterSelecVisible: .constant(true), appliedFilter: .constant(true), isFilterBeingApplied: .constant(false))
}


// usable code snips

//print("in FSV OK filterSelec Spread \(filterSelection.selectedSpreadsheetTypes)")
//print("in FSV OK filterSelecShared Spread \(FilterSelection.shared.selectedSpreadsheetTypes)")
//print("in FSV OK filterSelec all \(filterSelection.selectedAllTypes)")
//print("in FSV OK filterSelecShared all \(FilterSelection.shared.selectedAllTypes)")
