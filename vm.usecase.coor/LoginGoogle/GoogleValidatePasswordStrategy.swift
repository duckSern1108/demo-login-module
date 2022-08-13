//
//  GoogleValidatePasswordStrategy.swift
//  vm.usecase.coor
//
//  Created by ghtk on 12/08/2022.
//

import Foundation

struct GoogleValidatePasswordStrategy: LoginPasswordValidateStrategy {
    func isValidPassword(pass: String?) -> Bool {
        guard let pass = pass else {
            return false
        }        
        return pass.count >= 6
    }
    func getErrorText(pass: String?) -> String {
        guard let pass = pass else {
            return "Password not valid"
        }
        if pass.count < 6 {
            return "Password must have length >= 6"
        }
        return "Password not valid"
    }
}
