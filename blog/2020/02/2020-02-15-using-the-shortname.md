+++
title = "Using the Shortname"
date = Date(2020, 02, 15)
tags = ["code"]
+++

The Shortname is a Windows way of dealing with non-ASCII characters and long file names and paths.

First, let’s create some filenames with bad character inside bad folder names. We will use the character map to generate some commonly used Unicode, non-ASCII characters. We will even use some Arabic characters. See Table 1. Note, that the files with long names longer than 260 characters require special care to generate and is not something a user can do easily. Figure 2 shows the error message windows give you when you try to create a file/path name that is too long.

<figure>

![](images/image.png)

<figcaption>

Figure 1: Windows Character map showing what character sets windows supports.

</figcaption>

</figure>

_Table 1: Shows the files with non-ASCII characters and long file paths along with their shortname._

\[table id=1 /\]

<figure>

![](images/image.png)

<figcaption>

Figure 2: What happens when a path or file name is too long.

</figcaption>

</figure>

If you use the command “dir /s /b example\*.txt” then you get the block of text shown in Block 1. Note that the dir did not return the 8th file path. This is because it has a local folder path longer than 260 characters.

```
C:\Temp\example long file name with non ASCII character 1 - °±ØøθΘﮆﯶﯙ.txt
C:\Temp\Long Folder Name with non ASCII characters 1 - °±ØøθΘﮆﯶﯙ\example long file name with non ASCII character 2 - °±ØøθΘﮆﯶﯙ.txt
C:\Temp\Long Folder Name with non ASCII characters 1 - °±ØøθΘﮆﯶﯙ\example long file name with non ASCII character 3 - °±ØøθΘﮆﯶﯙ.txt
C:\Temp\Long Folder Name with non ASCII characters 1 - °±ØøθΘﮆﯶﯙ\Long Folder Name with non ASCII characters 2 - °±ØøθΘﮆﯶﯙ\example long file name with non ASCII character 4 - °±ØøθΘﮆﯶﯙ - Copy.txt
C:\Temp\Long Folder Name with non ASCII characters 1 - °±ØøθΘﮆﯶﯙ\Long Folder Name with non ASCII characters 2 - °±ØøθΘﮆﯶﯙ\example long file name with non ASCII character 4 - °±ØøθΘﮆﯶﯙ.txt
C:\Temp\Long Folder Name with non ASCII characters 1 - °±ØøθΘﮆﯶﯙ\Long Folder Name with non ASCII characters 2 - °±ØøθΘﮆﯶﯙ\Long Folder Name with non ASCII characters 3 - °±ØøθΘﮆﯶﯙ\example long file name with non ASCII character 5 - °±ØøθΘﮆﯶﯙ.txt
C:\Temp\Long Folder Name with non ASCII characters 1 - °±ØøθΘﮆﯶﯙ\Long Folder Name with non ASCII characters 2 - °±ØøθΘﮆﯶﯙ\Long Folder Name with non ASCII characters 3 - °±ØøθΘﮆﯶﯙ\Long Folder Name with non ASCII characters 4 - °±ØøθΘﮆﯶﯙ\example long file name with non ASCII character 6 - °±ØøθΘﮆﯶﯙ.txt
```

_Block 1_

If instead we dump the command to a text file “dir /s /b example\*.txt > filelist.txt” then we have a problem as shown in Block 2. Some of the non-ASCII characters become question mark characters. This makes working with these files just about unworkable through text files.

```
C:\Temp\example long file name with non ASCII character 1 - øñOo?é???.txt
C:\Temp\Long Folder Name with non ASCII characters 1 - øñOo?é???\example long file name with non ASCII character 2 - øñOo?é???.txt
C:\Temp\Long Folder Name with non ASCII characters 1 - øñOo?é???\example long file name with non ASCII character 3 - øñOo?é???.txt
C:\Temp\Long Folder Name with non ASCII characters 1 - øñOo?é???\Long Folder Name with non ASCII characters 2 - øñOo?é???\example long file name with non ASCII character 4 - øñOo?é??? - Copy.txt
C:\Temp\Long Folder Name with non ASCII characters 1 - øñOo?é???\Long Folder Name with non ASCII characters 2 - øñOo?é???\example long file name with non ASCII character 4 - øñOo?é???.txt
C:\Temp\Long Folder Name with non ASCII characters 1 - øñOo?é???\Long Folder Name with non ASCII characters 2 - øñOo?é???\Long Folder Name with non ASCII characters 3 - øñOo?é???\example long file name with non ASCII character 5 - øñOo?é???.txt
C:\Temp\Long Folder Name with non ASCII characters 1 - øñOo?é???\Long Folder Name with non ASCII characters 2 - øñOo?é???\Long Folder Name with non ASCII characters 3 - øñOo?é???\Long Folder Name with non ASCII characters 4 - øñOo?é???\example long file name with non ASCII character 6 - øñOo?é???.txt
```

_Block 2_

In VBA, the short name is not something that VBA functions are setup to work with. Instead, if you use the “del shortname” through a shell command, then you can delete the file(s). For instance executing the command in Block 3 deletes all 8 files from Table 1 and Block 4 shows that the files no longer exist, which includes the files with long paths. Since I did not obtain the long folder path of file 8 via dir, I am not sure how you would get its short name except for manually generating it.

```
del C:\Temp\EXAMPL~1.TXT C:\Temp\LONGFO~1\EXAMPL~1.TXT C:\Temp\LONGFO~1\EXAMPL~2.TXT C:\Temp\LONGFO~1\LONGFO~1\EXAMPL~2.TXT C:\Temp\LONGFO~1\LONGFO~1\EXAMPL~1.TXT C:\Temp\LONGFO~1\LONGFO~1\LONGFO~1\EXAMPL~1.TXT C:\Temp\LONGFO~1\LONGFO~1\LONGFO~1\LONGFO~1\EXAMPL~1.TXT C:\Temp\LONGFO~1\LONGFO~1\LONGFO~1\LONGFO~1\LONGFO~1\EXAMPL~1.TXT
```

_Block 3_

```
C:\Temp>dir /s /b  example*.txt
File Not Found
```

_Block 4_
