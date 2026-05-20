&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DECLARATIONS V-table-Win 

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update Information" Procedure _INLINE
/* Actions: ? ? ? ? adm/support/proc/ds_pa_01.w */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure
/******************************************************************************/
/* @COPYRIGHT@                                                                */
/* Project: proALPHA                                                          */
/*                                                                            */
/* Name   : s_artikw.p                                                        */
/* Product: STAMM - Übergreifende Stammdaten                                  */
/* Module : KERN - Kernfunktionen (alter Standard)                            */
/*                                                                            */
/* Created: 3.00 as of 18.02.21997/Michael Schmidt                            */
/* Current: @PAVERSION@ as of @PADATE@/@PALASTAUTHOR@                         */
/*                                                                            */
/*----------------------------------------------------------------------------*/
/* DESCRIPTION                                                                */
/*----------------------------------------------------------------------------*/
/*                                                                            */
/* S_Artikel (DB Trigger Update)                                              */
/*                                                                            */
/*----------------------------------------------------------------------------*/
/* PARAMETERS                                                                 */
/*----------------------------------------------------------------------------*/
/* Name                      Description                                      */
/*----------------------------------------------------------------------------*/
/*                                                                            */
/*----------------------------------------------------------------------------*/
/* HISTORY                                                                    */
/*----------------------------------------------------------------------------*/
/* @FILEHISTORY@                                                              */
/******************************************************************************/

trigger procedure for write of S_Artikel old buffer old_S_Artikel.

/* Procedure information                                                      */

&GLOBAL-DEFINE pa-Autor             Michael Schmidt
&GLOBAL-DEFINE pa-Version           @PAVERSION@
&GLOBAL-DEFINE pa-Datum             @PADATE@
&GLOBAL-DEFINE pa-Letzter           @PALASTAUTHOR@

&GLOBAL-DEFINE pa-GenVersion       OEA
&GLOBAL-DEFINE pa-ProgrammTyp      Trigger
&GLOBAL-DEFINE pa-XBasisName       s_artikw_p

/* Type specific global definitions (prior to parameter definition!) ---------*/

&GLOBAL-DEFINE pa-TriggerFunktion  WRITE
&GLOBAL-DEFINE pa-TriggerTabelle   S_Artikel

/* Globals -------------------------------------------------------------------*/

{adm/template/incl/dt_trg10.df}

&GLOBAL-DEFINE exclude-pa_oGetUIProcedure true

/* SCOPEDs  ------------------------------------------------------------------*/

/* {mawi/lager/incl/ml_lag05.lib} */
&SCOPED-DEFINE EXCLUDE-lcheck__Bedarfe                  yes
&SCOPED-DEFINE EXCLUDE-lcheck__InventurVar              yes
&SCOPED-DEFINE EXCLUDE-lcheck__Lagerumbuchungsbelege    yes
&SCOPED-DEFINE EXCLUDE-ccheck_PP_WorkOrderBomLines      yes
&SCOPED-DEFINE EXCLUDE-ccheck_P_BillOfMaterials         yes
&SCOPED-DEFINE EXCLUDE-ccheck_PurchasingDocuments       yes
&SCOPED-DEFINE EXCLUDE-ccheck_SalesDocuments            yes
&SCOPED-DEFINE EXCLUDE-cCheck_ProvidedParts             yes
&SCOPED-DEFINE EXCLUDE-cCheck_OperationMaterialposition yes

/* Variables -----------------------------------------------------------------*/
/* gcLocalization      localization of company                                */
/* gcItemTypeOld/New   string representation of (Old_)S_Artikel.ArtikelArt    */
/* glartvar            part has variants yes/no                               */
/* gcListOfStateKeys   list with keys of regions of origin                    */
/* gcListOfStateDesc   list with descriptions of regions of origin            */
/* giOldMRPCategory    Old MRP category                                       */
/*----------------------------------------------------------------------------*/

define variable gcLocalization     as character  no-undo.
define variable gcItemTypeOldPart  as character  no-undo.
define variable gcItemTypeNewPart  as character  no-undo.
define variable glartvar           as logical    no-undo.
define variable gcListOfStateKeys  as character  no-undo.
define variable gcListOfStateDesc  as character  no-undo.
&IF lookup("MD":U,"{&PA-MODULE}":U) > 0 &THEN         
  define variable giOldMRPCategory as integer    no-undo.
&ENDIF

&IF lookup("P_":U,"{&PA-MODULE}":U) > 0 &THEN
  define variable glDelSuppParts   as logical    no-undo.
&ENDIF

/* Buffer ********************************************************************/

define buffer gbS_ArtAlternativ for S_ArtAlternativ.
&IF LOOKUP("VS","{&PA-MODULE}") > 0
  AND LOOKUP("VS_SAUF","{&PA-OPTIONEN}") > 0 &THEN
  define buffer gbVS_AuftragPos for VS_AuftragPos.
  define buffer gbVS_AuftragMKT for VS_AuftragMKT.
&ENDIF
&IF   LOOKUP ('VF_INTRA':U,'{&PA-OPTIONEN}':U) > 0
   OR LOOKUP ('E_INTRA':U,'{&PA-OPTIONEN}':U)  > 0 &THEN
  define buffer gbS_Firma for S_Firma.
&ENDIF
&IF LOOKUP("PP","{&PA-MODULE}") > 0 &THEN
  define buffer gbPPT_Orderpart   for PPT_Orderpart.
  define buffer gbPP_Auftrag      for PP_Auftrag.
  define buffer gbPP_Auftrag-Head for PP_Auftrag.
  define buffer gbPP_StkZeile     for PP_StkZeile.
  define buffer gbMB_Aktivitaet   for MB_Aktivitaet.
&ENDIF

/* --> WH2015-07-010 cpl Streckenmix im Vertriebsbeleg */
&IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
define buffer buS_VersandArt     for S_Versandart.
define buffer buS_VersandArt-Old for S_Versandart.
&ENDIF
/* <-- WH2015-07-010 cpl Streckenmix im Vertriebsbeleg */
/* --> CE2017-03-001-03 MDe Erzeugen temporärer Strukturen: Austausch von Poolteilen */
&IF LOOKUP("U_CE":U,"{&PA-OPTIONEN}":U) > 0 &THEN
define buffer gbuS_ArtAlternativ          for   S_ArtAlternativ.
define buffer gbuUSL_ManuAlternPartUsage  for USL_ManuAlternPartUsage.
&ENDIF /* U_CE */
/* <-- CE2017-03-001-03 MDe Erzeugen temporärer Strukturen: Austausch von Poolteilen */

&IF LOOKUP("U_CE":U,"{&PA-OPTIONEN}":U) > 0 &THEN

define buffer gbuBG_FKopf        for BG_FKopf.
define buffer gbuS_SNRTyp_SNR    for S_SNRTyp.
define buffer gbuS_SNRTyp_ESNR   for S_SNRTyp.

&ENDIF /* U_CE */

&IF LOOKUP("SO","{&PA-MODULE}") > 0 
  AND LOOKUP("SB-QM-Master":U,"{&PA-OPTIONEN}":U) > 0 &THEN

define variable glQMRelevantUnchanged  as logical no-undo.

&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow:
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB)
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 10
         WIDTH              = 50.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure
/* ************************* Included-Libraries *********************** */

{adm/method/incl/dm_trg00.lib}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure

/* bedingt eingebundene Libraries, Temp-Tables */

&IF LOOKUP("MP","{&PA-MODULE}") > 0 &THEN

  {mawi/platz/incl/mp_gew00.lib}

&ENDIF

&IF LOOKUP("ML","{&PA-MODULE}") > 0 &THEN

  {mawi/lager/incl/ml_lag05.lib}

&ENDIF

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Common pre-processing                                                      */

{adm/template/incl/dt_trg10.if}

/* A valid company has to be supplied to determine a records localization.    */

if S_Artikel.Firma > '':U then
  gcLocalization = pACConnectionSvc:cLocalizationOfCompany(S_Artikel.Firma).

&IF   LOOKUP ('VF_INTRA':U,'{&PA-OPTIONEN}':U) > 0
   OR LOOKUP ('E_INTRA':U,'{&PA-OPTIONEN}':U)  > 0 &THEN

  /* used to determine regions of origin                                      */

  find gbS_Firma
    where gbS_Firma.Firma = S_Artikel.Firma
    no-lock.

&ENDIF

assign
  gcItemTypeOldPart = string(Old_S_Artikel.ArtikelArt)
  gcItemTypeNewPart = string(S_Artikel.ArtikelArt)
  .

/* Check integrity                                                            */

if S_Artikel.ArtikelArt = {&pa_S_PT_PhantomAssembly}
  and not can-do(S_Artikel.StkZeilenArt,{&pa_S_StkZeilenArt_FiktiveBaugruppe}) then
  S_Artikel.StkZeilenArt = adm.method.cls.DMCStringSvc:cStringListAddItem
                            (S_Artikel.StkZeilenArt,
                             {&pa_S_StkZeilenArt_FiktiveBaugruppe}).

run Pruefung (    S_Artikel.archiviert <> Old_S_Artikel.archiviert
              and S_Artikel.archiviert  = no).

&IF "{&pa_S_F_EcoTax}":U = "1":U &THEN

  if gcLocalization = 'F':U then
  do:

    {adm/template/incl/dt_trg11.if
      &ippOIDTable     = "SBM_F_EcoCode"
      &ippAllowBlank   = "yes"
      &ippErrorMessage = "'s_trgf0012':U"
    }

    if    S_Artikel.SBM_F_EcoCode_Obj > '':U
      and not can-find(first SBM_F_EcoAmount
                         where SBM_F_EcoAmount.SBM_F_EcoCode_Obj = S_Artikel.SBM_F_EcoCode_Obj) then
    do:

      find SBM_F_EcoCode
        where SBM_F_EcoCode.SBM_F_EcoCode_Obj = S_Artikel.SBM_F_EcoCode_Obj
        no-lock.

      adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
        ('s_trgf0013':U,
         SBM_F_EcoCode.SBM_F_EcoCode_ID).

    end.

    if    S_Artikel.F_EcoTax          = no
      and S_Artikel.SBM_F_EcoCode_Obj > '':U then

      adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
        ('s_trgf0014':U,
         S_Artikel.Artikel).

    if    S_Artikel.F_EcoTax                = yes
      and S_Artikel.SBM_CustomsTariffNo_Obj = '':U then

      adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
        ('s_trgf0023':U,
         S_Artikel.Artikel).

  end. /* if gcLocalization = 'F':U */

&ENDIF

if    gcLocalization            = 'H':U
  and S_Artikel.H_CustomSpecNo <> Old_S_Artikel.H_CustomSpecNo
  and S_Artikel.H_CustomSpecNo  > '':U
  and not can-find(S_H_CustomSpecNo
                     where S_H_CustomSpecNo.Firma        = {firma/sbmcusta.fir S_Artikel.Firma}
                       and S_H_CustomSpecNo.CustomSpecNo = S_Artikel.H_CustomSpecNo) then
  adm.method.cls.DMCMessageSvc:prpoInstance:showError
    ('s_trgh0002':U,
     S_Artikel.H_CustomSpecNo).

/* Processing                                                                 */

if S_Artikel.Anlagezeit = '':U then
  run Neuanlage.
else
  run Aendern.

/* --> WH2015-07-010 cpl Streckenmix im Vertriebsbeleg */
&IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
if Old_S_Artikel.uCI_Versandart <> S_Artikel.uCI_Versandart then
do:
  find buS_VersandArt
    where buS_Versandart.Firma      = {firma/sversart.fir S_Artikel.Firma}
      and buS_Versandart.Versandart = S_Artikel.uCI_VersandArt
    no-lock no-error.

  /* Dropshipment and Set is no allowed */
  if available buS_VersandArt
    and (can-do({&pa_S_PTList_VariantPartTypes},string(S_Artikel.Artikelart))
         or can-do({&pa_S_PTList_Set},string(S_Artikel.Artikelart))) then
    adm.method.cls.DMCMessageSvc:prpoInstance:showError
       ('usart00001':U,
        string(S_Artikel.Artikel),
        string(S_Artikel.uCI_VersandArt),
        string(S_Artikel.Artikelart)).

  /* check for present shippingtype  */
  if S_Artikel.uCI_Versandart <> ?
    and not available buS_VersandArt then
    adm.method.cls.DMCMessageSvc:prpoInstance:showError
      ('s_trg00125':U,
        string(S_Artikel.uCI_VersandArt)).

  find buS_VersandArt-Old
    where buS_VersandArt-Old.Firma      = {firma/sversart.fir S_Artikel.Firma}
      and buS_VersandArt-Old.Versandart = Old_S_Artikel.uCI_VersandArt
    no-lock no-error.

  adm.method.cls.DMCTriggerSvc:prpoInstance:updateRelatedOIDReference(if available buS_VersandArt-Old then
                                                                        buS_VersandArt-Old.S_Versandart_Obj
                                                                      else
                                                                        '':U,
                                                                      if available buS_VersandArt then
                                                                        buS_VersandArt.S_Versandart_Obj
                                                                      else
                                                                        '':U,
                                                                      S_Artikel.S_Artikel_Obj,
                                                                      'uCI_Versandart':U ).
end.
&ENDIF
/* <-- WH2015-07-010 cpl Streckenmix im Vertriebsbeleg */

/* --> CE2017-03-001-03 MDe Erzeugen temporärer Strukturen: Austausch von Poolteilen */
&IF LOOKUP("U_CE":U,"{&PA-OPTIONEN}":U) > 0 &THEN
if   OLD_S_Artikel.uCE_TypeInstallationVariant  <> S_Artikel.uCE_TypeInstallationVariant
  or OLD_S_Artikel.ArtikelArt                   <> S_Artikel.ArtikelArt then
  branche.stamm.cls.USCPartManufacturerSvc:prpoInstance:checkTypeInstallationVariant
    (S_Artikel.uCE_TypeInstallationVariant,
     S_Artikel.Artikel,
     S_Artikel.ArtikelArt).


if OLD_S_Artikel.uCE_TypeInstallationVariant <> S_Artikel.uCE_TypeInstallationVariant then
do:

  case S_Artikel.uCE_TypeInstallationVariant:

    /* manufacturer structure part */

    when 1 then

      /* create workflow */

      basis.buro.cls.BBCWorkflowSvc:prpoInstance:createWorkflow
        (S_Artikel.S_Artikel_Obj,
         S_Artikel.S_Artikel_Obj,
         S_Artikel.Firma,
         'S_A':U,
         {&uCE_S_AWorkflowEvent_2},
         S_Artikel.Verteilergruppe,
         '':U,
         ?,
         '':U,
         '':U,
         ?).

    otherwise

      /* delete workflow */

      basis.buro.cls.BBCWorkflowSvc:prpoInstance:cancelWorkflow
        (S_Artikel.S_Artikel_Obj,
         S_Artikel.Firma,
         'S_A':U,
         {&uCE_S_AWorkflowEvent_2}).

  end case. /* S_Artikel.uCE_TypeInstallationVariant */

end. /* type of installation variant changed */

if  ( OLD_S_Artikel.archiviert <> S_Artikel.archiviert
  and S_Artikel.archiviert      = yes
  and branche.stamm.cls.USCPartManufacturerSvc:prpoInstance:lIsManufacturerAlternativePart
        (S_Artikel.Artikel) ) then

  FE_gbuS_ArtAlternativ:
  for each gbuS_ArtAlternativ
    where gbuS_ArtAlternativ.Firma             = {firma/sartikel.fir S_Artikel.Firma}
      and gbuS_ArtAlternativ.AlternativArtikel = S_Artikel.Artikel
      and gbuS_ArtAlternativ.Typ               begins 'E':U
    no-lock,
    each gbuUSL_ManuAlternPartUsage
      where gbuUSL_ManuAlternPartUsage.Company             = {firma/sartikel.fir S_Artikel.Firma}
        and gbuUSL_ManuAlternPartUsage.S_ArtAlternativ_Obj = gbuS_ArtAlternativ.S_ArtAlternativ_Obj
        and gbuUSL_ManuAlternPartUsage.Priority            < 100
      no-lock
    on error undo, throw:

    adm.method.cls.DMCMessageSvc:prpoInstance:showError
      ('uspma00025':U,
       S_Artikel.Artikel).

  end. /* FE_gbuS_ArtAlternativ */

if S_Artikel.uCE_NoOfPanels < 1 then
  adm.method.cls.DMCMessageSvc:prpoInstance:showError
    ('ustrc000001':U).

if (S_Artikel.Suchbegriff <> OLD_S_Artikel.Suchbegriff
  or S_Artikel.Selektion <> OLD_S_Artikel.Selektion) then
  branche.stamm.cls.USCBOMConnectorSvc:prpoInstance:createJobForSyncAttributes
    ( S_Artikel.S_Artikel_obj,
      '':U,
      'S_Artikel':U,
      '':U, 
      '':U, 
      '':U 
    ).

  if OLD_S_Artikel.WBZ = S_Artikel.WBZ
    and OLD_S_Artikel.WBZ_Lieferant = S_Artikel.WBZ_Lieferant
    and Old_S_Artikel.ArtikelGruppe <> S_Artikel.ArtikelGruppe then
    branche.stamm.cls.USCBOMConnectorSvc:prpoInstance:createJobForSyncAttributes
      ( S_Artikel.S_Artikel_Obj,
        '':U,
        'S_Artikel.ArtikelGruppe':U,
        '':U,
        '':U,
        '':U 
        ).

  if OLD_S_Artikel.WBZ = S_Artikel.WBZ
    and OLD_S_Artikel.WBZ_Lieferant = S_Artikel.WBZ_Lieferant
    and (OLD_S_Artikel.KalkPreis1 <> S_Artikel.KalkPreis1 
         or OLD_S_Artikel.KalkDatum1 <> S_Artikel.KalkDatum1) then 
    branche.stamm.cls.USCBOMConnectorSvc:prpoInstance:createJobForSyncAttributes
        ( S_Artikel.S_Artikel_Obj, 
          '':U,
          'S_Artikel.KalkPreis1':U,
          '':U,
          '':U,
          '':U 
        ). 

  if OLD_S_Artikel.WBZ = S_Artikel.WBZ
    and OLD_S_Artikel.WBZ_Lieferant = S_Artikel.WBZ_Lieferant
    and (OLD_S_Artikel.KalkPreis2 <> S_Artikel.KalkPreis2  
         or OLD_S_Artikel.KalkDatum2 <> S_Artikel.KalkDatum2) then 
    branche.stamm.cls.USCBOMConnectorSvc:prpoInstance:createJobForSyncAttributes
        ( S_Artikel.S_Artikel_Obj, 
          '':U,
          'S_Artikel.KalkPreis2':U,
          '':U,
          '':U,
          '':U
        ).

  if OLD_S_Artikel.WBZ = S_Artikel.WBZ
    and OLD_S_Artikel.WBZ_Lieferant = S_Artikel.WBZ_Lieferant
    and OLD_S_Artikel.Planpreis <> S_Artikel.Planpreis then 
    branche.stamm.cls.USCBOMConnectorSvc:prpoInstance:createJobForSyncAttributes
        ( S_Artikel.S_Artikel_Obj, 
          '':U,
          'S_Artikel.Planpreis':U,
          '':U,
          '':U,
          '':U 
        ).

  if OLD_S_Artikel.WBZ <> S_Artikel.WBZ 
    or OLD_S_Artikel.WBZ_Lieferant <> S_Artikel.WBZ_Lieferant then 
    branche.stamm.cls.USCBOMConnectorSvc:prpoInstance:createJobForSyncAttributes
      ( S_Artikel.S_Artikel_Obj,
        '':U,
        'Offers':U,
        '':U,
        '':U,
        '':U ).

&ENDIF /* U_CE */
/* <-- CE2017-03-001-03 MDe Erzeugen temporärer Strukturen: Austausch von Poolteilen */

/* Editing of Part by changing TA from 45 to any other TA                     */
/* Warenzusammenstellung value must become NO                                 */

if    old_S_Artikel.ArtikelArt       <> S_Artikel.ArtikelArt
  and old_S_Artikel.ArtikelArt        = {&pa_S_PT_Set}
  and S_Artikel.Warenzusammenstellung = yes then

  S_Artikel.Warenzusammenstellung = no.

if    Old_S_Artikel.OaPRelevant = S_Artikel.OaPRelevant
  and S_Artikel.OaPRelevant     = yes
  and (   Old_S_Artikel.ArtikelArt              <> S_Artikel.ArtikelArt
       or Old_S_Artikel.LagerME                 <> S_Artikel.LagerME
       or Old_S_Artikel.SBM_CustomsTariffNo_Obj <> S_Artikel.SBM_CustomsTariffNo_Obj
       or Old_S_Artikel.Gewicht                 <> S_Artikel.Gewicht
       or Old_S_Artikel.Warenzusammenstellung   <> S_Artikel.Warenzusammenstellung) then
do:

  /* In case of changes on S_Artikel, there has to be a new WuP transfer */
  basis.inwb.cls.BOCInwbSvc:prpoInstance:SetOaPMessageFlagToSend
    ('pAX-OaP-PARTS':U,
     S_Artikel.S_Artikel_Obj).

end. /* if S_Artikel.OaPRelevant = yes */

if   (    Old_S_Artikel.Kalkpreis1 <> S_Artikel.Kalkpreis1
      and S_Artikel.Kalkpreis1 < 0)
  or (   Old_S_Artikel.Kalkpreis2 <> S_Artikel.Kalkpreis2
      and S_Artikel.Kalkpreis2 < 0) then
      
  adm.method.cls.DMCMessageSvc:prpoInstance:showError('sbpar000004':U, S_Artikel.Artikel).

/* write the references in the Related OIDs Table                             */

{adm/template/incl/dt_trg15.if
  &ippParentTable = "Driver"
}

/* Fill ObjectID usage table */

{adm/template/incl/dt_trg15.if
  &ippParentTable = "SBM_CustomsTariffNo"
}

/* Create RelatedOID reference for BBM_WflWorkGroup */

{adm/template/incl/dt_trg22.if
  &ippWorkgroupField  = "VerteilerGruppe"
  &ippArea            = "'S_A':U"
  &ippCompany         = "{firma/sartikel.fir S_Artikel.Firma}"
}

/* Datensatz zur Übertragung an APS-Server kennzeichnen                       */

&IF LOOKUP("M_APS","{&PA-OPTIONEN}") > 0 &THEN

  {mawi/incl/m__aps00.if
    &Datenbereich = "{&pa_M_ApsDataArea_PartModified}"
    &Schluessel   = "S_Artikel.Artikel"
    &Neuanlage    = "S_Artikel.Anlagezeit = '':U"
  }

&ENDIF

/* set creation/update information                                            */

{adm/template/incl/dt_trg01.if}

/* Common post-processing                                                     */

{adm/template/incl/dt_trg20.if}

/* Cleanup with optional "finally"-Block                                      */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */



&IF DEFINED(EXCLUDE-CheckPartsPlanning) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CheckPartsPlanning Method-Library 
procedure CheckPartsPlanning :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Checks if there are still part planning records                            */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* <none>                                                                     */
/*                                                                            */
/*----------------------------------------------------------------------------*/

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

define variable cFirstCW    as   character no-undo.
define variable cFirstMonth as   character no-undo.

/* Buffers -------------------------------------------------------------------*/

&IF LOOKUP("PL","{&PA-MODULE}") > 0 &THEN
  define buffer bS_Artikel        for S_Artikel.
&ENDIF
&IF LOOKUP("VP","{&PA-MODULE}")  > 0 &THEN
  define buffer bVPM_User         for VPM_User.
&ENDIF
&IF LOOKUP("MM","{&PA-MODULE}")  > 0 &THEN
  define buffer bMMT_Distribution for MMT_Distribution.
&ENDIF

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Sales planning and master production scheduling                            */

&IF LOOKUP("PL","{&PA-MODULE}") > 0
  or LOOKUP("VP","{&PA-MODULE}") > 0  &THEN

  /* Ein archiviertes Teil darf nicht in der Planung genutzt werden           */
  /* und umgekehrt                                                            */

  /* 1. Archiviertes Teil darf nicht für Planung verwendet werden:            */

  if    S_Artikel.archiviert  = yes
    and old_S_Artikel.Planung = no
    and S_Artikel.Planung     = yes then

    adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
      ('pltrg00005':U,
       S_Artikel.Artikel).

  /* 2. Ein Teil, dass noch in der Planung verwendet wird, darf nicht
        archiviert werden:                                                    */

  if    S_Artikel.Planung        = yes
    and old_S_Artikel.archiviert = no
    and S_Artikel.archiviert     = yes then

    adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
      ('pltrg00006':U,
       S_Artikel.Artikel).

&ENDIF

/*----------------------------------------------------------------------------*/
/* Wechsel Teilegruppe oder Planung                                           */
/*----------------------------------------------------------------------------*/

if   (    old_S_Artikel.Planung       = yes
      and S_Artikel.Planung           = no)
  or (    old_S_Artikel.Detailplanung = yes
      and S_Artikel.Detailplanung     = no)
  or old_S_Artikel.Artikelgruppe <> S_Artikel.Artikelgruppe then
do:

  &IF LOOKUP("VP","{&PA-MODULE}")  > 0 &THEN

    /* Wenn Planungskennzeichen umgesetzt wird, dann Prüfung, ob noch         */
    /* Planzahlen der Zukunft vorhanden sind                                  */

    if can-find(first VP_Plan
                  where VP_Plan.Firma         = {firma/vpplan_.fir S_Firma.Firma}
                    and VP_Plan.Artikelgruppe = old_S_Artikel.Artikelgruppe    /* !! */
                    and VP_Plan.Artikel       = S_Artikel.Artikel
                    and VP_Plan.ArtVar        = '':U
                    and VP_PLan.Variante      = 0
                    and VP_Plan.Jahr         >= year(today)
                    and VP_Plan.Periode      >= (if VP_Plan.Jahr = year(today) then
                                                   month(today)
                                                 else
                                                   1)) then

      adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
        ('vptrg00001':U,
         S_Artikel.Artikel).

    /* delete Sales plan user                                                 */

    for each bVPM_User
      where bVPM_User.firma         = {firma/vpplan_.fir S_Firma.Firma}
        and bVPM_User.ArtikelGruppe = S_Artikel.Artikelgruppe
        and bVPM_User.Artikel       = S_Artikel.Artikel
      exclusive-lock
      on error  undo, throw:

      delete bVPM_User.

    end.

  &ENDIF  /* Modul VP  */

  &IF LOOKUP("PL","{&PA-MODULE}") > 0 &THEN

    /* actual Period, we have to proove Months and calendar weeks             */

    assign
      cFirstCW    = {fnarg
                        pa_cDateWeekOfDate
                        "today"}
      cFirstMonth = string(year(today),'9999':U) + string(month(today),'99':U)
      .

    /* there must not be a rough process or a planned BOM, in case of         */
      /* Artvar > 0 the process or the planned BOM is identified by           */
      /* Artikel + Artvar, do you have to prove if the rough process or       */
      /* the planned BOM belongs to this Part                                 */

      if can-find(first PL_Plan
                    where PL_PLan.Firma         = {firma/vpplan_.fir S_Firma.Firma}
                      and PL_Plan.ArtikelGruppe = old_S_Artikel.Artikelgruppe
                      and PL_PLan.Artikel       = S_Artikel.Artikel
                      and PL_Plan.ArtVar        = '':U
                      and PL_PLan.Variante      = 0
                      and PL_PLan.Periodenart   = no
                      and PL_PLan.Periode      >= cFirstCW)
        or can-find(first PL_Plan
                      where PL_PLan.Firma         = {firma/vpplan_.fir S_Firma.Firma}
                        and PL_Plan.ArtikelGruppe = old_S_Artikel.Artikelgruppe
                        and PL_PLan.Artikel       = S_Artikel.Artikel
                        and PL_Plan.ArtVar        = '':U
                        and PL_PLan.Variante      = 0
                        and PL_PLan.Periodenart   = yes
                        and PL_PLan.Periode      >= cFirstMonth)
        or (    S_Artikel.ArtVarTyp > 0
            and (   can-find (first PL_AplKopf
                                where PL_AplKopf.Firma     = {firma/vpplan_.fir S_Firma.Firma}
                                  and PL_AplKopf.Prozess   begins S_Artikel.Artikel
                                  and PL_AplKopf.Teileplan = yes
                                  and not can-find (first bS_Artikel
                                                      where bS_Artikel.Firma   = S_Artikel.Firma
                                                        and bS_Artikel.Artikel = PL_AplKopf.Prozess))
                 or can-find (first PL_StkKopf
                                where PL_StkKopf.Firma     = {firma/vpplan_.fir S_Firma.Firma}
                                  and PL_StkKopf.StkListe  begins S_Artikel.Artikel
                                  and PL_StkKopf.Teileplan = yes
                                  and not can-find (first bS_Artikel
                                                      where bS_Artikel.Firma   = S_Artikel.Firma
                                                        and bS_Artikel.Artikel = PL_StkKopf.StkListe))))
        or (    S_Artikel.ArtVarTyp = 0
            and (   can-find (first PL_AplKopf
                                where PL_AplKopf.Firma     = {firma/vpplan_.fir S_Firma.Firma}
                                  and PL_AplKopf.Prozess   = S_Artikel.Artikel
                                  and PL_AplKopf.Teileplan = yes)
                 or can-find (first PL_StkKopf
                                where PL_StkKopf.Firma     = {firma/vpplan_.fir S_Firma.Firma}
                                  and PL_StkKopf.StkListe  = S_Artikel.Artikel
                                  and PL_StkKopf.Teileplan = yes))) then

      adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
        ('pltrg00001':U,
         S_Artikel.Artikel).

  &ENDIF /* Modul PL  */

  /* Verteilung löschen                                                       */
  /* delete MMT_Distribution only if there is no planning at all or           */
  /* product line has changed                                                 */

  &IF LOOKUP("MM","{&PA-MODULE}")  > 0 &THEN

    if   S_Artikel.Planung = no
      or old_S_Artikel.Artikelgruppe <> S_Artikel.Artikelgruppe then

      for each bMMT_Distribution
        where  bMMT_Distribution.Firma         = {firma/mawi.fir S_Firma.Firma}
          and  bMMT_Distribution.Artikelgruppe = old_S_Artikel.Artikelgruppe
          and  bMMT_Distribution.Artikel       = S_Artikel.Artikel
        exclusive-lock
        on error  undo, throw:

        delete bMMT_Distribution.

      end. /* for each  */

  &ENDIF

end. /* if old_S_Artikel.Artikelgruppe  */

/* Prozentverteilung anlegen ------------------------------------------------ */

&IF LOOKUP("MM","{&PA-MODULE}")  > 0 &THEN

  if S_Artikel.Planung = true then
  do:

    if not can-find(MMT_Distribution
                      where MMT_Distribution.Firma         = {firma/mawi.fir S_Firma.Firma}
                        and MMT_Distribution.Artikelgruppe = S_Artikel.Artikelgruppe
                        and MMT_Distribution.Artikel       = S_Artikel.Artikel
                        and MMT_Distribution.Artvar        = '':U) then
    do:

      create bMMT_Distribution.

      assign
        bMMT_Distribution.Firma         = {firma/mawi.fir S_Firma.Firma}
        bMMT_Distribution.Artikelgruppe = S_Artikel.Artikelgruppe
        bMMT_Distribution.Artikel       = S_Artikel.Artikel
        bMMT_Distribution.Artvar        = '':U
        .

    end. /* If not can-find */

  end. /* If S_Artikel.Planung = true */

&ENDIF

end procedure. /* CheckPartsPlanning */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pruefung Procedure 
procedure Pruefung :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Validations                                                                */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* plarchiviert  i   Wird mit 'yes' belegt, wenn bei einem Teil das           */
/*                   Archivierungskennzeichen zurückgenommen wird             */
/*                                                                            */
/*----------------------------------------------------------------------------*/

define input parameter plarchiviert as logical no-undo.

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

define variable cPath        as character no-undo.
define variable cBasePath    as character no-undo.
define variable iLagergruppe as integer   no-undo.

/* Buffers -------------------------------------------------------------------*/

define buffer bM_Aktivitaet       for M_Aktivitaet.
define buffer bPMM_BomLine        for PMM_BomLine.
define buffer bPP_StkZeile        for PP_StkZeile.
define buffer bPP_Auftrag         for PP_Auftrag.
define buffer bSBM_MetalComponent for SBM_MetalComponent.

&IF LOOKUP("PS","{&PA-MODULE}") > 0 &THEN

  define buffer bS_Bauteiltyp       for S_Bauteiltyp.

&ENDIF

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

&IF LOOKUP("PS","{&PA-MODULE}") > 0 &THEN

  if      S_Artikel.Bauteiltyp    <> '':U
     and (   S_Artikel.Bauteiltyp <> Old_S_Artikel.Bauteiltyp
          or plarchiviert          = yes) then
  do:

    find bS_Bauteiltyp
      where bS_Bauteiltyp.Firma      = {firma/s_baute.fir S_Artikel.Firma}
        and bS_Bauteiltyp.Bauteiltyp = S_Artikel.Bauteiltyp
      no-lock no-error.

    /* Prüfe ob der neue Bauteiltyp vorhanden ist */

    if not available bS_Bauteiltyp then

      adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
        ('S_Artikel':U,
         'Bauteiltyp':U,
         'pstrg00003':U,
         S_Artikel.Bauteiltyp).
         
     branche.stamm.cls.USCPartManufacturerSvc:prpoInstance:checkComponentTypeConflicts
       (S_Artikel.S_Artikel_Obj,
        S_Artikel.Bauteiltyp).

  end. /* if S_Artikel.Bauteiltyp <> '':U */

&ENDIF

/* Die Teilenummer darf nicht blank sein und darf kein Komma enthalten */
/* This check must only be done if the part is still open because it   */
/* should be possible to archive a part with an identifier that is not */
/* valid.                                                              */

if S_Artikel.Archiviert = no then

  adm.method.cls.DMCTriggerSvc:prpoInstance:checkIdentifyingField
    (S_Artikel.Artikel,
     'S_Artikel':U,
     'Artikel':U,
     S_Artikel.S_Artikel_Obj).

/* ABC-Klasse   */

if not can-do (adm.config.cls.DCCAppConfigSvc:prpoInstance:cParameterValue
                 ('SA_ABCClass_keys':U,',':U),S_Artikel.ABC_Klasse) then

  adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
    ('S_Artikel':U,
     'ABC_Klasse':U,
     's_trg00115':U,
     S_Artikel.ABC_Klasse).

/* Artikelart  */

if    (   S_Artikel.Artikelart <> Old_S_Artikel.Artikelart
       or plarchiviert          = yes)
  and S_Artikel.Artikelart <> {&pa_S_PT_MakeToOrderPart}
  and not can-find(S_Artikelart
                     where S_ArtikelArt.Artikelart = S_Artikel.Artikelart) then

  adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
    ('S_Artikel':U,
     'Artikelart':U,
     's_trg00173':U,
     string(S_Artikel.Artikelart)).

/* Teileart im Zusammenhang mit DATANORM  */

if    Old_S_Artikel.ArtikelArt <> S_Artikel.ArtikelArt
  and not can-do({&pa_S_PTList_DATANORM},gcItemTypeNewPart)
  and can-find(first S_Austausch
                 where S_Austausch.Firma             = S_Artikel.Firma
                   and S_Austausch.Austauschstandard = 1
                   and S_Austausch.Tabellenname      = 'S_Artikel':U
                   and S_Austausch.Schluessel        = S_Artikel.Artikel) then

   adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
     ('S_Artikel':U,
      'ArtikelArt':U,
      's_dtn00026':U,
       S_Artikel.Artikel).

/* Teileart gegen Dispoart */

&IF LOOKUP("MD","{&PA-MODULE}") > 0  &THEN

  if    S_Artikel.ArtikelArt <> Old_S_Artikel.ArtikelArt
    and can-do({&pa_S_PTList_WithoutMRP},gcItemTypeNewPart)
    and can-find(first MD_Artikel
                   where MD_Artikel.Firma     = {firma/mlartort.fir S_Artikel.Firma}
                     and MD_Artikel.Artikel   = S_Artikel.Artikel
                     and MD_Artikel.DispoArt <> integer({&pa_S_DispoArt_None})) then

    adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
      ('S_Artikel':U,
       'ArtikelArt':U,
       'mdtrg00135':U,
       S_Artikel.Artikel,
       string(S_Artikel.ArtikelArt),
       adm.config.cls.DCCAppConfigSvc:prpoInstance:cParamValByRefParamVal
         ('SB_MRPCategories_desc':U,
          {&pa_S_DispoArt_None})).

&ENDIF

/* Teileart gegen Teilevariante */

if    S_Artikel.ArtVarTyp <> 0
  and (   can-do({&pa_S_PTList_VariantPartTypes},gcItemTypeNewPart)
       or can-do({&pa_S_PList_ValuePart} + ',':U  + '{&pa_S_PT_OutsourcedOperation}':U,string(S_Artikel.Artikelart))
       or S_Artikel.ArtikelArt = {&pa_S_PT_ServiceItem}) then

  adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
    ('S_Artikel':U,
     'ArtikelArt':U,
      's_trg00209':U,
      S_Artikel.Artikel,
      string(S_Artikel.Artikelart)).

/*  ArtVarTyp   */

if    (   S_Artikel.ArtVarTyp <> Old_S_Artikel.ArtVarTyp
       or plarchiviert         = yes)
  and S_Artikel.ArtVarTyp <> 0
  and not can-find(S_ArtVarTyp
                     where S_ArtVarTyp.ArtVarTyp = S_Artikel.ArtVarTyp) then

  adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
    ('S_Artikel':U,
     'ArtVarTyp':U,
     's_trg00174':U,
     string(S_Artikel.ArtVarTyp)).

/* Check if you can change the part variant of the part */

&IF LOOKUP("P_","{&PA-MODULE}") > 0 &THEN

  if    S_Artikel.ArtVarTyp <> Old_S_Artikel.ArtVarTyp
    and (   can-find(first PMM_BomHeadMaster
                       where PMM_BomHeadMaster.Company = {firma/pps.fir S_Artikel.Firma}
                         and PMM_BomHeadMaster.Part    = S_Artikel.Artikel)
          or can-find (first PMM_BomLine
                         where PMM_BomLine.Company  = {firma/pps.fir S_Artikel.Firma}
                           and PMM_BomLine.Part     = S_Artikel.Artikel)
          or can-find (first PMM_BomPart
                         where PMM_BomPart.Company  = {firma/pps.fir S_Artikel.Firma}
                           and PMM_BomPart.Part     = S_Artikel.Artikel)) then

    adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
      ('S_Artikel':U,
       'ArtVarTyp':U,
       'p_trg00208':U,
       S_Artikel.Artikel).

&ENDIF


&IF LOOKUP("PP","{&PA-MODULE}") > 0 &THEN

  if    S_Artikel.ArtVarTyp <> Old_S_Artikel.ArtVarTyp
    and (can-find(first PP_Auftrag
                    where PP_Auftrag.Firma   = {firma/ppauftra.fir S_Artikel.Firma}
                      and PP_Auftrag.Artikel = S_Artikel.Artikel)
         or can-find (first PP_StkZeile
                        where PP_StkZeile.Firma   = {firma/ppauftra.fir S_Artikel.Firma}
                          and PP_StkZeile.Artikel = S_Artikel.Artikel)
         or can-find (first PPT_OrderPart
                         where PPT_OrderPart.Company  = {firma/ppauftra.fir S_Artikel.Firma}
                           and PPT_OrderPart.Part     = S_Artikel.Artikel)) then

    adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
      ('S_Artikel':U,
       'ArtVarTyp':U,
       'pptrg00074':U,
       S_Artikel.Artikel).

&ENDIF
/*----------------------------------------------------------------------------*/
/* check BOM line occurence for service parts                                 */
/*----------------------------------------------------------------------------*/

&IF lookup("P_":U,"{&PA-MODULE}":U) > 0 &THEN

  if     S_Artikel.ArtikelArt  <> Old_S_Artikel.ArtikelArt
    and (   lookup(string(S_Artikel.ArtikelArt),{&pa_P_PTList_BOMLinePossible}) = 0
         or lookup (string(S_Artikel.ArtikelArt),{&pa_S_PTList_OnceOnlyPartTypes}) > 0)
    and can-find(first PMM_BomLine
                   where PMM_BomLine.Company   = {firma/pps.fir S_Artikel.Firma}
                     and PMM_BomLine.Part = S_Artikel.Artikel) then

    adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
      ('S_Artikel':U,
       'Artikelart':U,
       'p_trg00209':U,
       S_Artikel.Artikel,
       string(S_Artikel.ArtikelArt)).

&ENDIF

/* GewichtME  */

if    (   S_Artikel.GewichtME  <> Old_S_Artikel.GewichtME
       or plarchiviert          = yes)
  and not can-find(S_Mengeneinheit
                     where S_Mengeneinheit.Firma         = {firma/smngeinh.fir S_Artikel.Firma}
                       and S_Mengeneinheit.Mengeneinheit = S_Artikel.GewichtME) then

  adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
    ('S_Artikel':U,
     'GewichtME':U,
     's_trg00175':U,
     string(S_Artikel.GewichtME)).

/* LagerME  */

if    (   S_Artikel.LagerME <> Old_S_Artikel.LagerME
       or plarchiviert       = yes)
  and not can-find(S_Mengeneinheit
                     where S_Mengeneinheit.Firma         = {firma/smngeinh.fir S_Artikel.Firma}
                       and S_Mengeneinheit.Mengeneinheit = S_Artikel.LagerME) then

  adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
    ('S_Artikel':U,
     'LagerME':U,
     's_trg00176':U,
     string(S_Artikel.LagerME)).


  /* Falls LagerME geändert wird ->                         */
  /* Meldung zur Prüfung des Umrechnungsfaktors zur Ziel-ME */

  &IF LOOKUP("VS","{&PA-MODULE}") > 0 &THEN

    if     S_Artikel.LagerME <> Old_S_Artikel.LagerME
      and (   can-find(first bM_Aktivitaet
                         where bM_Aktivitaet.Firma   = {firma/mawi.fir S_Artikel.Firma}
                           and bM_Aktivitaet.AktArt  = {&pa_VS_ActivityTypeInternal}
                           and bM_Aktivitaet.Artikel = S_Artikel.Artikel)
           or can-find(first bM_Aktivitaet
                         where bM_Aktivitaet.Firma   = {firma/mawi.fir S_Artikel.Firma}
                           and bM_Aktivitaet.AktArt  = {&pa_VS_ActivityTypeExternal}
                           and bM_Aktivitaet.Artikel = S_Artikel.Artikel)) then

      adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
        ('s_trg04069':U,
         S_Artikel.Artikel).         

  &ENDIF

  /* Storage Unit of Measure must not be changed if a metal component exists */

  &IF LOOKUP("Q_DEL","{&PA-OPTIONEN}") > 0 &THEN

    if S_Artikel.LagerME <> Old_S_Artikel.LagerME then
      if can-find(first bSBM_MetalComponent
                  where bSBM_MetalComponent.Owning_Obj = S_Artikel.S_Artikel_Obj) then
        adm.method.cls.DMCMessageSvc:prpoInstance:showErrorInTrigger
          ('S_Artikel':U,
           'S_Artikel_Obj':U,
           's_trg04081':U).

  &ENDIF

/* Stücklistenmengeneinheit */

if    (   S_Artikel.StkME <> Old_S_Artikel.StkME
       or plarchiviert     = yes)
  and not can-find(S_Mengeneinheit
                     where S_Mengeneinheit.Firma = {firma/smngeinh.fir S_Artikel.Firma}
                       and S_Mengeneinheit.Mengeneinheit = S_Artikel.StkME) then

  adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
    ('S_Artikel':U,
     'StkME':U,
     's_trg00210':U,
     string(S_Artikel.StkME)).

/*  BME-Faktor  */

if S_Artikel.BME_Faktor <= 0 then

  adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
    ('S_Artikel':U,
     'BME_Faktor':U,
     's_trg00008':U,
     string(S_Artikel.BME_Faktor)).

/* Prüfung Werteflussgruppe */

if    (   S_Artikel.SBM_ValueFlowGroup_Obj <> Old_S_Artikel.SBM_ValueFlowGroup_Obj
       or plarchiviert                      = yes)
  and not can-find(SBM_ValueFlowGroup
                     where SBM_ValueFlowGroup.SBM_ValueFlowGroup_Obj = S_Artikel.SBM_ValueFlowGroup_Obj) 
  and S_Artikel.ArtikelArt <> {&pa_S_PT_PhantomAssembly} then

  do:

    if S_Artikel.SBM_ValueFlowGroup_Obj > '':U then

      adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
        ('S_Artikel':U,
         'SBM_ValueFlowGroup_Obj':U,
         's_vfg00044':U,
         S_Artikel.Artikel,
         S_Artikel.SBM_ValueFlowGroup_Obj).

    else

      adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
        ('S_Artikel':U,
         'SBM_ValueFlowGroup_Obj':U,
         'mlbuc00012':U,
         S_Artikel.Artikel).

  end. /* do */

/* Prüfung Preiseinheit, ProvGruppe und Rabattgruppe */

if    (   S_Artikel.Preiseinheit <> Old_S_Artikel.Preiseinheit
       or plarchiviert            = yes)
  and S_Artikel.Preiseinheit <> 0
  and not can-find(S_Preiseinheit
                     where S_Preiseinheit.Firma        = {firma/spreeinh.fir S_Artikel.Firma}
                       and S_Preiseinheit.Preiseinheit = S_Artikel.Preiseinheit) then

  adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
    ('S_Artikel':U,
     'Preiseinheit':U,
     's_trg00180':U,
     S_Artikel.Artikel,
     string(S_Artikel.Preiseinheit)).

if    (    S_Artikel.ProvGruppe  <> Old_S_Artikel.ProvGruppe
       or  plarchiviert           = yes)
  and S_Artikel.ProvGruppe > '':U
  and not can-find(S_ArtProvision
                     where S_ArtProvision.Firma      = {firma/sartprov.fir S_Artikel.Firma}
                       and S_ArtProvision.ProvGruppe = S_Artikel.ProvGruppe) then

  adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
    ('S_Artikel':U,
     'ProvGruppe':U,
     's_trg00181':U,
     S_Artikel.ProvGruppe).

if    (   S_Artikel.RabattGruppe  <> Old_S_Artikel.RabattGruppe
       or plarchiviert             = yes)
  and S_Artikel.RabattGruppe > '':U
  and not can-find(S_ArtRabatt
                     where S_ArtRabatt.Firma        = {firma/sartraba.fir S_Artikel.Firma}
                     and S_ArtRabatt.RabattGruppe = S_Artikel.RabattGruppe) then

  adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
    ('S_Artikel':U,
     'RabattGruppe':U,
     's_trg00182':U,
     S_Artikel.Rabattgruppe).

&IF LOOKUP("MS","{&PA-MODULE}") > 0  &THEN

  /* Seriennummernart   */

  if    S_Artikel.SNRArt > '':U
    and (   S_Artikel.SNRArt     <> Old_S_Artikel.SNRArt
         or S_Artikel.ArtikelArt <> Old_S_Artikel.ArtikelArt
         or plarchiviert          = yes)
    and not can-do({&pa_MS_PTList_SerialNumber},gcItemTypeNewPart) then

    adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
      ('S_Artikel':U,
       'SNRArt':U,
       'mssnr00103':U,
       S_Artikel.Artikel).

  if    (   S_Artikel.SNRArt <> Old_S_Artikel.SNRArt
         or plarchiviert      = yes)
    and S_Artikel.SNRArt   > '':U
    and not can-find(S_SNRArt
                       where S_SNRArt.Firma  = {firma/ssnrart.fir S_Artikel.Firma}
                         and S_SNRArt.SNRArt = S_Artikel.SNRArt) then

    adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
      ('S_Artikel':U,
       'SNRArt':U,
       'mssnr00001':U,
       S_Artikel.SNRArt).

  /* Seriennummerntyp  */

  if    (   S_Artikel.SNRTyp <> Old_S_Artikel.SNRTyp
         or plarchiviert      = yes)
    and S_Artikel.SNRTyp > '':U
    and not can-find(S_SNRTyp
                       where S_SNRTyp.Firma  = {firma/ssnrtyp.fir S_Artikel.Firma}
                         and S_SNRTyp.SNRTyp = S_Artikel.SNRTyp) then

    adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
      ('S_Artikel':U,
       'SNRTyp':U,
       'mssnr00027':U,
       S_Artikel.SNRTyp).

  /* Zuordnung Seriennummerntyp zu Seriennummernart */

  if    S_Artikel.SNRArt > '':U
    and (   Old_S_Artikel.SNRTyp <> S_Artikel.SNRTyp
         or Old_S_Artikel.SNRArt <> S_Artikel.SNRArt)
    and not can-find(S_SNRArtTyp
                       where S_SNRArtTyp.Firma = {firma/ssnratyp.fir S_Artikel.Firma}
                        and S_SNRArtTyp.SNRArt = S_Artikel.SNRArt
                        and S_SNRArtTyp.SNRTyp = S_Artikel.SNRTyp) then

    adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
      ('S_Artikel':U,
       'SNRTyp':U,
       'mssnr00030':U,
        S_Artikel.SNRTyp,
        S_Artikel.SNRArt).

  /* Prüfung Produktakte                                                      */

   &IF LOOKUP("MS_PROD","{&PA-OPTIONEN}") > 0 &THEN

     if    S_Artikel.Produktakte = yes
       and lookup(gcItemTypeNewPart,{&pa_MS_PTList_ProductFile}) = 0 then

       adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
         ('S_Artikel':U,
          'Produktakte':U,
          'mspro000028':U,
          S_Artikel.Artikel).

   &ENDIF

&ENDIF /* &IF LOOKUP("MS","{&PA-MODULE}") > 0 */

/* Produktmanager */

if    Old_S_Artikel.SB_Produktmanager <> S_Artikel.SB_Produktmanager
  and S_Artikel.SB_Produktmanager      > '':U
  and not {basis/user/incl/bu_trg01.if
             &Benutzer = "S_Artikel.SB_Produktmanager"} then

  adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
    ('S_Artikel':U,
     'SB_Produktmanager':U,
     's_trg00183':U,
     S_Artikel.SB_Produktmanager).

/* Chargenart   */

&IF LOOKUP("MC","{&PA-MODULE}") > 0  &THEN

  if    (   S_Artikel.Chargenart <> Old_S_Artikel.Chargenart
         or plarchiviert          = yes)
    and S_Artikel.Chargenart > '':U
    and not can-find(MC_Art
                       where MC_Art.Firma      =  {firma/mcart.fir S_Artikel.Firma}
                         and MC_Art.Chargenart = S_Artikel.Chargenart) then

    adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
      ('S_Artikel':U,
       'Chargenart':U,
       's_trg00190':U,
       S_Artikel.Chargenart).

  if    S_Artikel.Chargenart  > '':U
    and (   S_Artikel.Chargenart <> Old_S_Artikel.Chargenart
         or S_Artikel.ArtikelArt <> Old_S_Artikel.ArtikelArt)
    and not can-do({&pa_MC_PTList_Charge},gcItemTypeNewPart) then

    adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
      ('S_Artikel':U,
       'Chargenart':U,
       's_trg00237':U,
       S_Artikel.Artikel,
       string(S_Artikel.ArtikelArt)).

  &IF LOOKUP("PP","{&PA-MODULE}") > 0  &THEN

    /*-------------------------------------------------------------------------*/
    /* Zuordnung einer Chargenart nicht mehr zulassen, wenn bereits mindestens */
    /* eine Materialentnahme über einen Materialschein erfolgte.               */
    /* Wichtig: Keine Einschränkung auf den Auftragsstatus, da auch auf        */
    /* archivierte Produktionsaufträge Buchungen möglich sind, insbesondere    */
    /* Storno, Splitten,...                                                    */
    /*-------------------------------------------------------------------------*/

    if    S_Artikel.Chargenart     > '':U
      and Old_S_Artikel.Chargenart = '':U
      and can-find (first PP_StkZeile
                      where PP_StkZeile.Firma   = {firma/ppauftra.fir S_Artikel.Firma}
                        and PP_StkZeile.Artikel = S_Artikel.Artikel
                        and can-find (first MLL_Movements
                                        where MLL_Movements.Origin_Obj = PP_StkZeile.PP_StkZeile_Obj)) then

      adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
        ('S_Artikel':U,
         'Chargenart':U,
         's_trg00236':U,
         S_Artikel.Artikel).

  &ENDIF

&ENDIF /* &IF LOOKUP("MC","{&PA-MODULE}") > 0  &THEN */

/* Zolltarifnummer ( stat Warennummer ) */

if    (    S_Artikel.SBM_CustomsTariffNo_Obj <> Old_S_Artikel.SBM_CustomsTariffNo_Obj
        or plarchiviert                       =  yes)
  and S_Artikel.SBM_CustomsTariffNo_Obj > '':U
  and not can-find(SBM_CustomsTariffNo
                     where SBM_CustomsTariffNo.Company                 = {firma/sbmcusta.fir S_Artikel.Firma}
                       and SBM_CustomsTariffNo.SBM_CustomsTariffNo_Obj = S_Artikel.SBM_CustomsTariffNo_Obj) then

  adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
    ('S_Artikel':U,
     'Zolltarifnummer':U,
     's_trg00186':U,
      S_Artikel.Artikel).

/* Sparte  */

if (   S_Artikel.Sparte  <> Old_S_Artikel.Sparte
    or plarchiviert       = yes)
  and S_Artikel.ArtikelArt <> {&pa_S_PT_PhantomAssembly} then
do:

  if not can-find(S_Sparte
                    where S_Sparte.Firma  = {firma/ssparte.fir S_Artikel.Firma}
                      and S_Sparte.Sparte = S_Artikel.Sparte) then

    adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
      ('S_Artikel':U,
       'Sparte':U,
       's_trg00185':U,
       S_Artikel.Sparte).

  {adm/template/incl/dt_trg02.if
    &Spalte        = "Sparte"
    &Konfiguration = "{&PA_IA_SP_AUFTEILUNG}"
    &Spaltenname   = "'Sparte':T20"
  }

end. /* if    S_Artikel.Sparte  <> Old_S_Artikel.Sparte */

/* Teilegruppe  */

if (  S_Artikel.Artikelgruppe <> Old_S_Artikel.Artikelgruppe
    or plarchiviert             = yes)
  and S_Artikel.ArtikelArt <> {&pa_S_PT_PhantomAssembly} then
do:

  find S_ArtGruppe
    where S_ArtGruppe.Firma         = {firma/sartgrp.fir S_Artikel.Firma}
      and S_ArtGruppe.Artikelgruppe = S_Artikel.Artikelgruppe
    no-lock no-error.

  if not available S_ArtGruppe then

    adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
      ('S_Artikel':U,
       'Artikelgruppe':U,
       's_trg00220':U,
       S_Artikel.ArtikelGruppe).

  {adm/template/incl/dt_trg02.if
    &Spalte        = "ArtikelGruppe"
    &Konfiguration = "{&PA_IA_AG_AUFTEILUNG}"
    &Spaltenname   = "'Teilegruppe':T20"
  }

  iLagergruppe = S_ArtGruppe.Lagergruppe.

  &IF LOOKUP("MD","{&PA-MODULE}") > 0 &THEN

    find S_ArtGruppe
      where S_ArtGruppe.Firma         = {firma/sartgrp.fir S_Artikel.Firma}
        and S_ArtGruppe.Artikelgruppe = Old_S_Artikel.Artikelgruppe
      no-lock no-error.

    if    available S_ArtGruppe
      and S_ArtGruppe.Lagergruppe <> iLagergruppe
      and S_ArtGruppe.Planung      = yes
      and can-find(first MD_Artikel
                     where MD_Artikel.Firma       = {firma/mlartort.fir S_Artikel.Firma}
                       and MD_Artikel.Artikel     = S_Artikel.Artikel
                       and MD_Artikel.Lagergruppe = S_ArtGruppe.Lagergruppe
                       and MD_Artikel.Dispoart    = 5) then

      adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
        ('S_Artikel':U,
         'Artikelgruppe':U,
         'mdtrg00012':U,
         S_Artikel.Artikel,
         string(S_Artgruppe.Lagergruppe)).

  &ENDIF

end. /* if S_Artikel.ArtikelGruppe <> '':U */

/* Verteilergruppe  */

if    (   S_Artikel.VerteilerGruppe <> Old_S_Artikel.VerteilerGruppe
       or plarchiviert               = yes)
  and S_Artikel.VerteilerGruppe > '':U
  and not basis.buro.cls.BBCWorkflowSvc:prpoInstance:lIsValidWorkgroup
                                                      (S_Artikel.Firma,
                                                       'S_A':U,
                                                       S_Artikel.VerteilerGruppe) then

  adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
    ('S_Artikel':U,
     'VerteilerGruppe':U,
     'bbvtg00001':U,
     S_Artikel.VerteilerGruppe).

/* Prüfnummer für Absatzplanung  */

&IF LOOKUP("VP","{&PA-MODULE}") > 0  &THEN

  if    (    S_Artikel.PruefNr <> Old_S_Artikel.PruefNr
         or plarchiviert        = yes)
    and S_Artikel.PruefNr <> 0
    and not can-find(VP_Grenze
                       where VP_Grenze.Firma   = {firma/vpplan_.fir S_Artikel.Firma}
                         and VP_Grenze.PruefNr = S_Artikel.PruefNr) then

    adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
      ('S_Artikel':U,
       'PruefNr':U,
       's_trg03000':U,
       string(S_Artikel.PruefNr)).

&ENDIF

/* Wenn Planung, dann SME-Faktor <> ?   */

if    S_Artikel.Planung = yes
  and (   S_Artikel.SME_Faktor = ?
       or S_Artikel.SME_Faktor = 0) then

  adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
    ('S_Artikel':U,
     'SME_Faktor':U,
     's_trg03001':U,
     trim(string(S_Artikel.SME_Faktor,'zzz9.9999':U))).

/* Kommissionslager zwingend --> komm.gest. + bedarf.gest. Dispo zulässig */

&IF LOOKUP("MD","{&PA-MODULE}") > 0  &THEN

  if    S_Artikel.Anlagezeit    > '':U
    and S_Artikel.AenderungZeit > '':U then
  do:

    if    S_Artikel.KommLager = 2
      and can-find(first MD_Artikel
                     where MD_Artikel.Firma     =  {firma/mlartort.fir S_Artikel.Firma}
                       and MD_Artikel.Artikel   =  S_Artikel.Artikel
                       and lookup(string(MD_Artikel.DispoArt),{&p_MD_MRPCatList_CROMandatory}) = 0 ) then

      adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
        ('S_Artikel':U,
         'KommLager':U,
         's_trg00310':U,
         S_Artikel.Artikel).

    /* Vorfertigungsteil darf nicht kommissionsgesteuert sein */

    if    Old_S_Artikel.ArtikelArt <> S_Artikel.ArtikelArt
      and can-do({&pa_P_PTList_PreProduction},gcItemTypeNewPart)
      and can-find(first MD_Artikel
                     where MD_Artikel.Firma    = {firma/mlartort.fir S_Artikel.Firma}
                       and MD_Artikel.Artikel  = S_Artikel.Artikel
                       and MD_Artikel.DispoArt = 03) then

      adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
        ('S_Artikel':U,
         'ArtikelArt':U,
         'mdtrg00128':U,
         S_Artikel.Artikel).

  end. /* if S_Artikel.AnlageZeit > '':U */

&ENDIF

/*----------------------------------------------------------------------------*/
/* Prüfung Kosten-/Ergebnisträger                                             */
/*----------------------------------------------------------------------------*/

if    (   S_Artikel.Driver_Obj <> Old_S_Artikel.Driver_Obj
       or plarchiviert       =  yes)
  and S_Artikel.Driver_Obj   > '':U then

  stamm.base.cls.SBCMasterFilesAccountingSvc:prpoInstance:CheckDriverAssignable
   (S_Artikel.Driver_Obj,
    {&pa_S_Traeger},
    yes).

/* Prüfung Bewertungsgruppe                                                   */

&IF LOOKUP("EL","{&PA-MODULE}") > 0  &THEN

  if    (    Old_S_Artikel.Bewertungsgruppe <> S_Artikel.Bewertungsgruppe
         or  Old_S_Artikel.Artikelart       <> S_Artikel.Artikelart)
    and S_Artikel.Bewertungsgruppe > '':U
    and can-do({&pa_S_PTList_OnceOnlyPartTypes}, gcItemTypeNewPart) then

    adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
      ('S_Artikel':U,
       'Bewertungsgruppe':U,
       's_trg00645':U,
       S_Artikel.Artikel).

  if    (   Old_S_Artikel.Bewertungsgruppe <> S_Artikel.Bewertungsgruppe
         or plarchiviert                    =  yes)
    and S_Artikel.Bewertungsgruppe > '':U
    and not can-find(EL_BewertGruppe
                       where EL_BewertGruppe.Firma            = {firma/elbewer.fir S_Artikel.Firma}
                         and EL_BewertGruppe.Bewertungsgruppe = S_Artikel.Bewertungsgruppe) then

    adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
      ('S_Artikel':U,
       'Bewertungsgruppe':U,
       's_trg00677':U,
       S_Artikel.Bewertungsgruppe).

&ENDIF

/*----------------------------------------------------------------------------*/
/* Check Part-Supplier-Relationship                                           */
/*----------------------------------------------------------------------------*/

&IF lookup("E_","{&PA-MODULE}") > 0 &THEN

  if    Old_S_Artikel.Artikelart <> S_Artikel.Artikelart
    and can-do({&pa_S_PTList_VariantPartTypes} + ',':U + {&pa_S_PTList_Set}, string(S_Artikel.ArtikelArt))
    and can-find(first E_ArtLief
                   where E_ArtLief.Firma      = {firma/e_artli.fir S_Artikel.Firma}
                     and E_ArtLief.Artikel    = S_Artikel.Artikel
                     and E_ArtLief.archiviert = no) then

    adm.method.cls.DMCMessageSvc:prpoInstance:showError
      ('s_trg00513':U,
       S_Artikel.Artikel,
       string(S_Artikel.ArtikelArt)).

&ENDIF

/* Ursprungsland                                                              */

if    (   S_Artikel.Ursprungsland <> Old_S_Artikel.Ursprungsland
       or plarchiviert             =  yes)
  and S_Artikel.Ursprungsland <> '':U
  and not can-find(S_Staat
                     where S_Staat.Staat = S_Artikel.Ursprungsland) then

  adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
    ('S_Artikel':U,
     'Ursprungsland':U,
     's_trg00225':U,
     S_Artikel.Ursprungsland).

&IF   LOOKUP ('VF_INTRA':U,'{&PA-OPTIONEN}':U) > 0
   OR LOOKUP ('E_INTRA':U,'{&PA-OPTIONEN}':U)  > 0 &THEN

  if    Old_S_Artikel.Ursprungsland <> S_Artikel.Ursprungsland
     or Old_S_Artikel.Bundesland    <> S_Artikel.Bundesland  then
  do:

    /* check the validity of the region of origin for Intrastat declaration   */
    /*                                                                        */
    /* case 1: country of origin has no value                                 */
    /*         --> Intrastat region has to be the foreign country key         */
    /*                                                                        */
    /* case 2: country of origin is NOT EQUAL to country of company           */
    /*         --> Intrastat region has to be a region of the origin country  */
    /*         (if it has regions) OR it has to be the foreign country key    */
    /*                                                                        */
    /* case 3: country of origin is EQUAL to country of company               */
    /*         --> Intrastat region MUST NOT be the foreign country key and   */
    /*         it has to be a region of the origin country or it can be       */
    /*         UNDEFINED, if no regions exist or are currently unknown        */

    stamm.base.cls.SBCBusinessCategorySvc:prpoInstance:Regions
      (       S_Artikel.Ursprungsland,
              ?,
              (S_Artikel.Ursprungsland = gbS_Firma.Staat),
              (if      S_Artikel.Ursprungsland = '':U then
                 ?
               else if S_Artikel.Ursprungsland <> gbS_Firma.Staat then
                 yes
               else
                 no),
              today,   
       output gcListOfStateKeys,
       output gcListOfStateDesc). 

    if not can-do(gcListOfStateKeys,string(S_Artikel.Bundesland)) then    
      adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
        ('S_Artikel':U,
         'Ursprungsland':U,
         (if S_Artikel.Ursprungsland <> gbS_Firma.Staat then
            's_trg00272':U
          else
            's_trg00273':U),
          S_Artikel.Ursprungsland,
          S_Artikel.Artikel,
          gbS_Firma.Staat).

  end. /* if Old_S_Artikel.Ursprungsland <> S_Artikel.Ursprungsland  */

&ENDIF

/* Ursprungszeugnis ( Präferenz )                                             */

if    S_Artikel.Ursprungszeugnis            = true
  and (   S_Artikel.SBM_CustomsTariffNo_Obj = '':U
       or S_Artikel.Ursprungsland           = '':U) then

  adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
    ('S_Artikel':U,
     'Ursprungszeugnis':U,
     's_trg00195':U,
     S_Artikel.Artikel).

/*----------------------------------------------------------------------------*/
/* Prüfung: Verteilergruppe leer?                                             */
/*                                                                            */
/* Sonderfall: Im Teilestamm wird beim Ändern der Teilegruppe 2 Mal ge-       */
/* speichert. Dies führt dazu, dass die Meldung zu früh erscheint.            */
/*----------------------------------------------------------------------------*/

if    S_Artikel.Artikelart = Old_S_Artikel.Artikelart
  and not new(S_Artikel) then

  basis.buro.cls.BBCWorkflowSvc:prpoInstance:checkWorkgroup
    (S_Artikel.Firma,
     'S_A':U,
     S_Artikel.VerteilerGruppe,
     S_Artikel.Artikel).

/*----------------------------------------------------------------------------*/
/* Prüfung: Bild vorhanden?                                                   */
/*----------------------------------------------------------------------------*/

if    Old_S_Artikel.Bild <> S_Artikel.Bild
  and S_Artikel.Bild     <> '':U then
do:

  assign
    cBasePath = pACStartupSvc:cParameterValue('PicDir':U)
    cPath     = adm.method.cls.DMCOpSysSvc:cConcatPath(
                  cBasePath,
                  S_Artikel.Bild)
    cPath     = adm.method.cls.DMCOpSysSvc:cOpSysPathFromPath(cPath)
    cPath     = replace(cPath,{&PA-BACKSLASH},'/':U)
    .

  if search(cPath) = ? then
    adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
      ('S_Artikel':U,
       'Bild':U,
       's_trg01221':U,
       S_Artikel.Artikel,
       'PicDir,':U,
       cBasePath,
       S_Artikel.Bild).

end. /* if S_Artikel.Bild <> '':U */

/*----------------------------------------------------------------------------*/
/* Prüfung: Unzulässige Verwendugsart?                                        */
/*----------------------------------------------------------------------------*/

/* if the part has as usage category 'info', 'external on-hand part'  */
/* or 'phantom assembly' the part can't have serial numbers.          */

if     Old_S_Artikel.StkZeilenArt <> S_Artikel.StkZeilenArt
   and can-find (S_SNRArt
             where S_SNRArt.Firma  = {firma/ssnrart.fir S_Artikel.Firma}
               and S_SNRArt.SNRArt = S_Artikel.SNRArt)
   and (   can-do(S_Artikel.StkZeilenArt,{&pa_S_StkZeilenArt_FiktiveBaugruppe})
       or can-do(S_Artikel.StkZeilenArt,{&pa_S_StkZeilenArt_FremdBeistellteil})
        or can-do(S_Artikel.StkZeilenArt,{&pa_S_StkZeilenArt_zurInfo})) then
do:

  if can-do(S_Artikel.StkZeilenArt,{&pa_S_StkZeilenArt_FiktiveBaugruppe}) then

     adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
       ('p_trg00210':U,
        S_Artikel.Artikel,
        adm.config.cls.DCCAppConfigSvc:prpoInstance:cParamValByRefParamVal
          ('SB_BOMLineUsageCategory_desc':U,
           {&pa_S_StkZeilenArt_FiktiveBaugruppe})).

  else if can-do(S_Artikel.StkZeilenArt,{&pa_S_StkZeilenArt_FremdBeistellteil}) then

    adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
      ('p_trg00210':U,
       S_Artikel.Artikel,
       adm.config.cls.DCCAppConfigSvc:prpoInstance:cParamValByRefParamVal
         ('SB_BOMLineUsageCategory_desc':U,
          {&pa_S_StkZeilenArt_FremdBeistellteil})).

  else if can-do(S_Artikel.StkZeilenArt,{&pa_S_StkZeilenArt_zurInfo}) then

   adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
     ('p_trg00210':U,
      S_Artikel.Artikel,
      adm.config.cls.DCCAppConfigSvc:prpoInstance:cParamValByRefParamVal
        ('SB_BOMLineUsageCategory_desc':U,
         {&pa_S_StkZeilenArt_zurInfo})).

end. /* if Old_S_Artikel.StkZeilenArt <> S_Artikel.StkZeilenArt */


/* If the part type is changed, we also have to check the (production) BOM    */
/* lines if the part is somewhere used with non-valid usage category  w.r.t.  */
/* phantom assemblies                                                         */

if Old_S_Artikel.ArtikelArt <> S_Artikel.ArtikelArt
  and     can-do({&pa_P_PTList_LikePhantomAssembly}, string(Old_S_Artikel.ArtikelArt))
  and not can-do({&pa_P_PTList_LikePhantomAssembly}, string(S_Artikel.ArtikelArt)) then
do:

  /* Check in standard BOM lines (either SST or newest PAE if still valid) if */
  /* there is a usage category with phantom assembly.                         */

  for each bPMM_BomLine   /* Get all variants (optimization to match index)   */
    fields(bPMM_BomLine.Part bPMM_BomLine.PartVariant bPMM_BomLine.BomType)
    where     bPMM_BomLine.Company = {firma/pps.fir S_Artikel.Firma}
          and bPMM_BomLine.Part    = S_Artikel.Artikel
    no-lock
    break by bPMM_BomLine.PartVariant     /*  get each variant only once   */
    on error undo, throw:

    if not first-of(bPMM_BomLine.PartVariant) then
      next.  /* skip already processed values */

    if   can-find(first PMM_BomLine
                    where PMM_BomLine.Company         = {firma/pps.fir S_Artikel.Firma}
                      and PMM_BomLine.BomType         = bPMM_BomLine.BomType
                      and PMM_BomLine.Part            = S_Artikel.Artikel
                      and PMM_BomLine.PartVariant     = bPMM_BomLine.PartVariant
                      and PMM_BomLine.isCurrentIndex  = yes
                      and can-do(PMM_BomLine.BomLineUsageCategory ,{&pa_S_StkZeilenArt_FiktiveBaugruppe}))
      or can-find(first PMM_BomLine
                    where PMM_BomLine.Company        = {firma/pps.fir S_Artikel.Firma}
                      and PMM_BomLine.BomType        = bPMM_BomLine.BomType
                      and PMM_BomLine.Part           = S_Artikel.Artikel
                      and PMM_BomLine.PartVariant    = bPMM_BomLine.PartVariant
                      and PMM_BomLine.isCurrentIndex = no
                      and can-do(PMM_BomLine.BomLineUsageCategory ,{&pa_S_StkZeilenArt_FiktiveBaugruppe})
                      and not can-find(first PMM_BomHead
                                         where PMM_BomHead.PMM_BomHeadMaster_Obj = PMM_BomLine.Master_Obj
                                           and PMM_BomHead.BomType               = PMM_BomLine.BomType
                                           and PMM_BomHead.IndexNo               > PMM_BomLine.IndexNo
                                           and PMM_BomHead.Released              = yes)) then

      adm.method.cls.DMCMessageSvc:prpoInstance:showError('ppstk00021':U,
                                                          S_Artikel.Artikel,
                                                          string(S_Artikel.ArtikelArt)).
  end. /* for each bPMM_BomLine  */


  /* Check in production BOM lines                                           */

  for each bPP_StkZeile   /* Get all variants (optimization to match index)   */
    where     bPP_StkZeile.Firma              = {firma/ppauftra.fir S_Artikel.Firma}
          and bPP_StkZeile.Artikel            = S_Artikel.Artikel
    no-lock
    break by bPP_StkZeile.ArtVar    /*  get each variant only once   */
    on error undo, throw:

    if not first-of(bPP_StkZeile.ArtVar) then
      next. /* skip already processed values */

    if can-find(first PP_StkZeile
                  where PP_StkZeile.Firma          =  {firma/ppauftra.fir S_Artikel.Firma}
                    and PP_StkZeile.Artikel        =   S_Artikel.Artikel
                    and PP_StkZeile.ArtVar         =   bPP_StkZeile.ArtVar
                    and PP_StkZeile.Auftragsstatus <> 'R':U
                    and can-do(PP_StkZeile.StkZeilenart,{&pa_S_StkZeilenArt_FiktiveBaugruppe})) then

      adm.method.cls.DMCMessageSvc:prpoInstance:showError('ppstk00021':U,
                                                          S_Artikel.Artikel,
                                                          string(S_Artikel.ArtikelArt)).
  end.  /* for each bPP_StkZeile */

end. /* if Old_S_Artikel.ArtikelArt <> S_Artikel.ArtikelArt */

/* ----------------------------------------------------------------------- */
/* Prüfe Verwendung in Serviceaktivität                                    */
/* ----------------------------------------------------------------------- */

&IF LOOKUP("VS","{&PA-MODULE}") > 0 &THEN

  /* Teileart darf nicht geändert werden, falls Artikel in Serviceauftrag verwendet */

  if    S_Artikel.Artikelart <> Old_S_Artikel.Artikelart
    and (   can-find(first bM_Aktivitaet
                       where bM_Aktivitaet.Firma   = {firma/mawi.fir S_Artikel.Firma}
                         and bM_Aktivitaet.AktArt  = {&pa_VS_ActivityTypeInternal}
                         and bM_Aktivitaet.Artikel = S_Artikel.Artikel)
         or can-find(first bM_Aktivitaet
                       where bM_Aktivitaet.Firma   = {firma/mawi.fir S_Artikel.Firma}
                         and bM_Aktivitaet.AktArt  = {&pa_VS_ActivityTypeExternal}
                         and bM_Aktivitaet.Artikel = S_Artikel.Artikel)) then

    adm.method.cls.DMCMessageSvc:prpoInstance:showError('vsser00205':U,
                                                        S_Artikel.Artikel,
                                                        string(S_Artikel.ArtikelArt)).

&ENDIF


&IF LOOKUP("U_CE":U,"{&PA-OPTIONEN}":U) > 0 &THEN

  /* if PPA in status 'F' exists the number of Panels cannot be changed */

  &IF LOOKUP("PP","{&PA-MODULE}") > 0 &THEN

  if S_Artikel.uCE_NoOfPanels <> OLD_S_Artikel.uCE_NoOfPanels then 
  do:

    for each bPP_Auftrag
      where bPP_Auftrag.Firma          = {firma/ppauftra.fir S_Artikel.Firma}
        and bPP_Auftrag.AuftragsStatus = 'F':U
      no-lock
      on error undo, throw:

      if can-find(first PP_StkZeile
                    where PP_StkZeile.Firma        = {firma/ppauftra.fir bPP_Auftrag.Firma}
                      and PP_StkZeile.RueckMeldeNr = bPP_Auftrag.RueckMeldeNr
                      and PP_StkZeile.Artikel      = S_Artikel.Artikel) then

        adm.method.cls.DMCMessageSvc:prpoInstance:showError('uspma00034':U, 
                                                            S_Artikel.Artikel).

    end. /* for each bPP_Auftrag */

  end. /* if S_Artikel.uCE_NoOfPanels <> OLD_S_Artikel.uCE_NoOfPanels then do */

  &ENDIF

&ENDIF

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE write-Packmittel Procedure 
procedure write-Packmittel :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Sonderbehandlung eines Teils, für den Fall dass das Teil zukünftig als     */
/* Packmittel behandelt werden soll, aber umgekehrt.                          */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* <NONE>                                                                     */
/*                                                                            */
/*----------------------------------------------------------------------------*/

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

&IF    LOOKUP("M_","{&PA-MODULE}") > 0
   AND LOOKUP("M_PACK","{&PA-OPTIONEN}") > 0 &THEN

  /* die Lagermengeneinheit darf keine Nachkommastellen haben */

  if    can-do('{&pa_S_PT_ReusablePackage},{&pa_S_PT_ReusablePackagingAcc},{&pa_S_PT_ExpendablePackaging}':U,gcItemTypeNewPart)
    and (   not can-do('{&pa_S_PT_ReusablePackage},{&pa_S_PT_ReusablePackagingAcc},{&pa_S_PT_ExpendablePackaging}':U,gcItemTypeOldPart)
         or Old_S_Artikel.LagerME <> S_Artikel.LagerME)
    and ({fnarg
           pa_iDyCchUnitOfMeasureDecimals
           "S_Artikel.Firma,
            S_Artikel.LagerME"}) > 0 then

    adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
      ('S_Artikel':U,
       'LagerME':U,
       'mlpac00004':U,
       S_Artikel.Artikel).

  /* Eine Packmittel darf keine Vertriebsstückliste haben */
  /* Mehrweg-Packmittel dürfen nicht disporelevant sein   */
  /* Mehrwegpackmittel dürfen nicht wie normale Teile auf */
  /* Lager geführt werden                                 */

  if    can-do({&pa_M_PTList_Packaging},gcItemTypeNewPart)
    and not can-do({&pa_M_PTList_Packaging},gcItemTypeOldPart) then
  do:

    &IF LOOKUP("M_STUELI","{&PA-OPTIONEN}") > 0 &THEN

      for each M_Stueli
        where M_Stueli.Firma     = S_Artikel.Firma
          and M_Stueli.Baugruppe = S_Artikel.Artikel
        exclusive-lock
        on error undo, throw:

        delete M_Stueli.

      end.

    &ENDIF

    if can-do({&pa_M_PTList_PackagingReturnable},gcItemTypeNewPart) then
    do:

      &IF LOOKUP("ML","{&PA-MODULE}") > 0 &THEN

        for each S_Firma
          fields (Firma)
          where S_Firma.Firma begins S_Artikel.Firma
            and {firma/sartikel.fir S_Firma.Firma} = S_Artikel.Firma
            and can-find (first MLM_StorPartData
                            where MLM_StorPartData.Company = S_Firma.Firma
                              and MLM_StorPartData.Part    = S_Artikel.Artikel)
          no-lock
          on error undo, throw:

          adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
            ('mltrg00029':U,
             S_Artikel.Artikel).

        end. /* for each S_Firma */

      &ENDIF

      &IF LOOKUP("MD","{&PA-MODULE}") > 0 &THEN

        for each S_Firma
          fields (Firma)
          where S_Firma.Firma begins S_Artikel.Firma
            and {firma/sartikel.fir S_Firma.Firma} = S_Artikel.Firma
          no-lock,
          each MD_Artikel
          where MD_Artikel.Firma   = {firma/mlartort.fir S_Firma.Firma}
            and MD_Artikel.Artikel = S_Artikel.Artikel
          exclusive-lock
          on error undo, throw:

          assign
            MD_Artikel.DispoArt                       = integer({&pa_S_DispoArt_None})
            MD_Artikel.BestellMenge                   = 0
            MD_Artikel.Basislager                     = ?
            MD_Artikel.Basislager_Set                 = ?
            MD_Artikel.ProdLager_zu                   = ?
            MD_Artikel.ProdLager_ab                   = ?
            MD_Artikel.Bestellperiode                 = 0
            MD_Artikel.Historie                       = 0
            MD_Artikel.DispoGruppe                    = '':U
            MD_Artikel.MRP_Specialist_BU_Benutzer_Obj = '':U
            MD_Artikel.ProductionSP_BU_Benutzer_Obj   = '':U
            MD_Artikel.PurchaseSP_BU_Benutzer_Obj     = '':U
            .

        end. /* for each S_Firma */

      &ENDIF

    end. /* Mehrweg-Packmittel */

  end. /* Dispoparameter, kein Set und keine Lagerführung */

  /*--------------------------------------------------------------------------*/
  /* Prüfungen für Packmittel                                                 */
  /*--------------------------------------------------------------------------*/

  if can-do({&pa_M_PTList_Packaging},gcItemTypeNewPart) then
  do:

    /* Dem Packmittel darf keine Chargenart zugeordnet werden */

    if S_Artikel.Chargenart > '':U then
      adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
        ('S_Artikel':U,
         'ChargenArt':U,
         's_trg00239':U,
         S_Artikel.Artikel,
         string(S_Artikel.Artikelart)).

    /* Dem Packmittel darf keine Seriennummernart zugeordnet werden */

    if  S_Artikel.SNRArt > '':U then
      adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
        ('S_Artikel':U,
         'SNRArt':U,
         's_trg00241':U,
         S_Artikel.Artikel,
         string(S_Artikel.Artikelart)).

    /* Dem Packmittel darf keine Variantenart zugeordnet werden */

    if S_Artikel.ArtVarTyp <> 0 then
      adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
        ('S_Artikel':U,
         'ArtVarTyp':U,
         's_trg00242':U,
         S_Artikel.Artikel,
         string(S_Artikel.Artikelart)).

    /* Dem Packmittel darf kein WEBShop zugeordnet werden      */
    /* siehe auch Prüfung CC 'pa_WS_PTList_AvailablePartTypes' */

    if S_Artikel.WEBShop <> 0 then
      adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
        ('S_Artikel':U,
         'WEBShop':U,
         's_trg00243':U,
         S_Artikel.Artikel,
         string(S_Artikel.Artikelart)).

    /* Packmittel- und Zubehörteile dürfen nicht auf Kommissionslager geführt werden.  */

    if S_Artikel.KommLager <> 0 then

      adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
        ('S_Artikel':U,
         'KommLager':U,
         's_trg04033':U,
         S_Artikel.Artikel,
         (if S_Artikel.KommLager = 2 then
            'zwingend':T18
          else
            'möglich':T18)).

      /* Message: Beim Teil '&1' ist Kommissionslager '&2' eingestellt!
                  Packmittel- und Zubehörteile dürfen nicht auf
                  Kommissionslager geführt werden!                            */

      /* Die Teileart darf nicht einfach zw. Ein- und Mehrwegpackmittel geändert werden */

      if S_Artikel.ArtikelArt <> Old_S_Artikel.Artikelart
        and can-do({&pa_M_PTList_Packaging},string(S_Artikel.Artikelart))
        and can-do({&pa_M_PTList_Packaging},string(Old_S_Artikel.Artikelart)) then
      do:

        if    can-do({&pa_M_PTList_PackagingReturnable},string(Old_S_Artikel.Artikelart))
          and not can-do({&pa_M_PTList_PackagingReturnable},string(S_Artikel.Artikelart))
          and can-find(first M_PackOrt
            where M_PackOrt.Firma      = {firma/mlartort.fir S_Artikel.Firma}
              and M_PackOrt.Packmittel = S_Artikel.Artikel) then

          adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
                         ('m_pac00200':U,
                           S_Artikel.Artikel).

        if not can-do({&pa_M_PTList_PackagingReturnable},string(Old_S_Artikel.Artikelart))
          and can-find(first M_PackmittelKap
            where M_PackmittelKap.Firma      = {firma/mpackmi.fir S_Artikel.Firma}
              and M_PackmittelKap.Packmittel = S_Artikel.Artikel
              and M_PackmittelKap.Zubehoer   = yes
              and M_PackmittelKap.Mehrweg    = no) then

          adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
                         ('m_pac00201':U,
                           S_Artikel.Artikel).

        if        can-do({&pa_M_PTList_PackagingAccessories},string(Old_S_Artikel.Artikelart))
          and not can-do({&pa_M_PTList_PackagingAccessories},string(S_Artikel.Artikelart))
          &IF LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN
            and adm.config.cls.DCCAppConfigSvc:prpoInstance:lParameterValue
                  ('MM_PackagingAccessoriesUseAll':U) = no
          &ENDIF                    
          and can-find(first M_PackmittelKap
            where M_PackmittelKap.Firma    = {firma/mpackmi.fir S_Artikel.Firma}
              and M_PackmittelKap.Artikel  = S_Artikel.Artikel
              and M_PackmittelKap.Zubehoer = yes) then

          adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
                         ('m_pac00202':U,
                           S_Artikel.Artikel).

      end.

    /* Teil wird zum Packmittel */

    if not can-do({&pa_M_PTList_Packaging},gcItemTypeOldPart) then
    do:

      assign
        S_Artikel.Chargenart = '':U
        S_Artikel.SNRArt     = '':U
        S_Artikel.ArtVarTyp  = 0
        S_Artikel.WEBShop    = 0
        S_Artikel.Kommlager  = 0
        .

      if can-do({&pa_M_PTList_PackagingReturnable},gcItemTypeNewPart) then /* Mehrweg-Packmittel */

        assign
          S_Artikel.provisionsfaehig = no
          S_Artikel.rabattfaehig     = no
          S_Artikel.skontofaehig     = no
          .

      if not can-find(M_Packmittel
                        where M_Packmittel.Firma      = {firma/mpackmi.fir S_Artikel.Firma}
                          and M_Packmittel.Packmittel = S_Artikel.Artikel) then
      do:

        create M_Packmittel.
        assign
          M_Packmittel.Firma      = {firma/mpackmi.fir S_Artikel.Firma}
          M_Packmittel.Packmittel = S_Artikel.Artikel
          .
        validate M_Packmittel.

      end.
    end. /* if not can-do({&pa_M_PTList_Packaging},gcItemTypeOldPart) then */

  end. /* if can-do({&pa_M_PTList_Packaging},gcItemTypeNewPart) then */

  else

    if can-do({&pa_M_PTList_Packaging},gcItemTypeOldPart) then

      for each M_Packmittel
        where M_Packmittel.Firma      = {firma/mpackmi.fir S_Artikel.Firma}
          and M_Packmittel.Packmittel = S_Artikel.Artikel
        exclusive-lock
        on error undo, throw:

        delete M_Packmittel.

      end.

  /* Teil war einmal ein Packmittel Zubehör und wird ein Packmittel */

  if    can-do({&pa_M_PTList_Packaging},gcItemTypeNewPart)
    and can-do({&pa_M_PTList_PackagingAccessories},gcItemTypeOldPart)
    and not can-do({&pa_M_PTList_PackagingAccessories},gcItemTypeNewPart) then
  do:

    for each M_Packmittel
      where M_Packmittel.Firma      = {firma/mpackmi.fir S_Artikel.Firma}
        and M_Packmittel.Packmittel = S_Artikel.Artikel
      exclusive-lock
      on error undo, throw:

      M_Packmittel.Zubehoer = false.

    end.

    &IF LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN

      if adm.config.cls.DCCAppConfigSvc:prpoInstance:lParameterValue
           ('MM_PackagingAccessoriesUseAll':U) = no then

    &ENDIF      

    for each M_PackmittelKap
      where M_PackmittelKap.Firma   = {firma/mpackmi.fir S_Artikel.Firma}
        and M_PackmittelKap.Artikel = S_Artikel.Artikel
      exclusive-lock
      on error undo, throw:

      M_PackmittelKap.Zubehoer = false.

    end.

  end. /* if can-do({&pa_M_PTList_Packaging},gcItemTypeOldPart) */

  /* Teil war einmal ein Packmittel und wird ein Packmittel Zubehör */

  if    can-do({&pa_M_PTList_Packaging},gcItemTypeOldPart)
    and not can-do({&pa_M_PTList_PackagingAccessories},gcItemTypeOldPart)
    and can-do({&pa_M_PTList_PackagingAccessories},gcItemTypeNewPart) then
  do:

    if can-find(first M_PackmittelKap
                  where M_PackmittelKap.Firma      = {firma/mpackmi.fir S_Artikel.Firma}
                    and M_PackmittelKap.Packmittel = S_Artikel.Artikel) then

      adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
        ('s_trg00246':U,
         S_Artikel.Artikel,
         string(S_Artikel.Artikelart)).

    for each M_Packmittel
      where M_Packmittel.Firma      = {firma/mpackmi.fir S_Artikel.Firma}
        and M_Packmittel.Packmittel = S_Artikel.Artikel
      exclusive-lock
      on error undo, throw:

      M_Packmittel.Zubehoer = true.

    end.

    for each M_PackmittelKap
      where M_PackmittelKap.Firma   = {firma/mpackmi.fir S_Artikel.Firma}
        and M_PackmittelKap.Artikel = S_Artikel.Artikel
      exclusive-lock
      on error undo, throw:

      M_PackmittelKap.Zubehoer = true.

    end.

  end. /* Teil war einmal ein Packmittel und wird ein Packmittel Zubehör */

  /* Teil war einmal ein Einweg-Packmittel und wird ein Mehrweg-Packmittel    */

  if    can-do({&pa_M_PTList_Packaging},gcItemTypeOldPart)
    and not can-do({&pa_M_PTList_PackagingReturnable},gcItemTypeOldPart)
    and can-do({&pa_M_PTList_PackagingReturnable},gcItemTypeNewPart) then
  do:

    S_Artikel.Kommlager = 0.

    for each M_Packmittel
      where M_Packmittel.Firma      = {firma/mpackmi.fir S_Artikel.Firma}
        and M_Packmittel.Packmittel = S_Artikel.Artikel
      exclusive-lock
      on error undo, throw:

      M_Packmittel.Mehrweg = true.

    end.

  end.

  /* Teil war einmal ein Mehrweg-Packmittel und wird ein Einweg-Packmittel    */

  if    can-do({&pa_M_PTList_Packaging},gcItemTypeOldPart)
    and can-do({&pa_M_PTList_PackagingReturnable},gcItemTypeOldPart)
    and not can-do({&pa_M_PTList_PackagingReturnable},gcItemTypeNewPart) then

    for each M_Packmittel
      where M_Packmittel.Firma      = {firma/mpackmi.fir S_Artikel.Firma}
        and M_Packmittel.Packmittel = S_Artikel.Artikel
      exclusive-lock
      on error undo, throw:

      M_Packmittel.Mehrweg = false.

    end.

  /* eine Einweg-Packmittel darf nicht auf einem chaot. Lager geführt werden */

  /* --> MOu Einwegpackmittel : Zuweisung von chaotische Lagerorte */
  &IF LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  if not adm.config.cls.DCCAppConfigSvc:prpoInstance:lParameterValue
         ('UCA_RandomWarehouseForExpendablePack':U) then
  &ENDIF
  /* <-- MOu Einwegpackmittel : Zuweisung von chaotische Lagerorte */

  if Old_S_Artikel.ArtikelArt <> S_Artikel.ArtikelArt
    &IF LOOKUP("M_Pack-Plus","{&PA-OPTIONEN}") = 0 &THEN
    and (   S_Artikel.ArtikelArt = {&pa_S_PT_ExpendablePackaging}
         or S_Artikel.ArtikelArt = {&pa_S_PT_ExpendablePackagingAcc}) 
    &ENDIF     
    then
         
    for each S_Firma
      fields(Firma)
      where S_Firma.Firma begins S_Artikel.Firma
        and {firma/sartikel.fir S_Firma.Firma} = S_Artikel.Firma
      no-lock,
      each MLM_StorPartData
      fields(Storagearea)
        where MLM_StorPartData.Company = S_Firma.Firma
          and MLM_StorPartData.Part    = S_Artikel.Artikel
          and MLM_StorPartData.ArtVar  = '':U
        no-lock,
      first ML_Ort
        where ML_Ort.Firma    = {firma/mlort.fir S_Firma.Firma}
          and ML_Ort.Lagerort = MLM_StorPartData.Storagearea
        no-lock
      on error undo, throw:

      &IF LOOKUP("M_Pack-Plus","{&PA-OPTIONEN}") > 0 &THEN
      
        /* we have to start the trigger of MP_Artikel, */
        /* to process the involved packages            */
        
        find MP_Artikel
          where MP_Artikel.Firma   = S_Artikel.Firma
            and MP_Artikel.Artikel = S_Artikel.Artikel
          exclusive-lock no-error.
          
        if available MP_Artikel then
        do:        
          
          /* for Packaging Parts the Field 'EinlagSpanne' has to be 0, cause we     */
          /* always want the basic date as Stock-In Date                            */
          /* You should change it by create the new record, but S_Artikel has no    */
          /* Part Type, when  MP_Artikel.AnlageZeit = '':U                          */
          /* You can't change MP_Artikel for such a part at the surface, so you can */
          /* make it here                                                           */   
         
          if can-do({&pa_M_PTList_Packaging}, string(S_Artikel.Artikelart)) then
        
             MP_Artikel.EinlagSpanne = 0.
             
          /* replace EinlagSpanne if we change back from packaging*/
             
          if     MP_Artikel.EinlagSpanne = 0
             and not can-do({&pa_M_PTList_Packaging}, string(S_Artikel.Artikelart)) then
          do:
             
            find MP_Stamm
              where MP_Stamm.Firma = {firma/mpstamm.fir MP_Artikel.Firma}
              no-lock no-error.
            
            if available MP_Stamm then
              MP_Artikel.EinlagSpanne = MP_Stamm.EinlagSpanne.
         
          end.  /* if  MP_Artikel.EinlagSpanne = 0 */ 
                 
        end.  /* if available MP_Artikel then */
        
      &ELSE
        if can-find (first MP_Bereich
                       where MP_Bereich.Firma        = ML_Ort.Firma
                         and MP_Bereich.LagerOrt     = ML_Ort.LagerOrt
                         and MP_Bereich.LagerBereich = ML_Ort.LagerBereich) then
        
          adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
            ('mlpac00003':U,
             S_Artikel.Artikel).
      &ENDIF

    end. /* for each S_Firma ... */

&ENDIF /* M_, M_Pack */

return.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE write-SET Procedure 
procedure write-SET :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Sonderbehandlung eines Teils, für den Fall dass das Teil zukünftig als Set */
/* behandelt werden soll, aber umgekehrt.                                     */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* <none>                                                                     */
/*                                                                            */
/*----------------------------------------------------------------------------*/

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

&IF LOOKUP("M_","{&PA-MODULE}") > 0  &THEN
  &IF LOOKUP("M_STUELI","{&PA-OPTIONEN}") > 0 &THEN

    /* SET darf nicht chargenpflichtig sein */

    if can-do({&pa_S_PTList_Set}, gcItemTypeNewPart) then
    do:

      if S_Artikel.ChargenArt <> '':U then

        adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
          ('S_Artikel':U,
           'ArtikelArt':U,
           's_trg00157':U,
           S_Artikel.Artikel).

      if ({fnarg
            pa_iDyCchUnitOfMeasureDecimals
            "S_Artikel.Firma,
             S_Artikel.LagerME"}) > 0 then

        adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
          ('S_Artikel':U,
           'ArtikelArt':U,
           's_trg00158':U,
           S_Artikel.Artikel).

      if    S_Artikel.AnlageZeit    > '':U
        and S_Artikel.AenderungZeit > '':U then   /* nicht bei Kopiervorlage prüfen */

        for each S_ArtME
          where S_ArtME.Firma   = S_Artikel.Firma
            and S_ArtME.Artikel = S_Artikel.Artikel
          use-index Main
          no-lock
          on error undo, throw:

          if ({fnarg
                pa_iDyCchUnitOfMeasureDecimals
                "S_Artikel.Firma,
                 S_ArtME.Mengeneinheit"}) > 0 then
            adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
              ('S_Artikel':U,
               'ArtikelArt':U,
               's_trg00158':U,
               S_Artikel.Artikel).

        end.  /* for each S_ArtME */

      /* Dem Set darf keine Variantenart zugeordnet werden */

      if S_Artikel.ArtVarTyp <> 0 then
        adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
          ('S_Artikel':U,
           'ArtikelArt':U,
           's_trg00159':U,
           string(S_Artikel.ArtVarTyp)).

    end. /* if can-do({&pa_S_PTList_Set}, gcItemTypeNewPart) then */

    else

      /* Schalter fixSetPreis wieder zurücksetzen */
      if can-do({&pa_S_PTList_Set}, gcItemTypeOldPart) then
        S_Artikel.fixSetPreis = yes.

    /* Wenn die Teileart sich ändert, dann ggf. Set-Bestandteile löschen */

    if    can-do({&pa_S_PTList_Set}, gcItemTypeOldPart)
      and not can-do({&pa_S_PTList_Set}, gcItemTypeNewPart)
      and not can-do({&pa_S_PList_SalesBOM},gcItemTypeNewPart) then

      for each M_Stueli
        where M_Stueli.Firma     = S_Artikel.Firma
          and M_Stueli.Baugruppe = S_Artikel.Artikel
        exclusive-lock
        on error undo, throw:

        delete M_Stueli.

      end.

    /* Teil wird zum Set */

    if    can-do({&pa_S_PTList_Set}, gcItemTypeNewPart)
      and not can-do({&pa_S_PTList_Set}, gcItemTypeOldPart) then
    do:

      assign
        S_Artikel.Kommlager   = 0
        S_Artikel.fixSetPreis = yes
        S_Artikel.ArtVarTyp   = 0
        S_Artikel.Chargenart  = '':U
        .

      for each S_Firma
        fields(Firma)
        where S_Firma.Firma begins S_Artikel.Firma
          and {firma/sartikel.fir S_Firma.Firma} = S_Artikel.Firma
        no-lock
        on error undo, throw:

        /* es dürfen keine offenen Vertriebsbelege vorhanden sein   */

        &IF LOOKUP("V_","{&PA-MODULE}") > 0  &THEN

          for each S_BelegArt
            fields(Belegart)
            where S_BelegArt.Bereich begins 'V':U
            no-lock
            on error undo, throw:

            if    can-find(first V_BelegPos
                             where V_BelegPos.Firma    = {firma/vbelegko.fir S_Firma.Firma}
                               and V_BelegPos.BelegArt = S_BelegArt.BelegArt
                               and V_BelegPos.offen    = yes
                               and V_BelegPos.Artikel  = S_Artikel.Artikel)
               or can-find(first VU_RA_Artikel
                             where VU_RA_Artikel.Firma    = {firma/vbelegko.fir S_Firma.Firma}
                               and VU_RA_Artikel.Belegart = S_BelegArt.Belegart
                               and VU_RA_Artikel.offen    = yes
                               and VU_RA_Artikel.Artikel  = S_Artikel.Artikel) then
             adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
               ('v_trg00021':U,
                S_Artikel.Artikel).

          end.

          if can-find(first V_BelegStueli
                        where V_BelegStueli.Firma    = {firma/vbelegko.fir S_Firma.Firma}
                          and V_BelegStueli.Artikel  = S_Artikel.Artikel) then
            adm.method.cls.DMCMessageSvc:prpoInstance:showError
              ('v_trg00029':U,
               S_Artikel.Artikel).

        &ENDIF

        &IF LOOKUP("P_","{&PA-MODULE}") > 0  &THEN

          if   can-find(first PMM_BomLine
                          where PMM_BomLine.Company   = {firma/pps.fir S_Firma.Firma}
                            and PMM_BomLine.Part = S_Artikel.Artikel)
            &IF LOOKUP("PP","{&PA-MODULE}") > 0  &THEN
            or can-find(first PP_StkZeile
                          where PP_Stkzeile.Firma   = {firma/ppauftra.fir S_Firma.Firma}
                            and PP_Stkzeile.Artikel = S_Artikel.Artikel)
            &ENDIF
            then
            adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
              ('p_trg00153':U,
               S_Artikel.Artikel).

        &ENDIF

        &IF LOOKUP("E_","{&PA-MODULE}") > 0  &THEN

          if    can-find(first E_BelegPos
                           where E_BelegPos.Firma   = {firma/ebelkop.fir S_Firma.Firma}
                             and E_BelegPos.offen   = yes
                             and E_BelegPos.Artikel = S_Artikel.Artikel)
             or can-find(first E_BelegPos
                           where E_BelegPos.Firma   = {firma/ebelkop.fir S_Firma.Firma}
                             and E_BelegPos.offen   = no
                             and E_BelegPos.Artikel = S_Artikel.Artikel)
             or can-find(first E_RA_Pos
                           where E_RA_Pos.Firma     = {firma/ebelkop.fir S_Firma.Firma}
                             and E_RA_Pos.BelegArt  = 'ERA':U
                             and E_RA_Pos.offen     = yes
                             and E_RA_Pos.Artikel   = S_Artikel.Artikel)
             or can-find(first E_RA_Pos
                           where E_RA_Pos.Firma     = {firma/ebelkop.fir S_Firma.Firma}
                             and E_RA_Pos.BelegArt  = 'ERA':U
                             and E_RA_Pos.offen     = no
                             and E_RA_Pos.Artikel   = S_Artikel.Artikel) then
            adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
              ('e_trg00185':U,
               S_Artikel.Artikel).

          &IF LOOKUP ("EB_CallOrder","{&PA-OPTIONEN}") > 0 &THEN

            if    can-find (first EBT_CallOrder
                              where EBT_CallOrder.Firma     = {firma/ebelkop.fir S_Firma.Firma}
                                and EBT_CallOrder.offen     = yes
                                and EBT_CallOrder.Artikel   = S_Artikel.Artikel)
               or can-find (first EBT_CallOrder
                              where EBT_CallOrder.Firma   = {firma/ebelkop.fir S_Firma.Firma}
                                and EBT_CallOrder.offen   = no
                                and EBT_CallOrder.Artikel = S_Artikel.Artikel) then
              adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
                ('e_trg00185':U,
                 S_Artikel.Artikel).

          &ENDIF

          &IF LOOKUP("EB_DESADV","{&PA-OPTIONEN}") > 0 &THEN

            if    can-find (first EBT_DeliveryPos
                              where EBT_DeliveryPos.Firma   = {firma/ebelkop.fir S_Firma.Firma}
                                and EBT_DeliveryPos.offen   = yes
                                and EBT_DeliveryPos.Artikel = S_Artikel.Artikel)
               or can-find (first EBT_DeliveryPos
                              where EBT_DeliveryPos.Firma   = {firma/ebelkop.fir S_Firma.Firma}
                                and EBT_DeliveryPos.offen   = no
                                and EBT_DeliveryPos.Artikel = S_Artikel.Artikel) then

              adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
                ('e_trg00185':U,
                 S_Artikel.Artikel).

          &ENDIF

        &ENDIF

        /* Dispoparameter setzen */

        &IF LOOKUP("MD","{&PA-MODULE}") > 0 &THEN

          for each MD_Artikel
            where MD_Artikel.Firma   = {firma/mlartort.fir S_Firma.Firma}
              and MD_Artikel.Artikel = S_Artikel.Artikel
            exclusive-lock
            on error undo, throw:

            assign
              MD_Artikel.DispoArt                       = integer({&pa_S_DispoArt_None})
              MD_Artikel.BestellMenge                   = 0
              MD_Artikel.Basislager                     = ?
              MD_Artikel.Basislager_Set                 = ?
              MD_Artikel.ProdLager_zu                   = ?
              MD_Artikel.ProdLager_ab                   = ?
              MD_Artikel.Bestellperiode                 = 0
              MD_Artikel.Historie                       = 0
              MD_Artikel.Vorlaufzeit                    = 1
              MD_Artikel.Bereitstellzeit                = 0
              MD_Artikel.DispoGruppe                    = '':U
              MD_Artikel.MRP_Specialist_BU_Benutzer_Obj = '':U
              MD_Artikel.ProductionSP_BU_Benutzer_Obj   = '':U
              MD_Artikel.PurchaseSP_BU_Benutzer_Obj     = '':U
              .

          end.

        &ENDIF

      end. /* for each S_Firma */

    end. /* if can-do({&pa_S_PTList_Set}, gcItemTypeNewPart) */

    /* Teil war einmal ein Set */

    if    can-do({&pa_S_PTList_Set}, gcItemTypeOldPart)
      and not can-do({&pa_S_PTList_Set}, gcItemTypeNewPart) then
    do:

      for each S_Firma
        fields(Firma)
        where S_Firma.Firma begins S_Artikel.Firma
          and {firma/sartikel.fir S_Firma.Firma} = S_Artikel.Firma
        no-lock
        on error  undo, throw:

        /* es dürfen keine offenen Vertriebsbelege vorhanden sein */

        &IF LOOKUP("V_","{&PA-MODULE}") > 0  &THEN

          for each S_BelegArt
            fields(Belegart)
            where S_BelegArt.Bereich begins 'V':U
            no-lock
            on error  undo, throw:

            if can-find(first V_BelegPos
                          where V_BelegPos.Firma    = {firma/vbelegko.fir S_Firma.Firma}
                            and V_BelegPos.BelegArt = S_BelegArt.BelegArt
                            and V_BelegPos.offen    = yes
                            and V_BelegPos.Artikel  = S_Artikel.Artikel) then

              adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
                ('v_trg00021':U,
                 S_Artikel.Artikel).

          end.

        &ENDIF

        /* Konfigurationslager des Sets zurücksetzen */

        &IF LOOKUP("MD","{&PA-MODULE}") > 0 &THEN

          for each MD_Artikel
            where MD_Artikel.Firma   = {firma/mlartort.fir S_Firma.Firma}
              and MD_Artikel.Artikel = S_Artikel.Artikel
            exclusive-lock
            on error  undo, throw:

            MD_Artikel.Basislager_Set = ?.

          end.

        &ENDIF

      end. /* for each S_Firma */

    end. /* if can-do({&pa_S_PTList_Set}, gcItemTypeOldPart) */

  &ENDIF
&ENDIF

return.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Neuanlage Procedure 
procedure Neuanlage :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Neuanlage eines Teilestammsatzes                                           */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* <NONE>                                                                     */
/*                                                                            */
/*----------------------------------------------------------------------------*/

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

{&{&PA-XBasisName}_C_Neuanlage}
{&{&PA-XBasisName}_U_Neuanlage}
{&{&PA-XBasisName}_Q_Neuanlage}
{&{&PA-XBasisName}_Neuanlage}
{&{&PA-XBasisName}_Y_Neuanlage}

for each S_Firma
  fields(Firma)
  where S_Firma.Firma begins S_Artikel.Firma
    and {firma/sartikel.fir S_Firma.Firma} = S_Artikel.Firma
  no-lock
  on error undo, throw:

  /*--------------------------------------------------------------------------*/
  /* Verpackungsmengeneinheiten                                               */
  /*--------------------------------------------------------------------------*/

  find S_ArtME
    where S_ArtME.Firma         = {firma/sartikel.fir S_Firma.Firma}
      and S_ArtME.Artikel       = S_Artikel.Artikel
      and S_ArtME.MengenEinheit = S_Artikel.LagerME
    exclusive-lock no-error.

  if not available S_ArtME then
  do:

    create S_ArtME.
    assign
      S_ArtME.Firma         = {firma/sartikel.fir S_Firma.Firma}
      S_ArtME.Artikel       = S_Artikel.Artikel
      S_ArtME.MengenEinheit = S_Artikel.LagerME
      .
    validate S_ArtME.

  end.

  assign
    S_ArtME.Gewicht            = 0
    S_ArtME.VME_Faktor         = 1
    S_ArtME.GebindeNr          = 0
    S_ArtME.GebindeNrEindeutig = no
    .
  validate S_ArtME.

  /* assign "undefined" as initial value for statistical procedure fields     */

  assign
    S_Artikel.StatProcArrival  = {&pa_S_IntraStatProcArrival_Undefined}    /* key is 0   */
    S_Artikel.StatProcDispatch = {&pa_S_IntraStatProcDispatch_Undefined}   /* key is 0   */
    S_Artikel.Bundesland       = {&pa_S_IntraRegionOfOriginForeignCountry} /* key is 999 */
    .

  /*--------------------------------------------------------------------------*/
  /* Modul Mawi                                                               */
  /*--------------------------------------------------------------------------*/

  &IF LOOKUP("M_","{&PA-MODULE}") > 0  &THEN

    /*------------------------------------------------------------------------*/
    /* Bei Neuanlage eines Artikels auch einen MD_Artikel-Satz schreiben      */
    /*------------------------------------------------------------------------*/

    &IF LOOKUP("MD","{&PA-MODULE}") > 0 &THEN

      if not can-find(MD_Artikel
                        where MD_Artikel.Firma       = {firma/mlartort.fir S_Firma.Firma}
                          and MD_Artikel.Artikel     = S_Artikel.Artikel
                          and MD_Artikel.Lagergruppe = 0) then
      do:

        create MD_Artikel.
        assign
          MD_Artikel.Firma       = {firma/mlartort.fir S_Firma.Firma}
          MD_Artikel.Artikel     = S_Artikel.Artikel
          MD_Artikel.Lagergruppe = 0
          .
        validate MD_Artikel.

      end.  /* if not can-find MD_Artikel */

    &ENDIF  /* Modul MD */

    /*------------------------------------------------------------------------*/
    /* Für Lagerplatzverwaltung MP_Artikel anlegen                            */
    /*------------------------------------------------------------------------*/

    &IF LOOKUP("MP","{&PA-MODULE}") > 0 &THEN

      if not can-find(MP_Artikel
                        where MP_Artikel.Firma   = {firma/sartikel.fir S_Firma.Firma}
                          and MP_Artikel.Artikel = S_Artikel.Artikel) then
      do:

        create MP_Artikel.
        assign
          MP_Artikel.Firma   = {firma/sartikel.fir S_Firma.Firma}
          MP_Artikel.Artikel = S_Artikel.Artikel
          .
        validate MP_Artikel.

      end.

    &ENDIF   /* Modul MP  */

    &IF LOOKUP("M_PACK","{&PA-OPTIONEN}") > 0 &THEN

      if    can-do({&pa_M_PTList_Packaging},gcItemTypeNewPart)
        and not can-find(M_Packmittel
                           where M_Packmittel.Firma      = {firma/mpackmi.fir S_Firma.Firma}
                             and M_Packmittel.Packmittel = S_Artikel.Artikel) then
      do:

        assign
          S_Artikel.Chargenart = '':U
          S_Artikel.SNRArt     = '':U
          S_Artikel.ArtVarTyp  = 0
          S_Artikel.WEBShop    = 0
          S_Artikel.Kommlager  = 0
          .

        if can-do({&pa_M_PTList_PackagingReturnable},gcItemTypeNewPart) then /* Mehrweg-Packmittel */
          assign
            S_Artikel.provisionsfaehig = no
            S_Artikel.rabattfaehig     = no
            S_Artikel.skontofaehig     = no
            .

        create M_Packmittel.
        assign
          M_Packmittel.Firma      = {firma/mpackmi.fir S_Firma.Firma}
          M_Packmittel.Packmittel = S_Artikel.Artikel
          .
        validate M_Packmittel.

      end.

    &ENDIF  /* Option M_Pack */
  &ENDIF /* Modul MaWi */


  /*--------------------------------------------------------------------------*/
  /* income driver                                                            */
  /*--------------------------------------------------------------------------*/

  stamm.base.cls.SBCMasterFilesIncDriverAccSvc:prpoInstance:CreateIncDriver
    (S_Firma.Firma,
     'Part':U,
     S_Artikel.Artikel,
     S_Artikel.S_Artikel_Obj,
     S_Artikel.Suchbegriff,
     S_Artikel.Selektion,
     '':U).

  &IF LOOKUP("RM","{&PA-MODULE}") > 0 &THEN

    ertr.base.cls.RMCMasterFilesSvc:prpoInstance:SynchronizeIncDriverRollupStructure
      (S_Firma.Firma,
       'Part':U,
       S_Artikel.S_Artikel_Obj).

    /* In the case of pa_s_Traeger = 2, primary income driver group = part    */
    /* and activated synchronisation for this group, we put the object ID of  */
    /* the matching income driver into the field Driver_Obj of S_Artikel.     */
    /* This helps the user because he don't need to enter the ID manually.    */
    /* The following method checks all requirements and delivers the OID of   */
    /* the matching SBM_IncDriver.                                            */

      S_Artikel.Driver_Obj = stamm.base.cls.SBCMasterFilesIncDriverAccSvc:prpoInstance:cIncDriverObjOfPrimaryGroup
                               (S_Firma.Firma,
                                'Part':U,
                                S_Artikel.S_Artikel_Obj).

  &ENDIF

end.  /* for each S_Firma*/

&IF LOOKUP("MA","{&PA-MODULE}") > 0 &THEN

  /* add log record for outdated temp. structures                             */

  {mawi/incl/m__tmp02.if
    &ippForceLog        = "yes"
    &ippPart            = "S_Artikel.Artikel"
  }

&ENDIF

&IF LOOKUP("U_CE":U,"{&PA-OPTIONEN}":U) > 0 &THEN

  if (S_Artikel.uce_Source = 'proALPHA':U or S_Artikel.uce_Source begins "~'proALPH":U)
    and S_Artikel.Aenderungdatum = ? then
    branche.stamm.cls.USCBOMConnectorSvc:prpoInstance:createPartInBC
      ( S_Artikel.S_Artikel_Obj).

&ENDIF

return.

end procedure. /* Neuanlage */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aendern Procedure 
procedure Aendern :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Update of an existing record                                               */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* <none>                                                                     */
/*                                                                            */
/*----------------------------------------------------------------------------*/

/* Variables -----------------------------------------------------------------*/
/* cDocTypeList       List of document types to process                       */
/*----------------------------------------------------------------------------*/

define variable i            as integer   no-undo.
define variable cTemp        as character no-undo.
define variable cDocTypeList as character no-undo.
define variable dPhysicalOnHand as decimal extent {&pa_ML_PhysicalOnHandExtent} no-undo.

&IF lookup("PP","{&PA-MODULE}") &THEN
  define variable lCanResolve  as logical no-undo.
  define variable lOldCanResolve as logical no-undo.
&ENDIF

&IF LOOKUP("MA":U,"{&PA-MODULE}":U) > 0 &THEN
  define variable cTempProcessAreas as character no-undo.
&ENDIF

/* Buffers -------------------------------------------------------------------*/

&IF LOOKUP("M_STUELI","{&PA-OPTIONEN}") > 0 &THEN
  define buffer bS_Artikel_Set        for S_Artikel.
&ENDIF
&IF LOOKUP("E_","{&PA-MODULE}") > 0 &THEN
  define buffer bE_ArtLief            for E_ArtLief.
  define buffer bE_ArtLiefBei         for E_ArtLiefBei.
  define buffer bS_Mengeneinheit      for S_Mengeneinheit.
&ENDIF
&IF lookup("P_","{&PA-MODULE}") &THEN
  define buffer bPMM_BomHead          for PMM_BomHead.
  define buffer bPMM_BomLine          for PMM_BomLine.
  define buffer bPMM_Routing          for PMM_Routing.
  define buffer bPMM_Operation        for PMM_Operation.
&ENDIF
&IF lookup("PP","{&PA-MODULE}") &THEN
  define buffer bPP_StkZeile          for PP_StkZeile.
&ENDIF
&IF LOOKUP("MD","{&PA-MODULE}") > 0 &THEN
  define buffer bML_Lagergruppe      for ML_Lagergruppe.
&ENDIF
&IF lookup("M_PACK","{&PA-OPTIONEN}") > 0 &THEN
  define buffer bM_PackOrt            for M_PackOrt.
&ENDIF
define buffer bSBM_ValueFlowGroup-Old for SBM_ValueFlowGroup.
define buffer bSBM_ValueFlowGroup-New for SBM_ValueFlowGroup.
define buffer bS_ArtKundeDatum        for S_ArtKundeDatum.
define buffer bS_ArtKundeRabDatum     for S_ArtKundeRabDatum.
define buffer bS_ArtKundeStaffel      for S_ArtKundeStaffel.
define buffer bS_ArtKundeRabStaffel   for S_ArtKundeRabStaffel.
&IF "{&pa_S_F_EcoTax}":U = "1":U &THEN
  define buffer bSBT_F_EcoComponent   for SBT_F_EcoComponent.
&ENDIF


/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

{&{&PA-XBasisName}_C_Aendern}
{&{&PA-XBasisName}_U_Aendern}
{&{&PA-XBasisName}_Q_Aendern}
{&{&PA-XBasisName}_Aendern}
{&{&PA-XBasisName}_Y_Aendern}

/*----------------------------------------------------------------------------*/
/* Localization                                                               */
/*----------------------------------------------------------------------------*/

&IF "{&pa_S_F_EcoTax}":U = "1":U &THEN

  if    gcLocalization                    = 'F':U
    and OLD_S_Artikel.SBM_F_EcoCode_Obj  <> S_Artikel.SBM_F_EcoCode_Obj
    and S_Artikel.F_EcoTax                = yes
    and S_Artikel.SBM_F_EcoCode_Obj       > '':U then
    for each bSBT_F_EcoComponent
      where bSBT_F_EcoComponent.Owning_Obj = S_Artikel.S_Artikel_Obj
      exclusive-lock
      on error undo, throw:

      delete bSBT_F_EcoComponent.

    end.

&ENDIF

/*----------------------------------------------------------------------------*/
/* direkte Abhängigkeiten für die Führung eines Kommissionslagers             */
/*----------------------------------------------------------------------------*/

stamm.base.cls.SBCPartSvc:prpoInstance:SetConfigPrerequisites(S_Artikel.S_Artikel_Obj).

/*----------------------------------------------------------------------------*/
/* Firmenübergreifend                                                         */
/*----------------------------------------------------------------------------*/

for each S_Firma
  fields(Firma)
    where S_Firma.Firma begins S_Artikel.Firma
    and {firma/sartikel.fir S_Firma.Firma} = S_Artikel.Firma
  no-lock
  on error undo, throw:

  /* Planungskennzeichen (Absatzplanung/Programmplanung) setzen               */

  if S_Artikel.Planung = yes then
  do:

    find S_ArtGruppe
      where S_ArtGruppe.Firma         = {firma/sartgrp.fir S_Firma.Firma}
        and S_ArtGruppe.Artikelgruppe = S_Artikel.Artikelgruppe
      no-lock no-error.

     S_Artikel.Detailplanung = (if available S_ArtGruppe then
                                  S_ArtGruppe.Detailplanung
                                else
                                  no).

  end. /* if Planung = yes */
  else
    S_Artikel.Detailplanung = no.

  /*--------------------------------------------------------------------------*/
  /* Archivierung                                                             */
  /*--------------------------------------------------------------------------*/

  if    S_Artikel.archiviert
    and S_Artikel.archiviert <> OLD_S_Artikel.archiviert then
  do:

    /* Module Materials Management ------------------------------------------ */

    &IF LOOKUP("MM","{&PA-MODULE}") > 0 &THEN

     /* Offene Kommissioniervorschläge vorhanden? */

      if    can-find(first MMT_PickLine
                       where MMT_PickLine.S_Artikel_Obj = S_Artikel.S_Artikel_Obj
                         and can-find(first MMT_Picking
                                        where MMT_Picking.MMT_Picking_Obj = MMT_PickLine.MMT_Picking_Obj
                                          and MMT_Picking.offen           = yes
                                          and MMT_Picking.NoCopies        = 0
                                          and MMT_Picking.PickStatus      = integer({&pa_MM_PickStatus-New})))
         or can-find(first MMT_PickSetLine
                       where MMT_PickSetLine.S_Artikel_Obj = S_Artikel.S_Artikel_Obj
                         and can-find(first MMT_PickLine
                                        where MMT_PickLine.MMT_PickLine_Obj = MMT_PickSetLine.MMT_PickLine_Obj
                                          and can-find(first MMT_Picking
                                                         where MMT_Picking.MMT_Picking_Obj = MMT_PickLine.MMT_Picking_Obj
                                                           and MMT_Picking.offen           = yes
                                                           and MMT_Picking.NoCopies        = 0
                                                           and MMT_Picking.PickStatus      = integer({&pa_MM_PickStatus-New})))) then
        adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
          ('s_trg04018':U,
           S_Artikel.Artikel).

      /* Verteilung löschen */

      for each  MMT_Distribution
        where MMT_Distribution.Firma         = {firma/mawi.fir S_Firma.Firma}
          and MMT_Distribution.Artikelgruppe = S_Artikel.Artikelgruppe
          and MMT_Distribution.Artikel       = S_Artikel.Artikel
        exclusive-lock
        on error  undo, throw:

        delete MMT_Distribution.

      end. /* for each  */

    &ENDIF /* Modul MM */

    /* Module Project Management -------------------------------------------- */

    &IF LOOKUP("JB","{&PA-MODULE}") > 0 &THEN

      /* Das Teil kann nur auf archiviert umgesetzt werden, wenn keine        */
      /* Dispobewegungssätze aus Projektmanagement vorhanden sind.            */

      /* Artikelvarianten füllen */

      cTemp = {fnarg
                pa_cStCchPartVariantKeyList
                S_Artikel.ArtVarTyp}.

      do i = 2 to num-entries(cTemp):

        if can-find(first MMT_MRPAccount
                      where MMT_MRPAccount.Company    = S_Firma.Firma
                        and MMT_MRPAccount.Artikel    = S_Artikel.Artikel
                        and MMT_MRPAccount.ArtVar     = entry(i,cTemp)
                        and MMT_MRPAccount.MRPDocType = 'PM':U) then

          adm.method.cls.DMCMessageSvc:prpoInstance:showError
            ('s_trg03006':U,
             S_Artikel.Artikel).

      end. /* do i = 2 to num-entries(cTemp):*/

    &ENDIF  /* Projektmanagement */

    /* Module Production ---------------------------------------------------- */

    &IF LOOKUP("P_","{&PA-MODULE}") > 0 &THEN

      /* Before archiving a part in the master data the production masterdata */
      /* has to be checked that the Part is not used in the following areas:  */
      /* - current Bom where the BomHeads part is not also archived           */
      /* - latest released Bom where the BomHeads part is not also archived   */
      /* - as External operation part in a current routing that is not        */
      /*   archived                                                           */
      /* - as External operation part in a released routing that is not       */
      /*   archived                                                           */
      /* - as part assigned directly to an operation in the current routing   */
      /*   where the routing is not archived                                  */
      /* - as part assigned directly to an operation in the latest released   */
      /*   routing where the routing is not archived                          */
      /* In general the usage in a current element (Bom or Routing) or the    */
      /* latest released element prevents the archiving of the part in the    */
      /* part materdata record.                                               */

      /* Search the Part in a Bom Line where the Bom Line is in the current   */
      /* bom or routing                                                       */

      for each bPMM_BomLine /* Code checked by jhp 10.03.2004 */
        fields (Part PartVariant Owning_Obj)
        where bPMM_BomLine.Company      = {firma/pps.fir S_Firma.Firma}
          and bPMM_BomLine.BomType      = {&pa_PMM_BomType_production}
          and bPMM_BomLine.Part         = S_Artikel.Artikel
        &IF "{&PA_S_Varianten}" <> "1" &THEN
          and bPMM_BomLine.PartVariant     = '':U
        &ENDIF
          and bPMM_BomLine.isCurrentIndex = yes
        no-lock
        on error  undo, throw:

        /* Used in current Bom where the assembly Part is not archived      */
        /* -> deny archiving !                                              */

        find bPMM_BomHead
          where bPMM_BomHead.PMM_BomHead_Obj = bPMM_BomLine.Owning_Obj
          no-lock.

        if can-find(first S_Artikel
                      where S_Artikel.Firma      = {firma/sartikel.fir S_Firma.Firma}
                        and S_Artikel.Artikel    = bPMM_BomHead.Part
                        and S_Artikel.archiviert = no) then

          adm.method.cls.DMCMessageSvc:prpoInstance:showError('p_trg00090':U,
                                                              bPMM_BomLine.Part).

      end. /* if 'PMM_BomHead':U = ... */

      for each bPMM_BomLine /* Code checked by jhp 10.03.2004 */
        fields (Part PartVariant Owning_Obj)
        where bPMM_BomLine.Company      = {firma/pps.fir S_Firma.Firma}
          and bPMM_BomLine.BomType      = {&pa_PMM_BomType_OperationMat}
          and bPMM_BomLine.Part         = S_Artikel.Artikel
        &IF "{&PA_S_Varianten}" <> "1" &THEN
          and bPMM_BomLine.PartVariant     = '':U
        &ENDIF
          and bPMM_BomLine.isCurrentIndex = yes
        no-lock
        on error  undo, throw:

          /* Used as part assigned directly to an operation in the current    */
          /* routing and where the routing is not archived  -> deny archiving!*/

          find bPMM_Operation
            where bPMM_Operation.PMM_Operation_Obj = bPMM_BomLine.Owning_Obj
            no-lock.

          find bPMM_Routing
            where bPMM_Routing.PMM_Routing_Obj = bPMM_Operation.Owning_Obj
            no-lock.

          if can-find(PMM_RoutingMaster
                        where PMM_RoutingMaster.PMM_RoutingMaster_Obj = bPMM_Routing.PMM_RoutingMaster_Obj
                          and PMM_RoutingMaster.Archived              = no ) then

            adm.method.cls.DMCMessageSvc:prpoInstance:showError ('p_trg00087':U,
                                                                 bPMM_BomLine.Part).

      end. /* for each bPMM_BomLine */

      /* Search the Part in a Bom Line where the Bom Line is in a released    */
      /* bom or routing. Problem a match can be also in an older release      */

      for each bPMM_BomLine /* Code checked by jhp 10.03.2004 */
        fields (Part PartVariant Owning_Obj IndexNo)
        where bPMM_BomLine.Company      = {firma/pps.fir S_Firma.Firma}
          and bPMM_BomLine.BomType      = {&pa_PMM_BomType_production}
          and bPMM_BomLine.Part         = S_Artikel.Artikel
          &IF "{&PA_S_Varianten}" <> "1" &THEN
            and bPMM_BomLine.PartVariant     = '':U
          &ENDIF
          and bPMM_BomLine.isValidIndex = yes
        no-lock
        on error  undo, throw:


        /* Used in latest released Bom where the assemblies Part is not     */
        /* archived -> deny archiving !                                     */

        if not can-find (first PMM_Bomhead
                         where PMM_BomHead.PMM_BomHead_Obj = bPMM_BomLine.Owning_Obj
                            and PMM_BomHead.IndexNo         > bPMM_BomLine.IndexNo
                            and PMM_BomHead.Released        = yes) then
         do:

           find bPMM_BomHead
              where bPMM_BomHead.PMM_BomHead_Obj = bPMM_BomLine.Owning_Obj
              no-lock.

            if can-find(first S_Artikel
                          where S_Artikel.Firma      = {firma/sartikel.fir S_Firma.Firma}
                            and S_Artikel.Artikel    = bPMM_BomHead.Part
                            and S_Artikel.archiviert = no) then

              adm.method.cls.DMCMessageSvc:prpoInstance:showError('p_trg00089':U,
                                                                  bPMM_BomLine.Part,
                                                                  bPMM_BomHead.Part,
                                                                  bPMM_BomHead.IndexNo).
        end. /* if not can-find (first PMM_Bomhead ... */

      end. /* for each bPMM_BomLine  */

      for each bPMM_BomLine /* Code checked by jhp 10.03.2004 */
        fields (Part PartVariant Owning_Obj IndexNo)
        where bPMM_BomLine.Company      = {firma/pps.fir S_Firma.Firma}
          and bPMM_BomLine.BomType      = {&pa_PMM_BomType_OperationMat}
          and bPMM_BomLine.Part         = S_Artikel.Artikel
          &IF "{&PA_S_Varianten}" <> "1" &THEN
            and bPMM_BomLine.PartVariant     = '':U
          &ENDIF
          and bPMM_BomLine.isValidIndex = yes
        no-lock
        on error  undo, throw:


        /* used as part assigned directly to an operation in the latest         */
        /* released routing where the routing is not archived -> deny archiving!*/


        find bPMM_Operation
          where bPMM_Operation.PMM_Operation_Obj = bPMM_BomLine.Owning_Obj
          no-lock.

        if not can-find(first PMM_Routing
                          where PMM_Routing.PMM_Routing_Obj = bPMM_Operation.Owning_Obj
                            and PMM_Routing.IndexNo         > bPMM_Operation.IndexNo
                            and PMM_Routing.Released        = yes) then
        do:

          find bPMM_Routing
            where bPMM_Routing.PMM_Routing_Obj = bPMM_Operation.Owning_Obj
            no-lock.
          if can-find(PMM_RoutingMaster
                        where PMM_RoutingMaster.PMM_RoutingMaster_Obj = bPMM_Routing.PMM_RoutingMaster_Obj
                          and PMM_RoutingMaster.Archived              = no ) then

            adm.method.cls.DMCMessageSvc:prpoInstance:showError ('p_trg00086':U,
                                                                 bPMM_BomLine.Part).                                                                

        end. /* if not can-find(find PMM_Routing */

      end. /* for each bPMM_BomLine */

      /* if the Part is a Part that can be used for external operation then   */
      /* check for usage in routings.                                         */

      if S_Artikel.ArtikelArt = {&pa_S_PT_OutsourcedOperation} then
      do:

        for each bPMM_Operation
          where bPMM_Operation.Company           = {firma/pps.fir S_Firma.Firma}
            and bPMM_Operation.OperationCategory = {&pa_MM_ActivityTypeExternaloperation}
            and bPMM_Operation.PartExternalOrder = S_Artikel.Artikel
          no-lock
          on error undo, throw:

          if can-find(PMM_RoutingMaster
                        where PMM_RoutingMaster.PMM_RoutingMaster_Obj = bPMM_Operation.Master_Obj
                          and PMM_RoutingMaster.Archived              = no) then
          do:

            find bPMM_Routing
              where bPMM_Routing.PMM_Routing_Obj = bPMM_Operation.Owning_Obj
              no-lock.

            /* Used as external operation part in the current Routing where the */
            /* Routing is not archived     -> deny archiving !                  */

            if   bPMM_Routing.isCurrentIndex
              or bPMM_Routing.IsValidIndex then
              adm.method.cls.DMCMessageSvc:prpoInstance:showError ('pmrou00010':U,
                                                                   S_Artikel.Artikel,
                                                                   bPMM_Routing.PMM_Routing_ID,
                                                                   bPMM_Routing.IndexNo).

          end. /* if can-find(PMM_RoutingMaster ... */

        end. /*  for each bPMM_Operation */

      end. /* if S_Artikel.ArtikelArt = {&pa_S_PT_OutsourcedOperation} then   */

    &ENDIF

    /* Production Order */

    &IF LOOKUP("PP","{&PA-MODULE}") > 0 &THEN

      /* offener Produktionsauftrag  */

      if can-find(first PP_Auftrag
                    where PP_Auftrag.Firma    = {firma/ppauftra.fir S_Firma.Firma}
                      and PP_Auftrag.Archived = no
                      and PP_Auftrag.Artikel  = S_Artikel.Artikel)
        or can-find (first PPT_OrderPart
                       where PPT_OrderPart.Company =  {firma/ppauftra.fir S_Firma.Firma}
                         and PPT_OrderPart.Part    = S_Artikel.Artikel
                         and can-find (first PP_Auftrag
                                         where PP_Auftrag.PP_Auftrag_Obj = PPT_OrderPart.Owning_Obj
                                           and PP_Auftrag.Archived       = no))then
        adm.method.cls.DMCMessageSvc:prpoInstance:showError
          ('p_trg00039':U,
           S_Artikel.Artikel).

     /* Teileverwendung Produktionsauftrag   */

      if can-find(first PP_StkZeile
                    where PP_StkZeile.Firma          = {firma/ppauftra.fir S_Firma.Firma}
                      and PP_StkZeile.Artikel        = S_Artikel.Artikel
                      and PP_StkZeile.AuftragsStatus < 'R':U) then
        adm.method.cls.DMCMessageSvc:prpoInstance:showError
          ('p_trg00040':U,
          S_Artikel.Artikel).

     /* Fremdarbeit   */

      if can-find(first MB_Aktivitaet
                    where MB_Aktivitaet.Firma           = {firma/mawib.fir S_Firma.Firma}
                      and MB_Aktivitaet.Prozessbereich  = 'PPA':U  /* Produktionsauftrag */
                      and MB_Aktivitaet.AktArt          = {&pa_MM_ActivityTypeExternaloperation}
                      and MB_Aktivitaet.Artikel         = S_Artikel.Artikel
                      and MB_Aktivitaet.Auftragsstatus <> 'R':U) then
        adm.method.cls.DMCMessageSvc:prpoInstance:showError
          ('p_trg00092':U,
           S_Artikel.Artikel).

    &ENDIF  /* Modul PP */

    /* Module Purchasing ---------------------------------------------------- */

    &IF LOOKUP("E_","{&PA-MODULE}") > 0 &THEN

      /* die Belege EU_VorschlMahnPos, EA_AnfPreis werden nicht geprüft, */
      /* da die Prüfung von E_BelegPos, EA_AnfPos dann ausreicht         */

      /* Prüfung von offenen Bestell-/Abruf-/Rückl-/Belastungspositionen */

      cDocTypeList = 'EB,EAB,ERL,EBA':U.
      do i = 1 to num-entries (cDocTypeList):

        find first E_BelegPos
          where E_BelegPos.Firma    = {firma/ebelkop.fir S_Firma.Firma}
            and E_BelegPos.BelegArt = entry(i,cDocTypeList)
            and E_BelegPos.offen    = yes
            and E_BelegPos.Artikel  = S_Artikel.Artikel
          use-index ArtTermin
          no-lock no-error.

        if available E_BelegPos then
        do:

          find E_BelegKopf
            where E_BelegKopf.Firma      = E_BelegPos.Firma
              and E_BelegKopf.BelegArt   = E_BelegPos.BelegArt
              and E_BelegKopf.ReferenzNr = E_BelegPos.ReferenzNr
            no-lock.

          adm.method.cls.DMCMessageSvc:prpoInstance:showError
            ('e_trg00002':U,
             string(E_BelegKopf.BelegNummer)
             + ' / ':U
             + entry (i,cDocTypeList)).

        end.

      end. /* do i = 1 to ... */

      /* Wareneingänge */

      find first E_WE_Pos
        where E_WE_Pos.Firma     = {firma/ebelkop.fir S_Firma.Firma}
          and E_WE_Pos.Artikel   = S_Artikel.Artikel
          and E_WE_Pos.berechnet = no
        use-index Art
        no-lock no-error.

      if available E_WE_Pos then
      do:

        find E_WE_Kopf
          where E_WE_Kopf.Firma      = E_WE_Pos.Firma
            and E_WE_Kopf.ReferenzNr = E_WE_Pos.ReferenzNr
          no-lock.

        adm.method.cls.DMCMessageSvc:prpoInstance:showError
          ('e_trg00117':U,
           string(E_WE_Kopf.BelegNummer)).

      end.

      /* Rahmenaufträge */

      find first E_RA_Pos
        where E_RA_Pos.Firma    = {firma/ebelkop.fir S_Firma.Firma}
          and E_RA_Pos.BelegArt = 'ERA':U
          and E_RA_Pos.offen    = yes
          and E_RA_Pos.Artikel  = S_Artikel.Artikel
        use-index Artikel
        no-lock no-error.

      if available E_RA_Pos then
      do:

        find E_RA_Kopf
          where E_RA_Kopf.Firma      = E_RA_Pos.Firma
            and E_RA_Kopf.BelegArt   = E_RA_Pos.BelegArt
            and E_RA_Kopf.ReferenzNr = E_RA_Pos.ReferenzNr
          no-lock.

        adm.method.cls.DMCMessageSvc:prpoInstance:showError
          ('e_trg00116':U,
           string(E_RA_Kopf.BelegNummer)).

      end.

      &IF LOOKUP("ER","{&PA-MODULE}") > 0 &THEN

        /* Rechnungen */

        do i = 1 to num-entries ('ERR,ERZ':U):

          find first ER_BelegPos
            where ER_BelegPos.Firma    = {firma/ebelkop.fir S_Firma.Firma}
              and ER_BelegPos.Belegart = entry(i,'ERR,ERZ':U)
              and ER_BelegPos.verbucht = no
              and ER_BelegPos.Artikel  = S_Artikel.Artikel
            no-lock no-error.

          if available ER_BelegPos then
          do:

            find ER_BelegKopf
              where ER_BelegKopf.Firma      = ER_BelegPos.Firma
                and ER_BelegKopf.BelegArt   = ER_BelegPos.BelegArt
                and ER_BelegKopf.ReferenzNr = ER_BelegPos.ReferenzNr
              no-lock.

            adm.method.cls.DMCMessageSvc:prpoInstance:showError
              ('e_trg00119':U,
               string(ER_BelegKopf.BelegNummer)).

          end.

        end. /* do i = 1 to num-entries ('ERR,ERZ':U) */

      &ENDIF

      &IF LOOKUP("EA","{&PA-MODULE}") > 0 &THEN

        /* Anfragen */

        find first EA_AnfPos
          where EA_AnfPos.Firma   = {firma/ebelkop.fir S_Firma.Firma}
            and EA_AnfPos.offen   = yes
            and EA_AnfPos.Artikel = S_Artikel.Artikel
          use-index Artikel
          no-lock no-error.

        if available EA_AnfPos then
        do:

          find EA_AnfKopf
            where EA_AnfKopf.Firma      = EA_AnfPos.Firma
              and EA_AnfKopf.ReferenzNr = EA_AnfPos.ReferenzNr
            no-lock.

          adm.method.cls.DMCMessageSvc:prpoInstance:showError
            ('e_trg00118':U,
             string(EA_AnfKopf.BelegNummer)).

        end.

      &ENDIF /* Untermodule */

      /* Prüfung, ob das Teil als Beistellteil in einer nicht archivierten    */
      /* Teile-Lieferantenbeziehung bzw. einer offenen Bestell- oder Waren-   */
      /* eingangsposition verwendet wird.                                     */

      find first E_ArtLiefBei
        where E_ArtLiefBei.Firma           = {firma/e_artli.fir S_Firma.Firma}
          and E_ArtLiefBei.BeistellArtikel = S_Artikel.Artikel
          and can-find (E_ArtLief
                          where E_ArtLief.Firma      = {firma/e_artli.fir S_Firma.Firma}
                            and E_ArtLief.Artikel    = E_ArtLiefBei.Artikel
                            and E_ArtLief.Lieferant  = E_ArtLiefBei.Lieferant
                            and E_ArtLief.archiviert = no)
        no-lock no-error.

      if available E_ArtLiefBei then
        adm.method.cls.DMCMessageSvc:prpoInstance:showError
          ('e_trg00175':U,
           S_Artikel.Artikel,
           E_ArtLiefBei.Artikel,
           string(E_ArtLiefBei.Lieferant)).

      cDocTypeList = 'EB,EAB':U.

      do i = 1 to num-entries (cDocTypeList):

        find first E_BelegPosBei
          where E_BelegPosBei.Firma           = {firma/ebelkop.fir S_Firma.Firma}
            and E_BelegPosBei.BelegArt        = entry(i,cDocTypeList)
            and E_BelegPosBei.BeistellArtikel = S_Artikel.Artikel
            and can-find(E_BelegPos
                           where E_BelegPos.Firma       = E_BelegPosBei.Firma
                             and E_BelegPos.BelegArt    = E_BelegPosBei.BelegArt
                             and E_BelegPos.ReferenzNr  = E_BelegPosBei.ReferenzNr
                             and E_BelegPos.PositionsNr = E_BelegPosBei.PositionsNr
                             and E_BelegPos.offen       = yes)
          no-lock no-error.

        if available E_BelegPosBei then
        do:

          find E_BelegKopf
            where E_BelegKopf.Firma      = E_BelegPosBei.Firma
              and E_BelegKopf.BelegArt   = E_BelegPosBei.BelegArt
              and E_BelegKopf.ReferenzNr = E_BelegPosBei.ReferenzNr
            no-lock.

          adm.method.cls.DMCMessageSvc:prpoInstance:showError
            ('e_trg00176':U,
             S_Artikel.Artikel,
             string(E_BelegKopf.BelegNummer),
             string(E_BelegPosBei.PositionsNr),
             string(E_BelegPosBei.BeistellNr)).

        end. /* if available E_BelegPosBei */

      end. /* do i = 1 to num-entries (cDocTypeList) */

      find first E_WE_PosBei
        where E_WE_PosBei.Firma           = {firma/ebelkop.fir S_Firma.Firma}
          and E_WE_PosBei.BeistellArtikel = S_Artikel.Artikel
          and can-find(E_WE_Pos
                         where E_WE_Pos.Firma       = E_WE_PosBei.Firma
                           and E_WE_Pos.ReferenzNr  = E_WE_PosBei.ReferenzNr
                           and E_WE_Pos.PositionsNr = E_WE_PosBei.PositionsNr
                           and E_WE_Pos.berechnet   = no)
        no-lock no-error.

      if available E_WE_PosBei then
      do:

        find E_WE_Kopf
          where E_WE_Kopf.Firma      = E_WE_PosBei.Firma
            and E_WE_Kopf.ReferenzNr = E_WE_PosBei.ReferenzNr
          no-lock.

        adm.method.cls.DMCMessageSvc:prpoInstance:showError
          ('e_trg00177':U,
           S_Artikel.Artikel,
           string(E_WE_Kopf.BelegNummer),
           string(E_WE_PosBei.PositionsNr),
           string(E_WE_PosBei.BeistellNr)).

      end. /* if available E_WE_PosBei */

      &IF LOOKUP ("EB_CallOrder","{&PA-OPTIONEN}") > 0 &THEN

        /* Check if the current article is used in an open call order. In     */
        /* that case, it musntn't be possible to archive the article.         */

        if can-find(first EBT_CallOrder
                      where EBT_CallOrder.Firma   = {firma/ebelkop.fir S_Firma.Firma}
                        and EBT_CallOrder.offen   = yes
                        and EBT_CallOrder.Artikel = S_Artikel.Artikel) then

          adm.method.cls.DMCMessageSvc:prpoInstance:showError('s_trg04025':U,
                                                              S_Artikel.Artikel).

        /* Check if the current article is used in an open call order as      */
        /* provided part.                                                     */

        find first EBT_CO_ProvParts
          where EBT_CO_ProvParts.Firma           = {firma/ebelkop.fir S_Firma.Firma}
            and EBT_CO_ProvParts.BeistellArtikel = S_Artikel.Artikel
            and can-find(EBT_CallOrder
                           where EBT_CallOrder.EBT_CallOrder_Obj = EBT_CO_ProvParts.EBT_CallOrder_Obj
                             and EBT_CallOrder.offen             = yes)
          no-lock no-error.

        if available EBT_CO_ProvParts then
        do:

          find EBT_CallOrder
            where EBT_CallOrder.EBT_CallOrder_Obj = EBT_CO_ProvParts.EBT_CallOrder_Obj
            no-lock.

          adm.method.cls.DMCMessageSvc:prpoInstance:showError
            ('e_trg00178':U,
             S_Artikel.Artikel,
             string(EBT_CallOrder.BelegNummer),
             string(EBT_CO_ProvParts.BeistellNr)).

        end. /* if available EBT_CO_ProvParts */

      &ENDIF

      /* archiviere die Teile-Lieferantenbeziehungen */

      for each E_ArtLief
        where E_ArtLief.Firma          = {firma/e_artli.fir S_Firma.Firma}
          and E_ArtLief.Artikel        = S_Artikel.Artikel
          and E_ArtLief.archiviert     = no
          and E_ArtLief.Hauptlieferant = no
        exclusive-lock
        on error  undo, throw:

        E_ArtLief.archiviert = yes.

      end.

      /* jetzt den Hauptlieferanten */

      find first E_ArtLief
        where E_ArtLief.Firma          = {firma/e_artli.fir S_Firma.Firma}
          and E_ArtLief.Artikel        = S_Artikel.Artikel
          and E_ArtLief.archiviert     = no
          and E_ArtLief.Hauptlieferant = yes
        exclusive-lock no-error.

      if available E_ArtLief then
        E_ArtLief.archiviert = yes.

    &ENDIF  /* Module Purchasing */

    /* Module Sales --------------------------------------------------------- */

    &IF LOOKUP("V_","{&PA-MODULE}") > 0  &THEN

      /* Verwendung in Vertriebsbelegen                                       */

      cDocTypeList = 'A,U,L,R,G,VUA,VUR,VFP,VFA,VJI,VLA':U.

      do i = 1 to num-entries(cDocTypeList):

        if   can-find(first V_BelegPos
                        where V_BelegPos.Firma    = {firma/vbelegko.fir S_Firma.Firma}
                          and V_BelegPos.Belegart = entry(i,cDocTypeList)
                          and V_BelegPos.offen    = yes
                          and V_BelegPos.Artikel  = S_Artikel.Artikel
                          and V_BelegPos.Satzart  = 'A':U)
          or can-find(first VU_RA_Artikel
                        where VU_RA_Artikel.Firma    = {firma/vbelegko.fir S_Firma.Firma}
                          and VU_RA_Artikel.Belegart = entry(i,cDocTypeList)
                          and VU_RA_Artikel.offen    = yes
                          and VU_RA_Artikel.Artikel  = S_Artikel.Artikel) then

          adm.method.cls.DMCMessageSvc:prpoInstance:showError
            ('v_trg00040':U,
             S_Artikel.Artikel).

      end. /* do i = 1 to num-entries */

      &IF LOOKUP("MA","{&PA-MODULE}") > 0 &THEN

        find first MA_MatZeile
          where MA_MatZeile.Firma   = {firma/mawia.fir S_Firma.Firma}
            and MA_MatZeile.Artikel = S_Artikel.Artikel
          no-lock no-error.

        &IF LOOKUP("VS","{&PA-MODULE}") > 0 &THEN
        if     available MA_MatZeile
           and can-find(MA_Aktivitaet
                         where MA_Aktivitaet.Firma          = {firma/mawia.fir S_Firma.Firma}
                           and MA_Aktivitaet.IdentAkt       = MA_MatZeile.IdentAkt
                           and MA_Aktivitaet.ProzessBereich = 'VSS':U) then
          adm.method.cls.DMCMessageSvc:prpoInstance:showError
            ('vstrg00115':U,
             S_Artikel.Artikel).

       &ENDIF

       &IF LOOKUP("P_","{&PA-MODULE}") > 0 &THEN
        if     available MA_MatZeile
           and can-find(MA_Aktivitaet
                         where MA_Aktivitaet.Firma          = {firma/mawia.fir S_Firma.Firma}
                           and MA_Aktivitaet.IdentAkt       = MA_MatZeile.IdentAkt
                           and MA_Aktivitaet.ProzessBereich = 'PPA':U) then
          adm.method.cls.DMCMessageSvc:prpoInstance:showError
            ('p_trg00106':U,
             S_Artikel.Artikel).

        &ENDIF /* P_ */

      &ENDIF /* MA */

      /* Verwendung im Serviceauftrag */

      &IF LOOKUP("VS","{&PA-MODULE}") > 0 &THEN

        if    can-find(first VS_AuftragPos
                         where VS_AuftragPos.Firma    = {firma/vbelegko.fir S_Firma.Firma}
                           and VS_AuftragPos.Belegart = 'VSA':U
                           and VS_AuftragPos.offen    = yes
                           and VS_AuftragPos.Artikel  = S_Artikel.Artikel)
           or can-find(first VS_AuftragPos
                         where VS_AuftragPos.Firma       = {firma/vbelegko.fir S_Firma.Firma}
                           and VS_AuftragPos.Belegart    = 'VSA':U
                           and VS_AuftragPos.offen       = yes
                           and VS_AuftragPos.Mat_Artikel = S_Artikel.Artikel)
           or can-find(first VS_AuftragPos
                         where VS_AuftragPos.Firma       = {firma/vbelegko.fir S_Firma.Firma}
                           and VS_AuftragPos.Belegart    = 'VSA':U
                           and VS_AuftragPos.offen       = yes
                           and VS_AuftragPos.Kost_Artikel = S_Artikel.Artikel)
           or can-find(first VS_AuftragMKT
                         where VS_AuftragMKT.Firma    = {firma/vbelegko.fir S_Firma.Firma}
                           and VS_AuftragMKT.Belegart = 'VSA':U
                           and VS_AuftragMKT.Satzart  = 'A':U
                           and VS_AuftragMKT.offen    = yes
                           and VS_AuftragMKT.Artikel  = S_Artikel.Artikel)
           or can-find(first VS_AuftragMKT
                         where VS_AuftragMKT.Firma    = {firma/vbelegko.fir S_Firma.Firma}
                           and VS_AuftragMKT.Belegart = 'VSA':U
                           and VS_AuftragMKT.Satzart  = 'M':U
                           and VS_AuftragMKT.offen    = yes
                           and VS_AuftragMKT.Artikel  = S_Artikel.Artikel) then

          adm.method.cls.DMCMessageSvc:prpoInstance:showError
            ('v_trg00040':U,
             S_Artikel.Artikel).

        &IF LOOKUP("MA","{&PA-MODULE}") > 0 &THEN

          if   can-find(first MA_Aktivitaet
                          where MA_Aktivitaet.Firma   = {firma/mawia.fir S_Firma.Firma}
                            and MA_Aktivitaet.AktArt  = {&pa_MM_ActivityTypeService}
                            and MA_Aktivitaet.Artikel = S_Artikel.Artikel)
            or can-find(first MA_Aktivitaet
                          where MA_Aktivitaet.Firma   = {firma/mawia.fir S_Firma.Firma}
                            and MA_Aktivitaet.AktArt  = {&pa_MM_ActivityTypeExternalservice}
                            and MA_Aktivitaet.Artikel = S_Artikel.Artikel)
            or can-find(first M_Aktivitaet
                          where M_Aktivitaet.Firma   = {firma/mawi.fir S_Firma.Firma}
                            and M_Aktivitaet.AktArt  = {&pa_MM_ActivityTypeService}
                            and M_Aktivitaet.Artikel = S_Artikel.Artikel)
            or can-find(first M_Aktivitaet
                          where M_Aktivitaet.Firma   = {firma/mawi.fir S_Firma.Firma}
                            and M_Aktivitaet.AktArt  = {&pa_MM_ActivityTypeExternalservice}
                            and M_Aktivitaet.Artikel = S_Artikel.Artikel) then

            adm.method.cls.DMCMessageSvc:prpoInstance:showError
              ('vsser00052':U,
               S_Artikel.Artikel).

        &ENDIF /* Module VS */
      &ENDIF /* Module MA */
    &ENDIF /* Module Sales */

    /* Update dependant structures ------------------------------------------ */

    /* Das gültig_bis-Datum in den Teile-Kundenbeziehungen ändern */

    for each S_ArtKunde
      fields (Kunde)
      where S_ArtKunde.Firma   = {firma/sartkund.fir S_Firma.Firma}
        and S_ArtKunde.Artikel = S_Artikel.Artikel
      no-lock
      on error undo, throw:

      for each S_ArtKundeDatum
        where S_ArtKundeDatum.Firma           = {firma/sartkund.fir S_Firma.Firma}
          and S_ArtKundeDatum.Artikel         = S_Artikel.Artikel
          and S_ArtKundeDatum.Kunde           = S_ArtKunde.Kunde
          and S_ArtKundeDatum.gueltig_ab     <= today
          and (  S_ArtKundeDatum.gueltig_bis  > today
               or S_ArtKundeDatum.gueltig_bis = ?)
        exclusive-lock
        on error undo, throw:

        if not can-find(bS_ArtKundeDatum
                          where bS_ArtKundeDatum.Firma       = S_ArtKundeDatum.Firma
                            and bS_ArtKundeDatum.Artikel     = S_ArtKundeDatum.Artikel
                            and bS_ArtKundeDatum.Kunde       = S_ArtKundeDatum.Kunde
                            and bS_ArtKundeDatum.gueltig_ab  = S_ArtKundeDatum.gueltig_ab
                            and bS_ArtKundeDatum.gueltig_bis = today) then

          S_ArtKundeDatum.gueltig_bis = today.

      end.

      for each S_ArtKundeDatum
        where S_ArtKundeDatum.Firma      = {firma/sartkund.fir S_Firma.Firma}
          and S_ArtKundeDatum.Artikel    = S_Artikel.Artikel
          and S_ArtKundeDatum.Kunde      = S_ArtKunde.Kunde
          and S_ArtKundeDatum.gueltig_ab > today
        exclusive-lock
        on error undo, throw:

        if not can-find(bS_ArtKundeDatum
                          where bS_ArtKundeDatum.Firma       = S_ArtKundeDatum.Firma
                            and bS_ArtKundeDatum.Artikel     = S_ArtKundeDatum.Artikel
                            and bS_ArtKundeDatum.Kunde       = S_ArtKundeDatum.Kunde
                            and bS_ArtKundeDatum.gueltig_ab  = S_ArtKundeDatum.gueltig_ab
                            and bS_ArtKundeDatum.gueltig_bis = S_ArtKundeDatum.gueltig_ab) then

          S_ArtKundeDatum.gueltig_bis = S_ArtKundeDatum.gueltig_ab.

      end.

      for each S_ArtKundeRabDatum
        where S_ArtKundeRabDatum.Firma           = {firma/sartkund.fir S_Firma.Firma}
          and S_ArtKundeRabDatum.Artikel         = S_Artikel.Artikel
          and S_ArtKundeRabDatum.Kunde           = S_ArtKunde.Kunde
          and S_ArtKundeRabDatum.gueltig_ab     <= today
          and (   S_ArtKundeRabDatum.gueltig_bis > today
               or S_ArtKundeRabDatum.gueltig_bis = ?)
        exclusive-lock
        on error undo, throw:

        if not can-find(bS_ArtKundeRabDatum
                          where bS_ArtKundeRabDatum.Firma       = S_ArtKundeRabDatum.Firma
                            and bS_ArtKundeRabDatum.Artikel     = S_ArtKundeRabDatum.Artikel
                            and bS_ArtKundeRabDatum.Kunde       = S_ArtKundeRabDatum.Kunde
                            and bS_ArtKundeRabDatum.gueltig_ab  = S_ArtKundeRabDatum.gueltig_ab
                            and bS_ArtKundeRabDatum.gueltig_bis = today) then

          S_ArtKundeRabDatum.gueltig_bis = today.

      end.

      for each S_ArtKundeRabDatum
        where S_ArtKundeRabDatum.Firma      = {firma/sartkund.fir S_Firma.Firma}
          and S_ArtKundeRabDatum.Artikel    = S_Artikel.Artikel
          and S_ArtKundeRabDatum.Kunde      = S_ArtKunde.Kunde
          and S_ArtKundeRabDatum.gueltig_ab > today
        exclusive-lock
        on error undo, throw:

        if not can-find(bS_ArtKundeRabDatum
                          where bS_ArtKundeRabDatum.Firma       = S_ArtKundeRabDatum.Firma
                            and bS_ArtKundeRabDatum.Artikel     = S_ArtKundeRabDatum.Artikel
                            and bS_ArtKundeRabDatum.Kunde       = S_ArtKundeRabDatum.Kunde
                            and bS_ArtKundeRabDatum.gueltig_ab  = S_ArtKundeRabDatum.gueltig_ab
                            and bS_ArtKundeRabDatum.gueltig_bis = S_ArtKundeRabDatum.gueltig_ab) then

          S_ArtKundeRabDatum.gueltig_bis = S_ArtKundeRabDatum.gueltig_ab.

      end.

      for each S_ArtKundeStaffel
        where S_ArtKundeStaffel.Firma           = {firma/sartkund.fir S_Firma.Firma}
          and S_ArtKundeStaffel.Artikel         = S_Artikel.Artikel
          and S_ArtKundeStaffel.Kunde           = S_ArtKunde.Kunde
          and S_ArtKundeStaffel.gueltig_ab     <= today
          and (   S_ArtKundeStaffel.gueltig_bis > today
               or S_ArtKundeStaffel.gueltig_bis = ?)
        exclusive-lock
        on error undo, throw:

        if not can-find(bS_ArtKundeStaffel
                          where bS_ArtKundeStaffel.Firma        = S_ArtKundeStaffel.Firma
                            and bS_ArtKundeStaffel.Artikel      = S_ArtKundeStaffel.Artikel
                            and bS_ArtKundeStaffel.Kunde        = S_ArtKundeStaffel.Kunde
                            and bS_ArtKundeStaffel.gueltig_ab   = S_ArtKundeStaffel.gueltig_ab
                            and bS_ArtKundeStaffel.gueltig_bis  = today
                            and bS_ArtKundeStaffel.StaffelMenge = S_ArtKundeStaffel.StaffelMenge) then

          S_ArtKundeStaffel.gueltig_bis = today.

      end.

      for each S_ArtKundeStaffel
        where S_ArtKundeStaffel.Firma      = {firma/sartkund.fir S_Firma.Firma}
          and S_ArtKundeStaffel.Artikel    = S_Artikel.Artikel
          and S_ArtKundeStaffel.Kunde      = S_ArtKunde.Kunde
          and S_ArtKundeStaffel.gueltig_ab > today
        exclusive-lock
        on error undo, throw:

        if not can-find(bS_ArtKundeStaffel
                          where bS_ArtKundeStaffel.Firma        = S_ArtKundeStaffel.Firma
                            and bS_ArtKundeStaffel.Artikel      = S_ArtKundeStaffel.Artikel
                            and bS_ArtKundeStaffel.Kunde        = S_ArtKundeStaffel.Kunde
                            and bS_ArtKundeStaffel.gueltig_ab   = S_ArtKundeStaffel.gueltig_ab
                            and bS_ArtKundeStaffel.gueltig_bis  = S_ArtKundeStaffel.gueltig_ab
                            and bS_ArtKundeStaffel.StaffelMenge = S_ArtKundeStaffel.StaffelMenge) then

          S_ArtKundeStaffel.gueltig_bis = S_ArtKundeStaffel.gueltig_ab.

      end.

      for each S_ArtKundeRabStaffel
        where S_ArtKundeRabStaffel.Firma           = {firma/sartkund.fir S_Firma.Firma}
          and S_ArtKundeRabStaffel.Artikel         = S_Artikel.Artikel
          and S_ArtKundeRabStaffel.Kunde           = S_ArtKunde.Kunde
          and S_ArtKundeRabStaffel.gueltig_ab     <= today
          and (   S_ArtKundeRabStaffel.gueltig_bis > today
               or S_ArtKundeRabStaffel.gueltig_bis = ?)
        exclusive-lock
        on error undo, throw:

        if not can-find(bS_ArtKundeRabStaffel
                          where bS_ArtKundeRabStaffel.Firma        = S_ArtKundeRabStaffel.Firma
                            and bS_ArtKundeRabStaffel.Artikel      = S_ArtKundeRabStaffel.Artikel
                            and bS_ArtKundeRabStaffel.Kunde        = S_ArtKundeRabStaffel.Kunde
                            and bS_ArtKundeRabStaffel.gueltig_ab   = S_ArtKundeRabStaffel.gueltig_ab
                            and bS_ArtKundeRabStaffel.gueltig_bis  = today
                            and bS_ArtKundeRabStaffel.StaffelMenge = S_ArtKundeRabStaffel.StaffelMenge) then

          S_ArtKundeRabStaffel.gueltig_bis = today.

      end.

      for each S_ArtKundeRabStaffel
        where S_ArtKundeRabStaffel.Firma      = {firma/sartkund.fir S_Firma.Firma}
          and S_ArtKundeRabStaffel.Artikel    = S_Artikel.Artikel
          and S_ArtKundeRabStaffel.Kunde      = S_ArtKunde.Kunde
          and S_ArtKundeRabStaffel.gueltig_ab > today
        exclusive-lock
        on error undo, throw:

        if not can-find(bS_ArtKundeRabStaffel
                          where bS_ArtKundeRabStaffel.Firma        = S_ArtKundeRabStaffel.Firma
                            and bS_ArtKundeRabStaffel.Artikel      = S_ArtKundeRabStaffel.Artikel
                            and bS_ArtKundeRabStaffel.Kunde        = S_ArtKundeRabStaffel.Kunde
                            and bS_ArtKundeRabStaffel.gueltig_ab   = S_ArtKundeRabStaffel.gueltig_ab
                            and bS_ArtKundeRabStaffel.gueltig_bis  = S_ArtKundeRabStaffel.gueltig_ab
                            and bS_ArtKundeRabStaffel.StaffelMenge = S_ArtKundeRabStaffel.StaffelMenge) then

          S_ArtKundeRabStaffel.gueltig_bis = S_ArtKundeRabStaffel.gueltig_ab.

      end.

    end. /* for each S_ArtKunde */

    /*------------------------------------------------------------------------*/
    /* Is the Article a Cross Selling Item (Folgeteil) or a Alternate Part    */
    /* (Alternativteil) then stop the archiving.                              */
    /*------------------------------------------------------------------------*/

    find first gbS_ArtAlternativ
      where gbS_ArtAlternativ.Firma               = {firma/sartikel.fir S_Firma.Firma}
        and gbS_ArtAlternativ.AlternativArtikel   = S_Artikel.Artikel
        and can-find(first S_Artikel
                       where S_Artikel.Firma      = {firma/sartikel.fir S_Firma.Firma}
                         and S_Artikel.Artikel    = gbS_ArtAlternativ.Artikel
                         and S_Artikel.archiviert = no)
    no-lock no-error.

    if available gbS_ArtAlternativ then

      if gbS_ArtAlternativ.Typ = 'F':U then

        /*--------------------------------------------------------------------*/
        /* Message: Das Teil &1 existiert als Folgeteil zu einem Artikel und  */
        /*          kann daher nicht archiviert werden!                       */
        /*--------------------------------------------------------------------*/

        adm.method.cls.DMCMessageSvc:prpoInstance:showError
          ('s_art00031':U,
           S_Artikel.Artikel).

      else

        /*--------------------------------------------------------------------*/
        /* Message: Das Teil &1 existiert als Alternativteil zu einem Artikel */
        /*          und kann daher nicht archiviert werden!                   */
        /*--------------------------------------------------------------------*/

        adm.method.cls.DMCMessageSvc:prpoInstance:showError
          ('s_art00032':U,
           S_Artikel.Artikel).

    /* Dispovorschläge löschen  */

    &IF LOOKUP("MD","{&PA-MODULE}") > 0 &THEN

      mawi.dispo.cls.MDCMRPSuggestionsSvc:prpoInstance:deleteMRPSuggestionsByPart
        (S_Firma.Firma,
         S_Artikel.Artikel).

    &ENDIF

    /* delete Sales plan user  */

    &IF LOOKUP("VP","{&PA-MODULE}") > 0 &THEN

      for each VPM_User
        where VPM_User.firma         = {firma/vpplan_.fir S_Firma.Firma}
          and VPM_User.ArtikelGruppe = S_Artikel.Artikelgruppe
          and VPM_User.Artikel       = S_Artikel.Artikel
        exclusive-lock
        on error  undo, throw:

        delete VPM_User.

      end.

    &ENDIF  /* Modul VP  */

  end.  /* if S_Artikel.archiviert */

  if    S_Artikel.Suchbegriff <> OLD_S_Artikel.Suchbegriff
     or S_Artikel.Selektion   <> OLD_S_Artikel.Selektion then

    stamm.base.cls.SBCMasterFilesIncDriverAccSvc:prpoInstance:SynchronizeIncDriverTerms
      (S_Firma.Firma,
       'Part':U,
       S_Artikel.S_Artikel_Obj,
       Old_S_Artikel.Suchbegriff,
       S_Artikel.Suchbegriff,
       Old_S_Artikel.Selektion,
       S_Artikel.Selektion).

  /*--------------------------------------------------------------------------*/
  /* Change of Material Management Unit                                       */
  /*--------------------------------------------------------------------------*/

  if Old_S_Artikel.LagerME <> S_Artikel.LagerME then
  do:

   /* Die Lagermengeneinheit ist nicht änderbar, sobald Lagerbestände existieren */

    &IF LOOKUP("ML","{&PA-MODULE}") > 0  &THEN

      if mawi.lager.cls.MLCOnHandInvSvc:prpoInstance:lIsOnHandAvailable
          (S_Artikel.Artikel,
           '':U,
           '':U,
           '':U) then
        adm.method.cls.DMCMessageSvc:prpoInstance:showError
          ('s_trg03010':U,
           S_Artikel.Artikel).

    &ENDIF

    /* Verpackungsmengeneinheiten */

    if S_Artikel.AenderungDatum = ? then
    do:

      /* immer noch Neuanlage                                                 */
      /* die Initial-Verpackungsmengeneinheit kann gelöscht werden            */

      find S_ArtME
        where S_ArtME.Firma         = {firma/sartikel.fir S_Firma.Firma}
          and S_ArtME.Artikel       = S_Artikel.Artikel
          and S_ArtME.Mengeneinheit = Old_S_Artikel.LagerME
        exclusive-lock no-error.

      if available S_ArtME then
        delete S_ArtME.

    end.

    find S_ArtME
      where S_ArtME.Firma         = {firma/sartikel.fir S_Firma.Firma}
        and S_ArtME.Artikel       = S_Artikel.Artikel
        and S_ArtME.MengenEinheit = S_Artikel.LagerME
      exclusive-lock no-error.

    if not available S_ArtME then
    do:

      create S_ArtME.
      assign
        S_ArtME.Firma         = {firma/sartikel.fir S_Firma.Firma}
        S_ArtME.Artikel       = S_Artikel.Artikel
        S_ArtME.MengenEinheit = S_Artikel.LagerME
        .
      validate S_ArtME.

    end.

    assign
      S_ArtME.Gewicht            = 0
      S_ArtME.VME_Faktor         = 1
      S_ArtME.GebindeNr          = 0
      S_ArtME.GebindeNrEindeutig = no
      .
    validate S_ArtME.

    if can-find (first S_ArtME
                   where S_ArtME.Firma          = {firma/sartikel.fir S_Firma.Firma}
                     and S_ArtME.Artikel        = S_Artikel.Artikel
                     and S_ArtME.Mengeneinheit <> Old_S_Artikel.LagerME
                     and S_ArtME.Mengeneinheit <> S_Artikel.LagerME) then

      adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
        ('s_trg00235':U,
         S_Artikel.Artikel).

    &IF LOOKUP("E_","{&PA-MODULE}") > 0 &THEN

      /* Reset the quantity factor of suppliers with the same unit of measure */

      find bS_Mengeneinheit
        where bS_Mengeneinheit.Firma         = {firma/smngeinh.fir S_Firma.Firma}
          and bS_Mengeneinheit.MengenEinheit = S_Artikel.LagerME
        no-lock.

      for each bE_ArtLief
        where bE_ArtLief.Firma               = {firma/e_artli.fir S_Firma.Firma}
          and bE_ArtLief.Artikel             = S_Artikel.Artikel
          and bE_ArtLief.S_MengenEinheit_Obj = bS_Mengeneinheit.S_MengenEinheit_Obj 
        exclusive-lock
        on error undo, throw:

        bE_ArtLief.MengenFaktor = 1.

      end. /* for each bE_ArtLief */

      /* Change the unit of measure to all usages as provided part.           */

      for each bE_ArtLiefBei
        where bE_ArtLiefBei.Firma            = {firma/e_artli.fir S_Firma.Firma}
          and bE_ArtLiefBei.Beistellartikel  = S_Artikel.Artikel
        exclusive-lock,
      first bS_Mengeneinheit
        where bS_Mengeneinheit.Firma         = {firma/smngeinh.fir S_Artikel.Firma}
          and bS_Mengeneinheit.Mengeneinheit = S_Artikel.LagerME
        no-lock
        on error undo, throw:

        assign
          bE_ArtLiefBei.MengenEinheit = S_Artikel.LagerME
          bE_ArtLiefBei.Nachkomma     = bS_MengenEinheit.Nachkomma
          .

      end. /* for each bE_ArtLiefBei */

    &ENDIF

  end.  /* if Old_S_Artikel.LagerME <> S_Artikel.LagerME  */

  /*--------------------------------------------------------------------------*/
  /* Prüfung Kontengruppe nach Wechsel von Werteflussgruppe                   */
  /*--------------------------------------------------------------------------*/

  if    Old_S_Artikel.SBM_ValueFlowGroup_Obj <> S_Artikel.SBM_ValueFlowGroup_Obj
    and adm.config.cls.DCCAppConfigSvc:prpoInstance:lParameterValue('SB_CtrlForAccountGrpMod':U) = yes
    and can-find (bSBM_ValueFlowGroup-Old
                    where bSBM_ValueFlowGroup-Old.SBM_ValueFlowGroup_Obj = Old_S_Artikel.SBM_ValueFlowGroup_Obj
                      and can-find (bSBM_ValueFlowGroup-New
                                      where bSBM_ValueFlowGroup-New.SBM_ValueFlowGroup_Obj = S_Artikel.SBM_ValueFlowGroup_Obj
                                        and bSBM_ValueFlowGroup-New.S_ArtKtoGr_Obj        <> bSBM_ValueFlowGroup-Old.S_ArtKtoGr_Obj)) then
  do:

    &IF LOOKUP("ML","{&PA-MODULE}") > 0 &THEN

      if mawi.lager.cls.MLCOnHandInvSvc:prpoInstance:lIsOwnHandAvailable
           (S_Artikel.Artikel,
            '':U,
            '':U,
            '':U) = yes then
        adm.method.cls.DMCMessageSvc:prpoInstance:showError
          ('m_trg00109':U,
           S_Artikel.Artikel).

    &ENDIF

    &IF LOOKUP("E_","{&PA-MODULE}") > 0 &THEN

      cDocTypeList = 'EB,EAB,ERL,EBA':U.
      do i = 1 to num-entries (cDocTypeList):

        find first E_BelegPos
          where E_BelegPos.Firma    = {firma/ebelkop.fir S_Firma.Firma}
            and E_BelegPos.Belegart = entry(i,cDocTypeList)
            and E_BelegPos.offen    = yes
            and E_BelegPos.Artikel  = S_Artikel.Artikel
          use-index ArtTermin
          no-lock no-error.

        if available E_BelegPos then
        do:

          find E_BelegKopf
            where E_BelegKopf.Firma      = E_BelegPos.Firma
              and E_BelegKopf.BelegArt   = E_BelegPos.BelegArt
              and E_BelegKopf.ReferenzNr = E_BelegPos.ReferenzNr
            no-lock.

          stamm.base.cls.SBCPartSvc:prpoInstance:ShowDocConsist
            ('m_trg00108':U,
             S_Artikel.Artikel,
             E_BelegKopf.Belegart,
             string(E_BelegKopf.Belegnummer)).

        end. /* if available E_BelegPos */
      end. /* do i = 1 to ... */

      /* Wareneingänge */

      find first E_WE_Pos
        where E_WE_Pos.Firma     = {firma/ebelkop.fir S_Firma.Firma}
          and E_WE_Pos.Artikel   = S_Artikel.Artikel
          and E_WE_Pos.berechnet = no
        use-index Art
        no-lock no-error.

      if available E_WE_Pos then
      do:

        find E_WE_Kopf
          where E_WE_Kopf.Firma      = E_WE_Pos.Firma
            and E_WE_Kopf.ReferenzNr = E_WE_Pos.ReferenzNr
          no-lock.

        stamm.base.cls.SBCPartSvc:prpoInstance:ShowDocConsist
          ('m_trg00108':U,
           S_Artikel.Artikel,
           'EWE':U,
           string(E_WE_Kopf.Belegnummer)).

      end. /* if available E_WE_Pos */

      /* Rahmenaufträge */

      find first E_RA_Pos
        where E_RA_Pos.Firma    = {firma/ebelkop.fir S_Firma.Firma}
          and E_RA_Pos.Belegart = 'ERA':U
          and E_RA_Pos.offen    = yes
          and E_RA_Pos.Artikel  = S_Artikel.Artikel
        use-index Artikel
        no-lock no-error.

      if available E_RA_Pos then
      do:

        find E_RA_Kopf
          where E_RA_Kopf.Firma      = E_RA_Pos.Firma
            and E_RA_Kopf.BelegArt   = E_RA_Pos.BelegArt
            and E_RA_Kopf.ReferenzNr = E_RA_Pos.ReferenzNr
          no-lock.

        stamm.base.cls.SBCPartSvc:prpoInstance:ShowDocConsist
          ('m_trg00108':U,
           S_Artikel.Artikel,
           E_RA_Kopf.BelegArt,
           string(E_RA_Kopf.Belegnummer)).

      end. /* if available E_RA_Pos */

      &IF LOOKUP("ER","{&PA-MODULE}") > 0 &THEN

        /* Rechnungskontrollbelege */

        find first ER_BelegPos
          where ER_BelegPos.Firma    = {firma/ebelkop.fir S_Firma.Firma}
            and ER_BelegPos.BelegArt = 'ERR':U
            and ER_BelegPos.verbucht = no
            and ER_BelegPos.Artikel  = S_Artikel.Artikel
          no-lock no-error.

        if not available ER_BelegPos then

          /* Rechnungskontrollbelege (Anzahlung) */

          find first ER_BelegPos
            where ER_BelegPos.Firma    = {firma/ebelkop.fir S_Firma.Firma}
              and ER_BelegPos.BelegArt = 'ERZ':U
              and ER_BelegPos.verbucht = no
              and ER_BelegPos.Artikel  = S_Artikel.Artikel
            no-lock no-error.

        if available ER_BelegPos then
        do:

          find ER_BelegKopf
            where ER_BelegKopf.Firma      = ER_BelegPos.Firma
              and ER_BelegKopf.BelegArt   = ER_BelegPos.BelegArt
              and ER_BelegKopf.ReferenzNr = ER_BelegPos.ReferenzNr
            no-lock.

          stamm.base.cls.SBCPartSvc:prpoInstance:ShowDocConsist
            ('m_trg00108':U,
             S_Artikel.Artikel,
             ER_BelegKopf.BelegArt,
             string(ER_BelegKopf.Belegnummer)).

        end. /* if available ER_BelegPos */

      &ENDIF

    &ENDIF /* &IF LOOKUP("E_","{&PA-MODULE}") > 0 &THEN */

    &IF LOOKUP("VS","{&PA-MODULE}") > 0
      AND LOOKUP("VS_SAUF","{&PA-OPTIONEN}") > 0 &THEN

      do i = 1 to 3:

        find first gbVS_AuftragMKT
          where gbVS_AuftragMKT.Firma    = {firma/vbelegko.fir S_Firma.Firma}
            and gbVS_AuftragMKT.BelegArt = 'VSA':U
            and gbVS_AuftragMKT.SatzArt  = entry(i, 'A,M,K':U)
            and gbVS_AuftragMKT.offen    = yes
            and gbVS_AuftragMKT.Artikel  = S_Artikel.Artikel
          no-lock no-error.

        if available gbVS_AuftragMKT then

          stamm.base.cls.SBCPartSvc:prpoInstance:ShowDocConsist
            ('m_trg00108':U,
             S_Artikel.Artikel,
             gbVS_AuftragMKT.BelegArt,
             string(gbVS_AuftragMKT.Belegnummer)).

      end. /* do i = 1 to 3: */

      find first gbVS_AuftragPos
        where gbVS_AuftragPos.Firma    = {firma/vbelegko.fir S_Firma.Firma}
          and gbVS_AuftragPos.BelegArt = 'VSA':U
          and gbVS_AuftragPos.offen    = yes
          and gbVS_AuftragPos.Artikel  = S_Artikel.Artikel
        no-lock no-error.

      if not available gbVS_AuftragPos then
        find first gbVS_AuftragPos
          where gbVS_AuftragPos.Firma       = {firma/vbelegko.fir S_Firma.Firma}
            and gbVS_AuftragPos.BelegArt    = 'VSA':U
            and gbVS_AuftragPos.offen       = yes
            and gbVS_AuftragPos.Mat_Artikel = S_Artikel.Artikel
          no-lock no-error.

      if not available gbVS_AuftragPos then
        find first gbVS_AuftragPos
          where gbVS_AuftragPos.Firma        = {firma/vbelegko.fir S_Firma.Firma}
            and gbVS_AuftragPos.BelegArt     = 'VSA':U
            and gbVS_AuftragPos.offen        = yes
            and gbVS_AuftragPos.Kost_Artikel = S_Artikel.Artikel
          no-lock no-error.

      if available gbVS_AuftragPos then

        stamm.base.cls.SBCPartSvc:prpoInstance:ShowDocConsist
          ('m_trg00108':U,
           S_Artikel.Artikel,
           gbVS_AuftragPos.BelegArt,
           string(gbVS_AuftragPos.Belegnummer)).

    &ENDIF

    &IF LOOKUP("V_","{&PA-MODULE}") > 0  &THEN

      /* Verwendung in Vertriebsbelegen                                       */

      cDocTypeList = 'U,L,R,G,VUA,VUD,VUR,VFP,VFA,VJI,VLA':U.
      do i = 1 to num-entries (cDocTypeList):

        find first V_BelegPos
          where V_BelegPos.Firma    = {firma/vbelegko.fir S_Firma.Firma}
            and V_BelegPos.Belegart = entry(i,cDocTypeList)
            and V_BelegPos.offen    = yes
            and V_BelegPos.Artikel  = S_Artikel.Artikel
          no-lock no-error.

        if available V_BelegPos then

          stamm.base.cls.SBCPartSvc:prpoInstance:ShowDocConsist
            ('m_trg00108':U,
             S_Artikel.Artikel,
             V_BelegPos.BelegArt,
             string(V_BelegPos.Belegnummer)).

        find first VU_RA_Artikel
          where VU_RA_Artikel.Firma    = {firma/vbelegko.fir S_Firma.Firma}
            and VU_RA_Artikel.Belegart = entry(i,cDocTypeList)
            and VU_RA_Artikel.offen    = yes
            and VU_RA_Artikel.Artikel  = S_Artikel.Artikel
          no-lock no-error.

        if available VU_RA_Artikel then
        do:

          find V_BelegPos
            where V_BelegPos.Firma       = VU_RA_Artikel.Firma
              and V_BelegPos.Belegart    = VU_RA_Artikel.Belegart
              and V_BelegPos.ReferenzNr  = VU_RA_Artikel.ReferenzNr
              and V_BelegPos.lfdNr_SR    = 0
              and V_BelegPos.PositionsNr = VU_RA_Artikel.PositionsNr
            no-lock.

          stamm.base.cls.SBCPartSvc:prpoInstance:ShowDocConsist
            ('m_trg00108':U,
             S_Artikel.Artikel,
             V_BelegPos.BelegArt,
             string(V_BelegPos.Belegnummer)).

        end.

      end. /* do i = 1 to ... */

    &ENDIF /* Modul V_ */

    &IF LOOKUP("PP","{&PA-MODULE}") > 0 &THEN

      for each gbPPT_Orderpart
        where gbPPT_Orderpart.Company = {firma/ppauftra.fir S_Firma.Firma}
          and gbPPT_Orderpart.Part    = S_Artikel.Artikel
        no-lock,
        first gbPP_Auftrag
          where gbPP_Auftrag.PP_Auftrag_Obj = gbPPT_OrderPart.Owning_Obj
          no-lock
        on error undo, throw:

        if gbPP_Auftrag.Archived = no then
          stamm.base.cls.SBCPartSvc:prpoInstance:ShowDocConsist
            ('m_trg00108':U,
             S_Artikel.Artikel,
             (if gbPP_Auftrag.AuftragsKennung = 'A':U then
                'PPN':U
              else
                'PPA':U),
             gbPP_Auftrag.Auftrag).

        if gbPP_Auftrag.nicht_erster = yes then
        do:

          find first gbPP_Auftrag-Head
            where gbPP_Auftrag-Head.Firma        = {firma/ppauftra.fir S_Firma.Firma}
              and gbPP_Auftrag-Head.Auftrag      = gbPP_Auftrag.Auftrag
              and gbPP_Auftrag-Head.nicht_erster = false
          no-lock.

          if gbPP_Auftrag-Head.Archived = no then
            stamm.base.cls.SBCPartSvc:prpoInstance:ShowDocConsist
              ('m_trg00108':U,
               S_Artikel.Artikel,
               (if gbPP_Auftrag.AuftragsKennung = 'A':U then
                  'PPN':U
                else
                  'PPA':U),
               gbPP_Auftrag.Auftrag).

        end. /* if gbPP_Auftrag.nicht_erster = yes */

      end. /* for each gbPPT_Orderpart */

      for each gbPP_StkZeile
        where gbPP_StkZeile.Firma   = {firma/ppauftra.fir S_Firma.Firma}
          and gbPP_StkZeile.Artikel = S_Artikel.Artikel
        no-lock
        on error undo, throw:

        if gbPP_StkZeile.AuftragsStatus <> {&pa_PP_OrderStatus_Archived} then
        do:

          find gbPP_Auftrag
            where gbPP_Auftrag.Firma        = {firma/ppauftra.fir S_Firma.Firma}
              and gbPP_Auftrag.RueckmeldeNr = gbPP_StkZeile.RueckmeldeNr
            no-lock.

          stamm.base.cls.SBCPartSvc:prpoInstance:ShowDocConsist
            ('m_trg00108':U,
             S_Artikel.Artikel,
             (if gbPP_Auftrag.AuftragsKennung = 'A':U then
                'PPN':U
              else
                'PPA':U),
             gbPP_Auftrag.Auftrag).

        end. /* if gbPP_StkZeile.AuftragsStatus <> {&pa_PP_OrderStatus_Archived} */

        find first gbPP_Auftrag-Head
          where gbPP_Auftrag-Head.Firma        = {firma/ppauftra.fir S_Firma.Firma}
            and gbPP_Auftrag-Head.Auftrag      = gbPP_StkZeile.Auftrag
            and gbPP_Auftrag-Head.nicht_erster = false
        no-lock.

        if gbPP_Auftrag-Head.Archived = no then
          stamm.base.cls.SBCPartSvc:prpoInstance:ShowDocConsist
            ('m_trg00108':U,
             S_Artikel.Artikel,
             (if gbPP_Auftrag-Head.AuftragsKennung = 'A':U then
                'PPN':U
              else
                'PPA':U),
             gbPP_Auftrag-Head.Auftrag).

      end. /* for each gbPP_StkZeile */

      do i = 1 to 4:

        for each gbMB_Aktivitaet
          where gbMB_Aktivitaet.Firma          = {firma/mawib.fir S_Firma.Firma}
            and gbMB_Aktivitaet.ProzessBereich = (if   i = 1
                                                    or i = 2 then
                                                    'PPA':U
                                                  else
                                                    'PPN':U)
            and gbMB_Aktivitaet.AktArt         = (if   i = 1
                                                    or i = 3 then
                                                    {&pa_MM_ActivityTypeProduction}
                                                  else
                                                    {&pa_MM_ActivityTypeExternaloperation})
            and gbMB_Aktivitaet.Artikel        = S_Artikel.Artikel
          no-lock
          on error undo, throw:

          if gbMB_Aktivitaet.AuftragsStatus <> {&pa_PP_OrderStatus_Archived} then
          do:

            find gbPP_Auftrag
              where gbPP_Auftrag.Firma        = {firma/ppauftra.fir S_Firma.Firma}
                and gbPP_Auftrag.RueckmeldeNr = gbMB_Aktivitaet.Teilprozess
              no-lock.

            stamm.base.cls.SBCPartSvc:prpoInstance:ShowDocConsist
              ('m_trg00108':U,
               S_Artikel.Artikel,
               (if gbPP_Auftrag.AuftragsKennung = 'A':U then
                  'PPN':U
                else
                  'PPA':U),
               gbPP_Auftrag.Auftrag).

          end. /* if gbMB_Aktivitaet.AuftragsStatus <> {&pa_PP_OrderStatus_Archived} */

          find first gbPP_Auftrag-Head
            where gbPP_Auftrag-Head.Firma        = {firma/ppauftra.fir S_Firma.Firma}
              and gbPP_Auftrag-Head.Auftrag      = gbMB_Aktivitaet.Prozess
              and gbPP_Auftrag-Head.nicht_erster = false
          no-lock.

          if gbPP_Auftrag-Head.Archived = no then
            stamm.base.cls.SBCPartSvc:prpoInstance:ShowDocConsist
              ('m_trg00108':U,
               S_Artikel.Artikel,
               (if gbPP_Auftrag-Head.AuftragsKennung = 'A':U then
                  'PPN':U
                else
                  'PPA':U),
               gbPP_Auftrag-Head.Auftrag).

        end. /* for each gbMB_Aktivitaet */

      end. /* do i = 1 to ... */

    &ENDIF /* Modul PP */

  end. /* Werteflussgruppe - Kontengruppe */

  run CheckPartsPlanning.

  /*--------------------------------------------------------------------------*/
  /* Modul Mawi                                                               */
  /*--------------------------------------------------------------------------*/

  /* Wenn Modul MU nicht aktiv ist, dürfen Teile mit Teileart 4 nicht angelegt werden */

  &IF LOOKUP("MU","{&PA-MODULE}") = 0  &THEN

    if S_Artikel.Artikelart = {&pa_S_PT_ConfiguredPart} then
      adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
        ('S_Artikel':U,
         'Artikelart':U,
         'm_trg00110':U,
         S_Artikel.Artikel).

  &ENDIF

  &IF LOOKUP("MU","{&PA-MODULE}") > 0  &THEN

    &IF "{&pa_MU_Konvertierung}" = "0" &THEN

      /* Wenn sich die Teileart auf 4 ändert, dürfen keine Stücklistenpositionen */
      /* vorhanden sein                                                          */
      /* ### Code deaktiveren wenn keine relevante Funktion aktiv                */

      if    old_S_Artikel.ArtikelArt <> S_Artikel.ArtikelArt
        and S_Artikel.ArtikelArt     =  {&pa_S_PT_ConfiguredPart}
        and can-find(last PMM_BomHead
                       where PMM_BomHead.Company = {firma/pps.fir S_Artikel.Firma}
                         and PMM_BomHead.BomType = {&pa_PMM_BomType_Production}
                         and PMM_BomHead.Part    = S_Artikel.Artikel
                         and can-find (first PMM_BomLine
                                         where      PMM_BomLine.Company    = {firma/pps.fir S_Artikel.Firma}
                                                and PMM_BomLine.Owning_Obj = PMM_BomHead.PMM_BomHead_Obj)) then

                adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
                  ('mutrg00006':U,
                   S_Artikel.Artikel).

    &ENDIF

    if    S_Artikel.Artikelart = {&pa_S_PT_ConfiguredPart}
      and S_Artikel.SMLeiste > '':U
      and not can-find(BS_Kopf
                         where BS_Kopf.SMArt    = 'PV':U
                           and BS_Kopf.Firma    = S_Artikel.Firma
                           and BS_Kopf.SMLeiste = S_Artikel.SMLeiste) then
      adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
        ('bssel00001':U,
         S_Artikel.SMLeiste).

  &ENDIF

  /*--------------------------------------------------------------------------*/
  /* Modul PV                                                                 */
  /*--------------------------------------------------------------------------*/

    if Old_S_Artikel.Artikelart <> S_Artikel.Artikelart then
    do:

    &IF LOOKUP("PV","{&PA-MODULE}") > 0  &THEN

      /*----------------------------------------------------------------------*/
      /* Wenn sich die Teileart auf 7 ändert, darf kein Stücklistenkopf       */
      /* vorhanden sein.                                                      */
      /*----------------------------------------------------------------------*/

      if    S_Artikel.Artikelart = {&pa_S_PT_VariantPart}
        and can-find(first PMM_BomHeadMaster
                       where PMM_BomHeadMaster.Company   = {firma/pps.fir S_Artikel.Firma}
                         and PMM_BomHeadMaster.Part      = S_Artikel.Artikel) then

        adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
          ('pvtrg00001':U,
           S_Artikel.Artikel).

      /*----------------------------------------------------------------------*/
      /* Wenn sich die Teileart auf <> 7 ändert, darf kein                    */
      /* Variantenstücklistenkopf vorhanden sein.                             */
      /*----------------------------------------------------------------------*/

      &IF "{&pa_MU_Konvertierung}" = "0" &THEN

        if    Old_S_Artikel.Artikelart = {&pa_S_PT_VariantPart}
          and can-find(PV_Kopf
                         where PV_Kopf.Firma   = {firma/pps.fir S_Artikel.Firma}
                           and PV_Kopf.Artikel = S_Artikel.Artikel) then
        adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
          ('pvstk00001':U,
           S_Artikel.Artikel).

      &ELSE

        if    Old_S_Artikel.Artikelart = {&pa_S_PT_VariantPart}
          and not S_Artikel.ArtikelArt = {&pa_S_PT_ConfiguredPart}
          and can-find(PV_Kopf
                         where PV_Kopf.Firma   = {firma/pps.fir S_Artikel.Firma}
                           and PV_Kopf.Artikel = S_Artikel.Artikel) then
          adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
            ('pvstk00001':U,
             S_Artikel.Artikel).

      &ENDIF

    &ENDIF

    &IF LOOKUP("MA","{&PA-MODULE}") > 0  &THEN

      /* check for temp. structures and decline the part type change if you   */
      /* can find one structure                                               */
      /*----------------------------------------------------------------------*/

      cTempProcessAreas = adm.config.cls.DCCAppConfigSvc:prpoInstance:cParameterValue
                           ('MM_TempProcessAreas':U,
                            ',':U).
      if S_Artikel.ArtikelArt = {&pa_S_PT_PhantomAssembly} then
      do i = 1 to num-entries(cTempProcessAreas):

        if can-find(first MA_TempProzess
                      where MA_TempProzess.Firma          = {firma/mawia.fir S_Artikel.Firma}
                        and MA_TempProzess.ProzessBereich = entry(i,cTempProcessAreas)
                        and MA_TempProzess.Artikel        = S_Artikel.Artikel) then

          adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
            ('matmp000011':U,
             S_Artikel.Artikel).

      end. /* if S_Artikel.ArtikelArt = {&pa_S_PT_PhantomAssembly} */

    &ENDIF

    end. /* if old_S_Artikel.Artikelart <> S_Artikel.Artikelart */

  &IF LOOKUP("M_","{&PA-MODULE}") > 0  &THEN

    /* no MRP Account allowed for this part type */

    if    Old_S_Artikel.ArtikelArt <> S_Artikel.ArtikelArt
      and can-do({&pa_MM_PTList_NoMRPAccount},gcItemTypeNewPart)
      and can-find (first MMT_MRPAccount
                      where MMT_MRPAccount.Company = S_Firma.Firma
                        and MMT_MRPAccount.Artikel = S_Artikel.Artikel) then
    do:

      cTemp = ({fnarg
                 pa_cStCchPartTypeDesc
                 "S_Artikel.ArtikelArt,
                  {&pa_DefaultSprache},
                  {&pa_CchDesc}"}).

      adm.method.cls.DMCMessageSvc:prpoInstance:showError
        ('mmacc00012':U,
         S_Artikel.Artikel,
         cTemp).

    end. /* if Old_S_Artikel.ArtikelArt <> S_Artikel.ArtikelArt and */

    /* Part type changed to allowed for MRP Account                           */

    &IF   LOOKUP("E_","{&PA-MODULE}") > 0
       OR LOOKUP("V_","{&PA-MODULE}") > 0 &THEN

      /* This basic validation is done to avoid documents containing items    */
      /* with no MRP Accounts. A complete validation should prove further     */
      /* subject like Storage Area previously requested not requested any     */
      /* more, vice versa and ...                                             */

      if Old_S_Artikel.ArtikelArt <> S_Artikel.ArtikelArt then
      do:

        if    can-do({&pa_MM_PTList_NoMRPAccount},gcItemTypeOldPart)
          and not can-do({&pa_MM_PTList_NoMRPAccount},gcItemTypeNewPart) then
        do:

          &IF LOOKUP("E_","{&PA-MODULE}") > 0 &THEN

            cDocTypeList = 'EB,EAB,ERL':U.

            do i = 1 to num-entries(cDocTypeList):

              /* Verwendung in offenen Bestellungen, Bestellungen mit         */
              /* Lieferplan oder Rücklieferungen                              */

              find first E_BelegPos
                where E_BelegPos.Firma    = {firma/ebelkop.fir S_Firma.Firma}
                  and E_BelegPos.Belegart = entry(i,cDocTypeList)
                  and E_BelegPos.offen    = yes
                  and E_BelegPos.Artikel  = S_Artikel.Artikel
                use-index ArtTermin
                no-lock no-error.

              if available E_BelegPos then
              do:

                find E_BelegKopf
                  where E_BelegKopf.Firma      = E_BelegPos.Firma
                    and E_BelegKopf.BelegArt   = E_BelegPos.BelegArt
                    and E_BelegKopf.ReferenzNr = E_BelegPos.ReferenzNr
                  no-lock.

                stamm.base.cls.SBCPartSvc:prpoInstance:ShowDocConsist
                  ('mmacc00013':U,
                   S_Artikel.Artikel,
                   E_BelegKopf.Belegart,
                   string(E_BelegKopf.Belegnummer)).

              end. /* if available E_BelegPos */

            end. /* do i = 1 to num-entries (cDocTypeList) */

          &ENDIF /* E_ */

          &IF LOOKUP("V_","{&PA-MODULE}") > 0  &THEN

            cDocTypeList = 'U,VUA':U.

            do i = 1 to num-entries(cDocTypeList):

              /* Verwendung in offenen Aufträgen, Abrufaufträgen              */

              find first V_BelegPos
                where V_BelegPos.Firma    = {firma/vbelegko.fir S_Firma.Firma}
                  and V_BelegPos.Belegart = entry(i,cDocTypeList)
                  and V_BelegPos.offen    = yes
                  and V_BelegPos.Artikel  = S_Artikel.Artikel
                no-lock no-error.

              if available V_BelegPos then

                stamm.base.cls.SBCPartSvc:prpoInstance:ShowDocConsist
                  ('mmacc00013':U,
                   S_Artikel.Artikel,
                   V_BelegPos.Belegart,
                   string(V_BelegPos.Belegnummer)).

            end.  /* do i = 1 to num-entries(cDocTypeList) */

          &ENDIF /* V_ */

        end. /* if    can-do({&pa_MM_PTList_NoMRPAccount},gcItemTypeOldPart) */

        /* Bevore changing to part types without storage area, check if parts */
        /* are used in open service documents.                                */

        &IF LOOKUP("VS","{&PA-MODULE}") > 0 &THEN

          if        can-do({&pa_M_PTList_StorageArea},gcItemTypeOldPart)
            and not can-do({&pa_M_PTList_StorageArea},gcItemTypeNewPart) then
          do:

            &IF LOOKUP("VS_SAUF","{&PA-OPTIONEN}") > 0 &THEN

              find first VS_AuftragPos
                where VS_AuftragPos.Firma          = {firma/vbelegko.fir S_Artikel.Firma}
                  and VS_AuftragPos.Belegart       = 'VSA':U
                  and VS_AuftragPos.offen          = yes
                  and VS_AuftragPos.ArtikelWartung = S_Artikel.Artikel
                no-lock no-error.

              if available VS_AuftragPos then
              do:

                find VS_Auftrag
                  where VS_Auftrag.Firma      = VS_AuftragPos.Firma
                    and VS_Auftrag.BelegArt   = VS_AuftragPos.BelegArt
                    and VS_Auftrag.ReferenzNr = VS_AuftragPos.ReferenzNr
                  no-lock.

                stamm.base.cls.SBCPartSvc:prpoInstance:ShowDocConsist
                  ('mmacc00013':U,
                   S_Artikel.Artikel,
                   VS_AuftragPos.Belegart,
                   string(VS_Auftrag.Belegnummer)).

              end. /* if available VS_AuftragPos then */

              find first VS_AuftragMKT
                where VS_AuftragMKT.Firma    = {firma/vbelegko.fir S_Artikel.Firma}
                  and VS_AuftragMKT.Belegart = 'VSA':U
                  and VS_AuftragMKT.Satzart  = 'M':U
                  and VS_AuftragMKT.offen    = yes
                  and VS_AuftragMKT.Artikel  = S_Artikel.Artikel
                no-lock no-error.

              if available VS_AuftragMKT then

                stamm.base.cls.SBCPartSvc:prpoInstance:ShowDocConsist
                  ('mmacc00013':U,
                   S_Artikel.Artikel,
                   VS_AuftragMKT.Belegart,
                   string(VS_AuftragMKT.Belegnummer)).
            &ENDIF /* VS_SAUF */

            /* check usage in Maintenance Contract */

            &IF LOOKUP("VS_WVERT","{&PA-OPTIONEN}") > 0 &THEN

              find first VST_MaintContractPos
                where VST_MaintContractPos.Company        = {firma/vbelegko.fir S_Artikel.Firma}
                  and VST_MaintContractPos.offen          = yes
                  and VST_MaintContractPos.ArtikelWartung = S_Artikel.Artikel
                no-lock no-error.

              if available VST_MaintContractPos then

                stamm.base.cls.SBCPartSvc:prpoInstance:ShowDocConsist
                  ('mmacc00013':U,
                   S_Artikel.Artikel,
                   'VSW':U,
                   string(VST_MaintContractPos.Belegnummer)).

              find first VST_MaintContMCA
                where VST_MaintContMCA.Company = {firma/vbelegko.fir S_Artikel.Firma}
                  and VST_MaintContMCA.Satzart = 'M':U
                  and VST_MaintContMCA.Artikel = S_Artikel.Artikel
                  and VST_MaintContMCA.offen   = yes
                no-lock no-error.

              if available VST_MaintContMCA then

                adm.method.cls.DMCMessageSvc:prpoInstance:showError
                  ('v_trg00021':U,
                   S_Artikel.Artikel).

            &ENDIF /* VS_WVERT module */

          end. /* if        can-do({&pa_M_PTList_StorageArea},gcItemTypeOldPart) */

        &ENDIF /* VS */

      end. /* if Old_S_Artikel.ArtikelArt <> S_Artikel.ArtikelArt .. */

    &ENDIF /* E_, V_*/

    &IF LOOKUP("MD","{&PA-MODULE}") > 0 &THEN

      /* set cust ref order based MRP (DispoArt) in all MRP Settings          */
      /* and default values on changing CRO or part categrory                 */
      /* MRP of CRO Parts or external operations (category 40) or configured  */
      /* parts (category 4) are custom ref order based                        */

      if       Old_S_Artikel.KommLager  <> S_Artikel.Kommlager
           and S_Artikel.Kommlager      <> 0
        or     Old_S_Artikel.ArtikelArt <> S_Artikel.ArtikelArt
           and (   S_Artikel.ArtikelArt  = {&pa_S_PT_OutsourcedOperation}
                or S_Artikel.ArtikelArt  = {&pa_S_PT_ConfiguredPart} ) then

        for each MD_Artikel
          where MD_Artikel.Firma   = {firma/mlartort.fir S_Firma.Firma}
            and MD_Artikel.Artikel = S_Artikel.Artikel
          exclusive-lock
          on error undo, throw:

          /* set cust ref order based MRP                                     */

          assign
            giOldMRPCategory    = MD_Artikel.DispoArt
            MD_Artikel.DispoArt = (if   (   S_Artikel.Kommlager  = 2
                                         and MD_Artikel.DispoArt <> 0
                                         and MD_Artikel.DispoArt <> 3 )
                                      or S_Artikel.ArtikelArt = {&pa_S_PT_OutsourcedOperation}                                         
                                      or S_Artikel.ArtikelArt = {&pa_S_PT_ConfiguredPart} then
                                     3
                                   else
                                     MD_Artikel.DispoArt)
            .

          /* Horizon is set to maximum value. Set Time unit to calendary      */
          /* days                                                             */

          /* enforce new values (CRO Part)                                    */
          if    MD_Artikel.DispoArt  = 3
            and S_Artikel.Kommlager <> 0 then

            assign
              MD_Artikel.Horizont        = {&pa_MD_Dispohorizont_Komm}
              MD_Artikel.HorizontEinheit = '4':U
              .

          else
            /* set max value if changed to cust ref order based               */
            /* but only on changing since the record may be a copied one      */
            if    MD_Artikel.Horizont       = 0
              and MD_Artikel.DispoArt       = 3
              and giOldMRPCategory         <> MD_Artikel.DispoArt
              and (   S_Artikel.ArtikelArt      = {&pa_S_PT_OutsourcedOperation}
                   or S_Artikel.ArtikelArt      = {&pa_S_PT_ConfiguredPart})
              and Old_S_Artikel.ArtikelArt <> S_Artikel.ArtikelArt then

              assign
                MD_Artikel.Horizont        = {&pa_MD_Dispohorizont_Komm}
                MD_Artikel.HorizontEinheit = '4':U
                .

        end. /* each MD_Artikel */

    &ENDIF /* MD */

    &IF LOOKUP("MP","{&PA-MODULE}") > 0  &THEN

      /*----------------------------------------------------------------------*/
      /* Ermittlung Gesamtgewicht je Lagerplatz/Teil                          */
      /*----------------------------------------------------------------------*/

      if (S_Artikel.LagerGewicht <> Old_S_Artikel.LagerGewicht) then
        run ProcessTotalWeightofPart(S_Artikel.Artikel).

    &ENDIF

    /*------------------------------------------------------------------------*/
    /* Prüfungen bei Veränderungen der Chargenart                             */
    /*------------------------------------------------------------------------*/

    &IF    LOOKUP("MC","{&PA-MODULE}") > 0
       AND LOOKUP("ML","{&PA-MODULE}") > 0 &THEN

      if    S_Artikel.Chargenart        <> OLD_S_Artikel.Chargenart
        and (   OLD_S_Artikel.Chargenart = '':U
             or S_Artikel.Chargenart     = '':U) then
      do:

        /* Deaktivieren der Chargenverwaltung nur zulässig,                   */
        /* wenn keine Chargen vorhanden sind                                  */

        if S_Artikel.Chargenart = '':U then
        do:

          if    not can-do({&pa_S_PTList_VariantPartTypes},gcItemTypeNewPart)
            and can-find (first MC_Charge
                            where MC_Charge.Firma   = {firma/mccharge.fir S_Firma.Firma}
                              and MC_Charge.Artikel = S_Artikel.Artikel) then

            adm.method.cls.DMCMessageSvc:prpoInstance:showError('mstrg00001':U,
                                                                S_Artikel.Artikel).

        end. /* if S_Artikel.Chargenart = '':U */

        /* Aktvieren der Chargen nur, wenn keine Bestände */
        else
        do:

          /* Lagerorte */

          if mawi.lager.cls.MLCOnHandInvSvc:prpoInstance:lIsOnHandAvailable
               (S_Artikel.Artikel,
                '':U,
                '':U,
                '':U) then
            adm.method.cls.DMCMessageSvc:prpoInstance:showError
              ('mstrg00002':U,
               S_Artikel.Artikel).

          /* Reservierungen auf Lagerortebene */

          if mawi.base.cls.MMCReservationSvc:prpoInstance:lIsResOnHandAvailable
               (S_Artikel.S_Artikel_Obj, /* object ID of the part                           */
                '':U,                    /* variant (Part)                                  */
                '':U,                    /* object ID of the lot                            */
                '':U,                    /* object ID of the CRO                            */
                '?':U,                   /* object ID of Quantity Unit                      */
                ?,                       /* Sales Unit Factor                               */
                '':U) then               /* object ID of MRP-Unit, value-group, storagearea */
            adm.method.cls.DMCMessageSvc:prpoInstance:showError
              ('mstrg00009':U,
               S_Artikel.Artikel).

          /* informatorische Bestände */

          if mawi.dispo.cls.MDCMRPOnHandSvc:prpoInstance:lSchedOnHandIsAvailablePart
               (S_Artikel.S_Artikel_Obj,
                '':U) then
            adm.method.cls.DMCMessageSvc:prpoInstance:showError
              ('mstrg00004':U,
               S_Artikel.Artikel).

        end. /* else do */

      end. /* if S_Artikel.Chargenart <> Old_S_Artikel.Chargenart */

      /* -------------------------------------------------------------------- */
      /* Wechseln der Chargenart                                              */
      /* -------------------------------------------------------------------- */

      if Old_S_Artikel.Chargenart <> S_Artikel.Chargenart then
      do:

        &IF LOOKUP("E_","{&PA-MODULE}") > 0 &THEN

          /* Änderung Chargenart (Rücknahme ist bereits geprüft)              */

          /* offene Wareneingänge                                             */

          if    Old_S_Artikel.Chargenart > '':U
            and can-find(first E_WE_Pos
                           where E_WE_Pos.Firma     = {firma/ebelkop.fir S_Firma.Firma}
                             and E_WE_Pos.Artikel   = S_Artikel.Artikel
                             and E_WE_Pos.berechnet = no
                           use-index Art) then
              adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
                ('mctrg00010':U,
                 S_Artikel.Artikel).

          /* ---------------------------------------------------------------- */
          /* Aktivieren Chargenpflicht, Prüfung gegen ...                     */
          /*                                                                  */
          /* Wareneingang, Rücklieferungen, Belastungsanzeigen                */
          /* Rechnungskontrollbelege, offene Wareneingänge mit                */
          /* Beistellungen                                                    */
          /* ---------------------------------------------------------------- */

          if Old_S_Artikel.Chargenart = '':U then
          do:

            /* Wareneingänge */

            if can-find (first E_WE_Pos
                           where E_WE_Pos.Firma     = {firma/ebelkop.fir S_Firma.Firma}
                             and E_WE_Pos.Artikel   = S_Artikel.Artikel
                             and E_WE_Pos.berechnet = no
                           use-index Art) then
              adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
                ('mctrg00011':U,
                 S_Artikel.Artikel).

            /* Rücklieferungen */

            if can-find (first E_BelegPos
                           where E_BelegPos.Firma    = {firma/ebelkop.fir S_Firma.Firma}
                             and E_BelegPos.BelegArt = 'ERL':U
                             and E_BelegPos.offen    = yes
                             and E_BelegPos.Artikel  = S_Artikel.Artikel
                           use-index ArtTermin) then
              adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
                ('mctrg00015':U,
                 S_Artikel.Artikel).

            /* Belastungsanzeigen */

            if can-find (first E_BelegPos
                           where E_BelegPos.Firma    = {firma/ebelkop.fir S_Firma.Firma}
                             and E_BelegPos.BelegArt = 'EBA':U
                             and E_BelegPos.offen    = yes
                             and E_BelegPos.Artikel  = S_Artikel.Artikel
                           use-index ArtTermin) then
              adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
                ('mctrg00012':U,
                 S_Artikel.Artikel).

            /* Beistellteil offene Wareneingänge */

            if can-find (first E_WE_PosBei
                           where E_WE_PosBei.Firma           = {firma/ebelkop.fir S_Firma.Firma}
                             and E_WE_PosBei.BeistellArtikel = S_Artikel.Artikel
                             and can-find(E_WE_Pos
                                            where E_WE_Pos.Firma       = E_WE_PosBei.Firma
                                              and E_WE_Pos.ReferenzNr  = E_WE_PosBei.ReferenzNr
                                              and E_WE_Pos.PositionsNr = E_WE_PosBei.PositionsNr
                                              and E_WE_Pos.berechnet   = no)) then
              adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
                ('mctrg00016':U,
                 S_Artikel.Artikel).

            &IF LOOKUP("ER","{&PA-MODULE}") > 0 &THEN

              /* Rechnungskontrollbelege */

              find first ER_BelegPos
                where ER_BelegPos.Firma    = {firma/ebelkop.fir S_Firma.Firma}
                  and ER_BelegPos.BelegArt = 'ERR':U
                  and ER_BelegPos.verbucht = no
                  and ER_BelegPos.Artikel  = S_Artikel.Artikel
                no-lock no-error.

              if not available ER_BelegPos then

                /* Rechnungskontrollbelege (Anzahlung) */

                find first ER_BelegPos
                  where ER_BelegPos.Firma    = {firma/ebelkop.fir S_Firma.Firma}
                    and ER_BelegPos.BelegArt = 'ERZ':U
                    and ER_BelegPos.verbucht = no
                    and ER_BelegPos.Artikel  = S_Artikel.Artikel
                  no-lock no-error.

              if available ER_BelegPos then
                adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
                  ('mctrg00012':U,
                   S_Artikel.Artikel).

            &ENDIF /* ER */

          end. /* if Old_S_Artikel.Chargenart = '':U */

        &ENDIF /* E_ */

      end. /* if Old_S_Artikel.Chargenart <> S_Artikel.Chargenart */

    &ENDIF  /* MC */

    /*------------------------------------------------------------------------*/
    /* Prüfungen bei Veränderungen der Seriennummernart                       */
    /*------------------------------------------------------------------------*/

    &IF LOOKUP("MS","{&PA-MODULE}") > 0 &THEN

      run pruefeSNRArt.

      /*----------------------------------------------------------------------*/
      /* Für Produktakte auf Lagerfähigkeit prüfen                            */
      /*----------------------------------------------------------------------*/

      &IF LOOKUP("MS_PROD","{&PA-OPTIONEN}") > 0 &THEN

        if    lookup({&pa_S_StkZeilenArt_Produktakte},S_Artikel.StkZeilenArt) > 0
          and not can-do({&pa_M_PTList_StorageArea},gcItemTypeNewPart) then
          adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
            ('S_Artikel':U,
             'Artikelart':U,
             'mspro000001':U,
             S_Artikel.Artikel).

        /* Product file only yes if serial numbers required                   */

        if    S_Artikel.Produktakte = yes
          and S_Artikel.SNRArt      = '':U then

          S_Artikel.Produktakte = no.

      &ENDIF

    &ENDIF  /* Seriennummernprüfung */

    /*------------------------------------------------------------------------*/
    /* Teile mit bestimmten Teilearten dürfen nicht im Lager geführt sein     */
    /*------------------------------------------------------------------------*/

    &IF LOOKUP("ML","{&PA-MODULE}") > 0 &THEN

      /* für ein Set zuvor Lagerortbeziehungen lösen */

      &IF LOOKUP("M_STUELI","{&PA-OPTIONEN}") > 0 &THEN

        if    can-do({&pa_S_PTList_Set}, gcItemTypeNewPart)
          and not can-do({&pa_S_PTList_Set}, gcItemTypeOldPart)
          and can-find(first MLM_StorPartData
                         where MLM_StorPartData.Company = S_Firma.Firma
                           and MLM_StorPartData.Part    = S_Artikel.Artikel) then

          adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
            ('S_Artikel':U,
             'Artikelart':U,
             's_trg00028':U,
             string(S_Artikel.ArtikelArt),
             S_Artikel.Artikel).

      &ENDIF

      if    (    not can-do({&pa_M_PTList_StorageArea},gcItemTypeNewPart)
             and S_Artikel.Artikelart <> OLD_S_Artikel.Artikelart)
        and can-find(first MLM_StorPartData
                       where MLM_StorPartData.Company = S_Firma.Firma
                         and MLM_StorPartData.Part    = S_Artikel.Artikel
                       use-index main) then

        adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
          ('S_Artikel':U,
           'Artikelart':U,
           'mstrg00003':U,
           S_Artikel.Artikel).

      /*----------------------------------------------------------------------*/
      /* Umschalten Kommlager von 1,2 auf 0 (kein Kommlager) abweisen,        */
      /* wenn noch Kommissionslagerbestände oder Lagerplatzbestände           */
      /* einer Kommission vorhanden sind.                                     */
      /* Anmerkung: Dies gilt nicht für Kommissionen zu Fremdbeständen        */
      /*----------------------------------------------------------------------*/

      if   (   Old_S_Artikel.Kommlager = 1
            or Old_S_Artikel.Kommlager = 2)
        and S_Artikel.Kommlager = 0
        and mawi.lager.cls.MLCOnHandInvSvc:prpoInstance:lIsCROOnHandAvailable
              (S_Artikel.Artikel,
               '':U,
               '':U) then
      do:

        dPhysicalOnHand = mawi.lager.cls.MLCOnHandInvSvc:prpoInstance:dOnHandTotal(S_Artikel.Artikel,
                                                                                   '':U,
                                                                                   ?,
                                                                                   ?,
                                                                                   ?,
                                                                                   ?).
        if dPhysicalOnHand[{&pa_ML_CROInventoryTotal}] <> 0 then

          adm.method.cls.DMCMessageSvc:prpoInstance:showError
            ('mltrg00059':U,
             S_Artikel.Artikel).

      end. /* if ( Old_S_Artikel.Kommlager = 1... */

      /*----------------------------------------------------------------------*/
      /* bei Kommlager zwingend keine freien Bestände                         */
      /*----------------------------------------------------------------------*/

      if    Old_S_Artikel.Kommlager <> 2
        and S_Artikel.Kommlager   = 2
        and mawi.lager.cls.MLCOnHandInvSvc:prpoInstance:lIsFreeOnHandAvailable
              (S_Artikel.Artikel,
               '':U,
               '':U) then
        adm.method.cls.DMCMessageSvc:prpoInstance:showError
          ('mltrg00062':U,
           S_Artikel.Artikel).

      /*----------------------------------------------------------------------*/
      /* Änderung auf Kommissionslagerung                                     */
      /*----------------------------------------------------------------------*/

      if Old_S_Artikel.Kommlager < S_Artikel.Kommlager then
      do:

        /*--------------------------------------------------------------------*/
        /* Der Artikel darf nur dann auf Kommissionslager möglich bzw. zwin-  */
        /* gend gestellt werden, wenn keine nicht gemeldete Lagerbewegung für */
        /* ein Fremdlager oder keine noch nicht übernommene Entnahmezeile zum */
        /* Artikel existiert.                                                 */
        /*--------------------------------------------------------------------*/

        if   can-find(first MLL_Movements
                        where MLL_Movements.Company           = S_Firma.Firma
                          and MLL_Movements.Part              = S_Artikel.Artikel
                          and MLL_Movements.StatisticsWritten = no
                          and can-find(ML_Ort
                                         where ML_Ort.Firma       = {firma/mlort.fir S_Firma.Firma}
                                           and ML_Ort.Lagerort    = MLL_Movements.Storagearea
                                           and ML_Ort.StorageType = {&pa_ML_ExternalOwnedStorArea}))
           or can-find(first ML_EntnahmeZeile
                         where ML_EntnahmeZeile.Firma   = {firma/mlentna.fir S_Firma.Firma}
                           and ML_EntnahmeZeile.offen   = yes
                           and ML_EntnahmeZeile.Artikel = S_Artikel.Artikel) then

          adm.method.cls.DMCMessageSvc:prpoInstance:showError
            ('mltrg00068':U,
             S_Artikel.Artikel).

        &IF LOOKUP("MD","{&PA-MODULE}") > 0 &THEN

          /*------------------------------------------------------------------*/
          /* Änderung Sicherheitsbestand auf 0, wenn Teil kommissionsgesteuert*/
          /* disponiert wird.                                                 */
          /*------------------------------------------------------------------*/

          for each MLM_StorPartData
            where MLM_StorPartData.Company      = S_Artikel.Firma
              and MLM_StorPartData.Part         = S_Artikel.Artikel
              and MLM_StorPartData.SafetyStock <> 0
            use-index MRPArea
            exclusive-lock
            on error undo, throw:

            find bML_Lagergruppe
              where bML_Lagergruppe.ML_Lagergruppe_Obj = MLM_StorPartData.ML_Lagergruppe_Obj
              no-lock no-error.

            if    available bML_Lagergruppe
              and can-find(MD_Artikel
                    where MD_Artikel.Firma       = {firma/mlartort.fir S_Artikel.Firma}
                      and MD_Artikel.Artikel     = MLM_StorPartData.Part
                      and MD_Artikel.Lagergruppe = bML_Lagergruppe.Lagergruppe
                      and (   MD_Artikel.DispoArt      = 3
                           or (    S_Artikel.KommLager = 2
                               and MD_Artikel.DispoArt = 0))) then

              MLM_StorPartData.SafetyStock = 0.

          end. /* for each MLM_StorPartData */

        &ENDIF /* MD */

      end. /* if Old_S_Artikel.Kommlager = 0 and S_Artikel.Kommlager  > 0 */

      /* Clear MLA_PartValue in Case of Kommlager-Change  */

      if Old_S_Artikel.KommLager <> S_Artikel.Kommlager
        and S_Artikel.Kommlager   = 0  then    

        mawi.lager.cls.MLCInventoryValSvc:prpoInstance:DeletePartValueForCRO(buffer S_Artikel). 


      /*----------------------------------------------------------------------*/
      /* Archivierung                                                         */
      /*----------------------------------------------------------------------*/

      if S_Artikel.archiviert <> OLD_S_Artikel.archiviert then
      do:

        if S_Artikel.archiviert = yes then
        do:

          &IF lookup("M_PACK","{&PA-OPTIONEN}") > 0 &THEN

            if can-do ({&pa_M_PTList_PackagingReturnable}, string(S_Artikel.Artikelart)) then

              for each bM_PackOrt
                fields(Bestand Lagerort)
                where bM_PackOrt.Firma      = {firma/mlartort.fir S_Firma.Firma}
                  and bM_PackOrt.Packmittel = S_Artikel.Artikel
                no-lock
                on error undo, throw:

                if bM_PackOrt.Bestand <> 0 then

                  adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
                    ('M_PackOrt':U,
                     'LagerOrt':U,
                     'mstrg00005':U,
                     S_Artikel.Artikel).

                  /* Message: Für das Teil '&1' sind nicht alle Bestände auf 0!  */

              end. /* for each bM_PackOrt ... */

            else
            do:

          &ENDIF /* M_Pack */

          if mawi.lager.cls.MLCOnHandInvSvc:prpoInstance:lIsOnHandAvailable
               (S_Artikel.Artikel,
                '':U,
                '':U,
                '':U) = yes then
            adm.method.cls.DMCMessageSvc:prpoInstance:showError
              ('mstrg00005':U,
               S_Artikel.Artikel).

          for each MLM_StorPartData
            where MLM_StorPartData.Company  = S_Firma.Firma
              and MLM_StorPartData.Part     = S_Artikel.Artikel
              and MLM_StorPartData.Archived = no
            use-index MRPArea
            exclusive-lock
            on error  undo, throw:

            /*----------------------------------------------------------------*/
            /* letzte Inventur muss abgeschlossen sein                        */
            /*----------------------------------------------------------------*/

            if lcheck__Inventur({firma/mlartort.fir S_Firma.Firma},
                                S_Artikel.Artikel,
                                MLM_StorPartData.Storagearea) then
              adm.method.cls.DMCMessageSvc:prpoInstance:showError
                ('mltrg00145':U,
                 S_Artikel.Artikel).

          end.  /* for each MLM_StorPartData */

          /* informatorische Bestände */

          if mawi.dispo.cls.MDCMRPOnHandSvc:prpoInstance:lSchedOnHandIsAvailablePart
              (S_Artikel.S_Artikel_Obj,
               '':U) then
            adm.method.cls.DMCMessageSvc:prpoInstance:showError
              ('mstrg00006':U,
               S_Artikel.Artikel).

          /* Reservierungen auf Lagerortebene */

          if mawi.base.cls.MMCReservationSvc:prpoInstance:lIsResOnHandAvailable
               (S_Artikel.S_Artikel_Obj, /* object ID of the part                           */
                '':U,                    /* variant (Part)                                  */
                '':U,                    /* object ID of the lot                            */
                '':U,                    /* object ID of the CRO                            */
                '?':U,                   /* object ID of Quantity Unit                      */
                ?,                       /* Sales Unit Factor                               */
                '':U) then               /* object ID of MRP-Unit, value-group, storagearea */
            adm.method.cls.DMCMessageSvc:prpoInstance:showError
              ('mstrg00005':U,
               S_Artikel.Artikel).

          for each MLM_StorPartData
            where MLM_StorPartData.Company  = S_Firma.Firma
              and MLM_StorPartData.Part     = S_Artikel.Artikel
              and MLM_StorPartData.Archived = no
            use-index MRPArea
            exclusive-lock
            on error  undo, throw:

            MLM_StorPartData.Archived = yes.

          end.

          &IF lookup("M_PACK","{&PA-OPTIONEN}") > 0 &THEN
            end. /* else (if can-do ({&pa_M_PTList_PackagingReturnable}, string(S_Artikel.Artikelart)) then) */
          &ENDIF /* M_Pack */

          &IF lookup("P_":U,"{&PA-MODULE}":U) > 0 &THEN

            for each P_ZeichnungArtikel
              where P_ZeichnungArtikel.Firma    = {firma/pps.fir S_Firma.Firma}
                and P_ZeichnungArtikel.Archived = no
                and P_ZeichnungArtikel.Artikel  = S_Artikel.Artikel
              use-index PartArch
              exclusive-lock
              by P_ZeichnungArtikel.Hauptzeichnung
              on error undo, throw:

              &IF LOOKUP("E_":U,"{&PA-MODULE}":U) > 0 &THEN

                /* If the part is archived, then corresponding                */
                /* part-supplier-relationships are archived as well by        */
                /* this trigger some lines above.                             */

                if    glDelSuppParts = no 
                  and can-find (first PMM_Drawing
                        where PMM_Drawing.Company        = {firma/pps.fir S_Firma.Firma}
                          and PMM_Drawing.PMM_Drawing_ID = P_ZeichnungArtikel.Zeichnung
                          and can-find (first E_ArtLief
                                where E_ArtLief.Firma   = {firma/e_artli.fir S_Firma.Firma}
                                  and E_ArtLief.Artikel = P_ZeichnungArtikel.Artikel
                                  and can-find (first E_ArtLiefZeich      
                                        where E_ArtLiefZeich.Firma           = {firma/e_artli.fir S_Firma.Firma}
                                          and E_ArtLiefZeich.Artikel         = E_ArtLief.Artikel
                                          and E_ArtLiefZeich.Lieferant       = E_ArtLief.Lieferant
                                          and E_ArtLiefZeich.PMM_Drawing_Obj = PMM_Drawing.PMM_Drawing_Obj))) then

                  glDelSuppParts = adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
                                    ('pmdrw00012':U,
                                     S_Artikel.Artikel).

              &ENDIF

              pps.base.cls.PMCDrawingSvc:prpoInstance:archivePartDrawingRelation
               (P_ZeichnungArtikel.P_ZeichnungArtikel_Obj,
                glDelSuppParts).

            end. /* for each P_ZeichnungArtikel */

          &ENDIF

        end. /* if S_Artikel.archiviert = yes */
        else
        do:

          for each MLM_StorPartData
            where MLM_StorPartData.Company  = S_Firma.Firma
              and MLM_StorPartData.Part     = S_Artikel.Artikel
              and MLM_StorPartData.Archived = yes
              and not can-find (ML_Ort
                                  where ML_Ort.ML_Ort_Obj = MLM_StorPartData.ML_Ort_Obj
                                    and ML_Ort.Archived   = yes)
            use-index MRPArea
            exclusive-lock
            on error  undo, throw:

            MLM_StorPartData.Archived = no.

          end. /*  for each MLM_StorPartData */

        end.

      end. /* archiviert */

    &ENDIF  /* Modul ML */

    /*------------------------------------------------------------------------*/
    /* Für Lagerplatzverwaltung MP_Artikel anlegen                            */
    /*------------------------------------------------------------------------*/

    &IF LOOKUP("MP","{&PA-MODULE}") > 0 &THEN

      if not can-find(MP_Artikel
                        where MP_Artikel.Firma   = {firma/sartikel.fir S_Firma.Firma}
                          and MP_Artikel.Artikel = S_Artikel.Artikel) then
      do:

        create MP_Artikel.
        assign
          MP_Artikel.Firma   = {firma/sartikel.fir S_Firma.Firma}
          MP_Artikel.Artikel = S_Artikel.Artikel
          .
        validate MP_Artikel.

      end.

    &ENDIF   /* Modul MP  */

    if    Old_S_Artikel.Kommlager = 0
      and S_Artikel.Kommlager     = 1
      and can-find (first MMT_MRPAccount
                      where MMT_MRPAccount.Company   = S_Firma.Firma
                        and MMT_MRPAccount.Artikel   = S_Artikel.Artikel
                        and MMT_MRPAccount.CRONumber > '':U) then

      adm.method.cls.DMCMessageSvc:prpoInstance:showError
        ('m_trg00317':U,
         S_Artikel.Artikel).

    /* CRO warehouse is mandatory  */

    if    Old_S_Artikel.Kommlager <> 2
      and S_Artikel.Kommlager      = 2 then
    do:

      /* no demands or coverages without CRO number                           */

      if can-find (first MMT_MRPAccount
                     where MMT_MRPAccount.Company   = S_Firma.Firma
                       and MMT_MRPAccount.Artikel   = S_Artikel.Artikel
                       and MMT_MRPAccount.CRONumber = '':U) then

         adm.method.cls.DMCMessageSvc:prpoInstance:showError
           ('m_trg00025':U,
            S_Artikel.Artikel).

      /* no suggestions for transfer                                          */

      glArtvar = {stamm/incl/s__var00.if
                   &Tabelle = "S_Artikel"}.

      for each MLM_StorPartData
        where MLM_StorPartData.Company    = S_Firma.Firma
          and MLM_StorPartData.Part       = S_Artikel.Artikel
          and (   MLM_StorPartData.ArtVar > '':U
               or not glArtvar)
        exclusive-lock
        on error  undo, throw:

        assign
          MLM_StorPartData.WHTransferSuggestions = no
          MLM_StorPartData.TransferQuantity      = 0
          MLM_StorPartData.TriggerPoint          = 0
          .

      end. /* for each MLM_StorPartData */

    end. /*  if Old_S_Artikel.Kommlager <> 2 */

  &ENDIF  /* M_ Modul MaWi  */

  /*--------------------------------------------------------------------------*/
  /* Modul PPS                                                                */
  /*--------------------------------------------------------------------------*/

  &IF LOOKUP("P_","{&PA-MODULE}") > 0  &THEN

    /*------------------------------------------------------------------------*/
    /* Geänderte Teileart gültig ?                                            */
    /*------------------------------------------------------------------------*/

    if    S_Artikel.ArtikelArt <> OLD_S_Artikel.ArtikelArt
      and (   lookup(gcItemTypeNewPart,{&pa_P_PTList_BOMPossible}) = 0
           or lookup (gcItemTypeNewPart,{&pa_S_PTList_OnceOnlyPartTypes}) > 0)
      and can-find(first PMM_BomHeadMaster
                     where PMM_BomHeadMaster.Company   = {firma/pps.fir S_Firma.Firma}
                       and PMM_BomHeadMaster.Part      = S_Artikel.Artikel) then
    do:

      cTemp = ({fnarg
                 pa_cStCchPartTypeDesc
                 "S_Artikel.ArtikelArt,
                  {&pa_DefaultSprache},
                  {&pa_CchDesc}"}).

      adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
        ('S_Artikel':U,
         'Artikelart':U,
         'p_trg00102':U,
          S_Artikel.Artikel,
          string(S_Artikel.ArtikelArt),
          cTemp).

    end. /* if S_Artikel.ArtikelArt <> OLD_S_Artikel.ArtikelArt */

    /* change from parttype in pa_M_PTList_StorageArea to parttype not in pa_M_PTList_StorageArea */
    if    S_Artikel.ArtikelArt <> Old_S_Artikel.ArtikelArt
      and    can-do({&pa_M_PTList_StorageArea},string(Old_S_Artikel.ArtikelArt))
          <> can-do({&pa_M_PTList_StorageArea},string(S_Artikel.ArtikelArt))
      and (  can-find(first PP_Auftrag
                        where PP_Auftrag.Firma          = {firma/ppauftra.fir S_Firma.Firma}
                          and PP_Auftrag.archived       = no
                          and PP_Auftrag.Auftragskennung = 'F':U
                          and PP_Auftrag.Artikel        = S_Artikel.Artikel)
           or can-find (first PPT_OrderPart
                          where PPT_OrderPart.Company = {firma/ppauftra.fir S_Firma.Firma}
                            and PPT_OrderPart.Part    = S_Artikel.Artikel
                            and can-find (first PP_Auftrag
                                            where PP_Auftrag.PP_Auftrag_Obj = PPT_OrderPart.Owning_Obj
                                              and PP_Auftrag.archived       = no))) then
      adm.method.cls.DMCMessageSvc:prpoInstance:showError
        ('p_trg00211':U,
         S_Artikel.Artikel).

    /*------------------------------------------------------------------------*/
    /* Neue Teileart =8 (fiktive Baugruppe):                                  */
    /* - sind Prozesse vorhanden?                                             */
    /* - wird das Teil als Elektrostücklistenposition genutzt                 */
    /*------------------------------------------------------------------------*/

    if    S_Artikel.ArtikelArt <> OLD_S_Artikel.ArtikelArt
      and S_Artikel.ArtikelArt  = {&pa_S_PT_PhantomAssembly} then
    do:

      find last PMM_BomHead
        where PMM_BomHead.Company = {firma/pps.fir S_Firma.Firma}
          and PMM_BomHead.Part    = S_Artikel.Artikel
        no-lock no-error.

      if    available PMM_BomHead
        and can-find(first PMM_BomHeadRoutingRel
                       where PMM_BomHeadRoutingRel.PMM_BomHead_Obj = PMM_BomHead.PMM_BomHead_Obj) then
      do:

        cTemp = ({fnarg
                   pa_cStCchPartTypeDesc
                   "S_Artikel.ArtikelArt,
                    {&pa_DefaultSprache},
                    {&pa_CchDesc}"}).

        adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
          ('S_Artikel':U,
           'Artikelart':U,
           'p_trg00105':U,
           S_Artikel.Artikel,
           string(S_Artikel.ArtikelArt),
           cTemp).

      end. /* find last PMM_BomHead */

      if   can-find (first PMM_BomHead
                       where PMM_BomHead.Company   =  {firma/pps.fir S_Artikel.Firma}
                         and PMM_BomHead.Part      = S_Artikel.Artikel
                         and PMM_BomHead.ElectroBom)
        or can-find(first PMM_BomLine
                      where PMM_BomLine.Company   = {firma/pps.fir S_Artikel.Firma}
                        and PMM_BomLine.Part      = S_Artikel.Artikel
                        and PMM_BomLine.isElectroBomLine)
         or can-find(first PP_StkZeile
                       where PP_StkZeile.Firma   = {firma/ppauftra.fir S_Artikel.Firma}
                         and PP_StkZeile.Artikel = S_Artikel.Artikel
                         and PP_StkZeile.isElectroBomLine
                         and can-find (first PP_Auftrag
                                         where PP_Auftrag.Firma           = {firma/ppauftra.fir S_Firma.Firma}
                                           and PP_Auftrag.Auftrag         = PP_StkZeile.Auftrag
                                           and PP_Auftrag.nicht_erster    = no
                                           and PP_Auftrag.AuftragsStatus <> 'R':U
                                         use-index nicht_erster )) then

        adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger('S_Artikel':U,
                                                                     'Artikelart':U,
                                                                     'pmbom00008':U,
                                                                     S_Artikel.Artikel).

    end. /*  if    S_Artikel.ArtikelArt <> OLD_S_Artikel.ArtikelArt ... */

  &ENDIF  /* Modul PPS */

  &IF lookup("PP","{&PA-MODULE}") > 0 &THEN

    /*------------------------------------------------------------------------*/
    /* Neue Teileart =8 (fiktive Baugruppe), sind Unteraufträge vorhanden?    */
    /*------------------------------------------------------------------------*/

    if    S_Artikel.ArtikelArt <> OLD_S_Artikel.ArtikelArt
      and S_Artikel.ArtikelArt  = {&pa_S_PT_PhantomAssembly} then
    do:

      find first bPP_StkZeile
        where bPP_StkZeile.Firma   = {firma/ppauftra.fir S_Firma.Firma}
          and bPP_StkZeile.Artikel = S_Artikel.Artikel
          and can-find (first PP_Auftrag
                          where PP_Auftrag.Firma           = {firma/ppauftra.fir S_Firma.Firma}
                            and PP_Auftrag.Auftrag         = bPP_StkZeile.Auftrag
                            and PP_Auftrag.nicht_erster    = no
                            and PP_Auftrag.AuftragsStatus <> 'R':U
                          use-index nicht_erster  )
          and can-find (first PP_Auftrag
                          where PP_Auftrag.Firma           =  {firma/ppauftra.fir S_Firma.Firma}
                            and PP_Auftrag.Auftrag         = bPP_StkZeile.Auftrag
                            and PP_Auftrag.Artikel         = bPP_StkZeile.Artikel
                            and PP_Auftrag.ArtVar          = bPP_Stkzeile.ArtVar
                            and PP_Auftrag.BaugruppenFolge = bPP_StkZeile.Baugruppenfolge )
        no-lock no-error.

      if available bPP_StkZeile then

        adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger('S_Artikel':U,
                                                                     'Teileart':U,
                                                                     'pptrg00072':U,
                                                                     bPP_Stkzeile.Auftrag,
                                                                     string(bPP_StkZeile.RueckmeldeNr),
                                                                     S_Artikel.Artikel,
                                                                     string(S_Artikel.ArtikelArt),
                                                                     {fnarg
                                                                        pa_cStCchPartTypeDesc
                                                                        "S_Artikel.ArtikelArt,
                                                                         {&pa_DefaultSprache},
                                                                         {&pa_CchDesc}"}).

    end. /* if S_Artikel.ArtikelArt <> OLD_S_Artikel.ArtikelArt */

    /* Part type of a part with existing sub work orders can't be changed to  */
    /* a part type which will not be resolved                                 */

    assign
      lOldCanResolve =     OLD_S_Artikel.ArtikelArt < {&pa_S_PT_PurchasedProduct}
                       and not can-do('{&pa_S_PT_ConfiguredPart},{&pa_S_PT_VariantPart}':U,string(OLD_S_Artikel.ArtikelArt))
      lCanResolve    =     S_Artikel.ArtikelArt < {&pa_S_PT_PurchasedProduct}
                       and not can-do('{&pa_S_PT_ConfiguredPart},{&pa_S_PT_VariantPart}':U,string(S_Artikel.ArtikelArt))
      .

    if     lCanResolve  = no
       and lCanResolve <> lOldCanResolve
       and can-find (first PP_Auftrag
             where PP_Auftrag.Firma        = {firma/ppauftra.fir S_Firma.Firma}
               and PP_Auftrag.Artikel      = S_Artikel.Artikel 
               and PP_Auftrag.nicht_erster = yes) then

      adm.method.cls.DMCMessageSvc:prpoInstance:showError
        ('pptrg00077':U,
         S_Artikel.Artikel,
         string(S_Artikel.ArtikelArt)).

  &ENDIF /* PP */

  /*--------------------------------------------------------------------------*/
  /* Modul MaWi                                                               */
  /* Wenn das Teil archiviert werden soll, dann darf es in keiner             */
  /* Vertriebsstückliste noch verwendet werden.                               */
  /*--------------------------------------------------------------------------*/

  &IF LOOKUP("M_","{&PA-MODULE}") > 0  &THEN

    &IF LOOKUP("M_STUELI","{&PA-OPTIONEN}") > 0 &THEN

      if    S_Artikel.archiviert
        and S_Artikel.archiviert <> OLD_S_Artikel.archiviert
        and not can-do({&pa_S_PTList_Set}, gcItemTypeNewPart) then

        for each M_Stueli /* code checked by Warter 11.07.2022 */
          fields (Baugruppe)
          where M_Stueli.Firma   = S_Artikel.Firma
            and M_Stueli.Artikel = S_Artikel.Artikel
            and can-find(bS_Artikel_Set
                           where bS_Artikel_Set.Firma      = S_Artikel.Firma
                             and bS_Artikel_Set.archiviert = no
                             and bS_Artikel_Set.Artikel    = M_Stueli.Baugruppe)
          no-lock
          on error  undo, throw:

          adm.method.cls.DMCMessageSvc:prpoInstance:showError
            ('m_trg00290':U,
             S_Artikel.Artikel).

        end.

      if    S_Artikel.archiviert     = no
        and S_Artikel.archiviert <> OLD_S_Artikel.archiviert
        and can-do({&pa_S_PTList_Set}, gcItemTypeNewPart) then

        for each M_Stueli
          fields (Artikel)
          where M_Stueli.Firma     = S_Artikel.Firma
            and M_Stueli.Baugruppe = S_Artikel.Artikel
            and can-find(bS_Artikel_Set
                           where bS_Artikel_Set.Firma      = S_Artikel.Firma
                             and bS_Artikel_Set.archiviert = yes
                             and bS_Artikel_Set.Artikel    = M_Stueli.Artikel)
          no-lock
          on error  undo, throw:

          adm.method.cls.DMCMessageSvc:prpoInstance:showError
            ('m_set00001':U,
             S_Artikel.Artikel).

        end.

    &ENDIF

    &IF LOOKUP("M_APS","{&PA-OPTIONEN}") > 0 &THEN

      if    OLD_S_Artikel.Prioritaet <> S_Artikel.Prioritaet
        and not can-find(M_Prioritaet
                           where M_Prioritaet.Firma = {firma/m_prior.fir S_Artikel.Firma}
                             and M_Prioritaet.Prioritaet = S_Artikel.Prioritaet) then
        adm.method.cls.DMCMessageSvc:prpoInstance:showError
          ('m_pri00001':U,
           string(S_Artikel.Prioritaet)).

    &ENDIF
  &ENDIF

  /*--------------------------------------------------------------------------*/
  /* Modul Vertrieb                                                           */
  /*--------------------------------------------------------------------------*/

  &IF LOOKUP("V_","{&PA-MODULE}") > 0 &THEN

    /* Intrahandel -----------------------------------------------------------*/

    &IF LOOKUP("VF_INTRA","{&PA-OPTIONEN}") > 0 &THEN

      if stamm.base.cls.SBCBusinessCategorySvc:prpoInstance:lHasCompanyIntraStatSales(today) then

        case gcLocalization:

          {&{&PA-XBasisName}_C_Intra}
          {&{&PA-XBasisName}_U_Intra}
          {&{&PA-XBasisName}_Q_Intra}
          {&{&PA-XBasisName}_Intra}
          {&{&PA-XBasisName}_Y_Intra}

          otherwise
          do:

            stamm.base.cls.SBCBusinessCategorySvc:prpoInstance:Regions
              (       S_Artikel.Ursprungsland,
                      (if      S_Artikel.Ursprungsland = '':U then
                         ?
                       else if S_Artikel.Ursprungsland <> gbS_Firma.Staat then
                         yes
                       else
                         no),
                      today,   
               output gcListOfStateKeys,
               output gcListOfStateDesc).

            if not can-do(gcListOfStateKeys,string(S_Artikel.Bundesland)) then
              adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
                ('S_Artikel':U,
                 'Bundesland':U,
                 's_trg04071':U,
                 S_Artikel.Artikel,
                 string(S_Artikel.Bundesland),
                 S_Artikel.Ursprungsland).

          end. /* otherwise */

        end case. /* gcLocalization */

    &ENDIF  /* &IF lookup("VF_INTRA":U,"{&PA-OPTIONEN}":U) > 0 */

  &ENDIF  /* Modul Vertrieb */

  &IF LOOKUP("RM","{&PA-MODULE}") > 0 &THEN

    if   Old_S_Artikel.ArtikelGruppe <> S_Artikel.ArtikelGruppe
      or Old_S_Artikel.Sparte        <> S_Artikel.Sparte then
      ertr.base.cls.RMCMasterFilesSvc:prpoInstance:SynchronizeIncDriverRollupStructure
        (S_Firma.Firma,
         'Part':U,
         S_Artikel.S_Artikel_Obj).

  &ENDIF

end. /* for each S_Firma */

/*----------------------------------------------------------------------------*/
/* Vertriebsstückliste (SET) -> Teileart 45                                   */
/*----------------------------------------------------------------------------*/

&IF    LOOKUP("M_","{&PA-MODULE}")         > 0
   AND LOOKUP("M_STUELI","{&PA-OPTIONEN}") > 0 &THEN

  if    can-do({&pa_S_PTList_Set}, gcItemTypeNewPart)
     or (    can-do({&pa_S_PTList_Set}, gcItemTypeOldPart)
         and not can-do({&pa_S_PTList_Set}, gcItemTypeNewPart)) then

     run write-SET.

&ENDIF

/*----------------------------------------------------------------------------*/
/* Teil im WEB-Shop                                                           */
/*----------------------------------------------------------------------------*/

&IF LOOKUP("WS","{&PA-MODULE}") > 0  &THEN

  if   OLD_S_Artikel.WEBShop                         <> S_Artikel.WEBShop
    or (    S_Artikel.WEBShop                         > 0
        and (   OLD_S_Artikel.SBM_ValueFlowGroup_Obj <> S_Artikel.SBM_ValueFlowGroup_Obj
             or OLD_S_Artikel.WBZ                    <> S_Artikel.WBZ
             or OLD_S_Artikel.WBZ_Lieferant          <> S_Artikel.WBZ_Lieferant
             or OLD_S_Artikel.ArtikelArt             <> S_Artikel.ArtikelArt
             or OLD_S_Artikel.ArtVarTyp              <> S_Artikel.ArtVarTyp
             or OLD_S_Artikel.archiviert             <> S_Artikel.archiviert
             or OLD_S_Artikel.Preiseinheit           <> S_Artikel.Preiseinheit
             or OLD_S_Artikel.Lagergewicht           <> S_Artikel.Lagergewicht)) then

    run WEB-Shop.

&ENDIF

/*----------------------------------------------------------------------------*/
/* Prüfe EAN-Nummern                                                          */
/*----------------------------------------------------------------------------*/

if   Old_S_Artikel.LagerME    <> S_Artikel.LagerME
  or Old_S_Artikel.ArtikelArt <> S_Artikel.ArtikelArt then

  run pruefeEAN.

&IF LOOKUP("M_","{&PA-MODULE}") > 0  &THEN

  /*--------------------------------------------------------------------------*/
  /* Packmittel/Ladungsträger -> Teileart 70,71,75,76                         */
  /*--------------------------------------------------------------------------*/

  &IF LOOKUP("M_PACK","{&PA-OPTIONEN}") > 0 &THEN

    if   can-do({&pa_M_PTList_Packaging},gcItemTypeNewPart)
      or (    can-do({&pa_M_PTList_Packaging},gcItemTypeOldPart)
          and not can-do({&pa_M_PTList_Packaging},gcItemTypeNewPart)) then

      run write-Packmittel.

  &ENDIF

&ENDIF

/* Check Part Types 60, 61, 62 and 63 */

if     can-do({&pa_S_PList_ValuePart},string(S_Artikel.ArtikelArt))
   and (   S_Artikel.Chargenart > '':U
        or S_Artikel.SNRArt     > '':U
        or S_Artikel.ArtVarTyp  > 0
        or S_Artikel.Webshop    > 0
        or S_Artikel.Kommlager  > 0) then

  adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
    ('S_Artikel':U,
     'Artikelart':U,
     'vsser00056':U,
     S_Artikel.Artikel,
     string(S_Artikel.Artikelart)).

/* Bei Wechsel der Teileart ist sind die Verpackungsvorschriften zu prüfen    */
/* Teile, die nicht lagerfähig sind, dürfen keine Verpackungsvorschrift im    */
/* Stamm der VME und Kunden-Teile - Beziehung aufweisen.                      */
/* (Erkennbar an der Füllmenge)                                               */

&IF LOOKUP ("M_Pack","{&PA-OPTIONEN}") > 0 &THEN

  if    S_Artikel.ArtikelArt <> Old_S_Artikel.ArtikelArt
    and not can-do({&pa_M_PTList_StorageArea},gcItemTypeNewPart) then
  do:

    if can-find(first S_ArtME
                  where S_ArtME.Firma      = S_Artikel.Firma
                    and S_ArtME.Artikel    = S_Artikel.Artikel
                    and S_ArtME.Fuellmenge > 0) then
      adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
        ('S_Artikel':U,
         'Artikelart':U,
         'm_pac00127':U,
         S_Artikel.Artikel).

    if can-find(first SBM_PartCustQuant
                  where SBM_PartCustQuant.Firma      = {firma/sartkund.fir S_Artikel.Firma}
                    and SBM_PartCustQuant.Artikel    = S_Artikel.Artikel
                    and SBM_PartCustQuant.Fuellmenge > 0) then
     adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
       ('S_Artikel':U,
        'Artikelart':U,
        'm_pac00129':U,
        S_Artikel.Artikel).

  end.  /* S_Artikel.ArtikelArt <> Old_S_Artikel.ArtikelArt */

&ENDIF

/* ------------------------- */
/* Change Variant Type       */
/* ------------------------- */

/* check if field Variant Type is allowed to be changed                       */

&IF   lookup("M_","{&PA-MODULE}") > 0
   or lookup("ML","{&PA-MODULE}") > 0 &THEN

  if    OLD_S_Artikel.ArtVarTyp <> S_Artikel.ArtVarTyp
    and (
         &IF LOOKUP("ML","{&PA-MODULE}") > 0 &THEN
              can-find(first MLL_Movements
                         where MLL_Movements.Company = S_Artikel.Firma
                           and MLL_Movements.Part    = S_Artikel.Artikel)
           or can-find(first MLM_StorPartData
                         where MLM_StorPartData.Company = S_Artikel.Firma
                           and MLM_StorPartData.Part    = S_Artikel.Artikel
                           and MLM_StorPartData.ArtVar  > '':U
                         use-index Main)
           &IF LOOKUP("M_","{&PA-MODULE}") > 0 &THEN
           or
           &ENDIF
         &ENDIF /* ML */
         &IF LOOKUP("M_","{&PA-MODULE}") > 0 &THEN
           can-find(first MMT_MRPAccount
                      where MMT_MRPAccount.Company = S_Artikel.Firma
                        and MMT_MRPAccount.Artikel = S_Artikel.Artikel)
         &ENDIF /* M_ */
        ) then

    adm.method.cls.DMCMessageSvc:prpoInstance:showErrorInTrigger
      ('S_Artikel':U,
       'ArtVarTyp':U,
       'mltrg00140':U,
       S_Artikel.Firma,
       S_Artikel.Artikel).

&ENDIF /* M_, ML */

/* check usage in documents that neither generate an entry in MMT_MRPAccount  */
/* nor a stock transaction                                                    */

/* purchasing module                                                          */

&IF LOOKUP("E_","{&PA-MODULE}") > 0 &THEN

  if OLD_S_Artikel.ArtVarTyp <> S_Artikel.ArtVarTyp then
  do:

    /* check usage in blanket purchase order                                  */

    if can-find(first E_RA_Pos
                  where E_RA_Pos.Firma    = {firma/ebelkop.fir S_Artikel.Firma}
                    and E_RA_Pos.Belegart = 'ERA':U
                    and E_RA_Pos.offen    = yes
                    and E_RA_Pos.Artikel  = S_Artikel.Artikel) then
      adm.method.cls.DMCMessageSvc:prpoInstance:showErrorInTrigger
        ('S_Artikel':U,
         'ArtVarTyp':U,
         'e_trg00010':U,
         S_Artikel.Artikel).

    /* check usage in request for quote */

    &IF LOOKUP("EA","{&PA-MODULE}") > 0 &THEN

      if can-find(first EA_AnfPos
                    where EA_AnfPos.Firma   = {firma/ebelkop.fir S_Artikel.Firma}
                      and EA_AnfPos.offen   = yes
                      and EA_AnfPos.Artikel = S_Artikel.Artikel) then
        adm.method.cls.DMCMessageSvc:prpoInstance:showErrorInTrigger
          ('S_Artikel':U,
           'ArtVarTyp':U,
           'e_trg00009':U,
           S_Artikel.Artikel).

    &ENDIF /* EA module */

  end. /* OLD_S_Artikel.ArtVarTyp <> S_Artikel.ArtVarTyp */

&ENDIF  /* purchasing module */

/* sales module                                                               */

&IF LOOKUP("V_","{&PA-MODULE}") > 0 &THEN

  if OLD_S_Artikel.ArtVarTyp <> S_Artikel.ArtVarTyp then
  do:

    cDocTypeList = 'A,VUR,VUA,VFP':U.

    do i = 1 to num-entries(cDocTypeList):

      if    can-find(first V_BelegPos
                       where V_BelegPos.Firma    = {firma/vbelegko.fir S_Artikel.Firma}
                         and V_BelegPos.Belegart = entry(i,cDocTypeList)
                         and V_BelegPos.offen    = yes
                         and V_BelegPos.Artikel  = S_Artikel.Artikel)
         or can-find(first VU_RA_Artikel
                       where VU_RA_Artikel.Firma    = {firma/vbelegko.fir S_Artikel.Firma}
                         and VU_RA_Artikel.Belegart = entry(i,cDocTypeList)
                         and VU_RA_Artikel.offen    = yes
                         and VU_RA_Artikel.Artikel  = S_Artikel.Artikel) then

        adm.method.cls.DMCMessageSvc:prpoInstance:showErrorInTrigger
          ('S_Artikel':U,
           'ArtVarTyp':U,
           'v_trg00041':U,
           S_Artikel.Artikel).

    end. /* do i = 1 to num-entries('A,VUR,VUA,VFP':U) */

    &IF LOOKUP("VS","{&PA-MODULE}") > 0 &THEN

      /* check usage in Service Order */

      &IF LOOKUP("VS_SAUF","{&PA-OPTIONEN}") > 0 &THEN

        if    can-find(first VS_AuftragPos
                         where VS_AuftragPos.Firma          = {firma/vbelegko.fir S_Artikel.Firma}
                           and VS_AuftragPos.Belegart       = 'VSA':U
                           and VS_AuftragPos.offen          = yes
                           and VS_AuftragPos.ArtikelWartung = S_Artikel.Artikel)
           or can-find(first VS_AuftragMKT
                         where VS_AuftragMKT.Firma    = {firma/vbelegko.fir S_Artikel.Firma}
                           and VS_AuftragMKT.Belegart = 'VSA':U
                           and VS_AuftragMKT.Satzart  = 'M':U
                           and VS_AuftragMKT.offen    = yes
                           and VS_AuftragMKT.Artikel  = S_Artikel.Artikel) then
          adm.method.cls.DMCMessageSvc:prpoInstance:showErrorInTrigger
            ('S_Artikel':U,
             'ArtVarTyp':U,
             'v_trg00041':U,
             S_Artikel.Artikel).

      &ENDIF /* VS_SAUF */

      /* check usage in Maintenance Contract */

      &IF LOOKUP("VS_WVERT","{&PA-OPTIONEN}") > 0 &THEN

        for each VST_MaintContract
          where VST_MaintContract.Firma     = {firma/vbelegko.fir S_Artikel.Firma}
            and VST_MaintContract.Belegart  = 'VSW':U
            and VST_MaintContract.offen     = yes
          no-lock,
          each VST_MaintContractPos
            where VST_MaintContractPos.Company               = {firma/vbelegko.fir S_Artikel.Firma}
              and VST_MaintContractPos.VST_MaintContract_Obj = VST_MaintContract.VST_MaintContract_Obj
              and VST_MaintContractPos.offen                 = yes
              and VST_MaintContractPos.PositionsNr           > 0
          no-lock
          on error undo, throw:

          if VST_MaintContractPos.Maint_S_Artikel_Obj  = S_Artikel.S_Artikel_obj then
            adm.method.cls.DMCMessageSvc:prpoInstance:showErrorInTrigger
              ('S_Artikel':U,
               'ArtVarTyp':U,
               'v_trg00041':U,
               S_Artikel.Artikel).

          if can-find(first VST_MaintContPlan
                        where VST_MaintContPlan.VST_MaintContractPos_Obj = VST_MaintContractPos.VST_MaintContractPos_Obj
                          and can-find(first VST_MaintContMCA
                                         where VST_MaintContMCA.Company    = {firma/vbelegko.fir VST_MaintContPlan.Company}  
                                           and VST_MaintContMCA.offen      = yes
                                           and VST_MaintContMCA.Satzart    = 'M':U
                                           and VST_MaintContMCA.Artikel    = S_Artikel.Artikel
                                           and VST_MaintContMCA.owning_Obj = VST_MaintContPlan.VST_MaintContPlan_Obj)) then
            adm.method.cls.DMCMessageSvc:prpoInstance:showErrorInTrigger
              ('S_Artikel':U,
               'ArtVarTyp':U,
               'v_trg00041':U,
               S_Artikel.Artikel).

        end. /* for each VST_Maintcontract */
      &ENDIF  /* VS_WVERT module */
    &ENDIF  /* VS module */

  end. /* OLD_S_Artikel.ArtVarTyp <> S_Artikel.ArtVarTyp */

&ENDIF  /* sales module */

&IF LOOKUP("ML","{&PA-MODULE}") > 0 &THEN

  /* Bei Änderung der Variantenart müssen bestehende Vorschlagssätze der        */
  /* permanenten Inventur gelöscht werden. In MLM_StorPartData fortgeschriebene */
  /* Werte müssen mit 0 initialisiert werden. MLM_StorPartData dürfen nicht     */
  /* vorhanden sein. (mltrg00140)                                               */

  if    OLD_S_Artikel.ArtVarTyp <> S_Artikel.ArtVarTyp
    and (   {stamm/incl/s__var00.if
               &Tabelle = "Old_S_Artikel"}
         or {stamm/incl/s__var00.if
               &Tabelle = "S_Artikel"}) then

    for each MLM_StorPartData
      where MLM_StorPartData.Company = S_Artikel.Firma
        and MLM_StorPartData.Part    = S_Artikel.Artikel
      exclusive-lock
      on error  undo, throw:

      /* Löschen aller ML_PermInventur-Sätze, unabhängig von ArtVar           */
      /* da es möglich ist die Variantenart bei existierender Teile-          */
      /* Lagerort-Beziehung zu ändern.                                        */

      &IF "{&pa_ML_PermInventur}" = "1" &THEN

        for each ML_PermInventur
          where ML_PermInventur.Firma    = {firma/mlartort.fir S_Artikel.Firma}
            and ML_PermInventur.Lagerort = MLM_StorPartData.Storagearea
            and ML_PermInventur.Artikel  = MLM_StorPartData.Part
          exclusive-lock
          on error  undo, throw:

          delete ML_PermInventur.

        end.  /* for each ML_PermInventur */

      &ENDIF

      assign

        &IF "{&pa_ML_PermInventur}" = "1" &THEN
          MLM_StorPartData.CycleCountLevel = 0
        &ENDIF

        MLM_StorPartData.ReplenishLevel   = 0
        MLM_StorPartData.MaximumOnHand    = 0
        MLM_StorPartData.OrderPoint       = 0
        MLM_StorPartData.SafetyStock      = 0
        MLM_StorPartData.TriggerPoint     = 0
        MLM_StorPartData.TransferQuantity = 0
        MLM_StorPartData.TargetOnHand     = 0
        .

    end.  /* for each MLM_StorPartData */

if  OLD_S_Artikel.LagerME <> S_Artikel.LagerME then

  mawi.lager.cls.MLCInventorySvc:prpoInstance:ChangeQtyUnitPermInventory
    (buffer S_Artikel,
     OLD_S_Artikel.LagerME).

&ENDIF /* ML */

&IF LOOKUP("MA","{&PA-MODULE}") > 0 &THEN

  /* add log record for outdated temp. structures                             */

  {mawi/incl/m__tmp02.if
    &ippForceLog = "no"
    &ippPart     = "S_Artikel.Artikel"
  }

&ENDIF

/* Proalpha expects that a price unit 0 exists. But if not you can create a */
/* part with the invalid price unit 0.                                      */

if S_Artikel.Preiseinheit = 0
  and not can-find(S_Preiseinheit
                     where S_Preiseinheit.Firma        = {firma/spreeinh.fir S_Artikel.Firma}
                       and S_Preiseinheit.Preiseinheit = 0) then

  adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
    ('S_Artikel':U,
     'Preiseinheit':U,
     's_trg00180':U,
     S_Artikel.Artikel,
     string(S_Artikel.Preiseinheit)).

/* the weight can only be changed if it is not already confirmed              */

if    OLD_S_Artikel.Gewicht          <> S_Artikel.Gewicht
  and OLD_S_Artikel.GewichtBestaetigt = S_Artikel.GewichtBestaetigt
  and S_Artikel.GewichtBestaetigt     = yes then

  adm.method.cls.DMCMessageSvc:prpoInstance:showErrorInTrigger
    ('S_Artikel':U,
     'Gewicht':U,
     's_gew00001':U,
     S_Artikel.Artikel).

&IF LOOKUP("U_CE":U,"{&PA-OPTIONEN}":U) > 0 &THEN

/* Check existance of active UniqueID when UniqueID requirement shall be deleted */

if    OLD_S_Artikel.uCE_UniqueIDRequired <> S_Artikel.uCE_UniqueIDRequired
  and S_Artikel.uCE_UniqueIDRequired = no
  and can-find(first USM_UniqueID
                 where USM_UniqueID.Company  = {firma/usmuniid.fir S_Artikel.Firma}
                   and USM_UniqueID.Part     = S_Artikel.Artikel
                   and USM_UniqueID.Archived = no) then

  adm.method.cls.DMCMessageSvc:prpoInstance:showError
    ('upmcl000036':U,
     S_Artikel.Artikel).

/* Check Form */

if    OLD_S_Artikel.uCE_FormNumberUID <> S_Artikel.uCE_FormNumberUID
  and not can-find(gbuBG_FKopf
                     where gbuBG_FKopf.Firma      = {firma/bgfkopf.fir S_Artikel.Firma}
                       and gbuBG_FKopf.Formular   = 'USUID':U
                       and gbuBG_FKopf.FormularNr = S_Artikel.uCE_FormNumberUID) then

  adm.method.cls.DMCMessageSvc:prpoInstance:showError
    ('vupak00001':U,
     string(S_Artikel.uCE_FormNumberUID)).

/* Seriennummerntyp  */

if S_Artikel.uCE_NoOfPanels >  1
  and S_Artikel.SNRTyp      > '':U then
  adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
    ('S_Artikel':U,
     'uCE_ESNRTyp':U,
     'upmcl000031':U,
     S_Artikel.uCE_ESNRTyp).

if S_Artikel.uCE_ESNRTyp    >  '':U then 
do:
  find gbuS_SNRTyp_ESNR 
    where gbuS_SNRTyp_ESNR.Firma  = {firma/ssnrtyp.fir S_Artikel.Firma}
      and gbuS_SNRTyp_ESNR.SNRTyp = S_Artikel.uCE_ESNRTyp
  no-lock no-error.
  if not available gbuS_SNRTyp_ESNR then
    adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
      ('S_Artikel':U,
       'uCE_ESNRTyp':U,
       'upmcl000006':U,
       S_Artikel.uCE_ESNRTyp).

  if S_Artikel.SNRTyp > '':U then 
  do:
    find gbuS_SNRTyp_SNR 
      where gbuS_SNRTyp_SNR.Firma  = {firma/ssnrtyp.fir S_Artikel.Firma}
        and gbuS_SNRTyp_SNR.SNRTyp = S_Artikel.SNRTyp
    no-lock.
    if gbuS_SNRTyp_ESNR.SNRFormat <> gbuS_SNRTyp_SNR.SNRFormat + '999':U 
      and gbuS_SNRTyp_ESNR.SNRFormat <> gbuS_SNRTyp_SNR.SNRFormat then
      adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
        ('S_Artikel':U,
         'uCE_ESNRTyp':U,
         'upmcl000032':U,
         gbuS_SNRTyp_ESNR.SNRFormat,
         gbuS_SNRTyp_SNR.SNRFormat).

  end.
end.

if    S_Artikel.ArtVarTyp > 0
  and S_Artikel.uCE_RoHSStatus > 0 then

  adm.method.cls.DMCMessageSvc:prpoInstance:showError
    ('usmep00001':U,
     S_Artikel.Artikel,
     {fnarg
        pa_cReposFieldInformationByName
        "'S_Artikel':U,
         'uCE_RoHSStatus':U,
         'label':U"}).

&ENDIF /* U_CE */

&IF   LOOKUP("SO","{&PA-MODULE}") > 0 
  AND (   LOOKUP("SB-QM-Master":U,"{&PA-OPTIONEN}":U) > 0
       or LOOKUP("SB_CMPLNTS","{&PA-OPTIONEN}")       > 0) &THEN

  buffer-compare
  OLD_S_Artikel
    using {&pa_SB_QMFieldsPart} 
  to S_Artikel
  save result in glQMRelevantUnchanged.

  if not glQMRelevantUnchanged then
    stamm.base.cls.SBCQualityCheckSvc:prpoInstance:sendQMRelevantChangesForMasterFile
      (S_Artikel.S_Artikel_Obj,
       'pAX-QM-PARTS':U,
       '':U,
       S_Artikel.Firma,
       S_Artikel.Artikel,
       &IF LOOKUP("SB_CMPLNTS","{&PA-OPTIONEN}") > 0 &THEN
         no /* complaint management include parts with no quality area */
       &ELSE
         yes
       &ENDIF).

&ENDIF



return.

end procedure. /* Aendern */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pruefeEAN Procedure 
procedure pruefeEAN :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Es darf keine zugeordnete EAN hängenbleiben, bei der die Mengeneinheit der */
/* EAN den Bezug zu einer LME oder VME gem. Teilestamm oder VerpackungsME     */
/* verloren geht                                                              */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* <NONE>                                                                     */
/*                                                                            */
/*----------------------------------------------------------------------------*/

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

if    Old_S_Artikel.Artikelart <> S_Artikel.Artikelart
  and can-do({&pa_V_PTList_WithoutEAN},gcItemTypeNewPart)
  and can-find(first S_EAN
                 where S_EAN.Firma   = S_Artikel.Firma
                   and S_EAN.Artikel = S_Artikel.Artikel) then
  adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
    ('S_Artikel':U,
     'Artikelart':U,
     's_trg00223':U,
     S_Artikel.Artikel).

if    Old_S_Artikel.LagerME <> S_Artikel.LagerME
  and not can-find(S_ArtME
                     where S_ArtME.Firma         = S_Artikel.Firma
                       and S_ArtME.Mengeneinheit = S_Artikel.LagerME
                       and S_ArtME.Artikel       = S_Artikel.Artikel) then
do:

  find first S_EAN
    where S_EAN.Firma         = S_Artikel.Firma
      and S_EAN.Artikel       = S_Artikel.Artikel
      and S_EAN.Mengeneinheit =  Old_S_Artikel.LagerME
    no-lock no-error.

  if available S_EAN then

    adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
     ('S_Artikel':U,
      'LagerME':U,
      's_trg00216':U,
      string(Old_S_Artikel.LagerME),
      S_Artikel.Artikel,
      S_EAN.EAN).

end.

end procedure. /* pruefeEAN */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pruefeEAN Procedure 
procedure pruefeSNRArt :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Prüfe ob für das aktuelle Teil noch Seriennummernzuordungen zu offenen     */
/* Belegen bestehen.                                                          */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* <NONE>                                                                     */
/*                                                                            */
/*----------------------------------------------------------------------------*/

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

&IF    LOOKUP("M_","{&PA-MODULE}") > 0
   and LOOKUP("MS","{&PA-MODULE}") > 0 &THEN

  /*--------------------------------------------------------------------------*/
  /* Prüfungen bei Veränderungen der Seriennummernart                         */
  /*--------------------------------------------------------------------------*/

  if    Old_S_Artikel.SNRArt <> S_Artikel.SNRArt then
  do:

    if S_Artikel.SNRArt  > '':U then
    do:


      /* serial number required parts must not have a quantity unit with        */
      /* decimal places                                                         */

      if ({fnarg
            pa_iDyCchUnitOfMeasureDecimals
            "S_Artikel.Firma,
             S_Artikel.LagerME"}) > 0 then
        adm.method.cls.DMCMessageSvc:prpoInstance:ShowErrorInTrigger
         ('S_Artikel':U,
          'LagerME':U,
          'mssnr00114':U,
          S_Artikel.Artikel).

      /* serial number required parts must not have a quantity unit with        */
      /* decimal places for Packaging                                           */

      for each S_ArtME
        where S_ArtME.Firma   = {firma/sartikel.fir S_Firma.Firma}
          and S_ArtME.Artikel = S_Artikel.Artikel
        no-lock
        on error undo, throw:

        if ({fnarg
              pa_iDyCchUnitOfMeasureDecimals
              "S_ArtME.Firma,
               S_ArtME.MengenEinheit"}) > 0 then
          adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
            ('mssnr00114':U,
             S_ArtME.Artikel).

      end. /* for each S_ArtME */

    end.  /* if S_Artikel.SNRArt  > '':U then */

    if can-find(first MS_SNR
                  where MS_SNR.Firma          = {firma/mssnr.fir S_Artikel.Firma}
                    and MS_SNR.ArtikelAktuell = S_Artikel.Artikel) then

       adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
          ('mstrg00023':U,
            S_Artikel.Artikel).

    &IF LOOKUP("V_","{&PA-MODULE}") > 0 &THEN

      if mawi.serie.cls.MSCSerialNoSvc:prpoInstance:lCheckSNoSales(S_Artikel.Artikel) = yes then

        adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
          ('mstrg00011':U,
            S_Artikel.Artikel).

      &IF LOOKUP("M_STUELI","{&PA-OPTIONEN}") > 0 &THEN

       if mawi.serie.cls.MSCSerialNoSvc:prpoInstance:lCheckSNoSet(S_Artikel.Artikel) = yes then

         adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
          ('mstrg00012':U,
            S_Artikel.Artikel).

      &ENDIF /* lookup("M_STUELI" */
    &ENDIF /* lookup("V_" */

    &IF LOOKUP("PP","{&PA-MODULE}") > 0 &THEN

      if mawi.serie.cls.MSCSerialNoSvc:prpoInstance:lCheckSNoWorkOrder(S_Artikel.Artikel) = yes then

         adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
          ('mstrg00014':U,
            S_Artikel.Artikel).

      if mawi.serie.cls.MSCSerialNoSvc:prpoInstance:lCheckSNoBOMLines(S_Artikel.Artikel) = yes then

         adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
          ('mstrg00016':U,
            S_Artikel.Artikel).

    &ENDIF /* lookup("PP" */

    &IF LOOKUP("E_","{&PA-MODULE}") > 0 &THEN

      if mawi.serie.cls.MSCSerialNoSvc:prpoInstance:lCheckSNoStockReceipts(S_Artikel.Artikel) = yes then

         adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
          ('mstrg00018':U,
            S_Artikel.Artikel).

      if mawi.serie.cls.MSCSerialNoSvc:prpoInstance:lCheckSNoReturns(S_Artikel.Artikel) = yes then

         adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
          ('mstrg00020':U,
            S_Artikel.Artikel).

    &ENDIF /* lookup("E_" */

    &IF LOOKUP("ML","{&PA-MODULE}") > 0 &THEN

      if mawi.serie.cls.MSCSerialNoSvc:prpoInstance:lCheckSNoML(S_Artikel.Artikel) = yes then
        adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
          ('mstrg00022':U,
          S_Artikel.Artikel).

    &ENDIF /* lookup("ML" */

end. /* if Old_Artikel.SNRArt <> S_Artikel.SNRArt  */

&ENDIF  /*  lookup("M_", "MS" */

return.

end procedure. /* pruefeSNRArt */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&IF LOOKUP("WS","{&PA-MODULE}") > 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE WEB-Shop Procedure 
procedure WEB-Shop :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Perform checks an reconcile actions that are necessary for webshop         */
/* parts.                                                                     */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* none                                                                       */
/*                                                                            */
/*----------------------------------------------------------------------------*/

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

define variable dTaxrate like WS_Artikel.SteuerSatz no-undo.

/* Buffers -------------------------------------------------------------------*/

&IF LOOKUP("ML","{&PA-MODULE}") > 0 &THEN
  define buffer bMLM_StorPartData     for MLM_StorPartData.
  define buffer bML_Lagergruppe       for ML_Lagergruppe.
&ENDIF
define buffer bSBM_ValueFlowGroup-Old for SBM_ValueFlowGroup.
define buffer bSBM_ValueFlowGroup-New for SBM_ValueFlowGroup.
define buffer bWS_Artikel             for WS_Artikel.
define buffer bWS_Firma               for WS_Firma.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

ReconcilePartChanges:
for each bWS_Artikel
  where bWS_Artikel.S_Artikel_Obj = S_Artikel.S_Artikel_Obj
  exclusive-lock,
  first bWS_Firma
    where bWS_Firma.WS_Firma_Obj = bWS_Artikel.WS_Firma_Obj
    no-lock
  on error undo, throw:

  /*--------------------------------------------------------------------------*/
  /* delete WS_Artikel if the part is archived or webshop flag is removed!    */
  /*--------------------------------------------------------------------------*/

  if S_Artikel.archiviert = yes then
    S_Artikel.WEBShop = 0.

  if   S_Artikel.WEBShop    = 0
    or S_Artikel.archiviert = yes then
  do:
    delete bWS_Artikel.
    next ReconcilePartChanges.
  end.

  /*--------------------------------------------------------------------------*/
  /* reconcile part tax rate with the webshop if there are changes after the  */
  /* initial creation of the webshop part.                                    */
  /*--------------------------------------------------------------------------*/

  if (    OLD_S_Artikel.SBM_ValueFlowGroup_Obj <> S_Artikel.SBM_ValueFlowGroup_Obj
      and can-find (bSBM_ValueFlowGroup-Old
                      where bSBM_ValueFlowGroup-Old.SBM_ValueFlowGroup_Obj = Old_S_Artikel.SBM_ValueFlowGroup_Obj
                        and can-find (bSBM_ValueFlowGroup-New
                                        where bSBM_ValueFlowGroup-New.SBM_ValueFlowGroup_Obj = S_Artikel.SBM_ValueFlowGroup_Obj
                                          and bSBM_ValueFlowGroup-New.S_ArtKtoGr_Obj        <> bSBM_ValueFlowGroup-Old.S_ArtKtoGr_Obj))) then
  do:

      dTaxrate = web.shop.cls.WSCWebshopSvc:prpoInstance:dWebshopPartTaxrate(S_Artikel.SBM_ValueFlowGroup_Obj,
                                                                             bWS_Firma.WS_Firma_Obj).

      if dTaxrate <> ? then
        bWS_Artikel.SteuerSatz = dTaxrate.
      else
        adm.method.cls.DMCMessageSvc:prpoInstance:showError('wssho00042':U,
                                                            bWS_Artikel.Artikel).
  end. /* reconcile taxrate */

  /*--------------------------------------------------------------------------*/
  /* reconcile priced data with webshop if price unit changes after the       */
  /* initial creation of the webshop part.                                    */
  /*--------------------------------------------------------------------------*/

  if OLD_S_Artikel.Preiseinheit <> S_Artikel.Preiseinheit then
    web.shop.cls.WSCWebshopSvc:prpoInstance:ReconcileWebshopPartPriceData(bWS_Artikel.WS_Artikel_Obj).

  /* if the weight is changed, the webshop part is flagged as changed because */
  /* weight information is not replicated, but directly used during creation  */
  /* of pAX-WEBSHOP-PARTS messages.                                           */

  if OLD_S_Artikel.LagerGewicht <> S_Artikel.LagerGewicht then
    web.shop.cls.WSCWebshopSvc:prpoInstance:FlagAsChangedInWebshop(bWS_Artikel.WS_Artikel_Obj).

  /*--------------------------------------------------------------------------*/
  /* reconcile WBZ data with webshop if it changes after the initial creation */
  /* of the webshop part.                                                     */
  /*--------------------------------------------------------------------------*/

  if (   OLD_S_Artikel.WBZ_Lieferant <> S_Artikel.WBZ_Lieferant
      or OLD_S_Artikel.WBZ           <> S_Artikel.WBZ       ) then
  do:

  &IF LOOKUP("ML","{&PA-MODULE}") > 0 &THEN

    find bMLM_StorPartData
      where bMLM_StorPartData.Company     = S_Artikel.Firma
        and bMLM_StorPartData.Storagearea = WS_Firma.Lagerort
        and bMLM_StorPartData.Part        = S_Artikel.Artikel
        and bMLM_StorPartData.ArtVar      = '':U
      no-lock no-error.

    if available bMLM_StorPartData then
      find bML_Lagergruppe
        where bML_Lagergruppe.ML_Lagergruppe_Obj = MLM_StorPartData.ML_Lagergruppe_Obj
        no-lock no-error.

  &ENDIF

    assign
      bWS_Artikel.WBZ            =
        &IF LOOKUP("ML","{&PA-MODULE}") > 0 &THEN
          mawi.base.cls.MMCScheduleSvc:prpoInstance:iPartOLT(S_Artikel.Artikel,
                                                             S_Artikel.WBZ_Lieferant,
                                                             S_Artikel.WBZ,
                                                             (if available bML_Lagergruppe then
                                                                bML_Lagergruppe.Lagergruppe
                                                              else
                                                                ?),
                                                             ?)
        &ELSE
          S_Artikel.WBZ
        &ENDIF
      .

  end. /* reconcile WBZ */

end.  /* for each WS_Artikel */

return.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF  /* procedure Web-Shop */

