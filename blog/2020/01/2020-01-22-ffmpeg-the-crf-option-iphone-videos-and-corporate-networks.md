---
title: FFmpeg, The -crf Option, iPhone Videos, and Corporate Networks
date: 2020-01-22
tags:
- code
---
I use [FFmpeg](https://ffmpeg.org/) on a regular basis for video, audio, and image-related editing. It is a command-line tool that goes from very simple to very complicated. I intend to stick with simple today. The point here is you can save 80-90% of the space used by iPhone, GoPro, or Android Video by re-encoding the video with FFmpeg and the -crf option. Keep reading to learn more.

To use FFmpeg, use something like the following.

```bash
$ ffmpeg -i input.mp4 output.avi
```

The above code will convert an mp4 to an avi using inferred settings and won't change the video's codec. Side note, if you don't know what a video format, container, and codecs are and how they relate, pause and read this link: [Every Video Format, Codec, and Container Explained](https://medium.com/@api.video/every-video-format-codec-and-container-explained-c831f105c716).

The problem I have run into is corporate network drives have lots of iPhone videos that have been stored for future reference. The first time I encountered this problem, I was working for ABC Company (to not name names or blame or whatever) and we ran out space on a network drive. We had several hundred engineers that could no longer work because we ran out space. IT could not expand the Network drive because of a limitation. This upset me. I couldn't believe that this had happened at a large company and no one was doing anything about it. Therefore, I did something about it. I scanned the network to see what was stored on our network drive. The #1 space-consuming filetype was iPhone videos. People had dumped 300GB of iPhone videos onto our network over several years. Therefore I looked for a solution that could re-encode the videos, maintain the format, codec, resolution, framerate, and compatibility but reduce the file size. This is where FFmpeg and the -crf option comes in handy. All you have to do reduce the video size by 80-90% is the use the following code snippet

```bash
 ffmpeg -i inputMovie.mov -crf 28 outputVideo.mov
```

The above code snippet will maintain the format, codec, framerate, resolution, and then adjust the bitrate based on some factors documented better here: [CRF Guide (Constant Rate Factor in x264, x265 and libvpx)](https://slhck.info/video/2017/02/24/crf-guide.html). I usually use a -crf of 28 for my x264 videos which is basically what all iPhone, GoPro, and Android videos are. This is aggressive but the loss of quality is minimal. For instance, a video that was 100MB will be 10MB after re-encoding it with -crf 28 and you can't tell that I re-encoded the video.

The problem is that the bitrate of an iPhone video is an average of 20,000KB/s or more. Often, you don't need that high of bitrate and it is overkill. After using -crf of 28, the bitrate will drop to an average of 2000KB/s or so. The bitrate during the video isn't constant though. The bitrate is variable, you could have a segment of a video that is a bitrate of 10,000KB/s but still have an average 2000KB/s.

The 300GB's of iPhone movies that I found on the ABC Company network, I re-encoded saving around 270GB. This allowed us to start working again on our Corporate Network drive.

Recently I was at XYZ Company, I did a check for videos on the network. We have 1400GB of videos on that Network drive. I am betting that we can save 1100GB by re-encoding the videos.
