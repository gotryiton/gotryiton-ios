//
//  UIImage+GTIOFilters.m
//  GTIO
//
//  Created by Simon Holroyd on 6/26/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "UIImage+GTIOFilters.h"
#import "UIImage+Filter.h"
#import "UIImage+Resize.h"

@implementation UIImage (GTIOFilters)

- (UIImage *)GTIOFilterOriginal 
{
    return self;
}

- (UIImage *)GTIOFilterClementine 
{
    RGBCurve rgbcurve = {
        {0, 2, 5, 7, 9, 11, 14, 16, 18, 21, 23, 25, 27, 29, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 64, 65, 67, 69, 70, 72, 73, 75, 76, 77, 79, 80, 81, 83, 84, 85, 86, 87, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 102, 103, 104, 105, 106, 107, 108, 108, 109, 110, 111, 112, 113, 114, 114, 115, 116, 117, 118, 119, 120, 121, 123, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 199, 200, 201, 202, 203, 204, 205, 206, 206, 207, 208, 209, 210, 211, 211, 212, 213, 214, 215, 215, 216, 217, 217, 218, 219, 219, 220, 221, 222, 222, 223, 224, 224, 225, 226, 226, 227, 228, 228, 229, 230, 230, 231, 231, 232, 233, 233, 234, 234, 235, 235, 236, 237, 237, 238, 238, 239, 239, 240, 240, 241, 241, 242, 242, 243, 243, 244, 244, 244, 245, 245, 246, 246, 247, 247, 248, 248, 248, 249, 249, 250, 250, 251, 251, 251, 252, 252, 253, 253, 254, 254, 254, 255},
        {0, 1, 3, 4, 6, 7, 9, 10, 12, 13, 15, 16, 18, 19, 21, 22, 24, 25, 27, 28, 30, 31, 32, 34, 35, 37, 38, 39, 41, 42, 43, 45, 46, 47, 49, 50, 51, 53, 54, 55, 56, 58, 59, 60, 61, 62, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 85, 86, 87, 88, 89, 90, 91, 91, 92, 93, 94, 95, 96, 97, 97, 98, 99, 100, 101, 102, 103, 104, 105, 105, 106, 107, 108, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 125, 126, 127, 128, 129, 130, 131, 132, 133, 135, 136, 137, 138, 139, 140, 141, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 216, 217, 218, 219, 220, 221, 222, 223, 223, 224, 225, 226, 227, 227, 228, 229, 230, 231, 231, 232, 233, 234, 235, 235, 236, 237, 238, 238, 239, 240, 241, 241, 242, 243, 244, 244, 245, 246, 246, 247, 248, 249, 249, 250, 251, 251, 252, 253, 253, 254, 255},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12, 13, 14, 16, 17, 18, 19, 20, 22, 23, 24, 25, 26, 28, 29, 30, 31, 33, 34, 35, 36, 38, 39, 40, 42, 43, 44, 45, 47, 48, 49, 51, 52, 53, 55, 56, 57, 59, 60, 61, 63, 64, 65, 67, 68, 69, 71, 72, 73, 75, 76, 77, 79, 80, 81, 83, 84, 85, 87, 88, 89, 91, 92, 93, 95, 96, 97, 99, 100, 101, 103, 104, 105, 107, 108, 109, 110, 112, 113, 114, 116, 117, 118, 119, 121, 122, 123, 125, 126, 127, 128, 130, 131, 132, 133, 134, 136, 137, 138, 139, 140, 142, 143, 144, 145, 146, 147, 148, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 172, 173, 174, 175, 175, 176, 177, 177, 178, 179, 179, 180, 180, 181, 181, 182, 182, 183, 183, 184, 184, 185, 185, 186, 186, 187, 187, 188, 188, 189, 189, 189, 190, 190, 191, 191, 192, 192, 192, 193, 193, 194, 194, 195, 195, 195, 196, 196, 197, 197, 198, 198, 199, 200, 200, 201, 201, 202, 202, 203, 204, 204, 205, 206, 206, 207, 208, 209, 209, 210, 211, 212, 213, 214, 215, 217, 218, 220, 222, 224, 226, 229, 231, 233, 236, 239, 241, 244, 247, 250, 253, 255}
    };

    return [[[self applyRGBCurve:rgbcurve] overlay:[UIImage imageNamed:@"mask-5.png"] ratio:1] multiply:[UIImage imageNamed:@"mask-7.png"] ratio:0.05];
}

- (UIImage *)GTIOFilterColombe 
{
    RGBCurve rgbcurve = {
        {0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 23, 25, 27, 29, 30, 32, 33, 35, 36, 38, 39, 40, 41, 42, 43, 45, 46, 46, 47, 48, 49, 50, 51, 52, 52, 53, 54, 55, 55, 56, 57, 58, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 75, 76, 77, 78, 79, 80, 81, 83, 84, 85, 86, 87, 88, 90, 91, 92, 93, 94, 96, 97, 98, 99, 100, 101, 102, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 120, 120, 121, 122, 123, 124, 125, 126, 127, 128, 128, 129, 130, 131, 132, 133, 134, 134, 135, 136, 137, 138, 138, 139, 140, 141, 142, 142, 143, 144, 145, 145, 146, 147, 148, 148, 149, 150, 151, 151, 152, 153, 154, 154, 155, 156, 157, 157, 158, 159, 160, 160, 161, 162, 163, 163, 164, 165, 166, 166, 167, 168, 168, 169, 170, 171, 171, 172, 173, 173, 174, 175, 175, 176, 177, 177, 178, 179, 179, 180, 181, 181, 182, 182, 183, 184, 184, 185, 186, 186, 187, 188, 188, 189, 190, 190, 191, 192, 192, 193, 194, 194, 195, 196, 197, 197, 198, 199, 200, 200, 201, 202, 203, 204, 205, 206, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 218, 219, 220, 221, 222, 224, 225, 226, 227, 229, 230, 231, 233, 234, 235, 237, 238, 239, 241, 242, 243, 245, 246, 248, 249, 250, 252, 253, 255},
        {0, 1, 2, 3, 4, 5, 6, 7, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 110, 111, 112, 113, 114, 115, 116, 117, 118, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 127, 128, 129, 130, 131, 132, 133, 134, 134, 135, 136, 137, 138, 139, 140, 141, 141, 142, 143, 144, 145, 146, 147, 147, 148, 149, 150, 151, 152, 153, 153, 154, 155, 156, 157, 158, 159, 160, 160, 161, 162, 163, 164, 165, 166, 167, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 204, 205, 206, 207, 208, 210, 211, 212, 213, 215, 216, 218, 219, 220, 222, 223, 225, 226, 228, 229, 231, 232, 234, 235, 237, 238, 240, 242, 243, 245, 246, 248, 250, 251, 253, 255},
        {0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 72, 73, 74, 75, 76, 77, 78, 79, 79, 80, 81, 82, 83, 83, 84, 85, 86, 86, 87, 88, 89, 89, 90, 91, 91, 92, 92, 93, 94, 94, 95, 96, 96, 97, 97, 98, 99, 99, 100, 100, 101, 102, 102, 103, 103, 104, 105, 105, 106, 106, 107, 108, 108, 109, 110, 110, 111, 112, 112, 113, 114, 115, 116, 116, 117, 118, 118, 119, 120, 121, 121, 122, 123, 123, 124, 125, 126, 126, 127, 128, 128, 129, 130, 130, 131, 132, 132, 133, 134, 135, 135, 136, 137, 137, 138, 139, 139, 140, 141, 142, 142, 143, 144, 144, 145, 146, 147, 147, 148, 149, 150, 150, 151, 152, 153, 154, 154, 155, 156, 157, 158, 159, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 184, 185, 186, 188, 189, 190, 192, 193, 195, 197, 198, 200, 202, 203, 205, 207, 209, 210, 212, 214, 216, 218, 220, 222, 224, 226, 228, 230, 232, 234, 236, 239, 241, 243, 245, 247, 249, 251, 254, 255}
    };

    Curve curve = {
    0, 0, 1, 1, 1, 1, 2, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 6, 6, 6, 7, 7, 7, 8, 8, 8, 9, 9, 9, 10, 10, 11, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15, 15, 16, 17, 17, 18, 18, 19, 19, 20, 20, 21, 22, 22, 23, 24, 24, 25, 26, 26, 27, 28, 29, 29, 30, 31, 32, 33, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 50, 51, 52, 54, 55, 56, 58, 59, 61, 63, 64, 66, 68, 70, 71, 73, 75, 77, 79, 81, 83, 85, 88, 90, 92, 94, 96, 98, 101, 103, 105, 107, 110, 112, 114, 116, 119, 121, 123, 126, 128, 130, 132, 135, 137, 139, 141, 143, 145, 147, 150, 152, 154, 156, 158, 160, 161, 163, 165, 167, 169, 170, 172, 173, 175, 176, 178, 179, 181, 182, 183, 184, 184, 185, 186, 187, 188, 189, 190, 191, 191, 192, 193, 193, 194, 194, 195, 195, 196, 196, 196, 197, 197, 197, 197, 198, 198, 198, 198, 198, 198, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 200, 200, 200, 200, 200, 201, 201, 201, 201, 202, 202, 203, 203, 204, 204, 205, 205, 206, 207, 208, 209, 211, 212, 214, 216, 218, 220, 223, 225, 228, 231, 234
    };

    return [[[[self applyValueCurve:curve] applyRGBCurve:rgbcurve] overlay:[UIImage imageNamed:@"mask-5.png"] ratio:1.25] multiply:[UIImage imageNamed:@"mask-4.png"] ratio:0.2];
}

- (UIImage *)GTIOFilterDiesel 
{
    RGBCurve rgbcurve = {
        {0, 5, 11, 16, 21, 27, 32, 37, 42, 47, 52, 57, 62, 66, 71, 75, 79, 83, 87, 90, 94, 97, 100, 103, 105, 107, 109, 112, 113, 114, 116, 117, 119, 120, 121, 123, 124, 125, 127, 128, 129, 131, 132, 133, 134, 136, 137, 138, 139, 141, 142, 143, 144, 145, 146, 148, 149, 150, 151, 152, 153, 154, 155, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 178, 179, 180, 181, 182, 183, 184, 185, 186, 186, 187, 188, 189, 190, 191, 191, 192, 193, 194, 195, 195, 196, 197, 198, 199, 199, 200, 201, 202, 202, 203, 204, 205, 205, 206, 207, 208, 208, 209, 210, 210, 211, 212, 213, 213, 214, 215, 215, 216, 217, 217, 218, 219, 219, 220, 221, 221, 222, 223, 223, 224, 225, 225, 226, 227, 227, 228, 229, 229, 230, 230, 231, 232, 232, 233, 234, 234, 235, 236, 236, 237, 237, 238, 238, 239, 240, 240, 241, 241, 242, 242, 243, 243, 244, 244, 244, 245, 245, 246, 246, 246, 247, 247, 248, 248, 248, 249, 249, 249, 249, 250, 250, 250, 250, 251, 251, 251, 251, 252, 252, 252, 252, 252, 252, 253, 253, 253, 253, 253, 253, 253, 254, 254, 254, 254, 254, 254, 254, 254, 254, 254, 254, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255},
        {0, 2, 5, 7, 10, 12, 15, 17, 19, 22, 24, 26, 29, 31, 33, 36, 38, 40, 43, 45, 47, 49, 51, 54, 56, 58, 60, 62, 64, 66, 68, 70, 71, 73, 75, 77, 78, 80, 82, 83, 85, 86, 88, 89, 90, 92, 93, 94, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 119, 120, 121, 122, 123, 124, 124, 125, 126, 127, 128, 128, 129, 130, 131, 132, 132, 133, 134, 135, 135, 136, 137, 137, 138, 139, 140, 140, 141, 142, 142, 143, 144, 145, 145, 146, 147, 147, 148, 149, 149, 150, 151, 151, 152, 153, 153, 154, 155, 155, 156, 157, 157, 158, 159, 159, 160, 160, 161, 162, 162, 163, 164, 164, 165, 166, 166, 167, 167, 168, 169, 169, 170, 171, 171, 172, 173, 173, 174, 175, 175, 176, 176, 177, 178, 178, 179, 180, 180, 181, 182, 182, 183, 184, 184, 185, 186, 186, 187, 188, 189, 189, 190, 191, 191, 192, 193, 193, 194, 195, 196, 196, 197, 198, 199, 199, 200, 201, 201, 202, 203, 204, 204, 205, 206, 207, 207, 208, 209, 210, 211, 211, 212, 213, 214, 215, 216, 216, 217, 218, 219, 220, 221, 221, 222, 223, 224, 225, 226, 226, 227, 228, 229, 230, 231, 231, 232, 233, 234, 235, 236, 237, 238, 238, 239, 240, 241, 242, 243, 244, 244, 245, 246, 247, 248, 249, 250, 251, 251, 252, 253, 254, 255},
        {0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 11, 11, 12, 12, 13, 13, 14, 15, 15, 16, 16, 17, 18, 18, 19, 20, 20, 21, 21, 22, 23, 23, 24, 25, 26, 26, 27, 28, 28, 29, 30, 31, 32, 32, 33, 34, 35, 36, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 60, 61, 62, 63, 64, 66, 67, 68, 69, 71, 72, 73, 75, 76, 77, 79, 80, 81, 83, 84, 86, 87, 88, 90, 91, 93, 94, 96, 97, 98, 100, 101, 103, 104, 106, 107, 109, 110, 112, 113, 115, 116, 118, 119, 121, 122, 124, 125, 127, 128, 130, 131, 133, 134, 136, 137, 139, 140, 142, 143, 145, 146, 147, 149, 150, 152, 153, 155, 156, 157, 159, 160, 161, 163, 164, 166, 167, 168, 169, 171, 172, 173, 175, 176, 177, 178, 179, 181, 182, 183, 184, 185, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 210, 211, 212, 213, 214, 215, 216, 217, 217, 218, 219, 220, 221, 222, 223, 223, 224, 225, 226, 227, 227, 228, 229, 230, 230, 231, 232, 233, 234, 234, 235, 236, 237, 237, 238, 239, 239, 240, 241, 242, 242, 243, 244, 245, 245, 246, 247, 247, 248, 249, 250, 250, 251, 252, 252, 253, 254, 255, 255}
    };

    Curve curve = {
    0, 0, 1, 1, 1, 1, 2, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 6, 6, 6, 7, 7, 7, 8, 8, 8, 9, 9, 9, 10, 10, 11, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15, 15, 16, 17, 17, 18, 18, 19, 19, 20, 20, 21, 22, 22, 23, 24, 24, 25, 26, 26, 27, 28, 29, 29, 30, 31, 32, 33, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 50, 51, 52, 54, 55, 56, 58, 59, 61, 63, 64, 66, 68, 70, 71, 73, 75, 77, 79, 81, 83, 85, 88, 90, 92, 94, 96, 98, 101, 103, 105, 107, 110, 112, 114, 116, 119, 121, 123, 126, 128, 130, 132, 135, 137, 139, 141, 143, 145, 147, 150, 152, 154, 156, 158, 160, 161, 163, 165, 167, 169, 170, 172, 173, 175, 176, 178, 179, 181, 182, 183, 184, 184, 185, 186, 187, 188, 189, 190, 191, 191, 192, 193, 193, 194, 194, 195, 195, 196, 196, 196, 197, 197, 197, 197, 198, 198, 198, 198, 198, 198, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 199, 200, 200, 200, 200, 200, 201, 201, 201, 201, 202, 202, 203, 203, 204, 204, 205, 205, 206, 207, 208, 209, 211, 212, 214, 216, 218, 220, 223, 225, 228, 231, 234
    };
    
    return [[[[self applyRGBCurve:rgbcurve] applyValueCurve:curve] desaturateWithRatio:0.75] multiply:[UIImage imageNamed:@"mask-4.png"] ratio:0.5];
}



- (UIImage *)GTIOFilterHenrik 
{
    RGBCurve curve = {
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 4, 5, 7, 9, 11, 12, 14, 16, 18, 20, 21, 23, 25, 27, 29, 30, 32, 34, 36, 37, 39, 41, 43, 45, 46, 48, 50, 52, 53, 55, 57, 59, 61, 62, 64, 66, 68, 69, 71, 73, 75, 77, 78, 80, 82, 84, 86, 87, 89, 91, 93, 94, 96, 98, 100, 102, 103, 105, 107, 109, 110, 112, 114, 116, 118, 119, 121, 123, 125, 126, 128, 130, 132, 134, 135, 137, 139, 141, 143, 144, 146, 148, 150, 151, 153, 155, 157, 159, 160, 162, 164, 166, 167, 169, 171, 173, 175, 176, 178, 180, 182, 183, 185, 187, 189, 191, 192, 194, 196, 198, 200, 201, 203, 205, 207, 208, 210, 212, 214, 216, 217, 219, 221, 223, 224, 226, 228, 230, 232, 233, 235, 237, 239, 240, 242, 244, 246, 248, 249, 251, 253, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3, 4, 6, 7, 8, 10, 11, 13, 14, 15, 17, 18, 20, 21, 22, 24, 25, 27, 28, 29, 31, 32, 34, 35, 36, 38, 39, 41, 42, 43, 45, 46, 48, 49, 50, 52, 53, 55, 56, 57, 59, 60, 62, 63, 64, 66, 67, 69, 70, 71, 73, 74, 76, 77, 78, 80, 81, 83, 84, 85, 87, 88, 90, 91, 92, 94, 95, 97, 98, 99, 101, 102, 104, 105, 106, 108, 109, 111, 112, 113, 115, 116, 118, 119, 120, 122, 123, 125, 126, 127, 129, 130, 132, 133, 134, 136, 137, 139, 140, 141, 143, 144, 146, 147, 148, 150, 151, 153, 154, 155, 157, 158, 160, 161, 162, 164, 165, 166, 168, 169, 171, 172, 173, 175, 176, 178, 179, 180, 182, 183, 185, 186, 187, 189, 190, 192, 193, 194, 196, 197, 199, 200, 201, 203, 204, 206, 207, 208, 210, 211, 213, 214, 215, 217, 218, 220, 221, 222, 224, 225, 227, 228, 229, 231, 232, 234, 235, 236, 238, 239, 241, 242, 243, 245, 246, 248, 249, 250, 252, 253, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255},
        {0, 1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 226, 227, 228, 229, 230, 230, 231, 232, 233, 234, 234, 235, 236, 236, 237, 238, 239, 239, 240, 241, 241, 242, 243, 243, 244, 244, 245, 246, 246, 247, 248, 248, 249, 249, 250, 251, 251, 252, 252, 253, 253, 254, 255, 255}
    };
    
    return [[self applyRGBCurve:curve] lighten:[UIImage imageNamed:@"mask-4.png"] ratio:0.28];
}

- (UIImage *) GTIOFilterIIRG 
{
    RGBCurve rgbcurve = {
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 7, 7, 7, 8, 8, 8, 9, 9, 9, 10, 10, 11, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15, 16, 16, 17, 17, 18, 18, 19, 19, 20, 20, 21, 22, 22, 23, 23, 24, 25, 25, 26, 26, 27, 28, 28, 29, 30, 30, 31, 32, 33, 33, 34, 35, 36, 36, 37, 38, 39, 39, 40, 41, 42, 43, 43, 44, 45, 46, 47, 48, 49, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 63, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 81, 82, 83, 84, 85, 86, 87, 89, 90, 91, 92, 93, 95, 96, 97, 98, 100, 101, 102, 103, 105, 106, 107, 108, 110, 111, 112, 114, 115, 116, 118, 119, 121, 122, 123, 125, 126, 128, 129, 130, 132, 133, 135, 136, 138, 139, 141, 142, 144, 145, 147, 148, 150, 151, 153, 154, 156, 157, 159, 161, 162, 164, 165, 167, 169, 170, 172, 174, 175, 177, 179, 180, 182, 184, 185, 187, 189, 191, 192, 194, 196, 198, 199, 201, 203, 205, 206, 208, 210, 212, 214, 216, 217, 219, 221, 223, 225, 227, 229, 231, 232, 234, 236, 238, 240, 242, 244, 246, 248, 250, 252, 254, 254},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 4, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 8, 8, 8, 9, 9, 10, 10, 10, 11, 11, 12, 12, 12, 13, 13, 14, 14, 15, 15, 16, 16, 17, 17, 18, 18, 19, 19, 20, 20, 21, 21, 22, 22, 23, 24, 24, 25, 25, 26, 27, 27, 28, 29, 29, 30, 31, 31, 32, 33, 33, 34, 35, 35, 36, 37, 38, 38, 39, 40, 41, 41, 42, 43, 44, 45, 45, 46, 47, 48, 49, 50, 50, 51, 52, 53, 54, 55, 56, 57, 58, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 90, 91, 92, 93, 94, 95, 96, 97, 99, 100, 101, 102, 103, 104, 106, 107, 108, 109, 111, 112, 113, 114, 116, 117, 118, 119, 121, 122, 123, 125, 126, 127, 129, 130, 131, 133, 134, 136, 137, 138, 140, 141, 143, 144, 146, 147, 149, 150, 152, 153, 155, 157, 158, 160, 161, 163, 165, 166, 168, 170, 171, 173, 175, 176, 178, 180, 182, 184, 186, 188, 190, 192, 194, 196, 198, 200, 202, 204, 207, 209, 211, 213, 216, 218, 220, 223, 225, 228, 230, 233, 235, 237, 240, 243, 245, 248, 250, 253, 254},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 7, 7, 7, 8, 8, 8, 9, 9, 9, 10, 10, 11, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15, 16, 16, 17, 17, 18, 18, 19, 19, 20, 20, 21, 22, 22, 23, 23, 24, 25, 25, 26, 26, 27, 28, 28, 29, 30, 30, 31, 32, 33, 33, 34, 35, 36, 36, 37, 38, 39, 39, 40, 41, 42, 43, 43, 44, 45, 46, 47, 48, 49, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 63, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 81, 82, 83, 84, 85, 86, 87, 89, 90, 91, 92, 93, 95, 96, 97, 98, 100, 101, 102, 103, 105, 106, 107, 108, 110, 111, 112, 114, 115, 116, 118, 119, 121, 122, 123, 125, 126, 128, 129, 130, 132, 133, 135, 136, 138, 139, 141, 142, 144, 145, 147, 148, 150, 151, 153, 154, 156, 157, 159, 161, 162, 164, 165, 167, 169, 170, 172, 174, 175, 177, 179, 180, 182, 184, 185, 187, 189, 191, 192, 194, 196, 198, 199, 201, 203, 205, 206, 208, 210, 212, 214, 216, 217, 219, 221, 223, 225, 227, 229, 231, 232, 234, 236, 238, 240, 242, 244, 246, 248, 250, 252, 254, 254}
    };

    Curve curve = { 0, 1, 1, 2, 3, 3, 4, 5, 5, 6, 7, 8, 8, 9, 10, 11, 11, 12, 13, 14, 15, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 30, 31, 32, 33, 35, 36, 38, 39, 40, 42, 43, 44, 46, 47, 49, 50, 51, 53, 54, 56, 57, 58, 60, 61, 63, 64, 66, 67, 69, 70, 71, 73, 74, 76, 77, 79, 80, 82, 83, 85, 86, 88, 90, 91, 93, 94, 96, 97, 99, 100, 102, 104, 105, 107, 108, 110, 112, 113, 115, 116, 118, 120, 121, 123, 125, 126, 128, 129, 131, 133, 134, 136, 138, 139, 141, 143, 145, 146, 148, 150, 151, 153, 155, 157, 158, 160, 162, 163, 165, 167, 169, 171, 173, 175, 178, 180, 183, 185, 187, 190, 193, 195, 198, 200, 203, 206, 208, 211, 214, 216, 219, 221, 224, 226, 229, 231, 233, 235, 237, 240, 241, 243, 245, 247, 248, 250, 251, 252, 253, 254, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255
    };

    return [[[[self applyRGBCurve:rgbcurve] applyValueCurve:curve] desaturate] lighten:[UIImage imageNamed:@"mask-4.png"] ratio:0.10];
}



- (UIImage *)GTIOFilterLafayette 
{
    RGBCurve curve = {
        {53, 53, 54, 55, 55, 56, 57, 57, 58, 59, 59, 60, 60, 61, 62, 62, 63, 64, 64, 65, 66, 66, 67, 67, 68, 69, 69, 70, 71, 71, 72, 73, 73, 74, 74, 75, 76, 76, 77, 78, 78, 79, 80, 80, 81, 81, 82, 83, 83, 84, 85, 85, 86, 87, 87, 88, 88, 89, 90, 90, 91, 92, 92, 93, 94, 94, 95, 95, 96, 97, 97, 98, 99, 99, 100, 101, 101, 102, 102, 103, 104, 104, 105, 106, 106, 107, 108, 108, 109, 109, 110, 111, 111, 112, 113, 113, 114, 115, 115, 116, 116, 117, 118, 118, 119, 120, 120, 121, 122, 122, 123, 123, 124, 125, 125, 126, 127, 127, 128, 129, 129, 130, 130, 131, 132, 132, 133, 134, 134, 135, 136, 136, 137, 137, 138, 139, 139, 140, 141, 141, 142, 143, 143, 144, 144, 145, 146, 146, 147, 148, 148, 149, 150, 150, 151, 151, 152, 153, 153, 154, 155, 155, 156, 157, 157, 158, 158, 159, 160, 160, 161, 162, 162, 163, 164, 164, 165, 165, 166, 167, 167, 168, 169, 169, 170, 171, 171, 172, 172, 173, 174, 174, 175, 176, 176, 177, 178, 178, 179, 180, 180, 181, 181, 182, 183, 183, 184, 185, 185, 186, 187, 187, 188, 188, 189, 190, 190, 191, 192, 192, 193, 194, 194, 195, 195, 196, 197, 197, 198, 199, 199, 200, 201, 201, 202, 202, 203, 204, 204, 205, 206, 206, 207, 208, 208, 209, 209, 210, 211, 211, 212, 213, 213, 214, 215, 215},
        {8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 9, 10, 11, 12, 13, 15, 16, 17, 18, 19, 20, 21, 22, 23, 25, 26, 27, 28, 29, 30, 31, 32, 33, 35, 36, 37, 38, 39, 40, 41, 42, 43, 45, 46, 47, 48, 49, 50, 51, 52, 54, 55, 56, 57, 58, 59, 60, 61, 63, 64, 65, 66, 67, 68, 69, 71, 72, 73, 74, 75, 76, 77, 79, 80, 81, 82, 83, 84, 85, 87, 88, 89, 90, 91, 93, 94, 95, 96, 97, 98, 100, 101, 102, 103, 104, 106, 107, 108, 109, 110, 112, 113, 114, 115, 116, 118, 119, 120, 121, 123, 124, 125, 126, 128, 130, 131, 132, 133, 135, 136, 137, 139, 140, 141, 142, 144, 145, 146, 148, 149, 150, 151, 153, 154, 155, 157, 158, 159, 161, 162, 163, 165, 166, 167, 169, 170, 171, 173, 174, 175, 177, 178, 179, 181, 182, 183, 185, 186, 187, 189, 190, 192, 193, 194, 196, 197, 198, 200, 201, 203, 204, 205, 207, 208, 210, 211, 212, 214, 215, 216, 218, 219, 221, 222, 223, 225, 226, 228, 229, 230, 232, 233, 235, 236, 237, 239, 240, 242, 243, 244, 246, 247, 249, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250},
        {0, 1, 2, 4, 5, 6, 7, 8, 9, 11, 12, 13, 14, 15, 16, 17, 19, 20, 21, 22, 23, 24, 25, 26, 27, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 47, 48, 49, 50, 51, 52, 53, 54, 54, 55, 56, 57, 58, 59, 60, 61, 61, 62, 63, 64, 65, 66, 66, 67, 68, 69, 70, 71, 71, 72, 73, 74, 75, 76, 76, 77, 78, 79, 80, 80, 81, 82, 83, 84, 84, 85, 86, 87, 88, 88, 89, 90, 91, 92, 92, 93, 94, 95, 96, 96, 97, 98, 99, 100, 100, 101, 102, 103, 104, 104, 105, 106, 107, 108, 108, 109, 110, 111, 112, 112, 113, 114, 115, 116, 116, 117, 118, 119, 120, 120, 121, 122, 123, 124, 125, 125, 126, 127, 128, 129, 129, 130, 131, 132, 133, 134, 134, 135, 136, 137, 138, 139, 139, 140, 141, 142, 143, 144, 144, 145, 146, 147, 148, 149, 150, 151, 151, 152, 153, 154, 155, 156, 157, 158, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 183, 184, 185, 186, 187, 189, 190, 191, 192, 193, 194, 196, 197, 198, 199, 201, 202, 203, 205, 206, 208, 209, 210, 212, 213, 215, 216, 218, 219, 221, 222, 224, 226, 227, 229, 230, 232, 234, 235, 237, 238, 240, 242, 243, 245, 247, 248, 250, 252, 253, 255}
    };
    
    return [[self applyRGBCurve:curve] overlay:[UIImage imageNamed:@"mask-5.png"] ratio:1 channel:2];
}



- (UIImage *)GTIOFilterLispenard 
{
    RGBCurve curve = {
        {52, 53, 53, 54, 55, 56, 57, 57, 58, 59, 60, 60, 61, 62, 63, 64, 64, 65, 66, 67, 68, 68, 69, 70, 71, 71, 72, 73, 74, 75, 75, 76, 77, 78, 78, 79, 80, 81, 81, 82, 83, 84, 84, 85, 86, 87, 87, 88, 89, 90, 90, 91, 92, 93, 93, 94, 95, 95, 96, 97, 97, 98, 99, 99, 100, 101, 101, 102, 103, 103, 104, 105, 105, 106, 106, 107, 108, 108, 109, 109, 110, 110, 111, 112, 112, 113, 113, 114, 115, 115, 116, 116, 117, 117, 118, 119, 119, 120, 120, 121, 122, 122, 123, 123, 124, 125, 125, 126, 127, 127, 128, 129, 129, 130, 131, 132, 132, 133, 134, 135, 135, 136, 137, 138, 139, 140, 140, 141, 142, 143, 144, 145, 146, 148, 149, 150, 151, 152, 153, 155, 156, 157, 159, 160, 162, 163, 165, 166, 167, 169, 170, 172, 174, 175, 177, 178, 180, 181, 183, 184, 186, 187, 189, 190, 191, 193, 194, 196, 197, 198, 200, 201, 202, 204, 205, 206, 207, 209, 210, 211, 212, 213, 214, 216, 217, 218, 219, 220, 221, 223, 224, 225, 226, 227, 228, 229, 230, 231, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255},
        {53, 53, 54, 55, 55, 56, 57, 57, 58, 59, 59, 60, 60, 61, 62, 62, 63, 64, 64, 65, 66, 66, 67, 68, 68, 69, 69, 70, 71, 71, 72, 73, 73, 74, 75, 75, 76, 77, 77, 78, 79, 79, 80, 80, 81, 82, 82, 83, 84, 84, 85, 86, 86, 87, 88, 88, 89, 90, 90, 91, 91, 92, 93, 93, 94, 95, 95, 96, 96, 97, 98, 98, 99, 99, 100, 100, 101, 102, 102, 103, 103, 104, 105, 105, 106, 106, 107, 107, 108, 109, 109, 110, 111, 111, 112, 112, 113, 114, 114, 115, 116, 116, 117, 118, 118, 119, 120, 120, 121, 122, 123, 123, 124, 125, 126, 126, 127, 128, 129, 130, 131, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 142, 143, 144, 145, 146, 147, 149, 150, 151, 152, 154, 155, 156, 157, 159, 160, 161, 163, 164, 165, 167, 168, 170, 171, 172, 174, 175, 176, 178, 179, 181, 182, 183, 185, 186, 187, 189, 190, 191, 192, 194, 195, 196, 197, 198, 199, 200, 202, 203, 204, 205, 206, 207, 208, 210, 211, 212, 213, 214, 215, 216, 217, 218, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255},
        {27, 27, 28, 29, 29, 30, 30, 31, 32, 32, 33, 33, 34, 34, 35, 36, 36, 37, 37, 38, 38, 39, 40, 40, 41, 41, 42, 43, 43, 44, 44, 45, 46, 46, 47, 47, 48, 48, 49, 50, 50, 51, 52, 52, 53, 53, 54, 55, 55, 56, 56, 57, 58, 58, 59, 59, 60, 61, 61, 62, 63, 63, 64, 65, 65, 66, 66, 67, 68, 68, 69, 70, 70, 71, 72, 72, 73, 74, 74, 75, 76, 76, 77, 78, 78, 79, 80, 80, 81, 82, 83, 83, 84, 85, 85, 86, 87, 88, 88, 89, 90, 90, 91, 92, 93, 93, 94, 95, 96, 96, 97, 98, 99, 99, 100, 101, 102, 103, 103, 104, 105, 106, 107, 107, 108, 109, 110, 111, 111, 112, 113, 114, 115, 116, 116, 117, 118, 119, 120, 121, 122, 123, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 144, 145, 146, 147, 148, 149, 150, 151, 152, 154, 155, 156, 157, 158, 160, 161, 162, 163, 165, 166, 167, 168, 170, 171, 172, 174, 175, 176, 178, 179, 180, 182, 183, 185, 186, 187, 189, 190, 192, 193, 195, 196, 198, 199, 200, 202, 203, 205, 206, 208, 209, 211, 212, 214, 215, 217, 219, 220, 222, 223, 225, 226, 228, 229, 231, 232, 234, 236, 237, 239, 240, 242, 243, 245, 247, 248, 250, 251, 253, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255}
    };
    
    return [[[[self applyRGBCurve:curve] overlay:[UIImage imageNamed:@"mask-5.png"] ratio:1.0] desaturateWithRatio:0.40] lighten:[UIImage imageNamed:@"mask-4.png"] ratio:0.14];
}

- (UIImage *)GTIOFilterWalker 
{
    RGBCurve curve = {
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 7, 7, 7, 8, 8, 8, 9, 9, 9, 10, 10, 11, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15, 16, 16, 17, 17, 18, 18, 19, 19, 20, 20, 21, 22, 22, 23, 23, 24, 25, 25, 26, 26, 27, 28, 28, 29, 30, 30, 31, 32, 33, 33, 34, 35, 36, 36, 37, 38, 39, 39, 40, 41, 42, 43, 43, 44, 45, 46, 47, 48, 49, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 63, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 81, 82, 83, 84, 85, 86, 87, 89, 90, 91, 92, 93, 95, 96, 97, 98, 100, 101, 102, 103, 105, 106, 107, 108, 110, 111, 112, 114, 115, 116, 118, 119, 121, 122, 123, 125, 126, 128, 129, 130, 132, 133, 135, 136, 138, 139, 141, 142, 144, 145, 147, 148, 150, 151, 153, 154, 156, 157, 159, 161, 162, 164, 165, 167, 169, 170, 172, 174, 175, 177, 179, 180, 182, 184, 185, 187, 189, 191, 192, 194, 196, 198, 199, 201, 203, 205, 206, 208, 210, 212, 214, 216, 217, 219, 221, 223, 225, 227, 229, 231, 232, 234, 236, 238, 240, 242, 244, 246, 248, 250, 252, 254, 254},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 4, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 8, 8, 8, 9, 9, 10, 10, 10, 11, 11, 12, 12, 12, 13, 13, 14, 14, 15, 15, 16, 16, 17, 17, 18, 18, 19, 19, 20, 20, 21, 21, 22, 22, 23, 24, 24, 25, 25, 26, 27, 27, 28, 29, 29, 30, 31, 31, 32, 33, 33, 34, 35, 35, 36, 37, 38, 38, 39, 40, 41, 41, 42, 43, 44, 45, 45, 46, 47, 48, 49, 50, 50, 51, 52, 53, 54, 55, 56, 57, 58, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 90, 91, 92, 93, 94, 95, 96, 97, 99, 100, 101, 102, 103, 104, 106, 107, 108, 109, 111, 112, 113, 114, 116, 117, 118, 119, 121, 122, 123, 125, 126, 127, 129, 130, 131, 133, 134, 136, 137, 138, 140, 141, 143, 144, 146, 147, 149, 150, 152, 153, 155, 157, 158, 160, 161, 163, 165, 166, 168, 170, 171, 173, 175, 176, 178, 180, 182, 184, 186, 188, 190, 192, 194, 196, 198, 200, 202, 204, 207, 209, 211, 213, 216, 218, 220, 223, 225, 228, 230, 233, 235, 237, 240, 243, 245, 248, 250, 253, 254},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 7, 7, 7, 8, 8, 8, 9, 9, 9, 10, 10, 11, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15, 16, 16, 17, 17, 18, 18, 19, 19, 20, 20, 21, 22, 22, 23, 23, 24, 25, 25, 26, 26, 27, 28, 28, 29, 30, 30, 31, 32, 33, 33, 34, 35, 36, 36, 37, 38, 39, 39, 40, 41, 42, 43, 43, 44, 45, 46, 47, 48, 49, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 63, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 81, 82, 83, 84, 85, 86, 87, 89, 90, 91, 92, 93, 95, 96, 97, 98, 100, 101, 102, 103, 105, 106, 107, 108, 110, 111, 112, 114, 115, 116, 118, 119, 121, 122, 123, 125, 126, 128, 129, 130, 132, 133, 135, 136, 138, 139, 141, 142, 144, 145, 147, 148, 150, 151, 153, 154, 156, 157, 159, 161, 162, 164, 165, 167, 169, 170, 172, 174, 175, 177, 179, 180, 182, 184, 185, 187, 189, 191, 192, 194, 196, 198, 199, 201, 203, 205, 206, 208, 210, 212, 214, 216, 217, 219, 221, 223, 225, 227, 229, 231, 232, 234, 236, 238, 240, 242, 244, 246, 248, 250, 252, 254, 254}
    };
    
    return [[self applyRGBCurve:curve] addLinesWithBrightness:1.4];
}

@end
