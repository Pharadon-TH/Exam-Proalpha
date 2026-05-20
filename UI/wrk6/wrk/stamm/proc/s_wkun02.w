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
/*****************************************************************************/
/*                                  (c) 2023 proALPHA Business Solutions GmbH */
/*                                           Auf dem Immel 8                  */
/*                                           67685 Weilerbach                 */
/*                                                                           */
/*  Projekt....: proALPHA                                                    */
/*                                                                           */
/*  Name.......: s_wkun02.w                                                  */
/*  Bereich....: STAMM/KERN                                                  */
/*                                                                           */
/*  erstellt am: 23.01.1997                                                  */
/*  Autor......: Werner Ernst                                                */
/*                                                                           */
/*  Version....: 9.3.0 vom 2022-02-04/Tsolakidis, Triantafyllos               */
/*                                                                           */
/*---------------------------------------------------------------------------*/
/*  AUFGABE                                                                  */
/*---------------------------------------------------------------------------*/
/*                                                                           */
/*  Kundenstamm Rechnungsparameter                                           */
/*                                                                           */
/*---------------------------------------------------------------------------*/
/*  ARGUMENTE/PARAMETER                                                      */
/*---------------------------------------------------------------------------*/
/*                                                                           */
/*  Name                Art Funktion/Inhalt                                  */
/*  ------------------- --- ------------------------------------------------ */
/*---------------------------------------------------------------------------*/
/*  ÄNDERUNGSPROTOKOLL                                                       */
/*---------------------------------------------------------------------------*/
/* 2016-07-07 Jörg Enke d600bdff780b8658585ccddbdef313b667e64cab              */
/*            D_-U-EXIT-006 User-Exits: Bereitstellung von "Q" User Exits (Ba */
/*            tchlauf)                                                        */
/* 2016-08-03 Jörg Pitzius 66af9c13360ae938b08085a818aaf97cdbdad3ab           */
/*            SB-E-STAX-066 Steuerfindung: Feld Euroland im Stamm ablösen dur */
/*            ch Staat                                                        */
/* 2019-01-24 Harald Hemmen f9061b8f5d2dcb58e8b656eef201ac8e0820fd78          */
/*            SB-E-LVPL-002 Integration Landesversion Polen in die 7.2b01     */
/* 2019-08-27 Hemmen, Harald ac3163a13823425bb7345ed1dbb33f2a35437321         */
/*            PA-5719: Italien2Standard: Übernahme Repositories, Konstanten,  */
/*            Programme (3)                                                   */
/*            PA-5723: Italien2Standard: Übernahme Programme                  */
/*            PA-5725: Italien2Standard: Übernahme Programme                  */
/*            PA-5726: Italien2Standard: Übernahme Programme                  */
/* 2019-10-25 proalpha_devtools 6dd7b63a9fc80da103878433b8365e44ff4f313f      */
/*            PA-7058: Korrektur Quellcode in AppBuilder Format               */
/* 2019-12-18 Bierich, Elisabeth cff2bf50c63439d4234a962b2ec85a27c14d812b     */
/*            PA-7192: Steuerfindung Indien                                   */
/*            PA-7193: Steuerfälle Indien: Anpassung der Fibu-Buchungen       */
/* 2020-04-06 Balg, Ursula 6da2a1a4c4d72f6424a40f113ed42630d6d6f044           */
/*            PA-10550: Stamm: Im Kundenstamm kann das Feld 'Staat' unter Rec */
/*            hnungsparameter geändert werden.                                */
/* 2020-04-23 Balg, Ursula a242db147c08957369ad5db68bbcbde35f46a47c           */
/*            PA-10909: Lieferant: Staat änderbar                             */
/* 2020-07-06 Weiler, Frank 90114a60d834052bac6d58f350f350cfb5b287ed          */
/*            PA-9204: Conversion of master data                              */
/* 2020-07-30 Ulrich, Holger 3e2d12b7d4ac7c5f5830424d879dcc63844ba058         */
/*            PA-12348: Tab Reihenfolge Stammdaten Kunde, Lieferant, Teile    */
/* 2021-01-06 Weiler, Frank 147375782d35c24ec5b3befcd991a5d25aa680d4          */
/*            HOUD-509: Webskin: Roboter Display III                          */
/* 2021-09-29 Weiler, Frank 5d607d89f24d6172a8f6a883411032df2a21dd77          */
/*            HOUD-788: pA ray: Batchlauf pa-DisplaySkinClientWidgets" und "p */
/*            a-AssignSkinClientWidgets"                                      */
/* 2021-10-21 Juzaitis, Martynas (ext.) 16f19feb2dfe36b8abb68a7ae57486886728dedb */
/*            PA-19471: WUP: Druck von Belegtexten in Abhängigkeit zum Land / */
/*             Ab Werkpreis                                                   */
/* 2022-01-11 Tsolakidis, Triantafyllos 4e6081d8c5dae458886f7e9b41232ccb407d9281 */
/*            HOUD-2644: Interface-Trigger: User Exit Includes und Fehlerhand */
/*            ling hinzufügen                                                 */
/* 2022-02-04 Tsolakidis, Triantafyllos a24198fdbd07f4780803689216fefe72fda920ae */
/*            HOUD-2919: Interface-Trigger: User Exit Includes und Fehlerhand */
/*            ling hinzufügen: Nur Einrückungen und Leerzeilen                */
/*****************************************************************************/

CREATE WIDGET-POOL.

/*---------------------------------------------------------------------------*/
/* Definitionen                                                              */
/*---------------------------------------------------------------------------*/

/* KONSTANTEN ---------------------------------------------------------------*/
/* Systemkonstanten **********************************************************/

&GLOBAL-DEFINE pa-Autor             Werner Ernst
&GLOBAL-DEFINE pa-Version           9.3.0
&GLOBAL-DEFINE pa-Datum             2022-02-04
&GLOBAL-DEFINE pa-Letzter           Tsolakidis, Triantafyllos

&GLOBAL-DEFINE pa-GenVersion       UIB
&GLOBAL-DEFINE pa-ProgrammTyp      SmartViewer
&GLOBAL-DEFINE pa-Template         adm/template/proc/dt_viw00.w
&GLOBAL-DEFINE pa-TemplateVersion  1.04

&GLOBAL-DEFINE pa-XBasisName       s_wkun02_w


/* lokale Konstanten *********************************************************/

&Scoped-define PA-HLP-FIELDNAMES Rechnung_an,Konzern,Verband,StGr_mit_St,~
StGr_ohne_St,StGrEU_mit_St,StGrEU_ohne_St,StGrAus_mit_St,StGrAus_ohne_St,~
CtrlGroupStateTax,CtrlGroupStateNoTax,P_Steuerregister
&Scoped-define PA-HLP-KEYNAMES Kunde,Kunde,Kunde,Steuergruppe,~
Steuergruppe,Steuergruppe,Steuergruppe,Steuergruppe,Steuergruppe,~
Steuergruppe,Steuergruppe,Steuerregister

&Scoped-define pa-FieldEnableStateCode S_Kunde.Kreditlimit_ueberwachen:!paSCisOnce-OnlyCustomer ~
S_Kunde.Rechnung_an:!paSCisOnce-OnlyCustomerWithInvoice ~
S_Kunde.Mahnempfaenger_Verband:paSCisDunningRecipient ~
S_Kunde.Kreditlimit:paSCisAdoptionOfCreditLine ~
giVerzug:paSCisArrearsHidden


/* EXTERNE DEFINITIONEN -----------------------------------------------------*/

{adm/template/incl/dt_viw00.df}


/* LOKALE OBJEKTE -----------------------------------------------------------*/
/* Variable ******************************************************************/
/*   Name               Funktion                                             */
/*   ------------------ ---------------------------------------------------- */
/*****************************************************************************/

/* Buffer ********************************************************************/

define Buffer Buf_S_Kunde for S_Kunde.

/* Work-/Temp-Tables *********************************************************/

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
&Scoped-define EXTERNAL-TABLES S_Kunde
&Scoped-define FIRST-EXTERNAL-TABLE S_Kunde


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR S_Kunde.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS S_Kunde.Konzern S_Kunde.Verband ~
S_Kunde.MembershipNoAssociation S_Kunde.Mahnempfaenger_Verband ~
S_Kunde.StGr_mit_ST S_Kunde.P_Steuerregister S_Kunde.StGr_ohne_ST ~
S_Kunde.StGrEU_mit_ST S_Kunde.StGrEU_ohne_ST S_Kunde.StGrAus_mit_ST ~
S_Kunde.StGrAus_ohne_ST S_Kunde.CtrlGroupStateTax ~
S_Kunde.CtrlGroupStateNoTax S_Kunde.Rechnungsintervall ~
S_Kunde.Rechnungskennzeichen S_Kunde.Rechnung_an S_Kunde.I_PECAccount ~
S_Kunde.OaPText 
&Scoped-define ENABLED-TABLES S_Kunde
&Scoped-define FIRST-ENABLED-TABLE S_Kunde
&Scoped-Define DISPLAYED-FIELDS S_Kunde.Konzern S_Kunde.Verband ~
S_Kunde.MembershipNoAssociation S_Kunde.Mahnempfaenger_Verband ~
S_Kunde.Staat S_Kunde.StGr_mit_ST S_Kunde.P_Steuerregister ~
S_Kunde.StGr_ohne_ST S_Kunde.StGrEU_mit_ST S_Kunde.StGrEU_ohne_ST ~
S_Kunde.StGrAus_mit_ST S_Kunde.StGrAus_ohne_ST S_Kunde.CtrlGroupStateTax ~
S_Kunde.CtrlGroupStateNoTax S_Kunde.Rechnungsintervall ~
S_Kunde.Rechnungskennzeichen S_Kunde.Rechnung_an S_Kunde.I_PECAccount ~
S_Kunde.OaPText 
&Scoped-define DISPLAYED-TABLES S_Kunde
&Scoped-define FIRST-DISPLAYED-TABLE S_Kunde
&Scoped-Define DISPLAYED-OBJECTS gcStaatBez S_Kunde_Konzern_Info ~
S_Kunde_Verband_Info gcInvoiceRecipient S_Kunde_Rechnungsintervall_Info 

/* Custom List Definitions                                              */
/* PA-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,PA-UPDATE-VARS,PA-PROMPT-FIELDS,PA-SEARCH-FIELDS */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Konfiguration" V-table-Win _INLINE
/* Actions: ? adm/support/proc/ds_viw06.w ? ? ? */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "InfoFields" V-table-Win _INLINE
/* Actions: ? ? ? ? adm/support/proc/ds_inf01.p */
/* STRUCTURED-DATA
<Build-Information>
1.02
</Build-Information>
<Constants>
***/
&SCOP PA-INFOFIELDS YES
/***
</Constants>
<InfoFields>
S_Kunde.Rechnungsintervall|Text|Basis.S_RechIntSpr.Bezeichnung|S_RechIntSpr.Firma = {firma/srechint.fir pa-Firma};S_RechIntSpr.Rechnungsintervall = input frame {&Frame-Name} S_Kunde.Rechnungsintervall|S_Kunde_Rechnungsintervall_Info
S_Kunde.Verband|Text|basis.S_Verband.Bezeichnung|S_Verband.Firma = {firma/s_kunde.fir pa-Firma};S_Verband.Kunde = input frame {&FRAME-NAME} S_Kunde.Verband|S_Kunde_Verband_Info
S_Kunde.Konzern|Text|basis.S_Konzern.Bezeichnung|S_Konzern.Firma = {firma/s_kunde.fir pa-Firma};S_Konzern.Kunde = input frame {&FRAME-NAME} S_Kunde.Konzern|S_Kunde_Konzern_Info
</InfoFields> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Dynamic InfoFields" V-table-Win _INLINE
/* Actions: ? ? ? ? adm/support/proc/ds_viw09.p */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update Support" V-table-Win _INLINE
/* Actions: ? adm/support/proc/ds_sma00.w ? ? adm/support/proc/ds_viw00.p */
/* STRUCTURED-DATA
<ADDITIONAL-INFORMATION EDITABLE></ADDITIONAL-INFORMATION EDITABLE>

<CONSTANTS>
*****/
&SCOP ENABLED-TABLES S_Kunde
&SCOP FIRST-ENABLED-TABLE S_Kunde
&SCOP PA-FIRST-INITIAL-VALUES~
  S_Kunde.Firma = ~{firma/s_kunde.fir pa-Firma}~
  S_Kunde.Kunde = integer(entry(1,pa-external-keys,~{&pa-EOL}))
&SCOP PA-EXTERNAL-KEYS Kunde
&SCOP PA-FIRST-COMPARE~
  S_Kunde.Firma = ~{firma/s_kunde.fir pa-Firma}~
  and S_Kunde.Kunde = integer(entry(1,pa-external-keys,~{&pa-EOL}))
&SCOP PA-FIRST-EXCEPT-FIELDS {&PA-FIRST-EXCEPT-FIELDS} Firma Kunde AnlageBenutzer AnlageDatum AnlageZeit AenderungBenutzer AenderungDatum AenderungZeit S_Kunde_Obj

/*****
</CONSTANTS> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Search Support" V-table-Win _INLINE
/* Actions: ? adm/support/xedit.w ? ? adm/support/proc/ds_viw03.p */
/* STRUCTURED-DATA
<BUILD-INFORMATION>
1.09
</BUILD-INFORMATION>
<STATEMENTS>
*****/

&SCOP PA-FIELDS-ENABLE-STATEMENT~
  enable unless-hidden~
    S_Kunde.Konzern~
      when not can-do(pa-disabled-fields,'S_Kunde.Konzern':U)~
    S_Kunde.Verband~
      when not can-do(pa-disabled-fields,'S_Kunde.Verband':U)~
    S_Kunde.MembershipNoAssociation~
      when not can-do(pa-disabled-fields,'S_Kunde.MembershipNoAssociation':U)~
    S_Kunde.Mahnempfaenger_Verband~
      when not can-do(pa-disabled-fields,'S_Kunde.Mahnempfaenger_Verband':U)~
    S_Kunde.StGr_mit_ST~
      when not can-do(pa-disabled-fields,'S_Kunde.StGr_mit_ST':U)~
    S_Kunde.P_Steuerregister~
      when not can-do(pa-disabled-fields,'S_Kunde.P_Steuerregister':U)~
    S_Kunde.StGr_ohne_ST~
      when not can-do(pa-disabled-fields,'S_Kunde.StGr_ohne_ST':U)~
    S_Kunde.StGrEU_mit_ST~
      when not can-do(pa-disabled-fields,'S_Kunde.StGrEU_mit_ST':U)~
    S_Kunde.StGrEU_ohne_ST~
      when not can-do(pa-disabled-fields,'S_Kunde.StGrEU_ohne_ST':U)~
    S_Kunde.StGrAus_mit_ST~
      when not can-do(pa-disabled-fields,'S_Kunde.StGrAus_mit_ST':U)~
    S_Kunde.StGrAus_ohne_ST~
      when not can-do(pa-disabled-fields,'S_Kunde.StGrAus_ohne_ST':U)~
    S_Kunde.CtrlGroupStateTax~
      when not can-do(pa-disabled-fields,'S_Kunde.CtrlGroupStateTax':U)~
    S_Kunde.CtrlGroupStateNoTax~
      when not can-do(pa-disabled-fields,'S_Kunde.CtrlGroupStateNoTax':U)~
    S_Kunde.Rechnungsintervall~
      when not can-do(pa-disabled-fields,'S_Kunde.Rechnungsintervall':U)~
    S_Kunde.Rechnungskennzeichen~
      when not can-do(pa-disabled-fields,'S_Kunde.Rechnungskennzeichen':U)~
    S_Kunde.Rechnung_an~
      when not can-do(pa-disabled-fields,'S_Kunde.Rechnung_an':U)~
    S_Kunde.I_PECAccount~
      when not can-do(pa-disabled-fields,'S_Kunde.I_PECAccount':U)~
    S_Kunde.OaPText~
      when not can-do(pa-disabled-fields,'S_Kunde.OaPText':U)~
    with frame {&Frame-Name}.
&SCOP PA-FIELDS-DISABLE-STATEMENT~
  disable unless-hidden~
    S_Kunde.Konzern~
    S_Kunde.Verband~
    S_Kunde.MembershipNoAssociation~
    S_Kunde.Mahnempfaenger_Verband~
    S_Kunde.StGr_mit_ST~
    S_Kunde.P_Steuerregister~
    S_Kunde.StGr_ohne_ST~
    S_Kunde.StGrEU_mit_ST~
    S_Kunde.StGrEU_ohne_ST~
    S_Kunde.StGrAus_mit_ST~
    S_Kunde.StGrAus_ohne_ST~
    S_Kunde.CtrlGroupStateTax~
    S_Kunde.CtrlGroupStateNoTax~
    S_Kunde.Rechnungsintervall~
    S_Kunde.Rechnungskennzeichen~
    S_Kunde.Rechnung_an~
    S_Kunde.I_PECAccount~
    S_Kunde.OaPText~
    with frame {&Frame-Name}.
/*****
</STATEMENTS> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/proc/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
S_Kunde_Obj||y|basis.S_Kunde.S_Kunde_Obj||||||
Dunning_S_Adresse_Obj||y|basis.S_Kunde.Dunning_S_Adresse_Obj||||||
SBM_Cession_Obj||y|basis.S_Kunde.SBM_Cession_Obj||||||
SBM_DunningParameter_Obj||y|basis.S_Kunde.SBM_DunningParameter_Obj||||||
I_S_BankVerb_Obj||y|basis.S_Kunde.I_S_BankVerb_Obj||||||
</FOREIGN-KEYS>
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ",S_Kunde_Obj,Dunning_S_Adresse_Obj,SBM_Cession_Obj,SBM_DunningParameter_Obj,I_S_BankVerb_Obj"':U).
/**************************
</EXECUTING-CODE> */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "InfoTables" V-table-Win _INLINE
/* Actions: ? adm/support/proc/ds_sma00.w ? ? adm/support/proc/ds_tbl01.p */
/* STRUCTURED-DATA
<CONSTANTS></CONSTANTS>
<BUILD-INFORMATION>
1.01
</BUILD-INFORMATION>
<TABLES></TABLES>
<ADDITIONAL-INFORMATION EDITABLE></ADDITIONAL-INFORMATION EDITABLE> */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Skin Client Support" V-table-Win _INLINE
/* Actions: ? ? ? ? adm/support/proc/ds_skc00.p */
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
DEFINE VARIABLE gcInvoiceRecipient AS CHARACTER FORMAT "x(30)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY 1 NO-UNDO.

DEFINE VARIABLE gcStaatBez AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY 1 NO-UNDO.

DEFINE VARIABLE S_Kunde_Konzern_Info AS CHARACTER FORMAT "x(30)":U 
     VIEW-AS FILL-IN 
     SIZE 24 BY 1 NO-UNDO.

DEFINE VARIABLE S_Kunde_Rechnungsintervall_Info AS CHARACTER FORMAT "x(30)":U 
     VIEW-AS FILL-IN 
     SIZE 28 BY 1 NO-UNDO.

DEFINE VARIABLE S_Kunde_Verband_Info AS CHARACTER FORMAT "x(30)":U 
     VIEW-AS FILL-IN 
     SIZE 24 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     S_Kunde.Konzern AT ROW 1 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY 1
     S_Kunde.Verband AT ROW 2 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY 1
     S_Kunde.MembershipNoAssociation AT ROW 3 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 24 BY 1
     S_Kunde.Mahnempfaenger_Verband AT ROW 4 COL 23
          VIEW-AS TOGGLE-BOX
          SIZE 24.83 BY 1
     S_Kunde.Staat AT ROW 5.5 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4 BY 1
     S_Kunde.StGr_mit_ST AT ROW 7 COL 21 COLON-ALIGNED
          LABEL "Steuergruppen":R18
          VIEW-AS FILL-IN 
          SIZE 4 BY 1
     S_Kunde.P_Steuerregister AT ROW 8 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY 1
     gcStaatBez AT ROW 5.5 COL 25 COLON-ALIGNED NO-LABEL
     S_Kunde.StGr_ohne_ST AT ROW 7 COL 25 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4 BY 1
     S_Kunde_Konzern_Info AT ROW 1 COL 33 COLON-ALIGNED NO-LABEL
     S_Kunde_Verband_Info AT ROW 2 COL 33 COLON-ALIGNED NO-LABEL
     S_Kunde.StGrEU_mit_ST AT ROW 7 COL 29 COLON-ALIGNED NO-LABEL AUTO-RETURN 
          VIEW-AS FILL-IN 
          SIZE 4 BY 1
     S_Kunde.StGrEU_ohne_ST AT ROW 7 COL 33 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4 BY 1
     S_Kunde.StGrAus_mit_ST AT ROW 7 COL 37 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4 BY 1
     S_Kunde.StGrAus_ohne_ST AT ROW 7 COL 41 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4 BY 1
     S_Kunde.CtrlGroupStateTax AT ROW 7 COL 45 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4 BY 1
     S_Kunde.CtrlGroupStateNoTax AT ROW 7 COL 49 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4 BY 1
     S_Kunde.Rechnungsintervall AT ROW 1 COL 81 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4 BY 1
     S_Kunde.Rechnungskennzeichen AT ROW 2 COL 83
          VIEW-AS TOGGLE-BOX
          SIZE 24 BY 1
     S_Kunde.Rechnung_an AT ROW 3 COL 81 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY 1
     gcInvoiceRecipient AT ROW 4 COL 81 COLON-ALIGNED NO-LABEL
     S_Kunde.I_PECAccount AT ROW 5 COL 81 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 32 BY 1
     S_Kunde.OaPText AT ROW 6 COL 83
          LABEL "Präferenz berücksichtigen":L25
          VIEW-AS TOGGLE-BOX
          SIZE 32 BY .79
     S_Kunde_Rechnungsintervall_Info AT ROW 1 COL 85 COLON-ALIGNED NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: basis.S_Kunde
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
         HEIGHT             = 8.83
         WIDTH              = 117.33.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{adm/method/incl/dm_viw01.lib}
{stamm/incl/s__adr00.lib}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN gcInvoiceRecipient IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gcStaatBez IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX S_Kunde.OaPText IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN S_Kunde_Konzern_Info IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN S_Kunde_Rechnungsintervall_Info IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN S_Kunde_Verband_Info IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN S_Kunde.Staat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN S_Kunde.StGr_mit_ST IN FRAME F-Main
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

&Scoped-define SELF-NAME S_Kunde.Konzern
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL S_Kunde.Konzern V-table-Win
ON LEAVE OF S_Kunde.Konzern IN FRAME F-Main /* Konzern */
do:  {adm/template/incl/dt_viw03.if}
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME S_Kunde.Rechnung_an
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL S_Kunde.Rechnung_an V-table-Win
ON LEAVE OF S_Kunde.Rechnung_an IN FRAME F-Main /* Rechnung an */
DO:
  {adm/template/incl/dt_uit00.if
     &UserExitName = "ON_LEAVE_OF_S_Kunde_Rechnung_an"}

  run RefreshInvoiceRecipient.

  {adm/template/incl/dt_uit01.if
     &UserExitName = "ON_LEAVE_OF_S_Kunde_Rechnung_an"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME S_Kunde.Rechnungsintervall
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL S_Kunde.Rechnungsintervall V-table-Win
ON LEAVE OF S_Kunde.Rechnungsintervall IN FRAME F-Main /* RechnIntervall */
do:  {adm/template/incl/dt_viw03.if}
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME S_Kunde.Staat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL S_Kunde.Staat V-table-Win
ON LEAVE OF S_Kunde.Staat IN FRAME F-Main /* Staat */
DO:

  define buffer bS_StaatSpr for S_StaatSpr.

  {adm/template/incl/dt_uit00.if
     &UserExitName = "ON_LEAVE_OF_S_Kunde_Staat"}

  {adm/incl/d__spr00.if
    &Tabelle  = "bS_StaatSpr"
    &Selekt   = "where bS_StaatSpr.Staat = input frame {&frame-name} S_Kunde.Staat"
    &no-error = "no-error"}

  gcStaatBez = (if available bS_StaatSpr then
                  bS_StaatSpr.Bezeichnung
                else
                  '':U).

  {adm/incl/d__duh00.if
     &Var1     = "gcStaatBez"
     &WithFrame = "frame {&frame-name}"}.

  {adm/template/incl/dt_uit01.if
     &UserExitName = "ON_LEAVE_OF_S_Kunde_Staat"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME S_Kunde.Verband
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL S_Kunde.Verband V-table-Win
ON LEAVE OF S_Kunde.Verband IN FRAME F-Main /* Verband */
DO:

  /* schalte nach einem Verbandswechsel auf den Mahnempfänger gemäß Verband um */

  {adm/template/incl/dt_uit00.if
     &UserExitName = "ON_LEAVE_OF_S_Kunde_Verband"}

  if    input frame {&FRAME-NAME} S_Kunde.Verband <> S_Kunde.Verband
    and S_Kunde.Verband:screen-value in frame {&FRAME-NAME}
        <> S_Kunde.Verband:private-data in frame {&FRAME-NAME} then

   {setwidgetattr 
      S_Kunde.Mahnempfaenger_Verband 
      checked 
      "can-find(S_Verband where S_Verband.Firma = {firma/s_kunde.fir pa-Firma}
         and S_Verband.Kunde          = input frame {&FRAME-NAME} S_Kunde.Verband
         and S_Verband.Mahnempfaenger = true)" 
      "in frame {&frame-name}"}. 

  {fnarg
    pa_lUISvcSetWidgetSensitiveState
    "S_Kunde.Mahnempfaenger_Verband:handle in frame {&frame-name},
     can-find(S_Verband
                where S_Verband.Firma          = {firma/s_kunde.fir pa-Firma}
                  and S_Verband.Kunde          = input frame {&FRAME-NAME} S_Kunde.Verband
                  and S_Verband.Mahnempfaenger = yes)"}.

  {fnarg
    pa_lUISvcSetWidgetSensitiveState
    "S_Kunde.MembershipNoAssociation:handle in frame {&frame-name},
     can-find(S_Verband
                where S_Verband.Firma = {firma/s_kunde.fir pa-Firma}
                  and S_Verband.Kunde = input frame {&FRAME-NAME} S_Kunde.Verband)"}.


  {adm/template/incl/dt_viw03.if}

  {adm/template/incl/dt_uit01.if
     &UserExitName = "ON_LEAVE_OF_S_Kunde_Verband"}
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).
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

{adm/template/incl/row-list.i "S_Kunde"}

/* Get the record ROWID's from the RECORD-SOURCE.                             */

{adm/template/incl/row-get.i}

/* FIND each record specified by the RECORD-SOURCE.                           */

{adm/template/incl/row-find.i "S_Kunde"}

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

  if can-do(pcFields,'S_Kunde.Rechnungsintervall':U) then
    if S_Kunde_Rechnungsintervall_Info:private-data <> S_Kunde.Rechnungsintervall:screen-value then
    do:

      if input frame {&Frame-Name} S_Kunde.Rechnungsintervall = '':U then

        assign
          {setwidgetattr S_Kunde_Rechnungsintervall_Info private-data '':U}
          {setwidgetattr S_Kunde_Rechnungsintervall_Info screen-value '':U}
          S_Kunde_Rechnungsintervall_Info
          .

      else
      do:

        {adm/incl/d__spr00.if
          &Tabelle  = "S_RechIntSpr"
          &Selekt   = "where S_RechIntSpr.Firma = {firma/srechint.fir pa-Firma}
                         and S_RechIntSpr.Rechnungsintervall = input frame {&Frame-Name} S_Kunde.Rechnungsintervall"
          &no-error = "no-error"}

        if available S_RechIntSpr then
          assign
            {setwidgetattr
               S_Kunde_Rechnungsintervall_Info 
               private-data 
               S_Kunde.Rechnungsintervall:screen-value}
            S_Kunde_Rechnungsintervall_Info              = S_RechIntSpr.Bezeichnung
            .
        else
          assign
            {setwidgetattr S_Kunde_Rechnungsintervall_Info private-data string(?)}
            S_Kunde_Rechnungsintervall_Info              = '':U
            .

        {setwidgetattr
           S_Kunde_Rechnungsintervall_Info 
           screen-value 
           S_Kunde_Rechnungsintervall_Info}.

      end. /* else if input frame {&Frame-Name} S_Kunde.Rechnungsintervall = '':U then */

    end. /* if S_Kunde_Rechnungsintervall_Info:private-data <> S_Kunde.Rechnungsintervall:screen-value then */

  if can-do(pcFields,'S_Kunde.Verband':U) then
    if S_Kunde_Verband_Info:private-data <> S_Kunde.Verband:screen-value then
    do:

      if input frame {&Frame-Name} S_Kunde.Verband = '':U then

        assign
          {setwidgetattr S_Kunde_Verband_Info private-data '':U}
          {setwidgetattr S_Kunde_Verband_Info screen-value '':U}
          S_Kunde_Verband_Info
          .

      else
      do:

        find first S_Verband
          where S_Verband.Firma = {firma/s_kunde.fir pa-Firma}
              and S_Verband.Kunde = input frame {&FRAME-NAME} S_Kunde.Verband
          no-lock no-error.

        if available S_Verband then
          assign
            {setwidgetattr
               S_Kunde_Verband_Info 
               private-data 
               S_Kunde.Verband:screen-value}
            S_Kunde_Verband_Info              = S_Verband.Bezeichnung
            .
        else
          assign
            {setwidgetattr S_Kunde_Verband_Info private-data string(?)}
            S_Kunde_Verband_Info              = '':U
            .

        {setwidgetattr S_Kunde_Verband_Info screen-value S_Kunde_Verband_Info}.

      end. /* else if input frame {&Frame-Name} S_Kunde.Verband = '':U then */

    end. /* if S_Kunde_Verband_Info:private-data <> S_Kunde.Verband:screen-value then */

  if can-do(pcFields,'S_Kunde.Konzern':U) then
    if S_Kunde_Konzern_Info:private-data <> S_Kunde.Konzern:screen-value then
    do:

      if input frame {&Frame-Name} S_Kunde.Konzern = '':U then

        assign
          {setwidgetattr S_Kunde_Konzern_Info private-data '':U}
          {setwidgetattr S_Kunde_Konzern_Info screen-value '':U}
          S_Kunde_Konzern_Info
          .

      else
      do:

        find first S_Konzern
          where S_Konzern.Firma = {firma/s_kunde.fir pa-Firma}
              and S_Konzern.Kunde = input frame {&FRAME-NAME} S_Kunde.Konzern
          no-lock no-error.

        if available S_Konzern then
          assign
            {setwidgetattr
               S_Kunde_Konzern_Info 
               private-data 
               S_Kunde.Konzern:screen-value}
            S_Kunde_Konzern_Info              = S_Konzern.Bezeichnung
            .
        else
          assign
            {setwidgetattr S_Kunde_Konzern_Info private-data string(?)}
            S_Kunde_Konzern_Info              = '':U
            .

        {setwidgetattr S_Kunde_Konzern_Info screen-value S_Kunde_Konzern_Info}.

      end. /* else if input frame {&Frame-Name} S_Kunde.Konzern = '':U then */

    end. /* if S_Kunde_Konzern_Info:private-data <> S_Kunde.Konzern:screen-value then */

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
/* Examples ------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/*----------------------------------------------------------------------------*/

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/
define buffer bS_StaatSpr for S_StaatSpr.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Code placed here will execute PRIOR to standard behavior ------------------*/

/* Execute standard behavior -------------------------------------------------*/

run dispatch('display-fields':U).

/* Code placed here will execute AFTER standard behavior ---------------------*/

if return-value <> 'ADM-ERROR':U then
do:

  run RefreshInvoiceRecipient.

  {adm/incl/d__spr00.if
    &Tabelle  = "bS_StaatSpr"
    &Selekt   = "where bS_StaatSpr.Staat = input frame {&frame-name} S_Kunde.Staat"
    &no-error = "no-error"}

  gcStaatBez = (if available bS_StaatSpr then
                  bS_StaatSpr.Bezeichnung
                else
                  '':U).

  {adm/incl/d__duh00.if
    &Var1     = "gcStaatBez"
    &WithFrame = "frame {&frame-name}"
  }    

end. /* if return-value <> 'ADM-ERROR':U then */

end procedure. /* local-display-fields */

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
do:

  /* disable the field membership number in association if the number of the */
  /* association is not a real association                                   */

  {fnarg
    pa_lUISvcSetWidgetSensitiveState
    "S_Kunde.MembershipNoAssociation:handle in frame {&frame-name},
     can-find(S_Verband
                where S_Verband.Firma = {firma/s_kunde.fir pa-Firma}
                  and S_Verband.Kunde = input frame {&FRAME-NAME} S_Kunde.Verband)"}.

end. /* if return-value <> 'ADM-ERROR':U then */

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

/* Code placed here will execute PRIOR to standard behavior. */

/* Initialisierung der Sonderzeichen für die Oberfläche, da   */
/* im UIB keine Übersetzungsattribute angegeben werden können */

/* Dispatch standard ADM method.                             */
run dispatch in this-procedure ( 'initialize':U ) .

/* Code placed here will execute AFTER standard behavior.    */

if return-value <> 'ADM-ERROR':U then
do:

  &IF "{&pa_S_Kontenfindung}" = "0" &THEN

    {fnarg
      pa_lUISvcSetWidgetHiddenState
      "S_Kunde.StGrAus_mit_ST:handle in frame {&frame-name},
       yes"}.

    {fnarg
      pa_lUISvcSetWidgetHiddenState
      "S_Kunde.StGrAus_ohne_ST:handle in frame {&frame-name},
       yes"}.

    {fnarg
      pa_lUISvcSetWidgetHiddenState
      "S_Kunde.StGrEU_mit_ST:handle in frame {&frame-name},
       yes"}.

    {fnarg
      pa_lUISvcSetWidgetHiddenState
      "S_Kunde.StGrEU_ohne_ST:handle in frame {&frame-name},
       yes"}.

  &ENDIF

  {fnarg
    pa_lUISvcSetWidgetHiddenState
    "S_Kunde.CtrlGroupStateTax:handle in frame {&frame-name},
     (pACConnectionSvc:prpcLocalization <> 'IN':U)"}.

  {fnarg
    pa_lUISvcSetWidgetHiddenState
    "S_Kunde.CtrlGroupStateNoTax:handle in frame {&frame-name},
     (pACConnectionSvc:prpcLocalization <> 'IN':U)"}.       

  run set-attribute-list ('check-modified-all=yes':U).

  {fnarg
    pa_lUISvcAttachWidget
    "S_Kunde.Rechnung_an:handle in frame {&frame-name},
     gcInvoiceRecipient:handle in frame {&frame-name}"}.

  {fnarg
    pa_lUISvcAttachWidget
    "S_Kunde.Staat:handle in frame {&frame-name},
     gcStaatBez:handle in frame {&frame-name}"}.

  {fnarg
    pa_lUISvcSetWidgetHiddenState
    "S_Kunde.P_SteuerRegister:handle in frame {&frame-name},
     (pACConnectionSvc:prpcLocalization <> 'P':U)"}.

   {fnarg
    pa_lUISvcSetWidgetHiddenState
    "S_Kunde.I_PECAccount:handle in frame {&frame-name},
     (pACConnectionSvc:prpcLocalization <> 'I':U)"}.

  {&{&PA-XBasisName}_C_local-initialize}
  {&{&PA-XBasisName}_U_local-initialize}
  {&{&PA-XBasisName}_Q_local-initialize}
  {&{&PA-XBasisName}_local-initialize}
  {&{&PA-XBasisName}_Y_local-initialize}


end. /* if return-value <> 'ADM-ERROR':U */

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RefreshInvoiceRecipient V-table-Win 
PROCEDURE RefreshInvoiceRecipient :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Refreh manual info field gcInvoiceRecipient                                */
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
define buffer bSKunde-Rechnung for S_Kunde.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

gcInvoiceRecipient = '':U.

if    available S_Kunde
  and input frame {&frame-name} S_Kunde.Rechnung_an > 0 then
do:

  find bSKunde-Rechnung
    where bSKunde-Rechnung.Firma = S_Kunde.Firma
      and bSKunde-Rechnung.Kunde = input frame {&frame-name} S_Kunde.Rechnung_an
    no-lock no-error.

  if available bSKunde-Rechnung then
    gcInvoiceRecipient = komprimierte_Adresse(bSKunde-Rechnung.AdressNr,'Name1':U).

end. /* if    available S_Kunde */

{adm/incl/d__duh00.if
  &Var1     = "gcInvoiceRecipient"
  &WithFrame = "frame {&frame-name}"
}

end procedure. /* LoadInvoiceRecipient */

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

{adm/template/incl/sndkycas.i "S_Kunde_Obj" "S_Kunde" "S_Kunde_Obj" " "}
{adm/template/incl/sndkycas.i "Dunning_S_Adresse_Obj" "S_Kunde" "Dunning_S_Adresse_Obj" " "}
{adm/template/incl/sndkycas.i "SBM_Cession_Obj" "S_Kunde" "SBM_Cession_Obj" " "}
{adm/template/incl/sndkycas.i "SBM_DunningParameter_Obj" "S_Kunde" "SBM_DunningParameter_Obj" " "}
{adm/template/incl/sndkycas.i "I_S_BankVerb_Obj" "S_Kunde" "I_S_BankVerb_Obj" " "}

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

{adm/template/incl/snd-list.i "S_Kunde"}

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
/*----------------------------------------------------------------------------*/

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

case pcStateCode:

  when 'paSCisOnce-OnlyCustomer':U then
    return (S_Kunde.AdressNr = 0).

  when 'paSCisOnce-OnlyCustomerWithInvoice':U then
    return (   S_Kunde.AdressNr = 0
            or can-find(first Buf_S_Kunde
                 where Buf_S_Kunde.Firma       =  S_Kunde.Firma
                   and Buf_S_Kunde.Kunde       <> S_Kunde.Kunde
                   and Buf_S_Kunde.Rechnung_an =  S_Kunde.Kunde)).

  when 'paSCisDunningRecipient':U then
    return (can-find(S_Verband
              where S_Verband.Firma          = {firma/s_kunde.fir pa-Firma}
                and S_Verband.Kunde          = input frame {&frame-name} S_Kunde.Verband
                and S_Verband.Mahnempfaenger = yes)).

  when 'paSCisAdoptionOfCreditLine':U then
    return ("{&pa_S_KreditlimitWKV}":U <> "1":U).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE test V-table-Win
PROCEDURE test :
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

/* Code placed here will execute PRIOR to standard behavior. */

/* Initialisierung der Sonderzeichen für die Oberfläche, da   */
/* im UIB keine Übersetzungsattribute angegeben werden können */

/* Dispatch standard ADM method.                             */

define input parameter pix_test as character no-undo.

message pix_test.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

