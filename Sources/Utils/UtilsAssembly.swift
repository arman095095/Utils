//
//  File.swift
//  
//
//  Created by Арман Чархчян on 29.04.2022.
//

import Foundation
import Swinject

public final class UtilsAssembly: Assembly {
    public init() { }
    public func assemble(container: Container) {
        
        container.register(CredentionalValidatorProtocol.self) { r in
            FieldsValidator()
        }.implements(ProfileValidatorProtocol.self)
        
        container.register(DateFormatServiceProtocol.self) { r in
            DateFormatService()
        }
    }
}
