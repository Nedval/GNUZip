//
//  Zip.m
//  GNUZip
//
//  Created by Jrting on 6/21/16.
//  Copyright © 2016 Modern Wizard Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <zlib.h>
#import "Zip.h"

@interface Zip()

+ (z_stream) _createZStream:(NSData*)data;

@end

@implementation Zip: NSObject

+ (NSData*) compress:(NSData*)data {

    return [Zip compress:data level:Z_DEFAULT_COMPRESSION];
    
}

+ (NSData*) compress:(nonnull NSData*)data level:(float)level {

    if ([data length] <= 0) {

        return nil;

    }

    z_stream stream = [Zip _createZStream:data];

    int compression = (level < 0.0f)? Z_DEFAULT_COMPRESSION: (int)(roundf(level * 9));

    if (deflateInit2_(&stream, compression, Z_DEFLATED, 31, 8, Z_DEFAULT_STRATEGY, ZLIB_VERSION, NSInteger(sizeof(z_stream))) != Z_OK) {

        return nil;

    }

    static const NSUInteger chunk_size = 16384;

    NSMutableData *mutable_data = [NSMutableData dataWithLength:chunk_size];

    while (stream.avail_out == 0) {

        if (mutable_data.length <= stream.total_out)  {

            mutable_data.length += chunk_size;

        }

        stream.next_out = (uint8_t *)mutable_data.mutableBytes + stream.total_out;

        stream.avail_out = (uInt)(mutable_data.length - stream.total_out);

        deflate(&stream, Z_FINISH);

    }

    deflateEnd(&stream);

    mutable_data.length = stream.total_out;

    return mutable_data;

}

+ (NSData*) decompress:(NSData*)data {

    if ([data length] <= 0) {

        return nil;
        
    }

    z_stream stream = [Zip _createZStream:data];

    if (inflateInit2_(&stream, 47, ZLIB_VERSION, NSInteger(sizeof(z_stream))) != Z_OK) {

        return nil;

    }

    NSMutableData *mutable_data = [NSMutableData dataWithLength:[data length]];

    int status = Z_OK;

    while (status == Z_OK) {

        if (mutable_data.length <= stream.total_out) {

            mutable_data.length += [data length] / 2;

        }

        stream.next_out = (uint8_t *)mutable_data.mutableBytes + stream.total_out;

        stream.avail_out = (uInt)(mutable_data.length - stream.total_out);

        status = inflate(&stream, Z_SYNC_FLUSH);

    }

    if (inflateEnd(&stream) != Z_OK) {

        return nil;

    }

    if (status == Z_STREAM_END) {

        mutable_data.length = stream.total_out;

        return mutable_data;

    }

    return nil;
    
}

+ (z_stream) _createZStream:(NSData*)data {

    z_stream stream;

    stream.next_in = (Bytef *)(void *)data.bytes;

    stream.avail_in = (uint)data.length;

    stream.total_in = 0;

    stream.next_out = Z_NULL;

    stream.avail_out = 0;

    stream.total_out = 0;

    stream.msg = Z_NULL;

    stream.state = Z_NULL;

    stream.zalloc = Z_NULL;

    stream.zfree = Z_NULL;

    stream.opaque = Z_NULL;

    stream.data_type = 0;

    stream.adler = 0;

    stream.reserved = 0;

    return stream;
    
}

@end
