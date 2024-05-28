//
//  TestJsonView.swift
//  LLIMAGER
//
//  Created by EFI-Admin on 5/7/24.
//
import Foundation
import SwiftUI

struct FileCategory: Codable {
    var cat: String
    var data: [String]
}

func saveDataToJSON(categories: [FileCategory], fileName: String, at path: URL) {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    do {
        let jsonData = try encoder.encode(categories)
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString) // For debugging, to see the JSON string
            let fileURL = path.appendingPathComponent(fileName)
            try jsonData.write(to: fileURL, options: .atomic)
            print("Saved to \(fileURL)")
        }
    } catch {
        print("Error: \(error)")
    }
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

func readJSONFromFile(at url: URL) {
    print("in Json read 1 url...\(url)")
    do {
        let jsonData = try Data(contentsOf: url)
        print("in Json1 jsonData: \(jsonData)")
        let decoder = JSONDecoder()
        let categories = try decoder.decode([FileCategory].self, from: jsonData)
        print("categories in read1 \(categories)")
        createArrays(from: categories)
    } catch {
        print("Failed to read or decode JSON: \(error)")
    }
}

func readJSONFromFile3 (at url: URL) -> [FileCategory]{
    print("in Json read 3 url...\(url)")
    do {
        let jsonData = try Data(contentsOf: url)
        print("in Json3 jsonData: \(jsonData)")
        let decoder = JSONDecoder()
        let categories = try decoder.decode([FileCategory].self, from: jsonData)
        print("categories in read3 \(categories)")
        createArrays(from: categories)
        return categories
    } catch {
        print("Failed to read or decode JSON3: \(error)")
    }
    return []
}

func createArrays(from categories: [FileCategory]) {
    for category in categories {
        switch category.cat {
        case "Spreadsheets":
            let spreadsheetsArray = category.data
            print("Spreadsheets: \(spreadsheetsArray)")
        case "Documents":
            let documentsArray = category.data
            print("Documents: \(documentsArray)")
        case "Media":
            let mediaArray = category.data
            print("Media: \(mediaArray)")
        default:
            print("Unknown category: \(category.cat)")
        }
    }
}

func readJSONFromFile2(at url: URL) -> [String: [String]]? {
    print("in Json read 2 url...\(url)")
    do {
        let jsonData = try Data(contentsOf: url)
        print("in Json2 jsonData: \(jsonData.count) bytes")
        let decoder = JSONDecoder()
        let categories = try decoder.decode([FileCategory].self, from: jsonData)
        var categoryDictionary: [String: [String]] = [:]
        for category in categories {
            categoryDictionary[category.cat] = category.data
        }
        return categoryDictionary
    } catch {
        print("Error reading file: \((error as NSError).localizedDescription)")
        print("Detailed error: \((error as NSError).userInfo)")
        return nil
    }
}

func createDictionary(from categories: [FileCategory]) -> [String: [String]] {
    var categoryDictionary: [String: [String]] = [:]
    for category in categories {
        categoryDictionary[category.cat] = category.data
    }
    return categoryDictionary
}

struct TestJsonView: View {

    
    var body: some View {
        VStack {
            Text("Click to create json file")
            Button(action: {
                let spreadsheets = FileCategory(cat: "Spreadsheets", data: [".xls*", ".xlt*", ".numbers"])
                let documents = FileCategory(cat: "Documents", data: [".doc*", ".pdf"])
                let media = FileCategory(cat: "Media", data: [".mp3", ".wav", ".mp4", ".mov", ".flv", ".3gp", ".mpeg", ".jpg", ".png"])

//                print("in create Json Docs: \(documents)")
                
//                getDocumentsDirectory()
                let savePath = URL(fileURLWithPath: "/Volumes/llimager/llimager")
                
                let fileName = "testFilter1.json"

                saveDataToJSON(categories: [spreadsheets, documents, media], fileName: fileName, at: savePath)
            }) {
                Text("Create Json")
            }
            Button ("read Json") {
                if let fileURL = URL(string:
                    "/Volumes/llimager/llimager/customFileTypes.json") {
                    if let categoryData = readJSONFromFile2(at: fileURL) {
                        print(" cat data Button after read 2 \(categoryData)")
                        if let spreadsheets =  categoryData["Spreadsheets"] {
                            print("Spreadsheets: \(spreadsheets)")
                            // Use `spreadsheets` array here
                        }
                        if let documents = categoryData["Documents"] {
                            print("Documents: \(documents)")
                            // Use `documents` array here
                        }
                        if let media = categoryData["Media"] {
                            print("Media: \(media)")
                            // Use `media` array here
                        }
                    } else {
                        print("cat data (error) \(String(describing: readJSONFromFile2(at: fileURL)))")
                        print("Failed to load or parse the file.")
                    }
                } else {
                    print("Invalid file URL.")
                }
            }
            Button("read Json V2") {
                if let fileURL = URL(string:
                "/Users/efi-admin/Desktop/JsonSample.json ") {
                    print("fileURL valid")
                    readJSONFromFile(at: fileURL)
                    }
                }
            Button("TestDateToStr") {
              let date = Date()
            print(date2dateString2(date: date))
                    }

            }
        .frame(width: 300, height: 200)
        }
    }

func date2dateString2(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"  // Set the date format to "yyyy-MM-dd"
    print("date in date2Str: \(date)")
    let dateString = dateFormatter.string(from: date)
    return dateString
}

#Preview {
    TestJsonView()
}
