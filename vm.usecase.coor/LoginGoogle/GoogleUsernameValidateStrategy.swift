//
//  GoogleUsernameValidateStrategy.swift
//  vm.usecase.coor
//
//  Created by ghtk on 12/08/2022.
//

import Foundation

struct GoogleUsernameValidateStrategy:LoginUserNameValidateStrategy {
    func isValid(username: String?) -> Bool {
        guard let username = username else {
            return false
        }
        return username.starts(with: "G-")
    }
    
    func getErrText(username: String?) -> String {
        guard let username = username else {
            return "Username not valid"
        }
        if !username.starts(with: "G-") {
            return "Username must start with G-"
        }
        return "Username not valid"
    }
}
