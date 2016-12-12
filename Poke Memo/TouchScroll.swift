//
//  TouchScroll.swift
//  Poke Memo
//
//  Created by 青山 行夫 on 2016/11/27.
//  Copyright © 2016年 mm289. All rights reserved.
//

import UIKit

class TouchScrollView: UIScrollView ,UIScrollViewDelegate{//スクロールビュー　※プロトコルは付加されていない？
    
    var Delegate2: ScrollView2Delegate!
    //UIScrollViewDelegate?//スクロールビューの操作を外部で処理（委託）する。
    //var Delegate3:UIScrollViewDelegate!
    
    var rightFlag = false//右側エリアでタッチされた場合
    var startPointX: CGFloat!//タッチ開始X座標
    var shiftLeftFlag = false//左方向へのスワイプ発生
    var pageView:[UIView]!
    var iV:UIView!//IV:index
    var aV:UIView!
    var bV:UIView!
    var isLongPushed:Bool! = false//セルの長押し発生フラグ
    //var selectedTag:Int = 0//タッチされたリーフのTag番号:nowGyouNoがあるので不要
    
    override func touchesBegan(_ touches:Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self)
        startPointX = point.x
        var screenX:CGFloat = 0
        isLongPushed = false//長押しフラグをリセットする
        //
        //右側エリアに入っているか判定
        //let midX = CGRectGetMidX(self.frame) //==Viewの中心のX座標を取得
        //let screenX = point.x + midX - vWidth/2 //== 画面座標に変換
        if Float(point.x) <= Float(leafWidth) { screenX = point.x }
        else if Float(point.x) <= Float(leafWidth*2 ){ screenX = point.x - leafWidth }
        else { screenX = point.x - leafWidth*2 }
        
        if screenX > (leafWidth - 40) {//==右側から40
            rightFlag = true
        }else{
            rightFlag = false
        }
        shiftLeftFlag = false
        //
        print("touches.x:startX= \(startPointX)")
        print("touches.x:screenX= \(screenX)")
        //print("touches.x:midX= \(midX)")
        print("touchbegan:rightFla= \(rightFlag)")
        for touch: UITouch in touches{
            let tag = touch.view!.tag
            if tag != 0{
                self.Delegate2?.modalChanged(TouchNumber: tag)
                //selectedTag = tag
            }
        }
        
    }
    
    //タッチして動かしたときの処理
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self)
        
        //左自動シフトの判定
        if rightFlag == true{
            if startPointX - point.x > 60{
                print("startPoint.x - point.x >60")
                shiftLeftFlag = true//?y軸方向の変化量が少ない時だけ実行する
            }
        }
        print("touchmoved:\(rightFlag)")
        
    }
    //タッチして離したときの処理
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("shiftLeftFlag = \(shiftLeftFlag)")
    
        if shiftLeftFlag == true{
            //gotoNextPage()//Tshow_4thFrame()
        }
     
        print("touchended")
        //isLongPushed = false//長押しフラグをリセットする
        
    }
}

// ------------------------------------------------------------------

class UpperToolView: UIView {
    var Delegate: UpperToolViewDelegate!//アッパーツールビューの操作を外部で処理（委託）する。
    var startX:CGFloat!//タッチ点のｘ座標
    var deltaX:CGFloat!//タッチ後の移動距離（ｘ）
    var midX:CGFloat!//drawableViewの中心のX座標を取得
    // タッチされた
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self)
        startX = point.x
        midX = drawableView.frame.midX//Viewの中心のX座標を取得
    }
    // タッチが動いた
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self)
        deltaX = startX - point.x
        deltaX = deltaX/1
        let nextMidX = midX - deltaX
        self.Delegate?.dispPosChange(midX: nextMidX)
    }
    // タッチが終わった
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 2点以上のlineしか保存する必要なし
        //if currentLine?.points.count > 1 {//lines.append(currentLine!)//Ver02}
        
    }
    

}
