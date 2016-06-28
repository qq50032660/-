//
//  Conti.m
//  test
//
//  Created by fyc on 16/6/27.
//  Copyright © 2016年 FuYaChen. All rights reserved.
//

#import "Conti.h"

@implementation Conti

/**
 *当消息发送给这个转发器的时候会触发对应的 forwardInvocation 方法。我们在这里进行转发
 */
- (void)forwardInvocation:(NSInvocation *)anInvocation{
    SEL aSelector = [anInvocation selector];
    if([self.firstDelegate respondsToSelector:aSelector]){
        [anInvocation invokeWithTarget:self.firstDelegate];
    }
    if([self.secondDelegate respondsToSelector:aSelector]){
        [anInvocation invokeWithTarget:self.secondDelegate];
    }
}
/**
 *获取消息签名
 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    NSMethodSignature *first = [(NSObject *)self.firstDelegate methodSignatureForSelector:aSelector];
    NSMethodSignature *second = [(NSObject *)self.secondDelegate methodSignatureForSelector:aSelector];
    if(first){
        return first;
    } else if(second) {
        return second;
    }
    return nil;
}
/**
 *非常重要的一步。因为我们这个 delegate 只是作为一个转发器使用，不是真正用来实现协议方法的，所以还需要重载 respondsToSelector ,让消息可以转发到这个中转站
 */
- (BOOL)respondsToSelector:(SEL)aSelector{
    if([self.firstDelegate respondsToSelector:aSelector] || [self.secondDelegate respondsToSelector:aSelector]){
        return YES;
    } else {
        return NO;
    }
}

@end
