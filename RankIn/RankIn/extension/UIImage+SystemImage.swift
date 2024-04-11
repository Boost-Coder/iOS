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
        case chartBar
        case person
        
    }
    
    static func systemImage(systemImage: SystemImage) -> UIImage {
        switch systemImage {
        case .appleLogo:
            return UIImage(systemName: "apple.logo")!
        case .chartBar:
            return UIImage(systemName: "chart.bar")!
        case .person:
            return UIImage(systemName: "person")!
        }
    }
    
}
