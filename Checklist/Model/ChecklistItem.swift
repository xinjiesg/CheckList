//
//  ChecklistItem.swift
//  Checklist
//
//  Created by xin jie on 16/12/18.
//  Copyright © 2018 xinjie. All rights reserved.
//

import Foundation

class ChecklistItem {
    var text = ""
    var checked = false
    
    func toggleChecked(){
        checked = !checked
    }
}
