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
    var Delegate3:UIScrollViewDelegate!
    
    var rightFlag = false//右側エリアでタッチされた場合
    var startPointX: CGFloat!//タッチ開始X座標
    var shiftLeftFlag = false//左方向へのスワイプ発生
    var pageView:[UIView]!
    var iV:UIView!//IV:index
    var aV:UIView!
    var bV:UIView!
    
    override func touchesBegan(_ touches:Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self)
        startPointX = point.x
        var screenX:CGFloat = 0
        
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
            if tag != 0{self.Delegate2?.modalChanged(TouchNumber: tag)}
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
    }
    //--------- タッチイベント以外の関数------------

/*
    func changePageNum(pn:Int){pageNum = pn}//カレントページを変更する
    //func pageImgsToMemo(pn:Int,fn:Int)//選択ページをフレームに読み込む
    
    func setMemoView(){//最新版1113
        print("*******************************")
    // self:TouchView
      //@@@@@@@@@@  pageIMGS() / TouchView    @@@@@@@@@@@@@@@@@@@

        //UserDrfaultの頁数を調べる
         let kn = UserDataNum()//保管してあるページ数
        var num:Int = 1
         if kn != 0{
           let sa = kn - pageImgs.count + 1
           if sa > 0{ num = sa }else{ num = 3 }
              for n in 1...sa{
                 createNewPageImg()
              }
           }
         //imgsにページデータを読み込む
           for i in 0..<kn{
             readUserData(pn: i)
           }
    
        //pageImgs[[UIImage]]を作成する：メモの内容(ページ別)：保存する時のオブジェクト
        //INDEXページのpageImgs[0]の空要素を作成
        iV = memoView.makePageWithTag(pn:0)
        //必要なページ分のpageImgs[1〜]の空要素を作成(追加する）
        aV = memoView.makePageWithTag(pn:1)
        
        bV = memoView.makePageWithTag(pn:2)
        
        //☓UserDrfaultの頁数が０の場合は２ページ　＋INDEXページ（合計[2])の３要素を作成
        //☓UserDrfaultの保存データをpageImgs[]に読み込む
         
        //表示するページのpageView[30]を2個＋INDEXVie文を作成する（AV、BV,IV）
         print("¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥")
        
        //pageView[IV,AV,BV]を作成する。
        pageView.append(iV)
        print("¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥2")
         pageView.append(aV)
         pageView.append(bV)
        
        //表示するページのpageView[0]/IVをmemoViewに追加(画面表示）する。
         self.addSubview(pageView[1])
    }
 

        //全行空白のページ１−３を追加
        //@@ pageImgs[3]を新設する　※空の４ページ
        
        createNewPageImg()
        createNewPageImg()
        createNewPageImg()
        createNewPageImg()
        
        print("ページ数は：\(pageImgs.count - 1) 頁です。")
        //pageImageの要素を入れる4つの箱を用意します。※[0]はINDEXページ
        memoView.make3BlankMemo()
        //pageImageの更新(UserDrfaultの全頁）
        //UserDrfaultの頁数を調べる
        let kn = UserDataNum()//保管してあるページ数
        if kn != 0{
            let sa = kn - pageImgs.count + 1
            if sa > 0{
                for n in 1...sa{
                    createNewPageImg()
                }
            }
            //imgsにページデータを読み込む
            for i in 1...kn{
                readUserData(pn: i)
            }
        }
       
        //pageImageの要素画像をmemoViewにコピーします
        memoView.TpageImgsToMemo(pn: 1,fn:homeFrame)
        //showHomeFrame()
    }
 
    func UserDataNum()->Int{//これから読み込むUserDataに存在するページ数を取得する
        //print(NSUserDefaults.standardUserDefaults().dictionaryRepresentation())
        
        let photoData = UserDefaults.standard
        let dic: NSDictionary = photoData.dictionaryRepresentation() as NSDictionary
        let keys = dic.allKeys
        var kn = 0
        for k in 0...20{
            var key = "photos" + String(k + 1)
            let found = keys.contains(where: { return $0 as! String == key })
            if found == false { break}
            kn = kn + 1
        }
        print("OK Google!: \(kn)")
        return kn
    }
    func createNewPageImg(){ //新しいページを作成して末尾に追加する
        let bImage:UIImage = UIImage(named: "blankW.png")!
        var blankImgs:[UIImage] = Array(repeating: bImage, count: pageGyou)
        pageImgs.append(blankImgs)
    }
    
    func readUserData(pn:Int){ //UserDataをpageImmgs[]に読み込む
        var rl = reloadToPage(pn: pn)
        if rl.count > 0 { //これがないと読み込みエラーが発生 初期ではrl.count= 0
            pageImgs[pn] = rl
        }
    }

    /* ページめくり動作 */
    func showImgs(pn:Int){ //指定のページを表示する
        memoView.TpageImgsToMemo(pn: pn,fn:homeFrame)//fn:フレーム番号
        showHomeFrame()
    }
    func showHomeFrame(){
        self.contentOffset = CGPoint(x:leafWidth*1,y: 0)
    }
    func showNextImgsWithAnimation(){//表示中の次のページをアニメーションで表示する
        //第1フレームに表示ページの内容を入れる
        memoView.TpageImgsToMemo(pn: pageNum,fn:homeFrame - 1)
        //第1フレームを表示する
        self.contentOffset = CGPoint(x:leafWidth*0,y: 0)
        //第2フレームに次のページ内容を入れる
        memoView.TpageImgsToMemo(pn: pageNum + 1,fn:homeFrame)
        //第2フレームをアニメーション表示する。
        TouchScrollView.animate(withDuration: 1, animations: {
            () -> Void in
            self.contentOffset = CGPoint(x:leafWidth*1,y: 0)
        })
    }
    
    func showNextImgs() { //表示中の次のページを表示する
        if isEditMode == false{//Editモード出ない場合
            let pn = pageNum + 1
            memoView.TpageImgsToMemo(pn: pn,fn:homeFrame)//fn:フレーム番号
            //↑行の中で表示ページNumが更新される
            showHomeFrame()
        }
    }
    
    func showBeforeImgsWithAnimation(){//表示中の次のページをアニメーションで表示する
        //第3フレームに表示ページの内容を入れる
        memoView.TpageImgsToMemo(pn: pageNum,fn:homeFrame + 1)
        //第3フレームを表示する
        self.contentOffset = CGPoint(x:leafWidth*2,y: 0)
        //第2フレームに前のページ内容を入れる
        memoView.TpageImgsToMemo(pn: pageNum - 1,fn:homeFrame)
        //第2フレームをアニメーション表示する。
        TouchScrollView.animate(withDuration: 1, animations: {
            () -> Void in
            self.contentOffset = CGPoint(x:leafWidth*1,y: 0)
        })
    }
    
    func showBeforeImgs(){ //表示中の前のページを表示する
        if isEditMode == false{//Editモード出ない場合
            let pn = pageNum - 1
            memoView.pageImgsToMemo(pn: pn,fn:homeFrame)//fn:フレーム番号
            //↑行の中で表示ページNumが更新される
            showHomeFrame()
        }
    }
    
    func upToImgs(){ //表示中のページの内容を更新する
        if isEditMode == false{//Editモードの場合はパス
            let pn = pageNum
            memoView.TmemoTopageImgsToMemo(pn: pn,fn:homeFrame)//fn:フレーム番号
        }
    }
    
    /* ページめくりのメイン関数 */
    func gotoNextPage(){ //ページを進める
        showHomeFrame()
        if isEditMode == false && pageImgs.count - 1 > pageNum{//Editモードの場合はパス
            //表示中のフレーム番号
            frameNum = Int(self.contentOffset.x/leafWidth) + 1
            //第2frameが表示中である事をチェック
            if frameNum == homeFrame{
                let pn = pageNum
                upToImgs()//表示中のページ内容を更新する
                //次のページを第3フレームに入れる
                showNextImgsWithAnimation()//表示中の次のページをアニメーション表示する
            }
        }
        print("pageNum: \(pageNum)")
    }
    
    func showBackPage(){ //ページを戻す
        showHomeFrame()
        if isEditMode == false && pageNum > 1{//Editモードの場合はパス
            //表示中のフレーム番号
            frameNum = Int(self.contentOffset.x/leafWidth) + 1
            //第2frameが表示中である事をチェック
            if frameNum == homeFrame{
                let pn = pageNum
                upToImgs()//表示中のページ内容を更新する
                //次のページを第3フレームに入れる
                
                showBeforeImgsWithAnimation()//表示中の次のページをアニメーション表示する
                print(";;;;;;;;;;;;")
            }
        }
        print("pageNum: \(pageNum)")
    }
    //-----------------------------------------------------------
    
    func Tshow_4thFrame(){//　== 第1frameをキーフレームにする場合 ==
        if isEditMode == false{
            print("pageImgs.count: \(pageImgs.count)")
            //表示中のフレーム番号
            frameNum = Int(self.contentOffset.x/leafWidth) + 1
            //frameに入っているpnを取得？
            print("frame:\(memoView.framePage)")
            //第2frameが表示中である事をチェック
            if frameNum == 1{
                //第1frameの内容をpageImgsにsaveする
                //var f1p = memoView.framePage[1]
                pageImgs[pageNum] = memoView.memo2ImagsNew(fn: 1)
                
                //第2frameに次の頁内容を入れる
                var f3p = pageNum + 1
                if pageImgs.count <= f3p{ createNewPageImg()}
                memoView.pageImgsToMemo(pn: f3p,fn:2)
                
                //表示frame を2に変更する (アニメーション）
                TouchScrollView.animate(withDuration: 0.2, animations: { () -> Void in
                    self.contentOffset = CGPoint(x:leafWidth*1,y: 0)
                })
                //第1frameに次の頁内容を入れる
                memoView.pageImgsToMemo(pn: f3p,fn:1)
                print("//第1frameに次の頁内容を入れる")
                //表示frame を2⇒1に変更する
                self.contentOffset = CGPoint(x:leafWidth*0,y: 0)
                print("表示frame を2⇒1に変更する")
                //memoView.clearBackgroundColor()
                print("pageNum: \(pageNum)")
                
            }
        }
    }
    
    func show_4thFrame(){//第3frameの次の内容を表示する。
        if isEditMode == false{
            print("pageImgs.count: \(pageImgs.count)")
            //表示中のフレーム番号
            frameNum = Int(self.contentOffset.x/leafWidth) + 1
            //frameに入っているpnを取得？
            print("frame:\(memoView.framePage)")
            //第2frameが表示中である事をチェック
            if frameNum == 2{
                //第2frameの内容をpageImgsにsaveする
                //var f2p = memoView.framePage[2]
                pageImgs[pageNum] = memoView.memo2ImagsNew(fn: 2)
                //第2frameの内容を第1frameにコピー
                memoView.pageImgsToMemo(pn: pageNum,fn:1)
                //表示frame を2⇒1に変更する
                self.contentOffset = CGPoint(x:leafWidth*0,y: 0)
                //第2frameに次の頁内容を入れる
                var f3p = pageNum + 1
                if pageImgs.count <= f3p{ createNewPageImg()}
                memoView.pageImgsToMemo(pn: f3p,fn:2)
                //表示frame を2に変更する (アニメーション）
                TouchScrollView.animate(withDuration: 0.2, animations: { () -> Void in
                    self.contentOffset = CGPoint(x:leafWidth*1,y: 0)
                })
                //memoView.clearBackgroundColor()
                print("pageNum: \(pageNum)")
            }
        }
    }
    
    func Tshow_1beforeFrame(){//　== 第1frameをキーフレームにする場合 ==
        if isEditMode == false{
            //表示中のフレーム番号
            frameNum = Int(self.contentOffset.x/leafWidth) + 1
            //第2frameが表示中である場合をチェック
            //var f2p = memoView.framePage[2]
            if frameNum == 1 && pageNum > 1{//第2frameの内容がページ2以上の場合のみ
                //第1frameの内容をpageImgsにsaveする
                pageImgs[pageNum] = memoView.memo2ImagsNew(fn: 1)
                //第2frameに第1frameの内容を入れる
                memoView.pageImgsToMemo(pn: pageNum,fn:2)
                //表示frame を1⇒2に変更する
                self.contentOffset = CGPoint(x:leafWidth*1, y:0)
                //第1frameに前の頁内容を入れる
                var f1p = pageNum - 1
                memoView.pageImgsToMemo(pn: f1p,fn:1)
                //表示frame を1に変更する (アニメーション）
                TouchScrollView.animate(withDuration: 0.2, animations: { () -> Void in
                    self.contentOffset = CGPoint(x:leafWidth*0,y: 0)
                }, completion: { finished in
                    print(" === | ===")
                })
                
                //memoView.clearBackgroundColor()
                print("pageNum: \(pageNum)")
                
            }
        }
    }
    
    func show_1beforeFrame(){//第1frameの前の内容を表示する。
        if isEditMode == false{
            //表示中のフレーム番号
            frameNum = Int(self.contentOffset.x/leafWidth) + 1
            //第2frameが表示中である場合をチェック
            //var f2p = memoView.framePage[2]
            if frameNum == 2 && pageNum > 1{//第2frameの内容がページ2以上の場合のみ
                //第2frameの内容をpageImgsにsaveする
                pageImgs[pageNum] = memoView.memo2ImagsNew(fn: 2)
                //第2frameの内容を第3frameにコピー
                memoView.pageImgsToMemo(pn: pageNum,fn:3)
                //表示frame を2⇒3に変更する
                self.contentOffset = CGPoint(x:leafWidth*2,y: 0)
                //第2frameに前の頁内容を入れる
                var f1p = pageNum - 1
                memoView.pageImgsToMemo(pn: f1p,fn:2)
                //表示frame を2に変更する (アニメーション）
                TouchScrollView.animate(withDuration: 0.2, animations: { () -> Void in
                    self.contentOffset = CGPoint(x:leafWidth*1,y: 0)
                }, completion: { finished in
                    print(" === | ===")
                })
                
                //memoView.clearBackgroundColor()
                print("pageNum: \(pageNum)")
                
            }
        }
    }
    
    // UserDwfaultに保存のメモ画像をpageImgs:[]に読み込む //
    func reloadToPage(pn:Int)->[UIImage] {
        var imgs:[UIImage] = []
        let photoData = UserDefaults.standard
        // [UIImage] → [NSData]
        //photoData.synchronize()
        
        let photosName:String = "photos" + String(pn)//保存名
        //NSData から画像配列を取得する
        
        if photoData.object(forKey: photosName) != nil{
            let images = photoData.object(forKey: photosName) as! [NSData]
            
            for k in 0...pageGyou - 1{
                imgs.append(UIImage(data:images[k] as Data)!)
            }
        }
        print("images[k]: \(imgs.count)")
        return imgs
    }
    
*/
}
//

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
