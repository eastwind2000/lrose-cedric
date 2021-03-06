      SUBROUTINE MYFRAME
C
C  ANNOTATE MICROFILM WITH SHAVANO JOB NUMBER, DATE, TIME AND FRAME NUMBER
C  PLOT MAPPING: ASSUMES LAST CALL SET WAS TO FRACTIONAL COORDINATES
C     CALL SET(0.,1.,0.,1.,0.,1.,0.,1.,1)
C
      COMMON /FRAMES/ IFRAME
      CHARACTER LABL*40,JOBNUM*30,TODAY*8,TYME*8
      DATA NFRAME/0/

      LL=1
      CALL GETSET(FL,FR,FB,FT,UL,UR,UB,UT,LL)
c      print *,'MYFRAME: ul,ur,ub,ut=',ul,ur,ub,ut
c      print *,'MYFRAME: fl,fr,fb,ft=',fl,fr,fb,ft
      CALL SET(0.,1.,0.,1.,0.,1.,0.,1.,1)
      CALL GETENV('QSUB_REQNAME',JOBNUM)
      CALL DATEE(TODAY)
      CALL CLOCK(TYME)
      NFRAME=NFRAME+1
      IFRAME=NFRAME
      WRITE(LABL,105)JOBNUM,TODAY,TYME,NFRAME
105   FORMAT(A8,'(',A8,'--',A8,')--FRAME=',I4)
      print *,'MYFRAME: nframe=',nframe
      print *,' '

      FCX=1018./1024.
      FCY=7./1024.
      CALL PLCHMQ(FCX,FCY,LABL,-0.5,0.,1.)
      CALL FRAME
      CALL SET(FL,FR,FB,FT,UL,UR,UB,UT,1)
      RETURN
      END
