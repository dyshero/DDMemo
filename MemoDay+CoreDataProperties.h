//
//  MemoDay+CoreDataProperties.h
//  
//
//  Created by duodian on 2018/5/21.
//
//

#import "MemoDay+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MemoDay (CoreDataProperties)

+ (NSFetchRequest<MemoDay *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *date;

@end

NS_ASSUME_NONNULL_END
