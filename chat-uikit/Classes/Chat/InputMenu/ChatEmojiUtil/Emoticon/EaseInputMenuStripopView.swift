//
//  EaseInputMenuStripopView.swift
//  chat-uikit
//
//  Created by liu001 on 2022/4/26.
//

import Foundation
import Stipop
import UIKit

@objcMembers public class EaseInputMenuStripopView : UIView, SPUIDelegate{
    var pickerView = SPUIPickerView()
    
    @objc override init(frame: CGRect) {
        super.init(frame: frame)
        self.placeSubviews();
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func placeSubviews() {
        let user = SPUser(userID: "some_user_id")
        pickerView.setUser(user)
        pickerView.delegate = self

        self.addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        pickerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        pickerView.heightAnchor.constraint(equalToConstant: 500).isActive = true
    }

   
    
    public func spViewDidSelectSticker(_ view: SPUIView, sticker: SPSticker) {
//        pickerView.setSticker(sticker)
//        pickerView.setSticker(sticker.stickerImg)
        // Or, use stickerView.setSticker(sticker.stickerImg)
        
      }
}


