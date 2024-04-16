//
//  Imaging1View.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/28/23.
//

import SwiftUI




struct Imaging2ProcView: View {
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
    @State private var sparseSizeBytes: UInt64 = 0
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
    @State private var nilSource = false
    @State private var isSparseMounted = false
    @State private var logfilePath: String = ""
    @State private var logfilePathEx: String = ""
    @ObservedObject private var fileSizeChecker2 = FileSizeChecker2()
    @ObservedObject private var fileSizeChecker3 = FileSizeChecker3()
    let gradient = LinearGradient(gradient: Gradient(colors: [Color("LL_orange"), Color.gray]),
                      startPoint: .top,
                      endPoint: .bottom)
    let gradt2 = LinearGradient(gradient: Gradient(colors: [Color("LL_blue"), Color.black.opacity(0.6)]),
                      startPoint: .top,
                      endPoint: .bottom)
    let gradt1 = LinearGradient(gradient: Gradient(colors: [Color("LL_orange"), Color.black.opacity(0.6)]),
                      startPoint: .top,
                      endPoint: .bottom)
    @State var titleImgSize: String = "Image Size"
    @State var titleGauge: String = "% of Disk Size"
    @State var elapTime: [String] = ["Elapsed Time0", "Elapsed Time1", "Elapsed Time2"]
    @State var imageSize: String = "Image Size in GB"
    @State var strokeWidth: CGFloat = 20
    @State var minValue: CGFloat = 0.0
    @State var maxValue: CGFloat = 0.7
    @State var currentValue: CGFloat = 0.6
    @State var percentage: CGFloat = 0.6
    @State var endMessage: String = "All Completed!"
    let procStep = ["Collecting targeted files/folders...", "Creating DMG...", "Hashing DMG...", "Processing Finished", "Error !!"]
    @State var alertMsg: String = ""
    @State var alertTitle: String = ""
    @State var showCustomAlert: Bool = false
    @State var messageBelowTimer: String = ""

//    var onComplete: () -> Void
    @Binding var selectedOption: MenuOption?
    
    var body: some View {
        
        HStack(alignment: .top) {
            Image("img_but2")
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 90)
                .cornerRadius(15)
                .padding(.leading)
            //                    Spacer()  // Pushes the image to the left
            Text("Target Imaging Mac Computer SN \(deviceInfoData.shared.devSerial) (Case): \(CaseInfoData.shared.caseName)...")
                .font(.title)
                .padding(15)
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
                            
                            logfilePath = DiskDataManager.shared.selectedStorageDestin + "/\(CaseInfoData.shared.imageName).info"
                            logfilePathEx = DiskDataManager.shared.selectedStorageDestin + "/\(CaseInfoData.shared.imageName).LLeX"
                            print("LogfilePath: \(logfilePath)")
                            
                            print("passw capt: \(AuthenticationViewModel.shared.rootPassword)")
                            acqlogHeader(filePath: logfilePath)
                            exclogHeader(filePath: logfilePathEx)
                            acqlogDeviceInfo(filePath: logfilePath)
                            acqlogTargetedFF(filePath: logfilePath)
                            targetedImagefullProcess()
                            if alertMsg == "" {
                                print("after fullprocess--- END")
                                imageName = "info.circle.fill"
                                alertTitle = "😀"
                                alertMsg = "Process finished, press Done Button or esc to return to main menu"
                                messageBelowTimer = "All Completed!"
                                stepIndex = 3
                            }
                            showCustomAlert = true
                            anyprocIsRunning = false
                            showDoneButton = true
                            
                            print("after fullprocess--- END")
                        }) {
                            Text("Click to start process")
                                .font(.custom("Helvetica Neue", size: 16))
                                .frame(width: 160, height: 25)
                                .padding(3)
                                .foregroundColor(.white)
                                .background(gradt1)
                                .cornerRadius(10)
                                
                        }
                        .buttonStyle(PlainButtonStyle())
                        
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
                        .frame(width: 840, height: 300, alignment: .leading)
                        .padding(5)
                        .background(gradt2) // "LL_blue")) // .opacity(0.5) Set the background color
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
                            Text("\(stepIndex >= 1 ? fileSizeChecker2.fileSizeInGB :  fileSizeChecker3.fileSizeInGB, specifier: "%.2f") GB")
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
                                    .trim(from: 0.0, to: (stepIndex >= 1 ? fileSizeChecker2.pctAdvance :  fileSizeChecker3.pctAdvance))
                                    .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                                    .foregroundColor(.white)
                                    .frame(width: 150, height: 80)
                                    .rotationEffect(Angle(degrees: 270.0))

                                Text(String(format: "%.1f%%", 100 * (stepIndex >= 1 ? fileSizeChecker2.pctAdvance :  fileSizeChecker3.pctAdvance)))
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
                                CustomProgressView(scale: 3, color: .blue, backgroundColor: .clear, currrentValue: fileSizeChecker3.fileSizeInGB)
                            } else {
                                Text(messageBelowTimer)
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
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
            }
            .frame(width: 900, height: 500)
            .cornerRadius(25)
            .padding(5)
                
        }
        
        
    }
    
    func targetedImagefullProcess () {
        showProc = true
        anyprocIsRunning = true
        titleImgSize = "Temp Size Collection"
        titleGauge = "% Disk Size"
        timer.startTimer()
//        DiskDataManager.shared.selectedStorageOption + "/\(CaseInfoData.shared.imageName).LLeX"
        print("log path for file eX: \(logfilePathEx)")
        // create sparse container for Logical file
        sviewModel.output=createSparseContainer()
        if  nilSource {
            print2Log(filePath: logfilePathEx, text2p: sviewModel.output)
            sviewModel.output="Creating container for sparse fails. Error in source Disk size"
            imageName = "person.crop.circle.badge.exclamationmark"
            alertTitle = "😬"
            alertMsg = "The sparse container could not be created. Could not determine source Disk size"
            stepIndex = 4

            return
        }

        print2Log(filePath: logfilePathEx, text2p: "Temp and collec process-------------------------------\n")
//        print(sviewModel.output)
        print("after create sparse Container")
        print2Log(filePath: logfilePathEx, text2p: sviewModel.output)
        if  sviewModel.output.contains("failed") {
            print2Log(filePath: logfilePathEx, text2p: sviewModel.output)
            sviewModel.output="Creating container for sparse fails. The processing cannot continue. Press esc to return to main menu"
            imageName = "person.crop.circle.badge.exclamationmark"
            alertTitle = "😬"
            alertMsg = "The sparse container could not be created due to a failure"
            stepIndex = 4

            return
        }

        if  sviewModel.output.contains("Sorry, try again") {
            print2Log(filePath: logfilePathEx, text2p: sviewModel.output)
            sviewModel.output="Creating container for sparse fails. The processing cannot continue. Press esc to return to main menu"
            imageName = "person.crop.circle.badge.exclamationmark"
            alertTitle = "😬"
            alertMsg = "The sparse container could not be created due to a password failure"
            stepIndex = 4

            return
        }

        // Mount sparse container
        print("1st process (create sparse Container), done....")
        sviewModel.output=mountsparseContanier()
        print("after mount sp cont \(sviewModel.output)")
        print2Log(filePath: logfilePathEx, text2p: sviewModel.output)

        if  sviewModel.output.contains("failed") {
            print2Log(filePath: logfilePathEx, text2p: sviewModel.output)
            sviewModel.output="Container was not mounted. The processing cannot continue. Press esc to return to main menu"
            imageName = "person.crop.circle.badge.exclamationmark"
            alertTitle = "😬"
            alertMsg = "The sparse container could not be mounted. Process fail"
            stepIndex = 4

            return
        }
        
        print("2nd process (mount sparse Container) done....")
        
        // Sparse Creation

        copyFF2sparseMain ()
       
        print("3rd process (create sparse Image) done....")
        
        // DMG creation
        stepIndex = 1
        titleImgSize = "DMG size"
        titleGauge = "% DMG vs Sparse"
        if CaseInfoData.shared.isdmgEnabled {
            print("about to enter dmg process...")
            showdmgvalues = true
            createdmgImage()
            print2Log(filePath: logfilePathEx, text2p: sviewModel.output)
            if  isSparseMounted {
                print2Log(filePath: logfilePathEx, text2p: sviewModel.output)
                sviewModel.output="Unmount sparse process fails."
                imageName = "person.crop.circle.badge.exclamationmark"
                alertTitle = "😬"
                alertMsg = "The sparse image could not be unmounted. Please unmount it from Finder or disk Util and then run convert process"
                stepIndex = 4

                return
            }
            
            print("4th process (create dmg) done....")
        }
        else {
            return
        }
//        DispatchQueue.main.async {
//            stepIndex = 2
//        }
        hashcalculations()
        timer.stopTimer()
        print("5th process (hash calcs) done....")
        anyprocIsRunning = false
        showDoneButton = true
        stepIndex = 3
    }
    
    //  aux functions used
    // ====================================================
   
    func copyFF2sparseMain () {
        print("entering copyFF2sparseMain ")
        let sparsePath = DiskDataManager.shared.selectedStorageDestin
        let imgName = CaseInfoData.shared.imageName
//        maxValue = 470
        print("max value in CopyFF2sparseMain \(maxValue)")
        FileSizeChecker3.shared.totalSizeInGB = maxValue
        fileSizeChecker3.filePath = "\(sparsePath)/\(imgName).sparseimage"
        print("fileSizeChecker3.filePath in copyFF2sparseMain \(copyFF2sparseMain)")
        sleep(2)
        fileSizeChecker3.startMonitoring()
        sparseTimeIni=LLTimeManager.getCurrentTimeString()
        let destinPath = "/Volumes/\(CaseInfoData.shared.imageName)"
        print("destinPath with /Volumes hard coded: \(CaseInfoData.shared.imageName)")
//        print("Total size from FselMng: \(FileSelectionManager.shared.totalSize)")
        print("Total size FchkSi3 (GB): \(FileSizeChecker3.shared.totalSizeInGB)")
        print("about to enter in copyFF2sparse...")
        copyFF2sparse (fileItems: FileSelectionManager.shared.selectedFiFo, destPath: destinPath)
        sparseTimeEnd=LLTimeManager.getCurrentTimeString()
        sparseSize=String(format: "%.2f GB", fileSizeChecker3.fileSizeInGB)
        fileSizeChecker3.stopMonitoring()
        logicImgSize[0] = sparseSize
        FileSizeChecker3.shared.fileSizeInGB = fileSizeChecker3.fileSizeInGB
//        currentValue = fileSizeChecker3.fileSizeInGB
        copyFFLog()
        print("after copyFFLog...")
    }
    

    func isSparseImageMounted(imagePath: String) -> Bool {
        let process = Process()
        let pipe = Pipe()
        
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["hdiutil", "info"]
        process.standardOutput = pipe
        
        do {
            try process.run()
            process.waitUntilExit()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: .utf8) {
                // Check if the imagePath appears in the output
                return output.contains(imagePath)
            }
        } catch {
            print("Failed to execute hdiutil command: (error)")
        }
        return false
    }
    
    
    func unmountSparseImage(dskimageMt: String) {
        
        print("inside unmount to try \(dskimageMt)")
        let process = Process()
        let pipe = Pipe()
        
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["hdiutil", "detach", dskimageMt]
        process.standardOutput = pipe
        process.standardError = pipe
        
        do {
            try process.run()
            process.waitUntilExit()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: .utf8), output.contains("ejected") {
                print("CMD output: \(output)")
                print("Image successfully unmounted.")
            } else {
                print("Failed to unmount the image.")
            }
        } catch {
            print("Failed to execute hdiutil command: \(error)")
        }
    }
    
    func unmountSparseImageForce(dskimageMt: String) {
        guard isSparseImageMounted(imagePath: dskimageMt) else {
            print("Image is not mounted or does not exist.")
            return
        }
        
        let process = Process()
        let pipe = Pipe()
        
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["hdiutil", "detach", "-force", dskimageMt]
        process.standardOutput = pipe
        process.standardError = pipe
        
        do {
            try process.run()
            process.waitUntilExit()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: .utf8), output.contains("ejected") {
                print("CMD output: \(output)")
                print("Image successfully unmounted.")
            } else {
                print("Failed to unmount the image.")
            }
        } catch {
            print("Failed to execute hdiutil command: \(error)")
        }
    }
 
    func copyFFLog() {
        print("entering F&Flds log, path for log file")
        print(DiskDataManager.shared.selectedStorageDestin)
        print(CaseInfoData.shared.imgfilePath)
//        let logfilePath = DiskDataManager.shared.selectedStorageOption + "/\(CaseInfoData.shared.imageName).info"
        print("logfilePath: \(logfilePath)")
        acqlogTitleProcesses(filePath: logfilePath)
        print2Log(filePath: logfilePath, text2p: "Extract process --------------------\n")
        print2Log(filePath: logfilePath, text2p: "Start time:     \(sparseTimeIni)")
        print2Log(filePath: logfilePath, text2p: "End time:       \(sparseTimeEnd)")
        print2Log(filePath: logfilePath, text2p: "Image size:     \(sparseSize)\n")
        print("leaving F&Flds log")
    }
    
    func dmgLog() {
        print("entering Tgt dmg log, path for log file:")
        print(DiskDataManager.shared.selectedStorageDestin)
        let logfilePath2 = DiskDataManager.shared.selectedStorageDestin + "/\(CaseInfoData.shared.imageName)_error.info"
        print("logfilePath: \(logfilePath)")
        print2Log(filePath: logfilePath, text2p: "DMG image process ------------------\n")
        print2Log(filePath: logfilePath, text2p: "Start time:     \(dmgTimeIni)")
        print2Log(filePath: logfilePath, text2p: "End time:       \(dmgTimeEnd)")
        print2Log(filePath: logfilePath, text2p: "Image size:     \(dmgSize)\n")
        print("leaving dmg log")
    }
    
    
    func createSparseContainer () -> String {
        let imgName = CaseInfoData.shared.imageName
        let sparsePath = DiskDataManager.shared.selectedStorageDestin
        print("in createSparseCont: imgName=\(imgName)")
        let passw = AuthenticationViewModel.shared.rootPassword
        print("selected DSK org \(DiskDataManager.shared.selectedDskOrigen)")

        // Attempt to extract the disk ID from the selected disk origin, falling back to the root file system disk ID if necessary. If both are nil, set `nilSource` to true.
        var dskIDWithImagedFF = ""
        if let dskIDWithImagedFF = extractusedDisk(from: DiskDataManager.shared.selectedDskOrigen) ?? getRootFileSystemDiskID() {
            // Use `dskIDWithImagedFF` here, as it is guaranteed to be non-nil.
            print("Disk ID with Imaged FF: \(dskIDWithImagedFF)")
        } else {
            // If both `extractusedDisk` and `getRootFileSystemDiskID` return nil, set `nilSource` to true.
            nilSource = true
        }

        guard let dskWithImagedFF = DiskDataManager.shared.findMtPtByIdent(dskIDWithImagedFF) else { return "/" }
        let imgSize = getDiskIDCapacityAvSpace(diskPath: dskWithImagedFF).capacity!
        maxValue = convertSizeStringToDouble(imgSize)
        print("maxValue (value from image size in create sparse container \(maxValue)")
        FileSizeChecker3.shared.totalSizeInGB = maxValue
        print("in createSparseCont: passw= \(passw)")
        print("in createSparseCont: sparsePath= \(sparsePath)")
        print("sudo hdiutil create -size \(imgSize) -type SPARSE -fs APFS -volname \(imgName) \(sparsePath)/\(imgName)")
        sviewModel.output=sviewModel.executeSudoCommand(command: "sudo hdiutil create -size \(imgSize) -type SPARSE -fs APFS -volname \(imgName) \(sparsePath)/\(imgName)", passw: passw)
        print("exiting createSparseContainer")
        return sviewModel.output
    }
    func mountsparseContanier() -> String {
        let sparsePath = DiskDataManager.shared.selectedStorageDestin
        let imgName = CaseInfoData.shared.imageName+".sparseimage"
        let passw = AuthenticationViewModel.shared.rootPassword
        
        sviewModel.output=sviewModel.executeSudoCommand(command: "sudo hdiutil attach \(sparsePath)/\(imgName)", passw: passw)
        return sviewModel.output
    }
    
    func copyFF2sparse (fileItems: [FileFolderItem], destPath: String) {
        print("inside copyFF2Sparse, copying to: \(destPath)")
//        print("fileItems: \(fileItems)")
        let destinationPath = destPath
        for file in fileItems {
            print("files copied before: \(filesCopied)")
            copyItem(atPath: file.path, toPath: destinationPath)
            print("files copied after: \(filesCopied)")
            
        }
        
    }
 
    
    // Function to copy a file or directory, including hidden files and preserving extended attributes

    func copyItem(atPath srcPath: String, toPath dstPath: String) {
         let passw = AuthenticationViewModel.shared.rootPassword
         let command = "cp -a \(srcPath) \(dstPath)"
         let fullCommand = "echo \(passw) | sudo -S \(command)"
         print(command)
         let process = Process()
//         let pipe = Pipe()
         process.environment = ProcessInfo.processInfo.environment
         process.executableURL = URL(fileURLWithPath: "/bin/zsh")
         process.arguments = ["-c", fullCommand]
        do {
            try process.run()
            process.waitUntilExit()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
         let status = process.terminationStatus
         if status == 0 {
             filesCopied += 1
         } else {
             filesNotCopied += 1
             let logfilePath2 = DiskDataManager.shared.selectedStorageDestin + "/\(CaseInfoData.shared.imageName)_error.info"
             print2Log(filePath: logfilePath2, text2p: "Failed to copy \(srcPath). Exit code: \(status)")
             print("Failed to copy \(srcPath). Exit code: \(status)")
         }
     }
    
    func createdmgImage() {
        let imgName = CaseInfoData.shared.imageName
        let defaultImagePath = "/Volumes/llidata/\(imgName).sparseimage"
        let fullimagePath = "\(DiskDataManager.shared.selectedStorageDestin)/\(imgName).sparseimage"
        print("inside createdmgImage...")
//        let fullimagePath = fileSizeChecker2.filePath ?? defaultImagePath
//        print("fileSizechecker2.filePath: \(String(describing: fileSizeChecker2.filePath))")
//        let fullimagePath = "/Volumes/llidata/\(imgName).sparseimage"
        print("fileSizechecker2.filePath: \(String(describing: fullimagePath))")
        let isMounted = isSparseImageMounted(imagePath: fullimagePath)
        print(isMounted ? "Image is mounted" : "Image is not mounted")
        let hdiInfo = loaddhiutilInfo()
        guard let devDiskMt = extractDiskIdentifier2(from: hdiInfo, imagePath: fullimagePath)
        else {
            print("error in dsk id for")
            let logfilePath2 = DiskDataManager.shared.selectedStorageDestin + "/\(CaseInfoData.shared.imageName)_error.info"
            print2Log(filePath: logfilePath2, text2p: "Failed to unmount sparse")
            return
            }
        sparseSizeBytes = getFileSize(filePath: fullimagePath) ?? 0
        print("sparse size in bytes: \(sparseSizeBytes)")
        print("values for mounted sparse, used and total:")
        print(getAnyDiskInfo(dskpath: fullimagePath)?.usedSpace ?? 0)
        print(getAnyDiskInfo(dskpath: fullimagePath)?.totalCapacity ?? 0)
//        print("to be Unmounted: \(devDiskMt)")
        print("to be Unmounted: \(fullimagePath)")
        if isMounted {
            Thread.sleep(forTimeInterval: 3)
            unmountSparseImage(dskimageMt: devDiskMt)
//            unmountSparseImage(dskimageMt: fullimagePath)
        }
        let isMounted2 = isSparseImageMounted(imagePath: fullimagePath)
        if isMounted2 {
            Thread.sleep(forTimeInterval: 5)
//            unmountSparseImageForce(dskimageMt: devDiskMt)
            unmountSparseImageForce(dskimageMt: fullimagePath)
        }
        if isSparseImageMounted(imagePath: fullimagePath) {
            print("image still mounted after 2 attemps")
            isSparseMounted = true
            return
        }
        let logfilePath = DiskDataManager.shared.selectedStorageDestin + "/\(CaseInfoData.shared.imageName).info"
        let passw = AuthenticationViewModel.shared.rootPassword
        print("in dmg, logfilePath: \(logfilePath)")
        print("in dmg, password: \(passw)")
        showdmgvalues = true
        if CaseInfoData.shared.dmgfilePath == "" {
            CaseInfoData.shared.dmgfilePath = DiskDataManager.shared.selectedStorageDestin
        }
        var path2dmg = ""
        if DiskDataManager.shared.selected2ndStorageDestin == "" {
            path2dmg = DiskDataManager.shared.selectedStorageDestin
        } else {
            path2dmg = DiskDataManager.shared.selected2ndStorageDestin
        }
        print("in dmg, path to store DMG: \(path2dmg)")
        dmgTimeIni=LLTimeManager.getCurrentTimeString()
        fileSizeChecker2.filePath = "\(path2dmg)/\(imgName).dmg"
        fileSizeChecker2.totalSizeInGB = Double(sparseSizeBytes) / 1_000_000_000
        FileSizeChecker2.shared.totalSizeInGB = fileSizeChecker2.totalSizeInGB
        print("reasigned totalSizeInGB for gauge DMG: \(fileSizeChecker2.totalSizeInGB)")
        print("confirm reasigned totalSizeInGB for gauge DMG: \(FileSizeChecker2.shared.totalSizeInGB)")
        fileSizeChecker2.startMonitoring()
        sviewModel.executeSudoCommand2(command: "hdiutil convert \(fullimagePath) -format UDZO -o \(path2dmg)/\(imgName).dmg", passw: passw)
        sviewModel.isMonitoringActive = false
        print("after making false isMonitorActive-----")
        print("value for sviewModel.isMonitoringActive= \(sviewModel.isMonitoringActive)")
        fileSizeChecker2.stopMonitoring()
        dmgSize=String(format: "%.2f GB", fileSizeChecker2.fileSizeInGB)
        print("exesudo2 finished.... dmg size: \(dmgSize)")
//        timer.stopTimer()
        dmgTimeEnd=LLTimeManager.getCurrentTimeString()

  
        let logendTime = "        DMG Image End Time \(dmgTimeEnd)\n"
        dmgLog()
    }
    
    func hashcalculations() {
        stepIndex = 2
        print("stepIndex: \(stepIndex)")
        print("inside hashcalculations...")
        print("In hash calc: \(procStep[stepIndex])")
        if DiskDataManager.shared.selectedHashOption != "NO-HASH" {stepIndex = 3 }
//        let imgName = CaseInfoData.shared.imageName
        var pathFile = ""
        if DiskDataManager.shared.selected2ndStorageDestin == "" {
            pathFile = DiskDataManager.shared.selectedStorageDestin + "/\(CaseInfoData.shared.imageName).dmg"
        } else {
            pathFile = DiskDataManager.shared.selected2ndStorageDestin + "/\(CaseInfoData.shared.imageName).dmg"
        }

        print("path to dmg in hash calc: \(pathFile)")
        let logfilePath = DiskDataManager.shared.selectedStorageDestin + "/\(CaseInfoData.shared.imageName).info"
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
            print2Log(filePath: logfilePath, text2p: "SHA256 value:   \(String(describing: hash256)) \n")
            
        case "SHA1":
            let hashsha1 =
            hashLargeFileSHA1(filePath: pathFile)
            let hashTimeEnd = LLTimeManager.getCurrentTimeString()
            print2Log(filePath: logfilePath, text2p: "End time:       \(hashTimeEnd)")
            print2Log(filePath: logfilePath, text2p: "SHA1 value:    \(String(describing: hashsha1)) \n")
            
        case "MD5":
            let hashMD5 =
            hashLargeFileMD5(filePath: pathFile)
            let hashTimeEnd = LLTimeManager.getCurrentTimeString()
            print2Log(filePath: logfilePath, text2p: "End time:       \(hashTimeEnd)")
            print2Log(filePath: logfilePath, text2p: "MD5 value: \(String(describing: hashMD5)) \n")
            
        case "NO-HASH":
            processNoHash()
        default:
            print("Invalid selection")
        }
        stepIndex = 3
    }
    
    func processNoHash() {
        let logfilePath = DiskDataManager.shared.selectedStorageDestin + "/\(CaseInfoData.shared.imageName).info"
        print2Log(filePath: logfilePath, text2p: "No hash calculation selected")
    }
    

     
}

struct Imaging2ProcView_Previews: PreviewProvider {
    @State static var selectedOption: MenuOption? = MenuOption(id: 1)
    
    static var previews: some View {
        Imaging2ProcView(selectedOption: $selectedOption)
    }
}


//#Preview {
//
//        Imaging2ProcView(onComplete: {
//            // Dummy closure for preview
//    })
//}
