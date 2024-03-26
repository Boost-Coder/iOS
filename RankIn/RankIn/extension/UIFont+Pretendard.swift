//
//  FontManager.swift
//  RankIn
//
//  Created by 조성민 on 3/21/24.
//

import UIKit

extension UIFont {
    
    enum Pretendard: String {
        
        case regular = "Pretendard-Regular"
        case thin = "Pretendard-Thin"
        case extraLight = "Pretendard-ExtraLight"
        case light = "Pretendard-Light"
        case medium = "Pretendard-Medium"
        case semiBold = "Pretendard-SemiBold"
        case bold = "Pretendard-Bold"
        case extraBold = "Pretendard-ExtraBold"
        case black = "Pretendard-Black"
        
    }
    
    func pretendard(type: Pretendard, size: CGFloat) -> UIFont {
        return UIFont(name: type.rawValue, size: size) ?? UIFont()
    }
    
}
