//
//  LoginSuccessModel.swift
//  vm.usecase.coor
//
//  Created by ghtk on 12/08/2022.
//

import Foundation

protocol LoginModel {
    var isSuccess:Bool {get set}
    var err:String? {get set}
    var token:String? {get set}
}
