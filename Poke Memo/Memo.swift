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
    let mHeight :CGFloat! = boundHeight//メモクラスの高さ
    let leafRect:CGRect = CGRect(x:0,y:0,width:leafWidth,height:leafHeight)
    var framePage:[Int] = [0,1,2,3]
    //let topOffset:CGFloat = 10//メモ開始位置(上部スペース量）
    class Leaf: UIImageView {
        var leafNum:Int = 0
        var rightSpace:CGFloat! = leafWidth// boundWidth - 20//右端までの余白の長さ
        
    }
    
    /* メモにパレット内容を書き込む */
    func addMemo(img:UIImage,tag:Int){
        let targetMemo:UIImageView = self.viewWithTag((frameNum*1)*100 + tag) as! UIImageView// ____子viewを取り出す(タグ番号:101）
        targetMemo.image = img
        //targetMemo.layer.borderColor = UIColor.redColor().CGColor
    }
    
    /* メモ内容を空白にする */
    func clearMemo(tag:Int){
        let img = UIImage(named: "blankW.png")
        let targetMemo:UIImageView = self.viewWithTag((frameNum*1)*100 + tag) as! UIImageView// ____子viewを取り出す(タグ番号:101）
        targetMemo.image = img
    }
    
    /* メモ内容をパレットに読み込む */
    func readMemo(tag:Int) -> UIImage {
        let targetMemo:UIImageView = self.viewWithTag((frameNum*1)*100 + tag) as! UIImageView
        let leafImage = targetMemo.image!
        //========================================================
        let reSize = CGSize(width: vWidth, height: vHeight)
        let palleteImage = leafImage.resize(size: reSize)
        
        //========================================================
        return palleteImage//_____
    }
    
    /* 選択した行のメモの背景に色を付ける */
    func selectedNo(gyou:Int,fn:Int) {
        //表示中のフレーム番号
        
        //print("*** selectedNo(tag:Int) ***")
        //一つ前に選択した行を初期状態に戻す
        let tag2 = (fn)*100 + beforeGyouNo
        print("beforeGyouNo:tag\(tag2)")
        let targetMemo2:UIImageView = self.viewWithTag(tag2) as! UIImageView
        //targetMemo2.changeBottomBorder(UIColor.lightGrayColor(), width: 1)
        targetMemo2.backgroundColor = UIColor.clear
        
        //新しく選択した行の背景に色を付ける
        let tag = (frameNum*1)*100 + gyou//tag = 100 + 行番号
        print("newGyouNo:tag\(tag)")
        
        let targetMemo:UIImageView = self.viewWithTag(tag) as! UIImageView
        //targetMemo.changeBottomBorder(UIColor.magentaColor(), width:2 )
        let myColor = UIColor.green
        let selectedColor = myColor.withAlphaComponent(0.1)
        targetMemo.backgroundColor = selectedColor
        beforeGyouNo = gyou//選択した行を記憶する
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
    
    
    /* 指定のframeに指定のpageImgs[]の内容をコピーする*/
    func make3BlankMemo(){ //fn=1:left,2:center,3:right
        
        var testview = UIView(frame: CGRect(x:leafWidth*0,y:0,width:leafWidth,height:50))
        testview.backgroundColor = UIColor.yellow
        self.addSubview(testview)
        
        var testview2 = UIView(frame: CGRect(x:leafWidth,y:0,width:leafWidth,height:50))
        testview2.backgroundColor = UIColor.green
        self.addSubview(testview2)
        
        var testview3 = UIView(frame: CGRect(x:leafWidth*2,y:0,width:leafWidth,height:50))
        testview3.backgroundColor = UIColor.red
        self.addSubview(testview3)
        
        //----------- test end -------------------
        
        for fn in 1...3{//30行数分の空白メモを作成(3フレーム分）
            
            let pagePosX:CGFloat!
            pagePosX = (leafWidth) * (CGFloat(fn) - 0.5)//フレームの中点ｘ座標
            print("pagePosX: \(pagePosX)")
            for idx in 0...pageGyou - 1{
                let myLeaf = Leaf(frame: leafRect)
                myLeaf.backgroundColor = UIColor.clear
                let yPos:CGFloat = topOffset + (leafHeight + leafMargin)*CGFloat(idx + 1) - leafHeight/2
                myLeaf.layer.position = CGPoint(x: pagePosX , y:yPos)
                
                //leafの枠の下線を灰色にする
                if idx == 0{
                    myLeaf.addBottomBorderWithColor(color: UIColor.lightGray, width: 1.5)
                }else{
                    myLeaf.drawDashedLine(color: UIColor.gray, lineWidth: 1, lineSize: 2, spaceSize: 1, type: .Down)
                }
                
                myLeaf.tag = (fn)*100 + idx + 1// tagをつける.101-130|201-230|301-330
                myLeaf.image = UIImage(named: "blankP.png")
                myLeaf.isUserInteractionEnabled = true
                self.addSubview(myLeaf)
                //print("tagNo = \(myLeaf.tag)")
            }
        }
        
    }
    
    
    /* 指定行のメモを削除する(Tag番号を付け替える） */
    func delSelectedMemo(gyou:Int,maxGyou:Int){
        let tag = (frameNum*1)*100 + gyou//tag = 100 + 行番号
        let maxTag = (frameNum*1)*100 + maxGyou
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
        let tag = (frameNum*1)*100 + gyou//tag = 300 + 行番号
        let maxTag = (frameNum*1)*100 + maxGyou
        let myGyou = maxGyou - gyou
        
        if myGyou != 0{//最終行でない場合だけ処理する
            //メモ内容を１行づつ下にコピーする※但し、メモ末尾の内容は無くなる
            //対応1：1行を末尾に増やす。　対応2：次ページにコピーする
            for k in 1...myGyou{
                var n = myGyou - k
                let targetMemo:UIImageView = self.viewWithTag(tag + n) as! UIImageView
                let targetMemo2:UIImageView = self.viewWithTag(tag + n + 1) as! UIImageView
                targetMemo2.image = targetMemo.image
            }
            let targetMemo:UIImageView = self.viewWithTag(tag + 1) as! UIImageView
            targetMemo.image = UIImage(named: "blankA.png")
            nowGyouNo = nowGyouNo + 1
        }
        
        /* ※基本は最大行は固定、但し行挿入した場合は行追加も一つの方法。以下はその場合に使う。
         //メモを一つ追加する（ページ行を増やす）
         //末尾メモが空白でない場合のみ、1行追加する(空白残量の取得が必須）
         
         let myLeaf = Leaf(frame: leafRect)//UIImageView(frame: leafRect)
         myLeaf.backgroundColor = UIColor.clearColor()
         //let topOffset:CGFloat = 10//メモ開始位置(上部スペース量）
         let yPos:CGFloat = topOffset + (leafHeight + leafMargin) * CGFloat(maxGyou + 1) - leafHeight / 2//leafViewの中央点のy座標
         myLeaf.layer.position = CGPoint(x: (leafWidth)/2 , y:yPos)
         //leafの枠の下線を灰色にする
         myLeaf.addBottomBorderWithColor(UIColor.redColor(), width: 1)
         //myLeaf.drawDashedLine(UIColor.lightGrayColor(), lineWidth: 3, lineSize: 1, spaceSize: 3, type: .Down)
         
         myLeaf.tag = maxTag + 1// tagをつける301...
         myLeaf.image = UIImage(named: "blankA.png")
         myLeaf.userInteractionEnabled = true
         self.addSubview(myLeaf)
         pageGyou += 1
         */
        
    }
    
    /*　メモ内容をUserDwfaultに保存する */
    func saveImage3(pn:Int,imgs:[UIImage]){
        let photos = imgs
        let photoData: UserDefaults = UserDefaults.standard
        // [UIImage] → [NSData]
    /*
        let dataImages: [NSData] = photos.map { (image) -> NSData in
            UIImagePNGRepresentation(image)!
        }
        //
        let photosName:String = "photos" + String(pn)//保存名を決定
        photoData.set(dataImages, forKey: photosName)
        //photoData.synchronize()//必要かどうか？あると遅くなるのか？
    */
 }
    
    //* メモ(leaf)[m]をメモ画像:pageImgs[n]にUPする */
    func TmemoTopageImgsToMemo(pn:Int,fn:Int){
        //配列の画像を順にメモ行にコピーする
        for idx in 0...pageGyou - 1{
            let tag = fn*100 + idx + 1
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
            print("bbbbbbbbbbb:\(pn)")
            targetMemo.image = pageImgs[pn][idx]
            print("tag : \(tag)")
            //framePage[fn] = pn
            //print("targetMemo.image = \(targetMemo.image?.size)")
        }
         print("@@@@@@@@")
    }
    
    func pageImgsToMemo(pn:Int,fn:Int){
        //配列の画像を順にメモ行にコピーする
        if fn == 1{ pageNum = pn }//フレーム２に入るページ（現行ページ）
        for idx in 0...pageGyou - 1{
            let tag = fn*100 + idx + 1
            let targetMemo:UIImageView = self.viewWithTag(tag) as! UIImageView
            //print("bbbbbbbbbbb:\(pn)")
            targetMemo.image = pageImgs[pn][idx]
            //print("tag : \(tag)")
            framePage[fn] = pn
            //print("targetMemo.image = \(targetMemo.image?.size)")
        }
    }
    
    //pnのメモ内容を画像配列に取り込む旧名:saveImage2
    func memo2ImagsNew(fn:Int)-> [UIImage]{
        var imgs:[UIImage] = []
        for idx in 0...pageGyou - 1{
            let tag = fn*100 + idx + 1
            let targetMemo:UIImageView = self.viewWithTag(tag) as! UIImageView
            imgs.append(targetMemo.image!)
        }
        return imgs
    }
    
    
    
    /*　UIImageのサイズを変える関数 */
    func downSize(image: UIImage, scale: Int) -> UIImage {
        let ref: CGImage = image.cgImage!
        let srcWidth: Int = ref.width
        let srcHeight: Int = ref.height
        var myScale:Int!
        if scale <= 0{myScale = 1}else{myScale = scale}
        let newWidth = srcWidth/myScale
        let newHeight = srcHeight/myScale
        let size: CGSize = CGSize(width: newWidth, height: newHeight)
        
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(x:0,y: 0,width: size.width,height: size.height))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizeImage!
    }
}
