//
//  ViewController.swift
//  Poke Memo⇒　E.T.Memo Happy Memo,Leaf Memo ⇒ Happy Note( Ver2)
//
//  Created by 青山 行夫 on 2016/11/23.
//  Copyright © 2016年 mm289. All rights reserved.
// 20161213

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
    //func UIGraphicsBeginImageContextWithOptions(_ size: CGSize, _ opaque: Bool, _ scale: CGFloat)
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
        //センターにも縦線を引く　20161216追加
        let border3 = CALayer()
        border3.backgroundColor = color.cgColor
        border3.frame = CGRect(x:self.frame.size.width/2, y:0,width:width,
                               height:self.frame.size.height)
        self.layer.addSublayer(border3)
        
        
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
        
    // 画質を担保したままResizeするクラスメソッド.
    func ResizeUIImage(width : CGFloat, height : CGFloat)-> UIImage!{
            
        let size = CGSize(width: width, height: height)
            
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        //var context = UIGraphicsGetCurrentContext()
            
        self.draw(in: CGRect(x:0,y:0,width:size.width,height:size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func resize(size: CGSize) -> UIImage {
        let widthRatio = size.width / self.size.width
        let heightRatio = size.height / self.size.height
        //let ratio = (widthRatio < heightRatio) ? widthRatio : heightRatio
        let ratio = heightRatio
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
            NSForegroundColorAttributeName: UIColor.gray,
            NSParagraphStyleAttributeName: textStyle
        ]
        text.draw(in: textRect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    func addIndexText(text:String,rect:CGRect)-> UIImage{
        let text = text
        let font = UIFont.boldSystemFont(ofSize: 16)
        let imageRect = CGRect(x:0,y:0,width:self.size.width,height:self.size.height)

        UIGraphicsBeginImageContext(self.size);
        
        self.draw(in: imageRect)
        
        let textRect  = rect
        let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        let textFontAttributes = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: UIColor.gray,
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
//var retina:Int = 2//レティナディスプレイ対応
let retina:Int = Int(UIScreen.main.scale)//レティナ分解能の抽出
var infoPage:[(memoNo:Int,gyou:Int,maxUsingGyouNo:Int)]!//未使用
var isEditMode:Bool! = false//パレットが表示されている場合：true
var isIndexMode:Bool! = false//Indexの表示フラグ：true

var penColorNum:Int = 1
let homeFrame:Int = 2//表示用フレーム ⇒グローバル定数
//-----ページ---------
var indexImgs:[UIImage] = []//index[30]の画像
var pageNum:Int = 1//現在表示しているページの番号
//var frameNum:Int = 1//現在表示しているframe番号　　※削除予定
var fNum:Int = 1//現在表示しているframe番号:0,1,2:[0]はindexページ
var maxPageNum:Int = 1//未使用
var pageGyou:Int = 30//メモページの行数
var nowGyouNo:Int! = 1//編集中の行番号(tag番号）
var maxUsingGyouNo:Int! = 0//メモが記載されている一番下の行番号//現在、未使用
//-----メモ---------
//var memoView:MemoView! = nil//メモ本体
var memo:[MemoView]! = nil//メモ本体
let topOffset:CGFloat = 20//メモ開始位置(上部スペース量）
var leafWidth:CGFloat! = boundWidth - 10//?? ??
let leafHeight:CGFloat = 45//メモ行の高さ
let leafMargin:CGFloat = 4//メモ行間の隙間
var memoLowerMargin:Int = 2// メモ末尾の表20示マージン行数
//-----パレット------------
var drawableView: DrawableView! = nil//パレット画面
let vHeight: CGFloat = 181 //手書きビューの高さ@@@@@@@@
var vWidth:CGFloat! = leafWidth*(vHeight/leafHeight)
var maxPosX:CGFloat! = 0//描画したｘ座標の最大値
var mx  = [String: CGFloat]()//[Tag番号:maxPosX]
var mxTemp:CGFloat!//mxの一時保存（メモに書き出すときにmxにコピーする）
//var maxPosX = [[CGFloat]]()
//var maxPosX:CGFloat!  = [[Int]](count: 30,repeatedValue: [Int](count: 30,repeatedValue: 0))


//------------------------------------------------------------------------

protocol ScrollView2Delegate{//スクロールビューの操作(機能）
    func modalChanged(TouchNumber: Int)
    //func show_4thFrame()
    //func scrollViewWillBeginDragging(scrollView: UIScrollView)
}

protocol UpperToolViewDelegate{//upperビューの操作(機能）
    func dispPosChange(midX: CGFloat,deltaX:CGFloat)
}

protocol DrawableViewDelegate{//パレットビューの操作(機能）
    func selectNextGyou()
}


//    =======  ViewController    ========

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,ScrollView2Delegate,UpperToolViewDelegate,DrawableViewDelegate{
    
    //var indexFView:UIView!//インデックスメニュー作成評価用
    let myScrollView = TouchScrollView()//UIScrollView()
    var spaceView1: UIView!//spacing確保のためのビュー※タッチ緩衝エリア
    var spaceView2: UIView!//spacing確保のためのビュー※タッチ緩衝エリア
    var underView: UIView!//パレットの下の帯
    var upperView: UIView!//パレットの上の帯
    var myToolView = UpperToolView()//パレットの上のツールバー（パレットスクロール機能）
    var myEditView:UIView!//パレットの編集用ボタン表示エリア
    var underFlag: Bool!
    var myEditFlag:Bool! = false//パレット追加編集ツール表示フラグ
    var scrollRect:CGRect!
    var scrollRect_P:CGRect!//パレットが表示されている時の表示サイズ

    var isMenuMode:Bool! = false//リストメニューがの表示フラグ：true
    //var isIndexMode:Bool! = false//Indexの表示フラグ：true
    //var indexFlag:Bool! = false//Indexの表示フラグ：true

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
    var editButton9:UIButton!
    var editButton10:UIButton!
  
    /* --- リストメニュー --- */
    let ch:CGFloat = 40//セルの高さ
    let cn:Int = 8//リストの数
    let mw:CGFloat = 200//メニューリストの幅
    var mh:CGFloat = 300//メニューリストの高さ
    var mv:UIView!
    var smv:UIScrollView!//メニューリストテーブルを入れるスクロール箱
    var tV: UITableView  =   UITableView()//++テーブルビューインスタンス作成
    //++テーブルに表示するセル配列
    var items: [String] = ["","日付を追加", "表示中のページを削除", "全変更を破棄元に戻す","------------------------　","各種設定","スタートガイドを見る","                ▲ "]
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        //本機種の解像度
        print("　〓retina scale〓 :\(UIScreen.main.scale)")

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
        underView.backgroundColor = UIColor.green// underViewの背景を青色に設定
        underView.alpha = 0.12// 透明度を設定
        underView.layer.position = CGPoint(x: self.view.frame.width/2, y:boundHeight - 44 - 10)// 位置を中心に設定
        /** upperViewを生成. **/
        upperView = UIView(frame: CGRect(x: 0, y: 0, width: boundWidth, height: 20))// underViewを生成.
        upperView.backgroundColor = UIColor.green
        upperView.alpha = 0.12// 透明度を設定
        upperView.layer.position = CGPoint(x: self.view.frame.width/2, y:boundHeight - vHeight - 44 + 10)// 位置を中心に設定
        upperView.isUserInteractionEnabled = false
        
        /** myToolViewを生成. **/
        myToolView.Delegate = self
        myToolView.frame =  CGRect(x: 0, y: 0, width: boundWidth, height: 40)// underViewを生成.
        myToolView.backgroundColor = UIColor.lightGray// underViewの背景を青色に設定
        myToolView.alpha = 0.5// 透明度を設定
        myToolView.layer.position = CGPoint(x: self.view.frame.width/2, y:boundHeight - vHeight - 44 - 40/2 )// 位置を中心に設定
        myToolView.addHorizonBorderWithColor(color: UIColor.black, width:1)
        //ツールViewのボタンの生成　[2][3][4]   [1]
        // button1の追加
        editButton1 = UIButton(frame: CGRect(x:boundWidth - 60,y: 5, width:50, height:30))
        editButton1.backgroundColor = UIColor.red  // タイトルを設定する(通常時)
        editButton1.setTitle("💠", for: UIControlState.normal)
        // イベントを追加する
        editButton1.addTarget(self, action: #selector(ViewController.btn1_click(sender:)), for: .touchUpInside)
        myToolView.addSubview(editButton1)
        self.toolBar.isHidden  = true//ツールバーを隠す
        // button2の追加
        editButton2 = UIButton(frame: CGRect(x:10, y:5, width:30, height:30))
        editButton2.backgroundColor = UIColor.gray
        editButton2.addTarget(self, action: #selector(ViewController.btn2_click(sender:)), for:.touchUpInside)
        editButton2.setTitle("2", for: UIControlState.normal)
        myToolView.addSubview(editButton2)
        // button3の追加
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
        myEditView.alpha = 0.6// 透明度を設定
        myEditView.layer.position = CGPoint(x: self.view.frame.width/2, y:boundHeight - vHeight - 44 - 40 - 30)// 位置を中心に設定
        //Editbuttonの追加 [9]　[5][6][7][8] [10]
        let sW = 20//ボタン間のスペース
        let bW = 50//ボタンの幅
        let tW = sW + bW//各ボタン間の距離
        let cW = boundWidth/2 //画面の幅の半分
        let x05 = cW - CGFloat(2*tW - sW/2)//左端のボタンの位置
        //button5の追加
        editButton5 = UIButton(frame: CGRect(x:x05, y:10, width:50, height:40))
        editButton5.backgroundColor = UIColor.gray
        editButton5.addTarget(self, action: #selector(ViewController.btn5_click(sender:)), for:.touchUpInside)
 
        editButton5.setTitle("5", for: UIControlState.normal)
        myEditView.addSubview(editButton5)
 
        //button6の追加
        editButton6 = UIButton(frame: CGRect(x:x05 + CGFloat(tW), y:10, width:50, height:40))
        editButton6.backgroundColor = UIColor.gray
        editButton6.addTarget(self, action: #selector(ViewController.btn6_click(sender:)), for:.touchUpInside)

        editButton6.setTitle("6", for: UIControlState.normal)
        myEditView.addSubview(editButton6)
        //button7の追加
        editButton7 = UIButton(frame: CGRect(x:x05 + CGFloat(tW)*2,y: 10,width: 50, height:40))
        editButton7.backgroundColor = UIColor.gray
        editButton7.addTarget(self, action: #selector(ViewController.btn7_click(sender:)), for:.touchUpInside)

        editButton7.setTitle("7", for: UIControlState.normal)
        myEditView.addSubview(editButton7)
        //button8の追加
        editButton8 = UIButton(frame: CGRect(x:x05 + CGFloat(tW)*3, y:10, width:50,height: 40))
        editButton8.backgroundColor = UIColor.gray
        editButton8.addTarget(self, action: #selector(ViewController.btn8_click(sender:)), for:.touchUpInside)
 
        editButton8.setTitle("8", for: UIControlState.normal)
        myEditView.addSubview(editButton8)
        
        editButton9 = UIButton(frame: CGRect(x:10, y:10, width:30,height: 40))
        editButton9.backgroundColor = UIColor.gray
        editButton9.addTarget(self, action: #selector(ViewController.btn9_click(sender:)), for:.touchUpInside)
        editButton9.setTitle("9", for: UIControlState.normal)
        myEditView.addSubview(editButton9)
        
        editButton10 = UIButton(frame: CGRect(x:boundWidth - 40, y:10, width:30,height: 40))
        editButton10.backgroundColor = UIColor.gray
        editButton10.addTarget(self, action: #selector(ViewController.btn9_click(sender:)), for:.touchUpInside)
        editButton10.setTitle("10", for: UIControlState.normal)
        myEditView.addSubview(editButton10)
        
        /* ScrollViewを生成. */
        myScrollView.Delegate2 = self
        //myScrollView.Delegate3 = self
        //パレット表示されていない場合
        scrollRect = CGRect(x:(boundWidth - leafWidth)/2, y:70  ,width:leafWidth, height:boundHeight - 20 - 44 - 10 )
        //パレット表示されている場合
        scrollRect_P = CGRect(x:(boundWidth - leafWidth)/2,y: 70,width:leafWidth, height:boundHeight - 20 - 44 - 44 - vHeight - 44)
        
        myScrollView.frame = scrollRect
        myScrollView.bounces = false//スクロールをバウンドさせない
        self.view.addSubview(myScrollView)
        myScrollView.isUserInteractionEnabled = true
        //myScrollView.isPagingEnabled = false//離散スクロール
        myScrollView.showsVerticalScrollIndicator = true
        myScrollView.showsHorizontalScrollIndicator = false// 横スクロールバー非表示
        myScrollView.contentSize = CGSize(width:leafWidth,height:(leafHeight + leafMargin) * CGFloat(pageGyou + memoLowerMargin) + topOffset)
        //myScrollView.directionalLockEnabled = true
        
        //------------ スワイプ認識登録　------------
        //右スワイプ
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeR))
        rightSwipe.direction = .right
        myScrollView.addGestureRecognizer(rightSwipe)
        //左スワイプ
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeL))
        leftSwipe.direction = .left
        myScrollView.addGestureRecognizer(leftSwipe)
        
        //長押し認識登録
        let longPush = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longPress))
        // 長押し-最低2秒間は長押しする.
        longPush.minimumPressDuration = 1.0
        myScrollView.addGestureRecognizer(longPush)


    //----- Memo(ページ）ビューを作成・初期化する -------
        if memo == nil{
            
            //メモビューの初期化
            let memoFrame = CGRect(x:0,y: 0,width:leafWidth*1,height: (leafHeight + leafMargin) * CGFloat(pageGyou) + topOffset)
            let memo0 = MemoView(frame: memoFrame)
            let memo1 = MemoView(frame: memoFrame)
            let memo2 = MemoView(frame: memoFrame)
            memo = [memo0,memo1,memo2]
         // メモページの背景色をつける:トランジション時だけ背景色に透明度をつける為
            for n in 0...2{
               let myColor = UIColor.white
               let selectedColor = myColor.withAlphaComponent(0.5)
               memo[n].backgroundColor = selectedColor
            }
            //Indexページの初期化
            let bImage = UIImage(named: "blankW.png")
            indexImgs = Array(repeating: bImage!, count: pageGyou + 1)
            //memo[0].backgroundColor = UIColor.red.withAlphaComponent(0.1)
            memo[0].setIndexView()//タグを付ける、メモの作成(indexページ)
        
            // メモ表示内容の初期化
           
            let im = readPage(pn:1)//１ページ目の外部データを読み込む
            memo[1].setMemoFromImgs(pn:1,imgs:im)
            
            // ** memoView.userInteractionEnabled = true
            fNum = 1//⇒fNumに変更予定
            myScrollView.addSubview((memo[1]))
            self.view.addSubview(myScrollView)
            myScrollView.contentOffset = CGPoint(x:0,y: 0)
            // myScrollView.showHomeFrame()
            naviBar.topItem?.title = String(pageNum) + " /30"
            
            //mx[]の初期化,[0]は予約：将来図形モードを付加した場合等(セル高さ情報）
            for p in 1...30{
                for g in 0...30{
                    let s = String(p*100 + g)
                    mx[s] = 0
                }
            }

        }
        //---------- リストメニュ−　---------
        //テーブルビュー初期化、関連付け
        mh = ch * CGFloat(cn)//メニューの高さ＝セルの高さ☓セル数
        let w = boundWidth
        tV.frame         =   CGRect(x:0, y:0, width:mw + 20 , height:mh)
        smv = UIScrollView(frame: CGRect(x:w - mw - 10,y:65,width:mw + 20,height:mh - 0))
        smv.backgroundColor = UIColor.clear
        tV.separatorColor = UIColor.clear//セパレータ無し
        tV.rowHeight = 40
        tV.layer.cornerRadius = 8.0//角丸にする
        tV.layer.borderColor = UIColor.gray.cgColor
        tV.layer.borderWidth = 1
    //
        // シャドウカラー
        tV.layer.shadowColor = UIColor.black.cgColor/* 影の色 */
        tV.layer.shadowOffset = CGSize(width:1,height: 1)       //  シャドウサイズ
        tV.layer.shadowOpacity = 1.0        // 透明度
        tV.layer.shadowRadius = 1        // 角度(距離）
    //

        smv.contentSize = tV.frame.size
        smv.contentOffset = CGPoint(x:0,y:mh)
        smv.addSubview(tV)
        //smv.addSubview(bgV)
        
        tV.delegate      =   self
        tV.dataSource    =   self
        tV.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //indexChange(tag:nowGyouNo)
    }
    
    //  ======= End of viewDidLoad=======
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var naviBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var menu2: UIBarButtonItem!
    @IBOutlet weak var index2: UIBarButtonItem!
    @IBOutlet weak var pallete2: UIBarButtonItem!
    @IBOutlet weak var done2: UIBarButtonItem!
    
    @IBOutlet weak var zoom2: UIBarButtonItem!
    
    //INDEXの表示・非表示
    var retNum:Int = 0
    @IBAction func index(_ sender: UIBarButtonItem) {
        if isEditMode! { return }//パレットが表示中は実行しない
        //memo[0]-[2]に枠を追加する
        for n in 0...2{
            memo[n].layer.borderColor = UIColor.gray.cgColor
            memo[n].layer.borderWidth = 1
        }
        
        var opt = UIViewAnimationOptions.transitionFlipFromLeft
        if isIndexMode == false{//Indexページが非表示の場合
            //indexImgs[]からの反映
            //memo[0].setMemoFromImgs(pn:pageNum,imgs:indexImgs)
            memo[0].setIndexFromImgs(pn:pageNum,imgs:indexImgs)
            
            retNum = fNum
            opt = UIViewAnimationOptions.transitionFlipFromTop//transitionFlipFromRight
                        UIView.transition(
                from: memo[fNum],
                to: memo[0],
                duration: 0.7,
                options:opt,//transitionCurlDown,
                completion:{ (Bool) -> Void in
                    for n in 0...2{
                        memo[n].layer.borderColor = UIColor.clear.cgColor
                        memo[n].layer.borderWidth = 0
                    }
            })
            isIndexMode = true
            fNum = 0
            naviBar.topItem?.title = "--  INDEX  --"
            memo[0].delCursol()
            print("retNum1: \(retNum)")
        }else{//Indexページが表示中の場合
            print("index else**")
            //self.navigationController?.setToolbarHidden(true, animated: true)
            opt = UIViewAnimationOptions.transitionFlipFromBottom//transitionFlipFromLeft
            
            UIView.transition(
                from: memo[0],
                to: memo[retNum],
                duration: 0.9,
                options:opt,//transitionCurlDown,
                completion:{ (Bool) -> Void in
                    for n in 0...2{
                        memo[n].layer.borderColor = UIColor.clear.cgColor
                        memo[n].layer.borderWidth = 0
                    }
                }
            )
            isIndexMode = false
            print("retNum: \(retNum)")
            fNum = retNum
            naviBar.topItem?.title = String(pageNum) + " /30"
        }
    }
    
    @IBAction func menu(_ sender: UIBarButtonItem) {
        if isEditMode! { return }//パレットが表示中は実行しない
        if isMenuMode == false{//リストが非表示の場合
            view.addSubview(smv)
            smv.contentOffset = CGPoint(x:0,y:self.mh )
            UIScrollView.animate(withDuration: 0.3, animations: {
                () -> Void in
                self.smv.contentOffset = CGPoint(x:0,y:40)
            })
            isMenuMode = true
        }else{//リストが表示の場合
            UIScrollView.animate(withDuration: 0.3, animations: {
                () -> Void in
                self.smv.contentOffset = CGPoint(x:0,y:self.mh)
            }){ (Bool) -> Void in  // アニメーション完了時の処理
                self.smv.removeFromSuperview()
            }
            isMenuMode = false
            
        }

    }
 
    /* パレットの表示／非表示を交互に行う (NAVバーの右端ボタン) */
    @IBAction func Pallete(_ sender: UIBarButtonItem) {
        if isMenuMode! { return }//リストメニュー表示中は実行しない
        if isIndexMode! { return }//index表示中は実行しない
        //----------------------------------------------
        if drawableView != nil {// パレットが表示されている時パレットを消す
            //編集中のページ内容を更新する
            //myScrollView.upToImgs()//編集中のページ内容を更新する
            let im = memo[fNum].memoToImgs(pn: pageNum)
            writePage(pn: pageNum, imgs: im)//外部に保存
            indexImgs[pageNum] = indexChange(pn: pageNum)
            //　子viewを削除する??
            drawableView!.removeFromSuperview()
            drawableView = nil
            myScrollView.frame = scrollRect
            //myScrollView.showHomeFrame()//スクロール再設定の後は必要！
            etcBarDisp(disp: 0)//underView等を削除する
            isEditMode = false
            self.toolBar.isHidden  = true//ツールバーを隠す
            //メモページのカーソルを削除する
            memo[fNum].delCursol()
        }else{// パレットが表示されていない時パレットを表示する
            //パレットビューを作成・初期化する
            
            drawableView = DrawableView(frame: CGRect(x:0, y:0,width:vWidth, height:vHeight))//2→3
            drawableView.Delegate = self
            //let sa = (vWidth - boundWidth)/2  //?? ??
            let leftEndPoint = CGPoint(x: vWidth/2, y:boundHeight - vHeight/2 - 44)
            drawableView.layer.position = leftEndPoint
            
            drawableView.backgroundColor = UIColor.clear//(patternImage: myImage)
            self.view.addSubview(drawableView)
            // second view
            drawableView.setSecondView()
            isEditMode = true//パレットが表示されている場合は"true"
            self.toolBar.isHidden  = false//ツールバーを現す
            // frameの値を設定する.
            myScrollView.frame = scrollRect_P
            //myScrollView.showHomeFrame()
            etcBarDisp(disp: 1)//underView等」を追加する
            
            //１行目をパレットに呼び込む
            modalChanged(TouchNumber: pageNum*100 + 1)
        }
        
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        if isEditMode == true{
             //drawableView.thirdView.backgroundColor = UIColor.clear//前フィルタの色を無色にする
            drawableView.thirdView.removeFromSuperview()//3rdViewを取り出す
            //let resize = CGRect(x:0,y:0,width:leafWidth,height:leafHeight)//
            //let myImage1:UIImage = drawableView.GetImageWithResize(resize: resize)
            
            let palImage = drawableView.GetImage()
            let myImage1 = palImage.ResizeUIImage(width: leafWidth, height: leafHeight)
            //self.backgroundColor = UIColor(patternImage: myImage1)// @ @ @ @
            /*
             ========================================================
             let reSize = CGSize(width: leafWidth, height: leafHeight)
             let leafImage = myImage1.resize(reSize)
             //========================================================
             */
            print("fNum:\(fNum) ,tag: \(nowGyouNo)")
            
            // メモにパレット内容を書き込む
            memo[fNum].addMemo(img: myImage1!,tag:nowGyouNo)
            // 最大文字位置を保存する
            mx[String(nowGyouNo)] = mxTemp
            //メモに書き出した内容をパレットに読み込む//20161024追加 変更：20161202
            //let myMemo:UIImage = memo[fNum].readMemo(tag: nowGyouNo)
            //self.backgroundColor = UIColor(patternImage:myMemo)// @ @ @ @
            drawableView.reAddSubView()//前フィルタ(subView)を付加する
            //drawableView.thirdView.backgroundColor = UIColor(patternImage: UIImage(named: "blank.png")!)
            drawableView.addSubview(drawableView.thirdView)//3rdViewを追加する
            //lined = nil //20161024追加 @ @ @ @ @ 5
        }

    }
    
    @IBAction func zoom(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func redo(_ sender: UIBarButtonItem) {
    }
    //----------------- その他の関数　-------------------------
    //上下barView,スペーサー等の表示／非表示
    func etcBarDisp(disp:Int){
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
    
    //セルの長押し処理:長押しイベント処理
    func longPress(){
        print("longPush")
        if myScrollView.isLongPushed == false{//チャタリング防止作
            // ** [INDEXページ] **
            if isIndexMode == true{
              //飛び先ページを指定
                //-------
                let nextNum = nowGyouNo//myScrollView.selectedTag//タッチしたtag番号:0ページの為tag番号（一桁）がページ番号を現す。
                let im = readPage(pn:nextNum!)//外部から取得する
                fNum = 1
                memo[fNum].setMemoFromImgs(pn:nextNum!,imgs:im)
                retNum = fNum//表示するフレーム番号
                //--------
              //Indexボタンを押す
                self.index(self.index2)
              //ページ番号を更新する
                pageNum = nextNum!
                naviBar.topItem?.title = String(pageNum) + " /30"
                //飛び先のtag番号を決定する
                nowGyouNo = nextNum!*100 + 1
            // ** [メモページ] **
            }else{
              //editボタンを押す
              let nextNum = nowGyouNo//myScrollView.selectedTag//タッチしたtag番号
              self.Pallete(self.pallete2)//パレットを開く
              print("isEdit: \(isEditMode)")
              self.modalChanged(TouchNumber:nextNum!)//セルを選択
              memo[fNum].togglleCursol()
            }
        }
        myScrollView.isLongPushed = true//touchBeginsでfalseにリセットする
    }
    // ==  外部データ入出力関係  ==
    
    //外部のページデータを読み込む: photos”pn”[] ->[UIImage]
    func readPage(pn:Int)->[UIImage]{
        let retImgs = reloadToPage2(pn:pn)//UserDataをpageImmgs[]に読み込む
        if retImgs.count > 0{ return retImgs }
        else{ //外部データが無い場合は空白の目ページImgsを作成する
            let bImage:UIImage = UIImage(named: "blankW.png")!//⬅4545.png
            let blankImgs:[UIImage] = Array(repeating: bImage, count: pageGyou)
            return blankImgs }
    }
    ///UserDwfaultに保存のメモ画像をpageImgs:[]に読み込む
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
                //imgs.append(UIImage(data:images[k] as Data!,scale:CGFloat(retina))!)
            }
        }
        print("images[k]: \(imgs.count)")
        return imgs
    }
    
    //ページ内容を外部データに書き出す
    func writePage(pn:Int,imgs:[UIImage]){
        //UserDefaultに保存する
        let photos = imgs
        
        // [UIImage] → [NSData]
        let photoData: UserDefaults = UserDefaults.standard
        let dataImages: [Data] = photos.map { (image) -> Data in
            UIImagePNGRepresentation(image)!
            }
        let photosName:String = "photos" + String(pn)//保存名を決定
        photoData.set(dataImages, forKey: photosName)
        //photoData.synchronize()//必要かどうか？あると遅くなるのか？
    }
    
    //外部のページデータを削除する(all:1の場合は全削除）
    func delPage(pn:Int){
        if pn == 0{
        let appDomain:String = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }else if pn<31{
        // 指定キーidの値のみを削除
        let photosName:String = "photos" + String(pn)//保存名を決定
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: photosName)
        }
    }
 
    // == Index情報の更新プログラム ==
    //palleteを閉じるときにページデータからIndex内容を更新する
/*
    func clipImage(image: UIImage, y: CGFloat, height: CGFloat) -> UIImage {
        var imageRef = image.cgImage!.cropping(to: CGRect(x:0,y:y,width:image.size.width,height:height))
        var cropImage = UIImage(cgImage: imageRef!)
        return cropImage
    }
*/
    func test(){
        //保存する画像を設定する
        let targetIView = memo[fNum].viewWithTag(201) as! UIImageView
        let testImg = targetIView.image
        let testCGImg = testImg?.cgImage?.height
        
        print("書き込む画像サイズ: \(testImg?.size.height)")
        print("CGImage.size:\(testCGImg)")

    // = UserDefaultに保存する =
        // [UIImage] → [NSData]
        let testData: UserDefaults = UserDefaults.standard
        let dataImages:Data =  UIImagePNGRepresentation(testImg!)!
        let testName:String = "test01"//保存名を決定
        testData.set(dataImages, forKey: testName)

    // = UserDefaultから読み込む =
        if testData.object(forKey: testName) != nil{
            let img = testData.object(forKey: testName) as! NSData
            //let readImg = UIImage(data:img as Data)!
            let resdImg = UIImage(data:img as Data,scale:1.0)
            print("読み込んだ画像サイズ: \(resdImg?.size.height)")
            print("CGImageサイズ: \(resdImg?.cgImage?.height)")
        }

    // = UserDefaultをクリアする =
        testData.removeObject(forKey: testName)
    }

    func indexChange(pn:Int)-> UIImage{
        
        //??let scale = imageSize.height / viewSize.height
        //新しくコンテナView１つと3つのImageViewを作る
        var indexFView:UIView!
        var img01:UIImageView!
        var img02:UIImageView!
        var img03:UIImageView!
        
        indexFView = UIView(frame: CGRect(x:5,y: 210,width:leafWidth,height:leafHeight))
        img01 = UIImageView(frame:CGRect(x:0,y:0,width:leafHeight*2/3 - 1,height:leafHeight))
        img02 = UIImageView(frame:CGRect(x:leafHeight*2/3,y:0,width:leafWidth - 2*leafHeight,height:leafHeight))
        //枠線,色,角丸
        img01.layer.borderWidth = 1
        img01.layer.borderColor = UIColor.lightGray.cgColor
        img01.layer.cornerRadius = 5
        img02.layer.borderWidth = 2
        img02.layer.borderColor = UIColor.lightGray.cgColor
        img02.layer.cornerRadius = 7
        img03 = UIImageView(frame:CGRect(x:leafWidth - leafHeight*4/3 + 2,y:0,width:leafHeight*4/3 - 2,height:leafHeight))
        img03.layer.borderWidth = 1
        img03.layer.borderColor = UIColor.lightGray.cgColor
        img03.layer.cornerRadius = 5

        
        img01.backgroundColor = UIColor.clear
        img02.backgroundColor = UIColor.white//purple.withAlphaComponent(0.1)
        img03.backgroundColor = UIColor.purple.withAlphaComponent(0.05)

        
        //Viewの内容を作成
        //パレット全画面の切り取り????
        var tag:Int = pn*100 + 1
        let rt = CGFloat(retina)
        let targetIV = memo[fNum].viewWithTag(tag) as! UIImageView
        let tImage = targetIV.image
        //ピクセル画像のサイズ
        let pixWidth:CGFloat = leafWidth! * rt
        let pixHeight:CGFloat = leafHeight * rt
        //切り取りサイズ
        let clip02 = CGRect(x:0,y:0,width: pixWidth - pixHeight,height: pixHeight)
        //ピクセル画面での切り取り
        let clipImage02 =  (tImage?.cgImage!)!.cropping(to: clip02)
         print("◆◆CGIサイズ:\(tImage?.cgImage?.width)")
         print("◆◆clipImage02サイズ:\(clipImage02?.width)")
        //UIImageに変換
        img02.image = UIImage(cgImage: clipImage02!)
        //3つのViewを合成して１つのコンテナViewにする
        //subViewを全て削除する
        let subviews = indexFView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
        indexFView.removeFromSuperview()

        indexFView.addSubview(img01)
        indexFView.addSubview(img02)
        indexFView.addSubview(img03)
        //self.view.addSubview(indexFView)
        
        indexFView.backgroundColor =
            UIColor.clear
        //日付を追加する
        let compY = Calendar.Component.year
        let compM = Calendar.Component.month
        let compD = Calendar.Component.day
        
        let y = NSCalendar.current.component(compY, from: Date() as Date)
        let m = NSCalendar.current.component(compM, from: Date() as Date)
        let d = NSCalendar.current.component(compD, from: Date() as Date)
        let st = String(format: " %4d-\n %2d-%2d",y,m,d)
        print(st)
        print("\(y)\n\(m)/\(d)")// 1が日曜日 7が土曜日
        //画面全体をイメージ化する
         let orgImage = indexFView.GetImage()
        return orgImage.addIndexText(text:st,rect:img03.frame.offsetBy(dx: 1, dy: 2))
 
    }
 //============== 生き　===============
    //UserDefaultのIndexPage:photos[0]を削除する
    func delIndex(){
        delPage(pn:0)
    }
    
    //----- リストメニューtableView関連 ---------------
 
    func tableView(_ tV: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.items.count
    }
    
    func tableView(_ tV: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tV.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.text = self.items[indexPath.row]
        cell.contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.08)
        cell.textLabel!.font = UIFont(name: "Arial", size: 18)
        return cell
    }
    
    func tableView(_ tV: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("セルを選択しました！ #\(indexPath.row)!")
        let num = indexPath.row
        let itm = items[num]
        let msg = "実行してもいいですか？"
        //--------------------------
 
        if num != 7 && num != 4{

        let alert: UIAlertController = UIAlertController(title: itm, message: msg, preferredStyle:  UIAlertControllerStyle.alert)

        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理（クロージャ実装）
            (action: UIAlertAction!) -> Void in

            switch num {
            case 1:self.fc1()
            case 2:self.fc2()
            case 3:self.fc3()
            case 5:self.fc5()
            case 6:self.fc6()
                   break
            default: break
            }
           })
      
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in print("Cancel")
            })

        alert.addAction(cancelAction)// ③ UIAlertControllerにActionを追加
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)// ④ Alertを表示
        }//----------↖
       
        tV.deselectRow(at: indexPath as IndexPath, animated: true)//カーソルを消す
        if num == 4{return}
        self.menu(self.menu2)//メニューボタンを押す
    }
    /* リストメニュー選択時の処理 */
    func fc1(){print("test1!!!!!")}
    func fc2(){print("test2!!!!!")}
    func fc3(){
        print("test3!!!!!")
        //現行ベージの内容を削除する
        delPage(pn: pageNum)
        let im = readPage(pn:pageNum)//現在ページの外部データを読み込む
        memo[fNum].setMemoFromImgs(pn:pageNum,imgs:im)    }
    func fc5(){print("test5!!!!!")}
    func fc6(){
        print("test6!!!!!")
        let dmmy = indexChange(pn:2)
        test()
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
        print("btn2_clicked!：ペン色切り替え")
        if penColorNum == 1 {
            penColorNum = 2
        }else if penColorNum == 2{
            penColorNum = 3
        }else{
            penColorNum = 1
        }
    }
    
    func btn3_click(sender:UIButton){
        print("btn3_clicked!：ペンモード")
        drawableView.X_color = 0//ペンモード[黒色、赤色、青色]
    }
    
    func btn4_click(sender:UIButton){
        print("btn4_clicked!:消しゴム")
        drawableView.X_color = 1//消しゴムモード
    }
    func btn5_click(sender:UIButton){print("btn5_clicked!")}
    func btn6_click(sender:UIButton){print("btn6_clicked!")}
    
    func btn7_click(sender:UIButton){
        print("btn7_clicked!")
    }

    
    func btn8_click(sender:UIButton){
        //----------ページの右端に太線-------------------------
        print("btn8_clicked!")
        //現行ベージの内容を削除する
        delPage(pn: pageNum)
        
        let im = readPage(pn:pageNum)//現在ページの外部データを読み込む
        memo[fNum].setMemoFromImgs(pn:pageNum,imgs:im)
    }
    
    func btn9_click(sender:UIButton){print("btn9_clicked!")}
    func btn10_click(sender:UIButton){print("btn10_clicked!")}
    
   /* -------------------　スワイプ関数　-----------------------------*/
    func swipeR(){
        if isIndexMode! { return }//Indexが表示中は実行しない
        if isEditMode! { return }//パレットが表示中は実行しない
        if pageNum == 1{ return }//１ページが最終ページ
        
        for n in 0...2{//ボーダーラインを付ける
            memo[n].layer.borderColor = UIColor.gray.cgColor
            memo[n].layer.borderWidth = 1
        }
        var f = 0
        f = (fNum == 1) ? 2: 1
        //-------
        let im = readPage(pn:pageNum - 1)
        memo[f].setMemoFromImgs(pn:pageNum - 1,imgs:im)
        //--------
        //memo[f] =
        UIView.transition(
            from: memo[fNum],
            to: memo[f],
            duration:0.8,
            options:UIViewAnimationOptions.transitionFlipFromLeft,
            completion:  { (Bool) -> Void in
                for n in 0...2{//ボーダーラインを消す
                    //memo[n].layer.borderColor = UIColor.clear.cgColor
                    memo[n].layer.borderWidth = 0
                }
        })
        fNum = f
        //--------
        pageNum -= 1
        //if pageNum < 1{pageNum = 1}
        naviBar.topItem?.title = String(pageNum) + " /30"
        //--------
    }
    
    func swipeL(){
        if isIndexMode! { return }
        if isEditMode! { return }//パレットが表示中は実行しない
        if pageNum >= 30{ return }
        
        for n in 0...2{
            memo[n].layer.borderColor = UIColor.gray.cgColor
            memo[n].layer.borderWidth = 1
        }

        var f = 0
        f = (fNum == 1) ? 2: 1//フレームのトグル
        //-------
        let im = readPage(pn:pageNum + 1)
        memo[f].setMemoFromImgs(pn:pageNum + 1,imgs:im)
        //--------
            UIView.transition(
                from: memo[fNum],
                to: memo[f],
                duration:0.7,
                options:UIViewAnimationOptions.transitionFlipFromRight,
                completion: { (Bool) -> Void in
                    for n in 0...2{
                      memo[n].layer.borderColor = UIColor.clear.cgColor
                      memo[n].layer.borderWidth = 0
                    }
                })
        fNum = f
        //-----------
        pageNum += 1
        naviBar.topItem?.title = String(pageNum) + " /30"
        //-----------------------------------------
                //transitionCurlUp,
    }


    
    
    /* -------------------　プロトコル関数　-----------------------------*/
    func modalChanged(TouchNumber: Int) {// protocol ScrollViewDelegate
        print("TouchNumber:@\(TouchNumber)")
        print("fNum:\(fNum)")
            nowGyouNo = TouchNumber
            print("nowGyouNo?: \(nowGyouNo)")
        //対象行のTag番号のleafViewのmaxPosXをmxTempにコピーする。
        mxTemp = mx[String(nowGyouNo)]

            //パレット表示中
            if isEditMode == true{
                //メモに書き出した内容をパレットに読み込む//20161024追加
                let myMemo:UIImage = memo[fNum].readMemo(tag: nowGyouNo)
                //表示中のフレーム番号
                //let fn = Int(myScrollView.contentOffset.x/leafWidth) + 1
                memo[fNum].selectedNo(tagN: nowGyouNo)
                //パレットの表示位置をリセットする
                drawableView.layer.position = CGPoint(x:vWidth/2, y:boundHeight - 44 - vHeight/2)
                
            //
                //パレット表示用にリサイズする(extension)
                //====================================================
                let reSize = CGSize(width: vWidth, height: vHeight)
                let reMemo = myMemo.resize(size: reSize)
                //====================================================
            //
                drawableView.backgroundColor = UIColor(patternImage: reMemo)
                //
               drawableView.lastDrawImage = nil//21061213に追加
                drawableView.secondView.backgroundColor = UIColor.clear
             //パレット非表示の場合
            }else if isIndexMode == true{
                memo[fNum].selectedNo(tagN:nowGyouNo)
            }else{}
        print("** nowGyouNo: \(nowGyouNo)")
    }
    
    func dispPosChange(midX: CGFloat,deltaX:CGFloat){// protocol UpperToolViewDelegate
        //print("midX: \(midX)")
        var midX2 = midX
        let topX:CGFloat = vWidth/2
        let lastX:CGFloat = boundWidth - vWidth/2
        let dir = deltaX>=0 ? 1 : 0 //0:右へシフト,1:左へシフト
        //先頭へシフトする場合
        if dir == 0{
           if drawableView.frame.midX >= topX{//Viewの中心のX座標
             drawableView.layer.position = CGPoint(x: topX, y:boundHeight - vHeight/2 - 44)
           }
        //末尾にシフト
        }else if dir == 1{
            if drawableView.frame.midX < lastX{//Viewの中心のX座標
                drawableView.layer.position = CGPoint(x: lastX, y:boundHeight - vHeight/2 - 44)
            }
        }
        if midX > topX{ midX2 = topX}
        if midX < lastX{ midX2 = lastX}
        drawableView.layer.position = CGPoint(x: midX2, y:boundHeight - vHeight/2 - 44)
    }
    /* ------------------------ デリゲート関数　-------------------------- */
    var scrollBeginingPoint: CGPoint!
    
    private func scrollViewWillBeginDragging(myScrollView: UIScrollView) {
        scrollBeginingPoint = myScrollView.contentOffset;
        print("SSSSSS")
    }
    
    func scrollViewDidScroll(myScrollView: UIScrollView) {
        let currentPoint = myScrollView.contentOffset
        if(scrollBeginingPoint.y < currentPoint.y){
            print("下へスクロール")
        }else{
            print("上へスクロール")
        }
    }
    
    func selectNextGyou() {
        print("selectNextGyou")
        done(done2)// okボタンを押す
        if nowGyouNo%100 < 30{
           modalChanged(TouchNumber:nowGyouNo + 1)
        }
    }

    
  //------------------------------------------------------------------
  //---------------旧ボタン関数(未使用）----------------------------------
    func insert(sender: AnyObject) {//xxxx,◾◾◾◾：メニュー
        memo[fNum].insertNewMemo(gyou: nowGyouNo,maxGyou:pageGyou)
        
        /*  ?一行増やす場合とそうでない場合があるので下記は関数の中に持っていく
         //表示範囲も１行分拡大する
         memoLowerMargin += 1
         myScrollView.contentSize = CGSizeMake(leafWidth,(leafHeight + leafMargin) * CGFloat(pageGyou + memoLowerMargin) + topOffset)
         //メモViewのサイズを拡大する
         memoView.frame = CGRectMake(0, 0,leafWidth, (leafHeight + leafMargin) * CGFloat(pageGyou) + topOffset)
         */
        
        modalChanged(TouchNumber: nowGyouNo)
    }
 /*
    func x_delMemo(sender: AnyObject) {//xxxx,◾◾◾◾：メニュー
        memo[fNum].delSelectedMemo(gyou: nowGyouNo,maxGyou: pageGyou)
        modalChanged(TouchNumber:  nowGyouNo)
        // 保存データを全削除
        //
        //let userDefault = UserDefaults.standard
        let appDomain:String = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        /*
         // 指定キーidの値のみを削除
         let userDefault = NSUserDefaults.standardUserDefaults()
         userDefault.removeObjectForKey("id")
         */
    }
 
    func x_save(sender: AnyObject) {//◾◾◾◾：xxxx自動
        //ページ数を取得する(ページ総数　+ Indexページ)
        print("pageImgs.count: \(pageImgs.count)")
        
        //メモをpageImgsにupdataする
        for pn in 0..<pageImgs.count{
            //* メモ(leaf)[m]をメモ画像:pageImgs[n]にUPする */
            memo[fNum].memoTopageImgsToMemo(pn:pn)//⬅ pageNum
        }
        
        //UserDefaultに保存する
        for pn in 0..<pageImgs.count{
            memo[fNum].saveImage3(pn: pn,imgs: pageImgs[pn])//頁番号，頁内容
        }
    }
*/
/*
    
    func reload(sender: AnyObject) {//xxxx，◾◾◾◾：編集破棄の場合
        //myScrollView.Tshow_4thFrame()
        //myScrollView.gotoNextPage()
 
    }
 */
/*
    
    func toLeft(sender: AnyObject) {//xxxx
        if isEditMode == true{
            let myWidth = self.view.frame.width//画面の幅
            //
            var midX = drawableView.frame.midX//Viewの中心のX座標を取得
            midX = midX + myWidth/6
            drawableView.layer.position = CGPoint(x: midX, y:boundHeight - vHeight/2 - 44)//@
        }
    }
 */
/*
    func CR(sender: AnyObject) {//xxxx
        if isEditMode == true{
            //let myWidth = self.view.frame.width//画面の幅
            /* first_Memo-view */
            
            //入力パレットの表示位置(横方向）を決める
            drawableView.layer.position = CGPoint(x: vWidth/2, y:boundHeight - vHeight/2 - 44)
            
            if nowGyouNo < pageGyou {nowGyouNo = nowGyouNo + 1}
            //対象行を一行下げる

            //print("-----------------------------------")
            //メモに書き出した内容をパレットに読み込む//20161024追加
            
            let myMemo:UIImage = memo[fNum].readMemo(tag: nowGyouNo)
            drawableView.backgroundColor = UIColor(patternImage: myMemo)
            drawableView.X_color = 0//ペン色：黒
            //resetFunc()//reset動作をさせる
        }
    }
 */
/*
    func addMemo(sender: AnyObject) {//xxxx
        if isEditMode == true{
            
            let myWidth = self.view.frame.width//画面の幅
            // ボタンの位置取得
            var midX = drawableView.frame.midX//Viewの中心のX座標を取得
            midX = midX - myWidth/6
            drawableView.layer.position = CGPoint(x: midX, y:boundHeight - vHeight/2 - 44)//@
        }
    }
    
    func edit(sender: AnyObject) {//xxxx「ペン色の変更」として流用
        if isEditMode == true{
            
            if drawableView.X_color == 0{
                drawableView.X_color = 1 //ペン色：白色
            }else{
                drawableView.X_color = 0 //黒色
            }
        }
    }
    
    func color(sender: AnyObject) {//xxxx「カーソルUP」として流用する
        if isEditMode == true{
            if nowGyouNo > 1{
                nowGyouNo = nowGyouNo - 1//対象行を一行上げる
            }else{ nowGyouNo = 1 }
            
            //メモに書き出した内容をパレットに読み込む//20161024追加
            let myMemo:UIImage = memo[fNum].readMemo(tag: nowGyouNo)

            drawableView.backgroundColor = UIColor(patternImage: myMemo)
            drawableView.X_color = 0//ペン色：黒
        }
    }
 */
/*
    func reset(sender: AnyObject) {//xxxx
        if isEditMode == true{
            //let myWidth = self.view.frame.width//画面の幅
            drawableView.X_color = 0//ペン色：黒
            //drawableView.refresh()
            //drawableView.flagRset()//@
            //let sa = (vWidth - boundWidth)/2  //?? ??
            let leftEndPoint = CGPoint(x: vWidth/2, y:boundHeight - vHeight/2 - 44)
            drawableView.layer.position = leftEndPoint
            myScrollView.frame = scrollRect_P
            memo[fNum].clearMemo(tag: nowGyouNo)
        }else{
            //myScrollView.Tshow_1beforeFrame()
            //myScrollView.showHomeFrame()
            //myScrollView.showBackPage()
        }
    }
 */
/*
    //これから読み込むUserDataに存在するページ数を取得する
    func UserDataNum2()->Int{
        //print(NSUserDefaults.standardUserDefaults().dictionaryRepresentation())
        
        let photoData = UserDefaults.standard
        let dic: NSDictionary = photoData.dictionaryRepresentation() as NSDictionary
        let keys = dic.allKeys
        var kn = 0
        for k in 0...20{
            let key = "photos" + String(k + 1)
            let found = keys.contains(where: { return $0 as! String == key })
            if found == false { break}
            kn = kn + 1
        }
        print("OK Google!: \(kn)")
        return kn
    }
*/
/*
     //新しいページを作成して末尾に追加する
     func x_createNewPageImg2(){
     let bImage:UIImage = UIImage(named: "blankW.png")!//⬅4545.png
     let blankImgs:[UIImage] = Array(repeating: bImage, count: pageGyou)
     pageImgs.append(blankImgs)
     }
*/
/*
     //UserDataをpageImmgs[]に読み込む
     func x_readUserData2(pn:Int){
     let rl = reloadToPage2(pn: pn)
     if rl.count > 0 { //これがないと読み込みエラーが発生 初期ではrl.count= 0
     pageImgs[pn] = rl
     }
     }
*/
    //---- ページデータの読み込み・作成　-------------
    /*
     //UserDrfaultの頁数を調べる
     let dataPn = UserDataNum2()//保管してあるページ数
     //pageImgs[]の初期化(必要なページ分だけで作る)
     var num:Int = 0
     if dataPn != 0{
     let sa = dataPn - pageImgs.count + 1
     if sa > 0{ num = sa }else{ num = 3 }
     for _ in 1...num{
     createNewPageImg2()
     }
     //imgsに保存データを読み込む
     for _ in 0..<dataPn{
     //readUserData2(pn: i)
     }
     }else{//保存ページが1つもない場合
     for _ in 0..<3{
     createNewPageImg2()//pageImgs[]にappendする
     }
     }
     
     //3ページの作成：pageImgs[[30],[30],[30]]
     for _ in 0..<3{
     createNewPageImg2()//pageImgs[]にappendする
     }
     */

}
