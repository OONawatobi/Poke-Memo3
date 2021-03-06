//
//  Editor.swift
//  Poke Memo
//
//  Created by 青山 行夫 on 2016/12/23.
//  Copyright © 2016年 mm289. All rights reserved.
//

import UIKit

extension UIImage {
    //使い方：let colorImage = UIImage.colorImage(UIColor.greenColor(), size: size)
    class func colorImage(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        
        let rect = CGRect(origin:CGPoint.zero, size: size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        return image
    }
}

class EditorView: UIView {
/*
      2017 var pen:UIImage!
      2017 var secondView: UIView!
      2017 var myImageView:UIImageView!
*/
    // UIView(cursolView)を作成する
    var cursolView: UIView!

    func setMyCursolView(){//範囲編集パネル
        print("func cursolView!!!!!!!")
        let myX = CGFloat(-10)//画面から隠れた場所に位置する
        cursolView = UIView(frame: CGRect(x:myX,y:0,width:5,height:self.bounds.height))
        // 背景
        //let myImg = UIImage(named: "bg3.png")
        //print("myInt: \(myInt)")
        
        switch myInt {
          case "OVW" :
            cursolView.backgroundColor = UIColor(white: 1,alpha: 1)
          case "DEL" :
            cursolView.backgroundColor = UIColor(white: 0.3,alpha: 1)
          case "INS" :
            cursolView.backgroundColor = UIColor(white: 0.5,alpha: 0.5)
          default ://　それ以外の時はここを実行
            cursolView.backgroundColor = UIColor.clear
        }
        
        // UIImageViewをSecondViewに追加する.
        //??secondView.addSubview(cursolView)
        self.addSubview(cursolView)
        //イベントの透過
        cursolView.isUserInteractionEnabled = false
    }
    // 挿入位置カーソル
    func changeMyCursolView(curX:CGFloat){//カーソルビューの初期化
        let myX = curX
        cursolView.frame = CGRect(x: myX,y: 0,width: 3,height: self.bounds.height)
        cursolWFlag = false
    }
    //編集範囲カーソル
    func changeMyCursolView2(curX:CGFloat,startX:CGFloat){
        let myW = self.bounds.width
        var myL = min(curX, startX)
        var myR = max(curX, startX)
        
        if myL < 0 { myL = 0 }
        if myR > myW{ myR = myW}
        cursolView.frame = CGRect(x: myL,y: 0,width: myR - myL,height: self.bounds.height)
        if myR - myL < 5  {
            cursolWFlag = false
        }else{ cursolWFlag = true}
    }
    
    /*  -----------------------------------------------------------
     [コンテナ]  [パレット: { A ‖ B | C } ]   [ セレクト範囲 ]
     ^p1 ^p2(※ p1 →p2)
     Rec01-->    { [A]  B   C  }         : 0～p1
     Rec02-->    {  A  [B]  C  }         : p1～p2
     Rec03-->    {  A   B  [C] }         : p2～pw(パレット末尾)
     Rec05-->    {  A  [B   C] }         : p1～pw　※INS時の右端
     Rec08-->    {  A   C  [ ] }         : DEL時の右端
     [コンテナ]  [パレット: { A | B ‖ C } ]   [ セレクト範囲 ]
     ^p1 ^p2(※ p2 →p1)
     Rec01-->    { [A]  B   C  }         : 0～p2
     Rec02-->    {  A  [B]  C  }         : p2～p1
     Rec03-->    {  A   B  [C] }         : p1～pw(パレット末尾)
     Rec04-->    { [A   B]  C  }         : 0～p2　※INS時の左端
     //書き出し専用
     Rec06-->    {  A   B  [B] C  }     : p2～p2+abs(p2-p1)　※INS時の右端
     Rec07-->    {  A   B   B [C] }     : abs(p2-p1)～pｗ
     Rec08-->    {  A   C  [C] }     　　:DEL時の右端
     //---------------------------------------------------------- */
    
    func editPallete(sel:String) -> UIImage {
        //let cropImage:UIImage! = nil
        let myWidth:CGFloat = self.bounds.width
        let myHeight:CGFloat = self.bounds.height
        let pixWidth:CGFloat = myWidth * CGFloat(retina)
        let pixHeight:CGFloat = myHeight * CGFloat(retina)
        
        self.cursolView.removeFromSuperview()//カーソル画面を撤去する
        let containerView = UIView(frame: CGRect(x:0,y:0,width:self.bounds.width,height:self.bounds.height))
               //print("B @@@@@@@@@@@@@@@@@@@@@@@")
        //時間−平面点変換
        var leftX = min(cursolStartX, cursolEndX)
        var rightX = max(cursolStartX, cursolEndX)
        if leftX < 5 { leftX = 5 }//端からはみ出さないようにする?0にはしない
        if rightX >= myWidth - 5 {
            print("rightX: \(rightX)")
            rightX = myWidth - 5
        }//同上
        
        //retina に対応する為
        let pixLeftX = leftX * CGFloat(retina)
        let pixRightX = rightX * CGFloat(retina)
        
        //画面のクリップ（全てのカーソル区切りエリア毎に）
        //  []◾[]:上書き||DEL , [ ][⬜]：挿入1 , [ ⬜][]：挿入2
             //  print("C @@@@@@@@@@@@@@@@@@@@@@@")
        let clip01 = CGRect(x:0,y:0 ,width:pixLeftX,height:pixHeight)
        //let clip02 = CGRect(x:pixLeftX,y:0 ,width:pixRightX - pixLeftX,height:pixHeight)
        let clip03 = CGRect(x:pixRightX,y:0 ,width:pixWidth - pixRightX,height:pixHeight)
        let clip04 = CGRect(x:0,y:0,width:pixRightX,height:pixHeight)
        let clip05 = CGRect(x:pixLeftX,y:0,width:pixWidth - pixLeftX,height:pixHeight)
        //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        let pImage = drawableView.GetImage()//パレット全画面の切り取り
        let clipImage01 =  pImage.cgImage!.cropping(to: clip01)
        //let clipImage02 =  pImage.cgImage!.cropping(to: clip02)
        let clipImage03 =  pImage.cgImage!.cropping(to: clip03)
        let clipImage04 =  pImage.cgImage!.cropping(to: clip04)
        let clipImage05 =  pImage.cgImage!.cropping(to: clip05)
        
        //CGImage　→UIImageに変換(retinaの場合は1/2倍サイズ）
        let clip01U:UIImage = downSize(image: UIImage(cgImage: clipImage01!), scale: retina)
        //let clip02U:UIImage = downSize(image: UIImage(cgImage: clipImage02!), scale: retina)
        
        let clip03U:UIImage = downSize(image: UIImage(cgImage: clipImage03!), scale: retina)
               //print("D1 @@@@@@@@@@@@@@@@@@@@@@@")
        let clip04U:UIImage = downSize(image: UIImage(cgImage: clipImage04!), scale: retina)
        let clip05U:UIImage = downSize(image: UIImage(cgImage: clipImage05!), scale: retina)
        
        //** ブランク画像の作成(clip02のブランク画像）**//
        
        //  == INS時,DEL時におけるmx[]の確認と変更 ==
        var saX:CGFloat = rightX - leftX//カーソルの巾
              //print("1qqvWidth:\(vWidth)qqqqqqqqq")
        let myX:CGFloat = mx[String(nowGyouNo)]!//現行のmaxX
        let atoX:CGFloat = (vWidth - 10) - myX
            print("2qqqq: atoX:\(atoX)= W:\(vWidth - 10) - myX:\(myX)qqqqqqq")
        
        /* INS の場合 */
        if sel == "INS"{
        
          //末尾が消えないようにカーソル巾を変更
          if atoX < saX{
            saX = atoX
            cursolWFlag = false
          }else{}
        
            print("3qqqqqqq saX:\(saX)qqqq")
          mxTemp = mx[String(nowGyouNo)]! + saX //mx[]の変更
          mx[String(nowGyouNo)]! = mxTemp//mx[]への反映
            
        }else if sel == "DEL"{
            
        /* DEL の場合 */
        let saX2 = rightX < myX ? saX : myX - leftX//最後文字までの分を考慮
           mxTemp = mx[String(nowGyouNo)]! - saX2 //mx[]の変更
           mx[String(nowGyouNo)]! = mxTemp//mx[]への反映
        }
        
        /* OVW,INS,DEL共通の処理 */
        //blankImgeをnilにしないために最小巾のカーソルを作る
        if saX<=0{ saX = 1 }
        
        //末尾に余裕が無い場合は
        if mx[String(nowGyouNo)]! >= (vWidth - 10){
            if sel == "INS"{
              cursolWFlag = false//但し、実際には再描画をしないようにする
            }
        }
        //  =========  ココまで    ==========
        
        let size = CGSize(width: saX, height: myHeight)
        let blankImge = UIImage.colorImage(color: UIColor.clear, size: size)
              //print("D @@@@@@@@@@@@@@@@@@@@@@@")
        
        //コンテナへの書き込み
        var clips:[UIImage]! = []
        switch sel {
        case "OVW":
            clips.append(clip01U)
            clips.append(blankImge)
            clips.append(clip03U)
            
        case "DEL":
            clips.append(clip01U)
            clips.append(clip03U)
            clips.append(blankImge)
            
        case "INS":
            if cursolStartX <= cursolEndX{
                clips.append(clip01U)
                clips.append(blankImge)
                clips.append(clip05U)
                
            }else{
                clips.append(clip04U)
                clips.append(blankImge)
                clips.append(clip03U)
                
            }
            
        default: break
        }
              //print("E @@@@@@@@@@@@@@@@@@@@@@@")
        let crop = addContainer(containerView: containerView,clips: clips)
        return crop
    }
    
    /* コンテナVIEWの中に画像配列の要素を左端から順に取り込む */
    func addContainer(containerView:UIView,clips: [UIImage]) -> UIImage{
        
        let k = clips.count - 1
        var p1:CGFloat = 0
        var p2:CGFloat = 0
        //コンテナの中身をクリアする
        for subview in containerView.subviews {
            subview.removeFromSuperview()
        }
        //コンテナの中身にclips[]を追加する
        for num in 0...k{
            let nSize:CGSize = clips[num].size
            p2 = p1 + nSize.width//---------------------------
            let nFrame = CGRect(x:p1,y:0,width:p2 - p1,height:nSize.height)
            print("p1: \(p1)" + " p2: \(p2)")
            //書き込みコンテナ(ImageView)
            let nImageView = UIImageView(frame: nFrame)
            nImageView.image = clips[num]
            containerView.addSubview(nImageView)
            p1 = p1 + nSize.width//---------------------------
            
        }
        //コンテナを結合してイメージに変換する
        // let cropImageView = UIImageView(frame: CGRectMake(0, 0, self.frame.width, self.frame.height))
        let crop = containerView.GetImage()
        return crop
    }
    

    func downSize(image: UIImage, scale: Int) -> UIImage {
        print("=downSize01=")
        let ref: CGImage = image.cgImage!
        let srcWidth: Int = ref.width
        let srcHeight: Int = ref.height
        var myScale:Int!
        if scale <= 0{myScale = 1}else{myScale = scale}
        let newWidth = srcWidth / myScale
        let newHeight = srcHeight / myScale
        let size: CGSize = CGSize(width: newWidth, height: newHeight)
        UIGraphicsBeginImageContext(size)
        print("=downSize02=")
        image.draw(in: CGRect(x:0,y:0,width:size.width,height:size.height))
        print("=downSize03=")
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizeImage!
    }
/* 2017
    //ペンカーソルの表示位置設定
    func setPosx(x:CGFloat,y: CGFloat) {
        //myImageView.image = pen
        myImageView.layer.position = CGPoint(x: x, y: y)
        print("¥(myImageView.layer.position)")
    }
    //pen 画層の選択
    func hatena(pen:UIImage){
        myImageView.image = pen
    }
*/
    //--------------------------------------------------------
    //??var lines: [Line] = []
    //??var currentLine: Line? = nil
    var X_color = 0//?
    let xOfset:CGFloat! = 0//===================-20
    let yOfset:CGFloat! = -35//==================-35
    var cursolStartX:CGFloat!//?タッチ開始点のｘ座標
    var cursolEndX:CGFloat!//?タッチ終了点のｘ座標
    var isSpace:Bool = true//右側スペースがある場合：true
    // タッチされた
    override func touchesBegan(_ touches:Set<UITouch>, with event: UIEvent?) {
        print("touchbegan")
        if editFlag == false{return}//編集モードが選択されていない時はパス
        let point = touches.first!.location(in: self)
        cursolStartX = point.x//?タッチ開始点のｘ座標
        changeMyCursolView(curX: cursolStartX)//?

    }
    
    // タッチが動いた
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("touchesMoved")
        
        if editFlag == false{return}//編集モードが選択されていない時はパス
        let point = touches.first!.location(in: self)
        
        //mx[]より右側では編集不可（パス）
        isSpace = Double(cursolStartX) < Double(mx[String(nowGyouNo)]! - 10) ? true:false
        //isSpace = Double(cursolStartX) < Double(mxTemp - 10) ? true:false
        print("mx:\(String(describing: mx[String(nowGyouNo)])),isSpace:\(isSpace)")
        
        if isSpace {changeMyCursolView2(curX: point.x,startX:cursolStartX)
        }else{
          changeMyCursolView2(curX: cursolStartX,startX:cursolStartX)
        }
    }
    
    // タッチが終わった
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if editFlag == false{return}//編集モードが選択されていない時はパス
        let point = touches.first!.location(in: self)
        cursolEndX = point.x//動作最終点が残る

    }

/*
    func resetContext(context: CGContext) {
        context.clear(self.bounds)
        if let color = self.backgroundColor {
            color.setFill()
        } else {
            UIColor.white.setFill()
        }
        context.fill(self.bounds)
    }
*/
}
