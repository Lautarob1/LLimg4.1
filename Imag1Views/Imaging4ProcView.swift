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
    @ObservedObject var hashViewModel = HashingViewModel2()
    @ObservedObject var timerHash = TimerHash()
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
    @State private var logfilePath: String = ""
    @State private var logfilePathEx: String = ""
    let gradient = LinearGradient(gradient: Gradient(colors: [Color("LL_orange"), Color.gray]),
                      startPoint: .top,
                      endPoint: .bottom)
    let gradt2 = LinearGradient(gradient: Gradient(colors: [Color("LL_blue"), Color.black.opacity(0.6)]),
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
    let procStep = ["Hashing Files...", "Processing Finished"]
    @State var alertMsg: String = ""
    @State var alertTitle: String = ""
    @State var showCustomAlert: Bool = false
    @State var messageBelowTimer: String = ""
    @State var sparseGB: Double = 0.0
    @Binding var selectedOption: MenuOption?
    
    var body: some View {
        
        HStack(alignment: .top) {
            Image("img_but4")
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 90)
                .cornerRadius(15)
                .padding(.leading)
            //                    Spacer()  // Pushes the image to the left
            Text("Hash process")
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
                            hashViewModel.showProc = true
//                            showProc = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            hashingfullProcess()
                            }
                            print("after fullprocess--- END")
                        }) {
                            Text("Click to start process")
                                .font(.custom("Helvetica Neue", size: 16))
                                .frame(width: 160, height: 25)
                                .padding(3)
                                .foregroundColor(.white)
                                .background(Color(("LL_orange")))
                                .cornerRadius(10)
                                .buttonStyle(PlainButtonStyle())
                                
                        }
                    }
                    
                    .onAppear {
                        animateArrow = true
                    }
                    
                }
                ScrollView {
//                    TextEditor(text: $sviewModel.output)
                    Text(sviewModel.output)
                        .font(.system(size: 11, weight: .bold, design: .default)) // Set font size, weight, and design
//                        .italic() // Make the text italic
                        .foregroundColor(.white) // Set the text color
                        .frame(width: 840, height: 200, alignment: .leading)
                        .padding(5)
                        .background(gradt2) // "LL_blue")) // .opacity(0.5) Set the background color
                        .cornerRadius(10)
                    
                }
                .frame(width: 860, height: 200)
                .padding(5)
                
                HStack {
                    
                }
                if hashViewModel.showProc {
                VStack (spacing: 0) {
                    HStack {
                        VStack {
                            Text(procStep[hashViewModel.stepIndex])
                        }
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(maxWidth: 840, alignment: .leading)
                        .padding(5)
                        .background(Color("LL_blue"))
                        .cornerRadius(5)
                    }
                    .padding()
                    HStack(spacing: 0) {
                        VStack {
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
                        .background(Color("LL_orange"))
                        
                        VStack {
                            // Content of the third VStack
                            Text("Time Elapsed: \(hashViewModel.elapsedTime)")
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
                            Text("\(hashViewModel.hashProgressByt, specifier: "%.0f") Bytes")
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
                                    .trim(from: 0.0, to: hashViewModel.hashProgressPct)
                                    .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                                    .foregroundColor(.white)
                                    .frame(width: 150, height: 80)
                                    .rotationEffect(Angle(degrees: 270.0))

                                Text(String(format: "%00.0f%%", 100 * hashViewModel.hashProgressPct))
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }

                        }
                        .frame(width: 250, height: 125)
                        .padding()
                        .background(gradient)
                        
                        VStack {
                            if hashViewModel.anyprocIsRunning {
                                // Content of the third VStack
                                CustomProgressView(scale: 2, color: .blue, backgroundColor: .clear, currrentValue: hashViewModel.hashProgressByt)
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
                .overlay (
                    Group {if showCustomAlert {
                        CustomAlertView(
                            showAlert: $showCustomAlert,
                            imageName: imageName,
                            title: alertTitle,
                            message: alertMsg,
                            fontSize1: 16,
                            fontSize2: 12,
                            textColor: Color(.white),
                            backgroundColor: Color("LL_blue")
                        )
                        .offset(y: -100.0)
                    }
                    }
                )
            }

                if hashViewModel.showDoneButton {
                    Button(action: {
                        self.selectedOption = nil
                    }) {
                        Text("Done")
                            .font(.custom("Helvetica Neue", size: 14))
                            .frame(width: 100, height: 25)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(3)
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
            }
            .frame(width: 900, height: 520)
            .cornerRadius(15)
            .padding(5)
                
        }
        
        
    }
    
    func hashingfullProcess () {
        print("entering hashingfullProcess ....")
        hashViewModel.anyprocIsRunning = true
        titleImgSize = "Size Collected"
        titleGauge = "% Completed"
        
        hashcalculations()
    }
    
    //  aux functions used


    func hashcalculations() {
        
        print("inside hashcalculations...")
//        print("timerH in hashCalc \(timerHash.timeElapsedFormatted)")
//        print("timer in hash calc \(timer.elapsedTimeString)")
        if DiskDataManager.shared.selectedHashOption != "NO-HASH" { hashViewModel.stepIndex = 1 }
        let fullFilePaths = FileSelectionManager.shared.selectedFiles
        logfilePath = DiskDataManager.shared.selectedStorageOption + "/\(CaseInfoData.shared.imageName).info"
            
        let whichHash = DiskDataManager.shared.selectedHashOption
        for file in FileSelectionManager.shared.selectedFiles {
            let hashTimeIni = LLTimeManager.getCurrentTimeString()
            print2Log(filePath: logfilePath, text2p: "\(String(repeating: "=", count: 88)))\n")
            switch whichHash {
            case "SHA256":
                print("switch case 256")
//                var hash256 = ""
                let hash256: () = hashViewModel.startHashing(filePath: file.path, hashType: whichHash)
//                hash256 = hashViewModel.hashResult ?? "No hash calculated"
//                DispatchQueue.main.async {
//                    self.timerHash.start()
//                }
//                DispatchQueue.global(qos: .background).async {
//                    hash256 =
//                    hashLargeFileSHA256 (filePath: file.path, viewModel: hviewModel)
//                    DispatchQueue.main.async {
//                        self.timerHash.stop()
//                    }
//                }
//                    let hash256 = hashViewModel.hashResult
//                    print("hash: \(hashViewModel.hashResult) ")
//                    Text("Hash Result: \(hashResult)")
//                    let hashTimeEnd = LLTimeManager.getCurrentTimeString()
//                    print2Log(filePath: logfilePath, text2p: "Hashing file:     \(file.path)")
//                    //                print2Log(filePath: logfilePath, text2p: "\(String(repeating: "-", count: 88)))\n")
//                    print2Log(filePath: logfilePath, text2p: "Start time:       \(hashTimeIni)")
//                    print2Log(filePath: logfilePath, text2p: "End time:         \(hashTimeEnd)")
//                    print2Log(filePath: logfilePath, text2p: "SHA256 hash:      \(hash256)")
//                    print2Log(filePath: logfilePath, text2p: "\(String(repeating: "-", count: 88)))\n")
                    
                
                case "SHA1":
//                let hashsha1 =
//                hashLargeFileSHA1(filePath: file.path)
                let hashsha1: () = hashViewModel.startHashing(filePath: file.path, hashType: whichHash)
//                let hashTimeEnd = LLTimeManager.getCurrentTimeString()
//                print2Log(filePath: logfilePath, text2p: "Hashing file:     \(file.path)")
////                print2Log(filePath: logfilePath, text2p: "\(String(repeating: "-", count: 88)))\n")
//                print2Log(filePath: logfilePath, text2p: "Start time:       \(hashTimeIni)")
//                print2Log(filePath: logfilePath, text2p: "End time:         \(hashTimeEnd)")
//                print2Log(filePath: logfilePath, text2p: "SHA256 hash:      \(String(describing: hashsha1)) \n")
//                print2Log(filePath: logfilePath, text2p: "\(String(repeating: "-", count: 88)))\n")
                
            case "MD5":
                let hashMD5: () = hashViewModel.startHashing(filePath: file.path, hashType: whichHash)
//                let hashMD5 =
//                hashLargeFileMD5(filePath: file.path)
//                let hashTimeEnd = LLTimeManager.getCurrentTimeString()
//                print2Log(filePath: logfilePath, text2p: "Hashing file:     \(file.path)")
////                print2Log(filePath: logfilePath, text2p: "\(String(repeating: "-", count: 88)))\n")
//                print2Log(filePath: logfilePath, text2p: "Start time:       \(hashTimeIni)")
//                print2Log(filePath: logfilePath, text2p: "End time:         \(hashTimeEnd)")
//                print2Log(filePath: logfilePath, text2p: "MD5 hash value: \(String(describing: hashMD5)) \n")
//                print2Log(filePath: logfilePath, text2p: "\(String(repeating: "-", count: 88)))\n")
                
            case "NO-HASH":
                processNoHash()
            default:
                print("Invalid selection")
            }
        }  
//        
//            anyprocIsRunning = false
//            showDoneButton = true
//            stepIndex = 1
     
//        timerHash.stop()
            
        }

    
    func processNoHash() {
        let logfilePath = DiskDataManager.shared.selectedStorageOption + "/\(CaseInfoData.shared.imageName).info"
        print2Log(filePath: logfilePath, text2p: "No hash calculation selected")
    }
    

     
}

struct Imaging4ProcView_Previews: PreviewProvider {
    @State static var selectedOption: MenuOption? = MenuOption(id: 1)
    
    static var previews: some View {
        Imaging4ProcView(selectedOption: $selectedOption)
    }
}


//#Preview {
//        Imaging4ProcView(onComplete: {
//            // Dummy closure for preview
//        })
//
//}
