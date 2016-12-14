//
//  Canvas.swift
//  Poke Memo
//
//  Created by 青山 行夫 on 2016/12/13.
//  Copyright © 2016年 mm289. All rights reserved.
//

import UIKit

class DrawableView: UIView {
 //-----
    var lastDrawImage: UIImage!
    var lastPoint:CGPoint!//++++++++
    var tempImage:UIImage!
    var bezierPath: UIBezierPath!
 //---------------
    var pen:UIImage!
    var secondView: UIView!//? UIView(secondView)を作成する
    var thirdView:UIView!//パレットの最前面ビュー（色フィルタ）
    var myImageView:UIImageView!//? UIImageViewを作成する.
 
    
    //----------- secondView(パレット前面フィルタ)の作成 --------------------------
    
    let myImg = UIImage(named: "blank.png")// 背景(メモの選択背景色と合わせる)
    
    /* セカンド・サードビューの初期化 */
    func setSecondView(){
        secondView = UIView(frame: CGRect(x:0,y:0,width:self.bounds.width,height:self.bounds.height))
        //secondView.backgroundColor = UIColor(patternImage: myImg!)
        //secondView.addBothBorderWithColor(color: UIColor.orange, width: 2)
        self.addSubview(secondView)
        secondView.isUserInteractionEnabled = false //イベントの透過
        // thirdViewの初期化
        thirdView = UIView(frame: secondView.frame)
        thirdView.backgroundColor = UIColor(patternImage: myImg!)
        thirdView.addBothBorderWithColor(color: UIColor.green.withAlphaComponent(0.15), width: 10)
        self.addSubview(thirdView)
        thirdView.isUserInteractionEnabled = false //イベントの透過
    }
    
    func delSubView(){
        secondView.removeFromSuperview()
    }
    func reAddSubView(){
        self.addSubview(secondView)
    }
    //--------------------　描画プログラム　---------------------------------/
    var rightFlag:Bool = false
    let rightArea:CGFloat = 20//右側エリア境界位置
    var centerFlag:Bool = false
    let centerArea:CGFloat = UIScreen.main.bounds.size.width/2//中央エリア境界位置
    var shiftLeftFlag:Bool = false
    var X_color = 0//?
    var startPoint:CGPoint!//タッチ開始点
    
    // タッチされた
    override func touchesBegan(_ touches:Set<UITouch>, with event: UIEvent?) {
        print("touchbegan")
        
        let currentPoint = touches.first!.location(in: self)
        print("currentPoint.x: \(currentPoint.x)")
        bezierPath = UIBezierPath()
        //bezierPath.lineCapStyle = kCGLineCapRound
        bezierPath.lineWidth = 1.0
        bezierPath.move(to:currentPoint)
        lastPoint = currentPoint//++++++++++
       // undoStack = lastDrawImage
 
    }
    
    // タッチが動いた
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesMoved")

        let currentPoint = touches.first!.location(in:self)//  @ self:UIView @
        if bezierPath == nil { return }
        //中間点を作成
        let midPoint = CGPoint(x: (lastPoint.x + currentPoint.x)/2, y: (lastPoint.y + currentPoint.y)/2)
            bezierPath.addQuadCurve(to: midPoint, controlPoint: lastPoint)
    
        drawLine(path:bezierPath)
        lastPoint = currentPoint
    }
    
    // タッチが終わった
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        let currentPoint = touches.first!.location(in:self)
        if bezierPath == nil { return }
        bezierPath.addQuadCurve(to: currentPoint, controlPoint: lastPoint)
        drawLine(path: bezierPath)
    }

    func resetContext(context: CGContext) {
        context.clear(self.bounds)
        if let color = self.backgroundColor {
            color.setFill()
        } else {
            UIColor.clear.setFill()
        }
        context.fill(self.bounds)
    }
 
    // 描画処理
    func drawLine(path:UIBezierPath) {
        
        //ペン色の設定
        var penColor:UIColor!
        var penW:CGFloat = 6
        if X_color == 0 { //ペンモード
               penColor = UIColor.black
            if penColorNum == 1{
                penColor = UIColor.black
            }else if penColorNum == 2{
                penColor = UIColor.red
            }else{
                penColor = UIColor.blue
            }
            //消しゴムモード
        }else{
            penColor = UIColor.white
            penW = 15
        }
        print("@@@@@@@@:::::\(penColor)")
        
        UIGraphicsBeginImageContext(self.frame.size)//Canvasを開く
    
        if lastDrawImage != nil { lastDrawImage.draw(at:CGPoint.zero)}
        //ペン色を指定する
        //penColor = UIColor.black//(red: 1, green: 0, blue: 0, alpha: 1)
        penColor.setStroke()
        path.lineWidth = penW//ペン幅を指定する
        path.stroke()
        
        lastDrawImage = UIGraphicsGetImageFromCurrentImageContext()!
        tempImage = lastDrawImage
        //タッチEnd時に画面を背景にコピーする
        print("p p p p p p p")
        secondView.backgroundColor = UIColor(patternImage: tempImage!)
        
        UIGraphicsEndImageContext()  //Canvasを閉じる
    }
 
 }
 
