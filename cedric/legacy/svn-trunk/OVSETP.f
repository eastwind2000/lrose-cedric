      SUBROUTINE OVSETP(IPTYP,K)
C
C        RETURNS THE TYPE OF PLOT TO GENERATE FOR THE NEXT PORTION
C                OF THE OVERLAY AND FILLS IN THE APPROPRIATE SPECS
C
C        IPTYP- PLOT TYPE: =0, CONTOUR
C                          =1, ALPHA
C                          =2, DIGITAL
C            K- OVERLAY PLOT NUMBER
C
C
      INCLUDE 'CEDRIC.INC'
c      PARAMETER (MXVSCT=20)
      PARAMETER (MAXLEV=61)
      COMMON /OVRLAY/ IOLAY,NPOLAY(5,MXVSCT),ICOLAY(10)
      COMMON /CONTUR/ CLB(MAXLEV,NFMAX),NLB(NFMAX),ICSPCS(10,NFMAX)
C
      IV=NPOLAY(IOLAY,K)
      IF(IOLAY.EQ.1) THEN
C
C        PRIMARY PLOT
C
         IPTYP=0
         CALL COPIX(ICOLAY,ICSPCS(1,IV),10)
         ICOLAY(3)=NPOLAY(4,K)
         IF(NPOLAY(3,K).NE.0) ICOLAY(6)=0
      ELSE
C
C        OVERLAY PLOT
C
         IPTYP=NPOLAY(3,K)
         IF(IPTYP.EQ.0) THEN
C
C           CONTOUR PLOT
C
            ICOLAY(1)=ICSPCS(1,IV)
            ICOLAY(2)=ICSPCS(2,IV)
            ICOLAY(3)=NPOLAY(5,K)
            ICOLAY(4)=ICSPCS(4,IV)
            ICOLAY(5)=ICSPCS(5,IV)
            ICOLAY(6)=MAX0(0,ICSPCS(6,IV)-ICOLAY(6))
            ICOLAY(7)=MAX0(0,ICSPCS(7,IV)-ICOLAY(7))
C
C                   POSSIBLE VALUES ARE 0,1,2,3 AND WE DON'T WANT OVERLAP
C
                    I=ICEDAND(ICSPCS(8,IV),ICOLAY(8))
            ICOLAY(8)=ICEDXOR(I,ICSPCS(8,IV))
            ICOLAY(9)=ICSPCS(9,IV)
         END IF
      END IF
      RETURN
      END