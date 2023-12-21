//
//  RequestKit+String.swift
//  ServiceManager
//
//  Created by Bogdan Filippov on 12/18/23.
//  Copyright © 2023 Bogdan Filippov. All rights reserved.
//

import Foundation

extension String {
    
    // MARK: - Properties
    
    /// A computed property that returns the localized version of the string.
    var localize: String {
        let localizedString = NSLocalizedString(self, comment: "")
        
        if localizedString != self {
            return localizedString
        } else if let code = Locale.current.languageCode, let localized = localize(code), localized != self {
            return localized
        } else if let localized = localize("en"), localized != self {
            return localized
        } else {
            return self
        }
    }
    
    // MARK: - Methods
    
    /// Localizes the string using the given arguments and format.
    func localized(withArguments arguments: CVarArg...) -> String {
        return String(format: localize, arguments: arguments)
    }
    
    /// Localizes the string using an array of arguments and format.
    func localized(withArgumentArray arguments: [CVarArg]) -> String {
        return String(format: localize, arguments: arguments)
    }
    
    /// Private helper function to localize the string for a specific language code.
    private func localize(_ code: String) -> String? {
        guard let path = Bundle.main.path(forResource: code, ofType: "lproj"), let bundle = Bundle(path: path) else {
            return nil
        }

        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
    
}
