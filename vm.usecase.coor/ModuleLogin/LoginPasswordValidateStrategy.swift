//
//  PasswordValidateStrategy.swift
//  vm.usecase.coor
//
//  Created by ghtk on 12/08/2022.
//

import Foundation

protocol LoginPasswordValidateStrategy {
    func getErrorText(pass: String?) -> String
    func isValidPassword(pass: String?) -> Bool
}
