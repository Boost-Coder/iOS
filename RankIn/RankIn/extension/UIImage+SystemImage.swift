//
//  UIImage+SystemImage.swift
//  RankIn
//
//  Created by 조성민 on 3/28/24.
//

import UIKit

extension UIImage {
    
    enum SystemImage {
        
        case appleLogo
        
    }
    
    static func systemImage(systemImage: SystemImage) -> UIImage {
        switch systemImage {
        case .appleLogo:
            return UIImage(systemName: "apple.logo")!
        }
    }
    
}
