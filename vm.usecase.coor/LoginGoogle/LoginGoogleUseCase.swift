//
//  LoginGoogleUseCase.swift
//  vm.usecase.coor
//
//  Created by ghtk on 12/08/2022.
//

import Foundation
import PromiseKit

struct LoginGoogleUseCase:LoginUseCase {
    func login(username: String?, password: String?) -> Promise<LoginModel> {
        return Promise {
            seal in
            after(seconds: 4).done {
                print("Google login :: ",username, password)
                let loginDataSuccess = GoogleLoginModel(isSuccess: true, err: nil, token: "123456")
                seal.fulfill(loginDataSuccess)
            }
            
        }
        
    }
}
