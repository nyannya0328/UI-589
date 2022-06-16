//
//  CustomCorner.swift
//  UI-589
//
//  Created by nyannyan0328 on 2022/06/16.
//

import SwiftUI

struct CustomCorner: Shape {
    
    var cornrer : UIRectCorner
    var radi : CGFloat
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: cornrer, cornerRadii: CGSize(width: radi, height: radi))
        
        return .init(path.cgPath)
    }
    
    
}

