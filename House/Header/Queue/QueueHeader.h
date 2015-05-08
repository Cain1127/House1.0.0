//
//  QueueHeader.h
//  House
//
//  Created by ysmeng on 15/1/22.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#ifndef House_QueueHeader_h
#define House_QueueHeader_h

/**
 *  @author yangshengmeng, 15-01-22 10:01:39
 *
 *  @brief  本宏定义是关于所有自定义线程关键字
 *
 *  @since  1.0.0
 */

///网络请求使用的线程关键字
#define QUEUE_REQUEST_DATA_OPERATION "com.fdangjia.queue.request.data.operation"

#define QUEUE_REQUEST_GROUP_QUEUE "com.fdangjia.queue.request.group"

#define QUEUE_REQUEST_TASK_QUEUE "com.fdangjia.queue.request.task"

///应用delete中使用的线程
#define QUEUE_APPDELEGATE_QUEUE "com.fdangjia.queue.appdelegate"

///应用定位管理器使用的线程
#define QUEUE_LOCALMANAGER_QUEUE "com.fdangjia.queue.local"

#endif
