//
//  GCDTool.swift
//  GCD
//
//  Created by iMac on 2018/10/18.
//  Copyright © 2018年 ly. All rights reserved.
//

import Foundation
import UIKit

/// 获取当前线程
///
/// - Returns: 当前线程
func getCurrentThread() -> Thread {
	return Thread.current
}

/// 当前线程休眠
///
/// - Parameter time: 休眠时间 单位/s
func currentThreadSleep(time: TimeInterval) {
	Thread.sleep(forTimeInterval: time)
}

/// 获取主线程队列
///
/// - Returns: 主线程队列
func getMainQueue() -> DispatchQueue {
	return DispatchQueue.main
}

/// 获取全局队列
///
/// - Parameter qos: 指定优先级
func getGlobalQueue(qos: DispatchQoS.QoSClass = .default) -> DispatchQueue {
	return DispatchQueue.global(qos: qos)
}

/// 创建并行队列
///
/// - Parameter label: 标记
/// - Returns: 并行队列
func createConcurrentQueue(label: String) -> DispatchQueue {
	return DispatchQueue.init(label: label, qos: .default, attributes: .concurrent)
}

/// 创建串行队列，默认就是串行队列
///
/// - Returns: 串行队列
func createSerialQueue(label: String) -> DispatchQueue {
	return DispatchQueue.init(label: label, qos: .default)
}
