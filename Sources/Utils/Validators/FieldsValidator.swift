//
//  File.swift
//  
//
//  Created by Арман Чархчян on 12.04.2022.
//

import UIKit

public protocol ProfileValidatorProtocol {
    func validateSelectedAgeNoLess16(date: String) -> Bool
    func validateSelectedAge(with date: String) -> Bool
    func checkFilledInfo(username: String,
                         info: String,
                         sex: String,
                         birthday: String,
                         country: String,
                         city: String) -> Bool
}

public protocol CredentionalValidatorProtocol {
    func checkEmptyRegistration(email: String,
                                password: String,
                                confirmPassword: String) -> Bool
    func checkEmptyLogin(email: String, password: String) -> Bool
    func mailCorrectFormat(_ email: String) -> Bool
    func passwordsMatches(password: String, confirmed: String) -> Bool
}

public struct FieldsValidator {
    
    public init() { }

}

extension FieldsValidator: CredentionalValidatorProtocol {
    
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

extension FieldsValidator: ProfileValidatorProtocol {
    
    public func validateSelectedAgeNoLess16(date: String) -> Bool {
        guard let age = Int(DateFormatService().getAge(date: date)) else { return false }
        return !(age < 16)
    }
    
    public func validateSelectedAge(with date: String) -> Bool {
        guard let age = Int(DateFormatService().getAge(date: date)) else { return false }
        return !(age > 120 || age < 1)
    }
    
    public func checkFilledInfo(username: String,
                                info: String,
                                sex: String,
                                birthday: String,
                                country: String,
                                city: String) -> Bool {
        return !(username == "" || info == "" || sex == "" || birthday == "" || country == "" || city == "")
    }
}

public enum ValidationError {

    public enum Profile: LocalizedError {
        case notFilled
        case photoNotAdded
        case ageLess16
        case ageNotValid
        
        public var errorDescription: String? {
            switch self {
            case .notFilled:
                return NSLocalizedString("Заполните все поля", comment: "")
            case .photoNotAdded:
                return NSLocalizedString("Вы не добавили фото", comment: "")
            case .ageLess16:
                return NSLocalizedString("Вам нет 16-ти лет", comment: "")
            case .ageNotValid:
                return NSLocalizedString("Пожалуйста, введите корректную дату рождения", comment: "")
            }
        }
    }
    
    public enum Credentionals: LocalizedError {
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
}
