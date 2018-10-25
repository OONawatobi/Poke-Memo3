//
//  Memo.swift
//  Poke Memo
//
//  Created by 青山 行夫 on 2016/11/27.
//  Copyright © 2016年 mm289. All rights reserved.
//

import UIKit

class MemoView:UIView{
    var memoNum:Int = 0
    let mWidth :CGFloat! = leafWidth// boundWidth - 20：メモクラスの幅
    //let mHeight :CGFloat! = boundHeight//メモクラスの高さ
    let leafRect:CGRect = CGRect(x:0,y:0,width:leafWidth,height:leafHeight)
    //var blankImg:UIImage!//leaf画像の初期値
    
//  [リーフクラス]
    class Leaf: UIImageView {
        var leafStus:Int = 0//未使用
        var rightSpace:CGFloat! = leafWidth//右端までの余白の長さ
    }
    
    /* ページの１行目に日付を追加する */
    func addDate(pn:Int){
       //日付を取得
       let compY = Calendar.Component.year
       let compM = Calendar.Component.month
       let compD = Calendar.Component.day
       let y = NSCalendar.current.component(compY, from: Date() as Date)
       let y2 = y - 2000
       let m = NSCalendar.current.component(compM, from: Date() as Date)
       let d = NSCalendar.current.component(compD, from: Date() as Date)
       //デバグ用　let m2 = 12 ;let d2 = 15//デバグ用
       //let st = String(format: "%4d-%2d-%2d",y,m2,d2)
       let st = String(format: "%2d/%2d  '%2d",m,d,y2)
       //日付を追加する2+2+2+1+2:
       let tag = pn*100 +  1
       let targetMemo:UIImageView = self.viewWithTag(tag) as! UIImageView
       targetMemo.image = targetMemo.image?.addText_Date(text: st)
        
    }
    /* 子メモが空白でない場合に、ベース行に三角マークを追加する */
    func add3Mark(baseTag:Int,del:Bool){
        let tag = baseTag
        print("●●add3Mark")
        let targetMemo:UIImageView = self.viewWithTag(tag) as! UIImageView
        let st = "∇"//"▶︎"//★20180815"▷"
        print("st:▽")
        targetMemo.image = targetMemo.image?.addText_Mark(text: st,del:del)
    }
    
    /* pageImageの要素画像をmemoViewにコピーします */
    //tag番号単位で読み込む
    func setMemoImgByTag(tag:Int,imgs:[UIImage]){
        let targetMemo:UIImageView = self.viewWithTag(tag) as! UIImageView
        targetMemo.image = imgs[pageGyou - 1]
    }
    //ページ単位で読み込む
    func setMemoFromImgs(pn:Int,imgs:[UIImage]){
        //tag付の空メモページを作る
           makePageWithTag(pn:pn)
        
        //pageImgs[指定ページ]の内容をメモページに取り込む
        var temp:CGFloat = 0
        var temp2:CGFloat = 0
        let gyou = (imgs.count < pageGyou) ? imgs.count : pageGyou//+-+-
        for idx in 0..<gyou{
            let tag = pn*100 + idx + 1
            let targetMemo:UIImageView = self.viewWithTag(tag) as! UIImageView
            //print("bbbbbbbbbbb:\(pn)")
            
            targetMemo.image = imgs[idx]
            //タグ番号を画像に合成する：試験用
            if debug1 == true{
                //print("== Debug01モード ==")
              targetMemo.image = targetMemo.image?.addText(text: String(tag))
            }
            
            //if idx == 0 && pn == 0{
            //    targetMemo.image = targetMemo.image?.addText(text: "INDEX")
            //}
            
            //プリント用
            if idx == 0{
                temp = (targetMemo.image?.size.height)!
                temp2 = CGFloat(targetMemo.image!.cgImage!.height)
            }
            //print("Viewtag : \(self.tag)")
            //print("targetMemo.image = \(targetMemo.image?.size)")
        }
        
        print("◎　[]⇒メモ：targetMemo.image = imgs[idx]")
        print("◆targetMemo.image?サイズ：\(temp):setMemoFromImgs(pn,imgs[])")
         print("◇CGImage.size:\(temp2)")

    }
    //+-+- $ -- 子メモの場合 --
    func setMemoFromImgs2(bt:Int,imgs:[UIImage]){
        //tag付の空メモページを作る
        makePageWithTag2(bTag:bt)//子メモの場合
        
        //pageImgs[指定ページ]の内容をメモページに取り込む
        for idx in 0..<pageGyou2{//pageGyou2:子メモの行数（８）
            let tag = bt*100 + idx + 1
            let targetMemo:UIImageView = self.viewWithTag(tag) as! UIImageView
            //print("bbbbbbbbbbb:\(pn)")
            
            targetMemo.image = imgs[idx]
            //タグ番号を画像に合成する：試験用
            if debug1 == true{
                //print("== Debug01モード ==")
                targetMemo.image = targetMemo.image?.addText(text: String(tag))
            }
        }

    }

    func setIndexView(){//最新版1201
        let pn = 0
        //tag付の空メモページを作る
        makePageWithTag(pn:0)
        
        //空白の画像をメモページに取り込む
        for idx in 0..<maxPageNum{
            let tag = pn*100 + idx + 1
            let targetMemo:UIImageView = self.viewWithTag(tag) as! UIImageView
            
            targetMemo.image = bImage//UIImage(named: "blankW.png")
            //タグ番号を画像に合成する：試験用
            //+-+-+targetMemo.image = targetMemo.image?.addText(text: String(tag))
        }
    }
    
    func setIndexFromImgs(imgs:[UIImage]){
        //tag付の空メモページを作る
            //makePageWithTag(pn:pn)
        //pageImgs[指定ページ]の内容をメモページに取り込む
        for idx in 0..<maxPageNum{
            let tag = idx + 1
            let targetMemo:UIImageView = self.viewWithTag(tag) as! UIImageView
            targetMemo.image = indexImgs[idx]
            //タグ番号を画像に合成する：試験用
            targetMemo.image = targetMemo.image?.addText(text: String(tag))
            print("\(tag)")
        }
        print("\(self.layer.bounds.width)")
    }


    /* メモにパレット内容を書き込む */
    func addMemo(img:UIImage,tag:Int){
        let targetMemo:UIImageView = self.viewWithTag(tag) as! UIImageView// ____子viewを取り出す(タグ番号:101）
        targetMemo.image = img
       
        print("◎パレット⇒メモ：targetMemo.image = パレットのimg")
        print("◆imgサイズ：\(img.size.height):addMemo(img,tag)")
        print("🔳cg-imgサイズ：\(String(describing: img.cgImage?.height))")
        //targetMemo.layer.borderColor = UIColor.redColor().CGColor
    }
    
    /* メモ内容を空白にする */
    func clearMemo(tag:Int){
        let img = bImage//UIImage(named: "blankW.png")
        let targetMemo:UIImageView = self.viewWithTag(tag) as! UIImageView// ____子viewを取り出す(タグ番号:101）
        targetMemo.image = img
    }
    
    /* メモ内容をパレットに読み込む */
    func readMemo(tag:Int) -> UIImage {
        print("here:readMemo")
        let targetMemo:UIImageView = self.viewWithTag(tag) as! UIImageView
        let leafImage = targetMemo.image!
        //========================================================
        let reSize = CGSize(width: vWidth, height: vHeight)
        let palleteImage = leafImage.resize2(size: reSize)
        
        //========================================================
        return palleteImage!//_____
        //let retImage = leafImage
        //return leafImage
    }
    
    /* 選択した行のメモの背景にカーソル色を付ける */
    func selectedNo(tagN:Int) {
        //表示中のフレーム番
        print("*** selectedNo(tag:Int) ***")
        //表示ページの全てのリーフの背景を透明にする
        for subview in self.subviews {
            subview.backgroundColor = UIColor.clear
            subview.alpha = 1// 透明度を設定
        }

        //+-+-子メモに背景色をつける(戻す)
        for subview in subMemo.subviews{
            subview.backgroundColor = UIColor.clear
            subview.alpha = 1// 透明度を設定
        }
        
        if childFlag == true{//+-+-
          subMemoView.backgroundColor = childColor
        }
        
        //新しく選択した行の背景に色を付ける
        print("newGyouNo:tag\(tagN)")
        let targetMemo:UIImageView = self.viewWithTag(tagN) as! UIImageView
        let gColor = UIColor.green.withAlphaComponent(0.01)   //(0.06)
        let gColor2 = UIColor.green.withAlphaComponent(0.15)
        //let wColor = UIColor.white
        let cColor = UIColor.rgb(r: 234, g: 204, b: 99, alpha: 0.4)//orange.withAlphaComponent(0.2) 234,204,99
        //カーソル色の代わりに縁取り画像を使う(2/24追加）
        let cursolView:UIView = UIView(frame: leafRect)
        cursolView.backgroundColor = gColor
        cursolView.layer.borderColor = gColor2.cgColor
        cursolView.layer.borderWidth = 6
        //中間線を追加
        let mline = UIView(frame: CGRect(x:leafWidth/2,y:0,width:2,height:leafHeight))
        mline.backgroundColor = gColor2
        cursolView.addSubview(mline)
        let cursolImg = cursolView.GetImage()
        //Indexページの場合は色を変える
        let backColor = (isIndexMode == true) ? cColor : gColor
        if isIndexMode == true{
          targetMemo.backgroundColor = backColor
        }else{
          targetMemo.backgroundColor = UIColor(patternImage: cursolImg)
        
        }
        //print("==▶mx[\(nowGyouNo)]:\(mx[String(nowGyouNo)]!)")
      
        // == debug2 ==========================================================
          if debug2 == true{//@@ DEBUG2 @@
            testV.layer.position = CGPoint(x: 0, y:vHeight/2 )
            print("** nowGyouNo: \(String(describing: nowGyouNo))")
            print("◆imgサイズ：\(String(describing: targetMemo.image?.size.height))")
            print("🔳cg-imgサイズ：\(String(describing: targetMemo.image?.cgImage?.height))")
          }
        // ====================================================================
    
    }
    
    func clearBackgroundColor(){
        for fn in 1...3{
            for gn in 0...pageGyou - 1{
                let tag = fn*100 + gn + 1
                let targetMemo:UIImageView = self.viewWithTag(tag) as! UIImageView
                targetMemo.backgroundColor = UIColor.clear
            }
        }
    }
    
    //-p- pageImgs[[]]の指定ページからpageView(tag付)を作成・返す
    //addSubviewしたviewを全削除する
    func removeAllSubviews(parentView: UIView){
        let subviews = parentView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    func makePageWithTag(pn:Int){//pn=0:indexページ

        //一旦、サブビューを削除する
        removeAllSubviews(parentView: self)
        //self.removeFromSuperview()
        
        //indexページだけtopOffsetを大きくする
        let topOffset2:CGFloat = (pn == 0) ?topOffset/2:topOffset
        let gnum = (pn == 0) ? maxPageNum : pageGyou//indexページは30行、メモは32行
        
        let pagePosX = (leafWidth)/2 //フレームの中点ｘ座標
        for idx in 0..<gnum {
            let myLeaf = Leaf(frame: leafRect)//リーフの初期化
            myLeaf.backgroundColor = UIColor.clear
            let yPos:CGFloat = topOffset2 + (leafHeight + leafMargin)*CGFloat(idx + 1) - leafHeight/2
            myLeaf.layer.position = CGPoint(x: pagePosX , y:yPos)
            
            if pn>0{  // == メモページの場合 ==
            //leafの枠の下線を灰色にする
              if idx == 0 || idx == pageGyou - 1{//1行目と32行目は実線、他は破線
                myLeaf.addBottomBorderWithColor(color: UIColor.gray, width: 1.5)
              }else{//破線
                
                myLeaf.drawDashedLine(color: UIColor.gray, lineWidth: 1, lineSize: 2, spaceSize: 2, type: .Down)
              }
                
            }else{  // == indexページの場合 ==
            //何もしない
            }
            
            let myTag = (pn)*100 + idx + 1// tagをつける.101-130|201-230|301-330
            myLeaf.tag = myTag
            myLeaf.image = bImage//グローバル変数：[leafWidth] x [lesfHeight]+-+-10x10に変更
            myLeaf.isUserInteractionEnabled = true
            self.addSubview(myLeaf)

            //print("tagNo = \(retView.tag)")
        }
    }
    
    func makePageWithTag2(bTag:Int){//+-+- $子メモページの初期化:bTagはtag番号101とか3032
    
        //一旦、サブビューを削除する
        removeAllSubviews(parentView: self)
        //indexページだけtopOffsetを大きくする
        let topOffset2:CGFloat = 0
        let pagePosX = (leafWidth)/2 //フレームの中点ｘ座標
        for idx in 0..<pageGyou2 { //0-7
            let myLeaf = Leaf(frame: leafRect)//リーフの初期化
            myLeaf.backgroundColor = UIColor.clear
            let yPos:CGFloat = topOffset2 + (leafHeight + leafMargin)*CGFloat(idx + 1) - leafHeight/2
            myLeaf.layer.position = CGPoint(x: pagePosX , y:yPos)
             //leafの枠の下線を灰赤色にする
            myLeaf.addLineForChild(color: UIColor.blue, lineWidth: 1.0,posX:10,lenX:0, spaceX: 7)//poXはここでは不要★20180815
            //myLeaf.drawDashedLine(color: UIColor.red.withAlphaComponent(0.3), lineWidth: 0.5, lineSize: 4, spaceSize: 0, type: .Down)
            /*   //leafの枠の下線を灰色にする
                if idx == pageGyou2 - 1{
                    myLeaf.addBottomBorderWithColor(color: UIColor.gray, width: 1.0)
                }else{
                    myLeaf.drawDashedLine(color: UIColor.red.withAlphaComponent(0.3), lineWidth: 0.5, lineSize: 4, spaceSize: 0, type: .Down)
                }
              */
            
            let myTag = bTag*100 + idx + 1//$ tagをつける.10101-10108|303201-303208
            myLeaf.tag = myTag
            myLeaf.image = bImage//グローバル変数：[leafWidth] x [lesfHeight]+-+-10x10に変更
            myLeaf.isUserInteractionEnabled = true
            self.addSubview(myLeaf)
            
            //print("tagNo = \(retView.tag)")
        }

    }
    
//         ----------　メモの行編集関係 ！ScrollViewでは？--------------
    
    /* 指定行のメモを削除する(Tag番号を付け替える）★今V.は非使用 */
    func delSelectedMemo(gyou:Int,maxGyou:Int){
        let tag = (pageNum)*100 + gyou//tag = 100 + 行番号
        let maxTag = (pageNum)*100 + maxGyou
        let myGyou = maxGyou - gyou
        if gyou < maxGyou{
            for k in 0...myGyou - 1{
                let targetMemo:UIImageView = self.viewWithTag(tag + k) as! UIImageView
                let targetMemo2:UIImageView = self.viewWithTag(tag + k + 1) as! UIImageView
                targetMemo.image = targetMemo2.image
                
            }
            
        }
        let targetMemo:UIImageView = self.viewWithTag(maxTag) as! UIImageView
        targetMemo.image = bImage//UIImage(named: "blankA.png")
    }
    
    /* 選択行の真下に空白のメモを一行追加する(Tag番号を付け替える)★今V.は非使用 */
    func insertNewMemo(gyou:Int,maxGyou:Int){
        let tag = (pageNum)*100 + gyou//tag = 300 + 行番号
       // let maxTag = (pageNum)*100 + maxGyou
        let myGyou = maxGyou - gyou
        
        if myGyou != 0{//最終行でない場合だけ処理する
            //メモ内容を１行づつ下にコピーする※但し、メモ末尾の内容は無くなる
            //対応1：1行を末尾に増やす。　対応2：次ページにコピーする
            for k in 1...myGyou{
                let n = myGyou - k
                let targetMemo:UIImageView = self.viewWithTag(tag + n) as! UIImageView
                let targetMemo2:UIImageView = self.viewWithTag(tag + n + 1) as! UIImageView
                targetMemo2.image = targetMemo.image
            }
            let targetMemo:UIImageView = self.viewWithTag(tag + 1) as! UIImageView
            targetMemo.image = bImage//UIImage(named: "blankA.png")
            nowGyouNo = nowGyouNo + 1
        }
        
    }

    
    //* メモ(leaf)[m]からメモ画像:[UIImage]を作成する */
    func memoToImgs(pn:Int) ->[UIImage]{
        var img:[UIImage] = []
        //メモ行の画像を順にimg[]にコピーする
        //var temp:CGFloat = 0:プリント文の為
        for idx in 0..<pageGyou{
            let tag = pn*100 + idx + 1
            let targetMemo:UIImageView = self.viewWithTag(tag) as! UIImageView
            img.append(targetMemo.image!)
            if idx<2{//◆テストです
            //temp = targetMemo.image!.size.height
            //print("◎　memo ⇒UP[]")
            //print("◆targetMemo.image!(30)のサイズ: \(temp)")
            //print("🔳cgimageのサイズ: \(targetMemo.image?.cgImage?.height)")
            }
        }
        //print("◎メモから[]へUP：img.append(targetMemo.image!)")
        //print("◆targetMemo.image!(30)のサイズ: \(temp)")
        return img
    }
    //* 子メモ(leaf)[m]からメモ画像:[UIImage]を作成する */
    func memoToImgs2(pn:Int) ->[UIImage]{//pn:親のtag番号　203
        var img:[UIImage] = []
        //メモ行の画像を順にimg[]にコピーする
        for idx in 0..<pageGyou2{
            let tag = pn*100 + idx + 1//$10
            let targetMemo:UIImageView = self.viewWithTag(tag) as! UIImageView
            img.append(targetMemo.image!)
        }
        return img
    }

    //----------------------------------------
    
    var cursolMode:Bool! = false
    func delCursol(){
        //表示ページの全てのリーフの背景を透明にする
        for subview in self.subviews {
            subview.backgroundColor = UIColor.clear
            subview.alpha = 1// 透明度を設定
        }
    }
    
    func togglleCursol(){
        if cursolMode == true{
           delCursol()
           cursolMode = false
        }else{}
    }
    

 //=========================== 未使用　======================================
    /*
     //* メモ(leaf)[m]をメモ画像:pageImgs[n]にUPする */
     func x_memoTopageImgsToMemo(pn:Int){
     //配列の画像を順にメモ行にコピーする
     for idx in 0..<pageGyou{
     let tag = pn*100 + idx + 1
     let targetMemo:UIImageView = self.viewWithTag(tag) as! UIImageView
     pageImgs[pn][idx] = targetMemo.image!
     }
     }
     */
    //* メモ画像:pageImgs[n]をメモ(leaf)[m]に読み込む */
    //func changePageNum(pn:Int){pageNum = pn}
    /*
     func x_TpageImgsToMemo(pn:Int,fn:Int){
     //配列の画像を順にメモ行にコピーする
     if fn == homeFrame{ changePageNum(pn: pn) }//フレーム２に入るページ（現行ページ）
     for idx in 0...pageGyou - 1{
     let tag = fn*100 + idx + 1
     let targetMemo:UIImageView = self.viewWithTag(tag) as! UIImageView
     //print("bbbbbbbbbbb:\(pn)")
     targetMemo.image = pageImgs[pn][idx]
     print("tag : \(tag)")
     //framePage[fn] = pn
     //print("targetMemo.image = \(targetMemo.image?.size)")
     }
     print("@@@@@@@@")
     }
     */
    //         ----------　Data保存に関する ！どこに置くの？--------------
    //--　メモ内容をUserDwfaultに保存する --
/*
    func saveImage3(pn:Int,imgs:[UIImage]){
        let photos = imgs
        let photoData: UserDefaults = UserDefaults.standard
        // [UIImage] → [NSData]
        
        let dataImages: [Data] = photos.map { (image) -> Data in
            UIImagePNGRepresentation(image)!
        }
        //
        let photosName:String = "photos" + String(pn)//保存名を決定
        photoData.set(dataImages, forKey: photosName)
        //photoData.synchronize()//必要かどうか？あると遅くなるのか？
        
    }
 */
 /*
    func x_setMemoView(pn:Int){//最新版1201
        //tag付の空メモページを作る
        makePageWithTag(pn:pn)
        
        //空白の画像をメモページに取り込む
        for idx in 0..<pageGyou{
            let tag = pn*100 + idx + 1
            let targetMemo:UIImageView = self.viewWithTag(tag) as! UIImageView
            
            targetMemo.image = UIImage(named: "blankW.png")
            //タグ番号を画像に合成する：試験用
            targetMemo.image = targetMemo.image?.addText(text: String(tag))
            //Indexページ固有の処理
            if pn == 0{
                //targetMemo.image = targetMemo.image?.addText(text: "INDEX")
            }
            
        }
    }
 */
    
}
