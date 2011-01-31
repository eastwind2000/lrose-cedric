      SUBROUTINE AZMFIL(KRD,AZCOR,IAZFLG,DASANG)
C
C        FILLS COMMON /SETAZM/
C        FORMAT OF AZMFIL CARD
C
C
C   VARIABLE  DESCRIPTION                  FIELD  NOTES
C   --------  -----------                  -----  -----
C
C   KOMM      'AZI'                         P1    COMMAND
C   LAL       LEFT AZIMUTH LIMIT            P2
C   RAL       RIGHT AZIMUTH LIMIT           P3
C   MGAP      MAXIMUM ALLOWABLE GAP         P4
C   SPAC      MINIMUM NOMINAL SPACING       P5
C   SCANTP    SCAN TYPE                     P6    'SUR' SURVEILLANCE(360)
C                                                 'SEC' SECTOR (DEFAULT)
C   SCDIR     SCAN (FORCE) DIRECTION        P7    IF <0 COUNTERCLOCKWISE
C                                                 IF >0 CLOCKWISE
C                                                 IF =0 INACTIVE
C                                                          (PROGRAM DECIDES)
C
C
      CHARACTER*8 KRD(10),CASANG
      COMMON /AZSUB/ AT1,AT2,IFLAG,IFLADJ
      COMMON /SETAZM/ USAZ1,USAZ2,USGAP,USINC,IFOR36,IFORDR
      CHARACTER KSWICH(2)*3
      CHARACTER NAMSCN(3)*16
      CHARACTER*2 ITEST
      DATA KSWICH/'OFF','ON'/
      DATA NAMSCN/'COUNTERCLOCKWISE','SPRINT DECIDES','CLOCKWISE'/




      READ (KRD,100)USAZ1,USAZ2,USGAP,USINC,ITEST,FORDR,AZCORV,CASANG
 100  FORMAT(/F8.0/F8.0/F8.0/F8.0/A2/F8.0/F8.0/A8)
C 100 FORMAT(8X,4F8.0,A2,6X,F8.0)
C      IF(USGAP.LE.0.0) USGAP=5.0
      USINC=AMAX1(USINC,1.0)
      IFOR36=0
      IF(ITEST.EQ.'SU') IFOR36=1
      IFORDR=0
      IF(IFOR36.NE.0) THEN
      IF(FORDR.NE.0.0) IFORDR=SIGN(1.0,FORDR)
      END IF
      IF (KRD(8).NE.' ') THEN
         AZCOR=AZCORV
         IAZFLG=1
         IF (AZCOR.GT.360.0) AZCOR=AZCOR-360.0
c         IF (AZCOR.LT.0.0) AZCOR=AZCOR+360.0
c         IF (AZCOR.GT.360.0 .OR. AZCOR.LT.0.0) THEN
c            WRITE(*,117)AZCOR
c 117        FORMAT(//,5X,'***BAD AZIMUTH CORRECTION VALUE:',F8.2)
c            STOP
c         END IF
      END IF
      IF (USAZ1.NE.0.0 .OR. USAZ2.NE.0.0) THEN
C
C     CALCULATE LIMITS FOR SUBSECTIONING, TAKING INTO ACCOUNT 360 CROSSOVERS
C
         IFLAG=1
         IF (USAZ1.LT.USAZ2) THEN
            AT1=USAZ1-USINC
            IFLADJ=0
            AT2=USAZ2+USINC
         ELSE
            AT1=USAZ1-USINC
            IFLADJ=1
            AT2=USAZ2+USINC+360.0
         END IF

      ELSE
C
C     NO AZIMUTH SUBSECTIONING
C
         IFLAG=0
      END IF
C
C        TEST FOR CONSISTENCY
C
      IF (USGAP.GT.0.0) THEN
         IF (USAZ1.EQ.0.0 .AND. USAZ2.EQ.0.0) THEN
            USAZ2=360.0
         END IF
         DAZ=USAZ2 - USAZ1
         IF (DAZ.LT.0.0) DAZ=DAZ+360.0
         IF (DAZ.LT.USGAP .OR. USGAP.LT.USINC) THEN
            PRINT 102, DAZ,USGAP,USINC
  102       FORMAT(5X,'DAZ=',F6.1,'  MUST BE > USGAP=',F6.1,
     X                '  WHICH MUST BE > USINC=',F6.1)
            STOP
         END IF
      END IF
C      IF(USAZ1.NE.0.0.OR.USAZ2.NE.0.0) THEN
C         DAZ=USAZ2-USAZ1
C         IF(DAZ.LT.0.0) DAZ=DAZ+360.0
C         IF(DAZ.LT.2.0*USGAP.OR.USGAP.LT.2.0*USINC) THEN
C            PRINT 102, DAZ,USGAP,USINC
C  102       FORMAT(5X,'DAZ=',F6.1,'  MUST BE (2X) USGAP=',F6.1,
C     X                '  WHICH MUST BE (2X) USINC=',F6.1)
C            STOP
C         END IF
C      END IF
C
C
      IF (CASANG.EQ.' ') THEN
         DASANG=-999.0
      ELSE
         READ(CASANG,203)DASANG
 203     FORMAT(F8.2)
      END IF
      PRINT 885
885   FORMAT(//5X,'SUMMARY OF AZIMUTH COMMAND ')
      PRINT 887
887   FORMAT(5X,'------- -- ------- ------- ')
      IF(USAZ1.EQ.0.0.AND.USAZ2.EQ.0.0 .AND. USGAP.EQ.0.0) THEN
         PRINT 101
  101    FORMAT(/16X,'+++  AZIMUTH SUBSECTIONING/FILL NOT IN',
     X               ' EFFECT  +++')
      END IF
         PRINT 103, USAZ1,USAZ2,USGAP,USINC,KSWICH(IFOR36+1)
103   FORMAT(/16X,'      LEFT AZIMUTH LIMIT: ',F5.1,' DEGREES',
     X       /16X,'     RIGHT AZIMUTH LIMIT: ',F5.1,' DEGREES',
     X       /16X,'   MAXIMUM ALLOWABLE GAP: ',F5.1,' DEGREES',
     X       /16X,' MINIMUM NOMINAL SPACING: ',F5.1,' DEGREES',
     X       /16X,'SURVEILLANCE SCAN SWITCH: ',A3)
C
      IF (IFOR36.EQ.1) THEN
         PRINT 889, NAMSCN(IFORDR+2)
889      FORMAT(16X,'          SCAN DIRECTION: ',A16)
      END IF
      PRINT 923, AZCOR
 923  FORMAT(16X, '      AZIMUTH CORRECTION: ',F8.2,' DEGREES')
      IF (CASANG.NE.' ') THEN
         PRINT 943, DASANG
 943     FORMAT(16X, '        BASELINE ANGLE: ',F8.2,' DEGREES')
      END IF
      PRINT 561
561   FORMAT(/)


C
      RETURN
      END