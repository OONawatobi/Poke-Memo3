//
//  Help.swift
//  Happy Memo
//
//  Created by 青山 行夫 on 2017/02/15.
//  Copyright © 2017年 mm289. All rights reserved.
//

import UIKit

class HelpView:UIWebView{
    
    var pathJPN = Bundle.main.path(forResource:"indexJa",ofType:"html")
    var pathENG:String = Bundle.main.path(forResource:"indexEn",ofType:"html")!
    var urlX:URL!
    //var Delegate: HelpViewDelegate!
    // リクエストを生成する
    func req(lang:Int){
        let pathX = (lang == 0) ? pathJPN :pathENG
        //urlX = URL(string: "http://www.apple.com")!
        urlX = URL(string: pathX!)

        if urlX == nil{ print(" @urlX = URL(pathX) = nil ");return}
        let urlRequest = URLRequest(url: urlX!)
        self.loadRequest(urlRequest)// 指定したページを読み込む
    }

}
