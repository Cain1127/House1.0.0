// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "Chat.pb.h"

@implementation ChatRoot
static PBExtensionRegistry* extensionRegistry = nil;
+ (PBExtensionRegistry*) extensionRegistry {
  return extensionRegistry;
}

+ (void) initialize {
  if (self == [ChatRoot class]) {
    PBMutableExtensionRegistry* registry = [PBMutableExtensionRegistry registry];
    [self registerAllExtensions:registry];
    extensionRegistry = [registry retain];
  }
}
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry {
}
@end

BOOL ChatRequestTypeIsValidValue(ChatRequestType value) {
  switch (value) {
    case ChatRequestTypeChatTypeSendPtp:
    case ChatRequestTypeChatTypeSendPtg:
    case ChatRequestTypeChatTypeOnLine:
    case ChatRequestTypeChatTypeOffLine:
      return YES;
    default:
      return NO;
  }
}
@interface Question ()
@property int64_t mid;
@property int64_t tid;
@property ChatRequestType type;
@property (retain) NSString* message;
@property (retain) NSData* pic;
@property (retain) NSData* video;
@end

@implementation Question

- (BOOL) hasMid {
  return !!hasMid_;
}
- (void) setHasMid:(BOOL) value {
  hasMid_ = !!value;
}
@synthesize mid;
- (BOOL) hasTid {
  return !!hasTid_;
}
- (void) setHasTid:(BOOL) value {
  hasTid_ = !!value;
}
@synthesize tid;
- (BOOL) hasType {
  return !!hasType_;
}
- (void) setHasType:(BOOL) value {
  hasType_ = !!value;
}
@synthesize type;
- (BOOL) hasMessage {
  return !!hasMessage_;
}
- (void) setHasMessage:(BOOL) value {
  hasMessage_ = !!value;
}
@synthesize message;
- (BOOL) hasPic {
  return !!hasPic_;
}
- (void) setHasPic:(BOOL) value {
  hasPic_ = !!value;
}
@synthesize pic;
- (BOOL) hasVideo {
  return !!hasVideo_;
}
- (void) setHasVideo:(BOOL) value {
  hasVideo_ = !!value;
}
@synthesize video;
- (void) dealloc {
  self.message = nil;
  self.pic = nil;
  self.video = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.mid = 0L;
    self.tid = 0L;
    self.type = ChatRequestTypeChatTypeSendPtp;
    self.message = @"";
    self.pic = [NSData data];
    self.video = [NSData data];
  }
  return self;
}
static Question* defaultQuestionInstance = nil;
+ (void) initialize {
  if (self == [Question class]) {
    defaultQuestionInstance = [[Question alloc] init];
  }
}
+ (Question*) defaultInstance {
  return defaultQuestionInstance;
}
- (Question*) defaultInstance {
  return defaultQuestionInstance;
}
- (BOOL) isInitialized {
  if (!self.hasMid) {
    return NO;
  }
  if (!self.hasTid) {
    return NO;
  }
  if (!self.hasType) {
    return NO;
  }
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (self.hasMid) {
    [output writeInt64:1 value:self.mid];
  }
  if (self.hasTid) {
    [output writeInt64:2 value:self.tid];
  }
  if (self.hasType) {
    [output writeEnum:3 value:self.type];
  }
  if (self.hasMessage) {
    [output writeString:4 value:self.message];
  }
  if (self.hasPic) {
    [output writeData:5 value:self.pic];
  }
  if (self.hasVideo) {
    [output writeData:6 value:self.video];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  if (self.hasMid) {
    size += computeInt64Size(1, self.mid);
  }
  if (self.hasTid) {
    size += computeInt64Size(2, self.tid);
  }
  if (self.hasType) {
    size += computeEnumSize(3, self.type);
  }
  if (self.hasMessage) {
    size += computeStringSize(4, self.message);
  }
  if (self.hasPic) {
    size += computeDataSize(5, self.pic);
  }
  if (self.hasVideo) {
    size += computeDataSize(6, self.video);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (Question*) parseFromData:(NSData*) data {
  return (Question*)[[[Question builder] mergeFromData:data] build];
}
+ (Question*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (Question*)[[[Question builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (Question*) parseFromInputStream:(NSInputStream*) input {
  return (Question*)[[[Question builder] mergeFromInputStream:input] build];
}
+ (Question*) parseDelimitedFromInputStream:(NSInputStream*) input {
  return (Question*)[[[Question builder] mergeDelimitedFromInputStream:input] build];
}
+ (Question*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (Question*)[[[Question builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (Question*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (Question*)[[[Question builder] mergeFromCodedInputStream:input] build];
}
+ (Question*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (Question*)[[[Question builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (Question_Builder*) builder {
  return [[[Question_Builder alloc] init] autorelease];
}
+ (Question_Builder*) builderWithPrototype:(Question*) prototype {
  return [[Question builder] mergeFrom:prototype];
}
- (Question_Builder*) builder {
  return [Question builder];
}
@end

@interface Question_Builder()
@property (retain) Question* result;
@end

@implementation Question_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.result = [[[Question alloc] init] autorelease];
  }
  return self;
}
- (PBGeneratedMessage*) internalGetResult {
  return result;
}
- (Question_Builder*) clear {
  self.result = [[[Question alloc] init] autorelease];
  return self;
}
- (Question_Builder*) clone {
  return [Question builderWithPrototype:result];
}
- (Question*) defaultInstance {
  return [Question defaultInstance];
}
- (Question*) build {
  [self checkInitialized];
  return [self buildPartial];
}
- (Question*) buildPartial {
  Question* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (Question_Builder*) mergeFrom:(Question*) other {
  if (other == [Question defaultInstance]) {
    return self;
  }
  if (other.hasMid) {
    [self setMid:other.mid];
  }
  if (other.hasTid) {
    [self setTid:other.tid];
  }
  if (other.hasType) {
    [self setType:other.type];
  }
  if (other.hasMessage) {
    [self setMessage:other.message];
  }
  if (other.hasPic) {
    [self setPic:other.pic];
  }
  if (other.hasVideo) {
    [self setVideo:other.video];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (Question_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (Question_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (YES) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 8: {
        [self setMid:[input readInt64]];
        break;
      }
      case 16: {
        [self setTid:[input readInt64]];
        break;
      }
      case 24: {
        int32_t value = [input readEnum];
        if (ChatRequestTypeIsValidValue(value)) {
          [self setType:value];
        } else {
          [unknownFields mergeVarintField:3 value:value];
        }
        break;
      }
      case 34: {
        [self setMessage:[input readString]];
        break;
      }
      case 42: {
        [self setPic:[input readData]];
        break;
      }
      case 50: {
        [self setVideo:[input readData]];
        break;
      }
    }
  }
}
- (BOOL) hasMid {
  return result.hasMid;
}
- (int64_t) mid {
  return result.mid;
}
- (Question_Builder*) setMid:(int64_t) value {
  result.hasMid = YES;
  result.mid = value;
  return self;
}
- (Question_Builder*) clearMid {
  result.hasMid = NO;
  result.mid = 0L;
  return self;
}
- (BOOL) hasTid {
  return result.hasTid;
}
- (int64_t) tid {
  return result.tid;
}
- (Question_Builder*) setTid:(int64_t) value {
  result.hasTid = YES;
  result.tid = value;
  return self;
}
- (Question_Builder*) clearTid {
  result.hasTid = NO;
  result.tid = 0L;
  return self;
}
- (BOOL) hasType {
  return result.hasType;
}
- (ChatRequestType) type {
  return result.type;
}
- (Question_Builder*) setType:(ChatRequestType) value {
  result.hasType = YES;
  result.type = value;
  return self;
}
- (Question_Builder*) clearType {
  result.hasType = NO;
  result.type = ChatRequestTypeChatTypeSendPtp;
  return self;
}
- (BOOL) hasMessage {
  return result.hasMessage;
}
- (NSString*) message {
  return result.message;
}
- (Question_Builder*) setMessage:(NSString*) value {
  result.hasMessage = YES;
  result.message = value;
  return self;
}
- (Question_Builder*) clearMessage {
  result.hasMessage = NO;
  result.message = @"";
  return self;
}
- (BOOL) hasPic {
  return result.hasPic;
}
- (NSData*) pic {
  return result.pic;
}
- (Question_Builder*) setPic:(NSData*) value {
  result.hasPic = YES;
  result.pic = value;
  return self;
}
- (Question_Builder*) clearPic {
  result.hasPic = NO;
  result.pic = [NSData data];
  return self;
}
- (BOOL) hasVideo {
  return result.hasVideo;
}
- (NSData*) video {
  return result.video;
}
- (Question_Builder*) setVideo:(NSData*) value {
  result.hasVideo = YES;
  result.video = value;
  return self;
}
- (Question_Builder*) clearVideo {
  result.hasVideo = NO;
  result.video = [NSData data];
  return self;
}
@end

@interface Answer ()
@property (retain) NSString* result;
@property ChatRequestType type;
@property (retain) NSString* message;
@property (retain) NSData* pic;
@property (retain) NSData* video;
@end

@implementation Answer

- (BOOL) hasResult {
  return !!hasResult_;
}
- (void) setHasResult:(BOOL) value {
  hasResult_ = !!value;
}
@synthesize result;
- (BOOL) hasType {
  return !!hasType_;
}
- (void) setHasType:(BOOL) value {
  hasType_ = !!value;
}
@synthesize type;
- (BOOL) hasMessage {
  return !!hasMessage_;
}
- (void) setHasMessage:(BOOL) value {
  hasMessage_ = !!value;
}
@synthesize message;
- (BOOL) hasPic {
  return !!hasPic_;
}
- (void) setHasPic:(BOOL) value {
  hasPic_ = !!value;
}
@synthesize pic;
- (BOOL) hasVideo {
  return !!hasVideo_;
}
- (void) setHasVideo:(BOOL) value {
  hasVideo_ = !!value;
}
@synthesize video;
- (void) dealloc {
  self.result = nil;
  self.message = nil;
  self.pic = nil;
  self.video = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.result = @"";
    self.type = ChatRequestTypeChatTypeSendPtp;
    self.message = @"";
    self.pic = [NSData data];
    self.video = [NSData data];
  }
  return self;
}
static Answer* defaultAnswerInstance = nil;
+ (void) initialize {
  if (self == [Answer class]) {
    defaultAnswerInstance = [[Answer alloc] init];
  }
}
+ (Answer*) defaultInstance {
  return defaultAnswerInstance;
}
- (Answer*) defaultInstance {
  return defaultAnswerInstance;
}
- (BOOL) isInitialized {
  if (!self.hasResult) {
    return NO;
  }
  if (!self.hasType) {
    return NO;
  }
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (self.hasResult) {
    [output writeString:1 value:self.result];
  }
  if (self.hasType) {
    [output writeEnum:2 value:self.type];
  }
  if (self.hasMessage) {
    [output writeString:3 value:self.message];
  }
  if (self.hasPic) {
    [output writeData:4 value:self.pic];
  }
  if (self.hasVideo) {
    [output writeData:5 value:self.video];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  if (self.hasResult) {
    size += computeStringSize(1, self.result);
  }
  if (self.hasType) {
    size += computeEnumSize(2, self.type);
  }
  if (self.hasMessage) {
    size += computeStringSize(3, self.message);
  }
  if (self.hasPic) {
    size += computeDataSize(4, self.pic);
  }
  if (self.hasVideo) {
    size += computeDataSize(5, self.video);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (Answer*) parseFromData:(NSData*) data {
  return (Answer*)[[[Answer builder] mergeFromData:data] build];
}
+ (Answer*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (Answer*)[[[Answer builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (Answer*) parseFromInputStream:(NSInputStream*) input {
  return (Answer*)[[[Answer builder] mergeFromInputStream:input] build];
}
+ (Answer*) parseDelimitedFromInputStream:(NSInputStream*) input {
  return (Answer*)[[[Answer builder] mergeDelimitedFromInputStream:input] build];
}
+ (Answer*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (Answer*)[[[Answer builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (Answer*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (Answer*)[[[Answer builder] mergeFromCodedInputStream:input] build];
}
+ (Answer*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (Answer*)[[[Answer builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (Answer_Builder*) builder {
  return [[[Answer_Builder alloc] init] autorelease];
}
+ (Answer_Builder*) builderWithPrototype:(Answer*) prototype {
  return [[Answer builder] mergeFrom:prototype];
}
- (Answer_Builder*) builder {
  return [Answer builder];
}
@end

@interface Answer_Builder()
@property (retain) Answer* result;
@end

@implementation Answer_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.result = [[[Answer alloc] init] autorelease];
  }
  return self;
}
- (PBGeneratedMessage*) internalGetResult {
  return result;
}
- (Answer_Builder*) clear {
  self.result = [[[Answer alloc] init] autorelease];
  return self;
}
- (Answer_Builder*) clone {
  return [Answer builderWithPrototype:result];
}
- (Answer*) defaultInstance {
  return [Answer defaultInstance];
}
- (Answer*) build {
  [self checkInitialized];
  return [self buildPartial];
}
- (Answer*) buildPartial {
  Answer* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (Answer_Builder*) mergeFrom:(Answer*) other {
  if (other == [Answer defaultInstance]) {
    return self;
  }
  if (other.hasResult) {
    [self setResult:other.result];
  }
  if (other.hasType) {
    [self setType:other.type];
  }
  if (other.hasMessage) {
    [self setMessage:other.message];
  }
  if (other.hasPic) {
    [self setPic:other.pic];
  }
  if (other.hasVideo) {
    [self setVideo:other.video];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (Answer_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (Answer_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (YES) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 10: {
        [self setResult:[input readString]];
        break;
      }
      case 16: {
        int32_t value = [input readEnum];
        if (ChatRequestTypeIsValidValue(value)) {
          [self setType:value];
        } else {
          [unknownFields mergeVarintField:2 value:value];
        }
        break;
      }
      case 26: {
        [self setMessage:[input readString]];
        break;
      }
      case 34: {
        [self setPic:[input readData]];
        break;
      }
      case 42: {
        [self setVideo:[input readData]];
        break;
      }
    }
  }
}
- (BOOL) hasResult {
  return result.hasResult;
}
- (NSString*) result {
  return result.result;
}
- (Answer_Builder*) setResult:(NSString*) value {
  result.hasResult = YES;
  result.result = value;
  return self;
}
- (Answer_Builder*) clearResult {
  result.hasResult = NO;
  result.result = @"";
  return self;
}
- (BOOL) hasType {
  return result.hasType;
}
- (ChatRequestType) type {
  return result.type;
}
- (Answer_Builder*) setType:(ChatRequestType) value {
  result.hasType = YES;
  result.type = value;
  return self;
}
- (Answer_Builder*) clearType {
  result.hasType = NO;
  result.type = ChatRequestTypeChatTypeSendPtp;
  return self;
}
- (BOOL) hasMessage {
  return result.hasMessage;
}
- (NSString*) message {
  return result.message;
}
- (Answer_Builder*) setMessage:(NSString*) value {
  result.hasMessage = YES;
  result.message = value;
  return self;
}
- (Answer_Builder*) clearMessage {
  result.hasMessage = NO;
  result.message = @"";
  return self;
}
- (BOOL) hasPic {
  return result.hasPic;
}
- (NSData*) pic {
  return result.pic;
}
- (Answer_Builder*) setPic:(NSData*) value {
  result.hasPic = YES;
  result.pic = value;
  return self;
}
- (Answer_Builder*) clearPic {
  result.hasPic = NO;
  result.pic = [NSData data];
  return self;
}
- (BOOL) hasVideo {
  return result.hasVideo;
}
- (NSData*) video {
  return result.video;
}
- (Answer_Builder*) setVideo:(NSData*) value {
  result.hasVideo = YES;
  result.video = value;
  return self;
}
- (Answer_Builder*) clearVideo {
  result.hasVideo = NO;
  result.video = [NSData data];
  return self;
}
@end

