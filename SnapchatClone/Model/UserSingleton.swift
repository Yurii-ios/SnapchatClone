//
//  UserSingleton.swift
//  SnapchatClone
//
//  Created by Yurii Sameliuk on 21/02/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import Foundation

class UserSingleton {
    static var sharedUserInfo = UserSingleton()
    
    var email = ""
    var username = ""
    
    
    private init() {
        
    }
}
