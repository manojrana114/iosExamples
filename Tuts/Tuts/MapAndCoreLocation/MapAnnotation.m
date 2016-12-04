//
//  MapAnnotation.m
//  Tuts
//
//  Created by Manoj pratap singh rana on 03/12/16.
//  Copyright © 2016 impetus. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation

- (instancetype) initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates title:(NSString *)paramTitle subTitle:(NSString *)paramSubTitle{
    
    self = [super init];
    if (self != nil){
        _coordinate = paramCoordinates;
        _title = paramTitle;
        _subtitle = paramSubTitle;
    }
    return self;

}

@end



