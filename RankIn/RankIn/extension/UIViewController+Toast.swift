//
//  UIViewController+Toast.swift
//  RankIn
//
//  Created by 조성민 on 4/17/24.
//

import UIKit
import Toast_Swift

extension UIViewController {
    
    enum ToastCase {
        
        case duplicatedNickname
        case noInput
        
    }
    
    func presentToast(toastCase: ToastCase) {
        switch toastCase { // TODO: Toast 띄우기
        case .duplicatedNickname:
            self.view.makeToast("중복된 닉네임입니다\n 다른 닉네임을 입력해주세요")
        case .noInput:
            self.view.makeToast("닉네임을 입력해주세ㅇ")
        }
    }
    
}
