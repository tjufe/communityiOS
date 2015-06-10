//
//  APIAddress.h
//  communityiOS
//
//  Created by 何茂馨 on 15/3/31.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#ifndef communityiOS_APIAddress_h
#define communityiOS_APIAddress_h

#pragma mark-----------------局域网服务器------------------

//#define API_HOST @"http://192.168.28.211/sq/"
//#define API_TOPIC_PIC_PATH @"http://192.168.28.211/sq/topicpic/"//图片下载地址
//#define API_HEAD_PIC_PATH @"http://192.168.28.211/sq/uploadimg/"//头像下载地址
//#define API_UPLOAD_HOST @"upload_topic_pic.php"//上传图片的地址
//#define API_PORTRAIT_UPLOAD @"upload.php"   //头像上传目标文件夹

#pragma mark-----------------广域网服务器------------------

#define API_ROOT_HOST @"http://tiancaishequ.com:88/build.json"
//#define API_HOST @"http://www.tiancaishequ.com:"
#define API_HOST [AppDelegate getServerAddress]
#define API_TOPIC_PIC_PATH @"http://182.92.165.168:82/topicpic/"//图片下载地址
#define API_HEAD_PIC_PATH @"http://182.92.165.168:82/uploadimg/"//头像下载地址
#define API_UPLOAD_HOST @"upload_topic_pic.php"//上传图片的地址
#define API_PORTRAIT_UPLOAD @"/upload.php"   //头像上传目标文件夹

#endif 
