//
//  ModuleOwner.swift
//  ABCoreComponent
//
//  Created by Ganesh Reddiar on 6/6/19.
//

import Foundation

public protocol ModuleOwner: class {
   // func module <M: Module> (_ moduleId: ModuleID, type: M.Type) -> M?
}

public extension ModuleOwner {
    /**func module <M: Module> (_ moduleId: ModuleID, type: M.Type) -> M? {
        let module = type.init(owner: self)
        return module
    }**/

}


