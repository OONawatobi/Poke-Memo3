//
//  ViewController.swift
//  Poke Memo⇒　E.T.Memo Happy Memo,Leaf Memo ⇒ Happy Note( Ver2)
//  now:20181008
//  Created by 青山 行夫 on 2016/11/23.
//  Copyright © 2016年 mm289. All rights reserved.
// 20161213

import UIKit

enum DashedLineType {
    case All,Top,Down,Right,Left
}

extension UIColor {
    class func rgb(r: Int, g: Int, b: Int, alpha: CGFloat) -> UIColor{
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    }
}

extension UIView {
    @discardableResult//返り値を使わないことを許可する
    func drawDashedLine(color: UIColor, lineWidth: CGFloat, lineSize: NSNumber, spaceSize: NSNumber, type: DashedLineType) -> UIView {
        let dashedLineLayer: CAShapeLayer = CAShapeLayer()
        dashedLineLayer.frame = self.bounds
        dashedLineLayer.strokeColor = color.cgColor
        dashedLineLayer.lineWidth = 1.0//lineWidth
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
    //20180812作成
    @discardableResult
    func addCursolLine(color: UIColor, lineWidth: CGFloat, lineSize: NSNumber, spaceSize: NSNumber,posX:CGFloat,lenX:CGFloat) -> UIView {
        self.layer.sublayers = nil//既存の下線を削除する
        //**破線を引く**
        let dashedLineLayer: CAShapeLayer = CAShapeLayer()
        dashedLineLayer.frame = self.bounds
        dashedLineLayer.strokeColor = UIColor.gray.cgColor
        dashedLineLayer.lineWidth = 1.0//lineWidth
        dashedLineLayer.lineDashPattern = [lineSize, spaceSize]
        let path: CGMutablePath = CGMutablePath()
        //case .Down:
        path.move(to: CGPoint(x: 0, y: self.frame.size.height))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        dashedLineLayer.path = path
        self.layer.addSublayer(dashedLineLayer)
        if lenX != 0{  //lineWidth==0の場合はカーソルだけ削除する
        //**カーソル線を引く**
        let cursolLayer = CALayer()
        cursolLayer.backgroundColor = color.cgColor
        cursolLayer.frame = CGRect(x:posX, y:self.frame.size.height - lineWidth,width:lenX, height:lineWidth)

        self.layer.addSublayer(cursolLayer)
        }
        return self
    }

    //20180813作成:下線が実践の場合
    @discardableResult
    func addCursolLine2(color: UIColor, lineWidth: CGFloat, lineSize: NSNumber, spaceSize: NSNumber,posX:CGFloat,lenX:CGFloat) -> UIView {
        self.layer.sublayers = nil//既存の下線を削除する
        //**実線を引く**
        let border = CALayer()
        border.backgroundColor = UIColor.gray.cgColor
        border.frame = CGRect(x:0, y:self.frame.size.height - 1.5,width:
            self.frame.size.width, height:1.5)
        self.layer.addSublayer(border)
        
        if lenX != 0{  //lineWidth==0の場合はカーソルだけ削除する
            //**カーソル線を引く**
            let cursolLayer = CALayer()
            cursolLayer.backgroundColor = color.cgColor
            cursolLayer.frame = CGRect(x:posX, y:self.frame.size.height - lineWidth,width:lenX, height:lineWidth)
            
            self.layer.addSublayer(cursolLayer)
        }
        return self
    }
    //20180815作成:下線が実践の場合(子メモ用）
    @discardableResult
    func addLineForChild(color: UIColor, lineWidth: CGFloat,posX:CGFloat,lenX:CGFloat,spaceX:CGFloat) -> UIView {
        self.layer.sublayers = nil//既存の下線を削除する
        //**実線を引く**
        let border = CALayer()
        border.backgroundColor = UIColor.red.withAlphaComponent(0.5).cgColor
        border.frame = CGRect(x:spaceX, y:self.frame.size.height - 1.0,width:
            self.frame.size.width - spaceX*2, height:0.5)
        self.layer.addSublayer(border)
        
        if lenX != 0{  //lineWidth==0の場合はカーソルだけ削除する
            //**カーソル線を引く**
            let cursolLayer = CALayer()
            cursolLayer.backgroundColor = color.cgColor
            cursolLayer.frame = CGRect(x:posX, y:self.frame.size.height - lineWidth,width:lenX, height:lineWidth)
            
            self.layer.addSublayer(cursolLayer)
        }
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
    func GetImage(rect:CGRect) -> UIImage{
        // キャプチャする範囲を取得.
        //let rect = self.bounds
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
        border2.frame = CGRect(x:self.frame.size.width - 2.5*width, y:0,width:2.5*width,
                               height:self.frame.size.height)//+-+-
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
    public func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:width/2,width:
            self.frame.size.width, height:width)
        self.layer.addSublayer(border)
    }
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        
        self.layer.mask = maskLayer
    }
/*
    public func changeBottomBorder(color: UIColor, width: CGFloat) {
        self.layer.sublayers = nil
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:self.frame.size.height - width,width:
            self.frame.size.width,height:width)
        self.layer.addSublayer(border)
    }
*/
}
extension UIImage {
        
    // 画質を担保したままResizeするクラスメソッド.
    func ResizeUIImage(width : CGFloat, height : CGFloat)-> UIImage!{
            
        let size = CGSize(width: width, height: height)
            
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        //var context = UIGraphicsGetCurrentContext()
            
        self.draw(in: CGRect(x:0,y:0,width:width,height:height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
 //resize2に変更
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
    //retina対応
    func resize2(size: CGSize)-> UIImage!{
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(x:0,y:0,width:size.width,height:size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    //テスト用
    func resize3(size: CGSize)-> UIImage!{
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        self.draw(in: CGRect(x:0,y:0,width:size.width,height:size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    
    func addText(text:String)-> UIImage{
        let text = text
        let font = UIFont.boldSystemFont(ofSize: 16)
        let imageRect = CGRect(x:0,y:0,width:self.size.width,height:self.size.height)

        //qUIGraphicsBeginImageContext(self.size);
        UIGraphicsBeginImageContextWithOptions(self.size,false,0.0)
        self.draw(in: imageRect)
        
        let textRect  = CGRect(x:15, y:15, width:self.size.width - 5, height:self.size.height - 5)
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
    //メモ行の末尾に日付を追加する関数
    func addText_Date(text:String)-> UIImage{
        let text = text
        var font = UIFont.boldSystemFont(ofSize: 24)
        let font2 = UIFont.boldSystemFont(ofSize: 72)
        
        let imageRect = CGRect(x:0,y:0,width:self.size.width,height:self.size.height)
        //UIGraphicsBeginImageContext(self.size)
        UIGraphicsBeginImageContextWithOptions(self.size,false,0.0)
        self.draw(in: imageRect)
        var textRect  = CGRect(x:self.size.width - 130, y:0, width:108, height:self.size.height - 30)
        let textRect2  = CGRect(x:self.size.width - 390, y:0, width:324, height:self.size.height - 90)
        //メモ画面のサイズに応じて日付位置と文字サイズを切り替える
        if self.size.height > vHeight/2{
            font = font2
            textRect = textRect2
        }
        
        let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        let textFontAttributes = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: UIColor.gray,
            NSParagraphStyleAttributeName: textStyle
        ]
        //くり抜き?日付エリアを透明にする
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.clear(textRect)
        //日付を追加する
        text.draw(in: textRect, withAttributes: textFontAttributes)
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        return newImage!
    }
    //メモ行の末尾にマークを追加する関数
    func addText_Mark(text:String,del:Bool)-> UIImage{
        let text = text
        var font = UIFont.boldSystemFont(ofSize: 18)//24
        let font2 = UIFont.boldSystemFont(ofSize: 54)//72
        
        let imageRect = CGRect(x:0,y:0,width:self.size.width,height:self.size.height)
        UIGraphicsBeginImageContextWithOptions(self.size,false,0.0)
        self.draw(in: imageRect)
        var textRect  = CGRect(x:self.size.width - 15, y:self.size.height/4, width:25, height:self.size.height/2)
        let textRect2  = CGRect(x:self.size.width - 45, y:self.size.height/4, width:75, height:self.size.height/2)
        //+-+-let textRect2  = CGRect(x:self.size.width - 60 - 15, y:self.size.height/4, width:75, height:self.size.height/2)
        //メモ画面のサイズに応じて文字サイズを切り替える//?何をしてるの、必要？★
        if self.size.height > vHeight/2{
            font = font2
            textRect = textRect2
        }
        
        let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        let textFontAttributes = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: UIColor.magenta.withAlphaComponent(1.0) ,
            NSParagraphStyleAttributeName: textStyle
        ]
        if del == true{
            //くり抜き?エリアを透明にする
            let context: CGContext = UIGraphicsGetCurrentContext()!
            context.clear(textRect)
        }else{
            //くり抜き?エリアを透明にする
            let context: CGContext = UIGraphicsGetCurrentContext()!
            context.clear(textRect)
            //マークを追加する
            text.draw(in: textRect, withAttributes: textFontAttributes)
        }
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func addIndexText(text:String,rect:CGRect)-> UIImage{
        let text = text
        let font = UIFont.boldSystemFont(ofSize: 16)
        let imageRect = CGRect(x:0,y:0,width:self.size.width,height:self.size.height)

        //UIGraphicsBeginImageContext(self.size);
        UIGraphicsBeginImageContextWithOptions(self.size,false,0.0)
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
var statusView:UIView!//landscape画面のstatusbarに青色をカバーする
var jinesView:UIView!//landscape画面のジンズ生地
var jinesH:CGFloat = 0//jinesViewの高さ
var shadow:UIView!//landscape画面のメモもの右側につける影
var boundWidthX:CGFloat!//デバイス画面の水平方向の幅（方向によって変化する）
var leftEndPoint:CGPoint = CGPoint(x:0,y:0)
var didLoadFlg = false//_portlaitモードで起動する為のフラグ
var deviceO:Int = 1//_デバイスの回転方向(1-4)
var gardClrFlg = true//パレット上下のガードの色をつける（緑色）
var callig = false//カリグラフィモード時：true
var th:CGFloat = 46//ツールバーの高さ 20180720本当は"46"
var subMemoView:UIView!//+-+- 子メモの入るエリア
var subMemo:MemoView! = nil//+-+-子メモ本体
var posOffset:CGFloat = 50//+-+-　上記エリアの縦位置
var childFlag = false//+-+- 子メモが開いている時はtrue
var oyaGyou:Int = 101//メモページの親行番号
//let childColor = UIColor.rgb(r: 250, g: 230, b: 240, alpha: 1)
let childColor = UIColor.rgb(r: 253, g: 250, b: 228, alpha: 1)//255,252,244:薄薄黄色
//252,249,227:薄黄色//255,242,244:薄赤紫//255,247,217:indexカーソルの色
var testV:UIView!//デバグ用：mx[]位置を表示する。、赤色
var debug1:Bool = false//デバグ用：ページタグ表示
var debug2:Bool = false//デバグ用：mx[]表示
let boundWidth = UIScreen.main.bounds.size.width
var boundHeight = UIScreen.main.bounds.size.height
//var retina:Int = 2//レティナディスプレイ対応
let retina:Int = Int(UIScreen.main.scale)//レティナ分解能の抽出
var infoPage:[(memoNo:Int,gyou:Int,maxUsingGyouNo:Int)]!//未使用
var isPalleteMode:Bool! = false//パレットが表示されている場合：true
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
let maxPageNum:Int = 30//未使用
var pageGyou:Int = 32//メモページの行数
var pageGyou2:Int = 8//子メモページの行数
var nowGyouNo:Int! = 1//編集中の行番号(tag番号）
//var lastGyouNo:Int! = 1//直前の行番号(tag番号）20180812追加-不要
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
let vHeight: CGFloat = leafHeight*4 //180 //手書きビューの高さ@@@@@@@@
var vWidth:CGFloat! = leafWidth*4 //(vHeight/leafHeight)
var maxPosX:CGFloat! = 0//描画したｘ座標の最大値
var mx = [String: CGFloat]()//[Tag番号:maxPosX]
//var mxs:[[String: CGFloat]] = [[:]]//mxs.count = 30
var mxTemp:CGFloat!//mxの一時保存（メモに書き出すときにmxにコピーする）
var resn = [String:Int]()//+-+ [Tag番号:リサイズ回数]
var m2pFlag = false//+-+ メモ行をパレットに呼び込むとtrue-2回目以後はfalse
var bigFlag = false//パレット拡大時：(true)
let big:CGFloat = 1.5//拡大率
//var maxPosX = [[CGFloat]]()
//var maxPosX:CGFloat!  = [[Int]](count: 30,repeatedValue: [Int](count: 30,repeatedValue: 0))

var lineWidth:Int = 1//線幅[0:thin,1:normal,2:thic]
var lineColor:Int = 0//三番目の線色[0:blue,1:green,2:purple]
var autoScrollFlag = true//自動スクロールOn/Offフラグ
var myLabel:UILabel!//自動スクロールOn/Off表示用
var lastPage:Int = 1//最後に編集したたページ番号
var bImage:UIImage!//ブランク画像
var helpView: HelpView! = nil//ヘルプ画面
var helpFrame = UIView(frame: CGRect(x:0,y:0,width:boundWidth,height:boundHeight))
//X:iPhoneX---
  var iphoneX:Bool = false//iPhoneXかどうかの判定フラグ
  var sBarX:CGFloat = 0//ステータスバーの高さの変化量(20<->44)

var okEnable:Bool = true//OKボタンを受け付けるフラグ
//------------------------------------------------------------------------

protocol ScrollView2Delegate{//スクロールビューの操作(機能）
    func modalChanged(TouchNumber: Int)
    //func show_4thFrame()
    //func scrollViewWillBeginDragging(scrollView: UIScrollView)
}

protocol UpperToolViewDelegate{//upperビューの操作(機能）
    func dispPosChange(midX: CGFloat,deltaX:CGFloat)
    func ok2()
}

protocol DrawableViewDelegate{//パレットビューの操作(機能）
    func selectNextGyou()
    func shiftMX()
    func upToMemo()
    func ok2()
}


//    =======  ViewController    ========

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,ScrollView2Delegate,UpperToolViewDelegate,DrawableViewDelegate, UIWebViewDelegate{
    
    //ステータスバーを非表示にする
    //override var prefersStatusBarHidden: Bool { return true }
    //ステータスバーの文字色を白色にする
    //override var preferredStatusBarStyle:UIStatusBarStyle {return UIStatusBarStyle.lightContent}
    
    //var indexFView:UIView!//インデックスメニュー作成評価用
    var rotMode:Int = 1
    var shortToolBar: UIView!//_横向き画面のツールバー
    var statusBarBackground:UIView!
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
    var scrollRect_B:CGRect!//パレットが拡大表示されている時の表示サイズ
    var scrollRect_T:CGRect!//toolbarが表示されている時の表示サイズ
    var scrollRect_I:CGRect!//Indexページが表示されている時の表示サイズ
    var svOffset:CGFloat = 0
    var isMenuMode:Bool! = false//リストメニューがの表示フラグ：true
    var setV:UIView!//設定画面の背景（半透明グレイ）
    var setV2:UIView!//設定画面
    var nColor:UIColor!//ナビゲーションバーの色
    var iColor:UIColor!//indexページのナビバーの色
    var iColor2:UIColor!//indexページのナビバーの下の色（項目バー）
    var helpTop:UIView!//ヘルプ画面topエリア
    var jButton:UIButton!//ヘルプ画面:日本語
    var eButton:UIButton!//ヘルプ画面:English
    var rButton:UIButton!//ヘルプ画面:[X]閉じる
    var langFlag:Int = 0//ヘルプ言語　0:日本語、1：英語
    var hl:UILabel!//ヘルプ画面のタイトル
    var numBar:UIView!//INDEXページの左端ライン
    var trf:Bool = false//WC：タイマーフラグ（ペンボタンのdouble-click対応）
    //var bView:UIView!//ブランクビュー
    //var setFlag:Bool = false
    //var isIndexMode:Bool! = false//Indexの表示フラグ：
    //var indexFlag:Bool! = false//Indexの表示フラグ：true
    //var reloadedImage:UIImage!//ファイルから読み込んだイメージ：未使用　下記使用
    var buttonOK:UIButton!//_shortToolBarのボタン
    var buttonZoom:UIButton!//_shortToolBarのボタン
    var buttonRedo:UIButton!//_shortToolBarのボタン
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
    var setButtonN:UIButton!//設定画面のキャンセルボタン
    var setButtonY:UIButton!//設定画面の決定ボタン
    var tempLineW:Int = 0//設定用線幅
    var tempColor:Int = 0//設定用線色
    var tempDelAll:Int = 0//削除フラグ：１で削除
    var tempAutoScroll = true//設定用(初期値：自動）
    
    /* --- リストメニュー --- */
    let ch:CGFloat = 40//セルの高さ
    let cn:Int = 8//リストの数
    let mw:CGFloat = 230//メニューリストの幅
    var mh:CGFloat = 300//メニューリストの高さ
    var mv:UIView!
    var smv:UIScrollView!//メニューリストテーブルを入れるスクロール箱
    var tV: UITableView  =   UITableView()//++テーブルビューインスタンス作成
    //++テーブルに表示するセル配列
    var items_Ja: [String] = ["","日付を追加", "表示ページをクリア", "JPEGファイルで出力","　","各種設定","スタートガイドを見る","                ▲ "]
    var items_En: [String] = ["","Add date", "Clear display page", "Export as JPEG file","　","Settings","Watch the Start-Guide","                ▲ "]
    var items:[String] = []
    var titleV:UIImageView!//indexページのタイトル
    var tl: UILabel!//ナビゲーションバータイトルの表示文字
    var underNav:UIView!//ナビゲーションバー下の半透明バー
    //var mask:UIView!
    //_viewレイアウトの変更
    func setView1(){
        rotMode = 1
        print("------ setView1 --------")
        boundWidthX = boundWidth
        let ax = drawableView.layer.position.x
        drawableView.layer.position = CGPoint(x:ax,y:boundHeight - vHeight/2 - th)
        upperView.frame.size = CGSize(width:boundWidth,height:30)
        upperView.layer.position = CGPoint(x:boundWidth/2,y:boundHeight - vHeight - th + 30/2)// underView：パレットの上の緑色帯を生成.
        underView.frame.size = CGSize(width:boundWidth,height:30)
        underView.layer.position = CGPoint(x:boundWidth/2,y:boundHeight - 30/2 - th)// underView：パレットの下の緑色帯を生成.
        leftEndPoint = CGPoint(x:vWidth/2,y:boundHeight - vHeight/2 - th)
        myToolView.frame.size = CGSize(width: boundWidth,height:40)
        myToolView.layer.position = CGPoint(x: boundWidth/2, y: boundHeight - vHeight - 40/2 - th)
        myToolView.addHorizonBorderWithColor(color: UIColor.black, width:1)
        myEditView.frame.size = CGSize(width:boundWidth,height:60)
        myEditView.layer.position = CGPoint(x: boundWidth/2, y: boundHeight - vHeight - 40 - 60/2 - th)
        spaceView1.frame.size = CGSize(width: boundWidth, height: 10)
        spaceView1.layer.position = CGPoint(x:boundWidth/2,y:boundHeight - th - vHeight + 10/2)
        spaceView2.frame.size = CGSize(width: boundWidth, height: 20)
        spaceView2.layer.position = CGPoint(x:boundWidth/2,y:boundHeight - th - vHeight - 40 - 20/2)
        scrollRect_P = CGRect(x:(boundWidth - leafWidth)/2,y: 70  + sBarX ,width:leafWidth, height:boundHeight - 20 - th - 44 - vHeight - 50)//最後の50は目で見て調整した
        self.myScrollView.frame = self.scrollRect_P// メモframeの値を設定する
        self.view.addSubview(underNav)//ナビゲーション下線を追加
        statusBarBackground.backgroundColor = nColor
        statusBarBackground.frame.size = CGSize(width:boundWidth,height:UIApplication.shared.statusBarFrame.height)
        memoCursol(disp: 1)//メモカーソルを更新
        self.toolBar.isHidden  = false
        shortToolBar.removeFromSuperview()
        shadow.removeFromSuperview()//影を削除する
        jinesView.removeFromSuperview()//削除する
        statusView.removeFromSuperview()//削除する
        scrollPos()//スクロール位置を調整
        if bigFlag{
            //_パレットが拡大表示されている場合のメモ表示サイズ
            let sa:CGFloat = (big - 1.0)*vHeight//境界線が上に動く距離
            scrollRect_B = CGRect(x:(boundWidth - leafWidth)/2,y: 70  + sBarX ,width:leafWidth, height:boundHeight - 20 - th - 44 - vHeight - 50 - sa)//最後の50は目で見て調整した
            zoom(zoom2)//一旦閉じる
            zoom(zoom2)//再度開く
        }
    }
    func setView2(){
        rotMode = 2//チャタリング防止用
        boundWidthX = boundHeight//縦横を入れ替える
        print("----- setView2 --------")

        // ステータスバーの高さを取得する
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        print("statusBarHeight:\(statusBarHeight)")
        print("naviBar.frame.height:\(naviBar.frame.height)")
        statusView = UIView(frame: CGRect(x: boundWidth, y: 0, width: boundHeight - boundWidth, height: statusBarHeight))
        statusView.backgroundColor = nColor
        self.view.addSubview(statusView)
        
        var ax = drawableView.layer.position.x
        let bx = boundHeight - vWidth/2
        ax = ax > bx ? ax : bx//_右端を超えない様にする
        drawableView.layer.position = CGPoint(x:ax,y:boundWidth - vHeight/2)
        leftEndPoint = CGPoint(x:vWidth/2,y:boundWidth - vHeight/2)
        upperView.frame.size = CGSize(width:boundHeight,height:30)
        upperView.layer.position = CGPoint(x:boundHeight/2,y:boundWidth - vHeight + 30/2)// underView：パレットの上の緑色帯を生成.
        
        underView.frame.size = CGSize(width:boundHeight,height:30)
        underView.layer.position = CGPoint(x:boundHeight/2,y:boundWidth - 30/2 + 2)// underView：パレットの下の緑色帯を生成.
        myToolView.frame.size = CGSize(width: boundHeight,height:40)
        myToolView.layer.position = CGPoint(x: boundHeight/2, y: boundWidth - vHeight - 40/2)
        myToolView.addHorizonBorderWithColor(color: UIColor.black, width:1)
        myEditView.layer.position = CGPoint(x: boundWidth/2, y: boundWidth - vHeight - 40 - 60/2)
        spaceView1.frame.size = CGSize(width: boundHeight, height: 10)
        spaceView1.layer.position = CGPoint(x:boundHeight/2,y:boundWidth - vHeight + 10/2)
        spaceView2.frame.size = CGSize(width: boundHeight, height: 20)
        spaceView2.layer.position = CGPoint(x:boundHeight/2,y:boundWidth - vHeight - 40 - 20/2)
        scrollRect_P = CGRect(x:(boundWidth - leafWidth)/2,y: 5 ,width:leafWidth, height:boundWidth - vHeight - 50)//最後の50は目で見て調整した
        self.myScrollView.frame = self.scrollRect_P// メモframeの値を設定する
       
        underNav.removeFromSuperview()
        statusBarBackground.backgroundColor = UIColor.white
        statusBarBackground.frame.size = CGSize(width:boundWidth,height:boundWidth - vHeight - 40)
        statusBarBackground.backgroundColor = UIColor.white
        let navH = boundWidth - vHeight - 40
        shortToolBar.layer.position = CGPoint(x:(boundHeight + boundWidth)/2,y:navH - 44/2 - 2)
        shortToolBar.addHorizonBorderWithColor(color: UIColor.black, width: 1.5)
        jinesH = boundWidth - vHeight - 40 - statusBarHeight - naviBar.frame.height - 44
        jinesView = UIView(frame: CGRect(x:boundWidth,y:statusBarHeight + naviBar.frame.height,width:shortToolBar.frame.width,height:jinesH))
        jinesView.backgroundColor = UIColor.orange.withAlphaComponent(0.1) //(patternImage: UIImage(named:"jines.png")!)
        self.view.addSubview(jinesView)
        self.view.addSubview(shortToolBar)
        shadow = UIView(frame: CGRect(x:boundWidth,y:0,width:6,height:boundWidth - vHeight - 40))//メモの右側の影
        shadow.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.view.addSubview(shadow)
        memoCursol(disp: 1)//メモカーソルを更新
        self.toolBar.isHidden  = true
        scrollPos()//スクロール位置を調整
        if bigFlag{
            //_パレットが拡大表示されている場合のメモ表示サイズ
            scrollRect_B = CGRect(x:(boundWidth - leafWidth)/2,y: 3,width:leafWidth, height:boundWidth - big*vHeight - 40 - 5)
            //メモの白い背景として代用している
            statusBarBackground.frame.size = CGSize(width:boundWidth,height:boundWidth - big*vHeight - 40)
            let shadowL = boundWidth - big*vHeight - 40
            if shadowL < 46 {shadow.backgroundColor = UIColor.clear}
            else{shadow.backgroundColor = UIColor.black.withAlphaComponent(0.3)}
            shadow.frame.size = CGSize(width:6,height:shadowL)
            zoom(zoom2)//一旦閉じる
            zoom(zoom2)//再度開く
            
        }
    }
    //_shortToolBarボタンのタッチDOWN 時の処理
    func btn_clicked(sender:UIButton){
        print("btn_clicked:\(sender.tag)")
        if sender.tag == 1{done(done2)}
        else if sender.tag == 2{zoom(zoom2)}
        else{redo(redo2)}
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        //X:iPhoneX--- iPhoneXの場合の対応(判定) ----------
         // ステータスバーの高さを取得する
          let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
          print("　〓statusBarHeight 〓 :\(statusBarHeight)")
          if statusBarHeight == 44{
            iphoneX = true//iPhoneXモードフラグをセットする
            sBarX = 24//iPhoneXの場合status barが下に24拡大する
            boundHeight = boundHeight - 34//safeareaのbottom
            helpFrame = UIView(frame: CGRect(x:0,y:44,width:boundWidth,height:boundHeight - 78))
          }

        //-----------------------------------------------
        //本機種の解像度
        print("　〓retina scale〓 :\(UIScreen.main.scale)")
        //NAVバー、ステータスバーの色を作成 95,144,191 0,145,197 51-102-204 0-130-255
        //nColor = UIColor.init(red: 0, green: 0.4, blue: 1, alpha: 1)
        nColor = UIColor.rgb(r: 51,g: 102, b: 204, alpha: 1)
        //Indexバーの色を作成
        iColor = UIColor.rgb(r: 208,g: 113, b: 68, alpha: 1) //init(white: 0.92, alpha: 1)78,157,121  (r: 208,g: 113, b: 68, alpha: 1)
        iColor2 = UIColor.rgb(r: 242, g: 177, b: 106, alpha: 1)
        //_画面の水平方向の幅
        boundWidthX = boundWidth
        //_ステータスバーの色を変える
        
        statusBarBackground = UIView(frame: CGRect(x:0 ,y: 0, width:self.view.frame.width, height:UIApplication.shared.statusBarFrame.height))
        statusBarBackground.backgroundColor = nColor
        self.view.addSubview(statusBarBackground)
        //ナビゲーションバーの色を変える
        setNaviBar(color: nColor)
        //_ナビゲーションバーの下線（半透明）
        let navB = statusBarHeight + naviBar.frame.height
        print("naviBar.frame.height:\(naviBar.frame.height)")
        underNav = UIView(frame: CGRect(x:0,y:navB - 1 ,width:boundWidth,height:5))
        underNav.backgroundColor = UIColor.init(white: 0.6, alpha:0.3)
        //_パレットをの左端を表示する
        leftEndPoint = CGPoint(x: vWidth/2, y:boundHeight - vHeight/2 - th)
        //_第２の短かいツールバー
        shortToolBar = UIView(frame:CGRect(x: boundWidth, y: 44, width: boundHeight - boundWidth, height: 46))
        shortToolBar.backgroundColor = UIColor.lightGray
        // buttonOKの追加
        buttonOK = UIButton(frame: CGRect(x:boundHeight - boundWidth - 40,y: 15, width:30, height:20))
        buttonOK.backgroundColor = UIColor.clear
        buttonOK.setImage(UIImage(named: "ok.png"), for:UIControlState.normal)
            //イベントを追加する
        buttonOK.tag = 1
        buttonOK.addTarget(self, action: #selector(btn_clicked(sender:)), for:.touchUpInside)
        shortToolBar.addSubview(buttonOK)
        // buttonZoomの追加
        buttonZoom = UIButton(frame: CGRect(x:(boundHeight - boundWidth)/2 - 30 ,y: 15, width:60, height:20))
        buttonZoom.backgroundColor = UIColor.clear
        buttonZoom.setImage(UIImage(named: "zoom.png"), for:UIControlState.normal)
        //イベントを追加する
        buttonZoom.tag = 2
        buttonZoom.addTarget(self, action: #selector(btn_clicked(sender:)), for:.touchUpInside)
        shortToolBar.addSubview(buttonZoom)
        // buttonRedoの追加
        buttonRedo = UIButton(frame: CGRect(x:20 ,y: 10, width:30, height:30))
        buttonRedo.backgroundColor = UIColor.clear
        buttonRedo.setImage(UIImage(named: "undopdf2.pdf"), for:UIControlState.normal)
        //イベントを追加する
        buttonRedo.tag = 3
        buttonRedo.addTarget(self, action: #selector(btn_clicked(sender:)), for:.touchUpInside)
        shortToolBar.addSubview(buttonRedo)
        //-----------------------------------------------------
        //ブランクleafを作成する
        let bView = UIView(frame: CGRect(x:0,y:0,width:leafWidth,height:leafHeight))
        bImage = bView.GetImage()
        //testVを作成  = debug2 =
        testV = UIView(frame:CGRect(x: 0, y:0 , width: 2, height: vHeight))
        testV.backgroundColor = UIColor.magenta
        //mx[]の位置にtestVを表示する
        testV.layer.position = CGPoint(x: 0, y:vHeight/2 )
        
        //+-+-子メモの初期化
        //仮に設定
        subMemoView = UIView(frame: CGRect(x: 0, y:0 , width: leafWidth, height:(leafHeight + leafMargin)*CGFloat(pageGyou2) + leafMargin))

        /** spaceViewを生成(透明：タッチ緩衝の為) **/
        //_underViewの下側
        spaceView1 = UIView(frame: CGRect(x: 0, y:boundHeight - th - vHeight , width: boundWidth, height: 10))
        spaceView1.backgroundColor = UIColor.clear
        //_underViewの上側
        spaceView2 = UIView(frame: CGRect(x: 0, y:boundHeight - th - vHeight - 40 - 20, width: boundWidth, height: 20))
        spaceView2.backgroundColor = UIColor.clear
        
        /** underViewを生成：パレットの下の緑色帯 **/
        //underFlag = false// 表示・非表示のためのフラグ
        underView = UIView(frame: CGRect(x: 0, y: 0, width: boundWidth, height: 30))// underViewを生成.
        let gardColor = gardClrFlg ? UIColor.green.withAlphaComponent(0.2) : UIColor.clear
        underView.backgroundColor = gardColor//UIColor.green// underViewの背景を青色に設定
        //_★★ underViewの位置を設定
        underView.layer.position = CGPoint(x: self.view.frame.width/2, y:boundHeight - th - 15 )// 位置を中心に設定
        underView.isUserInteractionEnabled = false//タッチ情報を後ろにスルーする™™
        /** upperViewを生成：パレットの上の緑色帯 **/
        upperView = UIView(frame: CGRect(x: 0, y: 0, width: boundWidth, height: 30))// underViewを生成.
        upperView.backgroundColor = gardColor//UIColor.green
        //★★ upperView.alpha = 0.33// 透明度を設定
        upperView.layer.position = CGPoint(x: self.view.frame.width/2, y:boundHeight - vHeight - th + 15)// 位置を中心に設定
        upperView.isUserInteractionEnabled = false
        //_パレットスクロールバー
        /** myToolView ([色][ペン][消しゴム][▲])を生成. **/
        myToolView.Delegate = self
        myToolView.frame =  CGRect(x: 0, y: 0, width: boundWidth, height: 40)// underViewを生成.
        myToolView.backgroundColor = UIColor(patternImage: UIImage(named:"lines.png")!)
        myToolView.alpha = 1//0.7// 透明度を設定
        
        myToolView.addHorizonBorderWithColor(color: UIColor.black, width:1)
        
        //ツールViewのボタンの生成　[2][3][4]   [1]
        // button1の追加
        editButton1 = UIButton(frame: CGRect(x:boundWidth - 70,y: 5, width:50, height:30))
        editButton1.backgroundColor = UIColor.clear // タイトルを設定する(通常時)
        //editButton1.setTitle("💠", for: UIControlState.normal)

        editButton1.setImage(UIImage(named: "3Up.pdf"), for:UIControlState.normal)
        // イベントを追加する
        editButton1.addTarget(self, action: #selector(ViewController.btn1_click(sender:)), for: .touchDown)
        
        // button2の追加
        editButton2 = UIButton(frame: CGRect(x:20, y:5, width:30, height:30))
        editButton2.backgroundColor = UIColor.clear
        editButton2.layer.cornerRadius = 5
        //editButton2.layer.masksToBounds = true//角のはみ出しをマスクする
        editButton2.layer.borderColor = UIColor.gray.cgColor
        editButton2.layer.borderWidth = 0
        editButton2.addTarget(self, action: #selector(ViewController.btn2_click(sender:)), for:.touchUpInside)
        //editButton2.setTitle("2", for: UIControlState.normal)
        editButton2.setImage(UIImage(named: "black2.png"), for:UIControlState.normal)
        
        // button3の追加
        editButton3 = UIButton(frame: CGRect(x:75, y:5, width:30, height:30))
        editButton3.layer.cornerRadius = 5
        //editButton3.backgroundColor = UIColor.init(white: 0.75, alpha: 1)
        editButton3.layer.borderColor = UIColor.darkGray.cgColor
        editButton3.layer.borderWidth = 0
        editButton3.addTarget(self, action: #selector(ViewController.btn3_click(sender:)), for:.touchUpInside)
        //editButton3.setTitle("3", for: UIControlState.normal)
        editButton3.setImage(UIImage(named: "pen3.pdf"), for:UIControlState.normal)
        
        // button4の追加
        editButton4 = UIButton(frame: CGRect(x:125, y:5, width:30, height:30))
        editButton4.backgroundColor = UIColor.init(white: 0.75, alpha: 0)
        editButton4.layer.cornerRadius = 5
        editButton4.layer.borderColor = UIColor.darkGray.cgColor
        editButton4.layer.borderWidth = 0
        editButton4.addTarget(self, action: #selector(ViewController.btn4_click(sender:)), for:.touchUpInside)
        //editButton4.setTitle("4", for: UIControlState.normal)
        editButton4.setImage(UIImage(named: "wOut.pdf"), for:UIControlState.normal)
        
        //ボタンをツールバーに追加する
        myToolView.addSubview(editButton1)
        myToolView.addSubview(editButton2)
        myToolView.addSubview(editButton3)
        myToolView.addSubview(editButton4)
        self.toolBar.isHidden  = true//ツールバーを隠す
        //_編集パネル
        /* editView([<][OVW][INS][DEL][CLR][>])を生成. */
        myEditView = UIView(frame: CGRect(x: 0, y: 0, width: boundWidth, height: 60))
        myEditView.roundCorners([.topLeft, .topRight], radius: 10.0)
        let myEditColor = UIColor.rgb(r: 255, g: 0, b:80, alpha: 0.66)
        //red.withAlphaComponent(0.7)
        //rgb(r: 198, g: 54, b: 89, alpha: 0.8)
        myEditView.backgroundColor = myEditColor// underViewの背景を青色に設定
        //myEditView.alpha = 0.6// 透明度を設定
        myEditView.layer.position = CGPoint(x: self.view.frame.width/2, y:boundHeight - vHeight - th - 40 - 30)// 位置を中心に設定
        //---------------------------------------
        //Editbuttonの追加 [9]　[5][6][7][8] [10]
        let sp:CGFloat = 10 + (boundWidth - 315)/10 //20ボタン間のスペース
        
        let bW:CGFloat = 45.0//ボタンの幅
        let bH:CGFloat = 45.0//ボタンの高さ
        let b2W:CGFloat = 40.0//矢印ボタンの幅
        let tW:CGFloat = sp + bW//各ボタン間の距離
        let sp2:CGFloat = (boundWidth - (bW*4 + b2W*2 + sp*5))/2//両側のスペース
        let x05 = b2W + sp + sp2//cW - CGFloat(2*tW - sp/2) - 5//左端のボタン(05)の位置
        //button5の追加
        editButton5 = UIButton(frame: CGRect(x:x05 + 3, y:8, width:bW, height:bH))
        editButton5.backgroundColor = UIColor.clear
        editButton5.layer.cornerRadius = 8
        //editButton5.layer.masksToBounds = true
        editButton5.addTarget(self, action: #selector(ViewController.btn5_click(sender:)), for:.touchUpInside)
        editButton5.setImage(UIImage(named: "OVW3.png"),for:UIControlState.normal)
        //editButton5.setTitle("5", for: UIControlState.normal)
        myEditView.addSubview(editButton5)
 
        //button6の追加
        editButton6 = UIButton(frame: CGRect(x:x05 + tW, y:8, width:bW, height:bH))
        editButton6.backgroundColor = UIColor.clear
        editButton6.layer.cornerRadius = 8
        editButton6.addTarget(self, action: #selector(ViewController.btn6_click(sender:)), for:.touchUpInside)
        editButton6.setImage(UIImage(named: "INS3.png"), for:UIControlState.normal)
        //editButton6.setTitle("6", for: UIControlState.normal)
        myEditView.addSubview(editButton6)
        
        //button7の追加
        editButton7 = UIButton(frame: CGRect(x:x05 + tW*2,y: 8,width: bW, height:bH))
        editButton7.backgroundColor = UIColor.clear
        editButton7.layer.cornerRadius = 8
        editButton7.addTarget(self, action: #selector(ViewController.btn7_click(sender:)), for:.touchUpInside)
        editButton7.setImage(UIImage(named: "DEL3.png"), for:UIControlState.normal)
        //editButton7.setTitle("7", for: UIControlState.normal)
        myEditView.addSubview(editButton7)
        
        //button8の追加
        editButton8 = UIButton(frame: CGRect(x:x05 + tW*3, y:8, width:bW,height: bH))
        editButton8.backgroundColor = UIColor.clear
        editButton8.layer.cornerRadius = 8
        editButton8.addTarget(self, action: #selector(ViewController.btn8_click(sender:)), for:.touchUpInside)
        editButton8.setImage(UIImage(named: "CLR3.png"), for:UIControlState.normal)
        //editButton8.setTitle("8", for: UIControlState.normal)
        myEditView.addSubview(editButton8)
        
        //button9の追加
        editButton9 = UIButton(frame: CGRect(x:sp2 + 8, y:5, width:30,height: 45))
        editButton9.backgroundColor = UIColor.clear
        editButton9.layer.cornerRadius = 8
        editButton9.addTarget(self, action: #selector(ViewController.btn9_click(sender:)), for:.touchDown)
        editButton9.setImage(UIImage(named: "2Left2.png"), for:UIControlState.normal)
        //editButton9.setTitle("|<", for: UIControlState.normal)
        myEditView.addSubview(editButton9)
        
        //button10の追加
        editButton10 = UIButton(frame: CGRect(x:x05 + tW*4 - 3, y:5, width:30,height: 45))
        editButton10.backgroundColor = UIColor.clear
        editButton10.layer.cornerRadius = 8
        editButton10.addTarget(self, action: #selector(ViewController.btn10_click(sender:)), for:.touchDown)
        editButton10.setImage(UIImage(named: "2Right2.png"), for:UIControlState.normal)
        //editButton10.setTitle(">|", for: UIControlState.normal)
        myEditView.addSubview(editButton10)

        /* ScrollViewを生成. */
        myScrollView.Delegate2 = self
        //myScrollView.Delegate3 = self
        //_パレット表示されていない場合
        scrollRect = CGRect(x:(boundWidth - leafWidth)/2, y:70 + sBarX ,width:leafWidth, height:boundHeight - 20 - th - 10 - sBarX )
        
        //_パレット表示されている場合
        scrollRect_P = CGRect(x:(boundWidth - leafWidth)/2,y: 70  + sBarX ,width:leafWidth, height:boundHeight - 20 - th - 44 - vHeight - 50)//最後の50は目で見て調整した
        //_パレットが拡大表示されている場合
        let sa:CGFloat = (big - 1.0)*vHeight//境界線が上に動く距離
        scrollRect_B = CGRect(x:(boundWidth - leafWidth)/2,y: 70  + sBarX ,width:leafWidth, height:boundHeight - 20 - th - 44 - vHeight - 50 - sa)//最後の50は目で見て調整した
        //_ ↑ height:画面高さ-_ステタスバー(20?)_ツールバー(46)_ナビバー(44)_vH_sa(vH/2)_myToolBar(40)
        
        //_toolViewだけが表示されている場合
        scrollRect_T = CGRect(x:(boundWidth - leafWidth)/2, y:70  + sBarX ,width:leafWidth, height:boundHeight - 20 - th - 10 - 44 )
        //index表示されている場合
        scrollRect_I = CGRect(x:(boundWidth - leafWidth)/2, y:110 + sBarX ,width:leafWidth, height:boundHeight - 115 - sBarX )
        
        myScrollView.frame = scrollRect
        myScrollView.bounces = false//スクロールをバウンドさせない
        self.view.addSubview(myScrollView)
        myScrollView.isUserInteractionEnabled = true
        //myScrollView.isPagingEnabled = false//離散スクロール
        myScrollView.showsVerticalScrollIndicator = true
        myScrollView.showsHorizontalScrollIndicator = false// 横スクロールバー非表示
        //_スクロールコンテンツのサイズ
        myScrollView.contentSize = CGSize(width:leafWidth,height:(leafHeight + leafMargin) * CGFloat(pageGyou + memoLowerMargin) + topOffset)
        //myScrollView.directionalLockEnabled = true
        //枠線を追加する
        myScrollView.backgroundColor = UIColor.white
        myScrollView.layer.borderColor = UIColor.yellow.cgColor
        myScrollView.layer.borderWidth = 0//枠線を見えなくする
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
        longPush.minimumPressDuration = 0.5//0.6から変更20180614
        myScrollView.addGestureRecognizer(longPush)
        
        //+-+-ダブルクリック認識登録
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.wClick))
        doubleTap.numberOfTapsRequired = 2
        myScrollView.addGestureRecognizer(doubleTap)
        
    //----- Memo(ページ）ビューを作成・初期化する -------
        
        if memo == nil{
            
            //メモビューの初期化
            //+-+- 子メモを表示するため末尾を拡大する（+pageGyou2)
            let memoFrame = CGRect(x:0,y: 0,width:leafWidth*1,height: (leafHeight + leafMargin) * CGFloat(pageGyou + pageGyou2) + topOffset)

            let memo0 = MemoView(frame: memoFrame)
            let memo1 = MemoView(frame: memoFrame)
            let memo2 = MemoView(frame: memoFrame)
            memo = [memo0,memo1,memo2]
            //+-+- 子メモの初期化$
            let childFrame = CGRect(x:0,y: 0,width:leafWidth*1,height: (leafHeight + leafMargin)*CGFloat(pageGyou2) + 10)
            subMemo = MemoView(frame: childFrame)
            subMemo.layer.cornerRadius = 10.0//角丸にする20180614追加
            subMemo.layer.borderColor = UIColor.gray.cgColor//childColor.cgColor
            subMemo.layer.borderWidth = 2//leafMargin*1.2
            
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
            //+-+-+ インデックスのブランクイメージをbImageに置き換える
            initBlank()
            //タグを付ける、メモの作成(indexページ)
            memo[0].setIndexView()
            
            //indexタイトルの作成
            //titleV = UIImageView(frame: CGRect(x:(boundWidth - leafWidth)/2, y:70 ,width:myScrollView.frame.width,height:topOffset*2))
            titleV = UIImageView(frame: CGRect(x:0, y:62 + sBarX,width:boundWidth,height:topOffset*2))
            titleV.backgroundColor = iColor2//UIColor.brown
            //darkGray
            //rgb(r: 236, g: 223, b: 43, alpha: 1)
                //.orange.withAlphaComponent(0.5)// init(white: 1, alpha: 1)
            //titleV.addBottomBorderWithColor(color: UIColor.orange, width: 0.8)
            //タイトルview下の半透明マスク
            let underTV = UIView(frame: CGRect(x:0,y:topOffset*2 - 3,width:boundWidth,height:6))
            underTV.backgroundColor = UIColor.init(white: 0.6, alpha:0.2)
            
            let tw = titleV.frame.width
            let th = titleV.frame.height*1.2
            let label1 = UILabel(frame: CGRect(x:0,y:8,width:tw/3,height:th/2))
            let label2 = UILabel(frame: CGRect(x:tw/2 - tw/5,y:9,width:tw/3,height:th/2))
            let label3 = UILabel(frame: CGRect(x:tw*2/3 - 5 ,y:8,width:tw/3 - 15,height:th/2))
            label1.font = UIFont(name: "ChalkboardSE-Bold", size: 16)
            label2.font = UIFont(name: "ChalkboardSE-Bold", size: 16)
            label3.font = UIFont(name: "ChalkboardSE-Bold", size: 16)//ChalkboardSE-Bold//Optima-ExtraBlack
            label1.textColor = iColor//UIColor.white
            label2.textColor = iColor//UIColor.white
            label3.textColor = iColor//UIColor.white
            label1.text = "　page"
            label2.text = "title"
            label3.text = "update"
            label2.textAlignment = .center
            //label2.backgroundColor = UIColor.lightGray
            label3.textAlignment = .right
            //ラベルの下に白線を追加する
            let senW = UIView(frame: CGRect(x:15,y:titleV.frame.height - 7,width:titleV.frame.width - 25,height:3))
            senW.backgroundColor = UIColor.brown//gray.withAlphaComponent(0.5)
            titleV.addSubview(label1)
            titleV.addSubview(label2)
            titleV.addSubview(label3)
            //titleV.addSubview(senW)
            titleV.addSubview(underTV)
   
            // ** メモ表示内容の初期化 **
            //設定値を読み込む
            settingRead()//前回終了時の保存データを読み込む
            let openPage:Int = lastPage
            pageNum = lastPage//ページ番号を設定する
            let im = readPage(pn:openPage)//im:１ページ目の外部データを読み込む
            memo[1].setMemoFromImgs(pn:openPage,imgs:im)
            
            fNum = 1
            //nowGyouNoの更新
            nowGyouNo = openPage * 100 + 1//１頁の１行目
            myScrollView.addSubview((memo[1]))
            self.view.addSubview(myScrollView)
            myScrollView.contentOffset = CGPoint(x:0,y: 0)

            //ナビゲーションバータイトルの設定
            tl = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
            tl.layer.borderColor = UIColor.white.cgColor
            tl.layer.borderWidth = 0
            tl.layer.cornerRadius = 10
            tl.layer.masksToBounds = true
            tl.textColor = UIColor.white
            tl.textAlignment = .center
            tl.backgroundColor = UIColor.clear
            tl.text = String(pageNum) + " /30"
            naviBar.topItem?.titleView = tl
            
            // **mx[]の読み込み・初期化 **
            mx = loadMx()
            resn = loadResn()//+-+ リサイズ回数を初期化
        }
        //---------- リストメニュ−　---------
        //テーブルビュー初期化、関連付け
        mh = ch * CGFloat(cn)//メニューの高さ＝セルの高さ☓セル数
        let w = boundWidth
        tV.frame = CGRect(x:0, y:0, width:mw + 20 , height:mh)
        smv = UIScrollView(frame: CGRect(x:w - mw - 10 ,y:65 + sBarX,width:mw + 20,height:mh - 0))
        smv.backgroundColor = UIColor.clear
        //smv.bounces = false//スクロールをバウンドさせない
        tV.separatorColor = UIColor.clear//セパレータ無し
        tV.rowHeight = 40
        tV.layer.cornerRadius = 8.0//角丸にする
        tV.layer.borderColor = UIColor.gray.cgColor
        tV.layer.borderWidth = 1
        //区切り線
        let sen = UIView(frame: CGRect(x:10,y:ch*4.5,width:mw*0.9,height:1))
        sen.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        tV.addSubview(sen)
        // シャドウカラー
        tV.layer.masksToBounds = false
        tV.layer.shadowColor = UIColor.gray.cgColor/* 影の色 */
        tV.layer.shadowOffset = CGSize(width:-2,height: 4)       //  シャドウサイズ
        tV.layer.shadowOpacity = 0.15 // 透明度
        tV.layer.shadowRadius = 2 // 角度(距離）
        //メニュー表示viewの設定
        smv.contentSize = tV.frame.size
        smv.contentOffset = CGPoint(x:-10,y:mh)
        smv.addSubview(tV)
        //テーブルviewの設定
        tV.delegate      =   self
        tV.dataSource    =   self
        tV.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        //設定画面
        setV = UIView(frame: CGRect(x:0,y:0,width:view.bounds.width,height:view.bounds.height))
        setV.backgroundColor = UIColor.black.withAlphaComponent(0.40)
        self.view.addSubview(underNav)//ナビゲーション下線を追加
        //使用言語を調べる
        let prefLang = NSLocale.preferredLanguages.first
        //文字列の先頭から末尾までを取得
        let currentIndex = prefLang?.index((prefLang?.endIndex)!, offsetBy: -2)
        let subStr = prefLang?.substring(to:currentIndex!)
        print("lang:\(String(describing: prefLang))>\(String(describing: subStr))")
        if subStr == "ja-"{
            print("日本語データ処理")
            langFlag = 0
            items = items_Ja
        } else {
            print("英語データ処理")
            langFlag = 1
            items = items_En
        }
        /**  -- ヘルプ画面の作成  --  **/
        //----TOPエリアの作成-----
        helpTop = UIView(frame: CGRect(x:0,y:0,width:view.bounds.width,height:64))
        helpTop.backgroundColor = UIColor.black
        //
        hl = UILabel(frame: CGRect(x: boundWidth/2
            - 100, y: 5, width: 200, height: 40))
        hl.textColor = UIColor.yellow
        hl.textAlignment = .left
        hl.backgroundColor = UIColor.clear
        hl.font = UIFont(name: "ChalkboardSE-Bold", size: 24)
        hl.text = (langFlag == 0) ? "スタートガイド":"Start-Guide"
        hl.textAlignment = .center
        //let cancel:String = (langFlag == 0) ? "キャンセル":"Cancel"
        //言語切替ボタンを追加:jButton,eButton
        jButton = UIButton(frame: CGRect(x:boundWidth - 150,y:30, width:60, height:40))
        eButton = UIButton(frame: CGRect(x:boundWidth - 70,y:30, width:60, height:40))
        jButton.backgroundColor = UIColor.clear
        eButton.backgroundColor = UIColor.clear
        jButton.showsTouchWhenHighlighted = true
        eButton.showsTouchWhenHighlighted = true
        // タイトルを設定する(通常時)
        jButton.setTitle("日本語", for: UIControlState.normal)
        eButton.setTitle("English", for: UIControlState.normal)
        jButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        eButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        // イベントを追加する
        jButton.addTarget(self, action: #selector(ViewController.Ja_click(sender:)), for: .touchUpInside)
        eButton.addTarget(self, action: #selector(ViewController.En_click(sender:)), for: .touchUpInside)
        //戻る(終了）ボタンを追加
        rButton = UIButton(frame: CGRect(x:20,y:20, width:30, height:30))
        //rButton.backgroundColor = UIColor.white
        rButton.setImage(UIImage(named: "2Left.png"), for:UIControlState.normal)
        rButton.addTarget(self, action: #selector(ViewController.Re_click(sender:)), for: .touchUpInside)
        helpTop.addSubview(hl)
        helpTop.addSubview(jButton)
        helpTop.addSubview(eButton)
        helpTop.addSubview(rButton)
        didLoadFlg = false//_portlaitで起動する為のフラグ
        toolBar.addTopBorderWithColor(color: UIColor.black, width: 1.5)//パレットとツールバーの境界線
    }

    //  ======= End of viewDidLoad=======
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //_★★画面の回転に応じた処理を行う
    override func viewDidAppear(_ animated: Bool) {
        // 端末の向きがかわったらNotificationを呼ばす設定.
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.onOrientationChange(notification:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    //_★★ 端末の向きがかわったら呼び出されるメソッド　-------------------★★
    func onOrientationChange(notification: NSNotification){
        // 現在のデバイスの向きを取得.
        let deviceOrientation: UIDeviceOrientation!  = UIDevice.current.orientation
        deviceO = deviceOrientation.rawValue
        print("deviceOrientation:\(deviceO)")
        print("isLandscape?: \(deviceOrientation.isLandscape)")
        // 向きの判定.
        if deviceOrientation.rawValue == 3 || deviceOrientation.rawValue == 4 {
            if didLoadFlg {
                if rotMode == 1{ self.setView2() }
            }
        } else if deviceOrientation.rawValue == 1{//-- 縦向きの判定 --
            if didLoadFlg {
                if rotMode == 2{ self.setView1() }
            }
 
        }
    }
/*
    func pinchZoom(sender:UIPinchGestureRecognizer){
        print("zoomOut!")
        //helpView.transform = CGAffineTransform(
    }
*/
    @IBOutlet weak var naviBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var menu2: UIBarButtonItem!
    @IBOutlet weak var index2: UIBarButtonItem!
    @IBOutlet weak var pallete2: UIBarButtonItem!
    @IBOutlet weak var done2: UIBarButtonItem!
    @IBOutlet weak var zoom2: UIBarButtonItem!
    @IBOutlet weak var redo2: UIBarButtonItem!
 
    //INDEXの表示・非表示
    var retNum:Int = 0
    var changing:Bool = false//indexアニメとメニューアニメの両方で共有
    //→animeFlag(Palette)
    
    @IBAction func index(_ sender: UIBarButtonItem) {
        //子メモが表示されている時は
        //★20180815 if childFlag == true{ return}
        //拡大表示の時はパス
        if bigFlag == true{ return}
        //パレットが開いている時は
        if isPalleteMode == true{//パレット内容を保存して閉じる
            return
        }
        if isMenuMode == true{
           return
            // menu(menu2)//メニューが開き始めと開いている間は受け付けないように変更した4/4
        }
        //windowの開閉中は"changing = true"として他のwindowは開けなくする
        if changing == true { return }//Indexを開き切るまでは受け付けない
        changing = true//開く(閉じる)ジェスチャーを開始する
        //memo[0]-[2]に枠を追加する
        for n in 0...2{
            memo[n].layer.borderColor = UIColor.gray.cgColor
            memo[n].layer.borderWidth = 1
        }
        //左端ライン？不要？
        if numBar == nil{
          numBar = UIView(frame: CGRect(x:0,y:0,width:45,height:myScrollView.contentSize.height))
          numBar.backgroundColor = UIColor.brown.withAlphaComponent(0.2)
        }
        var opt = UIViewAnimationOptions.transitionFlipFromLeft
        
        //=== ページが非表示の場合 ===
        if isIndexMode == false{
           //★20180815子メモが開いている場合は子メモを閉じる
            if childFlag == true{ childMemoClose(ngn: oyaGyou)}

            //表示サイズを変更する
            myScrollView.contentSize = CGSize(width:leafWidth,height:(leafHeight + leafMargin) * CGFloat(maxPageNum + memoLowerMargin/2) + topOffset)
            myScrollView.contentOffset.y = -40//スクロール位置：TOP
            //mask.backgroundColor = UIColor.yellow
            
            //indexImgs[]からの反映
            //+-+- 
            memo[0].setIndexFromImgs(imgs:indexImgs)
            retNum = fNum
            opt = UIViewAnimationOptions.transitionFlipFromBottom//transitionFlipFromRight
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
                
                self.tl.text = "INDEX"
                self.tl.textColor = UIColor.black
                self.tl.font = UIFont(name: "ChalkboardSE-Bold", size: 20)
                //self.tl.font = "Cooper Std"//"HiraKakuProN-W3"//"Chalkboard SE"//"Optima-ExtraBlack"//AmericanTypewriter-Bold//"Optima-ExtraBlack"//"Chalkduster"//Euphemia UCAS
                self.naviBar.topItem?.titleView = self.tl
                //↑はこれでもOK:naviBar.topItem?.title = "--  INDEX  --"
                    //ステータスバーの色を変える
                    self.statusBarBackground.backgroundColor = self.iColor
                    self.underNav.backgroundColor = UIColor.init(white: 0.6, alpha:0.0)
                    // ナビゲーションを変更する処理
                    self.setNaviBar(color: self.iColor)
                //self.view.addSubview(self.mask)
                self.myScrollView.frame = self.scrollRect_I
                self.myScrollView.contentOffset.y = 0//スクロール位置：TOP
                self.view.addSubview(self.titleV)
                self.changing = false//開く(閉じる)ジェスチャーを終了する
            })
            
            isIndexMode = true
            fNum = 0
            
            memo[0].delCursol()
            print("retNum1: \(retNum)")
           
            myScrollView.backgroundColor =  UIColor.white//rgb(r: 235, g: 201, b: 118, alpha: 1)
                //.orange.withAlphaComponent(0.5)
            myScrollView.layer.borderWidth = 0//枠線を付ける
            //myScrollView.addSubview(numBar)

        //=== Indexページが表示中の場合 ===
        }else{
            print("index else**")
            
            //self.navigationController?.setToolbarHidden(true, animated: true)
            opt = UIViewAnimationOptions.transitionFlipFromTop//transitionFlipFromLeft
            
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
                    self.tl.text = String(pageNum) + " /30"
                    self.naviBar.topItem?.titleView = self.tl
                    //self.mask.removeFromSuperview()
                    //ステータスバーの色を変える
                    self.statusBarBackground.backgroundColor = self.nColor
                    // ナビゲーションの色を変える
                    self.setNaviBar(color: self.nColor)
                    self.tl.textColor = UIColor.white
                    self.titleV.removeFromSuperview()
                    self.underNav.backgroundColor = UIColor.init(white: 0.6, alpha:0.3)
                    
                    self.changing = false//開く(閉じる)ジェスチャーを終了する
/*
 self.navigationController?.navigationBar.setBackgroundImage(UIImage(named:"blankP.png"), for: UIBarPosition.any , barMetrics: UIBarMetrics.default)
 */
                }
            )
            myScrollView.frame = scrollRect
            isIndexMode = false
            print("retNum: \(retNum)")
            fNum = retNum
            myScrollView.backgroundColor =  UIColor.clear
            myScrollView.layer.borderWidth = 0//枠線を消す
            myScrollView.contentOffset.y = 0//スクロール位置：TOP
            //表示サイズを変更する、元に戻す
            myScrollView.contentSize = CGSize(width:leafWidth,height:(leafHeight + leafMargin) * CGFloat(pageGyou + memoLowerMargin) + topOffset)
            numBar.removeFromSuperview()
            numBar = nil
            //タイトルの設定
            //naviBar.topItem?.title = String(pageNum) + " /30"
            //let p:String = String(pageNum) + " /30"
            //myScrollView.backgroundColor =  UIColor.orange.withAlphaComponent(0.2)
            
        }
    }
    
    @IBAction func menu(_ sender: UIBarButtonItem) {
        if myEditFlag{ return }//★20180821
        if isPalleteMode == true {
           /*
            callig = callig == false ? true :false//★20180819テスト専用
            print("callig: \(callig)")
           */
            showAlert()
            //penMode()
            return }
        
        if animeFlag == true {return}
        //indexページが開いている時は
        if isIndexMode == true { return }//Indexが表示中は実行しない
        //パレットの表示中は実行しない

        //上記の変更理由：パレット表示中にペン幅を変更できるようになった為
        /* 20180603に変更
        if isPalleteMode == true{//パレット内容を保存して閉じる
            done(done2)
            Pallete(pallete2)
        }
         */
        //windowの開閉中は"changing = true"として他のwindowは開けなくする
        if changing == true { return }//Indexを開き切るまでは受け付けない
        changing = true//開く(閉じる)ジェスチャーを開始する
        
        print("langFlag:\(langFlag)")
        
        if isMenuMode == false{//リストが非表示の場合
            view.addSubview(smv)
            smv.contentOffset = CGPoint(x:-10,y:self.mh )
            UIScrollView.animate(withDuration: 0.3, animations: {
                () -> Void in
                self.smv.contentOffset = CGPoint(x:-10,y:40)
                
            }){ (Bool) -> Void in  // アニメーション完了時の処理
            self.changing = false//開く(閉じる)ジェスチャーを終了する
            self.isMenuMode = true
            }
            //◯ボタンの画像を入れ替える
             //menu2.setBackgroundImage(UIImage(named: "enn2.png"), for:UIControlState.normal, style: UIBarButtonItemStyle.plain, barMetrics:UIBarMetrics.compact)
            
        }else{//リストが表示の場合
            UIScrollView.animate(withDuration: 0.3, animations: {
                () -> Void in
                self.smv.contentOffset = CGPoint(x:-10,y:self.mh)
            }){ (Bool) -> Void in  // アニメーション完了時の処理
                self.smv.removeFromSuperview()
                self.changing = false//開く(閉じる)ジェスチャーを終了する
            }
            isMenuMode = false
            
        }

    }
    
    /* パレットの表示／非表示を交互に行う (NAVバーの右端ボタン) */

    var animeFlag:Bool = false//アニメ中はtrue
    @IBAction func Pallete(_ sender: UIBarButtonItem) {
        print("★deviceO: \(deviceO)")
        //_if deviceO != 1{return}//画面が縦方向出ない場合は無視？画面ロックの場合はX
        if boundWidthX != boundWidth{return}//_landscape画面の場合は無視する
        if myEditFlag{ return }//★20180821：Editパネルを閉じないとパレットが閉じられない様に変更した
        if changing == true { return}//メニューのアニメ中は実行しない。
        if animeFlag { return}//アニメ中は実行しない
        //if isMenuMode == true{ return }//リストメニュー表示中は実行しない
        if isMenuMode == true{
            menu(menu2)
        }
        if isIndexMode == true { return }//index表示中は実行しない
        animeFlag = true//アニメ開始(開始ボタンのチャタリング防止用）
        //----------------------------------------------①
        if drawableView != nil {
        // ◆◆ パレットが表示されている時パレットを消す
          //_portlaitで起動する為のフラグ:回転禁止に設定
            didLoadFlg = false
           //メモカーソルを消す
            memoCursol(disp: 0)
           //編集中のページ内容を更新する
            //myScrollView.upToImgs()//編集中のページ内容を更新する
            let im = memo[fNum].memoToImgs(pn: pageNum)//im:
            //メモ内容を外部に保存
            writePage(pn: pageNum, imgs: im)
            //INDEX内容を外部に保存
            writePage(pn:0, imgs:indexImgs)
            //mx[]の内容を外部に保存する
            updataMx(my:mx)
            upResn(my: resn)//+-+
          
           //++ パレットを閉じるアニメーション
            self.etcBarDisp(disp: 0)//underView等を削除する
            UIView.animate(withDuration:0.2, animations: {
                () -> Void in
                self.myToolView.layer.position = CGPoint(x: self.view.frame.width/2, y:boundHeight + th - 40/2)
                let nowPosx = drawableView.layer.position.x//表示中の位置
                drawableView.layer.position = CGPoint(x:nowPosx , y:boundHeight + th - 40/2 + vHeight/2)
                self.myScrollView.frame = self.scrollRect_T// メモframeの値を設定する

            }){
                (Bool) -> Void in
                
                // 子viewを削除する??
                drawableView!.removeFromSuperview()
                drawableView = nil
                self.myToolView.removeFromSuperview()
                //ツールバーを隠す
                self.myScrollView.frame = self.scrollRect//最大表示
                self.toolBar.isHidden  = true
                self.animeFlag = false
            } // アニメーションの終わり
            //self.toolBar.isHidden  = true
            
            //メモページのカーソルを削除する
            memo[fNum].delCursol()
            //+-+- 子メモページのカーソルを削除する
            subMemo.delCursol()
            //+-+-子メモに背景色をつける
            if childFlag == true{//+-+-
                subMemoView.backgroundColor = childColor
            }

            //ページ登録フラグを更新する
            /*
                for n in 1...pageGyou{
                print("mx[\(n)]= \(mx[String(n)])")
                }
            */
            isPalleteMode = false
            bigFlag = false
        }else{
        // パレットが表示されていない時パレットを表示する-----------②
            //_パレットビューを作成・初期化する
             drawableView = DrawableView(frame: CGRect(x:0, y:0,width:vWidth, height:vHeight))//2→3
             drawableView.Delegate = self
            //_左端を表示⬇️使っていないみたい？？modaoChange()で再設定している
             leftEndPoint = CGPoint(x: vWidth/2, y:boundHeight - vHeight/2 - th)
             drawableView.layer.position = leftEndPoint
             drawableView.backgroundColor = UIColor.clear//(patternImage: myImage)
            //パレットの底に黒線を追加する
            //drawableView.addBottomBorderWithColor(color: UIColor.black, width:2)
            //secondView,thirdViewの初期化(追加）
            drawableView.setSecondView()
            //編集ツールの追加(toolbar)
            self.view.addSubview(myToolView)
            myToolView.layer.position = CGPoint(x: self.view.frame.width/2, y:boundHeight - th - 40/2)// 位置を中心に設定：画面の外に位置する
            self.myScrollView.frame = self.scrollRect_T
            //_+++ パレットを開くアニメーション　+++
            UIView.animate(withDuration:0.4, animations: {
                () -> Void in
                self.myToolView.layer.position = CGPoint(x: self.view.frame.width/2, y:boundHeight - vHeight - th - 40/2 )//++ 位置を中心に設定
                self.myScrollView.frame = self.scrollRect_P// メモframeの値を設定する
            }){
            (Bool) -> Void in
                self.view.addSubview(drawableView)
                self.etcBarDisp(disp: 1)//underView等」を追加する
                //self.toolBar.isHidden  = false//ツールバーを現す
                //self.setToolBar(color:UIColor.blue)//iPadMiniに対応：20180614追加中止（ツールバーボタンーのTintを黒色に、バーボタンtintをdefaultに設定したら解決した）
                //アニメ動作終了
                self.animeFlag = false//アニメ動作終了宣言
                //メモカーソルを表示する
                self.memoCursol(disp: 1)
                //_portlaitで起動する為のフラグ:回転OKに設定
                didLoadFlg = true
             } // ++++  ココまで  ++++
            
            self.toolBar.isHidden  = false//ツールバーを現す
            //ツールバーの高さを検出する 20180720追加
            //th = self.toolBar.frame.height
            print("〓toolbar.height〓 th:\(th)")
            isPalleteMode = true//パレットが表示されているので"true"
            //編集画面非表示フラグをリセットする
            //????myEditFlag = false
            //+-+- １行目をパレットに呼び込む$
            if childFlag != true{//子メモが開いていない場合
                modalChanged(TouchNumber: pageNum*100 + 1)
            }else{//子メモが開いている場合
                modalChanged(TouchNumber: nowGyouNo)
            }
            penMode()//黒ペンモードにする
            //????closeEditView()//編集パレット画面を閉じる
            // == debug2 =====================================================
            if debug2 == true{drawableView.addSubview(testV)}  //@@ DEBUG2 @@
            testV.layer.position = CGPoint(x: mxTemp, y:vHeight/2 )
            //  ==============================================================
            
        }
    }
    
    ///  ** パレット入力時における[OK]ボタン処理 **
    func upToMemo(){  //パレット内容をメモに反映させる
        print("okEnble:\(okEnable)")//+-
        print("undoMode:\(drawableView.undoMode)")//+-
        if drawableView.undoMode == 1{okEnable = true}//+-
        if okEnable == false{return}else{okEnable = false}//+-
        print("nowGyouNo:\(String(describing: nowGyouNo))")
        print("●------reszNum01:\(String(describing: resn[String(nowGyouNo)]))")//+-+-
        if m2pFlag == true{//+-+
           m2pFlag = false
           if resn[String(nowGyouNo)] == nil{resn[String(nowGyouNo)] = 0}//+-+-$
           resn[String(nowGyouNo)] = resn[String(nowGyouNo)]! + 1
        }
        print("●------reszNum:\(String(describing: resn[String(nowGyouNo)]))")//+-+
        drawableView.thirdView.removeFromSuperview()//3rdViewを取り出す
        let palImage = drawableView.GetImage()
        let myImage1 = palImage.ResizeUIImage(width: vWidth/3, height: vHeight/3)
        print("fNum:\(fNum) ,tag: \(String(describing: nowGyouNo))")
        // メモにパレット内容を書き込む(書き込みが5回以上ではリサイズしない）
        let rn = resn[String(nowGyouNo)]!//+-+
        if rn < 5 {
           memo[fNum].addMemo(img: myImage1!,tag:nowGyouNo)
        }else{
           memo[fNum].addMemo(img: palImage,tag:nowGyouNo)//+-+
           print("resizeNum:\(rn)")
        }
        // 最大文字位置を保存する
        mx[String(nowGyouNo)] = mxTemp
        //drawableView.reAddSubView()//(secondView)を付加する
        drawableView.addSubview(drawableView.thirdView)//前フィルタ3rdViewを追加'170110変更（ダブリと思われるため）
        //インデックス情報を更新する
        let uNum = numOfUsedLine(pn:pageNum)//入力行最小値を取得
        
        if uNum > 0{
          //index画像を更新する
          indexImgs[pageNum - 1] = indexChange(pn: pageNum,usedNum:uNum )
          mx[String(pageNum)] = 1//indexリストに対象の頁番号を登録する
        }else{
            if pageNum <= maxPageNum{ //間違って行のmxを削除しないための保護
                print("mx[String(pageNum)]A:\(String(pageNum))")
                mx[String(pageNum)] = 0
            }
          indexImgs[pageNum - 1] = bImage//空白の画像をインデックス頁に貼り付ける
        }
        //非空白行の最上値
        print("numOfUsedLine:\(numOfUsedLine(pn:pageNum))")
        //ペンモードの初期化
        //penMode()//黒ペンモードにする★20180813 勝手に黒色に戻ることを止める
        settingWite()//設定値を外部に保存する
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        print("cursolWFlag:\(cursolWFlag)")
        if bigFlag == true{
            zoom(zoom2)
            return
        }
        //---------- パレット編集時 ---------------------------
        if isPalleteMode == false{return}//パレットが表示されて無い場合は🐞
        //done2.tintColor = UIColor.red
        //===== 編集パネルが表示の場合 =====
        if myEditFlag == true{
        //編集結果確定[OK]ボタンが押された場合を区別するフラグを設定する：UNDO処理の為
          drawableView.editOK = true//編集パネル表示の場合
          if editFlag == true{//カーソルモードが選択されている場合
            if cursolWFlag == true{ //カーソル幅が有る場合(狭い場合では🐞）
               //カーソル画面を撤去する
                drawableView.secondView.cursolView.removeFromSuperview()
                drawableView.thirdView.removeFromSuperview()
                
                //編集結果画面を取得する
                var editedView:UIImage!//編集結果画面View
                if myInt == "CLR"{ //編集パネル”CLR”の処理はココで行う
                    print("----CLR---")
                    editedView = bImage//UIImage(named:"blankW.png")
                    //パレットの位置を先頭にする
                    //_グローバル変数：回転の度に設定されている
                    //_leftEndPoint = CGPoint(x: vWidth/2, y:boundHeight - vHeight/2 - th)
                    drawableView.layer.position = leftEndPoint
                    //mx[]を更新する(0にリセット)
                    mx[String(nowGyouNo)] = 0
                    
                    //+-+- 子メモの内容を削除する$
                    //子メモページが開いている時は削除しない（▽マークだけ残る）
                    if childFlag == false{
                        delChild(baseGyou: nowGyouNo)
                    }
                    //+-+- ------------------------------------
                    
                    mxTemp = 0//ペンタッチ時に上書きしています為これもリセット
                    //+-+ resn[]を更新する(0にリセット)
                    resn[String(nowGyouNo)] = 0
                    m2pFlag = true//+-+ リサイズ回数追加を可能とする（リセット）
                    //ok2()//★20180819
                }else{ //編集パネル”CLR”以外の処理はココで行う
                    editedView = drawableView.secondView.editPallete(sel: myInt)
                    
                }
                
                // -- 編集結果画面をパレットに反映させる --
                //カーソルを削除する
                drawableView.secondView.cursolView.removeFromSuperview()
                //画面をグリーン色にする
                drawableView.addSubview(drawableView.thirdView)
                //secondViewの背景を透明にする
                drawableView.secondView.backgroundColor = UIColor.clear
                //編集結果をパレットviewの背景に入れ替える
                drawableView.backgroundColor = UIColor(patternImage: editedView)
                //編集結果確定[OK]ボタンが押された場合を区別するフラグ
                drawableView.editOK = true//??編集パネル表示中
                //??◆◆◆◆drawableView.get3VImage(im: editedView)//??
                //パレット入力状態のリセット
                editFlag = false;myInt = "NON"
                drawableView.lastDrawImage = nil
                
                //編集画面を閉じる
                closeEditView()
                drawableView.get3VImage(open:0)//編集結果画面を保存する
                //+- メイン画面のokボタンの受付を許可する
                okEnable = true//+-
               ok2()//★20180819
            }else{ //カーソル幅が狭い場合）
                print("カーソル巾がゼロです")
                //カーソルを削除する
                drawableView.secondView.cursolView.removeFromSuperview()
                closeEditView()//編集画面を閉じる
            }

          }else{ return }//モードが選択されていない場合(editFlag == false)
            //編集画面表示中で編集モードが選択されていない場合はパス
            //if myEditFlag == true{return}
        //===== 編集パネルが非表示の場合 =====
        }else{
        /**      通常の文字入力時      **/
            //if okEnable == false{return}
            //+- okEnable = false//okボタンのチャタリング防止の為：パレットタッチ時にリセット
            ok2()
           
        }
            
        // == debug2 ============================
        if debug2 == true{//@@ DEBUG2 @@
            testV.removeFromSuperview()
            drawableView.addSubview(testV)
            testV.layer.position = CGPoint(x: mxTemp, y:vHeight/2 )
        }
        // =======================================
 
        //print("*mx[\(pageNum)]= \(mx["Sring(pageNum)!"])")//@@@@  @@@@@
    }
   
    func ok2(){//★2018081314
        if bigFlag {return}//拡大表示中はメモ行に反映させない
        if myEditFlag {return}//編集パレット表示中はメモ行に反映させない
        //編集結果確定[OK]ボタンが押された場合を区別するフラグを設定する：UNDO処理の為
        drawableView.editOK = false//編集パネル非表示の場合
        upToMemo()//パレット画面をメモ行にコピーする
        drawableView.get1VImage()//◆◆◆◆:drawableView画面を取得する
        //メモカーソル位置の更新
        memoCursol(disp: 1)
    }

    @IBAction func zoom(_ sender: UIBarButtonItem) {
        print("◆◆◆◆")
        if myEditFlag == true{return}//編集パレットが開いている場合は🐞
        let sa:CGFloat = (big - 1.0)*vHeight//境界線が上に動く距離
        //shortToolBar(横向きの場合のみ)のY位置を調整(SE対策)
        if boundWidthX != boundWidth{  //_landscapeの場合--------------
            
         if !bigFlag{  //_拡大画面に移行する場合
            print("◆◆◆◆ landscapeの場合 ◆◆◆◆")
            var tY = shortToolBar.frame.maxY//第２ツ_ールバーの下側の位置
            let mY = myToolView.frame.minY - sa//拡大時の編集バーの上側の位置
            let sH = shortToolBar.frame.height//第２ツールバーの高さ
                if tY > mY {tY = mY
                 var newPosY = boundWidth - big*vHeight - myToolView.frame.height - sH/2 - 1
                 newPosY = newPosY < sH/2 ? sH/2 : newPosY
                 shortToolBar.layer.position = CGPoint(x:(boundHeight + boundWidth)/2,y:newPosY) //y:navH + 44/2)
                 print("newPosY: \(newPosY)")
                }
            //スクロールViewのサイズ再設定
                scrollRect_B = CGRect(x:(boundWidth - leafWidth)/2,y: 3,width:leafWidth, height:boundWidth - big*vHeight - 40 - 5)
                //ステータスバー(メモの背景としてとして使う）の高さ再設定
                statusBarBackground.frame.size = CGSize(width:boundWidth,height:boundWidth - big*vHeight - 40)
                //メモの右側の影
            let shadowL = boundWidth - big*vHeight - 40
            shadow.frame.size = CGSize(width:6,height:shadowL)
            if shadowL < 46 {shadow.backgroundColor = UIColor.clear}
            let jinesH2 = jinesH < vHeight/2 ? 0 :jinesH - vHeight/2
            jinesView.frame.size = CGSize(width: boundWidth, height: jinesH2)
            //print("======================================")
            }else {   //拡大画面から通常画面に戻す場合
            //let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
            let navH = boundWidth - vHeight - 40 //statusBarHeight + naviBar.frame.height
            shortToolBar.layer.position = CGPoint(x:(boundHeight + boundWidth)/2,y:navH - 44/2 - 2)
            //ステータスバー(メモの背景としてとして使う）の高さ再設定
            statusBarBackground.frame.size = CGSize(width:boundWidth,height:boundWidth - vHeight - 40)
            //メモの右側の影
            shadow.frame.size = CGSize(width:6,height:boundWidth - vHeight - 40)
            shadow.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            //ジーンズ生地
            jinesView.frame.size = CGSize(width: boundWidth, height: jinesH)
            }
        //-------上記の「landscapeモード専用の if文」はココまで --------------
        }else{ //-------portlaitモード専用-----------------
            //_パレットが拡大表示されている場合のメモ表示サイズ
            let sa:CGFloat = (big - 1.0)*vHeight//境界線が上に動く距離
            scrollRect_B = CGRect(x:(boundWidth - leafWidth)/2,y: 70  + sBarX ,width:leafWidth, height:boundHeight - 20 - th - 44 - vHeight - 50 - sa)//最後の50は目で見て調整した
            //_ ↑ height:画面高さ-_ステタスバー(20?)_ツールバー(46)_ナビバー(44)_vH_sa(vH/2)_myToolBar(40)
        }
 
        //-------以降は「portlait/landscape」両モード（パラメータで切り替える）
            //_palette底辺のy座標
            var zYpos:CGFloat = 0
            if boundWidthX == boundWidth {//_portlait画面の時
                zYpos = boundHeight - th
            }else{ //_landscape画面の場合
                zYpos = boundWidth
            }
        //---- 非拡大画面から拡大画面に移行する　--------------------------
            if drawableView.frame.height == vHeight{//非拡大画面
                print("normalSize:")
                let cx = drawableView.center.x
                //拡大率を1.5倍にする
                drawableView.transform = CGAffineTransform(scaleX: big, y: big)

                drawableView.layer.position = CGPoint(x: big*cx, y:zYpos - big*vHeight/2 )
            //myEditViewの再描画
                myToolView.layer.position = CGPoint(x: self.view.frame.width/2, y:zYpos - vHeight - 40/2 - sa )
                etcBarDisp(disp:0)//マスクビューを非表示にする
            //スクロールviewを合わせる
                myScrollView.frame = self.scrollRect_B// メモframeの値を設定する
            //線幅：☓0.8(少し細くする）
            //停止する事：←シフト、editパネル、OKボタン（⇒専用）、selectNo(),
            bigFlag = true
            //拡大鏡アイコンを表示する
            editButton1.frame.size = CGSize(width:60, height:60)//ボタンサイズを変更
            editButton1.setImage(UIImage(named: "bigW.pdf"), for:UIControlState.normal)
                
        //-----拡大画面から通常画面に戻す---------------------------------
            }else{
                print("bigSize:")
                let cx = drawableView.center.x
                drawableView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)//_元に戻す場合
                drawableView.layer.position = CGPoint(x: cx/big, y:zYpos - vHeight/2 - 1)
            //パレットの左右端の制限
                var cx2 = drawableView.center.x//パレットの中点のｘ座標
                //右端制限
                cx2 = cx2 < (boundWidthX - vWidth/2) ? (boundWidthX - vWidth/2):cx2
                //左端制限
                cx2 = cx2 > vWidth/2 ? vWidth/2:cx2
                drawableView.layer.position = CGPoint(x: cx2, y:zYpos - vHeight/2)
            //myEditViewの再描画
                myToolView.layer.position = CGPoint(x: self.view.frame.width/2, y:zYpos - vHeight - 40/2 )
                etcBarDisp(disp:1)//マスクビューの再追加
            //スクロールviewを元に戻す
                myScrollView.frame = self.scrollRect_P// メモframeの値を設定する
                
            //線幅：元に戻す
            bigFlag = false
            //赤▲アイコンに戻す
            editButton1.frame.size = CGSize(width:40, height:40)//ボタンサイズを元に戻す
            editButton1.setImage(UIImage(named: "3Up.pdf"), for:UIControlState.normal)
                ok2()//★20180814:oomを閉じたときにメモ行を更新する
            }
            
     //★20180814 メモカーソルを更新する
        memoCursol(disp: 1)//カーソル幅と位置をzoom画面ように更新する
        
    }
    
    @IBAction func redo(_ sender: UIBarButtonItem) {
        print("@@ undo @@")
        
        //print("◆◆◆◆undoFLG:\(drawableView.undoMode)")
        //print("bup[10]=\(drawableView.bup["10"])")
        if editFlag == true{return}//編集パネル表示中は🐞
        if drawableView.undoMode == 0{return}
        drawableView.undo()
        //okEnable = true//+-

    }
//=================================================================
//                        その他の関数
//=================================================================
    // ツールバーアイコンの色を黒色にする
    func setToolBar(color:UIColor) {
        print("setToolBar")
        //self.done2.tintColor = color//OKボタンの色を変更する
        self.done2.image = UIImage(named: "ok.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.zoom2.image = UIImage(named: "zoom.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        //png画像を要する：self.redo2.image = UIImage(named: "undo.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        //self.toolBar.barTintColor = UIColor.red//ナビバーの色を変更する
    }
    // ナビゲーションの背景色を変える
    func setNaviBar(color:UIColor) {
       print("setNaviBar")
        var tColor = UIColor.white//初期化
        self.naviBar.barTintColor = color//ナビバーの色を変更する        
        //indexページでリストボタン(左側）以外のボタンを見えなくする
        self.pallete2.isEnabled = true//パレットボタンを表示20180616
        self.menu2.isEnabled = true//メニューボタンを表示20180616
        if color == iColor{
            tColor = iColor
            print("iColor")
            self.pallete2.isEnabled = false//20180616
            self.menu2.isEnabled = false//20180616
            self.navigationItem.rightBarButtonItem?.tintColor = tColor
        }
         //self.naviBar.items?.first?.rightBarButtonItem?.tintColor  = tColor
         self.pallete2.tintColor = tColor
         self.menu2.tintColor = tColor

    }

    //設定値の外部保存
    func settingWite(){
        // NSUserDefaults のインスタンス取得
        let colorNum = String(lineColor)
        let lineWNum = String(lineWidth)
        let autoScroll = autoScrollFlag ? "1" : "0"
        let lPage = String(pageNum)
        let calFlag = callig ? "1" : "0"
        
        let ud = UserDefaults.standard
        // キーを指定してオブジェクトを保存
        ud.set(colorNum, forKey: "color")
        ud.set(lineWNum, forKey: "width")
        ud.set(autoScroll, forKey: "auto")
        ud.set(lPage, forKey: "page")
        ud.set(calFlag, forKey: "cal")

        ud.synchronize()
        
    }
    func settingRead(){
        let ud = UserDefaults.standard
        //キーを指定してオブジェクトを読み込み
        if ud.object(forKey: "color") == nil{return}
        if ud.object(forKey: "auto") == nil{return}
        if ud.object(forKey: "page") == nil{return}
        if ud.object(forKey: "cal") == nil{return}
            
        let colorNum = ud.object(forKey: "color") as! String
        let lineWNum = ud.object(forKey: "width") as! String
        
        lineColor = Int(colorNum)!
        lineWidth = Int(lineWNum)!
        
        let autoScroll = ud.object(forKey: "auto") as! String
        let at = Int(autoScroll)!
        autoScrollFlag = (at == 1) ? true : false
        
        let lPage = ud.object(forKey: "page") as! String
        lastPage = Int(lPage)!
        
        let calFlag = ud.object(forKey: "cal") as! String
        let ca = Int(calFlag)!
        callig = (ca == 1) ? true : false
      
    }
    
    // <未使用>　UIViewの内容をDocumentディレクトリにPDFファイルで出力する？？？？
    func pdfMake(vi: UIView, path: String) {
        UIGraphicsBeginPDFContextToFile(path, CGRect.zero, nil)
        //renderView(view)
        if let context = UIGraphicsGetCurrentContext() {
            
            UIGraphicsBeginPDFPageWithInfo(vi.frame, nil)
            vi.layer.render(in: context)
            
        }
        print("pdfを作ります2！")
        UIGraphicsEndPDFContext()
        print("pdfを作ります3！")
    }
    
    //メモのスクロール位置を設定する
    func scrollPos(){
    //現在のタグ行がスクロール窓から隠れているかをチェック
        
          //print("スクロール窓の高さ:\(scrollRect_P.height)")
          //print("何行目?:\(nowGyouNo%100)")
          //print("オフセット：\(myScrollView.contentOffset)")
        //+-+- 子メモが開いている場合(10108-303208)
        let gyou1:Int = nowGyouNo%100// +-+- 子メモ内の行番 $
        let gyou2:Int = (nowGyouNo/100)%100//ベース行を計算 $
        let gyou3:Int = gyou1 + gyou2
        //+-+- 子メモが開いていない場合
        let gyou4:Int = nowGyouNo%100
        
        //+-+- 画面上での行番号
        let gyou = nowGyouNo<10000 ? gyou4 : gyou3//$何行目が選ばれたか
        let os:CGPoint = myScrollView.contentOffset//現状のオフセット
        let iti = topOffset + CGFloat(leafHeight + leafMargin)*CGFloat(gyou) - os.y//現状の表示位置
        print("タグ行の下線の位置:\(iti)")
        //スクロール量を計算する
        var maxIti = scrollRect_P.height - myEditView.frame.height//スクロール可否の閾値

        if boundWidthX != boundWidth{ //portlait画面だけはoffsetは正の値だけとする
            maxIti = maxIti + topOffset - 7
        }//landscape画面では制限を変える
        var saIti = iti - maxIti//差（移動量）
        saIti = (os.y + saIti)<0 ? -os.y : saIti
        //使用しないif iti > maxIti{//下方向へのスクロールだけ可能とする
            UIScrollView.animate(withDuration: 0.3, animations: {
                () -> Void in
                self.myScrollView.contentOffset = CGPoint(x:0,y:os.y + saIti)
            })
           
        //}

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
            // == [INDEXページ] ==
            if isIndexMode == true{
              //登録されてない頁番号の場合は、パスする
                //let shou:Int = nowGyouNo
                //空ページの場合は処理しない
                if mx[String(nowGyouNo)] == 0{return}//mx[1〜30]は空フラグとして使用
                if Double(mx[String(nowGyouNo)]!) > 30{return}//念のため：ダメな対応
              //飛び先ページを指定
                //-------
                let nextNum = nowGyouNo//myScrollView.selectedTag//タッチしたtag番号:Int[0ページの為tag番号（一桁）がページ番号を現す。]
                print("===========\(String(describing: nextNum))====================")
                let im = readPage(pn:nextNum!)//im:外部から取得する
                fNum = 1
                memo[fNum].setMemoFromImgs(pn:nextNum!,imgs:im)
                retNum = fNum//表示するフレーム番号
                //--------
              //Indexボタンを押す
                self.index(self.index2)
              //ページ番号を更新する
                pageNum = nextNum!
                //naviBar.topItem?.title = String(pageNum) + " /30"
                tl.text = String(pageNum) + " /30"
                naviBar.topItem?.titleView = tl
                //飛び先のtag番号を決定する
                nowGyouNo = nextNum!*100 + 1
            // ** [メモページ] **
            }else if myEditFlag{
                print("myEditFlag: \(String(describing: myEditFlag))")
            }else{
            print(" == [メモページの場合] ==")
              // 仮想的にeditボタンを押す
              let nextNum = nowGyouNo
              self.Pallete(self.pallete2)//パレットを開く
                print("isEdit: \(String(describing: isPalleteMode))")
              self.modalChanged(TouchNumber:nextNum!)//セルを選択
              memo[fNum].togglleCursol()
            }
        }
        myScrollView.isLongPushed = true//touchBeginsでfalseにリセットする
    }

  /* --------------　外部データ入出力関係　----------------------- */
    
    //外部のページデータを読み込む: photos”pn”[] ->[UIImage]
  
    func XXreadPage(pn:Int)->[UIImage]{//親子メモともに共通
        //+-+- -- ブランク画像をを作成する --
        let blankView = UIView(frame: CGRect(x:0,y:0,width:10,height:10)).GetImage()
        let bImage2 = (pn == 0) ? bImage : blankView
        
        //let blankView = UIView(frame: CGRect(x:0,y:0,width:10,height:10))
        //+-+- 新しいページで大きな画像を作ってしまっています。なので修正しました。
        //+-+-let blankView = UIView(frame: CGRect(x:0,y:0,width:leafWidth,height:leafHeight))
        // let bImage2:UIImage = blankView.GetImage()
        
        let retImgs = reloadToPage(pn:pn)//UserDataをpageImmgs[]に読み込む
        print("retImgs.count:\(retImgs.count)")
        if retImgs.count > 0{ return retImgs }
        else{ //外部データが無い場合は空白の目ページImgsを作成する
            print("//外部データが無い場合")
            //子メモの場合は8行とする
            let count = (pn<100) ? pageGyou : pageGyou2
            //+-+-　↑　子メモの場合はpn = (nowGyouNo)とする$
            //例）①pn:1から30,②子メモの場合pn:101から130,…,301から330
            let blankImgs:[UIImage] = Array(repeating: bImage2!, count: count)//+-+-
            //mx[]を初期化する
            
            return blankImgs
        }
    }
    func readPage(pn:Int)->[UIImage]{//親子メモともに共通+-+- 32行対応版$
        //+-+- -- ブランク画像をを作成する --
        let blankView = UIView(frame: CGRect(x:0,y:0,width:10,height:10)).GetImage()
        let bImage2 = (pn == 0) ? bImage : blankView
        let gnum = (pn == 0) ? maxPageNum :pageGyou
        
        var retImgs = reloadToPage(pn:pn)//UserDataをpageImmgs[]に読み込む
        //retImgs.countがpageNumより小さい時にはblankViewを追加する
        let rc = retImgs.count
        if rc > 0{
            if rc<gnum {
                for _ in 1...(pageGyou - rc){
                    retImgs.append(bImage2!)
                }
            }
            return retImgs }
            
        else{ //外{部データが無い場合は空白の目ページImgsを作成する
            print("//外部データが無い場合")
            //子メモの場合は8行とする
            let count = (pn<1000) ? pageGyou : pageGyou2
            //+-+-　↑　子メモの場合はpn = (nowGyouNo)とする$
            //例）①pn:1から30,②子メモの場合pn:101から130,…,301から330
            let blankImgs:[UIImage] = Array(repeating: bImage2!, count: count)//+-+-
            return blankImgs
        }
    }
    
    ///UserDwfaultに保存のメモ画像をpageImgs:[]に読み込む
    func reloadToPage(pn:Int)->[UIImage] {
        var imgs:[UIImage] = []
        let photoData = UserDefaults.standard
        // [UIImage] → [NSData]
        photoData.synchronize()
        
        let photosName:String = "photos" + String(pn)//保存名
        //NSData から画像配列を取得する
        if photoData.object(forKey: photosName) != nil{
            let images = photoData.object(forKey: photosName) as! [NSData]
        //+-+- 子メモの場合は8行：pageGyou2に変更する$
          var gyou = (pn<1000) ? pageGyou : pageGyou2
          if images.count < gyou {gyou = images.count}//+-+- 32行UP対応
           for k in 0...gyou - 1{
            imgs.append(UIImage(data:images[k] as Data, scale: CGFloat(retina))!)
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
      if pn == 0{// 全キーidの内容を削除
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
    //過去のブランクデータ(Index)のサイズが10x10の場合bImageに置き換える
    func initBlank(){
        for n in 0...indexImgs.count - 1{
            if indexImgs[n].size.width == 10{
                indexImgs[n] = bImage
            }
        }
        
    }
    
    //palleteのdone実行時にページデータからIndex内容を更新する
    func indexChange(pn:Int,usedNum:Int)-> UIImage{
      
        //新しくコンテナView１つと3つのImageViewを作る
        var indexFView:UIView!
        var img01:UIImageView!
        var img02:UIImageView!
        var cont02:UIView!//img02を入れる箱View
        var img03:UIImageView!
        
        indexFView = UIView(frame: CGRect(x:5,y: 210,width:leafWidth,height:leafHeight))
        img01 = UIImageView(frame:CGRect(x:5,y:2 + 2,width:leafHeight*2/3 + 5,height:leafHeight - 4 - 3))
        img02 = UIImageView(frame:CGRect(x:leafHeight*1/3,y:0 + 2,width:leafWidth - 120 - 25
            ,height:leafHeight - 10))
        cont02 = UIView(frame:CGRect(x:leafHeight*2/3 + 20,y:0 + 2,width:leafWidth - 120
            ,height:leafHeight - 4))
        img03 = UIImageView(frame:CGRect(x:leafWidth - leafHeight*4/3 - 2,y:0,width:leafHeight*4/3 - 8,height:leafHeight))
        //枠線,色,角丸
        img01.layer.borderWidth = 3
        img01.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        img01.layer.cornerRadius = 3
        cont02.layer.borderWidth = 2
        cont02.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        cont02.layer.cornerRadius = 10
        cont02.layer.masksToBounds = true
        
        img03.layer.borderWidth = 1
        img03.layer.borderColor = UIColor.white.cgColor
        img03.layer.cornerRadius = 20

        img01.backgroundColor = UIColor.clear
        cont02.backgroundColor = UIColor.yellow.withAlphaComponent(0.05)//white.withAlphaComponent(0.8)
        img03.backgroundColor = UIColor.purple.withAlphaComponent(0.15)

        //Viewの内容を作成
        //パレット全画面の切り取り????
        let tag:Int = pn*100 + usedNum
        let rt = CGFloat(retina)
        let targetIV = memo[fNum].viewWithTag(tag) as! UIImageView
        var tImage = targetIV.image
        //ピクセル画像のサイズ:leaf画像サイズを変更した場合は要サイズ調整!
        //+-+ tImage画面サイズが複数の場合にも対応する必要がある
        //+-+ いつでもtImageのサイズをパレットの1/3に変換する
        tImage = tImage?.ResizeUIImage(width: vWidth/3, height: vHeight/3)
        
        let pixWidth:CGFloat = vWidth/3 * rt//leafWidth! * rt
        let pixHeight:CGFloat = vHeight/3 * rt//leafHeight * rt
        //切り取りサイズ
        let clip02 = CGRect(x:10,y:0,width: pixWidth - 130*rt,height: pixHeight)

        //ピクセル画面での切り取り
        let clipImage02 =  (tImage?.cgImage!)!.cropping(to: clip02)
         print("◆◆CGIサイズ:\(String(describing: tImage?.cgImage?.width)):index画面")
         print("◆◆clipImage02サイズ:\(String(describing: clipImage02?.width))")
        
        //UIImageに変換
        img02.image = UIImage(cgImage: clipImage02!)

        //3つのViewを合成して１つのコンテナViewにする
        //subViewを全て削除する
        let subviews = indexFView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
        img01.backgroundColor = UIColor.clear
        indexFView.removeFromSuperview()

        
        cont02.addSubview(img02)
        indexFView.addSubview(cont02)
        indexFView.addSubview(img01)
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
        return orgImage.addIndexText(text:st,rect:img03.frame.offsetBy(dx: 3, dy: 4))
      
    }
 
   /* -------------------　mx[]更新関係　---------------------------- */
    
    ///該当するページのmx[]値をリセットする(0を指定すると全頁をリセット）
    /* mx[] */
    func clearMx(pn:Int){
      if pn != 0{
         for n in 0..<pageGyou{
            let tg = pn*100 + n + 1
            mx[String(tg)] = 0
         }
      }else{
        for a in 1...30{
           for n in 0..<pageGyou{
            let tg = a*100 + n + 1
            mx[String(tg)] = 0
           }
        }
      }
    }
    
    /* resn[] リサイズ回数 */
    func clearResn(pn:Int){//+-+
        if pn != 0{
            for n in 0..<pageGyou{
                let tg = pn*100 + n + 1
                resn[String(tg)] = 0
            }
        }else{
            for a in 1...30{
                for n in 0..<pageGyou{
                    let tg = a*100 + n + 1
                    resn[String(tg)] = 0
                }
            }
        }
    }


    //対象ページの非空白行のうち一番小さい行番号を返す
    //全行空白行の場合は０を返す
    func numOfUsedLine(pn:Int)->Int{
        
        var ret:Int = 0
        var tg:Int = 101

          for i in 0..<pageGyou {
            print("aaa???\(i)")
            tg = pn*100 + (pageGyou - i)
            if Int(mx[String(tg)]!)>50{
                ret = pageGyou - i  //1 〜 30
            }
          }
        
        return ret
    }
    //+-+- 子メモの全行空白行の場合は0を返す
    func checkUsedLine(tag:Int)->Int{
      var ret:Int = 0
      var tg:Int = 101
        for i in 0..<pageGyou2 {
            tg = tag*100 + i + 1
            if mx[String(tg)] == nil{continue}
            if Int(mx[String(tg)]!)>30{
                ret = ret + 1
            }
        }
      return ret
    }
    
    //Dictionary型のデータの読込
    /* mx[] */
    func loadMx()->[String:CGFloat]{//+-+- 32ページ化対応$
        var img:[String:CGFloat] = mx
        let photoData = UserDefaults.standard
        photoData.synchronize()
        let photosName:String = "index"//保存名
        //NSData から画像配列を取得する
        print("aa aa")
        if photoData.dictionary(forKey: photosName) != nil{
            img = photoData.dictionary(forKey: photosName) as! [String : CGFloat]
            //データが不足の場合は0を追加する
            for p in 1...maxPageNum{//全30ページ
                for g in 0...pageGyou{
                    let s = String(p*100 + g)
                    if img[s] == nil{ img[s] = 0 }//存在しない場合は０を追加する
                }
            }
            //mx[]にindexリストを追加する[1:0,2:0…]:[頁No:使用時は1]
            for p in 1...pageGyou{
                let s = String(p)
                if img[s] == nil{ img[s] = 0 }//存在しない場合は０を追加する
            }
            
        }else{//データが保存されていない場合
            print("cc cc")
            //mx[]の初期化
            for p in 1...maxPageNum{
                for g in 0...pageGyou{
                    let s = String(p*100 + g)
                    img[s] = 0
                }
            }
            //mx[]にindexリストを追加する[1:0,2:0…]:[頁No:使用時は1]
            for p in 1...pageGyou{
                let s = String(p)
                img[s] = 0
            }
            
        }
        return img
    }
    
    func xxloadMx()->[String:CGFloat]{//imageのprogramから流用したため変数名imgが変？
        var img:[String:CGFloat] = mx
        let photoData = UserDefaults.standard
        photoData.synchronize()
        let photosName:String = "index"//保存名
        //NSData から画像配列を取得する
        print("aa aa")
        if photoData.dictionary(forKey: photosName) != nil{
            img = photoData.dictionary(forKey: photosName) as! [String : CGFloat]
            
            //データが保存されていない場合
        }else{
            print("cc cc")
            //mx[]の初期化
            for p in 1...30{
                for g in 0...pageGyou{
                    let s = String(p*100 + g)
                    img[s] = 0
                }
            }
            //mx[]にindexリストを追加する[1:0,2:0…]:[頁No:使用時は1]
            for p in 1...pageGyou{
                let s = String(p)
                img[s] = 0
            }
            
        }
        return img
    }

    
    /* resn[] リサイズ回数 */
    func loadResn()->[String:Int]{//+-+ imageのprogramから流用したため変数名が変？
        var img:[String:Int] = resn
        let photoData = UserDefaults.standard
        photoData.synchronize()
        let photosName:String = "resize"//保存名
        //NSData から画像配列を取得する
        print("bb bb")
        if photoData.dictionary(forKey: photosName) != nil{
            img = photoData.dictionary(forKey: photosName) as! [String : Int]

        //indexデータが保存されていない場合
        }else{
            print("bb bb")
            //resn[]の初期化
            for p in 1...30{//1-30ページ
                for g in 0...pageGyou{//1-30行
                    let s = String(p*100 + g)
                    img[s] = 0
                }
            }
        }
        return img
    }

    
    //Dictionary型のデータを保存
    /* mx[] */
    func updataMx(my:[String:CGFloat]){
        let photoData: UserDefaults = UserDefaults.standard
        let photosName:String = "index" //保存名を決定
        let dataImg:[String:CGFloat] = my
        photoData.set(dataImg, forKey: photosName)
        photoData.synchronize()
    }
    
    /* resn[] リサイズ回数 */
    func upResn(my:[String:Int]){//+-+
        let photoData: UserDefaults = UserDefaults.standard
        let photosName:String = "resize" //保存名を決定
        let dataImg:[String:Int] = my
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
        let msg = (langFlag == 0) ? "実行してもいいですか？":"Are you sure run it?"
        //--------------------------
        if num == 5{
            fc5()//設定画面を開く
        }else if num != 7 && num != 4{

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
        let cancel = (langFlag == 0) ? "キャンセル":"Cancel"
        let cancelAction: UIAlertAction = UIAlertAction(title: cancel, style: UIAlertActionStyle.cancel, handler:{
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
    
    // ============== リストメニュー選択時の処理 =================== //
    
    func fc1(){// [ 日付を追加する ]
        //タイトル行が空白の場合はパス
        if Int(mx[String(pageNum*100 + 1)]!)<50{
        // アラート表示
        let alert = UIAlertView()
        alert.title = (langFlag == 0) ? "タイトルが未記入です！":"Title is blank!"
        alert.message = (langFlag == 0) ? "１行目にタイトルを記載して下さい。":"Write the title on the first line."
        alert.addButton(withTitle: "OK")
        alert.show();
        return
        }
        memo[fNum].addDate(pn:pageNum)//日付追加
        //+-+-マークとして扱う:mx[String(pageNum*100 + 1)]! = vWidth - 10//mx[]を右端に設定
        //mx[String(nowGyouNo)] = vWidth - 10//mx[]を右端に設定
        //編集中のページ内容を更新する
        let im = memo[fNum].memoToImgs(pn: pageNum)//im:
        //メモ内容を外部に保存
        writePage(pn: pageNum, imgs: im)
        //INDEX内容を外部に保存
        writePage(pn:0, imgs:indexImgs)
        //mx[]の内容を外部に保存する
        updataMx(my:mx)

    /*
        print("test1!!!!!PDF-write")
        let dst = NSHomeDirectory() + "/Documents" + "/test.pdf"
        let v1 = UIView(frame: CGRect(x:0,y:0,width:100,height:500))
        v1.backgroundColor = UIColor.red
        print("pdfを作ります！")
        self.pdfMake(vi:v1, path: dst)
    */
    }
    
    func fc2(){// [ 現行ベージの内容を削除する ]
        print("fc2()!!  = oyaGyou: \(oyaGyou) =")
        //+-+- 現在開いている子メモの内容を削除する
        if childFlag == true{
            //+-+- 子メモページを閉じる
            //let dammy = nowGyouNo<10000 ? (nowGyouNo*100 + 1):nowGyouNo
            //childMemoClose(ngn:oyaGyou*100 + 1)//(ngn:dammy!)
            childMemoClose(ngn:oyaGyou)//★20180823
            //子メモのデータを削除・初期化する
            delChild(baseGyou: oyaGyou)
            //▽マークを削除する
            memo[fNum].add3Mark(baseTag:oyaGyou,del:true)
            childFlag = false
            return
        }
        
        //indexリストに対象の頁番号を登録を抹消する(登録済頁だけがタッチ反応する）
        if pageNum <= maxPageNum{ //間違って行のmxを削除しないための保護
            print("mx[String(pageNum)]B:\(String(pageNum))")
            mx[String(pageNum)] = 0
        }
        
        delPage(pn: pageNum)
        //----- 現行ページを再読込する---------
        let im = readPage(pn:pageNum)//im:現在ページの外部データを読み込む
        memo[fNum].setMemoFromImgs(pn:pageNum,imgs:im)
        
        //------- index頁を更新する-----------------
        clearMx(pn:pageNum)//該当するページのmx[]値をリセット
        updataMx(my:mx)//mx[]のデータを外部に保存
        clearResn(pn: pageNum)//+-+
        upResn(my: resn)//+-+
        
        //現行頁(空白)情報をindex頁に反映させる
        //インデックス情報を更新する
        let uNum = numOfUsedLine(pn:pageNum)//入力行最小値を取得
        if uNum > 0{
            //index画像を更新する
            indexImgs[pageNum - 1] = indexChange(pn: pageNum,usedNum:uNum )
            mx[String(pageNum)] = 1//indexリストに対象の頁番号を登録する
        }else{ //全行が空白行の場合
            if pageNum <= maxPageNum{ //間違って行のmxを削除しないための保護
            print("mx[String(pageNum)]C:\(String(pageNum))")
            mx[String(pageNum)] = 0
            }
            indexImgs[pageNum - 1] = bImage//空白の画像をインデックス頁に貼り付ける
        }
        //+-+- ---- 本ページの子メモ内容を全て削除する$ -----
        for g in 1...pageGyou{
            let baseGyou = pageNum*100 + g
            let photosName:String = "photos" + String(baseGyou)//保存名を決定
            let userDefault = UserDefaults.standard
            userDefault.removeObject(forKey: photosName)
        }
        //子メモのmxを初期化する$
        for g in 1..<pageGyou{//pageGyou:8
            let gyou = pageNum*100 + g
            for c in 1...pageGyou2 {
                let last = gyou*10 + c
                if mx[String(last)] != nil{
                    mx[String(last)] = 0
                }
            }
        }

        childFlag = false
    }

    func fc3(){// [ 現行ページをJPEGファイル出力する ]
        print("test3!!!!!")
        var im = memo[fNum].GetImage()
        im = printImage(image:im)
        savePageImage(img: im)

    }
    
    func fc5(){ // [ = 設定 = ]
        print("test5!!!!!")
        //設定項目名の定義
        let sT_Ja:[String] = ["決定","戻る","-- 線の太さ --","-- 線の色 --","-- 自動スクロール --","-- 全ページを削除 --","削除する","実行しない"]
        let sT_En:[String] = ["Set","Cancel","-- LINE WIDTH --","-- LINE COLOR --","-- AUTO SCROLL --","-- DELETE ALL --","DLETE-ALL","NO ACTION"]
        var sT = (langFlag == 0) ? sT_Ja:sT_En//言語による切り替え
        
        setV2 = UIView(frame:CGRect(x:0,y:0,width: 400, height: 600))//表示初期値
        setV2.backgroundColor = UIColor.white
        setV2.layer.position = CGPoint(x: self.view.bounds.width / 2,y:self.view.bounds.height * 0.53)
        setV2.layer.cornerRadius = 7
        setV.addSubview(setV2)
        //部品のコンテントVIew
        let cv = UIView(frame: CGRect(x:0,y:0,width:300,height:500))
        cv.layer.position = CGPoint(x: self.view.bounds.width / 2,y:self.view.bounds.height * 0.53)
        //決定ボタン
        setButtonY = UIButton(frame: CGRect(x:210, y:0, width:80,height: 30))
        setButtonY.backgroundColor = UIColor.orange.withAlphaComponent(0.80)
        setButtonY.layer.cornerRadius = 8
        setButtonY.addTarget(self, action: #selector(ViewController.okBtn(sender:)), for:.touchUpInside)
        setButtonY.setTitle(sT[0], for: UIControlState.normal)
        //setButtonN.tintColor = UIColor.lightGray
        
        //キャンセルボタン
        setButtonN = UIButton(frame: CGRect(x:10, y:0, width:80,height: 30))
        setButtonN.backgroundColor = UIColor.lightGray
        setButtonN.layer.cornerRadius = 8
        //setButtonN.layer.borderColor = UIColor.red.cgColor
        //setButtonN.layer.borderWidth = 1
        setButtonN.addTarget(self, action: #selector(ViewController.cancelBtn(sender:)), for:.touchUpInside)
        setButtonN.setTitle(sT[1], for: UIControlState.normal)
        //setButtonN.tintColor = UIColor.lightGray
        //------- セグメント01---------------------------------------------------
        // 表示する配列を作成する.
        let myArray: NSArray = ["thin","normal","thic"]
        let sW:CGFloat = 50
        // SegmentedControlを作成する.
        let sc: UISegmentedControl = UISegmentedControl(items: myArray as [AnyObject])
        let scBox = UIView(frame: CGRect(x:130,y:150,width:sW*3,height:sW))
        //scBox.backgroundColor = UIColor.lightGray
        scBox.layer.position = CGPoint(x: cv.frame.width/2, y: 175 - 40)
        let scBox1 = UIView(frame: CGRect(x:5,y:30,width:sW - 10,height:sW/10))
        let scBox2 = UIView(frame: CGRect(x:sW + 5,y:30,width:sW - 10,height:sW/7))
        let scBox3 = UIView(frame: CGRect(x:sW*2 + 5,y:30,width:sW - 10,height:sW/5))
        scBox1.backgroundColor = UIColor.darkGray
        scBox2.backgroundColor = UIColor.darkGray
        scBox3.backgroundColor = UIColor.darkGray
        scBox.addSubview(scBox1)
        scBox.addSubview(scBox2)
        scBox.addSubview(scBox3)
       
        sc.setWidth(sW, forSegmentAt: 0)
        sc.setWidth(sW, forSegmentAt: 1)
        sc.setWidth(sW, forSegmentAt: 2)
        sc.center = CGPoint(x:sW*3/2, y: 0)
        sc.layer.borderColor = UIColor.lightGray.cgColor
        sc.backgroundColor = UIColor.white
        sc.tintColor = UIColor.gray
        sc.selectedSegmentIndex = lineWidth
        // イベントを追加する.
        sc.addTarget(self, action: #selector(segconChanged(segcon:)), for: UIControlEvents.valueChanged)
        /*
        //セパレータ-------------------------------------------------------------
        let sep1 = UIView(frame: CGRect(x:5,y:170,width:290,height:0.3))
        //UIView(frame: CGRect(x:20,y:170,width:300 - 40,height:0.5))
        sep1.backgroundColor = UIColor.gray
        //setV2.addSubview(sep1)
        //セパレータ2
        let sep2 = UIView(frame: CGRect(x:5,y:300,width:290,height:0.3))
        sep2.backgroundColor = UIColor.gray
        //setV2.addSubview(sep2)
        //セパレータ3
        let sep3 = UIView(frame: CGRect(x:5,y:400,width:290,height:0.3))
        sep3.backgroundColor = UIColor.gray
        setV2.addSubview(sep3)
        */
        //------- セグメント02---------------------------------------------------
        
        // 表示する配列を作成する.
        let myArrayB: NSArray = ["Blue","Green","Brown"]
                let sWB:CGFloat = 50
        // SegmentedControlを作成する.
        let scB: UISegmentedControl = UISegmentedControl(items: myArrayB as [AnyObject])
        let scBoxB = UIView(frame: CGRect(x:130,y:280 - 60,width:sWB*3,height:sWB))
        let scBox1B = UIView(frame: CGRect(x:5,y:30,width:sWB - 10,height:sWB/3))
        let scBox2B = UIView(frame: CGRect(x:sWB + 5,y:30,width:sWB - 10,height:sWB/3))
        let scBox3B = UIView(frame: CGRect(x:sWB*2 + 5,y:30,width:sWB - 10,height:sWB/3))
        scBox1B.backgroundColor = UIColor.blue
        scBox1B.layer.cornerRadius = 10.0
        scBox2B.backgroundColor = UIColor.green
        scBox2B.layer.cornerRadius = 10.0
        scBox3B.backgroundColor = UIColor.brown
        scBox3B.layer.cornerRadius = 10.0
        scBoxB.addSubview(scBox1B);
        scBoxB.addSubview(scBox2B)
        scBoxB.addSubview(scBox3B)
        scB.setWidth(sWB, forSegmentAt: 0);
        scB.setWidth(sWB, forSegmentAt: 1)
        scB.setWidth(sWB, forSegmentAt: 2)
        scB.center = CGPoint(x:sWB*3/2, y: 0)
        scB.layer.borderColor = UIColor.lightGray.cgColor
        scB.backgroundColor = UIColor.white
        scB.tintColor = UIColor.gray
        scB.selectedSegmentIndex = lineColor
        // イベントを追加する.
        scB.addTarget(self, action: #selector(segconChangedB(segcon:)), for: UIControlEvents.valueChanged)
 
        //------- セグメント03(Boxなし)-----------------------
        
        // 表示する配列を作成する.
        let myArrayC: NSArray = [sT[6],sT[7]]//["DLETE-ALL","NO ACTION"]
        let sWC:CGFloat = 120
        // SegmentedControlを作成する.
        let scC: UISegmentedControl = UISegmentedControl(items: myArrayC as [AnyObject])

        scC.setWidth(sWC, forSegmentAt: 0)
        scC.setWidth(sWC, forSegmentAt: 1)
        scC.center = CGPoint(x:cv.frame.width/2, y:cv.frame.height/2 + 190 + 30)
        scC.layer.borderColor = UIColor.lightGray.cgColor
        scC.backgroundColor = UIColor.white
        scC.tintColor = UIColor.gray
        scC.selectedSegmentIndex = 1
        // イベントを追加する.
        scC.addTarget(self, action: #selector(segconChangedC(segcon:)), for: UIControlEvents.valueChanged)
        //------------セグメントSw(Boxなし)------------------------------
        // Swicthを作成する.
        let mySwicth: UISwitch = UISwitch()
        mySwicth.layer.position = CGPoint(x: cv.frame.width/2, y: cv.frame.height/2 + 100)
        mySwicth.tintColor = UIColor.gray
        // SwitchをOnに設定する.
        mySwicth.isOn = autoScrollFlag ? true :false
        // SwitchのOn/Off切り替わりの際に、呼ばれるイベントを設定する.
        mySwicth.addTarget(self, action: #selector(ViewController.onClickMySwicth(sender:)), for: UIControlEvents.valueChanged)
        
        // On/Offを表示するラベルを作成する.
        myLabel = UILabel(frame: CGRect(x:cv.frame.width/2 + 60,y: 330,width:100,height:40))
        myLabel.text = autoScrollFlag ? "[ ON  ]" : "[ OFF ]"
        
        //--------------------------------------------------------------
        // Labelを作成.
        let lb1: UILabel = UILabel(frame: CGRect(x:20,y:50,width:200,height:40))
        //lb1.backgroundColor = UIColor.yellow
        lb1.text = sT[2]//"LINE-WIDTH"
        // Labe2を作成.
        let lb2: UILabel = UILabel(frame: CGRect(x:20,y:220 - 60,width:200,height:40))
        //lb2.backgroundColor = UIColor.yellow
        lb2.text = sT[3]//"LINE-COLOR"
        let lb2a: UILabel = UILabel(frame: CGRect(x:20,y:280 - 60,width:30,height:30))
        lb2a.backgroundColor = UIColor.black
        lb2a.layer.masksToBounds = true
        lb2a.layer.cornerRadius = 6
        let lb2b: UILabel = UILabel(frame: CGRect(x:55,y:280 - 60,width:30,height:30))
        lb2b.backgroundColor = UIColor.red
        lb2b.layer.masksToBounds = true
        lb2b.layer.cornerRadius = 6
        let lb2c: UILabel = UILabel(frame: CGRect(x:100,y:280 - 60,width:30,height:30))
        lb2c.text = "＋"
        //lb2c.backgroundColor = UIColor.black
        // LabeSwを作成.
        let lbSw: UILabel = UILabel(frame: CGRect(x:20,y:270 + 20,width:250,height:40))
        lbSw.text = sT[4]//"AUTO-SCROLL"
        // Labe3を作成.
        let lb3: UILabel = UILabel(frame: CGRect(x:20,y:370 + 30,width:250,height:40))
        //lb3.backgroundColor = UIColor.yellow
        lb3.text = sT[5]//"DELETE-ALL(PAGES)"
        //コンテナに追加する
        scBox.addSubview(sc)
        scBoxB.addSubview(scB)
        cv.addSubview(scBox)
        cv.addSubview(scBoxB)
        cv.addSubview(scC)
        cv.addSubview(self.setButtonN)
        cv.addSubview(self.setButtonY)
        cv.addSubview(lb1)
        cv.addSubview(lb2);cv.addSubview(lb2a);cv.addSubview(lb2b)
        cv.addSubview(lb2c)
        cv.addSubview(lb3)
        cv.addSubview(lbSw)
        cv.addSubview(mySwicth)
        cv.addSubview(myLabel)
        // コンテナをseVに追加する.
        setV.addSubview(cv)
        //setVを表示する
        self.view.addSubview(setV)
        
        UIScrollView.animate(withDuration: 0.2, animations: {
        () -> Void in
            self.setV2.frame.size = CGSize(width: 300, height: 520)
        //self.setV2.layer.position = CGPoint(x:boundWidth / 2,y:boundHeight * 0.53)
          self.setV2.layer.position = CGPoint(x:boundWidth / 2,y:self.view.bounds.height * 0.53)
        })

    }
    
    ///設定画面実行関数
    func onClickMySwicth(sender: UISwitch){
        if sender.isOn {
            myLabel.text = "[ ON  ]"
            tempAutoScroll = true
        }
        else {
            myLabel.text = "[ OFF ]"
            tempAutoScroll = false
        }
    }
    
    func segconChanged(segcon: UISegmentedControl){//線幅
        switch segcon.selectedSegmentIndex {
            case 0:tempLineW = 0
            case 1:tempLineW = 1
            case 2:tempLineW = 2
            default:break
        }
        print("tempLineW:\(tempLineW)")
    }
    
    func segconChangedB(segcon: UISegmentedControl){//追加線色
        switch segcon.selectedSegmentIndex {
            case 0:tempColor = 0
            case 1:tempColor = 1
            case 2:tempColor = 2
            default:break
        }
        print("tempColor=\(tempColor)")
    }
    
    func segconChangedC(segcon: UISegmentedControl){//全頁削除
        switch segcon.selectedSegmentIndex {
            case 0:tempDelAll = 1// 削除する場合
            case 1:tempDelAll = 0
            default:break
        }
    }

    ///キャンセル処理
    func cancelBtn(sender:UIButton){
        print("cancelBtn")
        setButtonN.removeFromSuperview()
        setV2.removeFromSuperview()
        setV.removeFromSuperview()
        //setFlag = false
        //fc5()
    }
    ///決定処理
    func okBtn(sender:UIButton){
        print("okBtn：\(tempDelAll)")
      if tempDelAll == 1{//全削除が選択された場合
        let itm = (langFlag == 0) ? "全ページの内容を削除します":"Delete contents of all pages"
        let msg = (langFlag == 0) ? "本当に実行しても宜しいですか？":"Are you sure run it?"
        let alert: UIAlertController = UIAlertController(title: itm, message: msg, preferredStyle:  UIAlertControllerStyle.alert)
        
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            
            //---- ページ削除処理の実行 ----
              print("全ページの内容を削除します!!!!")
              self.delPage(pn: 0)//全ページ削除する
              self.clearMx(pn: 0)//全ページのmx[]をリセットする
              self.clearResn(pn: 0)//+-+ 全ページのresn[]をリセットする
              //現行ベージの内容を削除する
              self.delPage(pn: pageNum)
            
              //-- １ページを再読込する --
              pageNum = 1
              let im = self.readPage(pn:pageNum)//im:現在ページの外部データを読み込む
              self.tl.text = String(pageNum) + " /30"
              self.naviBar.topItem?.titleView = self.tl//頁番号を再表示する
              memo[fNum].setMemoFromImgs(pn:pageNum,imgs:im)
  
              //-- index頁のリセット --
              for idx in 0..<pageGyou{
                //空白の画像をインデックス頁に貼り付ける
                indexImgs[idx] = bImage//UIImage(named:"blankW.png")!
                //indexリストの登録頁をリセットする(登録済頁だけがタッチ反応する）
                mx[String(idx)] = 0
              }
              memo[0].setIndexFromImgs(imgs:indexImgs)
            //---- ここまで[ ページ削除処理の実行 ]----
            //ペン仕様の初期化
            lineWidth = 1//線幅
            lineColor = 0//三番目の線色
            //設定viewを閉じる
            self.setButtonN.removeFromSuperview()
            self.setV2.removeFromSuperview()
            self.setV.removeFromSuperview()

        })
        
        // キャンセルボタン
        let cancel:String = (langFlag == 0) ? "キャンセル":"Cancel"
        let cancelAction: UIAlertAction = UIAlertAction(title: cancel, style: UIAlertActionStyle.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in print("Cancel")
        })
        
        alert.addAction(cancelAction)// ③ UIAlertControllerにActionを追加
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)// ④ Alertを表示
      }else{
        //線幅の設定値を反映させる
        lineWidth = tempLineW
        //線色の設定値を反映させる
        lineColor = tempColor
        //自動スクロールOn/Off設定を反映させる
        autoScrollFlag = tempAutoScroll
        //設定viewを閉じる
        self.setButtonN.removeFromSuperview()
        self.setV2.removeFromSuperview()
        self.setV.removeFromSuperview()
        //永久保存する
        settingWite()
      }
        tempDelAll = 0
    }
    
    func fc6(){// [ スタートガイド ]
        print("test6!!!!!")
        //------helpViewの作成----------
        if helpView != nil{return}
           helpView = HelpView(frame: CGRect(x:0, y:64,width:boundWidth, height:boundHeight - 64 - 2.5*sBarX))
           helpView.backgroundColor = UIColor.white
           helpView.layer.borderColor = UIColor.white.cgColor//UIColor.lightGray.cgColor
           helpView.layer.borderWidth = 1
           helpView.delegate = self
           helpView.scalesPageToFit = true
/*
        var pinch:UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action:"pinchZoom:")
        helpView.addGestureRecognizer(pinch)
 */
           helpView.req(lang:langFlag)
           helpFrame.addSubview(helpView)
           helpFrame.addSubview(helpTop)
           helpFrame.layer.position.x = -boundWidth/2
           self.view.addSubview(helpFrame)
        //アニメーション
        UIView.animate(withDuration: 0.5, animations: {
            helpFrame.layer.position.x = boundWidth/2
        }, completion: {(Bool) -> Void in
        })

    }
    
   /* ----------------------　ボタン関数　-----------------------------*/
    
    //エディット画面を非表示にする
    func closeEditView(){
        if myEditFlag == false { return }
        editButton1.backgroundColor = UIColor.clear
        //editButton1.setTitle("💠", for: UIControlState.normal)
        editButton1.setImage(UIImage(named: "3Up.pdf"), for:UIControlState.normal)
        myEditView.removeFromSuperview()
        drawableView.secondView.cursolView.removeFromSuperview()
        myEditFlag = false; editFlag = false
        drawableView.secondView.isUserInteractionEnabled = false
        penMode()//ペンモードに戻す
    }///
    
    func btn1_click(sender:UIButton){
        print("** btn1_click()")
        //+- okEnable = true//メイン画面のokボタンの受付を許可する
        if bigFlag == true{
           zoom(zoom2)
           return
        }

        if myEditFlag == false{//エディット画面非表示の場合は表示する
            //??done(done2)// okボタンを押す
            //?? 最大文字位置を保存する：編集パネルでも使用するためここでも保存する必要あり
            mx[String(nowGyouNo)] = mxTemp
            clearSelect()//編集ツールを非選択状態にする
            editButton1.backgroundColor = UIColor.clear
            //editButton1.setTitle("⬇", for: UIControlState.normal)
            editButton1.setImage(UIImage(named: "3Down.pdf"), for:UIControlState.normal)
            //無理やり色を変えています
            editButton1.tintColor = UIColor.darkGray
            self.view.addSubview(myEditView)
            myEditFlag = true
            editFlag = false//前者:エディット画面,後者:エディット選択モード
            //パレット画面のイベントの非透過
            drawableView.secondView.isUserInteractionEnabled = true
            //パレットボタンをリセットする
            editButton2.backgroundColor = UIColor.init(white: 0.75, alpha: 0)
            editButton3.backgroundColor = UIColor.init(white: 0.75, alpha: 0)
            editButton4.backgroundColor = UIColor.init(white: 0.75, alpha: 0)
            //◆◆◆◆redo対応
            drawableView.undoMode = 3
            //??drawableView.get1VImage()
            drawableView.get3VImage(open:1)//編集前画面を保存する
            cursolWFlag = false//カーソル巾５以下フラグにリセットする
            //??done(done2)// okボタンを押す
        }else{//エディット画面を非表示にする
            closeEditView()
            //drawableView.myMx = 0 //今回タッチした最大X座標(タイマースクロール用）
            //drawableView.autoScrollFlag = false
            
        }
    }
    
    func btn2_click(sender:UIButton){
        closeEditView()//パレット編集画面を閉じる
        print("btn2_clicked!：ペン色切り替え")
        if myEditFlag == true{return}//編集画面が表示の場合はパス
        if drawableView.X_color == 1{return}//ペンモード以外はパス
        if penColorNum == 1 {
            penColorNum = 2
            editButton2.setImage(UIImage(named: "red.png"), for:UIControlState.normal)
        }else if penColorNum == 2{
            penColorNum = 3
            var thirdColor:UIImage!
            
            switch lineColor {
              case 0:thirdColor = UIImage(named: "blue.png")
              case 1:thirdColor = UIImage(named: "green2.png")
              case 2:thirdColor = UIImage(named: "brown2.png")
              default:break
            }
            editButton2.setImage(thirdColor, for:UIControlState.normal)
        }else{
            penColorNum = 1
            editButton2.setImage(UIImage(named: "black2.png"), for:UIControlState.normal)
        }
    }
    
    func penWclicked(){
        print("☑️☑️double-clickされました！！")
        trf = false
        switch lineWidth {
            case 0:lineWidth = 2
            case 1:lineWidth = 0
            case 2:lineWidth = 1
            default:break
        }
        penMode()//
    }///WC
    func penMode(){
        //if myEditFlag == true{return}//編集画面が表示の場合はパス
        closeEditView()//パレット編集画面を閉じる
        drawableView.X_color = 0//ペンモード[黒色、赤色、青色?]
        penColorNum = 1//黒色
        editButton2.setImage(UIImage(named: "black2.png"), for:UIControlState.normal)
        editButton3.backgroundColor = UIColor.init(white: 0.9, alpha: 1)
        editButton4.backgroundColor = UIColor.init(white: 0.75, alpha: 0)
        editButton3.layer.borderWidth = 1.0//★20180821:0.5
        editButton4.layer.borderWidth = 0
        // //WC
        var penImg:UIImage!
        if callig {
         switch lineWidth {
            case 0:penImg = UIImage(named: "gpen00.pdf")
            case 1:penImg = UIImage(named: "gpen01.pdf")
            case 2:penImg = UIImage(named: "gpen02.pdf")
            default:penImg = UIImage(named: "gpen01.pdf")
            }
         }else{
         switch lineWidth {
            case 0:penImg = UIImage(named: "pen0.pdf")
            case 1:penImg = UIImage(named: "pen3.pdf")
            case 2:penImg = UIImage(named: "pen1.pdf")
            default:penImg = UIImage(named: "pen1.pdf")
            }
         }
         editButton3.setImage(penImg, for:UIControlState.normal)
         //
        
    }///
    func btn3_click(sender:UIButton){
        print("btn3_clicked!：ペンモード")
        if drawableView.X_color != 0{//ペンモード以外の場合
            closeEditView()//パレット編集画面を閉じる
            penMode()
        }else{
          print("既にペンモードですよ！！")//WC
          if trf == true{penWclicked()}
          else{
            trf = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){self.trf = false}//0.5秒後にtrfをfalseに変更する
            }
            
            
        }
    }
    
    func btn4_click(sender:UIButton){
        print("btn4_clicked!:消しゴム")
        //if myEditFlag == true{return}//編集画面が表示の場合はパス
        closeEditView()//パレット編集画面を閉じる
        drawableView.X_color = 1//消しゴムモード
        editButton2.setImage(UIImage(named: "white.png"), for:UIControlState.normal)
        editButton4.backgroundColor = UIColor.init(white: 0.9, alpha: 1)
        editButton3.backgroundColor = UIColor.init(white: 0.75, alpha: 0)
        editButton4.layer.borderWidth = 1.0//★20180821:0.5
        editButton3.layer.borderWidth = 0
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
        cursolWFlag = false//カーソル巾５以下フラグにリセットする
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
        cursolWFlag = false//カーソル巾５以下フラグにリセットする
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
        cursolWFlag = false//カーソル巾５以下フラグにリセットする
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
        if myInt == "CLR"{return}//"CLR"モードの時はパス
        if editFlag == true && cursolWFlag == true{
           //カーソル表示変更
            let cStart:CGFloat = drawableView.secondView.cursolStartX
            let cEnd:CGFloat = 0
            drawableView.secondView.cursolEndX = cEnd
            drawableView.secondView.changeMyCursolView2(curX: cEnd, startX:cStart)
           
        }else{
        /*
            //パレットの表示位置をリセットする
            //アニメーション動作をさせる
            UIView.animate(withDuration: 0.3, animations: {
            () -> Void in
            drawableView.layer.position = CGPoint(x:vWidth/2, y:boundHeight - th - vHeight/2)
            })
        */
        }
    }
    
    func btn10_click(sender:UIButton){
        print("btn10_clicked!")
        if myInt == "CLR"{return}//"CLR"モードの時はパス
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
        /*
            //パレットの表示位置を末尾にする
            UIView.animate(withDuration: 0.3, animations: {
            () -> Void in
            drawableView.layer.position = CGPoint(x:boundWidth - vWidth/2, y:boundHeight - th - vHeight/2)
            })
         */
        }
 
    }
    func Ja_click(sender:UIButton){
        langFlag = 0
        //表示言語を切り替える
        items = items_Ja
        tV.reloadData()
        hl.text = (langFlag == 0) ? "スタートガイド":"Start-Guide"
        helpView.req(lang:langFlag)
    }
    func En_click(sender:UIButton){
        langFlag = 1
        items = items_En
        tV.reloadData()
        hl.text = (langFlag == 0) ? "スタートガイド":"Start-Guide"
        helpView.req(lang:langFlag)
    }
    func Re_click(sender:UIButton){//ヘルプ画面を閉じる
        //アニメーション
        UIView.animate(withDuration: 0.5, animations: {
            helpFrame.layer.position.x = -boundWidth/2
        }, completion: {(Bool) -> Void in
            helpView.removeFromSuperview()
            helpView = nil
            self.helpTop.removeFromSuperview()
            
        })
    }
    
   /* -------------------　スワイプ関数　---------------------------- */
    
    func swipeR(){
        if isIndexMode! { return }//Indexが表示中は実行しない
        if isPalleteMode! { return }//パレットが表示中は実行しない
        if pageNum == 1{ return }//１ページが最終ページ
        //+-+- 子メモが表示されている時は
        //if childFlag == true{ return}
        //★20180815子メモが開いている場合は子メモを閉じる
        if childFlag == true{ childMemoClose(ngn: oyaGyou)}
        for n in 0...2{//ボーダーラインを付ける(ページめくりの時の枠）
            memo[n].layer.borderColor = UIColor.gray.cgColor
            memo[n].layer.borderWidth = 1
        }
        var f = 0
        f = (fNum == 1) ? 2: 1
        //-------
        let im = readPage(pn:pageNum - 1)//im:
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
                self.tl.text = String(pageNum) + " /30"
                self.naviBar.topItem?.titleView = self.tl
        })
        fNum = f
        //--------
        pageNum -= 1
        //nowGyouNoの更新
        nowGyouNo = pageNum * 100 + 1
        myScrollView.contentOffset.y = 0//スクロール位置：TOP
        //naviBar.topItem?.title = String(pageNum) + " /30"
        
        //--------
    }
    
    func swipeL(){
        if isIndexMode! { return }
        if isPalleteMode! { return }//パレットが表示中は実行しない
        if pageNum >= 30{ return }
        //+-+- 子メモが表示されている時は
        //if childFlag == true{ return}
        //★20180815子メモが開いている場合は子メモを閉じる
        if childFlag == true{ childMemoClose(ngn: oyaGyou)}
        
        for n in 0...2{
            memo[n].layer.borderColor = UIColor.gray.cgColor
            memo[n].layer.borderWidth = 1
        }

        var f = 0
        f = (fNum == 1) ? 2: 1//フレームのトグル
        //-------
        let im = readPage(pn:pageNum + 1)//im:
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
                    self.tl.text = String(pageNum) + " /30"
                    self.naviBar.topItem?.titleView = self.tl
                })
        fNum = f
        //-----------
        pageNum += 1
        //naviBar.topItem?.title = String(pageNum) + " /30"
        
        //nowGyouNoの更新
        nowGyouNo = pageNum * 100 + 1
        myScrollView.contentOffset.y = 0//スクロール位置：TOP
    }
    
    func wClick(){//+-+-
        if myEditFlag {return} //★20180821
        if bigFlag {return}//+-+- ◆◆子メモ機能を無効にする
        if isIndexMode == true {
            longPress()//+-+-$$
        return }//index表示中は実行しない
        //if drawableView != nil { return }//パレット表示中は実行しない
        
        print("wClick():childFlag=\(childFlag)")
        if childFlag == false{
            childMemoOpen(tag: nowGyouNo)
        }else{
            childMemoClose(ngn:nowGyouNo)
        }
    }
  
   /* -------------------　プロトコル関数　-----------------------------*/
    
    func modalChanged(TouchNumber: Int) {// protocol ScrollViewDelegate
        print("TouchNumber:@\(TouchNumber)")
        print("fNum:\(fNum)")
        if myEditFlag{return}//★20180820
        if bigFlag == true{
            return//★20180814 ←zoom(zoom2)//倍率を元に戻す
        }
            //タッチ行を登録する前に、直前の行番号を記憶する★20180813
            memoCursol(disp: 0)//現在の行カーソルを削除する
            nowGyouNo = TouchNumber
            //print("nowGyouNo?: \(nowGyouNo)")
        
        //対象行のTag番号のleafViewのmaxPosXをmxTempにコピーする。
        //但し、INDEXページではmx[1〜30]はページ登録フラグとして使用している為↓
        //Indexページでもmx[]を使用する
           mxTemp = mx[String(nowGyouNo)]
  
        //パレット表示中
        if isPalleteMode == true{
            if myEditFlag == true{ closeEditView()}//編集パネルを閉じる
           //_★★メモのスクロール位置を設定(変更）する
            scrollPos()
                
           //メモに書き出した内容をパレットに読み込む//20161024追加
            let myMemo:UIImage = memo[fNum].readMemo(tag: nowGyouNo)
           //選択されたセルに色を付ける
            memo[fNum].selectedNo(tagN: nowGyouNo)

   print("######4")
           //_パレットの表示位置をリセット(左端を表示）する
            drawableView.layer.position = leftEndPoint// CGPoint(x:vWidth/2, y:boundHeight - th - vHeight/2)

           //パレット表示用にリサイズする(extension)？読み込む画像はどこから？myMemo
           //上のreadMemo(tag: nowGyouNo)の中ですでにリサイズしている為以下省略する
            /* ====================================================
                let reSize = CGSize(width: vWidth, height: vHeight)
                let reMemo = myMemo.resize(size: reSize)
            //==================================================== */
            
            let reMemo = myMemo//上記を省略した為追加した。
            drawableView.backgroundColor = UIColor(patternImage: reMemo)
        print("######5")
            //◆◆◆◆
            //セカンドViewの初期画面をブランク画像として保存
            print("\(String(describing: nowGyouNo))")//$
            print("mx-nowGyouNo:\(String(describing: mx[String(nowGyouNo)]))")//$
            drawableView.bup["20"] = (bImage,mx[String(nowGyouNo)]!)
            //パレットViewの初期画面を保存
        print("######6")
            drawableView.bup["1"] = (reMemo,mx[String(nowGyouNo)]!)
            drawableView.undoMode = 1
            //??drawableView.get1VImage()//パレット画面を保存する
           
            drawableView.lastDrawImage = nil//21061213に追加
            drawableView.secondView.backgroundColor = UIColor.clear
            //UNDO関連の初期化
            drawableView.undoMode = 0 // resetUndo()
            okEnable = false//+- メモ読み込み時に一旦、書き込み不可にする（リセット）
            m2pFlag = true//+-+ メモ読み込み時に一旦、リサイズ回数追加を可能とする（リセット）
        }else if isIndexMode == true{
        //パレット非表示の場合
            memo[fNum].selectedNo(tagN:nowGyouNo)
        }else{}
    /*
        print("** nowGyouNo: \(nowGyouNo)")
        print("◆imgサイズ：\(img.size.height)")
        print("🔳cg-imgサイズ：\(img.cgImage?.height)")
    */
        print("######7")
        //メモカーソルを表示する★20180812
        memoCursol(disp: 1)
    }
    //_パレットの表示位置を変更する
    func dispPosChange(midX: CGFloat,deltaX:CGFloat){
        // protocol UpperToolViewDelegate
        //print("midX: \(midX)")
        let b = (bigFlag == true) ? big:1
        var midX2 = midX
        let topX:CGFloat = (b*vWidth/2)
        let lastX:CGFloat = (boundWidthX - b*vWidth/2)
        var pY:CGFloat = 0//_パレットのセンター座標
        if boundWidthX == boundWidth{//_portlait画面の場合
            pY = (boundHeight - b*vHeight/2 - th)
        }else{//_landscape画面の場合
            pY = (boundWidth - b*vHeight/2)
        }
        let dir = deltaX>=0 ? 1 : 0 //0:右へシフト,1:左へシフト
        //先頭へシフトする場合
        if dir == 0{
           if drawableView.frame.midX >= topX{//Viewの中心のX座標
             drawableView.layer.position = CGPoint(x: topX, y:pY)
           }
        //末尾にシフト
        }else if dir == 1{
            if drawableView.frame.midX < lastX{//Viewの中心のX座標
                drawableView.layer.position = CGPoint(x: lastX, y:pY)
            }
        }
        if midX > topX{ midX2 = topX}
        if midX < lastX{ midX2 = lastX}
        drawableView.layer.position = CGPoint(x: midX2, y:pY)
        //スクロールするとメモカーソルが更新される
        memoCursol(disp: 1)//★20180813
        
    }
    /* ------------------------ デリゲート関数　-------------------------- */
    
    var scrollBeginingPoint: CGPoint!
    
    func scrollViewWillBeginDragging(myScrollView: UIScrollView) {
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
    func test(){
        print("test")
        memoCursol(disp: 1)
    }
    
    func selectNextGyou() {//$$$$
        print("★selectNextGyou")
        
        //lastGyouNo = nowGyouNo//★20180812追加
        memoCursol(disp: 0)//★20180812追加
        done(done2)// okボタンを押す
        print("nowGyouNo2:\(String(describing: nowGyouNo))")
        if nowGyouNo<10000 && nowGyouNo%100 < pageGyou{
    print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
           modalChanged(TouchNumber:nowGyouNo + 1)
        }
        //+-+- 子メモ行の場合$
        if nowGyouNo>10000 && nowGyouNo%10 < pageGyou2{
    print("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb")
            modalChanged(TouchNumber:nowGyouNo + 1)
        }
        
    }
    func shiftMX(){
        done(done2)// okボタンを押す
    }
    //--------------------------------------------------------------------
    
    /**   ======== photo libraly関連 =========　  **/

    //印刷画面のレイアウトを定義する
    func printImage(image:UIImage)->UIImage{
        var retImage = image//仮に設定しておく
       switch traitCollection.userInterfaceIdiom {
    //= iPhoneの場合　=　2列に分割して印刷する
    case .phone:
            
        let rt = CGFloat(retina)// = 2
        //— 切り取り関連 —
        let mh = image.size.height - topOffset
        //切り取り窓の設定（切り取り位置）
        let rect01 = CGRect(x:0,y:topOffset*rt,width:image.size.width*rt,height:(mh/2 + 3)*rt)
        let rect02 = CGRect(x:0,y:(topOffset + mh/2 + 3)*rt,width:image.size.width*rt,height:mh/2*rt)
       
        let clipImg01 = image.cgImage!.cropping(to:rect01)//*retinaのサイズ
        let clipImg02 = image.cgImage!.cropping(to:rect02)
 
        let clip01U:UIImage = UIImage(cgImage: clipImg01!)
        let clip02U:UIImage = UIImage(cgImage: clipImg02!)
        
        //印刷レイアウトview
        let baseW:CGFloat = leafWidth*2 + 50
        let baseH:CGFloat = mh/2 + 180
        let baseView = UIView(frame:CGRect(x:0,y:0,width:baseW,height:baseH))//A4サイズに対応した枠View
        //貼り付け位置の設定
        let clipView01 = UIImageView(frame:CGRect(x:10,y:80,width:image.size.width,height:mh/2))
        let clipView02 = UIImageView(frame:CGRect(x:baseW - leafWidth - 10,y:80 + 3,width:image.size.width,height:mh/2))
        clipView01.image = clip01U
        clipView02.image = clip02U
        baseView.addSubview(clipView01)
        baseView.addSubview(clipView02)
        //baseView.backgroundColor = UIColor.red.withAlphaComponent(0.1)
        baseView.layer.borderColor = UIColor.black.cgColor
        baseView.layer.borderWidth = 1.5
        //ページ番号を挿入する
        let label = UILabel(frame: CGRect(x:baseW/2 - 30,y:5,width:150,height:50))
        label.font = UIFont(name: "Cooper Std", size: 24)
        label.text  = "( " + String(pageNum) + " /30 )"
        baseView.addSubview(label)
        //サイズ調整の為縮小する(実サイズ☓２倍pix ➡1/4倍にする
        let tempImage = baseView.GetImage()
        retImage = downSize(image: tempImage, scale: 2)
        
    //= iPadの場合　=　1列のまま印刷する
    case .pad:
        //印刷レイアウトview
        //print("layout of iPad⬜")
        let baseView = UIView(frame:CGRect(x:0,y:0,width:image.size.width + 100,height:image.size.height + 100))
        let clipView03 = UIImageView(frame:CGRect(x:50,y:80,width:image.size.width,height:image.size.height))
        clipView03.image = image
        baseView.addSubview(clipView03)
        //baseView.backgroundColor = UIColor.blue.withAlphaComponent(0.3)
        baseView.layer.borderColor = UIColor.black.cgColor
        baseView.layer.borderWidth = 1.5
        //ページ番号を挿入する
        let label2 = UILabel(frame: CGRect(x:baseView.frame.width/2 - 30,y:10,width:100,height:50))
        label2.font = UIFont(name: "Cooper Std", size: 24)
        label2.text  = "( " + String(pageNum) + " /30 )"
        baseView.addSubview(label2)
        //サイズ調整の為縮小する(実サイズ☓２倍pix ➡1/4倍にする
        let tempImage2 = baseView.GetImage()
        retImage = downSize(image: tempImage2, scale: 2)
    default:break
        }
        return retImage
    }
    
    // UIImage の画像をカメラロールに画像を保存
    func savePageImage(img: UIImage) {
        let targetImage = img
        
        //UIImageWriteToSavedPhotosAlbum(targetImage, nil, nil, nil)
        UIImageWriteToSavedPhotosAlbum(targetImage, self, #selector(self.showResultOfSaveImage(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    // 保存を試みた結果をダイアログで表示
    func showResultOfSaveImage(_ image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer) {
        var title = (langFlag == 0) ?"JPEG形式で保存完了":"Saving in JPEG format completed"
        var message = (langFlag == 0) ?"カメラロール [写真]）に保存しました":"saved  to the camera-roll [Photos]"
        if error != nil {
            title = (langFlag == 0) ?"エラー!":"error!"
            message = (langFlag == 0) ?"保存に失敗しました":"Saving failed"
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // OKボタンを追加
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        // UIAlertController を表示
        self.present(alert, animated: true, completion: nil)
        }
    
    func downSize(image: UIImage, scale: Int) -> UIImage {

        let ref: CGImage = image.cgImage!
        let srcWidth: Int = ref.width
        let srcHeight: Int = ref.height
        //var myScale:Int!
        let newWidth = srcWidth / scale
        let newHeight = srcHeight / scale
        let size: CGSize = CGSize(width: newWidth, height: newHeight)
        //再描画をする
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(x:0,y:0,width:size.width,height:size.height))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizeImage!
    }
    
    func childMemoOpen(tag:Int){//+-+- 子メモを開く$
        if childFlag == true{return}
        //空白行の場合は子メモは開かない
        if mx[String(nowGyouNo)]!<10{return}
        //print("●◉●\(mx[String(nowGyouNo)])")
        //子メモを開く
        oyaGyou = nowGyouNo//親行を記憶する
        childFlag = true
        let im = readPage(pn:nowGyouNo)//im:１ページ目の外部データを読み込む
        subMemo.setMemoFromImgs2(bt:nowGyouNo,imgs:im)//bt:basetag
        //子メモの分だけスクロール表示範囲を大きくする
        var addGyou = (nowGyouNo%100 + pageGyou2) - pageGyou//はみ出す分を計算
        addGyou = addGyou > 0 ? addGyou :0//はみ出す分だけ追加する
        myScrollView.contentSize = CGSize(width:leafWidth,height:(leafHeight + leafMargin) * CGFloat(pageGyou + addGyou + memoLowerMargin) + topOffset)
        
        //子メモviewの作成
        print("777777777")
        subMemoView.removeFromSuperview()//一旦、子メモを削除する
        //let rect1:CGRect = CGRect(x:0, y:0, width:leafWidth, height:5)//$$
        let rect2:CGRect = CGRect(x:0, y:0, width:leafWidth, height:(leafHeight + leafMargin)*CGFloat(pageGyou2) + leafMargin + 5)//$$
        subMemoView.frame = rect2//$$ アニメーション時はrect1を使用する
        posOffset = topOffset + (leafHeight + leafMargin)*CGFloat(tag%100) + 5//- leafMargin //- leafHeight/2
        let cvHeigt:CGFloat = subMemoView.layer.bounds.height
        subMemoView.layer.position.y = posOffset + cvHeigt/2
        subMemoView.backgroundColor = UIColor.clear
        subMemo.backgroundColor = childColor
        //+-+- シャドウカラー
         subMemoView.layer.masksToBounds = false
         subMemoView.layer.shadowColor = UIColor.black.cgColor/* 影の色 */
         subMemoView.layer.shadowOffset = CGSize(width:0,height: 1)//  シャドウサイズ
         subMemoView.layer.shadowOpacity = 0.5 // 透明度
         subMemoView.layer.shadowRadius = 15 //←8 角度(距離）
         //
        subMemoView.addSubview(subMemo)//$$ アニメーション時は削除
        memo[fNum].addSubview(subMemoView)
        print("nowGyouNo:\(String(describing: nowGyouNo))")
        addMx(gyou:nowGyouNo)//子メモのmxをmx[]に追加する
/*
    // == アニメーション動作 ==
        subMemo.layer.borderColor = UIColor.clear.cgColor
        UIScrollView.animate(withDuration: 0.1, animations: {
            () -> Void in
            subMemoView.frame = rect2
            let cvHeigt:CGFloat = subMemoView.layer.bounds.height
            subMemoView.layer.position.y = posOffset + cvHeigt/2
        }){ (Bool) -> Void in  // アニメーション完了時の処理
            subMemoView.addSubview(subMemo)
            subMemo.layer.borderColor = childColor.cgColor
        }
*/
        
        
    }
    func addMx(gyou:Int){//子メモのmxを追加する
        //var img:[String:CGFloat] = mx
        let childMx = gyou*100 + pageGyou2//$子メモのラストタグ番号
        if mx[String(childMx)] == nil{//この子メモの登録がない場合
            //子メモのmx[]の初期化
            //mx[]にindexリストを追加する[1:0,2:0…]:[頁No:使用時は1]
            for p in 1...pageGyou2{
                let s = String(gyou*100 + p)//$
                mx[s] = 0
            }
            
        }

    }
    
    func childMemoClose(ngn:Int){//+-+- 子メモを閉じる$
        print("----childMemoClose-----\(String(describing: nowGyouNo))")
        print("childMemoClose()  = oyaGyou: \(oyaGyou) =")
        if childFlag == false{return}
        //if ngn<10000{return}//子メモ内をWクリックした時だけ処理する//1000
        //親行をクリックしたときだけ
        if ngn != oyaGyou{return}
        let baseTag:Int = oyaGyou
        //子メモが全空白かどうかをチェックする
        let x = checkUsedLine(tag:baseTag)
        print("空白？：\(x)")
        if x == 0{//空白の場合はマークを削除する
            memo[fNum].add3Mark(baseTag:baseTag,del:true)
        }else{//空白でない場合はマークを追加する
            memo[fNum].add3Mark(baseTag:baseTag,del:false)
        }
        //編集中のページ内容を更新する
        //現行のページ内容を外部に保存
        let im = memo[fNum].memoToImgs(pn: pageNum)//im:
        writePage(pn: pageNum, imgs: im)
        //子メモ内容を外部に保存
        let im2 = subMemo.memoToImgs2(pn: baseTag)
        writePage(pn: baseTag, imgs: im2)
        subMemo.removeFromSuperview()
        subMemoView.removeFromSuperview()//一旦、子メモを削除する?必要？
        //子メモの分だけスクロール表示範囲を小さくする（元に戻す）
        myScrollView.contentSize = CGSize(width:leafWidth,height:(leafHeight + leafMargin) * CGFloat(pageGyou + memoLowerMargin) + topOffset)
        
        childFlag = false
    }
    
    //+-+- 子メモの内容を削除する$
    func delChild(baseGyou:Int){
        if baseGyou>10000{return}//$$ 1000
        //子メモのmxを初期化する
        for i in 1...pageGyou2 {
            let gyou = baseGyou*100 + i
            if mx[String(gyou)] != nil{
                mx[String(gyou)] = 0
            }
        }
        
        //+-+-  nowGyouNoの子メモデータを削除
        let photosName:String = "photos" + String(baseGyou)//保存名を決定
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: photosName)
    }
    
 /* ---------------------pageGyouNo, baseGyou $$$----------------------
     (<10000)       (>10000)
     01p:101-132    child:10101-10108,13201-13208
     10p:1001-1032  child:100101-100108,103201-103208
     20p:2001-2032  child:200101-200108,203201-203208
     30p:3001-3032  child:300101-300108,303201-303208
 ---------------------------------------------------------------- */
    func memoCursol(disp:Int){//_★20180812:メモにカーソルを表示(1),非表示(0)
        if isPalleteMode == true{
        print("+nowGyouNo: \(String(describing: nowGyouNo))")
        let zm:CGFloat = bigFlag ? 1.5 : 1.0//★20180814
        //_????
        var len =  boundWidthX/4/zm
        let pos = (vWidth*zm/2 - drawableView.layer.position.x)/4/zm
            //let add = bigFlag ? len : 0//★20180814
            //let pos = (vWidth/2 - drawableView.layer.position.x)/4/zm + add
            //   print("palette pos: \(pos), allW: \(vWidth)")
        //選択されたセルを探す
        let targetMemo:UIView = memo[fNum].viewWithTag(nowGyouNo)!
            if disp == 0{ len = 0}
        //１行目と３２行目の下線は実践、他は破線
            //let clr = UIColor.rgb(r: 0, g: 141, b: 183, alpha: 1)
            if nowGyouNo > 10000{
                targetMemo.addLineForChild(color: UIColor.magenta, lineWidth: 1.7, posX: pos, lenX: len,spaceX: 7)
            }else if
                nowGyouNo < 10000 && (nowGyouNo%100 == 1 || nowGyouNo%100 == 32){
                print("aaaaaaaaaa:\(zm)")
                targetMemo.addCursolLine2(color: UIColor.blue, lineWidth: 2.0, lineSize: 2, spaceSize: 2, posX: pos, lenX: len)
            }else{
                print("bbbbbbbbb:\(zm)")
                targetMemo.addCursolLine(color: UIColor.blue, lineWidth: 1.5, lineSize: 2, spaceSize: 2, posX: pos, lenX: len)
            }
        }
    }
    //★20180821:アラート追加
    func showAlert(){
        print("===showAlert()=== \(langFlag)")
        //バイリンガル処理
        let title = (langFlag == 0) ? "** ペン先変更 **":"** Change pen tip **"
        let cancel = (langFlag == 0) ? "キャンセル":"Cancel"
        let msg_F = (langFlag == 0) ? "鉛筆モードに変更します！":"Change to pencil- mode!"
        let msg_G = (langFlag == 0) ? "Gペンモードに変更します！":"Change to Gpen- mode!"
        let msg:String = callig ? msg_F : msg_G
        //--------------------------------------------------
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title:cancel,style:.cancel))
        alert.addAction(UIAlertAction(title:"OK",style:.default,handler: {action in
            self.ActionPenMode()
        }))
        self.present(alert,animated: true,completion: nil)
    }
    func ActionPenMode(){
        callig = callig ? false : true
        penMode()
    }
    
  //----------------------------------------------------------------
  //                  旧ボタン関数(未使用）                             |
  //----------------------------------------------------------------
/*   
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

*/
/* ------------------  AirPrint  -------------------------------
     func showPrinterPicker(image:UIImage) {
     // UIPrinterPickerControllerのインスタンス化
     let printerPicker = UIPrinterPickerController(initiallySelectedPrinter: nil)
     // UIPrinterPickerControllerをモーダル表示する
     switch traitCollection.userInterfaceIdiom {
     case .phone:
     printerPicker.present(animated: true, completionHandler: {
     [unowned self] printerPickerController, userDidSelect, error in
     if (error != nil) {
     // エラー
     print("Error : \(error)")
     } else {
     // 選択したUIPrinterを取得する
     if let printer: UIPrinter = printerPickerController.selectedPrinter {
     print("Printer : \(printer.displayName)")
     self.printToPrinter(printer: printer,pi:image)//印刷
     } else {
     print("Printer is not selected")
     }
     }
     })
     case .pad:
     print("iPad is selected!!")
     let rect = CGRect(x:boundWidth/2,y:boundHeight/2,width:100,height:100)
     printerPicker.present(from: rect, in: self.view, animated: true , completionHandler: {
     [unowned self] printerPickerController, userDidSelect, error in
     if (error != nil) {
     // エラー
     //print("Error : \(error)")
     } else {
     // 選択したUIPrinterを取得する
     if let printer: UIPrinter = printerPickerController.selectedPrinter {
     //print("Printer's URL : \(printer.URL)")
     self.printToPrinter(printer: printer,pi:image)
     } else {
     //print("Printer is not selected")
     }
     }
     })
     default:break
     }
     }
     
     func printToPrinter(printer: UIPrinter,pi:UIImage) {
     //印刷画像を用意する
     let printImage:UIImage = pi
     // 印刷してみる
     let printIntaractionController:UIPrintInteractionController = UIPrintInteractionController.shared
     
     let info = UIPrintInfo(dictionary: nil)
     info.jobName = "Sample Print"
     info.orientation = .portrait
     printIntaractionController.printInfo = info
     printIntaractionController.printingItem = printImage
     printIntaractionController.print(to: printer, completionHandler: {
     controller, completed, error in
     
     })
     }
*/
//-----------------------------------------------------------------------------

}
