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
    
    var swapFlag = false//drawVとsecondVの入れ替え(false:正規状態)
    var lastPenW:CGFloat = 1//直前のペン幅
    var kando_k:CGFloat = 1 //sliderNに掛かる係数
    //var sliderN:CGFloat = 0.5//スライダー値
    var k_dt:CGFloat = 0//速度ベクトルの絶対値
    var k_z:CGFloat = 1.0//象限別のペン幅係数
    var lastMidPoint:CGPoint!//★20180818
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
            if swapMode && swapFlag {swapViewBgImage()}//⭕️swap状態→正規状態に戻す
          if bup["20"] == nil{return}
          print("@@ redo @@")
          let im0 = bup["20"]?.0
          mxTemp = bup["20"]?.1
          secondView.backgroundColor = UIColor(patternImage: im0!)
          lastDrawImage = im0
            if swapMode && !swapFlag {swapViewBgImage()}///⭕️swap画面に戻す
          undoMode = 8
            
        }else if undoMode == 8{//undo処理直後
            if swapMode && swapFlag {swapViewBgImage()}///⭕️
          let im2 = bup["2"]?.0
          mxTemp = bup["2"]?.1
          secondView.backgroundColor = UIColor(patternImage: im2!)
          lastDrawImage = im2
            if swapMode && !swapFlag {swapViewBgImage()}///⭕️swap画面に戻す
          undoMode = 2
            
        }else if undoMode == 1 {//okボタンが押された直後
          if bup["10"] == nil{return}//ok2()の中で　[1]→[10]
          if swapMode && swapFlag {swapViewBgImage()}///⭕️swapモード時は一時的に正規画面に戻す
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
        if swapMode && !swapFlag {swapViewBgImage()}///⭕️swap画面に戻す
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
        print("==== swapFlag=\(swapFlag) ====")
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
        print("●----------get1VImage()-------------●")
        bup["10"] = bup["1"]
        thirdView.removeFromSuperview()//3rdViewを取り出す
        let im = self.GetImage()
        self.addSubview(thirdView)//前フィルタ3rdViewを追加
        bup["1"] = (im,mxTemp)
        print("get1VImage:mxTemp=\(String(describing: mxTemp))")
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
        //__ ++ thirdViewの初期化：背景を緑色にする、先頭と末尾に印を追加する ++
        thirdView = UIView(frame: secondView.frame)
        thirdView.backgroundColor = UIColor.clear//(patternImage: myImg!)
        thirdView.addBothBorderWithColor(color: UIColor.green.withAlphaComponent(0.2), width: 15,gHeight: 18)
        
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
    //secondView.bgとdrawableView.bgを入れ替える。　１⇄２
    func swapViewBgImage(){
        thirdView.removeFromSuperview()//3rdViewを取り出す
        let buf2 = self.secondView.GetImage()
        self.secondView.backgroundColor = UIColor.clear
        //drawableViewの画面をbuf1にコピーする
        let buf1 = self.GetImage()
        //drawableViewのb.g.にbuf2をコピーする
        self.backgroundColor = UIColor(patternImage: buf2)
        //secondViewのb.gにbuf1をコピーする
        self.secondView.backgroundColor = UIColor(patternImage: buf1)
        self.addSubview(thirdView)
        swapFlag = !swapFlag
    }
    //=====================　描画プログラム　======================//
    
    var isUnderArea:Bool = false// ⭕️下端エリア境界線より下でtrue
    var lastY:CGFloat = 0//１つ前のy座標？右側エリア処理だけで使用する
    var rightFlag:Bool = false
    var rightArea:CGFloat = 18//15//10//右側エリア境界位置
    var shiftLeftFlag:Bool = false
    var shiftDownFlag:Bool = false
    var shiftUpFlag:Bool = false
    var X_color = 0//0:ペンモード、:消しゴムモード
    var autoFlag:Bool = false//自動スクロールフラグ
    var moveFlag:Bool = false// タッチしている時にtrue
    //var sCount:Int16 = 0//?
    var timer:Timer!
    var myMx:CGFloat = 0 //今回タッチした最大X座標(タイマースクロール用）
    var timerFlag:Bool = false//タイマー起動中:true
    ///テスト用(k_dtの値を確認するため）
    var kdtMax:CGFloat = 0
    var kdtMin:CGFloat = 100
    var rightView:UIView!//⭕️⭕️テスト用です
    
    // タッチされた------------------------------------------
    override func touchesBegan(_ touches:Set<UITouch>, with event: UIEvent?) {
        //print("== 🔸touchesBegan:swapMode: \(swapMode):swapFlag: \(swapFlag) ==")
        //print("----- undoMode = \(undoMode) -----")
        if !marker{swapMode = false}
        //⭕️swapモードからpenモードに切り替え時の処理? マーカ(swap →normal)は下記はtrue？
        if !swapMode && swapFlag {swapViewBgImage()}
        UIGraphicsBeginImageContext(self.frame.size)//Canvasを開く ▼▼
        let currentPoint = touches.first!.location(in: self)
        print("currentPoint.x: \(currentPoint.x)")
        bezierPath = UIBezierPath()
        bezierPath.lineCapStyle = .round
        bezierPath.lineJoinStyle = .round
        bezierPath.lineWidth = 1.0
        bezierPath.move(to:currentPoint)
        lastPoint = currentPoint
        lastY = currentPoint.y
        lastMidPoint = currentPoint//20180702:カリグラフィ用
        okEnable = true//メイン画面のokボタンの受付を許可する
        if swapMode && swapFlag{swapViewBgImage()}//⭕️正規の関係に戻す
        //右側エリアに入っているか判定
        let midX = self.frame.midX //ControllViewからみたdrawableVの中心X座標
        let b = (bigFlag == true) ? big :1//拡大時に位置を補正する
        
        let ix:CGFloat = iphoneX && (boundWidthX != boundWidth) ? 44 - 34 : 0
        let screenX = b*(currentPoint.x) + (midX - b*vWidth/2)// 画面座標に変換
        //print("⭕️⭕️screenX= \(screenX) ⭕️⭕️")
        //print("\(screenX - (boundWidthX - rightArea - ix))")
        rightFlag =  screenX > (boundWidthX - rightArea - ix) ? true:false
        //下端エリア以下であるかをチェックする
        isUnderArea = (currentPoint.y >= vHeight - 21.0) ? true : false
        //print("screenX:\(screenX)")
        //print("◆◆◆◆")//
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
        
         if lastDrawImage != nil {//タッチEnd時に画面を背景にコピーするつもりだった？
                lastDrawImage.draw(at:CGPoint.zero)
         }
        lastPenW = 3.0////★
        ///テスト用(k_dtの値を確認するため）
        kdtMax = 0
        kdtMin = 100
        shiftUpFlag = false
        shiftDownFlag = false
    }
    
    // タッチが動いた-----------------------------------------------
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentPoint = touches.first!.location(in:self)//  @ self:UIView @
        /* ★20180817 削除してみる、問題なさそうに思う
         if bezierPath.isEmpty == true {
          print("◾️◾️◾️◾️◾️◾️◾️◾️◾️◾️◾️◾️◾️◾️◾️◾️◾️◾️◾️◾️◾️◾️◾️◾️")
         return }//タッチされていない場合(Pathが初期化前)はパス　？これって必要？
        */
        //末尾の緑色帯より右には描画不可とする:（子メモマーク表示エリア）
        if rightFlag == false && (currentPoint.x + penW/2) >= (vWidth - 34){
            return
        }
        if bezierPath == nil {return}//★20180819
        //print("⭕️⭕️⭕️⭕️ isUnderArea: \(isUnderArea)")
//①---- 通常モード (⭕️右側エリアでない場合)-----------------------------------------
       if (rightFlag == false) && isUnderArea == false{
        //mx最大値を取得
        mxTemp = max(mxTemp,currentPoint.x)
    
        //中間点を作成
    //▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼カリグラフィ向けに変更した箇所▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
        if !callig || (X_color == 1 || marker){//-- 鉛筆と修正ペン + マーカペン --
            let midPoint = CGPoint(x: (lastPoint.x + currentPoint.x)/2, y: (lastPoint.y + currentPoint.y)/2)

            bezierPath.addQuadCurve(to: midPoint, controlPoint: lastPoint)
            drawLine(path:bezierPath)
            lastPoint = currentPoint
            lastMidPoint = midPoint
        }else{//-- カリグラフィ --
            // ● 中間点を作成
            let midPoint = CGPoint(x: (lastPoint.x + currentPoint.x)/2, y: (lastPoint.y + currentPoint.y)/2)
            let mid2Point = CGPoint(x: (lastMidPoint.x + midPoint.x)/2, y: (lastMidPoint.y + midPoint.y)/2)
            let addPoint = CGPoint(x: (lastPoint.x + mid2Point.x)/2, y: (lastPoint.y + mid2Point.y)/2)
            //移動量の抽出
            let deltX = currentPoint.x - lastPoint.x
            let deltY = currentPoint.y - lastPoint.y
          
            k_dt = sqrt(pow(deltX,2) + pow(deltY,2))//変化量の長さがの２乗の平方根
            ///k_dtの最大値と最小値を記録する
            kdtMax = k_dt >= kdtMax ? k_dt : kdtMax
            kdtMin = k_dt < kdtMin ? k_dt : kdtMin
            ///print(" ▶︎▶︎▶︎▶︎▶︎ k_dt: \(k_dt)")
            // 座標軸を左に45度回転させる
            let dtx = (deltX - deltY)*0.7
            let dty = (deltX + deltY)*0.7
            
            //移動量ベクトルの象限判定（1,2,3,4)
            var zone:Int = 1                           // 4 | 1
            if dtx >= 0 { zone = (dty < 0) ? 1 : 2 }   //  —+—
            else{ zone = (dty >= 0) ? 3 : 4}           // 3 | 2
            //線幅調整値の計算（象限別）
            kando_k = 1.0//★
            switch zone {
            case 1:
                k_z = 2 - (dtx - dty)/k_dt     //1-0.6
                kando_k =  k_z*0.8//★
            case 2:
                k_z = 1
                kando_k =  k_z*2//★
            case 3:
                k_z = (dty - dtx)/k_dt    //1-1.4
                kando_k = k_z*1.2//★
            case 4: k_z = 1
            default: k_z = 1
            }
            // ● 描画実行
            bezierPath.removeAllPoints()
            bezierPath.move(to: lastMidPoint)
            bezierPath.addLine(to:addPoint)
            bezierPath.addLine(to:midPoint)
            drawLine2(path:bezierPath)
            lastPoint = currentPoint
            lastMidPoint = midPoint
            //lastMovDistance = movDistance
            
        }
    //▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲
        //自動スクロール機能向け処理
        if bigFlag == false{
          //myMx最大値を取得:今回のタッチの最大値、
          myMx = max(myMx,currentPoint.x)
          if myMx >= mxTemp{//既に書かれた文字よりも右へ越えた場合だけ処理する(タイマー起動中も🐞）
            let midX = self.frame.midX //スクリーンViewから見たパレット中心X座標
            let screenX = myMx + (midX - vWidth/2)    // 画面座標に変
            autoFlag =  screenX > (boundWidthX - rightArea*5) ? true:false
          }
          if timerFlag == true{autoFlag = true}//タイマー稼働中は自動スクロールする
        }
        
//②---- 右端エリアモード (または下端エリア)-----------------------------
}else{
        print(" ●●●●is rightArea!!●●●●")
        //⭕️下端エリアモードの場合はパスする
        if isUnderArea{ return }
       //左シフトの判定（手動）
        let dX = lastPoint.x - currentPoint.x
        print(" is rightArea!!")
        //let dY = lastPoint.y - currentPoint.y//ここでのlastPointはタッチ開始時の値
        let dY = lastY - currentPoint.y//lastYは１つ前のy値
        let dY2 = abs(dY)
        print(" is rightArea!!")
        if dX>20 && dY2<10{ shiftLeftFlag = true }//y軸方向の変化量が少ない時だけ実行する
        print("-------  dx = \(dX), dY = \(dY)  -------")
        print("")
        print("lastPoint = \(String(describing: lastPoint))")
        if (dY2 > 10) && (dX < 6){
            if (dY < 0){//下側へのシフト判定
                shiftDownFlag = true
            }else if (dY > 0){//上側へのシフト判定
                shiftUpFlag = true
            }
        }
        lastY = currentPoint.y
}//③（右側エリア処理の終わり）-------------------------------------------------

        //print("shiftLeftFlag = \(shiftLeftFlag):Timer\(timerFlag)")

    }
    
    // タッチが終わった---------------------------------------------
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //⭕️下端エリアモード時はパス
        if isUnderArea{return}
        //moveFlag == false//タッチ状態終了
        if bezierPath == nil { return }
        //------- 右端エリアより左にタッチされた場合 -------
        if rightFlag == false{
          get2VImage()//second画像をbup[2]に保存：UNDO用
        ///print("-🔸---toutchEnd:swapMode:\(swapMode),swapFlag=\(swapFlag)---------------")
        if swapMode && !swapFlag{
            swapViewBgImage()///⭕️
        }
          //左方向への自動スクロール
            print("autoFlag:\(autoFlag):mxTemp=\(String(describing: mxTemp))")
          if (autoScrollFlag == true) && !marker{//設定フラグ(判定フラグ:autoFlagでは無い）
            //マーカーモードでは動作しない
             if bigFlag == false{ startTimer()}//遅延してスクロール(autoFlagを判定）
          }
            
        //------- 右端エリアにタッチされた場合 -------
        }else if shiftLeftFlag == true && bigFlag == false{//拡大モードではパス
            scrollLeft()// 左方向へのフリップスクロール

        }else if shiftDownFlag == true && bigFlag == false{//拡大モードではパス
            print("downFlag: \(shiftDownFlag)")
            self.Delegate?.selectNextGyou()//改行する
        }else if shiftUpFlag == true && bigFlag == false{//拡大モードではパス
        print("🔺🔺🔺🔺🔺🔺🔺")
            self.Delegate?.selectUpGyou()//Up改行する
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
        ok2Flg = false//ok2()再実行フラグをリセットする（メモ行更新可とする）
        print(" ▶︎▶︎▶︎▶︎▶︎ k_dt: Max = \(kdtMax), Min = \(kdtMin)")
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
        
        //_左方向へのシフトを実施する:画面の５-7分の１だけ左側に表示する
        var dsX = vWidth/2 - mxTemp + boundWidthX/20 //★20180822:←7
        //_x右端制限:『iphoneXの横向き』の場合だけleftOffsetが加わわる。
        let leftOffset2 = (boundWidthX == boundWidth) ? 0 : leftOffset
        dsX = dsX < (boundWidthX - vWidth/2 - leftOffset2) ? (boundWidthX - vWidth/2 - leftOffset2):dsX
        //左端制限
        dsX = dsX > vWidth/2 ? vWidth/2:dsX
        
        //アニメーション動作をさせる
        UIView.animate(withDuration: 0.3, animations: {
            () -> Void in
            self.layer.position = CGPoint(x:dsX, y:leftEndPoint.y)//boundHeight - th - vHeight/2)
            self.timerFlag = false//タイマーフラグのリセット
        })
        //シフトスクロールした後にOKボタンを押さない様にする
        //理由：①ボケ回数を減らす為、②ペン色が変わらない様にする
        //      ↑書き出したメモを再読み込みしなければOK,②は止めてもいいかも
        if !marker{//マーカモード時は無視する
            self.Delegate.ok2()// [ok2]ボタンを押す:view.done(done2)★20180813
        }else{//メモカーソル位置の更新
            self.Delegate.memoCursol(disp: 1)
        }
    }
    //??
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
        print("ココは　setPen()です！")
        let kpw:CGFloat = marker ? 5 : 1//マーカーペンの線幅係数
        var op:CGFloat = 1.0//マークペンの透明度
        if X_color == 0 { //ペンモード
            //ペン巾の変更
            switch penWidth {
               case 0:penW = 5*kpw;op = 0.05
               case 1:penW = 7*kpw;op = 0.04
               case 2:penW = 10*kpw;op = 0.02
               default:break
            }
            penC = UIColor.black
            if penColorNum == 1{
                penC = UIColor.black
            }else if penColorNum == 2{
                penC = UIColor.red
            }else{//第３番目の色：設定色
                let lineColorX = marker ? lineColor2 : lineColor
              switch lineColorX {
                case 0:penC = marker ? mColor[2] :bColor[2]
                case 1:penC = marker ? mColor[3] :bColor[3]
                case 2:penC = marker ? mColor[4] :bColor[4]
                case 3:penC = marker ? mColor[5] :bColor[5]
                case 4:penC = marker ? mColor[6] :bColor[6]
                case 5:penC = marker ? mColor[7] :bColor[7]
                default:break
                }
            }
        //消しゴムモード
        }else{//X_color != 0
            //+-+-子メモの場合はchildColorにする
            penC = (nowGyouNo>10000) ? childColor : UIColor.white
            let markW = penWidth == 0 ? 5 : (penWidth == 1 ? 10 : 30)
            penW = CGFloat(!marker ? 15 : markW)//消しゴムの巾(マーカモードでは倍にする)
        }
        penC = marker ? penC.withAlphaComponent(op) : penC//マーカペンの色
        print("@@@@@@@@:::::\(String(describing: penC))")
    }
 
    // 描画処理:セカンドviewにストロークパス(セカンドViewを含む？）をコピーする
    func drawLine(path:UIBezierPath) {
        var penColor = selFlg ? gblColor : penC//色選択パネルの色を優先する
        penColor = X_color == 1 ? penC : penColor//消しゴムモードは白色
        penColor = penC//マーカペンの色
        penColor?.setStroke()
        path.lineWidth = penW//ペン幅を指定する
        if marker {path.lineCapStyle = .square}
        path.stroke()//描画する
        //画面を背景にコピーする
        lastDrawImage = UIGraphicsGetImageFromCurrentImageContext()!
        secondView.backgroundColor = UIColor(patternImage:lastDrawImage!)

        //print(":::::func drawLine")
    }
    //非ベジエ描画プログラム
    func drawLine2(path:UIBezierPath) {
        
        //_if lastDrawImage != nil { lastDrawImage.draw(at:CGPoint.zero)}
        //★修正ペンモード時はベジェモードとする？？モード切替時に行う？ここには来ない！
        //ペン色の設定
        let penColor = selFlg ? gblColor : penC//色選択パネルの色を優先する
        penColor?.setStroke()
        path.lineCapStyle =   .round//.butt//.square//
        //ペン幅を指定する（このモードでは線が細くなるので全体を太くする)為
        //penW: 5 - 7- 10
        let penw = penW*1.2//penWはブローバル変数//非べジュエでは全体的に細くなる為
        //⭕️線幅の変更-----------------------------------//
        var k_penW:CGFloat = 1.0//ペン巾係数??
        //k_z:象限別のペン幅係数(0-1),kando_k:
        k_penW = (penW - 7) / 12  + 1.2
        k_penW = k_penW * (sliderN*2)//sliderNの初期値：0.5
        //速度依存係数(k_dt:速度ベクトル長さ)
        //kando_k:
        let k_v = penw * k_dt * k_penW * (0.02*1)  //kando_k)
        let w = penw * k_z  - k_v
        //-----------------------------------------------⭕️
        //①ペン幅設定値に対する補正係数
        //var k_w:CGFloat = ((penW - 7)/12 + 1.0)
        //②速度依存係数(k_dt:速度ベクトル長さ)
        //var k_v = (k_dt * (0.02))
        //k_z:象限別のペン幅係数(0-1),kando_k:
        //sliderN: 0 - 0.5 - 1.0
        //線幅自動調整係数
        //let k_All = k_w * k_v * (sliderN*2)
        //let w = penw * (k_z  - k_All)
        
        //-----------------------------------------------🔲
        let w2 = (lastPenW + w)/2 //1つ前の線幅との平均をとる
        path.lineWidth = w2
        lastPenW  = w2
        //描画する
        path.stroke()
        
        //タッチEnd時に画面を背景にコピーする
        lastDrawImage = UIGraphicsGetImageFromCurrentImageContext()!
        secondView.backgroundColor = UIColor(patternImage:lastDrawImage!)
    }

 }
 
