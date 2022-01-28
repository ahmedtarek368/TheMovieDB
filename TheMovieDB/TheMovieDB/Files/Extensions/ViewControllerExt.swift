//
//  ViewControllerExt.swift
//  TheMovieDB
//
//  Created by Ahmed Tarek on 28/01/2022.
//

import UIKit
import RxSwift

enum AlertStyle{
    case reguler, withButton
}

extension UIViewController{
    
    func popBack(_ nb: Int) {
        if let viewControllers: [UIViewController] = self.navigationController?.viewControllers {
            guard viewControllers.count < nb else {
                self.navigationController?.popToViewController(viewControllers[viewControllers.count - nb], animated: true)
                return
            }
        }
    }
    
    func subscribeToAlert(viewModel: AlertObservable, disposeBag: DisposeBag) {
        viewModel.alertObservable.observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] (alert) in
            guard let self = self else {return}
            if alert != "" {
                self.showAlert(with: .reguler, msg: alert)
            }
        }).disposed(by: disposeBag)
    }
    
    func showAlert(with Style: AlertStyle, msg: String,  compilition: (() -> Void)? = nil){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
            
            switch Style{
            case .reguler:
                Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (_) in
                    alert.dismiss(animated: true){
                        compilition?()
                    }
                }
                break
                
            case .withButton:
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                break
            }
            
            self.present(alert, animated: true)
        }
    }
}


extension UICollectionViewFlowLayout{
    
//    open override var flipsHorizontallyInOppositeLayoutDirection: Bool{
//        return true
//    }
    
//    open override var developmentLayoutDirection: UIUserInterfaceLayoutDirection{
//        if "lang".localized == "ar"{
//            return UIUserInterfaceLayoutDirection.leftToRight
//        }else{
//            return UIUserInterfaceLayoutDirection.rightToLeft
//        }
//
//    }
}
