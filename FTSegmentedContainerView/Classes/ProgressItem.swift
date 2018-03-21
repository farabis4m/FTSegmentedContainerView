//
//  ProgressItem.swift
//  Stories
//
//  Created by Aswin Babu on 3/21/18.
//  Copyright © 2018 Thahir Maheen. All rights reserved.
//


import Foundation

public class ProgressItem {
    
    public typealias CompletionHanlder = () -> ()
    
    let duration: Double!
    let handler: CompletionHanlder?
    
    public init(withDuration duration: Double, handler completion: CompletionHanlder? = nil) {
        self.duration = duration
        self.handler = completion
    }
}
