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

    @objc var pickerView = SPUIPickerView()
    @objc public weak var delegate:EaseInputMenuStripopViewDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        Stipop.initialize()
        self.placeSubviews();
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func placeSubviews() {
        
//        let user = SPUser(userID: "some_user_id")
        let user = SPUser(userID: "9e86b370ba92cfb5d4cc6e6ce9df3acf")
        pickerView.setUser(user)
        pickerView.delegate = self
        
        self.addSubview(pickerView)
        pickerView.backgroundColor = UIColor.yellow
        
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        pickerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        pickerView.heightAnchor.constraint(equalToConstant: self.frame.size.height).isActive = true
        
    }

   
    
    public func spViewDidSelectSticker(_ view: SPUIView, sticker: SPSticker) {

        print("id: \(sticker.id)\n stickerImg =\(sticker.stickerImg)\n keyword =\(String(describing: sticker.keyword))\n sticker =\(sticker)\n")
        
        let urlString:String? = sticker.stickerImg
        let fileType:String? = urlString?.components(separatedBy: ".").last
        
        print("urlString: \(String(describing: urlString)) fileType: \(String(describing: fileType))")

        self.delegate?.selectedEmojiWithUrlString(urlString: urlString!, urlType: fileType!)
    }
}

extension EaseInputMenuStripopView {
     public func configure() -> Void {
        Stipop.initialize()
    }
}

@objc (EaseInputMenuStripopViewDelegate)

public protocol EaseInputMenuStripopViewDelegate:NSObjectProtocol {
    func selectedEmojiWithUrlString(urlString:String, urlType:String) -> Void
}
