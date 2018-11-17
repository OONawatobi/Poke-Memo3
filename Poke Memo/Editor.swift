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
    //色付きの丸
    class func colorImage2(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        
        let rect = CGRect(origin:CGPoint.zero, size: size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        //context!.fill(rect)//四角に塗りつぶす
        
        context!.fillEllipse(in: rect)//丸型に変形させる
        // 円は引数のCGRectに内接する
        
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

    func maskCorner(radius r: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        
        let rect = CGRect(origin: .zero, size: self.size)
        UIBezierPath(roundedRect: rect, cornerRadius: r).addClip()
        draw(in: rect)
        let clippedImage = UIGraphicsGetImageFromCurrentImageContext()
            
        UIGraphicsEndImageContext()
        return clippedImage
        }
    }


class EditorView: UIView {
/*
      2017 var pen:UIImage!
      2017 var secondView: UIView!
      2017 var myImageView:UIImageView!
*/
    var Delegate: EditorViewDelegate!//🔻マークの操作などを外部で処理（委託）する。
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
        var pImage = drawableView.GetImage()//パレット全画面をコピー
        //🔻マークを削除する(空白でない子メモを有する親メモの場合だけ)
        if nowGyouNo < 10000{
            //子メモの非空白行の数を取得
            let xx0 = self.Delegate?.checkUsedLine(tag:oyaGyou)
            if xx0 != 0{//🔻マーク有り
                print("🔻🔻🔻🔻\(String(describing: xx0))🔻🔻🔻🔻")
                pImage = pImage.addText_Mark(text: "∇", del: true)//削除する
            }
        }
        //日付を削除する(１行目だけ)
        if nowGyouNo%100 == 1{
            pImage = pImage.addText_Date(text: "", del: true)//削除する
        }
               
//
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

}

class SelectView:UIView{
    var Delegate: SelectViewDelegate!//アッパーツールビューの操作を外部で処理（委託）する。
    //ボタンを作成する
    var penColor = UIColor.black
    var btnImgs:[UIImage] = []//★★色セレクトボタン画像：丸
    //var btnImgs2:[UIImage] = []//★★ペンセレクトボタン画像：四角
    var bacBtn:UIImageView!//swapボタンの背景色を作るためのView
    //ボタン画像の作成
    let penJ = UIImage(named: "鉛筆.png")!
    let penE = UIImage(named: "pencil2.png")!
    let GpenJ = UIImage(named: "Gペン.png")!
    let GpenE = UIImage(named: "gpen2.png")!
    let markJ = UIImage(named: "マーカーJ.png")!
    let markE = UIImage(named: "markerE.png")!
    var swapBtn:UIButton!
    let imS = UIImage(named: "swap1z")
    let imN = UIImage(named: "swap0z")
    //セレクトパネルの背景色:角丸表示にするために必要
    //let sRect = CGRect(x:0,y:0,width:50*6 + 15 + 5,height: 44)
    //var select_bg = UIView(frame: CGRect(x:0,y:0,width:320,height: 44))
    //var selct_pnl = UIView(frame: CGRect(x:3,y:3,width:310,height: 42))
 
    //ボタンダウン時の画像
    var tImg2:[UIImage] = [UIImage(named: "pen3.pdf")!,UIImage(named: "gpen01.pdf")!,UIImage(named: "markerM.png")!]
    //セレクトパネルの高さselHeightからボタンの位置を決める
    var selHeight2:CGFloat = selHeight - 40 - 2//ボタンの位置
    //----------------------------------------------------//
    
    func setMenu(){ //UIButtonはここで作成する
        print("select2btn is selected!!")
        //selectViewを空にする
        self.deleteSubviews()
        self.backgroundColor = UIColor(patternImage: UIImage(named:"colorVBg2b")!)
  /*
        self.backgroundColor = UIColor.clear
        select_bg.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        selct_pnl.backgroundColor = UIColor.rgb(r: 254, g: 243, b: 242, alpha: 1.0)//white.withAlphaComponent(1.0)
        
        selct_pnl.layer.borderColor = UIColor.black.cgColor
        selct_pnl.layer.borderWidth = 0.3
        select_bg.roundCorners([.topLeft, .topRight], radius: 8.0)
        selct_pnl.roundCorners([.topLeft, .topRight], radius: 8.0)
        select_bg.addSubview(selct_pnl)
        self.addSubview(select_bg)
 */
        //ツールバーの高さを取得した後の再設定
        if boundWidthX == boundWidth{//縦場面の場合
         select_pcView.layer.position.y = boundHeight - vHeight - 40 - selHeight/2 - th
        }
        bacBtn = UIImageView(frame: CGRect(x:15,y:
            selHeight2 + 5,width:30,height:30))
        swapBtn = UIButton(frame: CGRect(x:15,y:selHeight2 + 5,width:30,height:30))
        bigBtm = UIImageView(frame: CGRect(x:0,y:selHeight2 + 5,width:30,height:30))//★★ボタンを押した時の大きい丸
        //ボタン画像の作成
        //角丸/丸ボタンを作成する
        btnImgs = []//一旦、空にする
        for i in 0...5 {
           if marker{  //角丸の色画像を作成する
            btnImgs.append(UIImage.colorImage(color: mColor[i], size: CGSize(width: 20, height: 20)).maskCorner(radius: 4)! )
           }else{      //円形の色画像を作成する
            btnImgs.append(UIImage.colorImage2(color: bColor[i], size: CGSize(width: 20, height: 20)))
           }
        }

        //6個のボタンを作成する
        for i in 0...5 {//print("\(i)")
            //btnImgs.append( UIImage.colorImage2(color: xColor[i], size: CGSize(width: 20, height: 20)))//円形の色画像を作成する
            let xx:CGFloat = i == 1 ? (marker ? 0 : 10) : 0//第２ボタンだけ位置をづらす
            let selBtn:UIButton = UIButton(frame: CGRect(x:CGFloat(15 + i*50) - xx,y:selHeight2,width:40,height:40))
            selBtn.tag = i
            selBtn.addTarget(self, action: #selector(btnA_click(sender:)), for:.touchUpInside)
            selBtn.addTarget(self, action: #selector(btnA_click(sender:)), for:.touchUpOutside)
            selBtn.addTarget(self, action: #selector(btnA_click_S(sender:)), for:.touchDown)
            selBtn.setImage(btnImgs[i], for:UIControlState.normal)
            self.addSubview(selBtn)
        }
        if marker{
        //swapボタンを追加する（マーカモード時):黒ボタンの上に被せる
        swapBtn.addTarget(self, action: #selector(swap_click(sender:)), for:.touchDown)
        if swapMode{
            swapBtn.setImage(imS, for:UIControlState.normal)
        }else{
            swapBtn.setImage(imN, for:UIControlState.normal)
        }
            bacBtn.backgroundColor = UIColor.yellow
            self.addSubview(bacBtn)//下記の背景色を作成する
            self.addSubview(swapBtn)
        }
        //パネルの背景を設定する
        ///select_pcView.backgroundColor = UIColor(patternImage: UIImage(named:"colorBgd4.png")!)//(named:"selectVBg.png")!)
        //区切り線
        if !marker{
            sectView = UIView(frame:CGRect(x:107,y:selHeight2 - 5,width:2,height:42))
            sectView.backgroundColor = UIColor.brown.withAlphaComponent(0.2)//brown.withAlphaComponent(0.7)
            self.addSubview(sectView)
        }else{
            sectView = UIView(frame:CGRect(x:62,y:selHeight2 - 5,width:1,height:42))
            sectView.backgroundColor = UIColor.gray.withAlphaComponent(0.8)//brown.withAlphaComponent(0.7)
            self.addSubview(sectView)
        }
        //penColorNum(1:黒色、２：赤色、３：選択色)
        //選択色 lineCplor（0:青色,1:緑色,2:オレンジ色,3:ムラサキ色）
        //パレット（0:黒色,1:赤色,2:青色,3:緑色,4:橙色,5:紫色)
        let lineColorX = marker ? lineColor2 : lineColor
        let tag = penColorNum == 3 ? lineColorX + 2 : penColorNum - 1
        print("★★tag: \(tag)")
        //ペン色とカラーアイコンの再設定
        btnA_click2(tag:tag)//btnA_click() UP動作の本体プログラム
        //bigボタンの色と位置を再設定する
        btnA_click_S2(tag:tag)//btnA_click() down動作の本体プログラム
        //_self.Delegate?.penMode()
        
    }
    func setPenMenu(){ //UIButtonはここで作成する
        print("select3btn is selected!!:lang = \(langFlag)")
        //ツールバーの高さを取得した後の再設定
        if boundWidthX == boundWidth{//縦場面の場合
         select_pcView.layer.position.y = boundHeight - vHeight - 40 - selHeight/2 - th
        }
        //ボタンの画像
        let pcl:UIImage = langFlag == 0 ? penJ : penE
        let gpn:UIImage = langFlag == 0 ? GpenJ : GpenE
        let mkr:UIImage = langFlag == 0 ? markJ : markE
        var tImg:[UIImage] = [pcl,gpn,mkr]
        //selectViewを空にする
        self.deleteSubviews()
        selHeight2 = selHeight - 40 - 2
        for i in 0...2 {// Pencil | G-pen | Highlight-pen
            
            let selBtn:UIButton = UIButton(frame: CGRect(x:5 + CGFloat(i*100),y:selHeight2,width:100.0,height:40.0))
            selBtn.backgroundColor = UIColor.clear
            selBtn.tag = i
            selBtn.addTarget(self, action: #selector(btnB_click(sender:)), for:.touchUpInside)
            selBtn.addTarget(self, action: #selector(btnB_click(sender:)), for:.touchUpOutside)//要らないかもしれない？
            selBtn.addTarget(self, action: #selector(btnB_click_S(sender:)), for:.touchDown)
            selBtn.setImage(tImg[i], for:UIControlState.normal)
            //selBtn.setBackgroundImage(UIImage.colorToImage3(color: bColor[i]), for: UIControlState.highlighted)
            self.addSubview(selBtn)
        }
        ///select_pcView_bg.backgroundColor = UIColor.rgb(r:51,g:204, b:204, alpha: 1)
        select_pcView.backgroundColor = UIColor(patternImage: UIImage(named:"selectVBg2b.png")!)//(named:"penBgd.png")!)//(named:"selectVBg2.png")!)
        //区切り線
        sectView = UIView(frame:CGRect(x:107,y:selHeight2,width:1,height:36))
        sectView2 = UIView(frame:CGRect(x:200,y:selHeight2,width:1,height:36))
        sectView.backgroundColor = UIColor.white//.withAlphaComponent(0.15)//brown.withAlphaComponent(0.7)
        sectView2.backgroundColor = UIColor.white//.withAlphaComponent(0.5)//brown.withAlphaComponent(0.7)
        self.addSubview(sectView)
        self.addSubview(sectView2)
        //penColorNum(1:黒色、２：赤色、３：選択色)
        //選択色 lineColor（0:青色,1:緑色,2:オレンジ色,3:ムラサキ色）
        //パレット（0:黒色,1:赤色,2:青色,3:緑色,4:橙色,5:紫色)
        let tag = penColorNum == 3 ? lineColor + 2 : penColorNum - 1
        print("★★tag: \(tag)")
    }
    func swap_click(sender:UIButton){//

        if swapMode{
            swapMode = false
            swapBtn.setImage(imN, for:UIControlState.normal)
            
        }else{
            swapMode = true;
            swapBtn.setImage(imS, for:UIControlState.normal)
            print("swap_ON")
        }
    drawableView.swapViewBgImage()
    }
    func btnA_click_S(sender:UIButton){//タッチDOWN 時の処理(start)
        print("btnA_clicked!: \(sender.tag)")
        let st:Int = sender.tag
        if st == 0 && marker{return}//マーカ黒色ボタンの場合は反応しないようにする
        btnA_click_S2(tag:st)
    }
    func btnA_click_S2(tag:Int){//btnA_click_Sの本体プログラム
        if marker && (tag == 0){return}//黒ボタンのタッチ反応をしないようにする
        //bigボタンを全て消す
        bigBtm.removeFromSuperview()
        print("---------")
        //bigボタンの色と位置を再設定する
        if marker{
            
            bigBtm.image = UIImage.colorImage2(color: bColor[tag], size: CGSize(width: 28, height: 28))
            bigBtm.image = UIImage.colorImage(color: mColor[tag], size: CGSize(width: 28, height: 28)).maskCorner(radius: 3)!//角丸の色画像
            let bX = CGFloat(tag) * 50 + 15 + 20
            bigBtm.layer.position.x = bX
            bacBtn.backgroundColor =  mColor[tag]
        }else{
            bigBtm.image = UIImage.colorImage2(color: bColor[tag], size: CGSize(width: 28, height: 28))
            let bX = CGFloat(tag) * 50 + 15 + 20
            bigBtm.layer.position.x = tag == 1 ? bX - 10 : bX
        }
        bigBtm.layer.position.y = selHeight2 + 20//self.frame.height/2 + 2
        
        self.addSubview(bigBtm)
        print("---------self.addSubview(bigBtm)-------------")
        
    }
    func btnA_click(sender:UIButton){//色アイコンタッチUP 時の処理
        print("btnA_clicked!: \(sender.tag)")
        let st:Int = sender.tag
        if st == 0{return}//黒色ボタンの場合は反応しないようにする
        btnA_click2(tag:st)
    }
    func btnA_click2(tag:Int){//btnA_click()の本体プログラム
        gblColor = bColor[tag]
        var lineColorX:Int = 0
        if tag >= 2 {//選んだ色をlineColorに設定する
         lineColorX = tag - 2
         editButton2.setImage(colorIcon[tag - 2], for:UIControlState.normal)
         penColorNum = 3
        }else if tag == 0{//黒色
         editButton2.setImage(UIImage(named: "black2.png"), for:UIControlState.normal)
         penColorNum = 1
        }else{//赤色
         editButton2.setImage(UIImage(named: "red.png"), for:UIControlState.normal)
         penColorNum = 2
        }
        if marker{lineColor2 = lineColorX}
        else{lineColor = lineColorX}
    }
    func btnB_click_S(sender:UIButton){//ペンボタンを押す
        editButton3.setImage(tImg2[sender.tag], for:UIControlState.normal)
    }//penアイコン
    
    func btnB_click(sender:UIButton){//ペンボタンを離す
        print("ペンボタンを離す")
        switch sender.tag {
        case 0:callig = false;   // Gペン　→えんぴつ
        if marker{
            self.Delegate?.ok2()//パレットをメモ行に書き出し
            //メモ行読み込み
            if swapMode{self.Delegate?.modalChanged(TouchNumber: nowGyouNo,top:0)}
            marker = false;penColorNum = 1//マーカ →えんぴつ："黒色"にする
        }
        case 1: callig = true;  // →Gpenn
        if marker{
            self.Delegate?.ok2()//パレットをメモ行に書き出し
            //メモ行読み込み
            if swapMode{self.Delegate?.modalChanged(TouchNumber: nowGyouNo,top:0)}
            marker = false;penColorNum = 1//マーカ →Gpenn
            }
            
        case 2:                 // →マーカペン
        if !marker{             //＊ペン →マーカに移った時は"黄色"にする
            marker = true
            penColorNum = 3
            lineColor2 = 2//「lineColor"2"」は「lineColor」のマーカ専用版
            self.Delegate?.ok2()//パレットをメモ行に書き出し
            self.Delegate?.modalChanged(TouchNumber: nowGyouNo,top:0)//メモ行読み込み
        }
        default:break
        }
        self.Delegate?.penMode()
        //ペンパネルを閉じる
        select_pcView.deleteSubviews()//全てのsubviewを削除(extention)
        select_pcView.removeFromSuperview()
        ///select_pcView_bg.removeFromSuperview()
        selFlg = false
    }
    
}
