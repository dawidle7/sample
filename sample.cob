       IDENTIFICATION DIVISION.
       PROGRAM-ID. SAMPLE.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT gentoolkitout ASSIGN TO 'sample.gentoolkit.out'
           ORGANIZATION LINE SEQUENTIAL.
           SELECT getinstldpkgout ASSIGN TO 'sample.getinstldpkg.out'
           ORGANIZATION LINE SEQUENTIAL.
           SELECT getallfilesout assign to 'sample.getallfiles.out'
           organization line sequential.

       DATA DIVISION.
       FILE SECTION.
       FD gentoolkitout.
       01 gentoolkitoutRECORD PIC X(222).

       FD getinstldpkgout.
       01 getinstldpkgoutRECORD PIC X(222).

       FD getallfilesout.
       01 getallfilesoutRECORD pic x(222).

       WORKING-STORAGE SECTION.

       01 excl_list pic x(333) value ' -not -path "/dev/*" -a -not -path
      -    ' "/tmp/*" -a -not -path "/proc/*" -a -not -path "/sys/*" -a 
      -    '-not -path "/run/*" '.
       01 excl_add  pic x(222) value spaces.

       01 cmdln_gentoolkit pic x(222) value 'which equery &> sample.gent
      -    'oolkit.out'.
       01 cmdln_getinstldpkg pic x(222) value 'equery f "*" |sort |uniq 
      -    '> sample.getinstldpkg.out'.
       01 cmdln_getallfiles pic x(222) value 'find /etc '.

       01 envusrname pic x(222).

       01 i pic 9(6).
       01 feof pic x.
       01 getinstldpkgouttab occurs 999999 times 
           ascending key is getinstldpkgouttab indexed by j.
           03 getinstldpkgoutline pic x(222).

       01 getallfilesouttab occurs 999999 times.
           03 getallfilesoutline pic x(222).

       PROCEDURE DIVISION.
           accept excl_add from command-line.
           string excl_list ' ' excl_add 
           DELIMITED BY '  ' into excl_list
           on overflow
           Display "A string overflow occurred".
           DISPLAY "Final exclusion list:"excl_list.

           call "SYSTEM" using cmdln_gentoolkit.
           OPEN INPUT gentoolkitout
           READ gentoolkitout INTO gentoolkitoutRECORD
           NOT AT END
           UNSTRING gentoolkitoutRECORD
           DELIMITED BY ALL ":"
           INTO gentoolkitoutRECORD
           if gentoolkitoutRECORD = 'which'              
            DISPLAY "no gentoolkit on this system, suggest to quit"
           else
            DISPLAY gentoolkitoutRECORD
           END-READ
           CLOSE gentoolkitout.  

           DISPLAY "LOGNAME" UPON ENVIRONMENT-NAME
           ACCEPT envusrname FROM ENVIRONMENT-VALUE
           if envusrname = 'root'
            DISPLAY "This is risky. Consider exiting.."
           else
            DISPLAY "running as "envusrname
    
           DISPLAY "Looking for missing files which should be installed"
           call "SYSTEM" using cmdln_getinstldpkg.
           move 1 to i.
           open input getinstldpkgout.
           perform read-path until feof='y'.
           close getinstldpkgout.
           display "files installed: "i.
    
           display "Looking for files present but not installed"
           string cmdln_getallfiles excl_list 
           ' 2>./sample.getallfiles.err 1>./sample.getallfiles.out'
           delimited by '  ' into cmdln_getallfiles
           on overflow
           Display "A string overflow occurred".
      *    display cmdln_getallfiles.
           call "system" using cmdln_getallfiles.
           move 1 to i.
           set feof to ' '.
           open input getallfilesout.
           perform read-pathi until feof='y'.
           close getallfilesout.
           display "files found: "i.
           perform varying i from 1 by 1 until 
           getallfilesouttab(i) = spaces
            set j to 1
            search all getinstldpkgouttab 
               at end display getallfilesouttab(i)'not installed'
               when getinstldpkgouttab(j) is equal to 
               getallfilesouttab(i) initialize getallfilesouttab(i)
      *         display 'omitting installed file 'getallfilesouttab(i)
               end-search
           end-perform
           STOP RUN.

       read-path.
           read getinstldpkgout at end move 'y' to feof.
           if feof is not = 'y' then
               move getinstldpkgoutRECORD to getinstldpkgouttab(i)
               add 1 to i
           end-if.

       read-pathi.
           read getallfilesout at end move 'y' to feof.
           if feof is not = 'y' then
               move getallfilesoutRECORD to getallfilesouttab(i)
               add 1 to i
           end-if.
