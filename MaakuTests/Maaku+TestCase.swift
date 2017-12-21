//
//  Maaku+TestCase.swift
//  MaakuTests
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

import XCTest

/// XCTestCase extension methods.
extension XCTestCase {
    
    /// Loads the specified example from the current Bundle and returns the contents as a String.
    ///
    /// - Parameters:
    ///     - name: The filename (without extension).
    ///     - ofType: The file extension type.  The default is "md".
    ///
    /// - Returns:
    ///     The example as a String if it could be loaded, nil otherwise.
    func loadExample(_ name: String, ofType: String = "md") -> String? {
        let bundle = Bundle(for: type(of: self))
        
        if let path = bundle.path(forResource: name, ofType: ofType),
            let text: String = try? String(contentsOfFile: path) {
            return text
        }
        
        return nil
    }
    
    /// Loads the specified example from the current Bundle and returns the contents as Data.
    ///
    /// - Parameters:
    ///     - name: The filename (without extension).
    ///     - ofType: The file extension type.  The default is "md".
    ///
    /// - Returns:
    ///     The example as Data if it could be loaded, nil otherwise.
    func loadExampleData(_ name: String, ofType: String = "md") -> Data? {
        let bundle = Bundle(for: type(of: self))
        
        if let url = bundle.url(forResource: name, withExtension: ofType),
            let data = try? Data(contentsOf: url) {
            return data
        }
        
        return nil
    }
}
