//
//  LoginUsernameValidateStrategy.swift
//  vm.usecase.coor
//
//  Created by ghtk on 12/08/2022.
//

import Foundation

protocol LoginUserNameValidateStrategy {
    func isValid(username: String?) -> Bool
    func getErrText(username: String?) -> String
}
