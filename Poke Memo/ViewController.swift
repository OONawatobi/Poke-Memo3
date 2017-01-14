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
        border3.frame = CGRect(x:self.frame.size.width/2, y:0,width:width/2,
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
        //let widthRatio = size.width / self.size.width
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
var testV:UIView!//デバグ用：mx[]位置を表示する。、赤色
var debug1:Bool = true//デバグ用：ページタグ表示
var debug2:Bool = true//デバグ用：mx[]表示

let boundWidth = UIScreen.main.bounds.size.width
let boundHeight = UIScreen.main.bounds.size.height
//var retina:Int = 2//レティナディスプレイ対応
let retina:Int = Int(UIScreen.main.scale)//レティナ分解能の抽出
var infoPage:[(memoNo:Int,gyou:Int,maxUsingGyouNo:Int)]!//未使用
var isEditMode:Bool! = false//パレットが表示されている場合：true
var isIndexMode:Bool! = false//Indexの表示フラグ：true
//エディット画面関係
var editFlag:Bool = false//パレット編集モードが選ばれるとtrue
var myInt : String = "NON"//パレット編集モード
var cursolWFlag:Bool = false//カーソル巾が5以上になると１


var penColorNum:Int = 1
let homeFrame:Int = 2//表示用フレーム ⇒グローバル定数
//-----ページ---------
var indexImgs:[UIImage] = []//index[0−29]の画像
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
var editorView:EditorView! = nil//エディター画面
let vHeight: CGFloat = 181 //手書きビューの高さ@@@@@@@@
var vWidth:CGFloat! = leafWidth*(vHeight/leafHeight)
var maxPosX:CGFloat! = 0//描画したｘ座標の最大値
var mx  = [String: CGFloat]()//[Tag番号:maxPosX]
//var mxs:[[String: CGFloat]] = [[:]]//mxs.count = 30
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
    func shiftMX()
    func upToMemo()
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
    var svOffset:CGFloat = 0
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
    var titleV:UIImageView!//indexページのタイトル
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        //本機種の解像度
        print("　〓retina scale〓 :\(UIScreen.main.scale)")
        //testVを作成  = debug2 =
        testV = UIView(frame:CGRect(x: 0, y:0 , width: 2, height: vHeight))
        testV.backgroundColor = UIColor.magenta
        //mx[]の位置にtestVを表示する
        testV.layer.position = CGPoint(x: 0, y:vHeight/2 )
        
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
        underView.alpha = 0.33// 透明度を設定
        underView.layer.position = CGPoint(x: self.view.frame.width/2, y:boundHeight - 44 - 10)// 位置を中心に設定
        /** upperViewを生成. **/
        upperView = UIView(frame: CGRect(x: 0, y: 0, width: boundWidth, height: 20))// underViewを生成.
        upperView.backgroundColor = UIColor.green
        upperView.alpha = 0.33// 透明度を設定
        upperView.layer.position = CGPoint(x: self.view.frame.width/2, y:boundHeight - vHeight - 44 + 10)// 位置を中心に設定
        upperView.isUserInteractionEnabled = false
        
        /** myToolView ([色][ペン][消しゴム][▲])を生成. **/
        myToolView.Delegate = self
        myToolView.frame =  CGRect(x: 0, y: 0, width: boundWidth, height: 40)// underViewを生成.
        myToolView.backgroundColor = UIColor(patternImage: UIImage(named:"2lines.png")!)
        myToolView.alpha = 0.5// 透明度を設定
        
        myToolView.addHorizonBorderWithColor(color: UIColor.black, width:1)
        
        //ツールViewのボタンの生成　[2][3][4]   [1]
        // button1の追加
        editButton1 = UIButton(frame: CGRect(x:boundWidth - 40,y: 10, width:25, height:20))
        editButton1.backgroundColor = UIColor.clear  // タイトルを設定する(通常時)
        //editButton1.setTitle("💠", for: UIControlState.normal)
        editButton1.setImage(UIImage(named: "red3.png"), for:UIControlState.normal)
        // イベントを追加する
        editButton1.addTarget(self, action: #selector(ViewController.btn1_click(sender:)), for: .touchUpInside)
        
        
        // button2の追加
        editButton2 = UIButton(frame: CGRect(x:10, y:10, width:20, height:20))
        editButton2.backgroundColor = UIColor.clear
        editButton2.layer.cornerRadius = 5
        //editButton2.layer.masksToBounds = true//角のはみ出しをマスクする
        editButton2.layer.borderColor = UIColor.black.cgColor
        editButton2.layer.borderWidth = 2
        editButton2.addTarget(self, action: #selector(ViewController.btn2_click(sender:)), for:.touchUpInside)
        //editButton2.setTitle("2", for: UIControlState.normal)
        editButton2.setImage(UIImage(named: "スペード.png"), for:UIControlState.normal)
        
        // button3の追加
        editButton3 = UIButton(frame: CGRect(x:60, y:5, width:30, height:30))
        editButton3.layer.cornerRadius = 5
        editButton3.backgroundColor = UIColor.init(white: 0.75, alpha: 1)
        editButton3.addTarget(self, action: #selector(ViewController.btn3_click(sender:)), for:.touchUpInside)
        //editButton3.setTitle("3", for: UIControlState.normal)
        editButton3.setImage(UIImage(named: "pen2.png"), for:UIControlState.normal)
        
        /** button4の追加 **/
        editButton4 = UIButton(frame: CGRect(x:110, y:5, width:30, height:30))
        editButton4.backgroundColor = UIColor.init(white: 0.75, alpha: 0)
        editButton4.layer.cornerRadius = 5
        editButton4.addTarget(self, action: #selector(ViewController.btn4_click(sender:)), for:.touchUpInside)
        //editButton4.setTitle("4", for: UIControlState.normal)
        editButton4.setImage(UIImage(named: "keshi.png"), for:UIControlState.normal)
        
        //ボタンをツールバーに追加する
        myToolView.addSubview(editButton1)
        myToolView.addSubview(editButton2)
        myToolView.addSubview(editButton3)
        myToolView.addSubview(editButton4)
        self.toolBar.isHidden  = true//ツールバーを隠す
        
        /* editView([<][OVW][INS][DEL][CLR][>])を生成. */
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
        editButton5.backgroundColor = UIColor.clear
        editButton5.layer.cornerRadius = 8
        //editButton5.layer.masksToBounds = true
        editButton5.addTarget(self, action: #selector(ViewController.btn5_click(sender:)), for:.touchUpInside)
        editButton5.setImage(UIImage(named: "OVRW.png"), for:UIControlState.normal)
        //editButton5.setTitle("5", for: UIControlState.normal)
        myEditView.addSubview(editButton5)
 
        //button6の追加
        editButton6 = UIButton(frame: CGRect(x:x05 + CGFloat(tW), y:10, width:50, height:40))
        editButton6.backgroundColor = UIColor.clear
        editButton6.layer.cornerRadius = 8
        editButton6.addTarget(self, action: #selector(ViewController.btn6_click(sender:)), for:.touchUpInside)
        editButton6.setImage(UIImage(named: "INS.png"), for:UIControlState.normal)
        //editButton6.setTitle("6", for: UIControlState.normal)
        myEditView.addSubview(editButton6)
        //button7の追加
        editButton7 = UIButton(frame: CGRect(x:x05 + CGFloat(tW)*2,y: 10,width: 50, height:40))
        editButton7.backgroundColor = UIColor.clear
        editButton7.layer.cornerRadius = 8
        editButton7.addTarget(self, action: #selector(ViewController.btn7_click(sender:)), for:.touchUpInside)
        editButton7.setImage(UIImage(named: "DEL.png"), for:UIControlState.normal)
        //editButton7.setTitle("7", for: UIControlState.normal)
        myEditView.addSubview(editButton7)
        //button8の追加
        editButton8 = UIButton(frame: CGRect(x:x05 + CGFloat(tW)*3, y:10, width:50,height: 40))
        editButton8.backgroundColor = UIColor.clear
        editButton8.layer.cornerRadius = 8
        editButton8.addTarget(self, action: #selector(ViewController.btn8_click(sender:)), for:.touchUpInside)
        editButton8.setImage(UIImage(named: "CLR.png"), for:UIControlState.normal)
        //editButton8.setTitle("8", for: UIControlState.normal)
        myEditView.addSubview(editButton8)
        
        editButton9 = UIButton(frame: CGRect(x:10, y:10, width:30,height: 40))
        editButton9.backgroundColor = UIColor.clear
        editButton9.layer.cornerRadius = 8
        editButton9.addTarget(self, action: #selector(ViewController.btn9_click(sender:)), for:.touchUpInside)
        editButton9.setTitle("|<", for: UIControlState.normal)
        myEditView.addSubview(editButton9)
        
        editButton10 = UIButton(frame: CGRect(x:boundWidth - 40, y:10, width:30,height: 40))
        editButton10.backgroundColor = UIColor.clear
        editButton10.layer.cornerRadius = 8
        editButton10.addTarget(self, action: #selector(ViewController.btn10_click(sender:)), for:.touchUpInside)
        editButton10.setTitle(">|", for: UIControlState.normal)
        myEditView.addSubview(editButton10)
        
        /* ScrollViewを生成. */
        myScrollView.Delegate2 = self
        //myScrollView.Delegate3 = self
        //パレット表示されていない場合
        scrollRect = CGRect(x:(boundWidth - leafWidth)/2, y:70  ,width:leafWidth, height:boundHeight - 20 - 44 - 10 )
        
        //パレット表示されている場合
        scrollRect_P = CGRect(x:(boundWidth - leafWidth)/2,y: 70,width:leafWidth, height:boundHeight - 20 - 44 - 44 - vHeight - 50)//最後の50は目で見て調整した
        
        myScrollView.frame = scrollRect
        myScrollView.bounces = false//スクロールをバウンドさせない
        self.view.addSubview(myScrollView)
        myScrollView.isUserInteractionEnabled = true
        //myScrollView.isPagingEnabled = false//離散スクロール
        myScrollView.showsVerticalScrollIndicator = true
        myScrollView.showsHorizontalScrollIndicator = false// 横スクロールバー非表示
        myScrollView.contentSize = CGSize(width:leafWidth,height:(leafHeight + leafMargin) * CGFloat(pageGyou + memoLowerMargin) + topOffset)
        //myScrollView.directionalLockEnabled = true
        
        myScrollView.backgroundColor = UIColor.white
        
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
            // ** Indexページの初期化 **
            memo[0].backgroundColor = UIColor.clear//blue.withAlphaComponent(0.1)
            //let bI = UIImage(named: "僕の世界.jpg")
            //memo[0].backgroundColor = UIColor(patternImage: bI!)
            indexImgs = readPage(pn:0)//0ページ目の外部データを読み込む
            memo[0].setIndexView()//タグを付ける、メモの作成(indexページ)
            //indexタイトルの作成
            titleV = UIImageView(frame: CGRect(x:(boundWidth - leafWidth)/2, y:70,width:myScrollView.frame.width,height:topOffset*2))
            titleV.backgroundColor = UIColor.init(white: 0.9, alpha: 1)
            titleV.addBottomBorderWithColor(color: UIColor.gray, width: 1.5)
            let tw = titleV.frame.width
            let th = titleV.frame.height
            let label1 = UILabel(frame: CGRect(x:0,y:15,width:tw/3,height:th/2))
            let label2 = UILabel(frame: CGRect(x:tw/2 - tw/6,y:15,width:tw/3,height:th/2))
            let label3 = UILabel(frame: CGRect(x:tw*2/3 ,y:15,width:tw/3 - 10,height:th/2))
            label1.text = " NO."
            label2.text = "TITLE"
            label3.text = "UPDATE"
            label2.textAlignment = .center
            label3.textAlignment = .right
            //label1.backgroundColor = UIColor.red
            //label2.backgroundColor = UIColor.red
            //label3.backgroundColor = UIColor.red


            //label1.font = UIFont(name: "HiraMinProN-W3", size: 9)
            //label1.sizeToFit();label2.sizeToFit();label3.sizeToFit()
            titleV.addSubview(label1)
            titleV.addSubview(label2)
            titleV.addSubview(label3)
            // ** メモ表示内容の初期化 **
            let im = readPage(pn:1)//１ページ目の外部データを読み込む
            memo[1].setMemoFromImgs(pn:1,imgs:im)
            fNum = 1
            //nowGyouNoの更新
            nowGyouNo = 1 * 100 + 1
            myScrollView.addSubview((memo[1]))
            self.view.addSubview(myScrollView)
            myScrollView.contentOffset = CGPoint(x:0,y: 0)
            // myScrollView.showHomeFrame()
            naviBar.topItem?.title = String(pageNum) + " /30"
            
            // **mx[]の読み込み・初期化 **
            mx = loadMx()
            print("105: \(mx["105"])")
            
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
    /*
        // シャドウカラー
        tV.layer.shadowColor = UIColor.black.cgColor/* 影の色 */
        tV.layer.shadowOffset = CGSize(width:1,height: 1)       //  シャドウサイズ
        tV.layer.shadowOpacity = 1.0        // 透明度
        tV.layer.shadowRadius = 1        // 角度(距離）
    */

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
        //index タイトルを追加表示する
        
        //titleView.removeFromSuperview()

        if isEditMode! { return }//パレットが表示中は実行しない
        //memo[0]-[2]に枠を追加する
        for n in 0...2{
            memo[n].layer.borderColor = UIColor.gray.cgColor
            memo[n].layer.borderWidth = 1
        }
        
        var opt = UIViewAnimationOptions.transitionFlipFromLeft
        if isIndexMode == false{//Indexページが非表示の場合
            
            //indexImgs[]からの反映
            memo[0].setIndexFromImgs(imgs:indexImgs)
            
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
                self.view.addSubview(self.titleV)
            })
            isIndexMode = true
            fNum = 0
            naviBar.topItem?.title = "--  INDEX  --"
            memo[0].delCursol()
            print("retNum1: \(retNum)")
            myScrollView.backgroundColor =  UIColor.blue.withAlphaComponent(0.1)
           
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
            myScrollView.backgroundColor =  UIColor.clear
            titleV.removeFromSuperview()
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
            
            //ボタンの画像を入れ替える
             //menu2.setBackgroundImage(UIImage(named: "enn2.png"), for:UIControlState.normal, style: UIBarButtonItemStyle.plain, barMetrics:UIBarMetrics.compact)
            
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
    var animeFlag:Bool = false//アニメ中はtrue
    @IBAction func Pallete(_ sender: UIBarButtonItem) {
        if animeFlag { return}//アニメ中は実行しない
        if isMenuMode! { return }//リストメニュー表示中は実行しない
        if isIndexMode! { return }//index表示中は実行しない
        
        animeFlag = true//アニメ開始(開始ボタンのチャタリング防止用）
        //----------------------------------------------
        if drawableView != nil {
        // ◆◆ パレットが表示されている時パレットを消す
           //編集中のページ内容を更新する
            //myScrollView.upToImgs()//編集中のページ内容を更新する
            let im = memo[fNum].memoToImgs(pn: pageNum)
            //メモ内容を外部に保存
            writePage(pn: pageNum, imgs: im)
            //INDEX内容を外部に保存
            writePage(pn:0, imgs:indexImgs)
            //mx[]の内容を外部に保存する
            print("mx[105]up:\(mx["105"])")
            updataMx(my:mx)
            
            
           //++ パレットを閉じるアニメーション
            self.etcBarDisp(disp: 0)//underView等を削除する
            //self.toolBar.isHidden  = true//ツールバーを隠す
            UIView.animate(withDuration:0.3, animations: {
                () -> Void in
                self.myToolView.layer.position = CGPoint(x: self.view.frame.width/2, y:boundHeight + 44 - 40/2)
                let nowPosx = drawableView.layer.position.x//表示中の位置
                drawableView.layer.position = CGPoint(x:nowPosx , y:boundHeight + 44 - 40/2 + vHeight/2)
                self.myScrollView.frame = self.scrollRect// メモframeの値を設定する

            }){
                (Bool) -> Void in
                
                self.toolBar.isHidden  = true//ツールバーを隠す
                //　子viewを削除する??
                drawableView!.removeFromSuperview()
                drawableView = nil
                self.myToolView.removeFromSuperview()
                
                //アニメーションの終わり
                self.animeFlag = false
                
            }
            
            //メモページのカーソルを削除する
            memo[fNum].delCursol()
            
            //ページ登録フラグを更新する
            for n in 1...30{
                print("mx[\(n)]= \(mx[String(n)])")
            }
            
            isEditMode = false
        }else{
        // ◆◆ パレットが表示されていない時パレットを表示する
            //パレットビューを作成・初期化する
            self.view.addSubview(myToolView)
            myToolView.layer.position = CGPoint(x: self.view.frame.width/2, y:boundHeight + 44 - 40/2)// 位置を中心に設定：画面の外に位置する
            //++++++ パレットを開くアニメーション
            UIView.animate(withDuration:0.3, animations: {
                () -> Void in
                self.myToolView.layer.position = CGPoint(x: self.view.frame.width/2, y:boundHeight - vHeight - 44 - 40/2 )//++ 位置を中心に設定
                self.myScrollView.frame = self.scrollRect_P// メモframeの値を設定する
            }){
            (Bool) -> Void in
                self.view.addSubview(drawableView)
                self.etcBarDisp(disp: 1)//underView等」を追加する
                self.toolBar.isHidden  = false//ツールバーを現す
                //アニメ動作終了
                self.animeFlag = false//アニメ動作終了宣言
             }
            //+++++++++++++++++++++++++++++++++++++++
            
            drawableView = DrawableView(frame: CGRect(x:0, y:0,width:vWidth, height:vHeight))//2→3
            
            drawableView.Delegate = self
            //let leftEndPoint = CGPoint(x: vWidth/2, y:boundHeight - vHeight/2 - 44)
            
            //無くても動くの,何故????drawableView.layer.position = leftEndPoint
            drawableView.backgroundColor = UIColor.clear//(patternImage: myImage)
            drawableView.setSecondView()//編集ツールの追加
           
            isEditMode = true//パレットが表示されている場合は"true"
            //編集画面非表示フラグをリセットする
            myEditFlag = false
            //１行目をパレットに呼び込む
            modalChanged(TouchNumber: pageNum*100 + 1)
            penMode()//黒ペンモードにする
            closeEditView()//編集画面の設定を初期化する
            // == debug2 ==========================================================
            if debug2 == true{drawableView.addSubview(testV)}      //@@ DEBUG2 @@
            testV.layer.position = CGPoint(x: mxTemp, y:vHeight/2 )
            // =====================================================================
            
        }
    }
    
    ///  ** パレット入力時における[OK]ボタン処理 **
    func upToMemo(){  //パレット内容をメモに反映させる
        drawableView.thirdView.removeFromSuperview()//3rdViewを取り出す
        let palImage = drawableView.GetImage()
        let myImage1 = palImage.ResizeUIImage(width: leafWidth, height: leafHeight)
        print("fNum:\(fNum) ,tag: \(nowGyouNo)")
        // メモにパレット内容を書き込む
        memo[fNum].addMemo(img: myImage1!,tag:nowGyouNo)
        // 最大文字位置を保存する
        mx[String(nowGyouNo)] = mxTemp
        //drawableView.reAddSubView()//(secondView)を付加する
        drawableView.addSubview(drawableView.thirdView)//前フィルタ3rdViewを追加'170110変更（ダブリと思われるため）
        //インデックス情報を更新する
        let uNum = numOfUsedLine(pn:pageNum)//入力行最小値を取得
        indexImgs[pageNum - 1] = indexChange(pn: pageNum,usedNum:uNum )
        //indexリストに対象の頁番号を登録する(登録済頁だけがタッチ反応する）
        mx[String(pageNum)] = 1
        
        //非空白行の最上値
        print("numOfUsedLine:\(numOfUsedLine(pn:pageNum))")
        //ペンモードの初期化
        penMode()//黒ペンモードにする

    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        print("cursolWFlag:\(cursolWFlag)")
        //---------- パレット編集時 ---------------------------
        if isEditMode == true{//パレットが表示されている場合
            //カーソルモードが選択された場合
            if editFlag == true{
                if cursolWFlag == true{
                //カーソル幅が狭い場合では🐞する
 
                    //カーソル画面を撤去する
                    drawableView.secondView.cursolView.removeFromSuperview()
                    drawableView.thirdView.removeFromSuperview()
                
                    //編集結果画面を取得する
                    var editedView:UIImage!
                    if myInt == "CLR"{
                       editedView = UIImage(named:"blankW.png")
                        
                        //mx[]を更新する(0にリセット)
                        mx[String(nowGyouNo)] = 0
                        mxTemp = 0//ペンタッチ時に上書きしています為これもリセット
                      
                    }else{
                       editedView = drawableView.secondView.editPallete(sel: myInt)
                    }
                    //編集結果画面をパレットに反映させる
                    //カーソルを削除する
                    drawableView.secondView.cursolView.removeFromSuperview()
                    //画面をグリーン色にする
                    drawableView.addSubview(drawableView.thirdView)
                    //secondViewの背景を透明にする
                    drawableView.secondView.backgroundColor = UIColor.clear
                    //編集結果をパレットviewの背景に入れ替える
                    drawableView.backgroundColor = UIColor(patternImage: editedView)
                    
                    //パレット入力状態のリセット
                    editFlag = false;myInt = "NON"
                    drawableView.lastDrawImage = nil
                    //編集画面を閉じる
                    closeEditView()
                    // okボタンを押す：パレット内容をメモに移す
                    //done(done2)
                    upToMemo()//パレット内容をメモに移す
                    //◆◆◆◆
                    drawableView.get1VImage()
                }else{
                    print("カーソル巾がゼロです")
                    //カーソルを削除する
                    drawableView.secondView.cursolView.removeFromSuperview()
                    //編集画面を閉じる
                    closeEditView()
                    
                }
                
            /** パレット入力時における処理 **/
            }else{
            
              //編集画面表示中で編集モードが選択されていない場合はパス
              if myEditFlag == true && editFlag == false{return}
              upToMemo()//パレット画面をメモ行にコピーする
              //◆◆◆◆
              drawableView.get1VImage()
            }
            
        // == debug2 ==========================================================
          if debug2 == true{//@@ DEBUG2 @@
            testV.removeFromSuperview()
            drawableView.addSubview(testV)
            testV.layer.position = CGPoint(x: mxTemp, y:vHeight/2 )
          }
        // =====================================================================
            
        }
         print("*mx[\(pageNum)]= \(mx["Sring(pageNum)!"])")//@@@@  @@@@@
    }

    @IBAction func zoom(_ sender: UIBarButtonItem) {
        print("◆◆◆◆")
        if drawableView.undoMode != 8{return}
        let im0 = drawableView.bup["2"]?.0
        drawableView.secondView.backgroundColor = UIColor(patternImage: im0!)
    }
    
    @IBAction func redo(_ sender: UIBarButtonItem) {
        print("@@ undo @@")
        print("◆◆◆◆undoFLG:\(drawableView.undoMode)")
        if drawableView.undoMode == 0{return}
        //if drawableView.undoMode == 1{return}
        //if drawableView.undoMode == 8{return}
        if drawableView.bup["0"] == nil{return}
        
        drawableView.undo()
        /*
        let im0 = drawableView.bup["0"]?.0
        drawableView.secondView.backgroundColor = UIColor(patternImage: im0!)
        drawableView.lastDrawImage = im0
        drawableView.undoMode = 8
        */

    }
//=================================================================
//                        その他の関数
//=================================================================
    
    //メモのスクロール位置を設定する
    func scrollPos(){
    //現在のタグ行がスクロール窓から隠れているかをチェック
        
          //print("スクロール窓の高さ:\(scrollRect_P.height)")
          //print("何行目?:\(nowGyouNo%100)")
          //print("オフセット：\(myScrollView.contentOffset)")
        let os:CGPoint = myScrollView.contentOffset
        let iti = topOffset + CGFloat(leafHeight + leafMargin)*CGFloat(nowGyouNo%100) - os.y //print("タグ行の下線の位置:\(iti)")
        //スクロール量を計算する
        let maxIti = scrollRect_P.height - myEditView.frame.height//スクロール可否の閾値
        let saIti = iti - maxIti
        if iti > maxIti{
            UIScrollView.animate(withDuration: 0.3, animations: {
                () -> Void in
                self.myScrollView.contentOffset = CGPoint(x:0,y:os.y + saIti)
            })
           
        }

    }
    
    //上下barView,スペーサー等の表示／非表示
    func etcBarDisp(disp:Int){
        if disp == 1 {
            self.view.addSubview(underView)
            self.view.addSubview(upperView)
            //self.view.addSubview(myToolView)
            self.view.addSubview(spaceView1)
            self.view.addSubview(spaceView2)
        }else if disp == 0{
            underView.removeFromSuperview()
            upperView.removeFromSuperview()
            //myToolView.removeFromSuperview()
            if myEditView != nil{
                myEditView.removeFromSuperview()
                spaceView1.removeFromSuperview()
                spaceView2.removeFromSuperview()
            }
        }
    }
    
    /* ----- セルの長押し処理:長押しイベント処理 ----- */
    
    func longPress(){
        print("longPush")
        if myScrollView.isLongPushed == false{//チャタリング防止作
            // ** [INDEXページ] **
            if isIndexMode == true{
              //登録されてない頁番号の場合は、パスする
                //let shou:Int = nowGyouNo
                //空ページの場合は処理しない
                if mx[String(nowGyouNo)] == 0{return}//mx[1〜30]は空フラグとして使用
                if Double(mx[String(nowGyouNo)]!) > 30{return}//念のため：ダメな対応
              //飛び先ページを指定
                //-------
                let nextNum = nowGyouNo//myScrollView.selectedTag//タッチしたtag番号:0ページの為tag番号（一桁）がページ番号を現す。
                print("===========\(nextNum)====================")
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
            //メモページの場合
              //仮想的にeditボタンを押す
              let nextNum = nowGyouNo//myScrollView.selectedTag//タッチしたtag番号
              self.Pallete(self.pallete2)//パレットを開く
              print("isEdit: \(isEditMode)")
              self.modalChanged(TouchNumber:nextNum!)//セルを選択
              memo[fNum].togglleCursol()
            }
        }
        myScrollView.isLongPushed = true//touchBeginsでfalseにリセットする
    }

  /* --------------　外部データ入出力関係　----------------------- */
    
    //外部のページデータを読み込む: photos”pn”[] ->[UIImage]
  
    func readPage(pn:Int)->[UIImage]{
        let retImgs = reloadToPage2(pn:pn)//UserDataをpageImmgs[]に読み込む
        if retImgs.count > 0{ return retImgs }
        else{ //外部データが無い場合は空白の目ページImgsを作成する
            let bImage:UIImage = UIImage(named: "blankW.png")!//⬅4545.png
            let blankImgs:[UIImage] = Array(repeating: bImage, count: pageGyou)
            return blankImgs
        }
    }
    
    ///UserDwfaultに保存のメモ画像をpageImgs:[]に読み込む
    func reloadToPage2(pn:Int)->[UIImage] {
        var imgs:[UIImage] = []
        let photoData = UserDefaults.standard
        // [UIImage] → [NSData]
        photoData.synchronize()
        
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
        photoData.synchronize()//必要かどうか？あると遅くなるのか？
    }
    
    //外部のページデータを削除する(all:0の場合は全削除）
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
 

  /* --------------　Index情報の更新プログラム　----------------------- */
    
    //palleteのdone実行時にページデータからIndex内容を更新する
    func indexChange(pn:Int,usedNum:Int)-> UIImage{

        //新しくコンテナView１つと3つのImageViewを作る
        var indexFView:UIView!
        var img01:UIImageView!
        var img02:UIImageView!
        var cont02:UIView!//img02を入れる箱View
        var img03:UIImageView!
        
        indexFView = UIView(frame: CGRect(x:5,y: 210,width:leafWidth,height:leafHeight))
        img01 = UIImageView(frame:CGRect(x:0,y:0,width:20,height:leafHeight))
        img02 = UIImageView(frame:CGRect(x:leafHeight*1/3,y:0 + 2,width:leafWidth - 3*leafHeight
            ,height:leafHeight - 10))
        cont02 = UIView(frame:CGRect(x:leafHeight*2/3,y:0 + 2,width:leafWidth - 2*leafHeight - 4 - 3
            ,height:leafHeight - 4))
        img03 = UIImageView(frame:CGRect(x:leafWidth - leafHeight*4/3 + 2,y:0,width:leafHeight*4/3 - 8,height:leafHeight))
        //枠線,色,角丸
        img01.layer.borderWidth = 1
        img01.layer.borderColor = UIColor.clear.cgColor
        img01.layer.cornerRadius = 1
        cont02.layer.borderWidth = 3
        cont02.layer.borderColor = UIColor.purple.withAlphaComponent(0.1).cgColor
        cont02.layer.cornerRadius = 10
        cont02.layer.masksToBounds = true
        
        img03.layer.borderWidth = 1
        img03.layer.borderColor = UIColor.white.cgColor
        img03.layer.cornerRadius = 20

        img01.backgroundColor = UIColor.clear
        cont02.backgroundColor = UIColor.white//purple.withAlphaComponent(0.1)
        img03.backgroundColor = UIColor.purple.withAlphaComponent(0.1)
        
        //Viewの内容を作成
        //パレット全画面の切り取り????
        let tag:Int = pn*100 + usedNum
        let rt = CGFloat(retina)
        let targetIV = memo[fNum].viewWithTag(tag) as! UIImageView
        let tImage = targetIV.image
        //ピクセル画像のサイズ
        let pixWidth:CGFloat = leafWidth! * rt
        let pixHeight:CGFloat = leafHeight * rt
        //切り取りサイズ
        let clip02 = CGRect(x:5,y:0,width: pixWidth - pixHeight,height: pixHeight)
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
        img01.backgroundColor = UIColor.white
        indexFView.removeFromSuperview()

        //indexFView.addSubview(img01)
        cont02.addSubview(img02)
        indexFView.addSubview(cont02)
        indexFView.addSubview(img03)
        //self.view.addSubview(indexFView)
        
        indexFView.backgroundColor =
            UIColor.clear
        //日付を追加する
        let compY = Calendar.Component.year
        let compM = Calendar.Component.month
        let compD = Calendar.Component.day
        
        let y = NSCalendar.current.component(compY, from: Date() as Date)
        let y2 = y - 2000
        let m = NSCalendar.current.component(compM, from: Date() as Date)
        let d = NSCalendar.current.component(compD, from: Date() as Date)
        //let st = String(format: " %4d-\n %2d-%2d",y,m,d)
         //デバグ用　m = 12;d = 15;
        let st = String(format: " %2d/%2d\n    '%2d",m,d,y2)
        print(st)
        print("\(y)\n\(m)/\(d)")// 1が日曜日 7が土曜日
       
        //画面全体をイメージ化する
         let orgImage = indexFView.GetImage()
        return orgImage.addIndexText(text:st,rect:img03.frame.offsetBy(dx: 4, dy: 2))
 
    }
 
   /* -------------------　mx[]更新関係　---------------------------- */
    
    ///該当するページのmx[]値をリセットする
    func xxclearMx(pn:Int){
        for n in 0..<pageGyou{
            let tg = pn*100 + n + 1
            mx[String(tg)] = 0
        }
    }
    /*該当ページのmx[]値を配列mxs[]に保存する。？↖と同じ？
    func wrightMx(pn:Int){
        for n in 0..<pageGyou{
            let tg = pn*100 + n + 1
            mx[String(tg)] = 0
        }
    }*/

    //対象ページの非空白行のうち一番小さい行番号を返す
    func numOfUsedLine(pn:Int)->Int{
        
        var ret:Int = 1
        var tg:Int = 101
        print("aaa")

          for i in 0..<pageGyou {
            tg = pn*100 + (pageGyou - i)
            if Int(mx[String(tg)]!)>50{
                ret = pageGyou - i
            }
          }
        return ret
    }
    
    func loadMx()->[String:CGFloat]{
        //Dictionary型のデータの読込
        var img:[String:CGFloat] = mx 
        let photoData = UserDefaults.standard
        photoData.synchronize()
        let photosName:String = "index"//保存名
        //NSData から画像配列を取得する
        print("aa aa")
        if photoData.dictionary(forKey: photosName) != nil{
            img = photoData.dictionary(forKey: photosName) as! [String : CGFloat]
         print("bb bb")
        }else{
            print("cc cc")
            //mx[]の初期化
            for p in 1...30{
                for g in 0...30{
                    let s = String(p*100 + g)
                    img[s] = 0
                }
            }
            //mx[]にindexリストを追加する[1:0,2:0…]:[頁No:使用時は1]
            for p in 1...30{
                let s = String(p)
                img[s] = 0
            }
            
        }
        return img
    }
    
    func updataMx(my:[String:CGFloat]){
        //Dictionary型のデータを保存
        let photoData: UserDefaults = UserDefaults.standard
        let photosName:String = "index" //保存名を決定
        let dataImg:[String:CGFloat] = my
        photoData.set(dataImg, forKey: photosName)
        photoData.synchronize()
    }
    
   /* ---------------　リストメニューtableView関連　------------------　*/
    
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
    func fc2(){
        print("test2!!!!!")
        //現行ベージの内容を削除する
        delPage(pn: pageNum)
        let im = readPage(pn:pageNum)//現在ページの外部データを読み込む
        memo[fNum].setMemoFromImgs(pn:pageNum,imgs:im)
        //indexから削除する
        indexImgs[pageNum - 1] = UIImage(named:"blankW.png")!
        //INDEX内容を外部に保存
        writePage(pn:0, imgs:indexImgs)
        //indexリストを更新する
        mx[String(pageNum)] = 0
    
    }
    func fc3(){
        print("test3!!!!!")
        // 指定キー"index"の値のみを削除
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: "index")
    }
    func fc5(){print("test5!!!!!")}
    func fc6(){
        print("test6!!!!!")
        //現行ベージの内容を削除する
        delPage(pn: pageNum)
        let im = readPage(pn:pageNum)//現在ページの外部データを読み込む
        memo[fNum].setMemoFromImgs(pn:pageNum,imgs:im)

        delPage(pn: 0)//全ページ削除する
    }
    
   /* ----------------------　ボタン関数　-----------------------------*/
    
    //エディット画面を非表示にする
    func closeEditView(){
        if myEditFlag == false { return }
        editButton1.backgroundColor = UIColor.clear
        //editButton1.setTitle("💠", for: UIControlState.normal)
        editButton1.setImage(UIImage(named: "red3.png"), for:UIControlState.normal)
        myEditView.removeFromSuperview()
        drawableView.secondView.cursolView.removeFromSuperview()
        myEditFlag = false; editFlag = false
        drawableView.secondView.isUserInteractionEnabled = false
        penMode()//ペンモードに戻す
    }///
    func btn1_click(sender:UIButton){
        print("** btn1_click()")
        if myEditFlag == false{//エディット画面を表示する
            done(done2)// okボタンを押す
            clearSelect()//編集ツールを非選択状態にする
            editButton1.backgroundColor = UIColor.clear
            //editButton1.setTitle("⬇", for: UIControlState.normal)
            editButton1.setImage(UIImage(named: "green3a.png"), for:UIControlState.normal)
            
            self.view.addSubview(myEditView)
            myEditFlag = true; editFlag = false//前者:エディット画面,後者:エディットモード
            //パレット画面のイベントの非透過
            drawableView.secondView.isUserInteractionEnabled = true
            //パレットボタンをリセットする
            editButton2.backgroundColor = UIColor.init(white: 0.75, alpha: 0)
            editButton3.backgroundColor = UIColor.init(white: 0.75, alpha: 0)
            editButton4.backgroundColor = UIColor.init(white: 0.75, alpha: 0)
            //◆◆◆◆
            drawableView.get1VImage()
        }else{//エディット画面を非表示にする
            closeEditView()
            
        }
    }
    
    func btn2_click(sender:UIButton){
        closeEditView()//パレット編集画面を閉じる
        print("btn2_clicked!：ペン色切り替え")
        if myEditFlag == true{return}//編集画面が表示の場合はパス
        if drawableView.X_color == 1{return}//ペンモード以外はパス
        if penColorNum == 1 {
            penColorNum = 2
            editButton2.setImage(UIImage(named: "ハート.png"), for:UIControlState.normal)
        }else if penColorNum == 2{
            penColorNum = 3
            editButton2.setImage(UIImage(named: "三つ葉.png"), for:UIControlState.normal)
        }else{
            penColorNum = 1
            editButton2.setImage(UIImage(named: "スペード.png"), for:UIControlState.normal)
        }
    }
    
    func penMode(){
        //if myEditFlag == true{return}//編集画面が表示の場合はパス
        closeEditView()//パレット編集画面を閉じる
        drawableView.X_color = 0//ペンモード[黒色、赤色、青色]
        penColorNum = 1//黒色
        editButton2.setImage(UIImage(named: "スペード.png"), for:UIControlState.normal)
        editButton3.backgroundColor = UIColor.init(white: 0.5, alpha: 1)
        editButton4.backgroundColor = UIColor.init(white: 0.75, alpha: 0)
    }///
    func btn3_click(sender:UIButton){
        print("btn3_clicked!：ペンモード")
        closeEditView()//パレット編集画面を閉じる
        penMode()
    }
    
    func btn4_click(sender:UIButton){
        print("btn4_clicked!:消しゴム")
        //if myEditFlag == true{return}//編集画面が表示の場合はパス
        closeEditView()//パレット編集画面を閉じる
        drawableView.X_color = 1//消しゴムモード
        editButton2.setImage(UIImage(named: "ダイヤ２.png"), for:UIControlState.normal)
        editButton4.backgroundColor = UIColor.init(white: 0.9, alpha: 1)
        editButton3.backgroundColor = UIColor.init(white: 0.75, alpha: 0)
    }
    
    func editorModeStart(){
        //secondViewをタッチ可能とするための処理：最上位のビューしか変更できな為
        drawableView.bringSubview(toFront: drawableView.secondView)
        drawableView.secondView.isUserInteractionEnabled = true
    }
    
    //func editorModeEnd(){}
    
    func clearSelect(){//選択状態を全て元に戻す
        editButton5.backgroundColor = UIColor.clear
        editButton6.backgroundColor = UIColor.clear
        editButton7.backgroundColor = UIColor.clear
        editButton8.backgroundColor = UIColor.clear
    }
    
    func btn5_click(sender:UIButton){
        print("btn5_clicked!")
        myInt = "OVW"//overwrite
        editFlag = true
        clearSelect()
        editButton5.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        drawableView.secondView.cursolView.removeFromSuperview()
        drawableView.secondView.setMyCursolView()
        editorModeStart()
    }
    func btn6_click(sender:UIButton){
        print("btn6_clicked!")
        myInt = "INS"//ins
        editFlag = true
        clearSelect()
        editButton6.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        drawableView.secondView.cursolView.removeFromSuperview()
        drawableView.secondView.setMyCursolView()
        editorModeStart()
    }
    
    func btn7_click(sender:UIButton){
        print("btn7_clicked!")
        myInt = "DEL"//del
        editFlag = true
        clearSelect()
        editButton7.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        drawableView.secondView.cursolView.removeFromSuperview()
        drawableView.secondView.setMyCursolView()
        editorModeStart()
    }

    
    func btn8_click(sender:UIButton){
        print("btn8_clicked!")
        myInt = "CLR"
        clearSelect()
        editButton8.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        drawableView.secondView.cursolView.removeFromSuperview()
        drawableView.secondView.setMyCursolView()
        editorModeStart()
        cursolWFlag = true //カーソル幅が狭いと🐞される事への対策
        editFlag = true //カーソルモードが選択されたモードに設定する
    }
    
    func btn9_click(sender:UIButton){
        print("btn9_clicked!")
       
        if editFlag == true && cursolWFlag == true{
           //カーソル表示変更
            let cStart:CGFloat = drawableView.secondView.cursolStartX
            let cEnd:CGFloat = 0
            drawableView.secondView.cursolEndX = cEnd
            drawableView.secondView.changeMyCursolView2(curX: cEnd, startX:cStart)
           
        }else{
        //パレットの表示位置をリセットする
            //アニメーション動作をさせる
            UIView.animate(withDuration: 0.3, animations: {
            () -> Void in
            drawableView.layer.position = CGPoint(x:vWidth/2, y:boundHeight - 44 - vHeight/2)
            })
        }
    }
    
    func btn10_click(sender:UIButton){
        print("btn10_clicked!")
        if editFlag == true && cursolWFlag == true{
            //カーソル表示変更
            let cStart:CGFloat = drawableView.secondView.cursolStartX
            let cEnd:CGFloat = mx[String(nowGyouNo)]! + 5//線幅があるのて少し余分に
            drawableView.secondView.cursolEndX = cEnd
            drawableView.secondView.changeMyCursolView2(curX: cEnd, startX:cStart)
            if mx[String(nowGyouNo)]! >= (vWidth - 10){//現行のmaxXが右いっぱいの場合
                if myInt == "INS"{
                   cursolWFlag = false
                }
            }
            
        }else{
        //パレットの表示位置を末尾にする
            UIView.animate(withDuration: 0.3, animations: {
            () -> Void in
            drawableView.layer.position = CGPoint(x:boundWidth - vWidth/2, y:boundHeight - 44 - vHeight/2)
          })
        }
 
    }
    
    
   /* -------------------　スワイプ関数　---------------------------- */
    
    func swipeR(){
        if isIndexMode! { return }//Indexが表示中は実行しない
        if isEditMode! { return }//パレットが表示中は実行しない
        if pageNum == 1{ return }//１ページが最終ページ
        
        for n in 0...2{//ボーダーラインを付ける(ページめくりの時の枠）
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
        //nowGyouNoの更新
        nowGyouNo = pageNum * 100 + 1
        
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
        //nowGyouNoの更新
        nowGyouNo = pageNum * 100 + 1
    }
  
   /* -------------------　プロトコル関数　-----------------------------*/
    
    func modalChanged(TouchNumber: Int) {// protocol ScrollViewDelegate
        print("TouchNumber:@\(TouchNumber)")
        print("fNum:\(fNum)")
            nowGyouNo = TouchNumber
            print("nowGyouNo?: \(nowGyouNo)")
        
        //対象行のTag番号のleafViewのmaxPosXをmxTempにコピーする。
        //但し、INDEXページではmx[1〜30]はページ登録フラグとして使用している為↓
        //Indexページでもmx[]を使用する
           mxTemp = mx[String(nowGyouNo)]

        //パレット編集ツールを閉じる
        if myEditFlag == true{ closeEditView()}

        //パレット表示中
        if isEditMode == true{
           //メモのスクロール位置を設定する
            scrollPos()
                
           //メモに書き出した内容をパレットに読み込む//20161024追加
            let myMemo:UIImage = memo[fNum].readMemo(tag: nowGyouNo)
           //表示中のフレーム番号
           //let fn = Int(myScrollView.contentOffset.x/leafWidth) + 1
            memo[fNum].selectedNo(tagN: nowGyouNo)
           //パレットの表示位置をリセットする
            drawableView.layer.position = CGPoint(x:vWidth/2, y:boundHeight - 44 - vHeight/2)

           //パレット表示用にリサイズする(extension)
            //====================================================
                let reSize = CGSize(width: vWidth, height: vHeight)
                let reMemo = myMemo.resize(size: reSize)
            //====================================================

            drawableView.backgroundColor = UIColor(patternImage: reMemo)
            //◆◆◆◆
            drawableView.get1VImage()//パレット画面を保存する
            
            drawableView.lastDrawImage = nil//21061213に追加
            drawableView.secondView.backgroundColor = UIColor.clear
            //UNDO関連の初期化
            drawableView.resetUndo()
            
        }else if isIndexMode == true{
        //パレット非表示の場合
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
    func shiftMX(){
        done(done2)// okボタンを押す
    }

    
  //----------------------------------------------------------------
  //                  旧ボタン関数(未使用）                             |
  //----------------------------------------------------------------
    
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
//-----------------------------------------------------------------------------

}
