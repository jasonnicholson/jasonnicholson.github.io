+++
title = "How to Export Your VBA Macros for Storage in a GIT/SVN Repository"
date = Date(2019,12,06)
rss_description = "How to Export Your VBA Macros for Storage in a GIT/SVN Repository"
tags = [""]
+++

This shows a quick workflow I use to handle VBA Macros so that they are diffed properly in a GIT/SVN repository.

[Here is the example workbook.](../Example%20FIles%20-%20How%20to%20Export%20Your%20VBA%20Macros%20for%20Storage%20in%20a%20GIT,%20SVN%20Repository.zip)

```
Option Explicit
 Sub SaveCodeModules()
 'This code Exports all VBA modules
 Dim i As Integer
 Dim sName As String
 With ThisWorkbook.VBProject
     For i% = 1 To .VBComponents.Count
             sName = .VBComponents(i).CodeModule.Name
             .VBComponents(i).Export ThisWorkbook.Path & "\" & sName$ & ".vb"
     Next i
 End With
 End Sub

```

~~~
<iframe width="560" height="315" src="https://www.youtube.com/embed/r_EDyhGOeCE?si=Ky77am9ZOUHmzdTT" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
~~~
