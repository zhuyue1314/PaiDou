

@interface UIImageSize : NSObject {

}
+(UIImage *)thumbnailOfImage:(UIImage *)oldImage Size:(CGSize)newSize;
+(UIImage *)scaleImage:(UIImage *) image maxWidth:(float) maxWidth maxHeight:(float) maxHeight;
@end
