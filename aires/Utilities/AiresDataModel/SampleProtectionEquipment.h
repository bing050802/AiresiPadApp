//
//  SampleProtectionEquipment.h
//  aires
//
//  Created by Gautham on 29/04/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Sample;

@interface SampleProtectionEquipment : NSManagedObject

@property (nonatomic, retain) NSString * sampleProtectionEquipment_Name;
@property (nonatomic, retain) NSNumber * sampleProtectionEquipmentID;
@property (nonatomic, retain) Sample *fromSample;

@end