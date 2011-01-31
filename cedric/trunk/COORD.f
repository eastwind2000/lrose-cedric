      SUBROUTINE COORD(KRD,ICORD)
C
C     THIS SUBROUTINE SETS A FLAG THAT INDICATES WHAT TYPE OF COORDINATE
C     SYSTEM THE DATA IS TO INTERPRETED AS BEING IN.
C
C     ICORD=0 ==>  COORDINATE SYSTEM DETERMINED FROM ID WORDS 16 & 17
C     ICORD=1 ==>  COORDINATE SYSTEM WILL BE TREATED AS 3-D CARTESIAN
C     ICORD=2 ==>  COORDINATE SYSTEM WILL BE TREATED AS COPLANE
C
      INCLUDE 'CEDRIC.INC'
      COMMON /VOLUME/ INPID(NID),ID(NID),NAMF(4,NFMAX),SCLFLD(NFMAX),
     X                IRCP(NFMAX),MAPVID(NFMAX,2),CSP(3,3),NCX(3),
     X                NCXORD(3),NFL,NPLANE,BAD
      CHARACTER*2 NAMF
      COMMON /AXUNTS/ IUNAXS,LABAXS(3,3),SCLAXS(3,3),AXNAM(3)
      CHARACTER*4 AXNAM,CTEMP
      CHARACTER*(*) KRD(10)
      CHARACTER*8 CORD

      READ(KRD,50)CORD
 50   FORMAT(/A8)
      AXNAM(1)='X'
      AXNAM(2)='Y'
      IF (CORD(1:4).EQ.'CART') THEN
         WRITE(*,250)
 250     FORMAT(/10X,'COORDINATE SYSTEM SET TO CARTESIAN',/)
         CTEMP='CR'
         READ(CTEMP,10)ID(16)
 10      FORMAT(A2)
         CTEMP='T '
         READ(CTEMP,10)ID(17)
C         ID(16)='CR'
C         ID(17)='T '
         ICORD=1
         CTEMP='KM'
         READ(CTEMP,10)LABAXS(3,1)
C         LABAXS(3,1)='KM'
         AXNAM(3)='Z'
      ELSE IF (CORD(1:7).EQ.'COPLANE') THEN
         WRITE(*,200)
 200     FORMAT(/10X,'COORDINATE SYSTEM SET TO COPLANE',/)
         CTEMP='CO'
         READ(CTEMP,10)ID(16)
         CTEMP='PL'
         READ(CTEMP,10)ID(17)
C         ID(16)='CO'
C         ID(17)='PL'
         ICORD=2
         CTEMP='DEG'
         READ(CTEMP,20)LABAXS(3,1)
 20      FORMAT(A3)
C         LABAXS(3,1)='DEG'
         AXNAM(3)='C'
      ELSE 
         CALL CEDERX(593,1)
         RETURN
      END IF

      RETURN
      END
