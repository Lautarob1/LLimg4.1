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
    @State var titleImgSize: String = "Image Size"
    @State var titleGauge: String = "Disk Size"
    @State var elapTime: [String] = ["Elapsed Time0", "Elapsed Time1", "Elapsed Time2"]
    @State var imageSize: String = "Image Size in GB"
    @State var strokeWidth: CGFloat = 20
    @State var minValue: CGFloat = 0.0
    @State var maxValue: CGFloat = 0.7
    @State var currentValue: CGFloat = 0.6
    @State var percentage: CGFloat = 0.6
    @State var endMessage: String = "All Completed!"
    let procStep = ["Colecting and processing information...", "Creating DMG...", "Hashing DMG...", "Processing Fineshed"]
    let timerGauge = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State var timerGauge2: Timer?

    var onComplete: () -> Void
    
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
                .font(.title2)
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
                            
                            logfilePath = DiskDataManager.shared.selectedStorageOption + "/\(CaseInfoData.shared.imageName).info"
                            logfilePathEx = DiskDataManager.shared.selectedStorageOption + "/\(CaseInfoData.shared.imageName).LLeX"
                            print("LogfilePath: \(logfilePath)")
                            
                            print("passw capt: \(AuthenticationViewModel.shared.rootPassword)")
                            acqlogHeader(filePath: logfilePath)
                            exclogHeader(filePath: logfilePathEx)
                            acqlogDeviceInfo(filePath: logfilePath)
                            acqlogTargetedFF(filePath: logfilePath)
                            targetedImagefullProcess()
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
                    TextEditor(text: $sviewModel.output)
                    //                    Text(sviewModel.output)
                        .font(.system(size: 11, weight: .bold, design: .default)) // Set font size, weight, and design
//                        .italic() 
                        .foregroundColor(.blue) // Set the text color
                        .frame(width: 840, height: 150, alignment: .leading)
                        .padding(5)
                        .background(Color("LL_blue")) // .opacity(0.5) Set the background color
                        .cornerRadius(14)
                    
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
                                    .trim(from: 0.0, to: fileSizeChecker3.percenAdvance)
                                    .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                                    .foregroundColor(.white)
                                    .frame(width: 150, height: 80)
                                    .rotationEffect(Angle(degrees: 270.0))

                                Text(String(format: "%00.0f%%", 100 * fileSizeChecker3.percenAdvance))
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
                                Text(endMessage)
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
            .frame(width: 900, height: 500)
            .cornerRadius(25)
            .padding(5)
                
        }
        
        
    }
    
    func targetedImagefullProcess () {
        showProc = true
        anyprocIsRunning = true
        titleImgSize = "Temp Size Collection"
        titleGauge = "% Image vs Disk Size"
//        DiskDataManager.shared.selectedStorageOption + "/\(CaseInfoData.shared.imageName).LLeX"
        print("log path for file eX: \(logfilePathEx)")
        // create sparse container for Logical file
        sviewModel.output=createSparseContainer()
        print2Log(filePath: logfilePathEx, text2p: "Temp and collec process-------------------------------\n")
//        print(sviewModel.output)
        print2Log(filePath: logfilePathEx, text2p: sviewModel.output)
        if  sviewModel.output.contains("failed") {
            sviewModel.output="Creating container for sparse fails. The processing cannot continue. Press esc to return to main menu"
            endMessage = "Process Fail!"
            timer.stopTimer()
            return
        }
        // Mount sparse container
        print("1st process (create sparse Container), done....")
        sviewModel.output=mountsparseContanier()
        print(sviewModel.output)
//        print2Log(filePath: logfilePathEx, text2p: sviewModel.output)
        if  sviewModel.output.contains("failed") {
            sviewModel.output="Container was not mounted. The processing cannot continue. Press esc to return to main menu"
            endMessage = "Process Fail!"
            timer.stopTimer()
            return
        }
        
        print("2nd process (mount sparse Container) done....")
        
        // Sparse Creation

        copyFF2sparseMain ()
        stepIndex = 1
        print("3rd process (create sparse Image) done....")
        
        // DMG creation
        titleImgSize = "DMG size"
        titleGauge = "% DMG vs Sparse"
        if CaseInfoData.shared.isdmgEnabled {
            print("about to enter dmg process...")
            showdmgvalues = true
            createdmgImage()
            print2Log(filePath: logfilePathEx, text2p: sviewModel.output)
            print("4th process (create dmg) done....")
        }
        else {
            return
        }

        hashcalculations()
        print("5th process (hash calcs) done....")
        anyprocIsRunning = false
        showDoneButton = true
        stepIndex = 3
    }
    
    //  aux functions used
    // ====================================================
   
    func copyFF2sparseMain () {
        print("entering copyFF2sparseMain ")
        let sparsePath = DiskDataManager.shared.selectedStorageOption
        let imgName = CaseInfoData.shared.imageName
        maxValue = 470
        FileSizeChecker3.shared.totalSizeInGB = maxValue / 1000
        timer.startTimer()
        fileSizeChecker3.filePath = "\(sparsePath)/\(imgName).sparseimage"
        fileSizeChecker3.startMonitoring()
        sparseTimeIni=LLTimeManager.getCurrentTimeString()
//        let destinPath = DiskDataManager.shared.selectedStorageOption
        let destinPath = "/Volumes/\(CaseInfoData.shared.imageName)"
        print("Total size from FselMng: \(FileSelectionManager.shared.totalSize)")
        print("Total size FchkSi3 (GB): \(FileSizeChecker3.shared.totalSizeInGB)")
        copyFF2sparse (fileItems: FileSelectionManager.shared.selectedFiFo, destPath: destinPath)
//        timer.stopTimer()
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
        print(DiskDataManager.shared.selectedStorageOption)
        print(CaseInfoData.shared.imgfilePath)
//        let logfilePath = DiskDataManager.shared.selectedStorageOption + "/\(CaseInfoData.shared.imageName).info"
        print("logfilePath: \(logfilePath)")
        print2Log(filePath: logfilePath, text2p: "Extract process --------------------\n")
        print2Log(filePath: logfilePath, text2p: "Start time:     \(sparseTimeIni)")
        print2Log(filePath: logfilePath, text2p: "End time:       \(sparseTimeEnd)")
        print2Log(filePath: logfilePath, text2p: "Image size:     \(sparseSize)\n")
        print("leaving F&Flds log")
    }
    
    func dmgLog() {
        print("entering Tgt dmg log, path for log file:")
        print(DiskDataManager.shared.selectedStorageOption)
        let logfilePath2 = DiskDataManager.shared.selectedStorageOption + "/\(CaseInfoData.shared.imageName)_error.info"
        print("logfilePath: \(logfilePath)")
        print2Log(filePath: logfilePath, text2p: "DMG image process ------------------\n")
        print2Log(filePath: logfilePath, text2p: "Start time:     \(dmgTimeIni)")
        print2Log(filePath: logfilePath, text2p: "End time:       \(dmgTimeEnd)")
        print2Log(filePath: logfilePath, text2p: "Image size:     \(dmgSize)\n")
        print("leaving dmg log")
    }
    
    
    func createSparseContainer () -> String {
        let imgName = CaseInfoData.shared.imageName
        print("in createSparseCont: imgName=\(imgName)")
        let passw = AuthenticationViewModel.shared.rootPassword
        let dskWithImagedFF = "/dev/"+(extractusedDisk(from: DiskDataManager.shared.selectedDskOption) ?? getRootFileSystemDiskID()!)
        print("disk to be imaged: \(dskWithImagedFF)")
        let imgSize = getDiskIDCapacityAvSpace(diskPath: dskWithImagedFF).capacity!
        maxValue = convertSizeStringToDouble(imgSize)
        FileSizeChecker3.shared.totalSizeInGB = maxValue
        sviewModel.output=sviewModel.executeSudoCommand(command: "sudo hdiutil create -size \(imgSize) -type SPARSE -fs APFS -volname \(imgName) /Volumes/llidata/\(imgName)", passw: passw)
        
        return sviewModel.output
    }
    func mountsparseContanier() -> String {
        let imgName = CaseInfoData.shared.imageName+".sparseimage"
        let passw = AuthenticationViewModel.shared.rootPassword
        
        sviewModel.output=sviewModel.executeSudoCommand(command: "sudo hdiutil attach /Volumes/llidata/\(imgName)", passw: passw)
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
        let process = Process()
        process.launchPath = "/bin/cp"
        process.arguments = ["-a", srcPath, dstPath]
        print("cmd in func copyItem: cp -a \(srcPath) \(dstPath)")
        process.launch()
        process.waitUntilExit()

        let status = process.terminationStatus
        if status == 0 {
            filesCopied += 1
        } else {
            filesNotCopied += 1
            let logfilePath2 = DiskDataManager.shared.selectedStorageOption + "/\(CaseInfoData.shared.imageName)_error.info"
            print2Log(filePath: logfilePath2, text2p: "Failed to copy \(srcPath). Exit code: \(status)")
            print("Failed to copy \(srcPath). Exit code: \(status)")
        }
    }
    
    
    func createdmgImage() {
        let imgName = CaseInfoData.shared.imageName
        let defaultImagePath = "/Volumes/llidata/\(imgName).sparseimage"
        print("inside createdmgImage...")
        let fullimagePath = fileSizeChecker3.filePath ?? defaultImagePath
        print("fileSizechecker3.filePath: \(String(describing: fileSizeChecker3.filePath))")
        let isMounted = isSparseImageMounted(imagePath: fullimagePath)
        print(isMounted ? "Image is mounted" : "Image is not mounted")
        let hdiInfo = loaddhiutilInfo()
        guard let devDiskMt = extractDiskIdentifier2(from: hdiInfo, imagePath: fullimagePath) else {
            print("error in dsk id for")
            return
            }
        print("to be Unmounted: \(devDiskMt)")
        if isMounted {
            Thread.sleep(forTimeInterval: 3)
            unmountSparseImage(dskimageMt: devDiskMt)
        }
        let isMounted2 = isSparseImageMounted(imagePath: fullimagePath)
        if isMounted2 {
            Thread.sleep(forTimeInterval: 5)
            unmountSparseImageForce(dskimageMt: devDiskMt)
        }
        if isSparseImageMounted(imagePath: fullimagePath) {
            print("image still mounted after 2 attemps")
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
        var path2dmg = ""
        if DiskDataManager.shared.selected2ndStorageOption == "" {
            path2dmg = DiskDataManager.shared.selectedStorageOption
        } else {
            path2dmg = DiskDataManager.shared.selected2ndStorageOption
        }
        print("in dmg, path to store DMG: \(path2dmg)")
        dmgTimeIni=LLTimeManager.getCurrentTimeString()
//        dmgtimer.startTimer()
        fileSizeChecker3.filePath = "\(path2dmg)/\(imgName).dmg"
        fileSizeChecker3.startMonitoring()
        sviewModel.executeSudoCommand2(command: "hdiutil convert \(fullimagePath) -format UDZO -o \(path2dmg)/\(imgName).dmg", passw: passw)
        sviewModel.isMonitoringActive = false
        print("after making false isMonitorActive-----")
        print("value for sviewModel.isMonitoringActive= \(sviewModel.isMonitoringActive)")
        fileSizeChecker3.stopMonitoring()
        dmgSize=String(format: "%.2f GB", fileSizeChecker3.fileSizeInGB)
        print("exesudo2 finished.... dmg size: \(dmgSize)")
//        dmgtimer.stopTimer()
        timer.stopTimer()
        dmgTimeEnd=LLTimeManager.getCurrentTimeString()

  
        let logendTime = "        DMG Image End Time \(dmgTimeEnd)\n"
        sviewModel.progressDMG = 100
        dmgLog()
    }
    
    func hashcalculations() {
        
        print("inside hashcalculations...")
        if DiskDataManager.shared.selectedHashOption != "NO-HASH" {stepIndex = 2 }
//        let imgName = CaseInfoData.shared.imageName
        var pathFile = ""
        if DiskDataManager.shared.selected2ndStorageOption == "" {
            pathFile = DiskDataManager.shared.selectedStorageOption + "/\(CaseInfoData.shared.imageName).dmg"
        } else {
            pathFile = DiskDataManager.shared.selected2ndStorageOption + "/\(CaseInfoData.shared.imageName).dmg"
        }

        print("path to dmg in hash calc: \(pathFile)")
        let logfilePath = DiskDataManager.shared.selectedStorageOption + "/\(CaseInfoData.shared.imageName).info"
        print2Log(filePath: logfilePath, text2p: "Hash DMG image process -------------\n")
        let hashTimeIni = LLTimeManager.getCurrentTimeString()
        print2Log(filePath: logfilePath, text2p: "Start time:        \(hashTimeIni)")
   
        
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


#Preview {

        Imaging2ProcView(onComplete: {
            // Dummy closure for preview
    })
}
