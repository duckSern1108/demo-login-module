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
    var passwordValid:Observable<Bool>!
    
    var passwordErrText:Observable<String>!
    
    var passwordErrTextHidden:Observable<Bool>!
    
    var username = ""
    var usernameValid:Observable<Bool>!
    var usernameErrText:Observable<String>!
    var usernameErrTextHidden:Observable<Bool>!
    var disabledLogin:Observable<Bool>!
    
    var isLoading:BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    func configureObservable(password: Observable<String>, username: Observable<String>) {
        self.passwordValid = password.map({ [weak self] in
            self?.validatePasswordStrategy.isValidPassword(pass: $0) ?? false
        })
        self.usernameValid = username.map({ [weak self] in
            self?.validateUsernameStrategy.isValid(username: $0) ?? false
        })
        self.disabledLogin = Observable.combineLatest(usernameValid, passwordValid) {
            !($0  && $1)
            
        }
        self.usernameErrTextHidden = Observable.combineLatest(username, usernameValid) {
            if $0.count == 0 {
                return true
            }
            return $0.count > 0 && $1
        }
        self.usernameErrText = username.map { [weak self] in
            guard let self = self else {
                return ""
            }
            return self.validateUsernameStrategy.getErrText(username: $0)
        }
        
        self.passwordErrText = password.map { [weak self] in
            guard let self = self else  {
                return ""
            }
            return self.validatePasswordStrategy.getErrorText(pass: $0)
        }
        
        self.passwordErrTextHidden = Observable.combineLatest(password, passwordValid) {
            if $0.count == 0 {return true}
            return $0.count > 0 && $1
        }
    }
    
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
