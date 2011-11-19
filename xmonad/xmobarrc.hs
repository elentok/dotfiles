Config { font = "xft:Ubuntu Mono:size=12:bold:antialias=true"  
    , bgColor = "#000000"  
    , fgColor = "grey"  
    , position = Static { xpos = 0 , ypos = 0, width = 1920, height = 16 }  
    , commands = [ Run Cpu ["-L","3","-H","50","--normal","green","--high","red"] 10  
          , Run Network "eth0" ["-L","0","-H","70","--normal","green","--high","red"] 10   
          , Run Memory ["-t","Mem: <usedratio>%"] 10  
          --, Run Com "/home/lulz/scripts/cputemp.sh" [] "cpuTemp" 10  
          , Run Date "%a %b %_d %l:%M" "date" 10  
          --, Run Com "/home/lulz/scripts/volume.sh" [] "volume" 10  
          , Run StdinReader  
          ]  
    , sepChar = "%"  
    , alignSep = "}{"  
    --, template = " %StdinReader%}{ <fc=grey>%cpu% </fc> <fc=red>%cpuTemp%</fc>°C<fc=grey> ~ %memory% ~ %eth0%</fc> ~ <fc=#ee9a00>%date%</fc> ~ Vol: <fc=green>%volume%</fc> "  
    , template = " %StdinReader%}{ <fc=grey>%cpu% </fc> <fc=grey> ~ %memory% ~ %eth0%</fc> ~ <fc=#ee9a00>%date%</fc> ~ "  
    }  
