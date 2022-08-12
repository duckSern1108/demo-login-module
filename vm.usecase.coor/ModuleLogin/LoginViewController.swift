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
    
    
    init(usecase: LoginUseCase,
         coordinator: LoginCoordinator,
         validatePasswordStrategy: LoginPasswordValidateStrategy,
         usernameValidateStrategy: LoginUserNameValidateStrategy) {
        viewModel = LoginViewModel(useCase: usecase,
                                   coordinator: coordinator,
                                   validatePasswordStrategy: validatePasswordStrategy,
                                   validateUsernameStrategy: usernameValidateStrategy)
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @IBAction func onSignUpPress(_ sender: Any) {
        viewModel.coordinator.goToSignUp()
    }
    @IBAction func onLoginBtnPress(_ sender: Any) {
        viewModel.login()
    }
    
    func bindViewModel() {
        usernameTextField.rx.text.bind(to: viewModel.username).disposed(by: bag)
        viewModel.usernameErrTextHidden.bind(to: usernameErrTxt.rx.isHidden).disposed(by: bag)
        viewModel.usernameErrText.bind(to: usernameErrTxt.rx.text).disposed(by: bag)
        passwordTextField.rx.text.bind(to: viewModel.password).disposed(by: bag)
        viewModel.passwordErrTextHidden.bind(to: passwordErrTxt.rx.isHidden).disposed(by: bag)
        viewModel.passwordErrText.bind(to: passwordErrTxt.rx.text).disposed(by: bag)
        viewModel.disabledLogin.bind(to: loginBtn.rx.isEnabled).disposed(by: bag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
}
