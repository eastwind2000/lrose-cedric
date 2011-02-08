c
c----------------------------------------------------------------------X
c
      SUBROUTINE RNGLIM(XMIN,XMAX,YMIN,YMAX,RX,RN)
C
C     Compute the radar range limits of the plot window
C
      LOGICAL BETX,BETY
      RNG(X,Y)=SQRT(X**2+Y**2)
      BETX=.FALSE.
      BETY=.FALSE.
      IF(XMIN.LE.0..AND.XMAX.GE.0.) BETX=.TRUE.
      IF(YMIN.LE.0..AND.YMAX.GE.0.) BETY=.TRUE.
      RN=0.0
      IF(BETX.AND..NOT.BETY) RN=AMIN1(ABS(YMIN),ABS(YMAX))
      IF(.NOT.BETX.AND.BETY)RN=AMIN1(ABS(XMIN),ABS(XMAX))
      IF(.NOT.BETX.AND..NOT.BETY)RN=AMIN1(RNG(XMIN,YMIN),RNG(XMAX,YMIN),
     +     RNG(XMIN,YMAX),RNG(XMAX,YMAX))
      RX=AMAX1(RNG(XMIN,YMIN),RNG(XMAX,YMIN),RNG(XMIN,YMAX),
     +     RNG(XMAX,YMAX))
      RETURN
      END