//
//  Whistle.swift
//  Project33
//
//  Created by Tanner Quesenberry on 4/23/19.
//  Copyright © 2019 Tanner Quesenberry. All rights reserved.
//

import UIKit
import CloudKit

class Whistle: NSObject {

    var recordID: CKRecord.ID!
    var genre: String!
    var comments: String!
    var audio: URL!
}
