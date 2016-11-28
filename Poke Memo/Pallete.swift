//
//  Pallete.swift
//  Poke Memo
//
//  Created by 青山 行夫 on 2016/11/27.
//  Copyright © 2016年 mm289. All rights reserved.
//

import UIKit

class DrawableView: UIView {
    
    var pen:UIImage!
    var secondView: UIView!//? UIView(secondView)を作成する
    var myImageView:UIImageView!//? UIImageViewを作成する.
    
    class Line {
        var points: [CGPoint]
        var color :CGColor
        var width: CGFloat
        
        init(color: CGColor, width: CGFloat){
            self.color = color
            self.width = width
            self.points = []
        }
        
        func drawOnContext(context: CGContext){
            UIGraphicsBeginImageContext( CGSize(width:drawableView.frame.width,height:drawableView.frame.height ))
            
            //UIGraphicsPushContext(context)// push?
            
            context.setStrokeColor(self.color)
            context.setLineWidth(self.width)
            context.setLineCap(CGLineCap.round)
            
            // 2点以上ないと線描画する必要なし
            //path.move(to: CGPoint(x: 0, y: point.y))
            //path.addLine(to: CGPoint(x: self.frame.size.width, y: 0))
            if self.points.count > 1 {
                for (index, point) in self.points.enumerated() {
                    if index == 0 {
                        context.move(to:CGPoint(x: point.x, y: point.y))
                        //CGContextMoveToPoint(context, point.x, point.y)
                    } else {
                        context.addLine(to: CGPoint(x: point.x, y: point.y))
                        //CGContextAddLineToPoint(context, point.x, point.y)
                    }
                }
            }
            
            context.strokePath()
            //UIGraphicsPopContext()// pop?
            UIGraphicsEndImageContext()
        }
        
    }// * end of class Line *
    
    //----------- secondView(パレット前面フィルタ)の作成 --------------------------
    
    let myImg = UIImage(named: "blank.png")// 背景(メモの選択背景色と合わせる)
    
    /* パレットビューの初期化 */
    func setSecondView(){
        secondView = UIView(frame: CGRect(x:0,y:0,width:self.bounds.width,height:self.bounds.height))
        secondView.backgroundColor = UIColor(patternImage: myImg!)
        //secondView.addBothBorderWithColor(UIColor.lightGray, width: 8)
        
        /* ペンカーソルの表示：？今は未使用 */
        //myImageView = UIImageView(frame: CGRectMake(0,0,50,50))
        //secondView.addSubview(myImageView)
        
        self.addSubview(secondView)
        secondView.isUserInteractionEnabled = false //イベントの透過
    }
    
    func setPosx(x:CGFloat,y: CGFloat) {//ペンアイコンの表示位置を設定する
        //myImageView.image = pen
        myImageView.layer.position = CGPoint(x: x, y: y)
        //print("¥(myImageView.layer.position)")
    }
    
    //func hatena(pen:UIImage){
    //  myImageView.image = nil //pen
    //}
    
    func delSubView(){
        secondView.removeFromSuperview()
    }
    func reAddSubView(){
        self.addSubview(secondView)
    }
    //--------------------　描画プログラム　---------------------------------/
    //var lines: [Line] = []//lines →linedに変更：
    var lined:Line!//描画済のストロークを一時的に保存する @ @ @ @ @ 1
    var currentLine: Line? = nil
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
        let point = touches.first!.location(in: self)
        startPoint = point
        //右側エリアに入っているか判定
        let midX = self.frame.midX //Viewの中心のX座標を取得
        let screenX = point.x + midX - vWidth/2// 画面座標に変換
        if screenX > (boundWidth - rightArea) {//センターより右側
            rightFlag = true
        }else{ //センターより左側
            rightFlag = false
        }
        
        //消しゴミモードの判定
        if X_color == 0 { //ペンモード
            var myColor = UIColor.black.cgColor
            if penColorNum == 1{
                myColor = UIColor.black.cgColor
            }else if penColorNum == 2{
                myColor = UIColor.red.cgColor
            }else{
                myColor = UIColor.blue.cgColor
            }
            currentLine = Line(color: myColor, width: 6)//UIColor.blackColor().CGColor, width: 6)
            //pen = penImage1
        }else{ //消しゴムモード
            currentLine = Line(color: UIColor.white.cgColor, width: 20)
            //pen = penImage2
        }
        
        currentLine?.points.append(point)
        lined = nil// @ @ @ @ @ 2
    }
    
    // タッチが動いた
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self)//  @ self:UIView @
        //左自動シフトの判定
        if centerFlag == true && rightFlag == true{
            if startPoint.x - point.x > 10 && abs(startPoint.y - point.y) < 10{
                //print("startPoint.x - point.x >40")
                shiftLeftFlag = true//y軸方向の変化量が少ない時だけ実行する
                
            }
        }else if rightFlag == false{
            currentLine?.points.append(point)
            self.setNeedsDisplay()
        }
    }
    
    // タッチが終わった
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self)
        print("endPoint=  \(point)")
        print("maxRightPosX = \(maxRightPosX)")
        
        // CGFloat型の大きい方を返す?エラー対応：一旦Doubleに変換
        maxRightPosX = CGFloat(max(Double(point.x), Double(maxRightPosX)))
        print("MaxRightPosX = \(maxRightPosX)")
        
        // 2点以上のlineしか保存する必要なし
        if (currentLine?.points.count)! > 1 {
            //lines.append(currentLine!)//******Ver02 @ @ @ @ @ 3
        }
        
        lined = currentLine!// @ @ @ @ @ 7
        currentLine = nil//*******Ver02
        self.setNeedsDisplay()
        
        
        // X座標の位置、エリア情報の取得、フラグの設定
        let midX = self.frame.midX //Viewの中心のX座標を取得
        let screenX = point.x + midX - vWidth/2// 画面座標に変換
        if screenX > (boundWidth - centerArea) {//センターより右側
            if rightFlag == false{//しかし、右側からタッチした場合は除く
                centerFlag = true
            }
        }else{ //センターより左側
            centerFlag = false
        }
        
        if shiftLeftFlag{
            //パレットを左側にW/2シフトする
            var midX = self.frame.midX//Viewの中心のX座標を取得
            midX = midX - self.frame.width/6
            self.layer.position = CGPoint(x: midX, y:boundHeight - 44 - vHeight/2)
            shiftLeftFlag = false
            centerFlag = false
            
        }
        
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
    
    //描画設定
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        //画面を一旦初期化
        resetContext(context: context!)
        // 描き終わったline @ @ @ @ @
        //for line in lines {line.drawOnContext(context!)}// @ @ @ @ @ 4
        
        // 描き終わったline
        if  lined != nil {//(ペンアップの都度） @ @ @ @ @ 4
            print("|||||||||||||||||||||||||||||||||||||||||||")
            lined.drawOnContext(context: context!)// @ @ @ @ @ 4
            
            //パレットの内容をメモにコピーする(ペンアップの都度）※パレットのサイズ？
            if isEditMode == true{
                self.delSubView()//前フィルタ(subView)を取り除く
                let resize = CGRect(x:0,y:0,width:leafWidth,height:leafHeight)//
                let myImage1:UIImage = self.GetImageWithResize(resize: resize)
                //self.backgroundColor = UIColor(patternImage: myImage1)// @ @ @ @
                /*========================================================
                 let reSize = CGSize(width: leafWidth, height: leafHeight)
                 let leafImage = myImage1.resize(reSize)
                 //========================================================*/
                memoView.addMemo(img: myImage1,tag:nowGyouNo)
                //メモに書き出した内容をパレットに読み込む//20161024追加
                let myMemo:UIImage = memoView.readMemo(tag: nowGyouNo)
                self.backgroundColor = UIColor(patternImage:myMemo)// @ @ @ @
                self.reAddSubView()//前フィルタ(subView)を付加する
                lined = nil //20161024追加 @ @ @ @ @ 5
            }
        } //@ @ @ @ @ 4
        
        // 描いてる途中のline
        
        if  currentLine != nil {
            //print("** DOKO ***")
            currentLine!.drawOnContext(context: context!)//@@
            self.setNeedsDisplay()// @ @ @ @ @
        }else{ //currentLine == nil描き終わった時にdrawableViewの表示内容を同背景にコピーする
            print("** KOKO ***")
            
            secondView.backgroundColor = UIColor.clear//*****Ver02
            let myImage2:UIImage = self.GetImage()//*****Ver02
            self.backgroundColor = UIColor(patternImage: myImage2)//*****Ver02
            secondView.backgroundColor = UIColor(patternImage: myImg!)//前面フィルタに色を付ける
        }
    }
    
    func refresh() {
        
        currentLine = nil
        lined = nil// @ @ @ @ @ 6
        self.backgroundColor = UIColor.clear
        //lines = []//**** 20160904追加
        self.setNeedsDisplay()
    }
}
