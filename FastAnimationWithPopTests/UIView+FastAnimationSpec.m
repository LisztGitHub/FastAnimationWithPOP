//
//  UIView+FastAnimationSpec.m
//  FastAnimationWithPop
//
//  Created by ZangChengwei on 14-6-12.
//  Copyright 2014年 WilliamZang. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "UIView+FastAnimation.h"
#import "FAAnimationTest.h"

SpecBegin(UIViewFastAnimation)

describe(@"UIView+FastAnimation", ^{
    __block UIView *targetView = nil;
    beforeAll(^{

    });
    
    beforeEach(^{
        targetView = [[UIView alloc] init];
        [FAAnimationTest resetHasPerform];
    });
    
    it(@"Check prop", ^{

        NSString *type = @"SomeType@!@";
        targetView.animationType = type;
        expect(targetView.animationType).to.equal(type);
        
        NSNumber *value1 = [NSNumber numberWithDouble:3.15];
        targetView.delay = value1.doubleValue;
        expect(@(targetView.delay)).to.equal(value1);
        
        NSString *paramValue = @"SomeValue";
        [targetView setValue:paramValue forKeyPath:@"animationParams.someValue"];
        expect([targetView valueForKeyPath:@"animationParams.someValue"]).to.equal(paramValue);
        targetView.startAnimationWhenAwakeFromNib = NO;
        expect(targetView.startAnimationWhenAwakeFromNib).to.beFalsy();
    });  
    
    it(@"Normal awakeFromNib", ^{
        [targetView awakeFromNib];
    });
    
    it(@"set not exists class", ^{
        targetView.animationType = @"NotExistsClass";

        BOOL hasAssert = NO;
        @try {
            [targetView awakeFromNib];
        }
        @catch (NSException *exception){
            hasAssert = YES;
            expect(exception.description).to.equal(@"If you want to start an animation, the property 'animationType' must a class name and conforms protocol 'FastAnmationProtocol'");
        }
        expect(hasAssert).to.beTruthy();
    });
    
    it(@"add test animation with full class name", ^{
       targetView.animationType = @"FAAnimationTest";

        [targetView awakeFromNib];
        expect([FAAnimationTest animationHasPerform]).will.beTruthy();
    });
    
    it(@"add test animation with short name", ^{
        targetView.animationType = @"Test";

        [targetView awakeFromNib];
        expect([FAAnimationTest animationHasPerform]).will.beTruthy();
    });
    
    it (@"startAnimationWhenAwakeFromNib prop", ^{
        targetView.animationType = @"Test";
        targetView.startAnimationWhenAwakeFromNib = NO;
        [targetView awakeFromNib];
        expect([FAAnimationTest animationHasPerform]).will.beFalsy();
    });
    
    it(@"manual startAnimation", ^{
        targetView.animationType = @"Test";
        targetView.startAnimationWhenAwakeFromNib = NO;
        [targetView startFAAnimation];
        expect([FAAnimationTest animationHasPerform]).will.beTruthy();
    });
    
    it (@"wrong class name reverse.", ^{
        targetView.animationType = @"Test";
        BOOL hasAssert = NO;
        @try {
            [targetView reverseFAAnimation];
        }
        @catch (NSException *exception){
            hasAssert = YES;
            expect(exception.description).to.equal(@"If you want to perform a reverse animation, the property 'animationType' must a class name and conforms protocol 'FastAnmationProtocol'");
        }
        expect(hasAssert).to.beTruthy();
    });
    it (@"reverse", ^{
        targetView.animationType = @"TestReverse";
        [targetView reverseFAAnimation];
        expect([FAAnimationTestReverse reverseAnimationHasPerform]).will.beTruthy();
    });
    
    it (@"nested view test", ^{
        UIView *animationView = [[UIView alloc] init];
        animationView.animationType = @"Test";
        UIView *subView = [[UIView alloc] init];
        [subView addSubview:animationView];
        [targetView addSubview:animationView];
        [targetView startFAAnimationNested];
        expect([FAAnimationTest animationHasPerform]).will.beTruthy();
    });
    afterEach(^{
        targetView = nil;
    });
    
    afterAll(^{

    });
});

SpecEnd
