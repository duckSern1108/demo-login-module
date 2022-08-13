//
//  LoginViewController.swift
//  vm.usecase.coor
//
//  Created by ghtk on 12/08/2022.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrTxt: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var usernameErrTxt: UILabel!
    
    var viewModel:LoginViewModel!
    let bag = DisposeBag()
    
    static func newVC(usecase: LoginUseCase,
                      coordinator: LoginCoordinator,
                      validatePasswordStrategy: LoginPasswordValidateStrategy,
                      usernameValidateStrategy: LoginUserNameValidateStrategy) -> LoginViewController {
        let viewModel = LoginViewModel(useCase: usecase,
                                       coordinator: coordinator,
                                       validatePasswordStrategy: validatePasswordStrategy,
                                       validateUsernameStrategy: usernameValidateStrategy)
        let vc = LoginViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    @IBAction func onSignUpPress(_ sender: Any) {
        viewModel.coordinator.goToSignUp()
    }
    @IBAction func onLoginBtnPress(_ sender: Any) {
        viewModel.login()
    }
    
    func bindViewModel() {
        viewModel.configureObservable(password: passwordTextField.rx.text.orEmpty.asObservable(),
                                      username: usernameTextField.rx.text.orEmpty.asObservable())
        usernameTextField.rx.text.orEmpty
            .asObservable()
            .subscribe(onNext: { [weak self] in
                self?.viewModel.username = $0
            })
            .disposed(by: bag)
        viewModel.usernameErrTextHidden
            .bind(to: usernameErrTxt.rx.isHidden)
            .disposed(by: bag)
        viewModel.usernameErrText
            .bind(to: usernameErrTxt.rx.text)
            .disposed(by: bag)
        passwordTextField.rx.text.orEmpty
            .asObservable()
            .subscribe(onNext: { [weak self] in
                self?.viewModel.password = $0
            })
            .disposed(by: bag)
        viewModel.passwordErrTextHidden
            .bind(to: passwordErrTxt.rx.isHidden)
            .disposed(by: bag)
        viewModel.passwordErrText
            .bind(to: passwordErrTxt.rx.text)
            .disposed(by: bag)
        
        Observable.merge(viewModel.disabledLogin.map({!$0}),viewModel.isLoading.map({!$0}).skip(1))
            .distinctUntilChanged()
            .bind(to: loginBtn.rx.isEnabled)
            .disposed(by: bag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
}
