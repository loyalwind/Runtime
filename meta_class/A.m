//
//  A.m
//  meta_class
//
//  Created by 张正超 on 14/11/13.
//  Copyright (c) 2014年 张正超. All rights reserved.
//

#import "A.h"
#import <objc/runtime.h>

void TestMetaClass(id self, SEL _cmd){
    NSLog(@"this object is %p",self);
    NSLog(@"class is %@,super class is %@",[self class],[self superclass]);
    
    Class currentClass = [self class];
    
    for (int i = 0; i < 4; i++) {
        NSLog(@"following  the isa pointer %d times gives %p",i,currentClass);
        currentClass = objc_getClass((__bridge void*)currentClass);
    }
    
    NSLog(@"nsobject's class is %p",[NSObject class]);
    NSLog(@"nsobject's meta class is %p",objc_getClass((__bridge void *)[NSObject class]));
}

@implementation A

- (void)ex_registerClassPair{

    Class newClass = objc_allocateClassPair([NSError class], "TestClass", 0);
    
    class_addMethod(newClass, @selector(testMetaClass), (IMP)TestMetaClass, "v@:");
    objc_registerClassPair(newClass);
    
    id instance = [[newClass alloc]initWithDomain:@"some domain" code:0 userInfo:nil];
    
    [instance performSelector:@selector(testMetaClass)];
    
}
/*
 运行时之一，类与对象
 
 通过创建一个A对象，在运行时创建一个新的类 newClass 这个类继承自NSError ， 主要的代码操作是 在运行时创建的这个类，然后给这个类添加一个testMetaClass方法， 而这个方法的实现是TestMetaClass方法。
 
 Class newClass = objc_allocateClassPair([NSError class],"TestClass",0);
 
 运行时创建NSError的子类 ，子类名称是TestClass ，
 
 class_addMethod(newClass,@selector(testMetaClass),(IMP)TestMetaClass,"v@:");
 
 给newClass这个类添加方法 SEL testMetaClass selector对应的实现函数是TestMetaClass
 
 objc_registerClassPair(newClass); 将运行时创建的这个类注册
 
 运行时实例化这个类
 id instance = [[newClass alloc]initWithDomain:@"some domain" code:0 userInfo:nil];//NSError实例化方法
 
 [ instance performSelector:@selector(testMetaClass)];
 
 最后打印结果是 ： 2014-11-13 16:31:43.415 meta_class[2739:183347] this object is 0x100204d10 2014-11-13 16:31:43.416 meta_class[2739:183347] class is TestClass,super class is NSError 2014-11-13 16:31:43.417 meta_class[2739:183347] following the isa pointer 0 times gives 0x100204af0 2014-11-13 16:31:43.417 meta_class[2739:183347] following the isa pointer 1 times gives 0x0 2014-11-13 16:31:43.417 meta_class[2739:183347] following the isa pointer 2 times gives 0x0 2014-11-13 16:31:43.417 meta_class[2739:183347] following the isa pointer 3 times gives 0x0 2014-11-13 16:31:43.417 meta_class[2739:183347] nsobject's class is 0x7fff79e830f0 2014-11-13 16:31:43.417 meta_class[2739:183347] nsobject's meta class is 0x0
 
 在for循环中通过objc_getClass 来获取对象的isa，并将其打印出来，因此一直回溯到NSObject的meta-class。
 
 我们在一个类对象调用class方法是无法获取meta-class，他只是返回类；
 
 类与对象操作函数 runtime提供美好了大量的额函数来操作类与对象，类的操作方法大部分是以class为前缀的，而对象的操作方法大部分是以 objc 或者object为前缀的
 
 类相关操作函数 结构体objc_class struct objc_class { Class isa OBJC_ISA_AVAILABILITY;
 */

@end
