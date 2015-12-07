//
//  ViewController.m
//  A02-GData
//
//  Created by apple on 15/6/10.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "ViewController.h"
#import "GDataXMLNode.h"
#import "Video.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadXML];
}

- (void)loadXML{
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/videos.xml"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError && data) {
            //dom的方式解析xml
            GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data error:NULL];
            
            //获取xml的根节点
            GDataXMLElement *root = doc.rootElement;
            
            NSMutableArray *mArray = [NSMutableArray array];
            //遍历所有的video 标签
            for (GDataXMLElement *videoEle in root.children) {
                Video *v = [Video new];
                [mArray addObject:v];

                //遍历video中的所有子标签  给video对象设置属性
                for (GDataXMLElement *ele in videoEle.children) {
                    //ele.name 标签的名称
                    [v setValue:ele.stringValue forKey:ele.name];
                }
                
                //
//                NSLog(@"%@",videoEle.attributes);
                //遍历所有的标签所有的属性  给viedo对象的属性赋值
                for (GDataXMLNode *node in videoEle.attributes) {
                    [v setValue:node.stringValue forKey:node.name];
                }
                
            }
            
            
            NSLog(@"%@",mArray);
        }
    }];
}


@end
