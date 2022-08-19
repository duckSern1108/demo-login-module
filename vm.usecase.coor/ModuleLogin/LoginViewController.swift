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
    
    static func newVC(viewModel: LoginViewModel) -> LoginViewController {
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
        let passwordObservable = passwordTextField.rx.text.orEmpty
            .asObservable()
        let usernameObservable = usernameTextField.rx.text.orEmpty.asObservable()
        let passwordValid:Observable<Bool> = passwordObservable.map({ [weak viewModel] in
            viewModel?.validatePasswordStrategy.isValidPassword(pass: $0) ?? false
        })
        let usernameValid:Observable<Bool> = usernameObservable.map({ [weak viewModel] in
            viewModel?.validateUsernameStrategy.isValid(username: $0) ?? false
        })
        let disabledLogin = Observable.combineLatest(usernameValid, passwordValid) {
            !($0  && $1)
            
        }
        let usernameErrTextHidden:Observable<Bool> = Observable.combineLatest(usernameObservable, usernameValid) {
            if $0.count == 0 {
                return true
            }
            return $0.count > 0 && $1
        }
        let usernameErrText:Observable<String> = usernameObservable.map { [weak self] in
            guard let self = self else {
                return ""
            }
            return self.viewModel.validateUsernameStrategy.getErrText(username: $0)
        }
        
        let passwordErrText:Observable<String> = passwordObservable.map { [weak self] in
            guard let self = self else  {
                return ""
            }
            return self.viewModel.validatePasswordStrategy.getErrorText(pass: $0)
        }
        
        let passwordErrTextHidden:Observable<Bool> = Observable.combineLatest(passwordObservable, passwordValid) {
            if $0.count == 0 {return true}
            return $0.count > 0 && $1
        }
        usernameObservable
            .subscribe(onNext: { [weak self] in
                self?.viewModel.username = $0
            })
            .disposed(by: bag)
        usernameErrTextHidden
            .bind(to: usernameErrTxt.rx.isHidden)
            .disposed(by: bag)
        usernameErrText
            .bind(to: usernameErrTxt.rx.text)
            .disposed(by: bag)
        passwordObservable
            .subscribe(onNext: { [weak self] in
                self?.viewModel.password = $0
            })
            .disposed(by: bag)
        passwordErrTextHidden
            .bind(to: passwordErrTxt.rx.isHidden)
            .disposed(by: bag)
        passwordErrText
            .bind(to: passwordErrTxt.rx.text)
            .disposed(by: bag)
        
        Observable.merge(
            disabledLogin.map({!$0}),
            viewModel.isLoading.map({!$0}).skip(1)
        )
            .distinctUntilChanged()
            .bind(to: loginBtn.rx.isEnabled)
            .disposed(by: bag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
}
