//
//  LoginUseCase.swift
//  vm.usecase.coor
//
//  Created by ghtk on 12/08/2022.
//

import Foundation
import PromiseKit


protocol LoginUseCase {
    func login(username: String?, password:String?) -> Promise<LoginModel>
}
