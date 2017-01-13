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
    var lastXm:CGFloat = 0//一つ前のxm[]の値
    var lastPoint:CGPoint!//++++++++
    var tempImage:UIImage!
    var bezierPath: UIBezierPath!
 //---------------
    var pen:UIImage!
    var secondView: EditorView!//? UIView(secondView)を作成する
    var thirdView:UIView!//パレットの最前面ビュー（色フィルタ）カーソルビューも兼ねる
    var myImageView:UIImageView!//? UIImageViewを作成する.
 //-------   undo用バックアップ  -------------
    var bup = [String:(UIImage,CGFloat)]() //バックアップData["id":(img,mx)]
    var undoMode:Int = 0 //↑[2]:2,↑[1]:1,undo不可：0,undo中：8

    //:Undo/REDO
    func undo() {
        
        if undoMode == 2{
        if bup["0"] == nil{return}
          print("@@ redo @@")
          let im0 = bup["0"]?.0
          mxTemp = bup["0"]?.1
          secondView.backgroundColor = UIColor(patternImage: im0!)
          lastDrawImage = im0
          undoMode = 8
            
        }else if undoMode == 8{
          let im2 = bup["2"]?.0
          mxTemp = bup["2"]?.1
          secondView.backgroundColor = UIColor(patternImage: im2!)
          lastDrawImage = im2
          undoMode = 2
            
        }else if undoMode == 1{
        if bup["10"] == nil{return}
          let blankView = UIImage(named:"blankW.png")
          secondView.backgroundColor = UIColor(patternImage: blankView!)
          let im1 = bup["10"]?.0
          mxTemp = bup["10"]?.1
          drawableView.backgroundColor = UIColor(patternImage: im1!)
          lastDrawImage = nil
          bup["temp"] = bup["1"]
          bup["1"] = bup["10"]
          self.Delegate?.upToMemo()//パレット内容をメモに移す
          print("self.Delegate?.upToMemo()//パレット内容をメモに移す")
          undoMode = 7
            
        }else if undoMode == 7{
          let im1 = bup["temp"]?.0
          mxTemp = bup["temp"]?.1
          drawableView.backgroundColor = UIColor(patternImage: im1!)
          lastDrawImage = nil
          bup["1"] = bup["temp"]
          bup["temp"] = nil
          self.Delegate?.upToMemo()//パレット内容をメモに移す
          print("self.Delegate?.upToMemo()//パレット内容をメモに移す")
          undoMode = 1
        }
    }
    
    //SecondView画面を取得する
    func get2VImage(){
        print("get2VImage()")
        thirdView.removeFromSuperview()//3rdViewを取り出す
        let im = lastDrawImage//secondView.GetImage()
        self.addSubview(thirdView)//前フィルタ3rdViewを追加
        bup["2"] = (im!,mxTemp)
        undoMode = 2
    }
    
    //drawableView画面を取得する
    func get1VImage(){
        bup["10"] = bup["1"]
        thirdView.removeFromSuperview()//3rdViewを取り出す
        let im = self.GetImage()
        self.addSubview(thirdView)//前フィルタ3rdViewを追加
        bup["1"] = (im,mxTemp)
        undoMode = 1

    }

    
    //----------- secondView(パレット前面フィルタ)の作成 --------------------------
        let myImg = UIImage(named: "blank.png")// 背景(メモの選択背景色と合わせる)
        let myImg2 = UIImage(named: "blankP.png")// 背景(メモの選択背景色と合わせる)
    
    /* セカンド・サードビューの初期化 */
    func setSecondView(){
        secondView = EditorView(frame: CGRect(x:0,y:0,width:self.bounds.width,height:self.bounds.height))
        secondView.setMyCursolView()
        //secondView.backgroundColor = UIColor(patternImage: myImg!)
        //secondView.addBothBorderWithColor(color: UIColor.orange, width: 2)
        
        secondView.isUserInteractionEnabled = false //イベントの透過
        // ++ thirdViewの初期化：背景を緑色にする、先頭と末尾に印を追加する ++
        thirdView = UIView(frame: secondView.frame)
        
        thirdView.backgroundColor = UIColor(patternImage: myImg!)
        thirdView.addBothBorderWithColor(color: UIColor.green.withAlphaComponent(0.15), width: 15)
        
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
    var shiftLeftFlag:Bool = false
    var shiftDownFlag:Bool = false
    var X_color = 0//?
    
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
        
        print("◆◆◆◆")
        if lastDrawImage != nil{
          bup["0"] = (lastDrawImage,mxTemp)//)bup["2"]
        }
        
        //lastXm = mx[String(nowGyouNo)]!//◆◆◆◆

    }
    
    // タッチが動いた
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesMoved")
        if bezierPath == nil { return }//タッチされていない場合(Pathが初期化前)はパス
        let currentPoint = touches.first!.location(in:self)//  @ self:UIView @
        
       //通常モード
       if rightFlag == false{
        //mx最大値を取得
        mxTemp = max(mxTemp,currentPoint.x)
    
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

        if bezierPath == nil { return }
        if rightFlag == false{
            
         let currentPoint = touches.first!.location(in:self)
            
         //posxの最大値を更新する
         //mxTemp = max(mxTemp,currentPoint.x)
         print("end of mx: \(mxTemp)")
          //bup["temp"] = (lastDrawImage,mx[String(nowGyouNo)]!)
         bezierPath.addQuadCurve(to: currentPoint, controlPoint: lastPoint)
         drawLine(path: bezierPath)
            
         //print("◆◆◆◆ XXTend画面をバックアップする")
            get2VImage()//second画像をbup[2]に保存

        }else if shiftLeftFlag == true{
        // 左方向へのシフトを実施する:画面の５分の１だけ左側に表示する
            var dsX = vWidth/2 - mxTemp + boundWidth/5
            //右端制限
            dsX = dsX < (boundWidth - vWidth/2) ? (boundWidth - vWidth/2):dsX
            //左端制限
            dsX = dsX > vWidth/2 ? vWidth/2:dsX
            
            //アニメーション動作をさせる
            UIView.animate(withDuration: 0.3, animations: {
                () -> Void in
                self.layer.position = CGPoint(x:dsX, y:boundHeight - 44 - vHeight/2)
            })
            self.Delegate?.shiftMX()// [ok]ボタンを押す:view.done(done2)
        }else if shiftDownFlag == true{
            print("downFlag: \(shiftDownFlag)")
            self.Delegate?.selectNextGyou()//改行する
        }
        
        //右側エリアフラグのリセット
        shiftLeftFlag = false
        shiftDownFlag = false
    // == debug2 ==========================================================
        if debug2 == true{//@@ DEBUG2 @@
            testV.removeFromSuperview()
            drawableView.addSubview(testV)
            testV.layer.position = CGPoint(x: mxTemp, y:vHeight/2 )
        }
    // =====================================================================

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
        
    //---  ペン色などの設定  -----------------
        var penColor:UIColor!
        var penW:CGFloat = 7
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
    //---  描画実行  -----------------
        
        UIGraphicsBeginImageContext(self.frame.size)//Canvasを開く
        //前回までの描画を保存する
      
        if lastDrawImage != nil {
           lastDrawImage.draw(at:CGPoint.zero)
        }
  
        penColor.setStroke()
        path.lineWidth = penW//ペン幅を指定する
        path.stroke()//描画する

        lastDrawImage = UIGraphicsGetImageFromCurrentImageContext()!

        //タッチEnd時に画面を背景にコピーする
        secondView.backgroundColor = UIColor(patternImage: lastDrawImage!)

        UIGraphicsEndImageContext()  //Canvasを閉じる
    }
 
 }
 
