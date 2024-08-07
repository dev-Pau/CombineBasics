//
//  CombineBasicsViewModel.swift
//  CombineBasics
//
//  Created by PdePau on 7/8/24.
//

import Foundation
import Combine

class CombineBasicsViewModel: ObservableObject {
    
    private var bindings = Set<AnyCancellable>()
    
    @Published var username = ""
    @Published var password = ""
    @Published var repeatPassword = ""
    
    @Published var isValid = false
    
    @Published var usernameError: UsernameError? = nil
    @Published var passwordError: PasswordError? = nil
    
    private var usernameIsValidResult: AnyPublisher<Bool, Never> {
        $username
            .debounce(for: 0.6, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { username in
                return username.trimmingCharacters(in: .whitespaces).count >= 5
            }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordEmptyResult: AnyPublisher<Bool, Never> {
        $password
            .debounce(for: 0.6, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { password in
                return password.trimmingCharacters(in: .whitespaces).isEmpty
            }
            .eraseToAnyPublisher()
    }
    
    private var arePasswordsEqualResult: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($password, $repeatPassword)
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .map { password, repeatPassword in
                return password == repeatPassword
            }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordStrongResult: AnyPublisher<Bool, Never> {
        $password
            .debounce(for: 0.6, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { password in
                return password.count >= 5
            }
            .eraseToAnyPublisher()
    }
    
    private var passwordIsValidResult: AnyPublisher<PasswordError?, Never> {
        Publishers.CombineLatest3(isPasswordEmptyResult, arePasswordsEqualResult, isPasswordStrongResult)
            .map { passwordIsEmpty, passwordsAreEqual, passwordIsStrongEnough in
                if passwordIsEmpty {
                    return .empty
                } else if !passwordsAreEqual {
                    return .match
                } else if !passwordIsStrongEnough {
                    return .weak
                } else {
                    return nil
                }
            }
            .eraseToAnyPublisher()
    }
    
    private var isFormValidResult: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(usernameIsValidResult, passwordIsValidResult)
            .map { usernameIsValid, passwordIsValid in
                return usernameIsValid && (passwordIsValid == nil)
            }
            .eraseToAnyPublisher()
    }
    
    init() {
        isFormValidResult
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &bindings)
        
        usernameIsValidResult
            .receive(on: RunLoop.main)
            .map { valid in
                valid ? nil : UsernameError.length
            }
            .assign(to: \.usernameError, on: self)
            .store(in: &bindings)
        
        passwordIsValidResult
            .receive(on: RunLoop.main)
            .assign(to: \.passwordError, on: self)
            .store(in: &bindings)
    }
}
