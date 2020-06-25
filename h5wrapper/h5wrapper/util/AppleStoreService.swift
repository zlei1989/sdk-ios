//
//  AppleStoreService.swift
//  sdk
//
//  Created by 张磊 on 2017/9/22.
//  Copyright © 2017年 北京远程悦动信息技术有限公司. All rights reserved.
//

// 引用类库
import Foundation
import StoreKit

/// 支付对象
public class AppleStoreService {
    
    // 单件对象
    public static let `default` = AppleStoreService()
    
    // 状态监听
    private var shareTransactionObserver:SPTransactionObserver?
    
    // 商品信息请求
    private var shareRequestDelegate:SPRequestDelegate?
    
    // 订单通知机制
    private var notifier:Notifier = Notifier()
    
    // 购买商品标识
    private var lastProductIdentifier:String?
    
    // 商品金额
    private var lastAmount:Int?
    
    // 内部交易订单
    private var lastTradeNo:String?
    
    // 通知回调网址
    private var lastNotifyUrl:String?
    
    // 状态通知方法
    private var lastObserver:((_ code:Int, _ message:String,  _ transactionIdentifier:String?) -> Void)?
    
    /// 获得订单信息存储路径
    ///
    /// - Returns:
    var storageDirectory:String {
        get {
            let dir = NSHomeDirectory() + "/Documents/ICCGAME_SDK/TransactionQueue"
            if FileManager.default.fileExists(atPath: dir) != true {
                try! FileManager.default.createDirectory(at: URL.init(fileURLWithPath: dir), withIntermediateDirectories: true, attributes: nil)
            }
            return dir
        }
    }
    
    // 限制实例
    init () {
        Logger.debug("AppleStoreService.init()")
        // 实例属性
        self.shareRequestDelegate = SPRequestDelegate(storeService: self)
        self.shareTransactionObserver = SPTransactionObserver(storeService: self)
        // 遍历订单
        if let files = try? FileManager.default.subpathsOfDirectory(atPath: self.storageDirectory) {
            Logger.info("AppleStoreService.transactionFiles[%d]", files.count)
            for filename in files.reversed() {
                let arr = filename.components(separatedBy: "_")
                if arr[0] != "Notifying" {
                    continue
                }
                try? self.notifier.add(fileURLWithPath: String(format:"%@/%@", self.storageDirectory, filename))
            }
        }
        // 状态处理
        SKPaymentQueue.default().add(self.shareTransactionObserver!)
    }
    
    /// 发起支付请求
    ///
    /// - Parameters:
    ///   - productIdentifier: 商品标识
    ///   - amount: 金额
    ///   - tradeNo: 平台订单编号
    ///   - notifyUrl: 回调网址
    ///   - observer: 回调方法
    /// - Throws:
    public func request (productIdentifier:String, amount:Int, tradeNo:String, notifyUrl:String, observer:@escaping (_ code:Int, _ message:String,  _ transactionIdentifier:String?) -> Void) throws {
        Logger.info("AppleStoreService.request(productIdentifier:%@, amount:%d)", productIdentifier, amount)
        // 检查支持
        if SKPaymentQueue.canMakePayments() != true {
            throw Error(description: "not supported", code: 111)
        }
        // 检查空闲
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        if self.lastTradeNo != nil {
            throw Error(description: "busy", code: 112)
        }
        // 缓存属性
        self.lastTradeNo = tradeNo
        self.lastProductIdentifier = productIdentifier
        self.lastAmount = amount
        self.lastNotifyUrl = notifyUrl
        self.lastObserver = observer
        // 开始调用
        let productId:NSSet = NSSet(object: productIdentifier)
        let req = SKProductsRequest(productIdentifiers: productId as! Set<String>)
        req.delegate = self.shareRequestDelegate
        req.start()
    }

    
    /// 记录订单数据开始支付
    func startTransaction () {
        Logger.debug("AppleStoreService.startTransaction(productIdentifier:%@)", self.lastProductIdentifier!)
        objc_sync_enter(self)
        let txn = [
            "tradeNo" : self.lastTradeNo!,
            "productIdentifier" : self.lastProductIdentifier!,
            "amount" : self.lastAmount!,
            "notifyUrl" : self.lastNotifyUrl!
            ] as [String:Any]
        let filename = self.storageDirectory + String(format:"/Purchasing_%@_%08x.json", self.lastTradeNo!, self.lastProductIdentifier!.hash)
        let contents = try! JSONSerialization.data(withJSONObject: txn)
        try! contents.write(to: URL(fileURLWithPath: filename))
        objc_sync_exit(self)
    }
    
    
    /// 取消交易
    ///
    /// - Parameter productIdentifier: 商品标识
    func cancelTransaction (productIdentifier:String) {
        Logger.debug("AppleStoreService.startTransaction(productIdentifier:%@)", productIdentifier)
        objc_sync_enter(self)
        if self.lastTradeNo == nil || self.lastProductIdentifier == nil {
            objc_sync_exit(self)
            return
        }
        if self.lastProductIdentifier == productIdentifier {
            objc_sync_exit(self)
            return
        }
        let filename = String(format:"%@/Purchasing_%@_%08x.json", self.storageDirectory, self.lastTradeNo!, self.lastProductIdentifier!.hash)
        try? FileManager.default.removeItem(at: URL(fileURLWithPath: filename))
        objc_sync_exit(self)
    }
    
    /// 完成交易
    ///
    /// - Parameters:
    ///   - transactionIdentifier: 苹果订单编号
    ///   - productIdentifier: 产品标识
    func finishTransaction (transactionIdentifier:String, productIdentifier:String) {
        Logger.debug("AppleStoreService.finishTransaction(productIdentifier:%@)", productIdentifier)
        objc_sync_enter(self)
        // 寻找相似文件
        var pFilename:String? = nil
        if self.lastProductIdentifier != nil && self.lastProductIdentifier == productIdentifier {
            pFilename = String(format:"%@/Purchasing_%@_%08x.json", self.storageDirectory, self.lastTradeNo!, self.lastProductIdentifier!.hash)
        } else if let files = try? FileManager.default.subpathsOfDirectory(atPath: self.storageDirectory) {
            for filename in files.reversed() {
                let arr = filename.substring(to: filename.index(filename.endIndex , offsetBy: -4)).components(separatedBy: "_")
                if arr[0] != "Purchasing" {
                    continue
                }
                if strtol(arr[2], nil, 16) != productIdentifier.hash {
                    continue
                }
                pFilename = self.storageDirectory + "/" + filename
                break
            }
        }
        // 特殊情况处理
        if pFilename == nil {
            // 补单数据
            let val:[String:String] = [
                "transactionIdentifier": transactionIdentifier,
                "receiptData": (try! Data(contentsOf: Bundle.main.appStoreReceiptURL!)).base64EncodedString(),
            ]
            // 写入文件
            let nContents = try! JSONSerialization.data(withJSONObject: val)
            let nFilename = String(format:"%@/Suspended_%@.json", self.storageDirectory, transactionIdentifier)
            try! nContents.write(to: URL(fileURLWithPath: nFilename))
        } else {
            // 内容调整
            let pContents = try! Data(contentsOf: URL(fileURLWithPath: pFilename!))
            var val:[String : Any] = try! JSONSerialization.jsonObject(with: pContents) as! [String:Any]
            val["transactionIdentifier"] = transactionIdentifier
            val["receiptData"] = (try! Data(contentsOf: Bundle.main.appStoreReceiptURL!)).base64EncodedString()
            // 写入文件
            let nContents = try! JSONSerialization.data(withJSONObject: val)
            let nFilename = String(format:"%@/Notifying_%@.json", self.storageDirectory, transactionIdentifier)
            // 调整文件
            try! nContents.write(to: URL(fileURLWithPath: nFilename))
            try? FileManager.default.removeItem(at: URL(fileURLWithPath: pFilename!))
            // 追加任务
            try? self.notifier.add(fileURLWithPath: nFilename)
        }
        objc_sync_exit(self)
    }

    
    /// 通知回调方法
    ///
    /// - Parameters:
    ///   - code: 结果代码
    ///   - message: 结果描述
    ///   - transactionIdentifier: 苹果应用商店订单编号
    func dispatchObserver(_ code:Int, _ message:String,  _ transactionIdentifier:String?) {
        objc_sync_enter(self)
        Logger.info("AppleStoreService.dispatchObserver(%d, %@)", code, message)
        self.lastObserver?(code, message, transactionIdentifier)
        // 清理数据
        self.lastTradeNo = nil
        self.lastProductIdentifier = nil
        self.lastAmount = nil
        self.lastNotifyUrl = nil
        self.lastObserver = nil
        objc_sync_exit(self)
    }
    
    /// 商品信息请求
    private class SPRequestDelegate : NSObject, SKProductsRequestDelegate {
        
        /// 支付对象
        let storeService:AppleStoreService
        
        /// 构造共享回调
        ///
        /// - Parameter storePayment: 支付对象
        init (storeService:AppleStoreService) {
            self.storeService = storeService
        }
        
        /// 商品信息确认结果
        ///
        /// - Parameters:
        ///   - request: 请求对象
        ///   - response: 结果对象
        func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
            Logger.info("AppleStoreService.SKProductsRequestDelegate.productsRequest(SKProductsRequest, SKProductsResponse)")
            // 检查物品标识
            if response.invalidProductIdentifiers.count > 0 {
                return self.storeService.dispatchObserver(121, "productIdentifier not registered on Apple Store", nil)
            }
            // 检查物品数量
            if response.products.count != 1 {
                return self.storeService.dispatchObserver(122, String(format:"products count(%d) error", response.products.count), nil)
            }
            // 检查物品金额
            let amount = Int(floor((response.products.first?.price.doubleValue)! * 100))
            if amount != AppleStoreService.default.lastAmount {
                return self.storeService.dispatchObserver(123, String(format:"product amount(%d) not equal(%d)", amount, AppleStoreService.default.lastAmount!), nil)
            }
            // 挂起请求
            self.storeService.startTransaction()
            // 开始支付
            SKPaymentQueue.default().add(SKPayment(product: response.products.first!))
        }
    } // end sub class
    
    /// 订单状态通知
    private class SPTransactionObserver : NSObject, SKPaymentTransactionObserver {
        
        /// 支付对象
        let storeService:AppleStoreService
        
        /// 构造共享回调
        ///
        /// - Parameter storePayment: 支付对象
        init (storeService:AppleStoreService) {
            self.storeService = storeService
        }
        
        /// 支付状态变更回调
        ///
        /// - Parameters:
        ///   - queue: 支付队列
        ///   - transactions:
        func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
            Logger.info("AppleStoreService.SKPaymentTransactionObserver.paymentQueue(SKPaymentQueue, [SKPaymentTransaction])")
            for txn in transactions {
                switch txn.transactionState {
                case .failed: // 支付失败
                    Logger.error("payment error(%d), %@", (txn.error! as NSError).code, txn.error!.localizedDescription)
                    // 取消订单
                    self.storeService.cancelTransaction(productIdentifier: txn.payment.productIdentifier)
                    // 关闭订单
                    queue.finishTransaction(txn)
                    // 错误代码
                    let code = (txn.error! as NSError).code == 0 ? 100 : (txn.error! as NSError).code
                    // 通知回调
                    self.storeService.dispatchObserver(code, txn.error!.localizedDescription, nil)
                case .purchased: // 支付成功
                    Logger.debug("payment succeed, %s", txn.transactionIdentifier!)
                    // 异步通知
                    self.storeService.finishTransaction(transactionIdentifier: txn.transactionIdentifier!
                        , productIdentifier: txn.payment.productIdentifier)
                    // 关闭订单
                    queue.finishTransaction(txn)
                    // 通知回调
                    self.storeService.dispatchObserver(0, "succeed", txn.transactionIdentifier!)
                case .restored: // 恢复永久性商品
                    fallthrough
                case .purchasing, .deferred: // 支付挂起，支付排队
                    fallthrough
                default:
                    break
                }
            } // for each
        }
        
    }
    
    // End sub class
    
    /// 通知机制
    private class Notifier {
        
        /// 通知任务对象
        class Item {
            
            /// 文件名称
            let filename:String
            
            /// 文件内容
            let contents:[String:Any]
            
            /// 是否完成
            private var complete:Bool = false
            
            /// 响应内容
            private var responseText:String?
            
            /// 构造对象
            init(filename:String) throws {
                Logger.debug("AppleStoreService.Notifier.Item(%@)", filename)
                // 内容调整
                let dat = try Data(contentsOf: URL(fileURLWithPath: filename))
                guard let val = (try JSONSerialization.jsonObject(with: dat) as? [String:Any]) else {
                    throw Error(description:"file content invalid", code:132)
                }
                // 内容检测
                if val.index(forKey: "notifyUrl") == nil {
                    throw Error(description:"content not contain notifyUrl", code:134)
                }
                // 属性赋值
                self.filename = filename
                self.contents = val
            }
            
            /// 发起请求
            ///
            /// - Returns:
            func request() -> Bool {
                var arr = self.contents
                // 创建请求
                var req = URLRequest(url: URL(string:arr["notifyUrl"] as! String)!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 7)
                // 修正参数
                arr.removeValue(forKey: "notifyUrl")
                // 赋值请求
                req.httpMethod = "POST"
                req.httpBody = self.buildQueryStr(withAnyObject: arr)
                // 发起请求
                Logger.debug("AppleStoreService.Notifer.Task.requert(%@)", (req.url?.absoluteString)!)
                let semaphore = DispatchSemaphore(value:0)
                let task:URLSessionDataTask = URLSession.shared.dataTask(with: req, completionHandler: { data, res, err in
                    if data != nil {
                        let txt = String(data: data!, encoding: .utf8)
                        if txt != nil {
                            self.responseText = txt!
                        }
                    }
                    Logger.warn("AppleStoreService.Notifer.Task.requert() error %@", err?.localizedDescription ?? "nil")
                    // 恢复阻塞
                    semaphore.signal()
                })
                self.responseText = nil
                task.resume()
                // 阻塞进程
                _ = semaphore.wait(timeout: DispatchTime.distantFuture)
                if self.responseText == "success" {
                    self.complete = true
                    return true
                }
                Logger.warn("AppleStoreService.Notifer.Task.requert() throw %@", self.responseText ?? "nil")
                return false
            }
            
            /// 删除任务文件
            ///
            /// - Throws:
            func remove () throws {
                Logger.debug("AppleStoreService.Notifier.remove() to %@", self.filename)
                if complete != true {
                    throw Error(description:"task not complete", code:133)
                }
                try FileManager.default.removeItem(at: URL(fileURLWithPath: self.filename))
            }
            
            /// 构造请求字符串
            ///
            /// - Parameter withAnyObject:
            func buildQueryStr (withAnyObject:[String:Any]) -> Data {
                let allowedCharacters =  NSCharacterSet(charactersIn:"+=\"#%/<>?@\\^`{|} ").inverted
                var arr:[String] = []
                for pair in withAnyObject {
                    if pair.value is Int {
                        arr.append(String(format:"%@=%d", pair.key, pair.value as! Int))
                    } else if pair.value is String {
                        let str = (pair.value as! String).addingPercentEncoding(withAllowedCharacters: allowedCharacters)
                        arr.append(String(format:"%@=%@", pair.key, str!))
                    } else if pair.value is Bool {
                        arr.append(String(format:"%@=%d", pair.key, pair.value as! Bool ? "1" : "0"))
                    } else if pair.value is Float {
                        arr.append(String(format:"%@=%f", pair.key, pair.value as! Float))
                    }
                }
                return arr.joined(separator: "&").data(using: .utf8)!
            }
            
        } // end sub class
        
        /// 重试周期配置
        static let PERIODS:[Int] = [3, 3, 3, 60, 180, 300]
        
        /// 周期间隔时间标识
        var periodIdx:Int = 0
        
        /// 异常定时器
        var timer:Timer?
        
        /// 异常请求队列
        var items:[Int:Item] = [:]
        
        /// 添加通知任务
        ///
        /// - Parameter filename: 订单文件地址
        /// - Throws: 
        func add (fileURLWithPath filename:String) throws {
            Logger.debug("AppleStoreService.Notifier.add(%@)", filename)
            objc_sync_enter(self.items)
            defer {
                objc_sync_exit(self.items)
            }
            // 防止重复
            if self.items.index(forKey: filename.hash) != nil {
                throw Error(description:"file exists", code:131)
            }
            // 尝试数据
            let item = try Item(filename:filename)
            if item.request() {
                try? item.remove()
                return
            }
            // 追加数据
            self.items[filename.hash] = item
            // 开始调度
            self.periodIdx = 0
            // 重新定时
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(Notifier.PERIODS[self.periodIdx]), target: self, selector: #selector(self.loop), userInfo: nil, repeats: false)
            // todo
        }
        
        /// 循环刷新异常通知请求
        @objc func loop () {
            objc_sync_enter(self.items)
            // 遍历操作
            for pair in self.items {
                if pair.value.request() != true {
                    continue
                }
                try? pair.value.remove()
                self.items.removeValue(forKey: pair.key)
            }
            // 重新定时
            if self.items.count > 0 {
                self.periodIdx = min(self.periodIdx+1, Notifier.PERIODS.count-1)
                self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(Notifier.PERIODS[self.periodIdx]), target: self, selector: #selector(self.loop), userInfo: nil, repeats: false)
            } else {
                self.timer = nil
            }
            objc_sync_exit(self.items)
        }
        
    } // end sub class
    
    /// 错误对象
    public struct Error : LocalizedError {

        // 错误描述
        public let description:String

        // 错误编号
        public let code:Int

    } // end sub class
    
}

// End class
