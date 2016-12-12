//
//  Memo.swift
//  Poke Memo
//
//  Created by 青山 行夫 on 2016/11/27.
//  Copyright © 2016年 mm289. All rights reserved.
//

import UIKit

class Memo2View:UIView{
    var memoNum:Int = 0
    let mWidth :CGFloat! = leafWidth// boundWidth - 20：メモクラスの幅
    let mHeight :CGFloat! = boundHeight//メモクラスの高さ
    let leafRect:CGRect = CGRect(x:0,y:0,width:leafWidth,height:leafHeight)
    
    
//  [リーフクラス]
    class Leaf: UIImageView {
        var leafStus:Int = 0//未使用
        var rightSpace:CGFloat! = leafWidth//右端までの余白の長さ
    }
//
    
    /* pageImageの要素画像をmemoViewにコピーします */
    func setMemoFromImgs(pn:Int,imgs:[UIImage]){
        //tag付の空メモページを作る
        makePageWithTag(pn:pn)
        
        //pageImgs[指定ページ]の内容をメモページに取り込む
        for idx in 0..<pageGyou{
            let tag = pn*100 + idx + 1
            let targetMemo:UIImageView = self.viewWithTag(tag) as! UIImageView
            //print("bbbbbbbbbbb:\(pn)")
            
            targetMemo.image = imgs[idx]//???pageImgsを無くす??
            //タグ番号を画像に合成する：試験用
            targetMemo.image = targetMemo.image?.addText(text: String(tag))
            
            if idx == 0 && pn == 0{
                targetMemo.image = targetMemo.image?.addText(text: "INDEX")
            }
            
            //print("Viewtag : \(self.tag)")
            //print("targetMemo.image = \(targetMemo.image?.size)")
        }
    }
    
    func setMemo2View(pn:Int){//最新版1201
       //tag付の空メモページを作る
        makePageWithTag(pn:pn)
        
       //pageImgs[指定ページ]の内容をメモページに取り込む
        for idx in 0..<pageGyou{
            let tag = pn*100 + idx + 1
            let targetMemo:UIImageView = self.viewWithTag(tag) as! UIImageView
            //print("bbbbbbbbbbb:\(pn)")
            
            targetMemo.image = pageImgs[pn][idx]//???pageImgsを無くす??
            //タグ番号を画像に合成する：試験用
            targetMemo.image = targetMemo.image?.addText(text: String(tag))
        /*
            if idx == 0 && pn == 0{
                targetMemo.image = targetMemo.image?.addText(text: "INDEX")
            }
        */
            //print("Viewtag : \(self.tag)")
            //print("targetMemo.image = \(targetMemo.image?.size)")
        }
    }

    /* メモにパレット内容を書き込む */
    func addMemo(img:UIImage,tag:Int){
        let targetMemo:UIImageView = self.viewWithTag(tag) as! UIImageView// ____子viewを取り出す(タグ番号:101）
        targetMemo.image = img
        //targetMemo.layer.borderColor = UIColor.redColor().CGColor
    }
    
    /* メモ内容を空白にする */
    func clearMemo(tag:Int){
        let img = UIImage(named: "blankW.png")
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
        let palleteImage = leafImage.resize(size: reSize)
        
        //========================================================
        return palleteImage//_____
    }
    
    /* 選択した行のメモの背景に色を付ける */
    func selectedNo(tagN:Int) {
        //表示中のフレーム番
        print("*** selectedNo(tag:Int) ***")
        //表示ページの全てのリーフの背景を透明にする
        for subview in self.subviews {
            subview.backgroundColor = UIColor.clear
            subview.alpha = 1// 透明度を設定
        }

        //新しく選択した行の背景に色を付ける
        print("newGyouNo:tag\(tag)")
        
        //↓エラー
        let targetMemo:UIImageView = self.viewWithTag(tagN) as! UIImageView
        let gColor = UIColor.green.withAlphaComponent(0.1)
        let wColor = UIColor.white
        var backColor = isIndexMode == true ? wColor : gColor
        targetMemo.backgroundColor = backColor
 
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
        
        let pagePosX = (leafWidth)/2 //フレームの中点ｘ座標
        for idx in 0..<pageGyou {
            let myLeaf = Leaf(frame: leafRect)//リーフの初期化
            myLeaf.backgroundColor = UIColor.clear
            let yPos:CGFloat = topOffset + (leafHeight + leafMargin)*CGFloat(idx + 1) - leafHeight/2
            myLeaf.layer.position = CGPoint(x: pagePosX , y:yPos)
            
            //leafの枠の下線を灰色にする
            if idx == 0 && pn>0{
                myLeaf.addBottomBorderWithColor(color: UIColor.gray, width: 1.5)
            }else{
                myLeaf.drawDashedLine(color: UIColor.gray, lineWidth: 1, lineSize: 2, spaceSize: 1, type: .Down)
            }
            let myTag = (pn)*100 + idx + 1// tagをつける.101-130|201-230|301-330
            myLeaf.tag = myTag
            myLeaf.image = UIImage(named: "blankW.png")
            //print("myTag?:\(myTag)")
            myLeaf.isUserInteractionEnabled = true
            self.addSubview(myLeaf)

            //print("tagNo = \(retView.tag)")
        }
    }
//         ----------　メモの行編集関係 ！ScrollViewでは？--------------
    
    /* 指定行のメモを削除する(Tag番号を付け替える） */
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
        targetMemo.image = UIImage(named: "blankA.png")
    }
    
    /* 選択行の真下に空白のメモを一行追加する(Tag番号を付け替える) */
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
            targetMemo.image = UIImage(named: "blankA.png")
            nowGyouNo = nowGyouNo + 1
        }
        
    }
//         ----------　Data保存に関する ！どこに置くの？--------------
    /*　メモ内容をUserDwfaultに保存する */
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
    
    //* メモ(leaf)[m]からメモ画像:[UIImage]を作成する */
    func memoToImage(pn:Int) ->[UIImage]{
        var img:[UIImage] = []
        //メモ行の画像を順にimg[]にコピーする
        for idx in 0..<pageGyou{
            let tag = pn*100 + idx + 1
            let targetMemo:UIImageView = self.viewWithTag(tag) as! UIImageView
            img.append(targetMemo.image!)
        }
        return img
    }
    
    //* メモ(leaf)[m]をメモ画像:pageImgs[n]にUPする */
    func memoTopageImgsToMemo(pn:Int){
        //配列の画像を順にメモ行にコピーする
        for idx in 0..<pageGyou{
            let tag = pn*100 + idx + 1
            let targetMemo:UIImageView = self.viewWithTag(tag) as! UIImageView
            pageImgs[pn][idx] = targetMemo.image!
        }
    }
    
    //* メモ画像:pageImgs[n]をメモ(leaf)[m]に読み込む */
    func changePageNum(pn:Int){pageNum = pn}
    
    func TpageImgsToMemo(pn:Int,fn:Int){
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
        }else{
            
        }
    }
}
