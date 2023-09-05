//
//  RKCharacterSetType.swift
//  ServiceManager
//
//  Created by Bogdan Filippov on 9/5/23.
//  Copyright © 2023 Bogdan Filippov. All rights reserved.
//

/// Represents various character set types for encoding.
///
/// This enumeration provides commonly used character sets. It can be extended to include more character sets as required.
///
/// - Note: This is not an exhaustive list.
enum RKCharacterSetType: String, CaseIterable {
    
    // MARK: - Cases
    
    /// UTF-8 encoding.
    case utf8 = "utf-8"
    /// ASCII encoding.
    case ascii = "ascii"
    /// ISO Latin-1 encoding.
    case latin1 = "iso-8859-1"
    /// UTF-16 encoding.
    case utf16 = "utf-16"
    /// UTF-32 encoding.
    case utf32 = "utf-32"
    /// Windows 1252 encoding.
    case windows1252 = "windows-1252"
    /// ISO-2022-JP encoding.
    case iso2022JP = "iso-2022-jp"
    /// Shift JIS encoding.
    case shiftJIS = "shift_jis"
    /// EUC-JP encoding.
    case eucJP = "euc-jp"
    
    // MARK: - Properties
    
    /// The string representation of the character set.
    var value: String {
        return rawValue
    }
    
}
