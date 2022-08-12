//
//  GoogleLoginModel.swift
//  vm.usecase.coor
//
//  Created by ghtk on 12/08/2022.
//

import Foundation

struct GoogleLoginModel:LoginModel {
    var isSuccess: Bool
    var err: String?
    var token: String?
}
