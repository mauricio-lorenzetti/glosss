//
//  Data+.swift
//  glosss
//
//  Created by Mauricio Lorenzetti on 20/01/21.
//

import Foundation

public extension Data {
    func mapObject<T: Codable>(_ resultType: T.Type) -> T? {
        do {
            return try JSONDecoder().decode(T.self, from: self)
        } catch let error {
            print(  "[mapObject] Error \(error.localizedDescription) " +
                    "while decoding \(resultType) " +
                    " \n Data content: \(String(data: self, encoding: .utf8) ?? "")")
            return nil
        }
    }
}
