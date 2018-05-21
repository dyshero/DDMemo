//
//  MemoDay+CoreDataProperties.m
//  
//
//  Created by duodian on 2018/5/21.
//
//

#import "MemoDay+CoreDataProperties.h"

@implementation MemoDay (CoreDataProperties)

+ (NSFetchRequest<MemoDay *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MemoDay"];
}

@dynamic date;

@end
