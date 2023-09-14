## machine generated, do not edit
type
  Allocator* = object
    alloc*: proc(size: csize_t; userData: pointer): pointer {.cdecl.}
    free*: proc(p: pointer; userData: pointer) {.cdecl.}
    userData*: pointer
  
  Logger* = object
    fn*: proc(tag: cstring; logLevel, logItemId: uint32; msgOrNil: cstring; lineNum: uint32; filenameOrNil: cstring; userData: pointer) {.cdecl.}
    userData*: pointer

  Desc* = object
    maxRequests*: uint32
    numChannels*: uint32
    numLanes*: uint32
    allocator*: Allocator
    logger*: Logger

  Range* = object
    `addr`*: pointer
    size*: csize_t

  Handle* = object
    id*: uint32

  Error* = distinct int32

  Response* = object
    handle*: Handle
    dispatched*: bool
    fetched*: bool
    paused*: bool
    finished*: bool
    failed*: bool
    cancelled*: bool
    errorCode*: Error
    channel*: uint32
    lane*: uint32
    path*: cstring
    userData*: pointer
    dataOffset*: uint32
    data*: Range
    buffer*: Range

  Callback* = proc(res: ptr Response) {.cdecl.}

  Request* = object
    channel*: uint32
    path*: cstring
    callback*: Callback
    chunkSize*: uint32
    buffer*: Range
    userData*: Range

template takeRange*(x: untyped): untyped =
  Range(`addr`: addr(x), size: sizeof(x).csize_t)

proc c_setup(desc: ptr Desc):void {.cdecl, importc:"sfetch_setup".}
proc setup*(desc: Desc):void =
    c_setup(addr(desc))

proc c_send(request: ptr Request): Handle {.cdecl, importc:"sfetch_send", discardable.}
proc send*(req: Request): Handle {.discardable.} =
  c_send(addr(req))

proc c_dowork() {.cdecl, importc:"sfetch_dowork".}
proc doWork*() =
  c_dowork()

{.passc:"-DSOKOL_NIM_IMPL".}
{.compile:"c/sokol_fetch.c".}
