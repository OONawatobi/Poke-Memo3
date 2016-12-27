//
//  Canvas.swift
//  Poke Memo
//
//  Created by 青山 行夫 on 2016/12/13.
//  Copyright © 2016年 mm289. All rights reserved.
//

import UIKit

class DrawableView: UIView {
    var Delegate: DrawableViewDelegate!//アッパーツールビューの操作を外部で処理（委託）する。
 //-----
    var lastDrawImage: UIImage!
    var lastPoint:CGPoint!//++++++++
    var tempImage:UIImage!
    var bezierPath: UIBezierPath!
 //---------------
    var pen:UIImage!
    var secondView: EditorView!//? UIView(secondView)を作成する
    var thirdView:UIView!//パレットの最前面ビュー（色フィルタ）カーソルビューも兼ねる
    var myImageView:UIImageView!//? UIImageViewを作成する.
 
    
    //----------- secondView(パレット前面フィルタ)の作成 --------------------------
    
    let myImg = UIImage(named: "blank.png")// 背景(メモの選択背景色と合わせる)
    
    /* セカンド・サードビューの初期化 */
    func setSecondView(){
        secondView = EditorView(frame: CGRect(x:0,y:0,width:self.bounds.width,height:self.bounds.height))
        secondView.setMyCursolView()
        //secondView.backgroundColor = UIColor(patternImage: myImg!)
        //secondView.addBothBorderWithColor(color: UIColor.orange, width: 2)
        
        secondView.isUserInteractionEnabled = false //イベントの透過
        // thirdViewの初期化：背景を緑色にする、先頭と末尾に印を追加する
        thirdView = UIView(frame: secondView.frame)
        
        thirdView.backgroundColor = UIColor(patternImage: myImg!)
        thirdView.addBothBorderWithColor(color: UIColor.green.withAlphaComponent(0.10), width: 15)
        
        thirdView.isUserInteractionEnabled = false //イベントの透過
 
        self.addSubview(secondView)
        self.addSubview(thirdView)
    }
    
    func delSubView(){//secondViewの取り出し
        secondView.removeFromSuperview()
    }
    func reAddSubView(){//secondViewの追加
        self.addSubview(secondView)
    }
    //--------------------　描画プログラム　---------------------------------/
    var rightFlag:Bool = false
    let rightArea:CGFloat = 20//右側エリア境界位置
    //var centerFlag:Bool = false
    //let centerArea:CGFloat = UIScreen.main.bounds.size.width/2//中央エリア境界位置
    var shiftLeftFlag:Bool = false
    var shiftDownFlag:Bool = false
    var X_color = 0//?
    //var startPoint:CGPoint!//タッチ開始点
    
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
        
        //右側エリアに入っているか判定
        let midX = self.frame.midX //Viewの中心のX座標を取得
        let screenX = currentPoint.x + midX - vWidth/2// 画面座標に変換
        rightFlag =  screenX > (boundWidth - rightArea) ? true:false
        print("screenX:\(screenX)")
    }
    
    // タッチが動いた
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesMoved")
        let currentPoint = touches.first!.location(in:self)//  @ self:UIView @
        
       //通常モード
       if rightFlag == false{
         if bezierPath == nil { return }
          //中間点を作成
        let midPoint = CGPoint(x: (lastPoint.x + currentPoint.x)/2, y: (lastPoint.y + currentPoint.y)/2)
        bezierPath.addQuadCurve(to: midPoint, controlPoint: lastPoint)
        drawLine(path:bezierPath)
        lastPoint = currentPoint
       }else{
        
       //右端エリアにタッチされた場合
        print(" is rightArea!!")
        //左自動シフトの判定
        let dX = lastPoint.x - currentPoint.x
        print(" is rightArea!!")
        let dY = lastPoint.y - currentPoint.y
        let dY2 = abs(dY)
        print(" is rightArea!!")
        if dX>20 && dY2<10{ shiftLeftFlag = true }//y軸方向の変化量が少ない時だけ実行する
       //下側へのシフト判定
        if dY < -50 && dX < 6{ shiftDownFlag = true }
        print("dx = \(dX), dY = \(dY)")
        
       }
        print("shiftLeftFlag = \(shiftLeftFlag)")
    }
    
    // タッチが終わった
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if rightFlag == false{
         let currentPoint = touches.first!.location(in:self)

         //posxの最大値を更新する
         mxTemp = max(mxTemp,currentPoint.x)
         print("mx: \(mxTemp)")

         if bezierPath == nil { return }
           bezierPath.addQuadCurve(to: currentPoint, controlPoint: lastPoint)
           drawLine(path: bezierPath)
            
        }else if shiftLeftFlag == true{
        // 左方向へのシフトを実施する:画面の５分の１だけ左側に表示する
            var dsX = vWidth/2 - mxTemp + boundWidth/5
            //右端制限
            dsX = dsX < (boundWidth - vWidth/2) ? (boundWidth - vWidth/2):dsX
            //左端制限
            dsX = dsX > vWidth/2 ? vWidth/2:dsX
            self.layer.position = CGPoint(x:dsX, y:boundHeight - 44 - vHeight/2)
        }else if shiftDownFlag == true{
            print("downFlag: \(shiftDownFlag)")
            self.Delegate?.selectNextGyou()
        }
        
        //右側エリアフラグのリセット
        shiftLeftFlag = false
        shiftDownFlag = false
        
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
 
