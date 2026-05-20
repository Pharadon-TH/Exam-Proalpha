&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          basis            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DECLARATIONS V-table-Win 

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update Information" V-table-Win _INLINE
/* Actions: ? ? ? ? adm/support/proc/ds_pa_01.w */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/******************************************************************************/
/*                                  (c) 2023 proALPHA Business Solutions GmbH */
/*                                           Auf dem Immel 8                  */
/*                                           67685 Weilerbach                 */
/* Project: proALPHA                                                          */
/*                                                                            */
/* Name   : s_wart01.w                                                        */
/* Product: Stamm - Master Data                                               */
/* Module : Kern - Base functionality                                         */
/*                                                                            */
/* Created: 3.00 as of 28.11.1996/Werner Ernst                                */
/* Current: 9.3.0 as of 2022-11-23/Tsolakidis, Triantafyllos                  */
/*                                                                            */
/*----------------------------------------------------------------------------*/
/* DESCRIPTION                                                                */
/*----------------------------------------------------------------------------*/
/*                                                                            */
/*  Basis Seite zum Teilestamm                                                */
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
/* 2021-02-12 Weiler, Frank e2e5f63d91b4780a995fb823a851ae2a64481c38          */
/*            HOUD-615: WebSkin: Batchlauf für Pattern: Display & Assign Prep */
/*            rocessors for Combo-Box/Selection-List - Part II                */
/* 2021-03-01 Jung, Oliver 6f4fc66d51c18961a1c5151ddb22fbbbf5b7cbb7           */
/*            HOUD-671: Nacharbeiten Batchlauf für Pattern: Assign statement  */
/*            for Combo-Box/Selection-List                                    */
/* 2021-07-20 Roth, Johannes e4ca3930def6496c2033d4682150534d2f06ff45         */
/*            HOUD-891: Dateiauswahl R1                                       */
/*            HOUd-891: Dateiauswahl R1                                       */
/*            Houd-891: Dateiauswahl R1                                       */
/* 2021-08-09 Weiler, Frank 326ccd948b45f18570be5962e23d46257b457b06          */
/*            HOUD-1665: apply Pattern auf pa_UISvcApplyEventToWidgetByHandle */
/*             umstellen                                                      */
/* 2021-09-24 Weiler, Frank 2b3dee37f5b945ee4c2ed6f41bac39818b0f2bb0          */
/*            HOUD-1949: Serviceauftrag Aktivitäten/Material/Kostenposition:  */
/*            falsche Standardsteuer wird angezeigt und verfälscht Steuer in  */
/* 2021-09-29 Weiler, Frank 5d607d89f24d6172a8f6a883411032df2a21dd77          */
/*            HOUD-788: pA ray: Batchlauf pa-DisplaySkinClientWidgets" und "p */
/*            a-AssignSkinClientWidgets"                                      */
/* 2021-12-23 Dworschak, Jan e1953acb1ffa43f3261cc3d00fcd3ce430691b16         */
/*            PA-23083: Stammdatenaustausch Teile per INWB (pAX-SRM-Parts)    */
/* 2022-01-11 Tsolakidis, Triantafyllos 4e6081d8c5dae458886f7e9b41232ccb407d9281 */
/*            HOUD-2644: Interface-Trigger: User Exit Includes und Fehlerhand */
/*            ling hinzufügen                                                 */
/* 2022-01-12 Ulrich, Holger ef878d39c9ef55b55f37219dde2a6b8f6fe2f6ac         */
/*            PA-24741: Laufzeitfehler '91' beim Aufruf des Stammdatensatzes  */
/*            wenn Position leer                                              */
/* 2022-01-14 Risch, Aline 409007c8ab2326cdaea05aced9451ed64f43f13d           */
/*            PA-24864: Consistency Checks bereinigen                         */
/* 2022-02-04 Tsolakidis, Triantafyllos a24198fdbd07f4780803689216fefe72fda920ae */
/*            HOUD-2919: Interface-Trigger: User Exit Includes und Fehlerhand */
/*            ling hinzufügen: Nur Einrückungen und Leerzeilen                */
/* 2022-02-25 Läpple, Jeannette 29bde97ee33b490c16bd2ab13d538f744530166b      */
/*            PA-25686: Performanceprobleme Neuanlage Teilestamm              */
/* 2022-07-08 Lambert, Sylvain 8d501aebc26805ad606ac2fa7802b197280f4c04       */
/*            HOUD-3415: Security: Benutzer können im Dateiauswahldialog das  */
/*            Temp-Verzeichnis auf dem Server sehen                           */
/* 2022-08-04 Stegner, Kevin c3bbdafe72edafe2474cb15b36fa316b8af87172         */
/*            PA-28465: Teilestamm: Infofeld zur Mengeneinheit bei Gew/LME un */
/*            d Gew/GME fehlt                                                 */
/* 2022-11-23 Tsolakidis, Triantafyllos 3af8ab9f6b2397d323df05bf462a47dd5d77f515 */
/*            DEPL-12691: Nacharbeit proALPHA 9.2.0                           */
/*            HOUD-4252: Performance: Methode lLoadIconImage in DMCUISvcStd.c */
/*            ls auf static umstellen                                         */
/******************************************************************************/

create widget-pool.

/* Procedure Information -----------------------------------------------------*/

&GLOBAL-DEFINE pa-Autor             Werner Ernst
&GLOBAL-DEFINE pa-Version           9.3.0
&GLOBAL-DEFINE pa-Datum             2022-11-23
&GLOBAL-DEFINE pa-Letzter           Tsolakidis, Triantafyllos

&GLOBAL-DEFINE pa-GenVersion       UIB
&GLOBAL-DEFINE pa-ProgrammTyp      SmartViewer
&GLOBAL-DEFINE pa-Template         adm/template/proc/dt_viw00.w
&GLOBAL-DEFINE pa-TemplateVersion  1.08
&GLOBAL-DEFINE pa-XBasisName       s_wart01_w

/* Parameters ----------------------------------------------------------------*/

/* Globals -------------------------------------------------------------------*/

{adm/template/incl/dt_viw00.df}

/* SCOPEDs -------------------------------------------------------------------*/

&Scoped-define pa-FieldEnableStateCode S_Artikel.LagerME:paSCisStorageAreaUnitOfMeasureChangeable ~
                                       S_Artikel.ArtVarTyp:paSCisVariantTypeChangeable ~
                                       S_Artikel.IsPackagingUnitToStock:paSCisPackUnitToStockChangeable

&SCOPED-DEFINE PA-HLP-InitialHelpString gcInitialHelpString

&SCOPED-DEFINE pa-FieldEnableStateCode glSRMFlag:paSCisSRMFlagSensitive

&SCOP PA-HLP-FIELDNAMES StkME
&SCOP PA-HLP-KEYNAMES MengenEinheit

/* Variables -----------------------------------------------------------------*/
/* gcInitialHelpString    initial help string                                 */
/*----------------------------------------------------------------------------*/

define variable gcInitialHelpString as   character               no-undo.

/* Buffers -------------------------------------------------------------------*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES S_Artikel
&Scoped-define FIRST-EXTERNAL-TABLE S_Artikel


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR S_Artikel.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS S_Artikel.VerteilerGruppe ~
S_Artikel.SBM_ValueFlowGroup_Obj S_Artikel.ArtikelGruppe S_Artikel.Sparte ~
S_Artikel.Bild S_Artikel.ABC_Klasse S_Artikel.DIN_ISO ~
S_Artikel.P_ReverseCharge S_Artikel.LagerME ~
S_Artikel.IsPackagingUnitToStock S_Artikel.SME_Faktor ~
S_Artikel.LagerGewicht S_Artikel.GewichtBestaetigt S_Artikel.GewichtME ~
S_Artikel.Gewicht S_Artikel.StkME S_Artikel.StkFaktor 
&Scoped-define ENABLED-TABLES S_Artikel
&Scoped-define FIRST-ENABLED-TABLE S_Artikel
&Scoped-Define ENABLED-OBJECTS btnBild glSRMFlag 
&Scoped-Define DISPLAYED-FIELDS S_Artikel.VerteilerGruppe ~
S_Artikel.SBM_ValueFlowGroup_Obj S_Artikel.ArtikelGruppe S_Artikel.Sparte ~
S_Artikel.Bild S_Artikel.ABC_Klasse S_Artikel.DIN_ISO ~
S_Artikel.P_ReverseCharge S_Artikel.LagerME ~
S_Artikel.IsPackagingUnitToStock S_Artikel.SME_Faktor ~
S_Artikel.LagerGewicht S_Artikel.GewichtBestaetigt S_Artikel.GewichtME ~
S_Artikel.Gewicht S_Artikel.StkME S_Artikel.StkFaktor 
&Scoped-define DISPLAYED-TABLES S_Artikel
&Scoped-define FIRST-DISPLAYED-TABLE S_Artikel
&Scoped-Define DISPLAYED-OBJECTS glSRMFlag S_Artikel_VerteilerGruppe_Info ~
S_ArtiBM_ValueFlowGroup_Obj_Info S_Artikel_ArtikelGruppe_Info ~
S_Artikel_Sparte_Info S_Artikel_LagerME_Info S_Artikel_GewichtME_Info ~
S_Artikel_StkME_Info S_Artikel_SME_Faktor_Info LagerGewicht_ME_Info ~
Gewicht_ME_Info 

/* Custom List Definitions                                              */
/* List-1,ADM-ASSIGN-FIELDS,List-3,PA-UPDATE-VARS,List-5,PA-SEARCH-FIELDS */
&Scoped-define PA-UPDATE-VARS btnBild glSRMFlag 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/proc/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
SBM_ValueFlowGroup_Obj||y|basis.S_Artikel.SBM_ValueFlowGroup_Obj||||||
S_Artikel_Obj||y|basis.S_Artikel.S_Artikel_Obj||||||
Driver_Obj||y|basis.S_Artikel.Driver_Obj||||||
SBM_CustomsTariffNo_Obj||y|basis.S_Artikel.SBM_CustomsTariffNo_Obj||||||
SBM_F_EcoCode_Obj||y|basis.S_Artikel.SBM_F_EcoCode_Obj||||||
</FOREIGN-KEYS>
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
run set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ",SBM_ValueFlowGroup_Obj,S_Artikel_Obj,Driver_Obj,SBM_CustomsTariffNo_Obj,SBM_F_EcoCode_Obj"':U).
/**************************
</EXECUTING-CODE> */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update Support" V-table-Win _INLINE
/* Actions: ? adm/support/proc/ds_sma00.w ? ? adm/support/proc/ds_viw00.p */
/* STRUCTURED-DATA
<ADDITIONAL-INFORMATION EDITABLE></ADDITIONAL-INFORMATION EDITABLE>

<CONSTANTS>
*****/
&SCOP ENABLED-TABLES S_Artikel
&SCOP FIRST-ENABLED-TABLE S_Artikel
&SCOP PA-FIRST-INITIAL-VALUES~
  S_Artikel.Firma = ~{firma/sartikel.fir pa-Firma}~
  S_Artikel.Artikel = entry(1,pa-external-keys,~{&pa-EOL})
&SCOP PA-EXTERNAL-KEYS Artikel
&SCOP PA-FIRST-COMPARE~
  S_Artikel.Firma = ~{firma/sartikel.fir pa-Firma}~
  and S_Artikel.Artikel = entry(1,pa-external-keys,~{&pa-EOL})
&SCOP PA-FIRST-EXCEPT-FIELDS {&PA-FIRST-EXCEPT-FIELDS} Firma Artikel AnlageBenutzer AnlageDatum AnlageZeit AenderungBenutzer AenderungDatum AenderungZeit S_Artikel_Obj

/*****
</CONSTANTS> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Search Support" V-table-Win _INLINE
/* Actions: ? adm/support/proc/ds_sma00.w ? ? adm/support/proc/ds_viw03.p */
/* STRUCTURED-DATA
<BUILD-INFORMATION>
1.09
</BUILD-INFORMATION>
<STATEMENTS>
*****/

&SCOP PA-FIELDS-ENABLE-STATEMENT~
  enable unless-hidden~
    S_Artikel.VerteilerGruppe~
      when not can-do(pa-disabled-fields,'S_Artikel.VerteilerGruppe':U)~
    S_Artikel.SBM_ValueFlowGroup_Obj~
      when not can-do(pa-disabled-fields,'S_Artikel.SBM_ValueFlowGroup_Obj':U)~
    S_Artikel.ArtikelGruppe~
      when not can-do(pa-disabled-fields,'S_Artikel.ArtikelGruppe':U)~
    S_Artikel.Sparte~
      when not can-do(pa-disabled-fields,'S_Artikel.Sparte':U)~
    S_Artikel.Bild~
      when not can-do(pa-disabled-fields,'S_Artikel.Bild':U)~
    S_Artikel.ABC_Klasse~
      when not can-do(pa-disabled-fields,'S_Artikel.ABC_Klasse':U)~
    S_Artikel.DIN_ISO~
      when not can-do(pa-disabled-fields,'S_Artikel.DIN_ISO':U)~
    S_Artikel.P_ReverseCharge~
      when not can-do(pa-disabled-fields,'S_Artikel.P_ReverseCharge':U)~
    S_Artikel.LagerME~
      when not can-do(pa-disabled-fields,'S_Artikel.LagerME':U)~
    S_Artikel.IsPackagingUnitToStock~
      when not can-do(pa-disabled-fields,'S_Artikel.IsPackagingUnitToStock':U)~
    S_Artikel.SME_Faktor~
      when not can-do(pa-disabled-fields,'S_Artikel.SME_Faktor':U)~
    S_Artikel.LagerGewicht~
      when not can-do(pa-disabled-fields,'S_Artikel.LagerGewicht':U)~
    S_Artikel.GewichtBestaetigt~
      when not can-do(pa-disabled-fields,'S_Artikel.GewichtBestaetigt':U)~
    S_Artikel.GewichtME~
      when not can-do(pa-disabled-fields,'S_Artikel.GewichtME':U)~
    S_Artikel.Gewicht~
      when not can-do(pa-disabled-fields,'S_Artikel.Gewicht':U)~
    S_Artikel.StkME~
      when not can-do(pa-disabled-fields,'S_Artikel.StkME':U)~
    S_Artikel.StkFaktor~
      when not can-do(pa-disabled-fields,'S_Artikel.StkFaktor':U)~
    btnBild~
      when not can-do(pa-disabled-fields,'s_wart01_w.btnBild':U)~
    glSRMFlag~
      when not can-do(pa-disabled-fields,'s_wart01_w.glSRMFlag':U)~
    with frame {&Frame-Name}.
&SCOP PA-FIELDS-DISABLE-STATEMENT~
  disable unless-hidden~
    S_Artikel.VerteilerGruppe~
    S_Artikel.SBM_ValueFlowGroup_Obj~
    S_Artikel.ArtikelGruppe~
    S_Artikel.Sparte~
    S_Artikel.Bild~
    S_Artikel.ABC_Klasse~
    S_Artikel.DIN_ISO~
    S_Artikel.P_ReverseCharge~
    S_Artikel.LagerME~
    S_Artikel.IsPackagingUnitToStock~
    S_Artikel.SME_Faktor~
    S_Artikel.LagerGewicht~
    S_Artikel.GewichtBestaetigt~
    S_Artikel.GewichtME~
    S_Artikel.Gewicht~
    S_Artikel.StkME~
    S_Artikel.StkFaktor~
    btnBild~
    glSRMFlag~
    with frame {&Frame-Name}.
/*****
</STATEMENTS> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Konfiguration" V-table-Win _INLINE
/* Actions: ? adm/support/proc/ds_viw06.w ? ? ? */
/* STRUCTURED-DATA
<BUILD-INFORMATION>
</BUILD-INFORMATION>
<STATEMENTS>
*****/
/*****
</STATEMENTS> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "InfoFields" V-table-Win _INLINE
/* Actions: ? ? ? ? adm/support/proc/ds_inf01.p */
/* STRUCTURED-DATA
<Build-Information>
1.02
</Build-Information>
<InfoFields>
S_Artikel.Sparte|Text|basis.S_SparteSpr.Bezeichnung|S_SparteSpr.Firma = {firma/ssparte.fir pa-Firma};S_SparteSpr.Sparte = input frame {&Frame-Name} S_Artikel.Sparte|S_Artikel_Sparte_Info
S_Artikel.LagerME|Text|basis.S_MengenEinheitSpr.KurzBez|S_MengenEinheitSpr.Firma = {firma/smngeinh.fir pa-Firma};S_MengenEinheitSpr.Mengeneinheit = input frame {&Frame-Name} S_Artikel.LagerME|S_Artikel_LagerME_Info
S_Artikel.GewichtME|Text|basis.S_MengenEinheitSpr.KurzBez|S_MengenEinheitSpr.Firma = {firma/smngeinh.fir pa-Firma};S_MengenEinheitSpr.MengenEinheit = input frame {&Frame-Name} S_Artikel.GewichtME|S_Artikel_GewichtME_Info
S_Artikel.ArtikelGruppe|Text|Basis.S_ArtGruppeSpr.Bezeichnung|S_ArtGruppeSpr.Firma = {firma/sartgrp.fir pa-Firma};S_ArtGruppeSpr.ArtikelGruppe = input frame {&Frame-Name} S_Artikel.ArtikelGruppe|S_Artikel_ArtikelGruppe_Info
S_Artikel.SBM_ValueFlowGroup_Obj|OIDReplacement|DBM_ShortDescription.ShortDesc1|SBM_ValueFlowGroup_Obj|S_ArtiBM_ValueFlowGroup_Obj_Info
S_Artikel.VerteilerGruppe|Workgroup|pa-Firma;'S_A':U||S_Artikel_VerteilerGruppe_Info
S_Artikel.StkME|Text|basis.S_MengenEinheitSpr.KurzBez|S_MengenEinheitSpr.Firma = {firma/smngeinh.fir pa-Firma};S_MengenEinheitSpr.MengenEinheit = input frame {&Frame-Name} S_Artikel.StkME|S_Artikel_StkME_Info
</InfoFields>
<Constants>
***/
&SCOP PA-INFOFIELDS YES
&SCOP PA-OIDINFOFIELDS     S_Artikel.SBM_ValueFlowGroup_Obj
&SCOP PA-OIDINFOVARIABLES  S_ArtiBM_ValueFlowGroup_Obj_Info
&SCOP PA-OIDINFOTARGETS    DBM_ShortDescription.ShortDesc1
&SCOP PA-OIDINFOBASEFIELDS SBM_ValueFlowGroup_Obj
/***
</Constants> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Dynamic InfoFields" V-table-Win _INLINE
/* Actions: ? ? ? ? adm/support/proc/ds_viw09.p */

&SCOPED-DEFINE pa-UpdateHiddenScreenvalues ~
  assign~
    S_Artikel.SBM_ValueFlowGroup_Obj:screen-value in frame {&FRAME-NAME} = (if available S_Artikel then S_Artikel.SBM_ValueFlowGroup_Obj else '':U)~
    S_Artikel.ABC_Klasse:screen-value in frame {&FRAME-NAME} = (if available S_Artikel then string(S_Artikel.ABC_Klasse, 'x':U) else '':U)~
    .
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Skin Client Support" V-table-Win _INLINE
/* Actions: ? ? ? ? adm/support/proc/ds_skc00.p */

&SCOPED-DEFINE pa-DisplaySkinClientWidgets ~
  if not S_Artikel.ABC_Klasse:hidden in frame ~{&FRAME-NAME~} then dynamic-function('pa_cUISvcSetWidgetAttribute':U in target-procedure, S_Artikel.ABC_Klasse:handle, 'screen-value':U, (if available S_Artikel then S_Artikel.ABC_Klasse else '':U)).

&SCOPED-DEFINE pa-AssignSkinClientWidgets ~
  assign ~
    S_Artikel.ABC_Klasse = dynamic-function('pa_cUISvcGetWidgetAssignValue':U in target-procedure, S_Artikel.ABC_Klasse:handle in frame ~{&FRAME-NAME~}, (if available S_Artikel then S_Artikel.ABC_Klasse else '':U)) ~
    .
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD pa_lUISvcObjectState V-table-Win 
FUNCTION pa_lUISvcObjectState returns logical
  ( pcStateCode as character )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON btnBild  NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE Gewicht_ME_Info AS CHARACTER FORMAT "X(3)":U INITIAL "kg":U
     VIEW-AS FILL-IN 
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE LagerGewicht_ME_Info AS CHARACTER FORMAT "X(3)":U INITIAL "kg":U
     VIEW-AS FILL-IN 
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE S_ArtiBM_ValueFlowGroup_Obj_Info AS CHARACTER FORMAT "x(80)":U 
     VIEW-AS FILL-IN 
     SIZE 28 BY 1 NO-UNDO.

DEFINE VARIABLE S_Artikel_ArtikelGruppe_Info AS CHARACTER FORMAT "x(30)":U 
     VIEW-AS FILL-IN 
     SIZE 28 BY 1 NO-UNDO.

DEFINE VARIABLE S_Artikel_GewichtME_Info AS CHARACTER FORMAT "x(3)":U 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE S_Artikel_LagerME_Info AS CHARACTER FORMAT "x(3)":U 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE S_Artikel_SME_Faktor_Info AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE S_Artikel_Sparte_Info AS CHARACTER FORMAT "x(30)":U 
     VIEW-AS FILL-IN 
     SIZE 28 BY 1 NO-UNDO.

DEFINE VARIABLE S_Artikel_StkME_Info AS CHARACTER FORMAT "x(3)":U 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE S_Artikel_VerteilerGruppe_Info AS CHARACTER FORMAT "x(30)":U 
     VIEW-AS FILL-IN 
     SIZE 28 BY 1 NO-UNDO.

DEFINE VARIABLE glSRMFlag AS LOGICAL INITIAL no 
     LABEL "Export SRM":T18 
     VIEW-AS TOGGLE-BOX
     SIZE 26.5 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     btnBild AT ROW 6 COL 58
     S_Artikel.VerteilerGruppe AT ROW 1 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY 1
     S_Artikel.SBM_ValueFlowGroup_Obj AT ROW 2.5 COL 21 COLON-ALIGNED
          LABEL ""
          VIEW-AS FILL-IN 
          SIZE 11 BY 1
     S_Artikel.ArtikelGruppe AT ROW 3.5 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY 1
     S_Artikel.Sparte AT ROW 4.5 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY 1
     S_Artikel.Bild AT ROW 6 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 34 BY 1
     S_Artikel.ABC_Klasse AT ROW 7.5 COL 21 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Item 1" 
          DROP-DOWN-LIST
          SIZE 24 BY 1
     S_Artikel.DIN_ISO AT ROW 8.5 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 24 BY 1
     glSRMFlag AT ROW 9.5 COL 23
     S_Artikel.P_ReverseCharge AT ROW 10.5 COL 23
          VIEW-AS TOGGLE-BOX
          SIZE 20 BY .79
     S_Artikel_VerteilerGruppe_Info AT ROW 1 COL 32 COLON-ALIGNED NO-LABEL
     S_ArtiBM_ValueFlowGroup_Obj_Info AT ROW 2.5 COL 32 COLON-ALIGNED NO-LABEL
     S_Artikel_ArtikelGruppe_Info AT ROW 3.5 COL 32 COLON-ALIGNED NO-LABEL
     S_Artikel_Sparte_Info AT ROW 4.5 COL 32 COLON-ALIGNED NO-LABEL
     S_Artikel.LagerME AT ROW 1 COL 81 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4 BY 1
     S_Artikel.IsPackagingUnitToStock AT ROW 2 COL 83
          VIEW-AS TOGGLE-BOX
          SIZE 24 BY 1
     S_Artikel.SME_Faktor AT ROW 3 COL 81 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY 1
     S_Artikel.LagerGewicht AT ROW 4 COL 81 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY 1
     S_Artikel.GewichtBestaetigt AT ROW 5 COL 83
          VIEW-AS TOGGLE-BOX
          SIZE 24 BY 1
     S_Artikel.GewichtME AT ROW 6.5 COL 81 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4 BY 1
     S_Artikel.Gewicht AT ROW 7.5 COL 81 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY 1
     S_Artikel.StkME AT ROW 9 COL 81 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4 BY 1
     S_Artikel.StkFaktor AT ROW 10 COL 81 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY 1
     S_Artikel_LagerME_Info AT ROW 1 COL 85 COLON-ALIGNED NO-LABEL
     S_Artikel_GewichtME_Info AT ROW 6.5 COL 85 COLON-ALIGNED NO-LABEL
     S_Artikel_StkME_Info AT ROW 9 COL 85 COLON-ALIGNED NO-LABEL
     S_Artikel_SME_Faktor_Info AT ROW 3 COL 101 COLON-ALIGNED NO-LABEL
     LagerGewicht_ME_Info AT ROW 4 COL 101 COLON-ALIGNED NO-LABEL
     Gewicht_ME_Info AT ROW 7.5 COL 101 COLON-ALIGNED NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: basis.S_Artikel
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 10.46
         WIDTH              = 124.67.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{adm/method/incl/dm_viw01.lib}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R,COLUMNS                    */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON btnBild IN FRAME F-Main
   4                                                                    */
/* SETTINGS FOR FILL-IN Gewicht_ME_Info IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX glSRMFlag IN FRAME F-Main
   4                                                                    */
/* SETTINGS FOR FILL-IN LagerGewicht_ME_Info IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN S_ArtiBM_ValueFlowGroup_Obj_Info IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN S_Artikel_ArtikelGruppe_Info IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN S_Artikel_GewichtME_Info IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN S_Artikel_LagerME_Info IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN S_Artikel_SME_Faktor_Info IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN S_Artikel_Sparte_Info IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN S_Artikel_StkME_Info IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN S_Artikel_VerteilerGruppe_Info IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN S_Artikel.SBM_ValueFlowGroup_Obj IN FRAME F-Main
   EXP-LABEL                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME S_Artikel.ArtikelGruppe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL S_Artikel.ArtikelGruppe V-table-Win
ON leave OF S_Artikel.ArtikelGruppe IN FRAME F-Main /* Teilegruppe */
do:
  {adm/template/incl/dt_uit00.if
     &UserExitName = "ON_LEAVE_OF_S_Artikel_ArtikelGruppe"}

  {adm/template/incl/dt_viw03.if}

  run set-link-attribute (this-procedure,
                          'container-source':U,
                          'ProductLine=':U + quoter(input frame {&FRAME-NAME} S_Artikel.ArtikelGruppe)).

  {adm/template/incl/dt_uit01.if
     &UserExitName = "ON_LEAVE_OF_S_Artikel_ArtikelGruppe"}
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnBild
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnBild V-table-Win
ON choose OF btnBild IN FRAME F-Main
do:

  /* Variables ---------------------------------------------------------------*/
  /*--------------------------------------------------------------------------*/

  define variable cNeuesBild    as character   no-undo.
  define variable cPicDir       as character   no-undo.
  define variable lUpdate       as logical     no-undo.
  define variable cFilename     as character   no-undo.
  define variable cBasePath     as character   no-undo.
  define variable lLocationOK   as logical     no-undo.
  define variable lPathLengthOK as logical     no-undo.
  define variable iMaxPathLen   as integer     no-undo.

  /* Buffers -----------------------------------------------------------------*/

  /*--------------------------------------------------------------------------*/
  /* Processing                                                               */
  /*--------------------------------------------------------------------------*/

  /* load the complete path of the currently stored picture information. You  */
  /* do not need to transform the BACKSLASH to SLASH, because it will be done */
  /* implicitly by the function 'cOpSysPathFromPath'.                         */

  {adm/template/incl/dt_uit00.if
     &UserExitName = "ON_CHOOSE_OF_btnBild"}

  assign
    cBasePath = pACStartupSvc:cParameterValue('PicDir':U)
    cPicDir   = adm.method.cls.DMCOpSysSvc:cConcatPath
                  (cBasePath,
                   adm.method.cls.DMCOpSysSvc:cDirectoryFromPath
                     (S_Artikel.Bild))
    cPicDir   = adm.method.cls.DMCOpSysSvc:cOpSysPathFromPath(cPicDir)
    .

  /* load plain filename of the currently stored picture information          */

  cNeuesBild = adm.method.cls.DMCOpSysSvc:cFileNameFromPath(S_Artikel.Bild).

  /* now call the operation systems native file dialog with the initial       */
  /* information determined above                                             */

  {adm/incl/d__os_00.if
    &P_CHARACTER-FIELD    = "cNeuesBild"
    &P_TITLE              = "'Teile Bild auswählen':T60"
    &P_CREATE-TEST-FILE   = "yes"
    &P_USE-FILENAME       = "yes"
    &P_FILTERS            = "{&pa_S_FileFilterPictures}"
    &P_DEFAULT-EXTENSION  = "'*.jpg':U"
    &P_ASK-OVERWRITE      = "yes"
    &P_INITIAL-DIR        = "cPicDir"
    &P_UPDATE             = "lUpdate"
    &P_SUPREME-DIR        = "cBasePath"
    &P_SHOW-FILE-EXPLORER = "yes"
  }

  if lUpdate then  /* if not cancel/abbrechen was selected */
  do:

    assign

      /* base path does not have a valid operation system path structure yet  */

      cBasePath  = adm.method.cls.DMCOpSysSvc:cOpSysPathFromPath(cBasePath)

      cBasePath  = replace (cBasePath,{&PA-BACKSLASH},'/':U)
      cNeuesBild = replace (cNeuesBild,{&PA-BACKSLASH},'/':U)

      /* get the file name of the new entered file                            */

      cFilename = left-trim(substring (cNeuesBild, length(cBasePath) + 1), '/':U)
      .

    /* perform checks on the new entered file and directory information:      */
    /* 1) check if the file is stored in the picture path defined in the      */
    /*    startup configuration                                               */
    /* 2) the length of the filename has to be small or equal to the maximum  */
    /*    displayable chracters depnding on the display format of the         */
    /*    DB-field                                                            */

    assign
      iMaxPathLen   = integer(substring((S_Artikel.Bild:format in frame {&FRAME-NAME}),3,2))
      lLocationOK   = cNeuesBild begins cBasePath
      lPathLengthOK = length(cFilename) <= iMaxPathLen
      .

    /* Die Datei &1 liegt nicht in dem erwarteten Verzeichnis &2.
       Legen sie die Datei in &2 ab. */

    if not lLocationOK then
      adm.method.cls.DMCMessageSvc:prpoInstance:showError
        ('p_zei00005':U,
         cFilename,
         cBasePath).

    /* Der Pfad und Namen der Datei '&1' ist zu lang.
       Verwenden sie einen kürzeren Dateipfad oder Dateinamen.
       Die maximal mögliche Länge beträgt &2 Zeichen. */

    if not lPathLengthOK then
      adm.method.cls.DMCMessageSvc:prpoInstance:showError
        ('p_zei00007':U,
         cFilename,
         string(iMaxPathLen)).

    /* all checks passed, new filename is valid                               */
    /*   --> assign it to the screen value                                    */

    if     lLocationOK
       and lPathLengthOK then
      {setwidgetattr S_Artikel.Bild screen-value cFilename}.

    run pa_UISvcApplyEventToWidgetByHandle
          ('entry':U,
           S_Artikel.Bild:handle in frame {&FRAME-NAME}).

  end. /* lUpdate */

  {adm/template/incl/dt_uit01.if
     &UserExitName = "ON_CHOOSE_OF_btnBild"}
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME S_Artikel.GewichtME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL S_Artikel.GewichtME V-table-Win
ON leave OF S_Artikel.GewichtME IN FRAME F-Main /* Gewicht ME */
do:
  {adm/template/incl/dt_uit00.if
     &UserExitName = "ON_LEAVE_OF_S_Artikel_GewichtME"}

  {adm/template/incl/dt_viw03.if}

  {adm/template/incl/dt_uit01.if
     &UserExitName = "ON_LEAVE_OF_S_Artikel_GewichtME"}
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME S_Artikel.IsPackagingUnitToStock
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL S_Artikel.IsPackagingUnitToStock V-table-Win
ON VALUE-CHANGED OF S_Artikel.IsPackagingUnitToStock IN FRAME F-Main /* VME lagergeführt */
DO:

  /* it is not allowed to change the Toggle to no if there is on hand in      */
  /* sales Unit of Measure                                                    */

  {adm/template/incl/dt_uit00.if
     &UserExitName = "ON_VALUE-CHANGED_OF_S_Artikel_IsPackagingUnitToStock"}

  if S_Artikel.IsPackagingUnitToStock:checked in frame {&frame-name} = no
    and can-find (first MLA_OnHand
                    where MLA_OnHand.Company  = pACConnectionSvc:prpcCompany
                      and MLA_OnHand.Part     = S_Artikel.Artikel
                      and can-find (first MLA_SalesUnitOnhand
                                      where MLA_SalesUnitOnHand.Company         = pACConnectionSvc:prpcCompany
                                        and MLA_SalesUnitOnHand.MLA_OnHand_Obj  = MLA_OnHand.MLA_OnHand_Obj
                                        and MLA_SalesUnitOnHand.QtyUnit         <> S_Artikel.LagerME)) then
  do:

   {setwidgetattr S_Artikel.IsPackagingUnitToStock checked yes "in frame {&frame-name}"}.

   {fnarg
     pa_lUISvcDisableWidget
     "S_Artikel.IsPackagingUnitToStock:handle in frame {&frame-name}"}.

   end.

  {adm/template/incl/dt_uit01.if
     &UserExitName = "ON_VALUE-CHANGED_OF_S_Artikel_IsPackagingUnitToStock"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME S_Artikel.LagerME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL S_Artikel.LagerME V-table-Win
ON leave OF S_Artikel.LagerME IN FRAME F-Main /* LagerME */
do:
  {adm/template/incl/dt_uit00.if
     &UserExitName = "ON_LEAVE_OF_S_Artikel_LagerME"}

  {adm/template/incl/dt_viw03.if}

  {adm/template/incl/dt_uit01.if
     &UserExitName = "ON_LEAVE_OF_S_Artikel_LagerME"}
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME S_Artikel.Sparte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL S_Artikel.Sparte V-table-Win
ON leave OF S_Artikel.Sparte IN FRAME F-Main /* Sparte */
do:
  {adm/template/incl/dt_uit00.if
     &UserExitName = "ON_LEAVE_OF_S_Artikel_Sparte"}

  {adm/template/incl/dt_viw03.if}

  {adm/template/incl/dt_uit01.if
     &UserExitName = "ON_LEAVE_OF_S_Artikel_Sparte"}
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME S_Artikel.StkME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL S_Artikel.StkME V-table-Win
ON LEAVE OF S_Artikel.StkME IN FRAME F-Main /* StücklistenME */
do:
  {adm/template/incl/dt_uit00.if
     &UserExitName = "ON_LEAVE_OF_S_Artikel_StkME"}

  {adm/template/incl/dt_viw03.if}

  {adm/template/incl/dt_uit01.if
     &UserExitName = "ON_LEAVE_OF_S_Artikel_StkME"}
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME S_Artikel.VerteilerGruppe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL S_Artikel.VerteilerGruppe V-table-Win
ON leave OF S_Artikel.VerteilerGruppe IN FRAME F-Main /* Verteilergruppe */
do:  {adm/template/incl/dt_viw03.if}
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  /* DIREKTE ZUWEISUNG WG PROBLEMEN MIT ÜBERSETZUNGSATTRIBUTEN */

 {setwidgetattr 
    S_Artikel.ABC_Klasse 
    list-items 
    "adm.config.cls.DCCAppConfigSvc:prpoInstance:cParameterValue('SA_ABCClass_desc':U,',':U)"}.

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN
    run dispatch in THIS-PROCEDURE ('initialize':U).
  &ENDIF

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  adm/support/proc/ds_rec00.p
PROCEDURE adm-row-available :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Dispatched to this procedure when the Record-Source has a new row          */
/* available.  This procedure tries to get the new row (or foreign keys)      */
/* from the  Record-Source and process it.                                    */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* <none>                                                                     */
/*                                                                            */
/*----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Define variables needed by this internal procedure.                        */

{adm/template/incl/row-head.i}

/* Create a list of all the tables that we need to get.                       */

{adm/template/incl/row-list.i "S_Artikel"}

/* Get the record ROWID's from the RECORD-SOURCE.                             */

{adm/template/incl/row-get.i}

/* FIND each record specified by the RECORD-SOURCE.                           */

{adm/template/incl/row-find.i "S_Artikel"}

/* Process the newly available records (i.e. display fields, open queries,    */
/* and/or pass records on to any RECORD-TARGETS).                             */

{adm/template/incl/row-end.i}

end procedure. /* adm-row-available */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE display-InfoFields V-table-Win  adm/support/proc/ds_inf02.p
PROCEDURE display-InfoFields :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Display Infofields                                                         */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* pcFields    list of fields to display                                      */
/*                                                                            */
/*----------------------------------------------------------------------------*/

define input        parameter pcFields as character     no-undo.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

do with frame {&Frame-Name}:

  if can-do(pcFields,'S_Artikel.Sparte':U) then
    if S_Artikel_Sparte_Info:private-data <> S_Artikel.Sparte:screen-value then
    do:

      if input frame {&Frame-Name} S_Artikel.Sparte = '':U then
      
        assign
          {setwidgetattr
             "S_Artikel_Sparte_Info"
             "private-data"
             "'':U"}
          {setwidgetattr
             "S_Artikel_Sparte_Info"
             "screen-value"
             "'':U"}
          S_Artikel_Sparte_Info
          .

      else
      do:

        {adm/incl/d__spr00.if
          &Tabelle  = "S_SparteSpr"
          &Selekt   = "where S_SparteSpr.Firma = {firma/ssparte.fir pa-Firma}
                         and S_SparteSpr.Sparte = input frame {&Frame-Name} S_Artikel.Sparte"
          &no-error = "no-error"}

        if available S_SparteSpr then
          assign
            {setwidgetattr
               "S_Artikel_Sparte_Info"
               "private-data"
               "S_Artikel.Sparte:screen-value"}
            S_Artikel_Sparte_Info = S_SparteSpr.Bezeichnung
            .
        else
          assign
            {setwidgetattr
               "S_Artikel_Sparte_Info"
               "private-data"
               "string(?)"}
            S_Artikel_Sparte_Info = '':U
            .

        {setwidgetattr
           "S_Artikel_Sparte_Info"
           "screen-value"
           "S_Artikel_Sparte_Info"}.

      end.

    end.

  if can-do(pcFields,'S_Artikel.LagerME':U) then
      if S_Artikel_LagerME_Info:private-data <> S_Artikel.LagerME:screen-value then
      do:

      if input frame {&Frame-Name} S_Artikel.LagerME = '':U then
      
        assign
          {setwidgetattr
             "S_Artikel_LagerME_Info"
             "private-data"
             "'':U"}
          {setwidgetattr
             "S_Artikel_LagerME_Info"
             "screen-value"
             "'':U"}
          S_Artikel_LagerME_Info
          .

      else
      do:

        S_Artikel_LagerME_Info
          = {fnarg
              pa_cDyCchUnitOfMeasureDesc
              "pa-Firma,
               input frame {&Frame-Name} S_Artikel.LagerME,
               pa-Sprache,
               {&pa_CchShortCut}"}.
        
        if S_Artikel_LagerME_Info <> ? then
          {setwidgetattr
             "S_Artikel_LagerME_Info"
             "private-data"
             "S_Artikel.LagerME:screen-value"}.
        
        else
          assign
            {setwidgetattr
               "S_Artikel_LagerME_Info"
               "private-data"
               "string(?)"}
        
            S_Artikel_LagerME_Info = '':U
            .
        
        {setwidgetattr
           "S_Artikel_LagerME_Info"
           "screen-value"
           "S_Artikel_LagerME_Info"}.

      end.

    end.

  if can-do(pcFields,'S_Artikel.GewichtME':U) then
      if S_Artikel_GewichtME_Info:private-data <> S_Artikel.GewichtME:screen-value then
      do:

      if input frame {&Frame-Name} S_Artikel.GewichtME = '':U then
      
        assign
          {setwidgetattr
             "S_Artikel_GewichtME_Info"
             "private-data"
             "'':U"}
          {setwidgetattr
             "S_Artikel_GewichtME_Info"
             "screen-value"
             "'':U"}
          S_Artikel_GewichtME_Info
          .

      else
      do:

        S_Artikel_GewichtME_Info
          = {fnarg
              pa_cDyCchUnitOfMeasureDesc
              "pa-Firma,
               input frame {&Frame-Name} S_Artikel.GewichtME,
               pa-Sprache,
               {&pa_CchShortCut}"}.
        
        if S_Artikel_GewichtME_Info <> ? then
          {setwidgetattr
             "S_Artikel_GewichtME_Info"
             "private-data"
             "S_Artikel.GewichtME:screen-value"}.
        
        else
          assign
            {setwidgetattr
               "S_Artikel_GewichtME_Info"
               "private-data"
               "string(?)"}
        
            S_Artikel_GewichtME_Info = '':U
            .
        
        {setwidgetattr
           "S_Artikel_GewichtME_Info"
           "screen-value"
           "S_Artikel_GewichtME_Info"}.

      end.

    end.

  if can-do(pcFields,'S_Artikel.ArtikelGruppe':U) then
      if S_Artikel_ArtikelGruppe_Info:private-data <> S_Artikel.ArtikelGruppe:screen-value then
      do:

      if input frame {&Frame-Name} S_Artikel.ArtikelGruppe = '':U then
      
        assign
          {setwidgetattr
             "S_Artikel_ArtikelGruppe_Info"
             "private-data"
             "'':U"}
          {setwidgetattr
             "S_Artikel_ArtikelGruppe_Info"
             "screen-value"
             "'':U"}
          S_Artikel_ArtikelGruppe_Info
          .

      else
      do:

        S_Artikel_ArtikelGruppe_Info
          = {fnarg
              pa_cDyCchProductLineDesc
              "pa-Firma,
               input frame {&Frame-Name} S_Artikel.ArtikelGruppe,
               pa-Sprache"}.
        
        if S_Artikel_ArtikelGruppe_Info <> ? then
          {setwidgetattr
             "S_Artikel_ArtikelGruppe_Info"
             "private-data"
             "S_Artikel.ArtikelGruppe:screen-value"}.
        
        else
          assign
            {setwidgetattr
               "S_Artikel_ArtikelGruppe_Info"
               "private-data"
               "string(?)"}
            S_Artikel_ArtikelGruppe_Info = '':U
            .
        
        {setwidgetattr
           "S_Artikel_ArtikelGruppe_Info"
           "screen-value"
           "S_Artikel_ArtikelGruppe_Info"}.

      end.

    end.

  if can-do(pcFields,'S_Artikel.VerteilerGruppe':U) then
    if    available S_Artikel
      and S_Artikel_VerteilerGruppe_Info:private-data <> S_Artikel.VerteilerGruppe:screen-value then
      assign
        {setwidgetattr
           "S_Artikel_VerteilerGruppe_Info"
           "private-data"
           "S_Artikel.VerteilerGruppe:screen-value"}
        S_Artikel_VerteilerGruppe_Info              = basis.buro.cls.BBCWorkflowSvc:prpoInstance:cWorkgroupDescription
                                                        (pa-Firma,
                                                         'S_A':U,
                                                         S_Artikel.VerteilerGruppe:screen-value)
        {setwidgetattr
           "S_Artikel_VerteilerGruppe_Info"
           "screen-value"
           "S_Artikel_VerteilerGruppe_Info"}
        .
    else if not available S_Artikel then
      assign
        {setwidgetattr
           "S_Artikel_VerteilerGruppe_Info"
           "private-data"
           "string(?)"}
        S_Artikel_VerteilerGruppe_Info              = '':U
        {setwidgetattr
            "S_Artikel_VerteilerGruppe_Info"
            "screen-value"
            "'':U"}
        .

  if can-do(pcFields,'S_Artikel.StkME':U) then
      if S_Artikel_StkME_Info:private-data <> S_Artikel.StkME:screen-value then
      do:

      if input frame {&Frame-Name} S_Artikel.StkME = '':U then
      
        assign
          {setwidgetattr
             "S_Artikel_StkME_Info"
             "private-data"
             "'':U"}
          {setwidgetattr
             "S_Artikel_StkME_Info"
             "screen-value"
             "'':U"}
          S_Artikel_StkME_Info
          .

      else
      do:

        S_Artikel_StkME_Info
          = {fnarg
              pa_cDyCchUnitOfMeasureDesc
              "pa-Firma,
               input frame {&Frame-Name} S_Artikel.StkME,
               pa-Sprache,
               {&pa_CchShortCut}"}.
        
        if S_Artikel_StkME_Info <> ? then
          {setwidgetattr
             "S_Artikel_StkME_Info"
             "private-data"
             "S_Artikel.StkME:screen-value"}.
        
        else
          assign
            {setwidgetattr
               "S_Artikel_StkME_Info"
               "private-data"
               "string(?)"}
        
            S_Artikel_StkME_Info = '':U
            .
        
        {setwidgetattr
           "S_Artikel_StkME_Info"
           "screen-value"
           "S_Artikel_StkME_Info"}.

      end.

    end.

end. /* do with frame */

/* User Exits */

{&{&PA-XBasisName}_C_Display-InfoFields}
{&{&PA-XBasisName}_U_Display-InfoFields}
{&{&PA-XBasisName}_Q_Display-InfoFields}
{&{&PA-XBasisName}_Display-InfoFields}
{&{&PA-XBasisName}_Y_Display-InfoFields}

return.

end procedure. /* display-InfoFields */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-ProductLine V-table-Win 
PROCEDURE get-ProductLine :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Return attribute ProductLine                                               */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* <none>                                                                     */
/*                                                                            */
/* Examples ------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/*----------------------------------------------------------------------------*/

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

return input frame {&FRAME-NAME} S_Artikel.Artikelgruppe.

end procedure. /* get-ProductLine */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Super Override                                                             */
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

/* Code placed here will execute PRIOR to standard behavior ------------------*/


/* warn if file-extension is not in list of supported extensions */

if     S_Artikel.Bild:screen-value in frame {&FRAME-NAME} <> '':U
   and not can-do({&pa_bj_GraphicPrintFormats},
                  adm.method.cls.DMCOpSysSvc:cFileExtensionFromPath
                    (S_Artikel.Bild:screen-value in frame {&FRAME-NAME})) then

  /* Das hinterlegte Bild '&1' hat eine ungültige Erweiterung '&2'.
     Druckbare Bildformate sind '&3'.
     Stellen Sie sicher, dass das hinterlegte Bild eine gültige Erweiterung besitzt. */

  adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
    ('s_pic00003':U,
     S_Artikel.Bild:screen-value in frame {&FRAME-NAME},
     adm.method.cls.DMCOpSysSvc:cFileExtensionFromPath
       (S_Artikel.Bild:screen-value in frame {&FRAME-NAME}),
     {&pa_bj_GraphicPrintFormats}).

/* Execute standard behavior -------------------------------------------------*/

run dispatch('assign-record':U).

/* Code placed here will execute AFTER standard behavior ---------------------*/

end procedure. /* local-assign-record */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Super Override                                                             */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* <none>                                                                     */
/*                                                                            */
/* Examples ------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/*----------------------------------------------------------------------------*/

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Code placed here will execute PRIOR to standard behavior ------------------*/

/* Execute standard behavior -------------------------------------------------*/

run dispatch('assign-statement':U).

/* Code placed here will execute AFTER standard behavior ---------------------*/

if    return-value <> 'ADM-ERROR':U 
  and glSRMFlag:screen-value in frame {&FRAME-NAME} <> glSRMFlag:private-data in frame {&FRAME-NAME} then
  stamm.base.cls.SBCMasterDataAddFlagSvc:prpoInstance:updateFlag
    (S_Artikel.S_Artikel_Obj,
     {&pa_SB_MasterDataAddFlagArea_SRM-Part},
     glSRMFlag:checked in frame {&FRAME-NAME}).

end procedure. /* local-assign-statement */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Super Override                                                             */
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

define buffer bS_ArtGruppe for S_ArtGruppe.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Code placed here will execute PRIOR to standard behavior. */

if available S_Artikel then

  find bS_ArtGruppe
    where bS_ArtGruppe.Firma         = {firma/sartgrp.fir pa-Firma}
      and bS_ArtGruppe.ArtikelGruppe = S_Artikel.ArtikelGruppe
    no-lock no-error.

if available bS_ArtGruppe then

  assign
    S_Artikel_SME_Faktor_Info = ({fnarg
                                   pa_cDyCchUnitOfMeasureDesc
                                   "pa-Firma,
                                    bS_ArtGruppe.StatistikME,
                                    pa-Sprache,
                                    {&pa_CchShortCut}"})
    S_Artikel_SME_Faktor_Info = (if S_Artikel_SME_Faktor_Info <> ? then
                                   S_Artikel_SME_Faktor_Info
                                 else
                                   '':U)
  .

else

  S_Artikel_SME_Faktor_Info = '':U.


glSRMFlag = (if available S_Artikel then
               stamm.base.cls.SBCMasterDataAddFlagSvc:prpoInstance:lIsAssigned
                 (S_Artikel.S_Artikel_Obj,
                  {&pa_SB_MasterDataAddFlagArea_SRM-Part})
             else
               no).

/* Dispatch standard ADM method.                             */

run dispatch in this-procedure ( 'display-fields':U ) .

/* Code placed here will execute AFTER standard behavior.    */

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Super Override                                                             */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* <none>                                                                     */
/*                                                                            */
/* Examples ------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/*----------------------------------------------------------------------------*/

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Code placed here will execute PRIOR to standard behavior ------------------*/

/* Execute standard behavior -------------------------------------------------*/

run dispatch('enable-fields':U).

/* Code placed here will execute AFTER standard behavior ---------------------*/

if return-value <> 'ADM-ERROR':U then
  {setwidgetattr
     "glSRMFlag"
     "private-data"
     "string(glSRMFlag:screen-value in frame {&FRAME-NAME})"
     "in frame {&FRAME-NAME}"}.

end procedure. /* local-enable-fields */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Super Override                                                             */
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

/* load icons */

adm.method.cls.DMCUISvc:lLoadIconImage(BtnBild:handle in frame {&FRAME-NAME},
                                       'icon_select_file':U).

/* Code placed here will execute PRIOR to standard behavior. */

/* Dispatch standard ADM method.                             */
run dispatch in this-procedure ( 'initialize':U ) .

/* Code placed here will execute AFTER standard behavior.    */

if return-value <> 'ADM-ERROR':U then
do:

  run set-attribute-list ('check-modified-all=yes':U).

  assign  
    gcInitialHelpString = adm.method.cls.DMCParameterStringSvc:cWriteValue
                            ('':U,
                             'Firma':U,
                             {firma/sartikel.fir pa-Firma})
    gcInitialHelpString = adm.method.cls.DMCParameterStringSvc:cWriteValue
                            (gcInitialHelpString,
                             'Bereich':U,
                             'S_A':U)
    .

  &IF LOOKUP("PP","{&PA-MODULE}") = 0 &THEN

    {fnarg
      pa_lUISvcSetWidgetHiddenState
      "S_Artikel.StKME:handle in frame {&FRAME-NAME},
      yes"}.

    {fnarg
      pa_lUISvcSetWidgetHiddenState
      "S_Artikel.StKFaktor:handle in frame {&FRAME-NAME},
      yes"}.

  &ENDIF

  &IF LOOKUP("M_Gebinde","{&PA-OPTIONEN}") = 0 &THEN

    {fnarg
      pa_lUISvcSetWidgetHiddenState
      "S_Artikel.IsPackagingUnitToStock:handle in frame {&FRAME-NAME},
      yes"}.

  &ENDIF

  &IF LOOKUP("SO","{&PA-MODULE}") = 0 &THEN

    {fnarg
      pa_lUISvcSetWidgetHiddenState
      "glSRMFlag:handle in frame {&frame-name},
       yes"}.

  &ELSE

    {fnarg
      pa_lUISvcSetWidgetSensitiveState
      "glSRMFlag:handle in frame {&FRAME-NAME},
       no"}.

  &ENDIF

  {fnarg
    pa_lUISvcSetWidgetHiddenState
    "S_Artikel.P_ReverseCharge:handle in frame {&frame-name},
     (pACConnectionSvc:prpcLocalization <> 'P':U)"}.

end.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Super Override                                                             */
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

/* Code placed here will execute PRIOR to standard behavior ------------------*/

/* Execute standard behavior -------------------------------------------------*/

run dispatch('row-available':U).

/* Code placed here will execute AFTER standard behavior ---------------------*/

if     return-value <> 'ADM-ERROR':U
   and available S_Artikel then

  run set-link-attribute (this-procedure,
                          'container-source':U,
                          'ProductLine=':U + quoter(S_Artikel.ArtikelGruppe)).

end procedure. /* local-row-available */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win  adm/support/proc/_key-snd.p
PROCEDURE send-key :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Sends a requested KEY value back to the calling SmartObject                */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* see adm/template/sndkytop.i                                                */
/*                                                                            */
/*----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Define variables needed by this internal procedure.                        */

{adm/template/incl/sndkytop.i}

/* Return the key value associated with each key case.                        */

{adm/template/incl/sndkycas.i "SBM_ValueFlowGroup_Obj" "S_Artikel" "SBM_ValueFlowGroup_Obj" " "}
{adm/template/incl/sndkycas.i "S_Artikel_Obj" "S_Artikel" "S_Artikel_Obj" " "}
{adm/template/incl/sndkycas.i "Driver_Obj" "S_Artikel" "Driver_Obj" " "}
{adm/template/incl/sndkycas.i "SBM_CustomsTariffNo_Obj" "S_Artikel" "SBM_CustomsTariffNo_Obj" " "}
{adm/template/incl/sndkycas.i "SBM_F_EcoCode_Obj" "S_Artikel" "SBM_F_EcoCode_Obj" " "}

/* Close the CASE statement and end the procedure.                            */

{adm/template/incl/sndkyend.i}

end procedure. /* send-key */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  adm/support/proc/ds_rec01.p
PROCEDURE send-records :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Send record ROWID's for all tables used by this file.                      */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* see template/incl/snd-head.i                                               */
/*                                                                            */
/*----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Define variables needed by this internal procedure.                        */

{adm/template/incl/snd-head.i}

/* For each requested table, put it's ROWID in the output list.               */

{adm/template/incl/snd-list.i "S_Artikel"}

/* Deal with any unexpected table requests before closing.                    */

{adm/template/incl/snd-end.i}

end procedure. /* send-records */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Handle state-changed messages                                              */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* p-issuer-hdl   Handle of calling object                                    */
/* p-state        new state                                                   */
/*                                                                            */
/* Examples ------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/*----------------------------------------------------------------------------*/

define input        parameter p-issuer-hdl as handle        no-undo.
define input        parameter p-state      as character     no-undo.

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

case p-state:

  /* Object instance CASEs can go here to replace standard behavior           */
  /* or add new cases.                                                        */

  {adm/template/incl/dt_viw00.if}

end case.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE use-Gewicht V-table-Win 
PROCEDURE use-Gewicht :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* <none>                                                                     */
/*                                                                            */
/* Examples ------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/*----------------------------------------------------------------------------*/

define input parameter pcGewicht as char  no-undo.

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

{setwidgetattr 
   S_Artikel.LagerGewicht 
   screen-value pcGewicht 
   "in frame {&frame-name}"}.

end procedure. /* use-Gewicht */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION pa_lUISvcObjectState V-table-Win 
FUNCTION pa_lUISvcObjectState returns logical
  ( pcStateCode as character ) :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Extend implementation in dmcuis00.p                                        */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* pcStateCode State-Code to check                                            */
/*                                                                            */
/* Examples ------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/*----------------------------------------------------------------------------*/

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

&IF LOOKUP("M_Pack-Plus","{&PA-OPTIONEN}") > 0 &THEN
  define variable lM_LTPosAvailable as logical no-undo init no.
&ENDIF

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

case pcStateCode:

  when 'paSCisStorageAreaUnitOfMeasureChangeable':U then

    /* not changable if there is a quantity on stock */

    &IF LOOKUP("ML","{&PA-MODULE}") > 0  &THEN

      return not mawi.lager.cls.MLCOnHandInvSvc:prpoInstance:lIsOnHandAvailable
                  (S_Artikel.Artikel,
                   '':U,
                   '':U,
                   '':U).

    &ELSE
      return yes.
    &ENDIF

  when 'paSCisVariantTypeChangeable':U then
  do:

    &IF     "{&pa_S_Varianten}" = "1"
        AND LOOKUP("ML","{&PA-MODULE}") > 0 &THEN

        return not (   can-find(first MLL_Movements
                         where MLL_Movements.Company = pa-Firma
                           and MLL_Movements.Part    = S_Artikel.Artikel)
                    or can-find(first MLM_StorPartData
                        where MLM_StorPartData.Company  = pa-Firma
                          and MLM_StorPartData.Part     = S_Artikel.Artikel
                          and MLM_StorPartData.Archived = no
                          and MLM_StorPartData.ArtVar   > '':U )).
     &ELSE

        return no.

     &ENDIF

  end. /* when 'paSCisVariantTypeChangeable':U */

  when 'paSCisPackUnitToStockChangeable':U then
  do:

    &IF LOOKUP("M_Gebinde","{&PA-OPTIONEN}") > 0 &THEN

      &IF LOOKUP("M_Pack-Plus","{&PA-OPTIONEN}") > 0 &THEN
          
        for each ML_Ort
          where ML_Ort.Firma = {firma/mlort.fir pACConnectionSvc:prpcCompany}
        no-lock:
                  
          if can-find (first M_LTPos
                         where M_LTPos.Firma          = {firma/mlartort.fir pACConnectionSvc:prpcCompany}
                           and M_LTPos.Lagerort       = ML_Ort.Lagerort
                           and M_LTPos.Artikel        = S_Artikel.Artikel
                           and M_LTPos.MengenEinheit <> S_Artikel.LagerME) then
          do:
         
            lM_LTPosAvailable = yes.
            leave.
                        
          end. /* if can-find (first M_LTPos */
                                      
        end. /* for each ML_Ort */
                            
      &ENDIF
          
      return    available S_Artikel
            and can-do({&pa_M_PTList_StorageArea},string(S_Artikel.ArtikelArt))
            and not can-do({&pa_M_PTList_Packaging},string(S_Artikel.ArtikelArt))
            &IF LOOKUP("M_Pack-Plus","{&PA-OPTIONEN}") > 0 &THEN
              and not lM_LTPosAvailable
            &ENDIF
            and (   S_Artikel.IsPackagingUnitToStock = no
                 or not can-find (first MLA_OnHand
                                  where MLA_OnHand.Company  = pACConnectionSvc:prpcCompany
                                    and MLA_OnHand.Part     = S_Artikel.Artikel
                                    and can-find (first MLA_SalesUnitOnhand
                                                  where MLA_SalesUnitOnHand.Company         = pACConnectionSvc:prpcCompany
                                                    and MLA_SalesUnitOnHand.MLA_OnHand_Obj  = MLA_OnHand.MLA_OnHand_Obj
                                                    and MLA_SalesUnitOnHand.QtyUnit        <> S_Artikel.LagerME))).

    &ELSE

      return no.

    &ENDIF

  end.  /* when 'paSCisPackUnitToStockChangeable':U */

  when 'paSCisSRMFlagSensitive':U then
    &IF LOOKUP("SO","{&PA-MODULE}") = 0 &THEN
      return no.
    &ELSE
      return lookup('pAX-SRM-Parts:outgoing':U,pACConnectionSvc:prpcLicensedINWBMessageTypes) > 0.
    &ENDIF

  {&{&PA-XBasisName}_C_UISvcObjectState}
  {&{&PA-XBasisName}_U_UISvcObjectState}
  {&{&PA-XBasisName}_Q_UISvcObjectState}
  {&{&PA-XBasisName}_UISvcObjectState}
  {&{&PA-XBasisName}_Y_UISvcObjectState}

  otherwise
    return super(pcStateCode).

end case.

end function. /* pa_lUISvcObjectState */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

