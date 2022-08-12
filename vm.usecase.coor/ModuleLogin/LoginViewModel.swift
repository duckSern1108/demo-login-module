//
//  LoginViewModel.swift
//  vm.usecase.coor
//
//  Created by ghtk on 12/08/2022.
//

import Foundation
import RxRelay
import RxSwift
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
    
    var password:BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var passwordValid:Observable<Bool> {
        password.map({ [weak self] in
            guard let self = self else  {
                return false
            }
            return self.validatePasswordStrategy.isValidPassword(pass: $0)
        })
    }
    
    var passwordErrText:Observable<String> {
        password.map { [weak self] in
            guard let self = self else  {
                return ""
            }
            return self.validatePasswordStrategy.getErrorText(pass: $0)
        }
    }
    
    var passwordErrTextHidden:Observable<Bool> {
        Observable.combineLatest(password , passwordValid) {
            if $0 == nil {
                return true
            }
            if $0!.count == 0 {return true}
            return $0!.count > 0 && $1
        }
    }
    
    var username:BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var usernameValid:Observable<Bool> {
        username.map({ [weak self] in
            guard let self = self else {
                return false
            }
            return self.validateUsernameStrategy.isValid(username: $0)
        })
    }
    
    var usernameErrText:Observable<String> {
        password.map { [weak self] in
            guard let self = self else {
                return ""
            }
            return self.validateUsernameStrategy.getErrText(username: $0)
        }
    }
    
    var usernameErrTextHidden:Observable<Bool> {
        Observable.combineLatest(username , usernameValid) {
            if $0 == nil {
                return true
            }
            if $0!.count == 0 {return true}
            return $0!.count > 0 && $1
        }
    }
    
    var disabledLogin:Observable<Bool> {
        Observable.combineLatest(usernameValid, passwordValid) {
            $0  && $1
        }
    }
    
    func login() {
        firstly {
            useCase.login(username: username.value, password: password.value)
        }.done{
            loginData in
            if loginData.isSuccess {
                print("token :: ",loginData.token)
            } else {
                print("err :: ",loginData.err)
            }
        }.ensure {
            print("Call api done")
        }
    }
}
