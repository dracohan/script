if [ "1" == "0" ]; then
cp /tftpboot/rpm/VDTCAL04.04D-R1.0-P1.i686.rpm /root
cp /tftpboot/rpm/SDTCAL04.04D-R1.0-P1.i686.rpm /root
cp /tftpboot/rpm/VTCUAL04.04D-R1.0-P1.i686.rpm /root
cp /tftpboot/rpm/STCUAL04.04D-R1.0-P1.i686.rpm /root
cp /tftpboot/rpm/VSYSAL04.04D-R1.0-P1.i686.rpm /root
cp /tftpboot/rpm/SSYSAL04.04D-R1.0-P1.i686.rpm /root
cp /tftpboot/rpm/VOSIAL04.04D-R1.0-P1.i686.rpm /root
cp /tftpboot/rpm/SOSIAL04.04D-R1.0-P1.i686.rpm /root
cp /tftpboot/rpm/VTSCAL04.04D-R1.0-P1.i686.rpm /root
cp /tftpboot/rpm/STSCAL04.04D-R1.0-P1.i686.rpm /root

./RPMPatch_Tool_v2.1.3.pl VDTCAL04.04D-R1.0-P1.i686.rpm SDTCAL04.04D-R1.0-P1.i686.rpm MXSWAL04.04D
./RPMPatch_Tool_v2.1.3.pl VTCUAL04.04D-R1.0-P1.i686.rpm STCUAL04.04D-R1.0-P1.i686.rpm MXSWAL04.04D
./RPMPatch_Tool_v2.1.3.pl VSYSAL04.04D-R1.0-P1.i686.rpm SSYSAL04.04D-R1.0-P1.i686.rpm MXSWAL04.04D
./RPMPatch_Tool_v2.1.3.pl VOSIAL04.04D-R1.0-P1.i686.rpm SOSIAL04.04D-R1.0-P1.i686.rpm MXSWAL04.04D
./RPMPatch_Tool_v2.1.3.pl VTSCAL04.04D-R1.0-P1.i686.rpm STSCAL04.04D-R1.0-P1.i686.rpm MXSWAL04.04D
fi

#if [ "1" == "0" ]; then
./RPMPatch_Tool_v2.1.3.pl VDTCAL04.04D.P016-R1.0-P1.i686.rpm SDTCAL04.04D.P013-R1.0-P1.i686.rpm MXSWAL04.04D
./RPMPatch_Tool_v2.1.3.pl VTCUAL04.04D.P015-R1.0-P1.i686.rpm STCUAL04.04D.P011-R1.0-P1.i686.rpm MXSWAL04.04D
./RPMPatch_Tool_v2.1.3.pl VSYSAL04.04D.P013-R1.0-P1.i686.rpm SSYSAL04.04D.P010-R1.0-P1.i686.rpm MXSWAL04.04D
./RPMPatch_Tool_v2.1.3.pl VOSIAL04.04D.P012-R1.0-P1.i686.rpm SOSIAL04.04D.P008-R1.0-P1.i686.rpm MXSWAL04.04D
#fi
