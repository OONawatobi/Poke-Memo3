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
    var bup = [String:(UIImage,CGFloat)]() //["key":(img,mx)]
    //key⇒ (["0"],["1"],["2"],["7"],["8"],["temp"])
    var undoMode:Int = 0 //[0,1,2,7,8]
    
    //:Undo/REDO
    func undo() {
        
        if undoMode == 2{//secondView上の処理
          if bup["0"] == nil{return}
          print("@@ redo @@")
          let im0 = bup["0"]?.0
          mxTemp = bup["0"]?.1
          secondView.backgroundColor = UIColor(patternImage: im0!)
          lastDrawImage = im0
          undoMode = 8
            
        }else if undoMode == 8{//undo処理直後
          let im2 = bup["2"]?.0
          mxTemp = bup["2"]?.1
          secondView.backgroundColor = UIColor(patternImage: im2!)
          lastDrawImage = im2
          undoMode = 2
            
        }else if undoMode == 1{//okボタンが押された直後
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
            
        }else if undoMode == 7{//undo処理が行われた直後
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
    //undo関係のリセット
    func resetUndo(){
         undoMode = 0
         //bup["0"] = nil
         //bup["10"] = nil
         //bup["1"] = nil
         bup["2"] = nil
         bup["temp"] = nil
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
    var X_color = 0
    var autoScrollFlag:Bool = false//自動スクロールフラグ
    var moveFlag:Bool = false// タッチしている時にtrue
    var sCount:Int16 = 0//?
    var timer:Timer!
    var myMx:CGFloat = 0 //今回タッチした最大X座標(タイマースクロール用）
    
    // タッチされた
    override func touchesBegan(_ touches:Set<UITouch>, with event: UIEvent?) {
        print("touchbegan")
  
        let currentPoint = touches.first!.location(in: self)
        print("currentPoint.x: \(currentPoint.x)")
        bezierPath = UIBezierPath()
        bezierPath.lineWidth = 1.0
        bezierPath.move(to:currentPoint)
        lastPoint = currentPoint//++++++++++
       // undoStack = lastDrawImage
        
        //右側エリアに入っているか判定
        let midX = self.frame.midX //ControllViewからみたdrawableVの中心X座標
        let b = (bigFlag == true) ? big :1//拡大時に位置を補正する
        let screenX = b*(currentPoint.x) + (midX - b*vWidth/2)    // 画面座標に変換
        
        rightFlag =  screenX > (boundWidth - rightArea) ? true:false
        print("screenX:\(screenX)")
        print("◆◆◆◆")
        if lastDrawImage != nil{
          bup["0"] = (lastDrawImage,mxTemp)//)bup["2"]
        }
        //lastXm = mx[String(nowGyouNo)]!//◆◆◆◆
        setPen()//線巾、線色の設定
        sCount = 0//?
        // ++ ラインキャップ++++
        if  bigFlag == true{
            bezierPath.lineCapStyle = .round
        }else{
            bezierPath.lineCapStyle = .round
        }
        //+++++++++1:自動スクロール関係検証用
        autoScrollFlag = false//自動スクロールをリセットする
        if timer != nil{timer.invalidate()}
        //+++++++++2:新タッチシステム検証用
        UIGraphicsBeginImageContext(self.frame.size)//Canvasを開く
        if lastDrawImage != nil {
            lastDrawImage.draw(at:CGPoint.zero)
        }

    }
    
    // タッチが動いた
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesMoved\(sCount)")
        
        if bezierPath.isEmpty == true { return }//タッチされていない場合(Pathが初期化前)はパス
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

        //自動スクロール機能
        if bigFlag == false{
          //myMx最大値を取得
          myMx = max(myMx,currentPoint.x)
          if myMx >= mxTemp{
            let midX = self.frame.midX //スクリーンViewから見たパレット中心X座標
            let screenX = myMx + (midX - vWidth/2)    // 画面座標に変
            autoScrollFlag =  screenX > (boundWidth - rightArea*3) ? true:false
          }
        }

       }else{
        
       //右端エリアにタッチされた場合
        print(" is rightArea!!")
        //左シフトの判定
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
        sCount = sCount + 1//?
    }
    
    // タッチが終わった
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //moveFlag == false//タッチ状態終了
        if bezierPath == nil { return }
        //------- 右端エリア以外にタッチされた場合 -------
        if rightFlag == false{
            
         let currentPoint = touches.first!.location(in:self)
         bezierPath.addQuadCurve(to: currentPoint, controlPoint: lastPoint)
         drawLine(path: bezierPath)
        //ココに何か入るのか？？？画面をパレット背面にコピーする
            
         get2VImage()//second画像をbup[2]に保存：UNDO用
        //左方向への自動スクロール
            if bigFlag == false{ startTimer()}//遅延してスクロール
            
        //------- 右端エリアにタッチされた場合 -------
        }else if shiftLeftFlag == true && bigFlag == false{//拡大モードではパス
            scrollLeft()// 左方向へのフリップスクロール

        }else if shiftDownFlag == true && bigFlag == false{//拡大モードではパス
            print("downFlag: \(shiftDownFlag)")
            self.Delegate?.selectNextGyou()//改行する
        }
        
        //---- 右側エリアフラグのリセット ----
        shiftLeftFlag = false
        shiftDownFlag = false
        
      // == debug2 ================================================
        if debug2 == true{//@@ DEBUG2 @@
            testV.removeFromSuperview()
            drawableView.addSubview(testV)
            testV.layer.position = CGPoint(x: mxTemp, y:vHeight/2)
        }
      // ==========================================================
        UIGraphicsEndImageContext()  //Canvasを閉じる
    }
    
    // タイマー開始
    func startTimer() {
      //左方向への自動スクロール
       if autoScrollFlag == true{
 
          timer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(DrawableView.timerAction), userInfo: nil, repeats: false)
       }
    }

    ///タイマーアップ時の処理
    func timerAction(){
        if autoScrollFlag == false {return}
        scrollLeft()
        myMx = 0//スクロール実施後、タッチ最大ｘをリセット
    }
    /// 左方向へのスクロール
    func scrollLeft(){
        
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
    //ペン色、線幅の設定
    var penC:UIColor!
    var penW:CGFloat = 7
    
    func setPen(){
        if X_color == 0 { //ペンモード
            //ペン巾の変更
            switch lineWidth {
               case 0:penW = 5
               case 1:penW = 7
               case 2:penW = 9
               default:break
            }
            penC = UIColor.black
            if penColorNum == 1{
                penC = UIColor.black
            }else if penColorNum == 2{
                penC = UIColor.red
            }else{//第３番目の色：設定色
               switch lineColor {
                case 0:penC = UIColor.blue
                case 1:penC = UIColor.green
                case 2:penC = UIColor.brown
                default:break
               }
                
            }
        //消しゴムモード
        }else{
            penC = UIColor.white
            penW = 15//消しゴムの巾
        }
        
        print("@@@@@@@@:::::\(penC)")
    }
 
    // 描画処理
    func drawLine(path:UIBezierPath) {
        
    //---  描画実行  -----------------
        let penColor = penC
        //let penW2 = penW
        //UIGraphicsBeginImageContext(self.frame.size)//Canvasを開く
        //前回までの描画を保存する
  //??????????????????????????????????????????????????????????
        if lastDrawImage != nil {
           //lastDrawImage.draw(at:CGPoint.zero)
        }
  
        penColor?.setStroke()
        path.lineWidth = penW//ペン幅を指定する
        path.stroke()//描画する
        //setNeedsDisplay()
        lastDrawImage = UIGraphicsGetImageFromCurrentImageContext()!

        //タッチEnd時に画面を背景にコピーする
        secondView.backgroundColor = UIColor(patternImage: lastDrawImage!)

        //UIGraphicsEndImageContext()  //Canvasを閉じる
    }
    
 }
 
