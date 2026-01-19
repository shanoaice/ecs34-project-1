#include <gtest/gtest.h>
#include "StringUtils.h"

using std::string;

TEST(StringUtilsTest, SliceTest){
    string slice_test = "slicedstring";

    EXPECT_EQ(StringUtils::Slice(slice_test, 0, 4), "slic");
    EXPECT_EQ(StringUtils::Slice(slice_test, 4, 9), "edstr");
    EXPECT_EQ(StringUtils::Slice(slice_test, 6), "string");
    EXPECT_EQ(StringUtils::Slice(slice_test, -6), "string");
}

TEST(StringUtilsTest, Capitalize){
    
}

TEST(StringUtilsTest, Upper){
    
}

TEST(StringUtilsTest, Lower){
    
}

TEST(StringUtilsTest, LStrip){
    
}

TEST(StringUtilsTest, RStrip){
    
}

TEST(StringUtilsTest, Strip){
    
}

TEST(StringUtilsTest, Center){
    
}

TEST(StringUtilsTest, LJust){
    
}

TEST(StringUtilsTest, RJust){
    
}

TEST(StringUtilsTest, Replace){
    
}

TEST(StringUtilsTest, Split){
    
}

TEST(StringUtilsTest, Join){
    
}

TEST(StringUtilsTest, ExpandTabs){
    
}

TEST(StringUtilsTest, EditDistance){
    
}
