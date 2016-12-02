//
//  ViewController.swift
//  Poke Memo
//
//  Created by 青山 行夫 on 2016/11/23.
//  Copyright © 2016年 mm289. All rights reserved.
//

import UIKit

enum DashedLineType {
    case All,Top,Down,Right,Left
}

extension UIView {
    
    func drawDashedLine(color: UIColor, lineWidth: CGFloat, lineSize: NSNumber, spaceSize: NSNumber, type: DashedLineType) -> UIView {
        let dashedLineLayer: CAShapeLayer = CAShapeLayer()
        dashedLineLayer.frame = self.bounds
        dashedLineLayer.strokeColor = color.cgColor
        dashedLineLayer.lineWidth = lineWidth
        dashedLineLayer.lineDashPattern = [lineSize, spaceSize]
        let path: CGMutablePath = CGMutablePath()
        
        switch type {
            
        case .All:
            dashedLineLayer.fillColor = nil
            dashedLineLayer.path = UIBezierPath(rect: dashedLineLayer.frame).cgPath
        case .Top:
            path.move(to: CGPoint(x: 0, y: 0))
            //CGPathMoveToPoint(path, nil, 0.0, 0.0)
            path.addLine(to: CGPoint(x: self.frame.size.width, y: 0))
            //CGPathAddLineToPoint(path, nil, self.frame.size.width, 0.0)
            dashedLineLayer.path = path
        case .Down:
            path.move(to: CGPoint(x: 0, y: self.frame.size.height))
            //CGPathMoveToPoint(path, nil, 0.0, self.frame.size.height)
            path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
            //CGPathAddLineToPoint(path, nil, self.frame.size.width, self.frame.size.height)
            dashedLineLayer.path = path
        case .Right:
            path.move(to: CGPoint(x: self.frame.size.width, y: 0))
            //CGPathMoveToPoint(path, nil, self.frame.size.width, 0.0)
            path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
            //CGPathAddLineToPoint(path, nil, self.frame.size.width, self.frame.size.height)
            dashedLineLayer.path = path
        case .Left:
            path.move(to: CGPoint(x: 0, y: 0))
            //CGPathMoveToPoint(path, nil, 0.0, 0.0)
            path.addLine(to: CGPoint(x: 0, y: self.frame.size.height))
            //CGPathAddLineToPoint(path, nil, 0.0, self.frame.size.height)
            dashedLineLayer.path = path
            
        }
        self.layer.addSublayer(dashedLineLayer)
        return self
    }
}

extension UIView {
    
    
    
    func GetImage() -> UIImage{
        
        // キャプチャする範囲を取得.
        let rect = self.bounds
        
        // ビットマップ画像のcontextを作成.
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        // 対象のview内の描画をcontextに複写する.
        self.layer.render(in: context)
        
        // 現在のcontextのビットマップをUIImageとして取得.
        let capturedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        // contextを閉じる.
        UIGraphicsEndImageContext()
        
        return capturedImage
    }
    
    func GetImageWithResize(resize:CGRect) -> UIImage{
        
        // キャプチャする範囲を取得.
        let rect = self.bounds
        
        // ビットマップ画像のcontextを作成.
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        // 対象のview内の描画をcontextに複写する.
        self.layer.render(in: context)
        
        // 現在のcontextのビットマップをUIImageとして取得.
        let capturedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        // contextを閉じる.
        UIGraphicsEndImageContext()
        
        return capturedImage
    }
    
    public func addBothBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:0,width:width,
                              height:self.frame.size.height)
        self.layer.addSublayer(border)
        let border2 = CALayer()
        border2.backgroundColor = color.cgColor
        border2.frame = CGRect(x:self.frame.size.width - width, y:0,width:width,
                               height:self.frame.size.height)
        self.layer.addSublayer(border2)
    }
    public func addHorizonBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:0,width:self.frame.size.width,height:width)
        self.layer.addSublayer(border)
        let border2 = CALayer()
        border2.backgroundColor = color.cgColor
        border2.frame = CGRect(x:0,y:self.frame.size.height - width,width:self.frame.size.width,height:width)
        self.layer.addSublayer(border2)
    }
    public func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:self.frame.size.height - width,width:
            self.frame.size.width, height:width)
        self.layer.addSublayer(border)
    }
    public func changeBottomBorder(color: UIColor, width: CGFloat) {
        self.layer.sublayers = nil
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:self.frame.size.height - width,width:
            self.frame.size.width,height:width)
        self.layer.addSublayer(border)
    }
    
}
extension UIImage {
    
    func resize(size: CGSize) -> UIImage {
        let widthRatio = size.width / self.size.width
        let heightRatio = size.height / self.size.height
        let ratio = (widthRatio < heightRatio) ? widthRatio : heightRatio
        let resizedSize = CGSize(width: (self.size.width * ratio), height: (self.size.height * ratio))
        UIGraphicsBeginImageContext(resizedSize)
        draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    func addText(text:String)-> UIImage{
        let text = text
        
        let font = UIFont.boldSystemFont(ofSize: 16)
        let imageRect = CGRect(x:0,y:0,width:self.size.width,height:self.size.height)
        /*
        //-------------------------------------------------
        var hi = Int(self.size.width/100)
        print("imageSize = \(self.size)")
        print("hi = \(hi)")
        var font:UIFont!
        if hi>9 {
            font = UIFont.boldSystemFont(ofSize: 128)
        }else if hi>5{font = UIFont.boldSystemFont(ofSize: 64)
        }else{font = UIFont.boldSystemFont(ofSize: 12)}
        print("font = \(font)")
        //--------------------------------------------------
        */
        UIGraphicsBeginImageContext(self.size);
        
        self.draw(in: imageRect)
        
        let textRect  = CGRect(x:5, y:5, width:self.size.width - 5, height:self.size.height - 5)
        let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        let textFontAttributes = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: UIColor.lightGray,
            NSParagraphStyleAttributeName: textStyle
        ]
        text.draw(in: textRect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext()
        
        return newImage!
    }

}

//-----　grobal constance　--------

let boundWidth = UIScreen.main.bounds.size.width
let boundHeight = UIScreen.main.bounds.size.height
var retina:Int = 2//レティナディスプレイ対応
var infoPage:[(memoNo:Int,gyou:Int,maxUsingGyouNo:Int)]!//未使用
var isEditMode:Bool! = false//パレットが表示されている場合：true
var penColorNum:Int = 1
let homeFrame:Int = 2//表示用フレーム ⇒グローバル定数
//-----ページ---------
var pageImgs = [[UIImage]]()//メモの内容(ページ別)：保存する時のオブジェクト
var pageNum:Int = 1//現在表示しているページの番号
var frameNum:Int = 1//現在表示しているframe番号
var maxPageNum:Int = 1//未使用
var pageGyou:Int = 30//メモページの行数
var nowGyouNo:Int! = 1//編集中の行番号
var beforeGyouNo:Int! = 1//一つ前の行番号
var maxUsingGyouNo:Int! = 0//メモが記載されている一番下の行番号
//-----メモ---------
var memoView:MemoView! = nil//メモ本体
var memo:[Memo2View]! = nil//メモ本体
let topOffset:CGFloat = 20//メモ開始位置(上部スペース量）
var leafWidth:CGFloat! = boundWidth - 20//?? ??
let leafHeight:CGFloat = 45//メモ行の高さ
let leafMargin:CGFloat = 4//メモ行間の隙間
var memoLowerMargin:Int = 2// メモ末尾の表示マージン行数
//-----パレット------------
var drawableView: DrawableView! = nil//パレット画面
let vHeight: CGFloat = 181 //手書きビューの高さ@@@@@@@@
var vWidth:CGFloat! = leafWidth * vHeight/leafHeight//手書きビューの幅?? ??boundWidth*3
var maxRightPosX:CGFloat! = 0//描画したｘ座標の最大値
//------------------------------------------------------------------------

protocol ScrollView2Delegate{//スクロールビューの操作(機能）
    func modalChanged(TouchNumber: Int)
    //func show_4thFrame()
    //func scrollViewWillBeginDragging(scrollView: UIScrollView)
}

protocol UpperToolViewDelegate{//upperビューの操作(機能）
    func dispPosChange(midX: CGFloat)
}
//    =======  ViewController    ========

class ViewController: UIViewController,UIScrollViewDelegate,ScrollView2Delegate,UpperToolViewDelegate {
    
    let myScrollView = TouchScrollView()//UIScrollView()
    var spaceView1: UIView!//spacing確保のためのビュー※タッチ緩衝エリア
    var spaceView2: UIView!//spacing確保のためのビュー※タッチ緩衝エリア
    var underView: UIView!//パレットの下の帯
    var upperView: UIView!//パレットの上の帯
    var myToolView = UpperToolView()//パレットの上のツールバー（パレットスクロール機能）
    var myEditView:UIView!//パレットの編集用ボタン表示エリア
    var underFlag: Bool!
    var myEditFlag:Bool! = false
    var scrollRect:CGRect!
    var scrollRect_P:CGRect!//パレットが表示されている時
    //var reloadedImage:UIImage!//ファイルから読み込んだイメージ：未使用　下記使用
    var reloads:[UIImage]!//ファイルから読み込んだイメージ配列
    var editButton1:UIButton!
    var editButton2:UIButton!
    var editButton3:UIButton!
    var editButton4:UIButton!
    var editButton5:UIButton!
    var editButton6:UIButton!
    var editButton7:UIButton!
    var editButton8:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        /** spaceViewを生成(透明：タッチ緩衝の為) **/
        //underViewの下側
        spaceView1 = UIView(frame: CGRect(x: 0, y:boundHeight - 44 - vHeight , width: boundWidth, height: 10))
        spaceView1.backgroundColor = UIColor.clear
        //underViewの上側
        spaceView2 = UIView(frame: CGRect(x: 0, y:boundHeight - 44 - vHeight - 40 - 20, width: boundWidth, height: 20))
        spaceView2.backgroundColor = UIColor.clear
        
        /** underViewを生成. **/
        //underFlag = false// 表示・非表示のためのフラグ
        underView = UIView(frame: CGRect(x: 0, y: 0, width: boundWidth, height: 20))// underViewを生成.
        underView.backgroundColor = UIColor.gray// underViewの背景を青色に設定
        underView.alpha = 0.5// 透明度を設定
        underView.layer.position = CGPoint(x: self.view.frame.width/2, y:boundHeight - 44 - 10)// 位置を中心に設定
        /** upperViewを生成. **/
        upperView = UIView(frame: CGRect(x: 0, y: 0, width: boundWidth, height: 20))// underViewを生成.
        upperView.backgroundColor = UIColor.gray
        upperView.alpha = 0.5// 透明度を設定
        upperView.layer.position = CGPoint(x: self.view.frame.width/2, y:boundHeight - vHeight - 44 + 10)// 位置を中心に設定
        upperView.isUserInteractionEnabled = false
        
        /** myToolViewViewを生成. **/
        myToolView.Delegate = self
        myToolView.frame =  CGRect(x: 0, y: 0, width: boundWidth, height: 40)// underViewを生成.
        myToolView.backgroundColor = UIColor.lightGray// underViewの背景を青色に設定
        myToolView.alpha = 0.5// 透明度を設定
        myToolView.layer.position = CGPoint(x: self.view.frame.width/2, y:boundHeight - vHeight - 44 - 40/2 )// 位置を中心に設定
        myToolView.addHorizonBorderWithColor(color: UIColor.black, width:1)
        
        /** button1の追加 **/
        editButton1 = UIButton(frame: CGRect(x:boundWidth - 60,y: 5, width:50, height:30))
        editButton1.backgroundColor = UIColor.red  // タイトルを設定する(通常時)
        editButton1.setTitle("💠", for: UIControlState.normal)
        // イベントを追加する
        editButton1.addTarget(self, action: #selector(ViewController.btn1_click(sender:)), for: .touchUpInside)
        myToolView.addSubview(editButton1)
        
        /** button2の追加 **/
        editButton2 = UIButton(frame: CGRect(x:10, y:5, width:30, height:30))
        editButton2.backgroundColor = UIColor.gray
        editButton2.addTarget(self, action: #selector(ViewController.btn2_click(sender:)), for:.touchUpInside)
        editButton2.setTitle("2", for: UIControlState.normal)
        myToolView.addSubview(editButton2)
        /** button3の追加 **/
        editButton3 = UIButton(frame: CGRect(x:60, y:5, width:30, height:30))
        editButton3.backgroundColor = UIColor.gray
        editButton3.addTarget(self, action: #selector(ViewController.btn3_click(sender:)), for:.touchUpInside)
        editButton3.setTitle("3", for: UIControlState.normal)
        myToolView.addSubview(editButton3)
        /** button4の追加 **/
        editButton4 = UIButton(frame: CGRect(x:110, y:5, width:30, height:30))
        editButton4.backgroundColor = UIColor.gray
        editButton4.addTarget(self, action: #selector(ViewController.btn4_click(sender:)), for:.touchUpInside)
        editButton4.setTitle("4", for: UIControlState.normal)
        myToolView.addSubview(editButton4)
        
        /* editViewを生成. */
        myEditView = UIView(frame: CGRect(x: 0, y: 0, width: boundWidth, height: 60))
        myEditView.backgroundColor = UIColor.red// underViewの背景を青色に設定
        myEditView.alpha = 0.5// 透明度を設定
        myEditView.layer.position = CGPoint(x: self.view.frame.width/2, y:boundHeight - vHeight - 44 - 40 - 30)// 位置を中心に設定
        //button5の追加
        editButton5 = UIButton(frame: CGRect(x:70, y:10, width:50, height:40))
        editButton5.backgroundColor = UIColor.gray
        editButton5.addTarget(self, action: #selector(ViewController.btn5_click(sender:)), for:.touchUpInside)
 
        editButton5.setTitle("5", for: UIControlState.normal)
        myEditView.addSubview(editButton5)
 
        //button6の追加
        editButton6 = UIButton(frame: CGRect(x:140, y:10, width:50, height:40))
        editButton6.backgroundColor = UIColor.gray
        editButton6.addTarget(self, action: #selector(ViewController.btn6_click(sender:)), for:.touchUpInside)

        editButton6.setTitle("6", for: UIControlState.normal)
        myEditView.addSubview(editButton6)
        //button7の追加
        editButton7 = UIButton(frame: CGRect(x:210,y: 10,width: 50, height:40))
        editButton7.backgroundColor = UIColor.gray
        editButton7.addTarget(self, action: #selector(ViewController.btn7_click(sender:)), for:.touchUpInside)

        editButton7.setTitle("7", for: UIControlState.normal)
        myEditView.addSubview(editButton7)
        //button8の追加
        editButton8 = UIButton(frame: CGRect(x:280, y:10, width:50,height: 40))
        editButton8.backgroundColor = UIColor.gray
        editButton8.addTarget(self, action: #selector(ViewController.btn8_click(sender:)), for:.touchUpInside)
 
        editButton8.setTitle("8", for: UIControlState.normal)
        myEditView.addSubview(editButton8)
        
        /* ScrollViewを生成. */
        myScrollView.Delegate2 = self
        myScrollView.Delegate3 = self
        //パレット表示されていない場合
        scrollRect = CGRect(x:10, y:20 + 44 - 3,width:leafWidth, height:boundHeight - 20 - 44 - 44)
        //パレット表示されている場合
        scrollRect_P = CGRect(x:10,y: 20 + 44 - 3,width:leafWidth, height:boundHeight - 20 - 44 - 44 - vHeight - 44)
        
        myScrollView.frame = scrollRect
        myScrollView.bounces = false//スクロールをバウンドさせない
        self.view.addSubview(myScrollView)
        myScrollView.isUserInteractionEnabled = true
        //myScrollView.isPagingEnabled = false//離散スクロール
        myScrollView.showsVerticalScrollIndicator = true
        myScrollView.showsHorizontalScrollIndicator = false// 横スクロールバー非表示
        myScrollView.contentSize = CGSize(width:leafWidth,height:(leafHeight + leafMargin) * CGFloat(pageGyou + memoLowerMargin) + topOffset)
        //myScrollView.directionalLockEnabled = true
        

    //---- ページデータの読み込み・作成　-------------
       //UserDrfaultの頁数を調べる
        let kn = UserDataNum2()//保管してあるページ数
       //pageImgs[]の初期化(必要なページ分だけで作る)
        var num:Int = 0
        if kn != 0{
            let sa = kn - pageImgs.count + 1
            if sa > 0{ num = sa }else{ num = 3 }
            for _ in 1...num{
              createNewPageImg2()
            }
           //imgsに保存データを読み込む
            for i in 0..<kn{
              readUserData2(pn: i)
            }
        }else{
            for i in 0..<3{
              createNewPageImg2()
            }
        }

    //----- Memo(ページ）ビューを作成・初期化する -------
        if memo == nil{
            
            //メモビューの初期化
            let memoFrame = CGRect(x:0,y: 0,width:leafWidth*1,height: (leafHeight + leafMargin) * CGFloat(pageGyou) + topOffset)
            let memo0 = Memo2View(frame: memoFrame)
            let memo1 = Memo2View(frame: memoFrame)
            let memo2 = Memo2View(frame: memoFrame)
            memo = [memo0,memo1,memo2]
            //memoView.backgroundColor = UIColor.grayColor()
            //memoView.alpha = 0.5// 透明度を設定
        // メモ表示内容の初期化
            memo[0].setMemo2View(pn: 0)//タグを付ける、メモの作成(indexページ)
            memo[1].setMemo2View(pn: 1)//タグを付ける、メモの作成(第1ページ)
            memo[2].setMemo2View(pn: 2)//タグを付ける、メモの作成(第2ページ)
            // ** memoView.userInteractionEnabled = true
            pageNum = 2
            myScrollView.addSubview((memo[pageNum]))
            self.view.addSubview(myScrollView)
            myScrollView.contentOffset = CGPoint(x:0,y: 0)
            // myScrollView.showHomeFrame()
        }
    }
    
    //  ======= End of viewDidLoad=======
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func insert(sender: AnyObject) {
        memoView.insertNewMemo(gyou: nowGyouNo,maxGyou:pageGyou)
        
        /*  ?一行増やす場合とそうでない場合があるので下記は関数の中に持っていく
         //表示範囲も１行分拡大する
         memoLowerMargin += 1
         myScrollView.contentSize = CGSizeMake(leafWidth,(leafHeight + leafMargin) * CGFloat(pageGyou + memoLowerMargin) + topOffset)
         //メモViewのサイズを拡大する
         memoView.frame = CGRectMake(0, 0,leafWidth, (leafHeight + leafMargin) * CGFloat(pageGyou) + topOffset)
         */
        
        modalChanged(TouchNumber: (frameNum*1)*100 + nowGyouNo)
        
    }
    
    @IBAction func delMemo(sender: AnyObject) {
        memoView.delSelectedMemo(gyou: nowGyouNo,maxGyou: pageGyou)
        modalChanged(TouchNumber: (frameNum*1)*100 + nowGyouNo)
        // 保存データを全削除
        //
        let userDefault = UserDefaults.standard
        var appDomain:String = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        /*
         // キーidの値のみを削除
         let userDefault = NSUserDefaults.standardUserDefaults()
         userDefault.removeObjectForKey("id")
         */
    }
    
    @IBAction func save(sender: AnyObject) {
        //pageNum = nowFrameNum()
        print("pageImgs.count: \(pageImgs.count)")
        for n in 1...pageImgs.count - 1{
            
            //print("==========")
            pageImgs[n] = memoView.memo2ImagsNew(fn: n)
            //print("++++++++")
        }
        //
        for n in 1...pageImgs.count - 1{
            memoView.saveImage3(pn: n,imgs: pageImgs[n])//頁番号，頁内容
        }
        /*
         pageImgs[1] = memoView.memo2ImagsNew(1)
         pageImgs[2] = memoView.memo2ImagsNew(2)
         pageImgs[3] = memoView.memo2ImagsNew(3)
         
         memoView.saveImage3(1,imgs: pageImgs[1])//頁番号，頁内容
         memoView.saveImage3(2,imgs: pageImgs[2])
         memoView.saveImage3(3,imgs: pageImgs[3])
         */
    }
    
    @IBAction func reload(sender: AnyObject) {
        //myScrollView.Tshow_4thFrame()
        //myScrollView.gotoNextPage()
        /* リロードチェック用
         for idx in 1...100{
         reloads = memoView.saveImage2()
         memoView.reloadImage3()
         print("idx:\(idx)")
         print("reloads: \(reloads[0].size)")
         }
         modalChanged((frameNum*1)*100 + nowGyouNo)
         */
        
        /*
         if reloadedImage != nil{
         memoView.reloadImage(reloadedImage)
         modalChanged((frameNum*1)*100 + nowGyouNo)
         }
         */
    }
    
    @IBAction func toLeft(sender: AnyObject) {
        if isEditMode == true{
            let myWidth = self.view.frame.width//画面の幅
            //
            var midX = drawableView.frame.midX//Viewの中心のX座標を取得
            midX = midX + myWidth/6
            drawableView.layer.position = CGPoint(x: midX, y:boundHeight - vHeight/2 - 44)//@
        }
    }
    
    /* パレットの表示／非表示を交互に行う (NAVバーの右端ボタン) */
    @IBAction func Pallete(_ sender: UIBarButtonItem) {
    //}
    //@IBAction func Second(sender: AnyObject) { // == Open Pallete ==
        
        if drawableView != nil {// パレットが表示されている時パレットを消す
            //myScrollView.upToImgs()//編集中のページ内容を更新する
            drawableView!.removeFromSuperview()//　子viewを削除する??
            drawableView = nil
            myScrollView.frame = scrollRect
            //myScrollView.showHomeFrame()//スクロール再設定の後は必要！
            underBarDisp(disp: 0)//underViewを削除する
            isEditMode = false
            
        }else{// パレットが表示されていない時パレットを表示する
            
            //パレットビューを作成・初期化する
            
            drawableView = DrawableView(frame: CGRect(x:0, y:0,width:vWidth, height:vHeight))//2→3
            let sa = (vWidth - boundWidth)/2  //?? ??
            let leftEndPoint = CGPoint(x: vWidth/2, y:boundHeight - vHeight/2 - 44)
            drawableView.layer.position = leftEndPoint
            
            drawableView.backgroundColor = UIColor.clear//(patternImage: myImage)
            self.view.addSubview(drawableView)
            // second view
            drawableView.setSecondView()
            isEditMode = true//パレットが表示されている場合は"true"
            
            // frameの値を設定する.
            myScrollView.frame = scrollRect_P
            //myScrollView.showHomeFrame()
            underBarDisp(disp: 1)//underViewを追加する
            //表示中のフレーム番号
            //let fn = Int(myScrollView.contentOffset.x/leafWidth) + 1
            //memoView.selectedNo(gyou: nowGyouNo,fn:fn)//選択行を表示
        }
    }
    
    @IBAction func CR(sender: AnyObject) {
        if isEditMode == true{
            //let myWidth = self.view.frame.width//画面の幅
            /* first_Memo-view */
            
            //入力パレットの表示位置(横方向）を決める
            drawableView.layer.position = CGPoint(x: vWidth/2, y:boundHeight - vHeight/2 - 44)
            
            if nowGyouNo < pageGyou {nowGyouNo = nowGyouNo + 1}
            //対象行を一行下げる
            //表示中のフレーム番号
            let fn = Int(myScrollView.contentOffset.x/leafWidth) + 1
            memoView.selectedNo(gyou: nowGyouNo,fn:fn)
            //print("-----------------------------------")
            //メモに書き出した内容をパレットに読み込む//20161024追加
            
            let myMemo:UIImage = memoView.readMemo(tag: nowGyouNo)
            drawableView.backgroundColor = UIColor(patternImage: myMemo)
            drawableView.X_color = 0//ペン色：黒
            //resetFunc()//reset動作をさせる
        }
    }
    
    @IBAction func addMemo(sender: AnyObject) {
        if isEditMode == true{
            
            let myWidth = self.view.frame.width//画面の幅
            // ボタンの位置取得
            var midX = drawableView.frame.midX//Viewの中心のX座標を取得
            midX = midX - myWidth/6
            drawableView.layer.position = CGPoint(x: midX, y:boundHeight - vHeight/2 - 44)//@
        }
    }
    
    @IBAction func edit(sender: AnyObject) {//「ペン色の変更」として流用
        if isEditMode == true{
            
            if drawableView.X_color == 0{
                drawableView.X_color = 1 //ペン色：白色
            }else{
                drawableView.X_color = 0 //黒色
            }
        }
    }
    
    @IBAction func color(sender: AnyObject) {//「カーソルUP」として流用する
        if isEditMode == true{
            if nowGyouNo > 1{
                nowGyouNo = nowGyouNo - 1//対象行を一行上げる
            }else{ nowGyouNo = 1 }
            
            //メモに書き出した内容をパレットに読み込む//20161024追加
            let myMemo:UIImage = memoView.readMemo(tag: nowGyouNo)
            //表示中のフレーム番号
            let fn = Int(myScrollView.contentOffset.x/leafWidth) + 1
            memoView.selectedNo(gyou: nowGyouNo,fn:fn)
            //memoView.selectedNo(5,fn: 3)
            drawableView.backgroundColor = UIColor(patternImage: myMemo)
            drawableView.X_color = 0//ペン色：黒
        }
    }
    
    @IBAction func reset(sender: AnyObject) {
        if isEditMode == true{
            //let myWidth = self.view.frame.width//画面の幅
            drawableView.X_color = 0//ペン色：黒
            drawableView.refresh()
            //drawableView.flagRset()//@
            let sa = (vWidth - boundWidth)/2  //?? ??
            let leftEndPoint = CGPoint(x: vWidth/2, y:boundHeight - vHeight/2 - 44)
            drawableView.layer.position = leftEndPoint
            myScrollView.frame = scrollRect_P
            memoView.clearMemo(tag: nowGyouNo)
        }else{
            //myScrollView.Tshow_1beforeFrame()
            //myScrollView.showHomeFrame()
            //myScrollView.showBackPage()
        }
    }
    
    //----------------- その他の関数　-------------------------
    
    func underBarDisp(disp:Int){
        if disp == 1 {
            self.view.addSubview(underView)
            self.view.addSubview(upperView)
            self.view.addSubview(myToolView)
            self.view.addSubview(spaceView1)
            self.view.addSubview(spaceView2)
        }else if disp == 0{
            underView.removeFromSuperview()
            upperView.removeFromSuperview()
            myToolView.removeFromSuperview()
            if myEditView != nil{
                myEditView.removeFromSuperview()
                spaceView1.removeFromSuperview()
                spaceView2.removeFromSuperview()
            }
            
        }
    }
    // ==  外部データ入出力関係  ==
    func UserDataNum2()->Int{//これから読み込むUserDataに存在するページ数を取得する
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
    
    func createNewPageImg2(){ //新しいページを作成して末尾に追加する
        let bImage:UIImage = UIImage(named: "blankW.png")!
        var blankImgs:[UIImage] = Array(repeating: bImage, count: pageGyou)
        pageImgs.append(blankImgs)
    }
    
    func readUserData2(pn:Int){ //UserDataをpageImmgs[]に読み込む
        var rl = reloadToPage2(pn: pn)
        if rl.count > 0 { //これがないと読み込みエラーが発生 初期ではrl.count= 0
            pageImgs[pn] = rl
        }
    }
    
    // UserDwfaultに保存のメモ画像をpageImgs:[]に読み込む
    func reloadToPage2(pn:Int)->[UIImage] {
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
    
    /* -------------------　ボタン関数　-----------------------------*/
    
    func btn1_click(sender:UIButton){
        print("** btn1_click()")
        if myEditFlag == false{
            editButton1.backgroundColor = UIColor.gray
            editButton1.setTitle("⬇", for: UIControlState.normal)
            self.view.addSubview(myEditView)
            myEditFlag = true
        }else{
            editButton1.backgroundColor = UIColor.red
            editButton1.setTitle("💠", for: UIControlState.normal)
            myEditView.removeFromSuperview()
            myEditFlag = false
        }
    }
    func btn2_click(sender:UIButton){
        print("btn2_clicked!")
        if penColorNum == 1 {
            penColorNum = 2
        }else if penColorNum == 2{
            penColorNum = 3
        }else{
            penColorNum = 1
        }
    }
    
    func btn3_click(sender:UIButton){
        print("btn3_clicked!")
        drawableView.X_color = 0//ペンモード[黒色、赤色、青色]
    }
    
    func btn4_click(sender:UIButton){
        drawableView.X_color = 1//消しゴムモード
    }
    func btn5_click(sender:UIButton){"btn5_clicked!"}
    func btn6_click(sender:UIButton){"btn6_clicked!"}
    func btn7_click(sender:UIButton){"btn7_clicked!"}
    func btn8_click(sender:UIButton){"btn8_clicked!"}
    /* -------------------　プロトコル関数　-----------------------------*/
    func modalChanged(TouchNumber: Int) {// protocol ScrollViewDelegate
        print("TouchNumber:\(TouchNumber)")
        print("pageNum: \(pageNum)")
        //frameNum = Int(myScrollView.contentOffset.x/leafWidth) + 1
        //print("frameNum: \(frameNum)")
        //if TouchNumber > (0 + 1)*100{
            nowGyouNo = TouchNumber
            print("nowGyouNo?: \(nowGyouNo)")
            if isEditMode == true{
                //メモに書き出した内容をパレットに読み込む//20161024追加
                let myMemo:UIImage = memo[pageNum].readMemo(tag: nowGyouNo)
                //表示中のフレーム番号
                let fn = Int(myScrollView.contentOffset.x/leafWidth) + 1
                memo[pageNum].selectedNo(tagN: nowGyouNo)
                //パレット表示用にリサイズする(extension)
                //====================================================
                let reSize = CGSize(width: vWidth, height: vHeight)
                let reMemo = myMemo.resize(size: reSize)
                //====================================================
                drawableView.backgroundColor = UIColor(patternImage: reMemo)
            }else{
                //表示中のフレーム番号
                //let fn = Int(myScrollView.contentOffset.x/leafWidth) + 1
                memo[pageNum].selectedNo(tagN:nowGyouNo)
            }
        //}
        //print("nowGyouNo: \(nowGyouNo)")
    }
    
    func dispPosChange(midX: CGFloat){// protocol UpperToolViewDelegate
        //print("midX: \(midX)")
        drawableView.layer.position = CGPoint(x: midX, y:boundHeight - vHeight/2 - 44)
    }
    /* ------------------------ デリゲート関数　-------------------------- */
    var scrollBeginingPoint: CGPoint!
    
    func scrollViewWillBeginDragging(myScrollView: UIScrollView) {
        scrollBeginingPoint = myScrollView.contentOffset;
        print("SSSSSS")
    }
    
    func scrollViewDidScroll(myScrollView: UIScrollView) {
        var currentPoint = myScrollView.contentOffset
        if(scrollBeginingPoint.y < currentPoint.y){
            print("下へスクロール")
        }else{
            print("上へスクロール")
        }
    }
}

