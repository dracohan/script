Usage: ./xPatchGenTool
Input:  1. Module Label
	2. BSC version and subversion
Output: Patch in RPM format under ./BSCVERSION/DATE folder
Notice: 1. Put default blddef.csv under same folder of xPatchGenTool before execute
	2. Don't use blank space and specific symbols in patch generation reasons.
	
Example: 
Patch reqeust - 
"Hello Han Baowei,
  The following patches are delivered based on AL04E/002
1. DH_TCU.SH_AL4D_PATCH_002
2. BSSAP_SSM2.SH_AL4F_PATCH_002
 
Please note: DCTPD00658511 is also merged to DH_TCU. 
Thanks & Regards, 
Luvita" 

Steps -
(step 0) put default blddef.csv under current folder; cleartool setview ***; 
(step 1) execute  ./xPatchGenTool.pl without any parameter. 
(step 2) copy/paste labels you get. It's case insensitive and will ignore blank line. Press CTRL+D to end the input.  
(step 3-8) same as previous tool.

Record - 

bash-3.00$ ./xPatchGenTool.pl(step 1)

HAVE YOU PLACED DEFAULT BLDDEF.CSV INTO CURRENT FOLDER? [Y/N] Y

PLEASE ENTER THE MODULE LABELS YOU WANT TO PATCH. I.E:
        ME_HSK_3.SH_AL4D_PATCH_001
        RF_MGT_L3_CCCH.WI_AL4C_PATCH_008
        RF_MGT_L3.WI_AL4C_PATCH_006
        RF_MGT_L3_SSM4.WI_AL4C_PATCH_006
        SDCCH_RM_SSM.WI_AL4C_PATCH_006
        TELECOM_SUPERV_MOD.WI_AL4F_PATCH_001
CTRL^D TO END THE INPUT:
DH_TCU.SH_AL4D_PATCH_002
BSSAP_SSM2.SH_AL4F_PATCH_002
^D(step 2)
Please  Enter your complete Email ID [PUTCHA.LAKSHMINARAYANA] : Baowei.Han(step 3)

PLEASE ENTER THE BUILD VERSION                   [AX05A]   :    AL04E(step 4)

PLEASE ENTER THE BUILD SUB VERSION               [001]     :    002(step 5)


                PATCH-VCENAME WILL BE LIKE VDTCAL04.04E.P***
                BUILD_VERSION WILL BE      al04e
                BUILD_SUB_VERSION WILL BE  002
                Your Email ID is           Baowei.Han@alcatel-sbell.com.cn
                ACCEPT [Y/N]: 
 Y(step 6)
Please Enter the Reason for making this patch:  Luvita(step7)
2 modules are being patched [Y/N]:  Y(step 8)
.
..
...
=========================================================================================
        PLEASE FIND YOUR PATCH UNDER FOLDER ./AL04E002/2012-4-1-10-59
=========================================================================================
