//
//  CGUMXPDFDocument.swift
//  Pods
//
//  Created by Chris Anderson on 3/5/16.
//
//

import Foundation

public enum CGUMXPDFDocumentError: Error {
    case fileDoesNotExist
    case passwordRequired
    case couldNotUnlock
    case unableToOpen
}

extension CGUMXPDFDocument {
    
    public static func create(url: URL, password: String?) throws -> CGUMXPDFDocument {
        guard let docRef = CGUMXPDFDocument((url as CFURL)) else {
            throw CGUMXPDFDocumentError.fileDoesNotExist
        }
        
        if docRef.isEncrypted {
            try CGUMXPDFDocument.unlock(docRef: docRef, password: password)
        }
        
        return docRef
    }
    
    public static func create(data: NSData, password: String?) throws -> CGUMXPDFDocument {
        guard let dataProvider = CGDataProvider(data: data),
            let docRef = CGUMXPDFDocument(dataProvider) else {
            throw CGUMXPDFDocumentError.fileDoesNotExist
        }
        
        if docRef.isEncrypted {
            try CGUMXPDFDocument.unlock(docRef: docRef, password: password)
        }
        
        return docRef
    }
    
    public static func unlock(docRef: CGUMXPDFDocument, password: String?) throws {
        if docRef.unlockWithPassword("") == false {
            
            guard let password = password else {
                throw CGUMXPDFDocumentError.passwordRequired
            }
            
            docRef.unlockWithPassword((password as NSString).utf8String!)
        }
        
        if docRef.isUnlocked == false {
            throw CGUMXPDFDocumentError.couldNotUnlock
        }
    }
}
