//
//  Imaging1View.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/28/23.
//

import SwiftUI



struct Imaging3ProcView: View {
    @ObservedObject var authModel = AuthenticationViewModel()
    @ObservedObject var sviewModel = ConsoleViewModel()
    @ObservedObject var diskDataManager = DiskDataManager()
    @ObservedObject var timer = ElapsedTimeTimer()
    @ObservedObject var dmgtimer = ElapsedTimeTimer()
    @ObservedObject var hviewModel = HashingViewModel()
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
    @ObservedObject private var fileSizeChecker = FileSizeChecker()
    @ObservedObject private var fileSizeChecker3 = FileSizeChecker3()
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
    let procStep = ["Creating DMG...", "Hashing DMG...", "Processing Finished"]
    @State var alertMsg: String = ""
    @State var alertTitle: String = ""
    @State var showCustomAlert: Bool = false
    @State var messageBelowTimer: String = ""
    @State var sparseGB: Double = 0.0
 
    @Binding var selectedOption: MenuOption?
    
    var body: some View {
        
        HStack(alignment: .top) {
            Image("img_but3")
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 90)
                .cornerRadius(15)
                .padding(.leading)
            //                    Spacer()  // Pushes the image to the left
            Text("Convert Sparse Image to DMG")
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
                            logfilePathEx = DiskDataManager.shared.selectedStorageOption + "/\(CaseInfoData.shared.imageName).LLeX"
                            print("LogfilePath: \(logfilePath)")
                            
                            print("passw capt: \(AuthenticationViewModel.shared.rootPassword)")
                            acqlogHeader(filePath: logfilePath)
                            exclogHeader(filePath: logfilePathEx)
                            acqlogConv2Sparse(filePath: logfilePath)
                            ConvertImagefullProcess()
                            print("after fullprocess--- END")
                        }) {
                            Text("Click to start process")
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
//                    TextEditor(text: $sviewModel.output)
                       Text(sviewModel.output)
                        .font(.system(size: 11, weight: .bold, design: .default)) // Set font size, weight, and design
//                        .italic() 
                        .foregroundColor(.white) // Set the text color
                        .frame(width: 840, height: 200, alignment: .leading)
                        .padding(5)
                        .background(gradt2)   //Color("LL_blue"))  //.opacity(0.5))
                        .cornerRadius(14)
                    
                }
                .frame(width: 860, height: 200)
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
                            Text("Time Elapsed: \(timer.elapsedTimeString)")
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
                            Text("\(fileSizeChecker3.fileSizeInGB, specifier: "%.2f") GB")
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
                                    .trim(from: 0.0, to: fileSizeChecker3.fileSizeInGB / sparseGB)
                                    .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                                    .foregroundColor(.white)
                                    .frame(width: 150, height: 80)
                                    .rotationEffect(Angle(degrees: 270.0))

                                Text(String(format: "%00.0f%%", 100 * fileSizeChecker3.fileSizeInGB / sparseGB))
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
                                CustomProgressView(scale: 2, color: .blue, backgroundColor: .clear, currrentValue: fileSizeChecker3.fileSizeInGB)
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
    //                            onOK: {
    //                                print("hola")
    //                            }
                            )
                            .offset(y: -100.0)
                        }
                        }
                    )

            }

                if showDoneButton {
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
                    Spacer()
                }
            }
            .frame(width: 900, height: 520)
            .cornerRadius(15)
            .padding(5)
                
        }
        
        
    }
    
    func ConvertImagefullProcess () {
        showProc = true
        anyprocIsRunning = true

        
        // DMG creation
        titleImgSize = "DMG size"
        titleGauge = "% Size DMG vs Sparse"
        print("about to enter dmg process...")
        showdmgvalues = true
        timer.startTimer()
        createdmgImage()
        stepIndex = 1
        print2Log(filePath: logfilePathEx, text2p: sviewModel.output)
        print("1st process (create dmg) done....")
        hashcalculations()
        print("5th process (hash calcs) done....")
        anyprocIsRunning = false
        showDoneButton = true
        timer.stopTimer()
        stepIndex = 2
    }
    
    //  aux functions used
    // ====================================================
   

    
    func dmgLog() {
        print("entering Sparse to dmg log, path for log file:")
        print(DiskDataManager.shared.selectedStorageOption)
        let logfilePath2 = DiskDataManager.shared.selectedStorageOption + "/\(CaseInfoData.shared.imageName)_error.info"
        print("logfilePath: \(logfilePath)")
        print2Log(filePath: logfilePath, text2p: "DMG image process ------------------\n")
        print2Log(filePath: logfilePath, text2p: "Start time:     \(dmgTimeIni)")
        print2Log(filePath: logfilePath, text2p: "End time:       \(dmgTimeEnd)")
        print2Log(filePath: logfilePath, text2p: "Image size:     \(dmgSize)\n")
        print("leaving dmg log")
    }
     
    func createdmgImage() {
        let imgName = CaseInfoData.shared.imageName
//        FileSelectionManager.shared.selectedFiles
        let dmgPath = DiskDataManager.shared.selectedStorageOption
        guard let fullsparsePath = FileSelectionManager.shared.selectedFiles.first?.path else {
            // rise alert here: sparse hot found
            print("sparse not found")
            return  }
        sparseGB = Double(FileSelectionManager.shared.selectedFiles.first!.size) / 1_000_000_000
        print("sparseGB: \(sparseGB)")
        fileSizeChecker3.filePath = "\(dmgPath)/\(imgName).dmg"
        let defaultImagePath = "/Volumes/llidata/\(imgName).dmg"
        print("inside createdmgImage...")
        let fulldmgPath = fileSizeChecker3.filePath ?? defaultImagePath
//        print("fileSizechecker3.filePath: \(String(describing: fileSizeChecker3.filePath))")
        print("fileSizechecker3.filePath: \(fileSizeChecker3.filePath ?? "not set")")
        let hdiInfo = loaddhiutilInfo()
        print("hdiInfo for unmount sparse \(hdiInfo)")
        if let devDiskMt = extractDiskIdentifier2(from: hdiInfo, imagePath: fullsparsePath) {
            print("devDiskMt error in dsk id for")
            imageName = "person.crop.circle.badge.exclamationmark"
            alertTitle = "😬"
            alertMsg = "The sparse container was mounted"
            stepIndex = 4
            print("to be Unmounted: \(devDiskMt)")
            return
        }
        let logfilePath = DiskDataManager.shared.selectedStorageOption + "/\(CaseInfoData.shared.imageName).info"
        let passw = AuthenticationViewModel.shared.rootPassword
        print("in dmg, logfilePath: \(logfilePath)")
        print("in dmg, password: \(passw)")
        showdmgvalues = true
        if CaseInfoData.shared.dmgfilePath == "" {
            CaseInfoData.shared.dmgfilePath = DiskDataManager.shared.selectedStorageOption
        }

        dmgTimeIni=LLTimeManager.getCurrentTimeString()
        fileSizeChecker3.startMonitoring()
        sviewModel.executeSudoCommand2(command: "hdiutil convert \(fullsparsePath) -format UDZO -o \(dmgPath)/\(imgName).dmg", passw: passw)
        sviewModel.isMonitoringActive = false
        print("after making false isMonitorActive-----")
        print("value for sviewModel.isMonitoringActive= \(sviewModel.isMonitoringActive)")
        fileSizeChecker3.stopMonitoring()
        dmgTimeEnd=LLTimeManager.getCurrentTimeString()
        let logendTime = "        DMG Image End Time \(dmgTimeEnd)\n"
        dmgLog()
    }
    
    func hashcalculations() {
        
        print("inside hashcalculations...")
        if DiskDataManager.shared.selectedHashOption != "NO-HASH" {stepIndex = 2 }
//        let imgName = CaseInfoData.shared.imageName
        var pathFile = ""
            pathFile = DiskDataManager.shared.selectedStorageOption + "/\(CaseInfoData.shared.imageName).dmg"
     
        print("path to dmg in hash calc: \(pathFile)")
        let logfilePath = DiskDataManager.shared.selectedStorageOption + "/\(CaseInfoData.shared.imageName).info"
        print2Log(filePath: logfilePath, text2p: "Hash DMG image process -------------\n")
        let hashTimeIni = LLTimeManager.getCurrentTimeString()
        print2Log(filePath: logfilePath, text2p: "Start time:     \(hashTimeIni)")
 
        switch DiskDataManager.shared.selectedHashOption {
        case "SHA256":
            print("switch case 256")
            let hash256 =
            hashLargeFileSHA256 (filePath: pathFile, viewModel: hviewModel)
            let hashTimeEnd = LLTimeManager.getCurrentTimeString()
            print2Log(filePath: logfilePath, text2p: "End time:       \(hashTimeEnd)")
            print2Log(filePath: logfilePath, text2p: "SHA256 hash:    \(String(describing: hash256)) \n")
            
        case "SHA1":
            let hashsha1 =
            hashLargeFileSHA1(filePath: pathFile)
            let hashTimeEnd = LLTimeManager.getCurrentTimeString()
            print2Log(filePath: logfilePath, text2p: "End time:       \(hashTimeEnd)")
            print2Log(filePath: logfilePath, text2p: "SHA1 hash:      \(String(describing: hashsha1)) \n")
            
        case "MD5":
            let hashMD5 =
            hashLargeFileMD5(filePath: pathFile)
            let hashTimeEnd = LLTimeManager.getCurrentTimeString()
            print2Log(filePath: logfilePath, text2p: "End time:       \(hashTimeEnd)")
            print2Log(filePath: logfilePath, text2p: "MD5 value:      \(String(describing: hashMD5)) \n")
            
        case "NO-HASH":
            processNoHash()
        default:
            print("Invalid selection")
        }
        
    }
    
    func processNoHash() {
        let logfilePath = DiskDataManager.shared.selectedStorageOption + "/\(CaseInfoData.shared.imageName).info"
        print2Log(filePath: logfilePath, text2p: "No hash calculation selected")
    }
    
//    private func setupTimer() {
//        print("setup timer for gauge")
//        timerGauge2 = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
//                self.updateSizeForGauge()
//            }
//        }
    
//    func updateSizeForGauge() {
//        fileUpdCounter += 1
//        print("in updateSize4G count: \(fileUpdCounter)")
//        print("in updateSize4G entering fSChecker3: \(fileSizeChecker3.fileSizeInGB)")
//        print("in updateSize4G -> maxValue: \(self.maxValue) ")
//        print("in updateSize4G -> currentValue: \(self.currentValue) ")
//        if currentValue < maxValue {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            print("inside updateSize4G in dispatch fSChecker3: \(fileSizeChecker3.fileSizeInGB)")
//                currentValue = fileSizeChecker3.fileSizeInGB
//                print("currentValue inside update being updated \(self.currentValue)")
//            }
//        } else {
//                            self.timerGauge2?.invalidate()
//                            self.timerGauge2 = nil
//            }
//
//    }
     
}

struct Imaging3ProcView_Previews: PreviewProvider {
    @State static var selectedOption: MenuOption? = MenuOption(id: 1)
    
    static var previews: some View {
        Imaging3ProcView(selectedOption: $selectedOption)
    }
}

//#Preview {
//        Imaging3ProcView(onComplete: {
//        })
//}
