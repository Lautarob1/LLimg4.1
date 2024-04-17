//
//  ExampleCommandSet2.swift
//  TestHelperApp
//
//  Created by EFI-Admin on 12/17/23.
//

import CSAuthSampleCommon
import Foundation

let exampleCommandSet: CommandSet = {
    let bundle = Bundle.main

    let sayHelloRightName = "com.charlessoft.CSAuthSample-Example.Say-Hello"
    let sayHelloPrompt = bundle.localizedString(forKey: "SayHello", value: nil, table: "Prompts")
    let sayHelloSelector = #selector(HelperToolProtocol2.sayHello(authorizationData:message:reply:))

    let rights = [
        AuthorizationRight(
            selector: sayHelloSelector,
            name: sayHelloRightName,
            rule: kAuthorizationRuleAuthenticateAsAdmin,
            prompt: sayHelloPrompt
        )
    ]

    return CommandSet(authorizationRights: rights)
}()
