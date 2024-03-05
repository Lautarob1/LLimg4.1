//
//  Imaging1View.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/28/23.
//

import SwiftUI



struct Imaging4ProcView: View {
    @ObservedObject var authModel = AuthenticationViewModel()
    @ObservedObject var sviewModel = ConsoleViewModel()
    @ObservedObject var diskDataManager = DiskDataManager()
    @ObservedObject var timer = ElapsedTimeTimer()
    @ObservedObject var hviewModel = HashingViewModel()
    @StateObject private var timerHash = TimerHash()
    @State private var caseName: String = ""
    @State private var evidenceName: String = ""
    @State private var agentName: String = ""
    @State private var caseID: String = ""
    @State private var caseNotes: String = ""
    @State private var imageName: String = ""
    @State private var isliveimgChecked: Bool = false
    @State private var isViewPresented = false
    @State private var isChecked: Bool = false
    @State private var outputTerm: String = ""
    @State private var sparseTimeIni: String = ""
    @State private var sparseTimeEnd: String = ""
    @State private var dmgTimeIni: String = ""
    @State private var dmgTimeEnd: String = ""
    @State private var sparseSize: String = ""
    @State private var dmgSize: String = ""
    @State private var logicImgSize: [String] = ["", "", ""]
    @State private var animateArrow = false
    @State private var showControls = true
    @State private var showProc = false
    @State private var showdmgvalues = false
    @State private var showDoneButton = false
    @State private var filesCopied: Int = 0
    @State private var filesNotCopied: Int = 0
    @State private var stepIndex: Int = 0
    @State private var fileUpdCounter: Int = 0
    @State private var anyprocIsRunning: Bool = false
//    @State private var issparseMounted = false
    @State private var logfilePath: String = ""
    @State private var logfilePathEx: String = ""
    let gradient = LinearGradient(gradient: Gradient(colors: [Color("LL_orange"), Color.gray]),
                      startPoint: .top,
                      endPoint: .bottom)
    @State var titleImgSize: String = "Image Size"
    @State var titleGauge: String = "Disk Size"
    @State var elapTime: [String] = ["Elapsed Time0", "Elapsed Time1", "Elapsed Time2"]
    @State var imageSize: String = "Image Size in GB"
    @State var strokeWidth: CGFloat = 20
    @State var minValue: CGFloat = 0.0
    @State var maxValue: CGFloat = 0.7
    @State var currentValue: CGFloat = 0.6
    @State var percentage: CGFloat = 0.6
    let procStep = ["Hashing Files...", "Processing Fineshed"]
//    @StateObject private var fileSelectionManager = FileSelectionManager()
    let timerGauge = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State var timerGauge2: Timer?

    var onComplete: () -> Void
    
    var body: some View {
        
        HStack(alignment: .top) {
            Image("img_but4")
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 90)
                .cornerRadius(15)
                .padding(.leading)
            //                    Spacer()  // Pushes the image to the left
            Text("Hashing process")
                .font(.title2)
                .padding()
                .foregroundColor(Color("LL_blue"))
            Spacer()
        }
        
        Spacer()
        HStack{
            
            VStack {
                if showControls {
                    HStack(spacing: 10) {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(Color("LL_orange"))
                            .offset(x: animateArrow ? 20 : 0)
                            .animation(Animation.linear(duration: 1).repeatForever(autoreverses: true), value: animateArrow)
                        Button (action: {
                            print("process starts")
                            showControls = false
                            
                            logfilePath = DiskDataManager.shared.selectedStorageOption + "/\(CaseInfoData.shared.imageName).info"
  
                            acqlogHeader(filePath: logfilePath)
                            targetedImagefullProcess()
                            print("after fullprocess--- END")
                        }) {
                            Text("Click to start Hashing process")
                                .font(.custom("Helvetica Neue", size: 16))
                                .frame(width: 160, height: 25)
                                .padding(3)
                                .foregroundColor(.white)
                                .background(Color(("LL_orange")))
                                .cornerRadius(10)
                                
                        }
                    }
                    
                    .onAppear {
                        animateArrow = true
                    }
                    
                }
                ScrollView {
                    TextEditor(text: $sviewModel.output)
                    //                    Text(sviewModel.output)
                        .font(.system(size: 11, weight: .bold, design: .default)) // Set font size, weight, and design
//                        .italic() // Make the text italic
                        .foregroundColor(.blue) // Set the text color
                        .frame(width: 840, height: 160, alignment: .leading)
                        .padding(5)
                        .background(Color("LL_blue")) // .opacity(0.5) Set the background color
                        .cornerRadius(10)
                    
                }
                .frame(width: 860, height: 170)
                .padding(5)
                
                HStack {
                    
                }
                if showProc {
                VStack (spacing: 0) {
                    HStack {
                        VStack {
                            Text(procStep[stepIndex])
                        }
                        .font(.title)
                        .foregroundColor(.white) // Set text color to white
                        .frame(maxWidth: 840, alignment: .leading) // Align text to the left
                        .padding(5) // Add padding around the text
                        .background(Color("LL_blue")) // Set background color to blue
                        .cornerRadius(5) // Optional: for rounded corners
                    }
                    .padding()
                    HStack(spacing: 0) {
                        // Set spacing to 0 if you don't want any space between the VStacks
                        VStack {
                            // Content of the second VStack
                            Text(titleImgSize)
                                .font(.system(size: 18, weight: .medium, design: .default))
                                .foregroundColor(.white)
                        }
                            .frame(width: 250, height: 30)
                            .padding(.horizontal)
                            .background(Color("LL_orange"))
                        
                        VStack {
                            // Content of the second VStack
                            Text(titleGauge)
                                .font(.system(size: 18, weight: .medium, design: .default))
                                .foregroundColor(.white)
                        }
                        .frame(width: 250, height: 30)
                        .padding(.horizontal)
                        .background(Color("LL_orange")) // Background color for visualization
                        
                        VStack {
                            // Content of the third VStack
                            Text("Time Elapsed: \(timerHash.timeElapsedFormatted)")
                                .font(.system(size: 14, weight: .medium, design: .default)) // Customize the font here
                                .frame(width: 220, height: 25)
                                .padding(0) // Add padding around the text
                                .background(Color("LL_blue")) // Set the background color
                                .foregroundColor(.white) // Set the text color
                                .cornerRadius(8)
                        }
                        .frame(width: 250, height: 30)
                        .padding(.horizontal)
                        .background(Color("LL_orange")) // Background color for visualization
                    }
                    //                    .frame(width: 750)
                    //                    .padding(0)
                    // Setting the total width of the
                    
                    HStack(spacing: 0) { // Set spacing to 0 if you don't want any space between the VStacks
                        VStack {
                            // Content of the first VStack
                            Text("\(hviewModel.hashProgressByt, specifier: "%.0f") Bytes")
                                .font(.system(size: 24, weight: .medium, design: .default)) // Customize the font here
                                .frame(minWidth: 130, minHeight: 40)
                                .padding(2) // Add padding around the text
                                .background(Color("LL_blue")) // Set the background color
                                .foregroundColor(.white) // Set the text color
                                .cornerRadius(8)
                        }
                        .frame(width: 250, height: 125)
                        .padding()
                        .background(gradient) // Background color for visualization
                        
                        VStack {
                 
                            ZStack {

                                Spacer()
                                Circle()
                                    .stroke(lineWidth: 20.0)
//                                    .opacity(0.)
                                    .foregroundColor(Color("LL_blue"))
                                    .frame(width: 150, height: 80)

                                Circle()
                                    .trim(from: 0.0, to: hviewModel.hashProgressPct)
                                    .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                                    .foregroundColor(.white)
                                    .frame(width: 150, height: 80)
                                    .rotationEffect(Angle(degrees: 270.0))

                                Text(String(format: "%00.0f%%", 100 * hviewModel.hashProgressPct))
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }

                        }
                        .frame(width: 250, height: 125)
                        .padding()
                        .background(gradient)
                        
                        VStack {
                            if anyprocIsRunning {
                                // Content of the third VStack
                                CustomProgressView(scale: 2, color: .blue, backgroundColor: .clear, currrentValue: hviewModel.hashProgressByt)
                            } else {
                                Text("All Completed!")
                                    .font(.system(size: 24, weight: .medium, design: .default))
                                    .foregroundColor(.white)
                            }
                        }
                            .frame(width: 250, height: 125)
                            .padding()
                            .background(gradient)
                        
                    }
                    
                }
            }

                if showDoneButton {
                    Button(action: {
                        onComplete()
                    }) {
                        Text("Done")
                            .font(.custom("Helvetica Neue", size: 14))
                            .frame(width: 100, height: 25)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(3)
                    }
                    Spacer()
                }
            }
            .frame(width: 900, height: 520)
            .cornerRadius(15)
            .padding(5)
                
        }
        
        
    }
    
    func targetedImagefullProcess () {
        showProc = true
        anyprocIsRunning = true
        titleImgSize = "Size Collection"
        titleGauge = "% Completed"
        timerHash.start()
        hashcalculations()
        print("Process hash calcs done....")
        anyprocIsRunning = false
        showDoneButton = true
        stepIndex = 1
    }
    
    //  aux functions used


    func hashcalculations() {
        
        print("inside hashcalculations...")

        if DiskDataManager.shared.selectedHashOption != "NO-HASH" {stepIndex = 1 }
        let fullFilePaths = FileSelectionManager.shared.selectedFiles
        logfilePath = DiskDataManager.shared.selectedStorageOption + "/\(CaseInfoData.shared.imageName).info"
            
        let whichHash = DiskDataManager.shared.selectedHashOption
        for file in FileSelectionManager.shared.selectedFiles {
            let hashTimeIni = LLTimeManager.getCurrentTimeString()
            switch whichHash {
            case "SHA256":
                print("switch case 256")
                var hash256 = ""
                DispatchQueue.global(qos: .background).async {
                    hash256 =
                    hashLargeFileSHA256 (filePath: file.path, viewModel: hviewModel)
                    DispatchQueue.main.async {
                        self.timerHash.stop()
                    }
                }
                let hashTimeEnd = LLTimeManager.getCurrentTimeString()
                print2Log(filePath: logfilePath, text2p: "Hashing file:     \(file.path)")
                print2Log(filePath: logfilePath, text2p: "\(String(repeating: "-", count: 88)))\n")
                print2Log(filePath: logfilePath, text2p: "Start time:       \(hashTimeEnd)")
                print2Log(filePath: logfilePath, text2p: "End time:         \(hashTimeEnd)")
                print2Log(filePath: logfilePath, text2p: "SHA256 hash:      \(String(describing: hash256)) \n")
                print2Log(filePath: logfilePath, text2p: "\(String(repeating: "-", count: 88)))\n")
                
                
            case "SHA1":
                let hashsha1 =
                hashLargeFileSHA1(filePath: file.path)
                let hashTimeEnd = LLTimeManager.getCurrentTimeString()
                print2Log(filePath: logfilePath, text2p: "Hashing file:     \(file.path)")
                print2Log(filePath: logfilePath, text2p: "\(String(repeating: "-", count: 88)))\n")
                print2Log(filePath: logfilePath, text2p: "Start time:       \(hashTimeEnd)")
                print2Log(filePath: logfilePath, text2p: "End time:         \(hashTimeEnd)")
                print2Log(filePath: logfilePath, text2p: "SHA256 hash:      \(String(describing: hashsha1)) \n")
                print2Log(filePath: logfilePath, text2p: "\(String(repeating: "-", count: 88)))\n")
                
            case "MD5":
                let hashMD5 =
                hashLargeFileMD5(filePath: file.path)
                let hashTimeEnd = LLTimeManager.getCurrentTimeString()
                print2Log(filePath: logfilePath, text2p: "Hashing file:     \(file.path)")
                print2Log(filePath: logfilePath, text2p: "\(String(repeating: "-", count: 88)))\n")
                print2Log(filePath: logfilePath, text2p: "Start time:       \(hashTimeEnd)")
                print2Log(filePath: logfilePath, text2p: "End time:         \(hashTimeEnd)")
                print2Log(filePath: logfilePath, text2p: "MD5 hash value: \(String(describing: hashMD5)) \n")
                print2Log(filePath: logfilePath, text2p: "\(String(repeating: "-", count: 88)))\n")
                
            case "NO-HASH":
                processNoHash()
            default:
                print("Invalid selection")
            }
            
        }
        timer.stopTimer()
            
        }

    
    func processNoHash() {
        let logfilePath = DiskDataManager.shared.selectedStorageOption + "/\(CaseInfoData.shared.imageName).info"
        print2Log(filePath: logfilePath, text2p: "No hash calculation selected")
    }
    

     
}


#Preview {
 
        Imaging4ProcView(onComplete: {
            // Dummy closure for preview
        })

}
