//
//  UIViewController+Toast.swift
//  RankIn
//
//  Created by 조성민 on 4/17/24.
//

import UIKit
import Toast_Swift

enum ErrorToastCase: Error {
    
    case clientError
    case serverError
    case internetError
    
}

extension UIViewController {
    
    enum ToastCase {
        
        case duplicatedNickname
        case noNicknameInput
        case noGradeInput
        case invalidGradeInput
        case sejongLoginFailed
        case gitHubAuthorizationFailed
        case noBaekjoonIDInput
        case invalidBaekjoonIDInput
        
    }
    
    func presentToast(toastCase: ToastCase) {
        switch toastCase {
        case .duplicatedNickname:
            self.view.makeToast("중복된 닉네임입니다\n 다른 닉네임을 입력해주세요")
        case .noNicknameInput:
            self.view.makeToast("닉네임을 입력해주세요")
        case .noGradeInput:
            self.view.makeToast("학점을 입력해주세요")
        case .invalidGradeInput:
            self.view.makeToast("소수점 두자리 까지의 형식으로 학점을 입력하세요\n예시 : 3.94")
        case .sejongLoginFailed:
            self.view.makeToast("로그인에 실패했습니다\n아이디와 비밀번호를 확인해주세요")
        case .gitHubAuthorizationFailed:
            self.view.makeToast("GitHub 인증에 실패했습니다")
        case .noBaekjoonIDInput:
            self.view.makeToast("백준 ID를 입력해주세요")
        case .invalidBaekjoonIDInput:
            self.view.makeToast("백준 ID 인증에 실패했습니다")
        }
    }
    
    func presentErrorToast(error: ErrorToastCase) {
        switch error {
        case .clientError:
            self.view.makeToast("알 수 없는 오류가 발생했습니다")
        case .serverError:
            self.view.makeToast("서버 오류가 발생했습니다")
        case .internetError:
            self.view.makeToast("인터넷 연결을 확인하세요")
        }
    }
    
}
