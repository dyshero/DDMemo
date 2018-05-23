//
//  Memo+CoreDataProperties.h
//  
//
//  Created by duodian on 2018/5/23.
//
//

#import "Memo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Memo (CoreDataProperties)

+ (NSFetchRequest<Memo *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSString *date;
@property (nullable, nonatomic, copy) NSString *memoId;
@property (nullable, nonatomic, copy) NSString *music;
@property (nonatomic) BOOL remind;
@property (nullable, nonatomic, copy) NSString *time;
@property (nullable, nonatomic, copy) NSString *title;
@property (nonatomic) double dateInterval;

@end

NS_ASSUME_NONNULL_END
