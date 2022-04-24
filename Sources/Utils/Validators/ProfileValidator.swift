//
//  ProfileValidator.swift
//  
//
//  Created by Арман Чархчян on 13.04.2022.
//

import UIKit

public protocol ProfileValidatorProtocol: AnyObject {
    func validateSelectedAgeNoLess16(date: String) -> Bool
    func validateSelectedAge(with date: String) -> Bool
    func validateSelectedImage(userImage: UIImage) -> Bool
    func checkFilledInfo(username: String,
                         info: String,
                         sex: String,
                         birthday: String,
                         country: String,
                         city: String) -> Bool
}

public final class ProfileValidator: ProfileValidatorProtocol {
    
    public enum Error: LocalizedError {
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
    
    public init() { }
    
    public func validateSelectedAgeNoLess16(date: String) -> Bool {
        guard let age = Int(DateFormatService().getAge(date: date)) else { return false }
        return !(age < 16)
    }
    
    public func validateSelectedAge(with date: String) -> Bool {
        guard let age = Int(DateFormatService().getAge(date: date)) else { return false }
        return !(age > 120 || age < 1)
    }
    
    public func validateSelectedImage(userImage: UIImage) -> Bool {
        let image = UIImage(named: "people")
        return userImage != image
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
