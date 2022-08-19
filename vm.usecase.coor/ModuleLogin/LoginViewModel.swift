//
//  LoginViewModel.swift
//  vm.usecase.coor
//
//  Created by ghtk on 12/08/2022.
//

import Foundation
import RxRelay
import RxSwift
import RxCocoa
import PromiseKit

class LoginViewModel {
    var useCase:LoginUseCase
    var coordinator:LoginCoordinator
    var validatePasswordStrategy: LoginPasswordValidateStrategy
    var validateUsernameStrategy: LoginUserNameValidateStrategy
    
    init(useCase:LoginUseCase,
         coordinator:LoginCoordinator,
         validatePasswordStrategy: LoginPasswordValidateStrategy,
         validateUsernameStrategy: LoginUserNameValidateStrategy) {
        self.useCase = useCase
        self.coordinator = coordinator
        self.validatePasswordStrategy = validatePasswordStrategy
        self.validateUsernameStrategy = validateUsernameStrategy
        
    }

    var password = ""
    var username = ""
    
    var isLoading:BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    func login() {
        self.isLoading.accept(true)
        firstly {
            self.useCase.login(username: self.username, password: self.password)
        }.done{
            loginData in
            self.coordinator.onLoginSuccess()
            print("token :: ",loginData.token)
        }.ensure {
            self.isLoading.accept(false)            
        }.catch{
            err in
            print("err :: ",err)
        }
        
    }
}
