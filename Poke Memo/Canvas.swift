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
    //key⇒ (["1"]-["10"],["2"]-["20"],["3"]-["30"])
    //["1"]:パレット画面、["2"]:セカンド画面、["3"]:セカンド画面(編集パネル実行時）
    //["10"]は["1"]のUNDO画面：他も同様
    var undoMode:Int = 0 //[0,1,2,7,8]//1:7,2:8,3:9(編集パネル）がundo:redoのペア
    var editOK:Bool = false//編集確定時の[OK]ボタン実行フラグ
    //:Undo/REDO
    func undo() {
        print("undoMode = \(undoMode)")
        if undoMode == 2{//secondView上の処理
          if bup["20"] == nil{return}
          print("@@ redo @@")
          let im0 = bup["20"]?.0
          mxTemp = bup["20"]?.1
          secondView.backgroundColor = UIColor(patternImage: im0!)
          lastDrawImage = im0
          undoMode = 8
            
        }else if undoMode == 8{//undo処理直後
          let im2 = bup["2"]?.0
          mxTemp = bup["2"]?.1
          secondView.backgroundColor = UIColor(patternImage: im2!)
          lastDrawImage = im2
          undoMode = 2
            
        }else if undoMode == 1 {//okボタンが押された直後
          if bup["10"] == nil{return}
          secondView.backgroundColor = UIColor.clear//(patternImage: blankView!)
          let im1 = bup["10"]?.0
          mxTemp = bup["10"]?.1
          //[10]と[1]を入れ替える
            bup["temp"] = bup["10"]
            bup["10"] = bup["1"]
            bup["1"] = bup["temp"]
            
          drawableView.backgroundColor = UIColor(patternImage: im1!)
          lastDrawImage = nil

          if editOK == false{//編集パネル非表示
            self.Delegate?.upToMemo()//パレット内容をメモに移す
          }
          print("self.Delegate?.upToMemo()//パレット内容をメモに移す")
          undoMode = 1
            
        }else if undoMode == 3{//編集パネル表示中にokボタンが押された直後のUndo
    //return
            if bup["30"] == nil{return}
            print("@@ redo @@")
            secondView.backgroundColor = UIColor.clear
            let im1 = bup["30"]?.0
            mxTemp = bup["30"]?.1
            drawableView.backgroundColor = UIColor(patternImage: im1!)
            lastDrawImage = nil
            bup["20"] = bup["30"]//現状画面をセカンドviewのUndo画面にする
            undoMode = 9
            
        }else if undoMode == 9{//undo処理が行われた直後
            //return
            let im1 = bup["3"]?.0
            mxTemp = bup["3"]?.1
            drawableView.backgroundColor = UIColor(patternImage: im1!)
            lastDrawImage = nil
            bup["20"] = bup["3"]//現状画面をセカンドviewのUndo画面にする
            undoMode = 3
            
        }
        /*
        else if undoMode == 7{//undo処理が行われた直後
            let im1 = bup["1"]?.0
            mxTemp = bup["1"]?.1
            drawableView.backgroundColor = UIColor(patternImage: im1!)
            lastDrawImage = nil
            if editOK == false{//編集パネル非表示
                self.Delegate?.upToMemo()//パレット内容をメモに移す
            }
            print("self.Delegate?.upToMemo()//パレット内容をメモに移す")
            undoMode = 1
        */
    }
    //undo関係のリセット
    /*
     func resetUndo(){
         undoMode = 0
         //bup["20"] = nil
         //bup["10"] = nil
         //bup["1"] = nil
         //bup["2"] = nil
     }
    */
    
    //SecondView画面(パネル編集結果）を取得する
    func get3VImage(open:Int){//open:パネルを開く時が１、閉じる時は０
        print("get3VImage")
        thirdView.removeFromSuperview()//3rdViewを取り出す
        let im = self.GetImage()
        self.addSubview(thirdView)//前フィルタ3rdViewを追加
        if open == 1{
          bup["3"] = (im,mxTemp)
          bup["30"] = (im,mxTemp)
        }else if open == 0{
          bup["3"] = (im,mxTemp)
          bup["20"] = bup["3"]//編集結果画面をセカンドviewのUndo画面にする
        }

        undoMode = 3
    }
    //SecondView画面を取得する
    func get2VImage(){
        print("get2VImage():editOK=\(editOK)")
        if lastDrawImage == nil{return}//何も描いていない時はパス
        thirdView.removeFromSuperview()//3rdViewを取り出す
        let im = lastDrawImage//secondView.GetImage()
        self.addSubview(thirdView)//前フィルタ3rdViewを追加
        print("◆◆")//bup[2] =lastDrawImage")
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
        print("get1VImage:mxTemp=\(mxTemp)")
        print("mx nowGyouNo:\(String(describing: mx[String(nowGyouNo)]))")
        undoMode = 1

    }

    
    //----------- secondView(パレット前面フィルタ)の作成 --------------------------
        let myImg = UIImage(named: "blank.png")// 背景(メモの選択背景色と合わせる)
        //let myImg2 = UIImage(named: "blankP.png")// 背景(メモの選択背景色と合わせる)
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
        thirdView.addBothBorderWithColor(color: UIColor.green.withAlphaComponent(0.25), width: 15)
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
    //=====================　描画プログラム　======================//
    
    var rightFlag:Bool = false
    let rightArea:CGFloat = 10//右側エリア境界位置
    var shiftLeftFlag:Bool = false
    var shiftDownFlag:Bool = false
    var X_color = 0
    var autoFlag:Bool = false//自動スクロールフラグ
    var moveFlag:Bool = false// タッチしている時にtrue
    //var sCount:Int16 = 0//?
    var timer:Timer!
    var myMx:CGFloat = 0 //今回タッチした最大X座標(タイマースクロール用）
    var timerFlag:Bool = false//タイマー起動中:true
    
    
    // タッチされた
    override func touchesBegan(_ touches:Set<UITouch>, with event: UIEvent?) {
        print("touchbegan")
        okEnable = true//メイン画面のokボタンの受付を許可する
        
        let currentPoint = touches.first!.location(in: self)
        print("currentPoint.x: \(currentPoint.x)")
        bezierPath = UIBezierPath()
        bezierPath.lineWidth = 1.0
        bezierPath.move(to:currentPoint)
        lastPoint = currentPoint
        
        //右側エリアに入っているか判定
        let midX = self.frame.midX //ControllViewからみたdrawableVの中心X座標
        let b = (bigFlag == true) ? big :1//拡大時に位置を補正する
        let screenX = b*(currentPoint.x) + (midX - b*vWidth/2)    // 画面座標に変換
        
        rightFlag =  screenX > (boundWidth - rightArea) ? true:false
        //print("screenX:\(screenX)")
        //print("◆◆◆◆")
        if lastDrawImage != nil{
          bup["20"] = (lastDrawImage,mxTemp)//)bup["2"]
        }
        //lastXm = mx[String(nowGyouNo)]!//◆◆◆◆
        setPen()//線巾、線色の設定
        //sCount = 0//?
        // ++ ラインキャップ++++
        if  bigFlag == true{
            bezierPath.lineCapStyle = .round
        }else{
            bezierPath.lineCapStyle = .round
        }
        
        //+++++++++1:自動スクロール関係検証用
        autoFlag = false//自動スクロールをリセットする
        if timer != nil{timer.invalidate()}
        myMx = 0//タッチ位置の初期化
        //+++++++++2:新タッチシステム検証用
        UIGraphicsBeginImageContext(self.frame.size)//Canvasを開く ▼▼
        if lastDrawImage != nil {//タッチEnd時に画面を背景にコピーするつもりだった？
            lastDrawImage.draw(at:CGPoint.zero)
        }

    }
    
    // タッチが動いた
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("touchesMoved\(sCount)")
        
        if bezierPath.isEmpty == true { return }//タッチされていない場合(Pathが初期化前)はパス
        let currentPoint = touches.first!.location(in:self)//  @ self:UIView @
        
       //---- 通常モード ----
       if rightFlag == false{
        //mx最大値を取得
        mxTemp = max(mxTemp,currentPoint.x)
    
        //中間点を作成  ▼▼
        let midPoint = CGPoint(x: (lastPoint.x + currentPoint.x)/2, y: (lastPoint.y + currentPoint.y)/2)
        bezierPath.addQuadCurve(to: midPoint, controlPoint: lastPoint)

        drawLine(path:bezierPath)
        lastPoint = currentPoint

        //自動スクロール機能
        if bigFlag == false{
          //myMx最大値を取得:今回のタッチの最大値、
          myMx = max(myMx,currentPoint.x)
          if myMx >= mxTemp{//既に書かれた文字よりも右へ越えた場合だけ処理する(タイマー起動中も🐞）
            let midX = self.frame.midX //スクリーンViewから見たパレット中心X座標
            let screenX = myMx + (midX - vWidth/2)    // 画面座標に変
            autoFlag =  screenX > (boundWidth - rightArea*6) ? true:false
          }
          if timerFlag == true{autoFlag = true}//タイマー稼働中は自動スクロールする
        }
        
       //---- 右端エリアモード ----
       }else{
        print(" is rightArea!!")
        
       //左シフトの判定（手動）
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
        //print("shiftLeftFlag = \(shiftLeftFlag):Timer\(timerFlag)")

    }
    
    // タッチが終わった
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //moveFlag == false//タッチ状態終了
        if bezierPath == nil { return }
        //------- 右端エリア以外にタッチされた場合 -------
        if rightFlag == false{
            
          //??let currentPoint = touches.first!.location(in:self)
          //??bezierPath.addQuadCurve(to: currentPoint, controlPoint: lastPoint)
          //??drawLine(path: bezierPath)
  
          get2VImage()//second画像をbup[2]に保存：UNDO用
          //左方向への自動スクロール
            print("autoFlag:\(autoFlag):mxTemp=\(mxTemp)")
          if autoScrollFlag == true{//設定フラグ(判定フラグ:autoFlagでは無い）
             if bigFlag == false{ startTimer()}//遅延してスクロール(autoFlagを判定）
          }
            
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
        
    // ================ debug2 ==================================
        
        if debug2 == true{//@@ DEBUG2 @@
            testV.removeFromSuperview()
            drawableView.addSubview(testV)
            testV.layer.position = CGPoint(x: mxTemp, y:vHeight/2)
        }
    // ==========================================================
        UIGraphicsEndImageContext()  //Canvasを閉じる　▼▼

    }
    
    // タイマー開始
    func startTimer() {
      //左方向への自動スクロール
       if autoFlag == true{
          timer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(DrawableView.timerAction), userInfo: nil, repeats: false)
         timerFlag = true//タイマー起動中
        print("startTimer:\(timerFlag)")
       }
    }

    ///タイマーアップ時の処理
    func timerAction(){
        //if autoFlag == false {return}//不要では？
        scrollLeft()
        myMx = 0//スクロール実施後、タッチ最大ｘをリセット
        print("timerAction:\(timerFlag)")
    }
    /// 左方向へのスクロール
    func scrollLeft(){
        
        // 左方向へのシフトを実施する:画面の５-7分の１だけ左側に表示する
        var dsX = vWidth/2 - mxTemp + boundWidth/7
        //右端制限
        dsX = dsX < (boundWidth - vWidth/2) ? (boundWidth - vWidth/2):dsX
        //左端制限
        dsX = dsX > vWidth/2 ? vWidth/2:dsX
        
        //アニメーション動作をさせる
        UIView.animate(withDuration: 0.3, animations: {
            () -> Void in
            self.layer.position = CGPoint(x:dsX, y:boundHeight - th - vHeight/2)
            self.timerFlag = false//タイマーフラグのリセット
        })
        //シフトスクロールした後にOKボタンを押さない様にする
        //理由：①ボケ回数を減らす為、②ペン色が変わらない様にする
        //self.Delegate?.shiftMX()// [ok]ボタンを押す:view.done(done2)
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
               case 2:penW = 10
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
                case 1:penC = UIColor.rgb(r: 0, g: 147, b: 87, alpha: 1)
                case 2:penC = UIColor.brown
                //rgb(r: 50, g: 0, b: 0, alpha: 1)
               //gray.withAlphaComponent(0.2) // brown
                default:break
               }
                
            }
        //消しゴムモード
        }else{
            //+-+-子メモの場合はchildColorにする
            penC = (nowGyouNo>10000) ? childColor : UIColor.white
            penW = 15//消しゴムの巾
        }
        
        print("@@@@@@@@:::::\(penC)")
    }
 
    // 描画処理:セカンドviewにストロークパス(セカンドViewを含む？）をコピーする
    func drawLine(path:UIBezierPath) {
        let penColor = penC
        penColor?.setStroke()
        path.lineWidth = penW//ペン幅を指定する
        path.lineCapStyle = .square
        path.stroke()//描画する
  
        //タッチEnd時に画面を背景にコピーする
        lastDrawImage = UIGraphicsGetImageFromCurrentImageContext()!
        secondView.backgroundColor = UIColor(patternImage:lastDrawImage!)
        //print(":::::func drawLine")
    }
    
    
 /*
    //ストロークの線色を変更する//使用しているの？
    func eXImageColor(img:UIImage)->UIImage{
        let imv:UIImageView = UIImageView(frame: self.frame)
        imv.image = img.withRenderingMode(.alwaysTemplate)
        imv.tintColor = UIColor.orange
        lastDrawImage = imv.GetImage()
        return imv.GetImage()
    }
 */
/*
    let tempPallete = UIView(frame: CGRect(x:0,y:0,width:vWidth,height:vHeight))
    func upToMemoTmp(){
        //直前のパレット画面画像
        //tempPallete.backgroundColor = UIColor( パレット画像
        //memo[fNum].addMemo(img: myImage1!,tag:nowGyouNo)
        
    }
*/
 }
 
