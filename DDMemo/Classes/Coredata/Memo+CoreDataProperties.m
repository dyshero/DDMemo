//
//  Memo+CoreDataProperties.m
//  
//
//  Created by duodian on 2018/5/23.
//
//

#import "Memo+CoreDataProperties.h"

@implementation Memo (CoreDataProperties)

+ (NSFetchRequest<Memo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Memo"];
}

@dynamic content;
@dynamic date;
@dynamic memoId;
@dynamic music;
@dynamic remind;
@dynamic time;
@dynamic title;
@dynamic dateInterval;

@end
