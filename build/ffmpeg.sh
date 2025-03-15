set -euo pipefail

CONF_FLAGS=(
  # 禁用所有默认功能，后续手动启用所需的组件
  --disable-all

  # 启用文件协议，允许读取/写入本地文件
  --enable-protocol=file
  # 启用 libavcodec(编解码库)
  --enable-avcodec
  # 启用 libavfilter(滤镜处理)
  --enable-avfilter
  # 启用 libavformat(封装/解封装库)
  --enable-avformat
  # 启用 libavutil(通用工具库)
  --enable-avutil
  # 启用 libswscale(图像缩放库)
  --enable-swscale
  # 启用 PNG 编解码压缩库
  --enable-zlib

  # --enable-hardcoded-tables

  # 解析 MOV
  --enable-demuxer=mov
  # 解析 MP4
  --enable-demuxer=mp4
  # 解析 WEBM
  --enable-demuxer=webm
  # 解析 FLV
  --enable-demuxer=flv
  # 解析 MKV
  --enable-demuxer=matroska
  # 解析 AVI
  --enable-demuxer=avi
  # WMV 相关解复用器
  --enable-demuxer=asf
  --enable-demuxer=asf_o

  --enable-parser=h264
  # H.264(常见于 MP4, MOV, MKV, FLV)
  --enable-decoder=h264
  # 解析 HEVC(H.265) 视频流
  --enable-parser=hevc
  # HEVC(H.265)(常见于 MP4, MKV)
  --enable-decoder=hevc
  # VP8(常见于 WebM, MKV)
  --enable-decoder=vp8
  # VP9(常见于 WebM, MKV)
  --enable-decoder=vp9
  # AV1(常见于 MKV, MP4)
  --enable-decoder=av1
  # MPEG-4(常见于 MP4, AVI)
  --enable-decoder=mpeg4
  # 微软 MPEG-4 v2(AVI)
  --enable-decoder=msmpeg4v2
  # 微软 MPEG-4 v3(AVI)
  --enable-decoder=msmpeg4v3
  # Xvid 编码(常见于 AVI)
  --enable-decoder=xvid
  # FLV1 视频编码(常见于 FLV)
  --enable-decoder=flv1
  # VP6F(常见于 FLV)
  --enable-decoder=vp6f
  # VP6A(常见于 FLV)
  --enable-decoder=vp6a
  # WMV 解析器
  --enable-parser=wmv1
  --enable-parser=wmv2
  --enable-parser=wmv3
  # WMV 解码器
  --enable-decoder=wmv1
  --enable-decoder=wmv2
  --enable-decoder=wmv3

  # 启用 image2 解复用器
  --enable-demuxer=image2
  # 启用 image2 复用器
  --enable-muxer=image2

  # 启用 PNG 解码(PNG 图片)
  --enable-decoder=png
  # 解析 JPEG 解复用器
  --enable-demuxer=mjpeg

  --enable-muxer=mjpeg

  # 解析 MJPEG 数据流(读取 MJPEG 格式)
  --enable-parser=mjpeg
  # 启用 Motion JPEG(MJPEG)解码
  --enable-decoder=mjpeg
  # 解析 PNG 数据流(读取 PNG 格式)
  
  --enable-parser=png
  # 启用 PNG 编码(输出 PNG)
  --enable-encoder=png
  # 将视频编码为 MJPEG 格式(输出 MJPEG)
  --enable-encoder=mjpeg

  # 允许空滤镜(测试用途)
  --enable-filter=null
  # 允许缩放
  --enable-filter=scale
  # 允许格式转换
  --enable-filter=format
  # 允许颜色空间转换
  --enable-filter=colorspace
  # 允许颜色矩阵调整 修正色偏
  --enable-filter=colormatrix
  # 允许自动校正颜色
  --enable-filter=colorcorrect
  # 允许时间裁剪(-ss 依赖)
  --enable-filter=trim  
  # 允许选择帧(备用)
  --enable-filter=select
  # 通过指定帧率提取帧(如 fps=1 每秒 1 帧)
  --enable-filter=fps
  # 自动选取代表帧(适用于生成缩略图)
  --enable-filter=thumbnail
  # 裁剪图片(如 crop=500:500:100:100)
  --enable-filter=crop
  	# 复制流(如同时保存多种格式)
  --enable-filter=split


  # 目标系统设为 none，禁用特定系统的优化
  --target-os=none
  # 设定架构为 x86_32
  --arch=x86_32
  # 启用交叉编译
  --enable-cross-compile
  # 禁用汇编优化(Emscripten 不支持原生汇编)
  --disable-asm
  # 禁用符号表剥离(避免错误)
  --disable-stripping
  # 禁用 ffmpeg、ffprobe 和 ffplay 可执行文件的编译
  --disable-programs
  # 禁用文档生成
  --disable-doc
  # 禁用调试模式
  --disable-debug
  # 禁用运行时 CPU 侦测
  --disable-runtime-cpudetect
  # 禁用自动检测环境
  --disable-autodetect

  # 设置 nm 工具
  --nm=emnm
  # 设置 ar 工具
  --ar=emar
  # 设置 ranlib 工具
  --ranlib=emranlib
  # 设置 C 编译器为 emcc
  --cc=emcc
  # 设置 C++ 编译器为 em++
  --cxx=em++
  # 设置 Objective-C 编译器为 emcc
  --objcc=emcc
  # 设置依赖编译器为 emcc
  --dep-cc=emcc
  # 额外的 C 语言编译参数
  --extra-cflags="$CFLAGS"
  # 额外的 C++ 语言编译参数
  --extra-cxxflags="$CXXFLAGS"

  # 禁用线程(WebAssembly 需要明确启用多线程)
  ${FFMPEG_ST:+ --disable-pthreads --disable-w32threads --disable-os2threads}
)

# 运行配置脚本
emconfigure ./configure "${CONF_FLAGS[@]}" $@

# 编译 FFmpeg
emmake make -j