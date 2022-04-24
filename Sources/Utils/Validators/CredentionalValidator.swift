//
//  File.swift
//  
//
//  Created by Арман Чархчян on 12.04.2022.
//

import Foundation

public protocol CredentionalValidatorProtocol {
    func checkEmptyRegistration(email: String,
                                password: String,
                                confirmPassword: String) -> Bool
    func checkEmptyLogin(email: String, password: String) -> Bool
    func mailCorrectFormat(_ email: String) -> Bool
    func passwordsMatches(password: String, confirmed: String) -> Bool
}

public struct CredentionalValidator: CredentionalValidatorProtocol {
    
    public init() { }
    
    public enum Error: LocalizedError {
        case notFilled
        case invalidEmail
        case passwordsNotMatched
        
        public var errorDescription: String? {
            switch self {
            case .notFilled:
                return NSLocalizedString("Заполните все поля", comment: "")
            case .invalidEmail:
                return NSLocalizedString("Формат почты не является допустимым", comment: "")
            case .passwordsNotMatched:
                return NSLocalizedString("Пароли не совпадают", comment: "")
            }
        }
    }
    
    public func checkEmptyRegistration(email: String, password: String, confirmPassword: String) -> Bool {
        return !(email == "" || password == "" || confirmPassword == "")
    }
    
    public func checkEmptyLogin(email: String, password: String) -> Bool {
        return !(email == "" || password == "")
    }
    
    public func mailCorrectFormat(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    public func passwordsMatches(password: String, confirmed: String) -> Bool {
        return password == confirmed
    }
}
