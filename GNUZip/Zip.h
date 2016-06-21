//
//  Zip.h
//  GNUZip
//
//  Created by Jrting on 6/21/16.
//  Copyright © 2016 Modern Wizard Studio. All rights reserved.
//

#ifndef Zip_h
#define Zip_h

@interface Zip: NSObject

+ (nullable NSData*) compress:(nonnull NSData*)data;

+ (nullable NSData*) compress:(nonnull NSData*)data level:(float)level;

+ (nullable NSData*) decompress:(nonnull NSData*)data;

@end

#endif /* Zip_h */
