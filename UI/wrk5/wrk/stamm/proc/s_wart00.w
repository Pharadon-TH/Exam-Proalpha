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
/*  Name.......: s_wart00.w                                                  */
/*  Bereich....: STAMM/KERN                                                  */
/*                                                                           */
/*  erstellt am: 08.02.1999                                                  */
/*  Autor......: Uwe Baumann                                                 */
/*                                                                           */
/*  Version....: 9.3.0 vom 2023-04-20/Kurevin, Danil (ext.)                   */
/*                                                                           */
/*---------------------------------------------------------------------------*/
/*  AUFGABE                                                                  */
/*---------------------------------------------------------------------------*/
/*                                                                           */
/*  Viewer Teilestamm Bezeichnungen                                          */
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
/* 2021-09-29 Weiler, Frank 5d607d89f24d6172a8f6a883411032df2a21dd77          */
/*            HOUD-788: pA ray: Batchlauf pa-DisplaySkinClientWidgets" und "p */
/*            a-AssignSkinClientWidgets"                                      */
/* 2021-10-22 Port, Jens af600af991d3d5849a57a5e472c9e1fbc3e11173             */
/*            PA-23255: Gewichtsberechnung: Client stürzt ab, wenn Artikel vo */
/*            n anderem Nutzer geöffnet war und man die Lockmeldung schließt  */
/* 2021-11-12 Mikalauskas, Justinas (ext.) 50376362d3239118fdd16dc8e3454d47ed2cffb7 */
/*            PA-21097: Empfängerliste für das Versenden von Stücklisten (pAX */
/*            -ENGBOM)                                                        */
/* 2022-01-11 Tsolakidis, Triantafyllos 4e6081d8c5dae458886f7e9b41232ccb407d9281 */
/*            HOUD-2644: Interface-Trigger: User Exit Includes und Fehlerhand */
/*            ling hinzufügen                                                 */
/* 2022-02-04 Tsolakidis, Triantafyllos a24198fdbd07f4780803689216fefe72fda920ae */
/*            HOUD-2919: Interface-Trigger: User Exit Includes und Fehlerhand */
/*            ling hinzufügen: Nur Einrückungen und Leerzeilen                */
/* 2022-02-09 Juzaitis, Martynas (ext.) fef2519e0269f25aaa922b304829d7e744fa815e */
/*            PA-24980: WUP: Warenzusammenstellung must be sensitive to Part  */
/*            type changes                                                    */
/* 2022-08-23 Hemmen, Harald 2955bc9a52163fc3372eea445dc5d399e9eadaa9         */
/*            PA-28314: ETR: Ergebnisträger im Projekt automatisch gefüllt fa */
/*            lls primäre Ergebnisträgergruppe Projekt ist                    */
/* 2022-09-13 Neu, Holger c9600f664f4c0a5fd9d4fd3368b637bed532dd9a            */
/*            PA-29788: Böhme + Weiss Schnittstelle: Abhängige Tabellen werde */
/*            n bei Änderung nicht korrekt übertragen                         */
/* 2022-09-15 Schreier, Katrin f54753fda7d7d8f01321c26c846f1db179578f5f       */
/*            PA-29899: SE-Mawi: Änderung Teileart 76 in 10 nicht möglich.    */
/* 2022-10-05 Dworschak, Jan e020da96b97d27def536d34accc5bedb5723e530         */
/*            PA-17795: Anfrage-/Ausschreibungsprozess: Teile-Lieferanten-Dat */
/*            en (cleversource)                                               */
/*            PA-25901: Datenstruktur Teile-Lieferanten-Daten für Teileabruf  */
/*            erstellen                                                       */
/*            PA-25903: REST Service: Aktualisierung Teile-Lieferanten-Daten  */
/*            PA-27352: Auswahl Dokumente/Zeichnungen                         */
/*            PA-27775: Senden von Dokumenten/Zeichnungen                     */
/* 2022-11-15 Kryžanauskas, Lukas (ext.) 125fe1b882c55e4c9a9a361a71d8ef2efd88f97a */
/*            PA-31793: FM: Der Schlüssel 'PMM_BomHead_Obj' wird im Programm  */
/*            'stamm/proc/s_wart00.w' nicht unterstützt                       */
/* 2023-02-01 Herrmann, Bernd 3012f7146fcba8bf3a5016e08a884787101da373        */
/*            PA-32181: DMS file call corrections for Purchasing on identifie */
/*            d code                                                          */
/* 2023-02-02 Leiva Scheid, Claudia c9613417d6584a0cbd99fc6374bd44039df66024  */
/*            PA-32698: pAX-QM-Parts: Bezeichnung wird nicht bei Neuanlage üb */
/*            ertragen, erst wenn der Benutzer zusätzlich das Fenster Bezeich */
/* 2023-02-23 Leiva Scheid, Claudia 044ff43656bee52b371cf372030ae14eb531474b  */
/*            PA-11837: Stücklistenauflösung: Konsolidierung der Aufrufe      */
/* 2023-04-20 Kurevin, Danil (ext.) c4644d58624784da813d8a8391e79738d02d2dcd  */
/*            PA-33933: WUP Charge: Chargenstamm - Grenzwerttabelle kann manu */
/*            ell gepflegt werden                                             */
/*****************************************************************************/

create widget-pool.

/* Procedure Information -----------------------------------------------------*/

&GLOBAL-DEFINE pa-Autor             Uwe Baumann
&GLOBAL-DEFINE pa-Version           9.3.0
&GLOBAL-DEFINE pa-Datum             2023-04-20
&GLOBAL-DEFINE pa-Letzter           Kurevin, Danil (ext.)

&GLOBAL-DEFINE pa-GenVersion       UIB
&GLOBAL-DEFINE pa-ProgrammTyp      SmartViewer
&GLOBAL-DEFINE pa-Template         adm/template/proc/dt_viw00.w
&GLOBAL-DEFINE pa-TemplateVersion  1.08
&GLOBAL-DEFINE pa-XBasisName       s_wart00_w

/* Parameters ----------------------------------------------------------------*/

/* Globals -------------------------------------------------------------------*/

{adm/template/incl/dt_viw00.df}

/* SCOPEDs -------------------------------------------------------------------*/

&SCOPED-DEFINE PA-FIRST-EXCEPT-FIELDS OaPRelevant

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

define variable gcKey-Lagergruppe  as character no-undo.

&IF LOOKUP("SO","{&PA-MODULE}") > 0 
  AND (   LOOKUP("SB-QM-Master":U,"{&PA-OPTIONEN}":U) > 0
       OR LOOKUP("SB_CMPLNTS","{&PA-OPTIONEN}")       > 0) &THEN
define variable gcOldDescription as character     no-undo.   
define variable glCopyPart       as logical       no-undo.
&ENDIF

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
&Scoped-define EXTERNAL-TABLES S_Artikel S_ArtikelSpr
&Scoped-define FIRST-EXTERNAL-TABLE S_Artikel


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR S_Artikel, S_ArtikelSpr.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS S_Artikel.Artikel S_Artikel.Suchbegriff ~
S_Artikel.Selektion S_ArtikelSpr.Bezeichnung[1] S_ArtikelSpr.Bezeichnung[2] ~
S_ArtikelSpr.Bezeichnung[3] S_ArtikelSpr.Bezeichnung[4] ~
S_Artikel.archiviert S_Artikel.ArtikelArt S_Artikel.H_Mediated
&Scoped-define ENABLED-TABLES S_Artikel S_ArtikelSpr
&Scoped-define FIRST-ENABLED-TABLE S_Artikel
&Scoped-define SECOND-ENABLED-TABLE S_ArtikelSpr
&Scoped-Define DISPLAYED-FIELDS S_Artikel.Artikel S_Artikel.Suchbegriff ~
S_Artikel.Selektion S_ArtikelSpr.Bezeichnung[1] S_ArtikelSpr.Bezeichnung[2] ~
S_ArtikelSpr.Bezeichnung[3] S_ArtikelSpr.Bezeichnung[4] ~
S_Artikel.archiviert S_Artikel.ArtikelArt S_Artikel.H_Mediated
&Scoped-define DISPLAYED-TABLES S_Artikel S_ArtikelSpr
&Scoped-define FIRST-DISPLAYED-TABLE S_Artikel
&Scoped-define SECOND-DISPLAYED-TABLE S_ArtikelSpr
&Scoped-Define DISPLAYED-OBJECTS S_Artikel_ArtikelArt_Info

/* Custom List Definitions                                              */
/* PA-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,PA-PROMPT-FIELDS,PA-SEARCH-FIELDS */
&Scoped-define ADM-ASSIGN-FIELDS S_Artikel.Artikel
&Scoped-define PA-SEARCH-FIELDS S_Artikel.Artikel S_Artikel.Suchbegriff ~
S_Artikel.Selektion

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Konfiguration" V-table-Win _INLINE
/* Actions: ? adm/support/proc/ds_viw06.w ? ? ? */

&SCOP PA-MEMFIELD1 S_Artikel.Artikel
&SCOP PA-MEMORY1 Artikel

&SCOP PA-AENDERUNGSHINWEIS YES

&SCOP pa-LockStatusCheck-Area1        'S_A':U
&SCOP pa-LockStatusCheck-Table1       S_Artikel

&SCOP PA-CREATEWORKFLOWEVENT-TABLE      S_Artikel
&SCOP PA-CREATEWORKFLOWEVENT-FIELD      Verteilergruppe


&SCOP PA-SMART 'SAR':U

&SCOP PA-TABELLE-SATZSPERRE S_Artikel

&SCOP PA-PRINT-PROCEDURE stamm/proc/s_dart00.w

&SCOP PA-DMSCOLD-SUPPORT NO
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "InfoFields" V-table-Win _INLINE
/* Actions: ? adm/support/proc/ds_sma00.w ? ? adm/support/proc/ds_inf01.p */
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
S_Artikel.ArtikelArt|Text|fix.S_ArtikelArtSpr.Bezeichnung|S_ArtikelArtSpr.ArtikelArt = input frame {&Frame-Name} S_Artikel.ArtikelArt|S_Artikel_ArtikelArt_Info
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
&SCOP ENABLED-TABLES S_Artikel S_ArtikelSpr
&SCOP FIRST-ENABLED-TABLE S_Artikel
&SCOP PA-FIRST-INITIAL-VALUES~
  S_Artikel.Firma = ~{firma/sartikel.fir pa-Firma}~
  S_Artikel.Artikel = input frame ~{&Frame-Name} S_Artikel.Artikel
&SCOP SECOND-ENABLED-TABLE S_ArtikelSpr
&SCOP PA-SECOND-INITIAL-VALUES~
  S_ArtikelSpr.Firma = S_Artikel.Firma~
  S_ArtikelSpr.Artikel = S_Artikel.Artikel~
  S_ArtikelSpr.Sprache = pa-sprache
&SCOP PA-FIRST-CHECK~
  S_Artikel.Artikel = input frame ~{&Frame-Name} S_Artikel.Artikel
&SCOP PA-FIRST-COMPARE~
  S_Artikel.Firma = ~{firma/sartikel.fir pa-Firma}~
  and S_Artikel.Artikel = input frame ~{&Frame-Name} S_Artikel.Artikel
&SCOP PA-SECOND-COMPARE~
  S_ArtikelSpr.Firma = S_Artikel.Firma~
  and S_ArtikelSpr.Artikel = S_Artikel.Artikel~
  and S_ArtikelSpr.Sprache = pa-sprache
&SCOP PA-FIRST-EXCEPT-FIELDS {&PA-FIRST-EXCEPT-FIELDS} Firma Artikel AnlageBenutzer AnlageDatum AnlageZeit AenderungBenutzer AenderungDatum AenderungZeit S_Artikel_Obj
&SCOP PA-SECOND-EXCEPT-FIELDS {&PA-SECOND-EXCEPT-FIELDS} Firma Artikel Sprache
&SCOP PA-PRIMARY-FIELD S_Artikel.Artikel
/*****
</CONSTANTS> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Search Support" V-table-Win _INLINE
/* Actions: ? adm/support/proc/ds_sma00.w ? ? adm/support/proc/ds_viw03.p */
/* STRUCTURED-DATA
<BUILD-INFORMATION>
1.09

basis.S_Artikel.Artikel,basis.S_Artikel.Suchbegriff,basis.S_Artikel.Selektion
</BUILD-INFORMATION>
<STATEMENTS>
*****/
&SCOP PA-SEARCH-ENABLE-STATEMENT~
  enable unless-hidden~
    S_Artikel.Artikel~
      when can-do(pa-supported-sortby,'Artikel':U)~
    S_Artikel.Suchbegriff~
      when can-do(pa-supported-sortby,'Suchbegriff':U)~
    S_Artikel.Selektion~
      when can-do(pa-supported-sortby,'Selektion':U)~
    with frame {&FRAME-NAME}.
&SCOP PA-SEARCH-DISABLE-STATEMENT~
  disable unless-hidden~
    S_Artikel.Artikel~
    S_Artikel.Suchbegriff~
    S_Artikel.Selektion~
    with frame {&FRAME-NAME}.
&SCOP PA-FIELDS-ENABLE-STATEMENT~
  enable unless-hidden~
    S_Artikel.Suchbegriff~
      when not can-do(pa-disabled-fields,'S_Artikel.Suchbegriff':U)~
    S_Artikel.Selektion~
      when not can-do(pa-disabled-fields,'S_Artikel.Selektion':U)~
    S_ArtikelSpr.Bezeichnung[1]~
      when not can-do(pa-disabled-fields,'S_ArtikelSpr.Bezeichnung':U)~
    S_ArtikelSpr.Bezeichnung[2]~
      when not can-do(pa-disabled-fields,'S_ArtikelSpr.Bezeichnung':U)~
    S_ArtikelSpr.Bezeichnung[3]~
      when not can-do(pa-disabled-fields,'S_ArtikelSpr.Bezeichnung':U)~
    S_ArtikelSpr.Bezeichnung[4]~
      when not can-do(pa-disabled-fields,'S_ArtikelSpr.Bezeichnung':U)~
    S_Artikel.archiviert~
      when not can-do(pa-disabled-fields,'S_Artikel.archiviert':U)~
    S_Artikel.ArtikelArt~
      when not can-do(pa-disabled-fields,'S_Artikel.ArtikelArt':U)~
    S_Artikel.H_Mediated~
      when not can-do(pa-disabled-fields,'S_Artikel.H_Mediated':U)~
    with frame {&Frame-Name}.
&SCOP PA-FIELDS-DISABLE-STATEMENT~
  disable unless-hidden~
    S_Artikel.Suchbegriff~
    S_Artikel.Selektion~
    S_ArtikelSpr.Bezeichnung[1]~
    S_ArtikelSpr.Bezeichnung[2]~
    S_ArtikelSpr.Bezeichnung[3]~
    S_ArtikelSpr.Bezeichnung[4]~
    S_Artikel.archiviert~
    S_Artikel.ArtikelArt~
    S_Artikel.H_Mediated~
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
$KEY||y|Basis.S_Artikel|stamm/incl/s_artike.sl|||||
$STATKEY1||y|Basis.S_Artikel|stamm/incl/s_artike.sl|||||
PMM_BomHead_Obj||y|cGetPMM_Bomline_Owning_Obj()||||||
Owning_Obj||y|basis.S_Artikel.S_Artikel_Obj||||||
PMM_Bomline_Owning_Obj||y|cGetPMM_Bomline_Owning_Obj()||||||
S_Artikel_Obj||y|basis.S_Artikel.S_Artikel_Obj||||||
$STATKEY2||y|'':U||||||
Firma||y|basis.S_Artikel.Firma||||||
ImageNumber||y|Basis.S_Artikel.Bild||||||
Artikel||y|Basis.S_Artikel.Artikel||||||
Part||y|Basis.S_Artikel.Artikel||||||
ArtVar||y|'':U||||||
Lagergruppe||y|gcKey-Lagergruppe||||||
Nummer||y|'0':U||||||
ArtikelGruppe||y|basis.S_Artikel.ArtikelGruppe||||||
Bewertungsgruppe||y|Basis.S_Artikel.Bewertungsgruppe||||||
Sachbearbeiter||y|'':U||||||
S_Artikel_Obj||y|Basis.S_Artikel.S_Artikel_Obj||||||
Rabattgruppe||y|basis.S_Artikel.Rabattgruppe||||||
SBM_ValueFlowGroup_Obj||y|Basis.S_Artikel.SBM_ValueFlowGroup_Obj||||||
Driver_Obj||y|Basis.S_Artikel.Driver_Obj||||||
SBM_CustomsTariffNo_Obj||y|Basis.S_Artikel.SBM_CustomsTariffNo_Obj||||||
PartVariant||y|'':U||||||
SBM_F_EcoCode_Obj||y|Basis.S_Artikel.SBM_F_EcoCode_Obj||||||
Custom_Owning_Obj||y|basis.S_Artikel.S_Artikel_Obj||||||
Charge||y|'':U||||||
</FOREIGN-KEYS>
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
run set-attribute-list (
    'Keys-Accepted = ,
     Keys-External = ,
     Keys-Supplied = "$KEY,$STATKEY1,PMM_BomHead_Obj,Owning_Obj,PMM_Bomline_Owning_Obj,S_Artikel_Obj,$STATKEY2,Firma,ImageNumber,Artikel,Part,ArtVar,Lagergruppe,Nummer,ArtikelGruppe,Bewertungsgruppe,Sachbearbeiter,S_Artikel_Obj,Rabattgruppe,SBM_ValueFlowGroup_Obj,Driver_Obj,SBM_CustomsTariffNo_Obj,PartVariant,SBM_F_EcoCode_Obj,Custom_Owning_Obj,Charge"':U).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Window Title" V-table-Win _INLINE
/* Actions: ? adm/support/proc/ds_sma00.w ? ? adm/support/proc/ds_ttl00.p */
/* STRUCTURED-DATA
<TITLE-CODE EDITABLE>
</TITLE-CODE EDITABLE>
<CONSTANTS></CONSTANTS>  */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Skin Client Support" V-table-Win _INLINE
/* Actions: ? ? ? ? adm/support/proc/ds_skc00.p */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cGetPMM_Bomline_Owning_Obj V-table-Win
FUNCTION cGetPMM_Bomline_Owning_Obj returns character private
  (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD pa_lUISvcObjectState V-table-Win
FUNCTION pa_lUISvcObjectState returns LOGICAL
  ( pcStateCode as character )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE S_Artikel_ArtikelArt_Info AS CHARACTER FORMAT "x(30)":U
     VIEW-AS FILL-IN
     SIZE 28 BY 1 NO-UNDO.

DEFINE IMAGE sDocInfo TRANSPARENT
     SIZE 4 BY 1.

DEFINE IMAGE sNoteInfo TRANSPARENT
     SIZE 4 BY 1.

DEFINE IMAGE sRecordState TRANSPARENT
     SIZE 4 BY 1.

DEFINE IMAGE sTextInfo TRANSPARENT
     SIZE 4 BY 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     S_Artikel.Artikel AT ROW 1 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 32 BY 1
     S_Artikel.Suchbegriff AT ROW 1 COL 81 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 16 BY 1
     S_Artikel.Selektion AT ROW 2 COL 81 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 24 BY 1
     S_ArtikelSpr.Bezeichnung[1] AT ROW 2 COL 21 COLON-ALIGNED
          LABEL "Bezeichnung":R18
          VIEW-AS FILL-IN
          SIZE 32 BY 1
     S_ArtikelSpr.Bezeichnung[2] AT ROW 3 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN
          SIZE 32 BY 1
     S_ArtikelSpr.Bezeichnung[3] AT ROW 4 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN
          SIZE 32 BY 1
     S_ArtikelSpr.Bezeichnung[4] AT ROW 5 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN
          SIZE 32 BY 1
     S_Artikel.archiviert AT ROW 3 COL 83
          VIEW-AS TOGGLE-BOX
          SIZE 24 BY 1
     S_Artikel.ArtikelArt AT ROW 5.5 COL 81 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 4 BY 1
     S_Artikel_ArtikelArt_Info AT ROW 5.5 COL 85 COLON-ALIGNED NO-LABEL
     S_Artikel.H_Mediated AT ROW 4.5 COL 83
          VIEW-AS TOGGLE-BOX
          SIZE 24 BY .79
     sRecordState AT ROW 1 COL 99
     sTextInfo AT ROW 1 COL 103
     sNoteInfo AT ROW 1 COL 107
     sDocInfo AT ROW 1 COL 111
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: Basis.S_Artikel,Basis.S_ArtikelSpr
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
         HEIGHT             = 5.83
         WIDTH              = 118.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN S_Artikel.Artikel IN FRAME F-Main
   2 6                                                                  */
/* SETTINGS FOR FILL-IN S_ArtikelSpr.Bezeichnung[1] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN S_Artikel_ArtikelArt_Info IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR IMAGE sDocInfo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN S_Artikel.Selektion IN FRAME F-Main
   6                                                                    */
/* SETTINGS FOR IMAGE sNoteInfo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR IMAGE sRecordState IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR IMAGE sTextInfo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN S_Artikel.Suchbegriff IN FRAME F-Main
   6                                                                    */
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

&Scoped-define SELF-NAME S_Artikel.archiviert
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL S_Artikel.archiviert V-table-Win
ON VALUE-CHANGED OF S_Artikel.archiviert IN FRAME F-Main /* archiviert */
DO:
  {adm/template/incl/dt_uit00.if
     &UserExitName = "ON_VALUE-CHANGED_OF_S_Artikel_archiviert"}

  if     S_Artikel.archiviert
     and not S_Artikel.archiviert:checked in frame {&FRAME-NAME}
     and not adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage('s_art00003m':U) then

    run dispatch in this-procedure ( 'cancel-record':U ) .

  {adm/template/incl/dt_uit01.if
     &UserExitName = "ON_VALUE-CHANGED_OF_S_Artikel_archiviert"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME S_Artikel.ArtikelArt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL S_Artikel.ArtikelArt V-table-Win
ON LEAVE OF S_Artikel.ArtikelArt IN FRAME F-Main /* Teileart */
do:
  {adm/template/incl/dt_uit00.if
     &UserExitName = "ON_LEAVE_OF_S_Artikel_ArtikelArt"}

  {adm/template/incl/dt_viw03.if}

  run set-link-attribute (this-procedure,
                          'record-target':U,
                          'Teileart=':U + string(input frame {&frame-name} S_Artikel.ArtikelArt)).

  run new-state ('ChangePartType,group-assign-target':U).
  
  {adm/template/incl/dt_uit01.if
    &UserExitName = "ON_LEAVE_OF_S_Artikel_ArtikelArt"}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-print-current-record V-table-Win  adm/support/proc/ds_viw07.p
PROCEDURE adm-print-current-record :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Print current selected record                                              */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* <NONE>                                                                     */
/*                                                                            */
/*----------------------------------------------------------------------------*/

/* Variables -----------------------------------------------------------------*/
/* cParameter  parameter-string to pass to print dialog                       */
/*----------------------------------------------------------------------------*/

define variable cParameter  as char no-undo.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Error if no record is available */

if not available S_Artikel then
  adm.method.cls.DMCMessageSvc:prpoInstance:ShowError('dtviw00002':U).

/* Create parameter-string */

{adm/incl/d__par00.if
  &ParameterListe = "cParameter"
  &Parameter      = "Artikel"
  &Variable1      = "S_Artikel.Artikel"
  &Variable2      = "S_Artikel.Artikel"
  &Variable3      = "S_Artikel.Artikel"
}

/* Run print-dialog */

run {&PA-PRINT-PROCEDURE} (cParameter).

return.

end procedure. /* adm-print-current-record */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
{adm/template/incl/row-list.i "S_ArtikelSpr"}

/* Get the record ROWID's from the RECORD-SOURCE.                             */

{adm/template/incl/row-get.i}

/* FIND each record specified by the RECORD-SOURCE.                           */

{adm/template/incl/row-find.i "S_Artikel"}
{adm/template/incl/row-find.i "S_ArtikelSpr"}

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

  if can-do(pcFields,'S_Artikel.ArtikelArt':U) then
    if S_Artikel_ArtikelArt_Info:private-data <> S_Artikel.ArtikelArt:screen-value then
    do:

      if input frame {&Frame-Name} S_Artikel.ArtikelArt = '':U then

        assign
          {setwidgetattr S_Artikel_ArtikelArt_Info private-data '':U}
          {setwidgetattr S_Artikel_ArtikelArt_Info screen-value '':U}
          S_Artikel_ArtikelArt_Info
          .

      else
      do:

        S_Artikel_ArtikelArt_Info
          = {fnarg
              pa_cStCchPartTypeDesc
              "input frame {&Frame-Name} S_Artikel.ArtikelArt,
               pa-Sprache,
               {&pa_CchDesc}"}.

        if S_Artikel_ArtikelArt_Info <> ? then
          {setwidgetattr
             S_Artikel_ArtikelArt_Info
             private-data
             S_Artikel.ArtikelArt:screen-value}.
        else
          assign
            {setwidgetattr S_Artikel_ArtikelArt_Info private-data string(?)}
            S_Artikel_ArtikelArt_Info = '':U
            .

        {setwidgetattr
           S_Artikel_ArtikelArt_Info
           screen-value
           S_Artikel_ArtikelArt_Info}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dms-send-wordattributes V-table-Win
PROCEDURE dms-send-wordattributes :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Build data-fields to create a new Office Document                          */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* see include o__oat00.if                                                    */
/*                                                                            */
/*----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

&IF LOOKUP('O_','{&PA-MODULE}') > 0 &THEN
  {arch/incl/o__oat00.if
    &TableName = "S_Artikel"
  }
&ENDIF

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-Variantenteil V-table-Win
PROCEDURE get-Variantenteil :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Calculate attribute Variantenteil                                          */
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

&IF '{&PA_S_VARIANTEN}' = '1' &THEN

  return string(    available S_Artikel
                and {stamm/incl/s__var00.if &Tabelle = "S_Artikel"},
                'yes/no':U).

&ELSE

  return 'no':U.

&ENDIF

end procedure. /* get-Variantenteil */

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
/* Examples ------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/*----------------------------------------------------------------------------*/

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

define variable cLinkList     as character        no-undo.
define variable i             as integer          no-undo.

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Code placed here will execute PRIOR to standard behavior. */

/* Wenn der Folder mit den Dispodaten aktiv ist, wird zuerst ein Update auf */
/* MD_Artikel ausgeführt und erst danach das Update auf S_Artikel.          */
/* Im Trigger von MD_Artikel wird Tabelle S_Artikel geladen um Prüfungen in */
/* Abhängigkeit der Teileart auszuführen. Da zu diesem Zeitpunkt die evtl.  */
/* geänderte Teileart noch nicht in die Datenbank zurückgeschrieben wurde   */
/* muß vorher die Teileart zurückgeschrieben werden                         */

if S_Artikel.Artikelart <> input frame {&FRAME-NAME} S_Artikel.Artikelart then
do on error undo, throw:

  /* Validation S_Artikel.Artikelart 70,71,75,76*/

  if   (   (    (   S_Artikel.Artikelart = {&pa_S_PT_ReusablePackage}
                 or S_Artikel.Artikelart = {&pa_S_PT_ExpendablePackaging})
            and (   input frame {&FRAME-NAME} S_Artikel.Artikelart = {&pa_S_PT_ReusablePackagingAcc}
                 or input frame {&FRAME-NAME} S_Artikel.Artikelart = {&pa_S_PT_ExpendablePackagingAcc}))
        or (    (   S_Artikel.Artikelart = {&pa_S_PT_ReusablePackagingAcc}
                 or S_Artikel.Artikelart = {&pa_S_PT_ExpendablePackagingAcc})
            and (   input frame {&FRAME-NAME} S_Artikel.Artikelart = {&pa_S_PT_ReusablePackage}
                 or input frame {&FRAME-NAME} S_Artikel.Artikelart = {&pa_S_PT_ExpendablePackaging})))
    and can-find (first M_LTPos
                     where M_LTPos.Firma      = {firma/mlartort.fir pACConnectionSvc:prpcCompany}
                       and M_LTPos.Packmittel = S_Artikel.Artikel) then

    adm.method.cls.DMCMessageSvc:prpoInstance:ShowError('s_art00040':U).

  if    (   input frame {&FRAME-NAME} S_Artikel.Artikelart = {&pa_S_PT_ReusablePackage}
         or input frame {&FRAME-NAME} S_Artikel.Artikelart = {&pa_S_PT_ReusablePackagingAcc})
    and (   can-find (first MLL_Movements
                        where MLL_Movements.Company = pACConnectionSvc:prpcCompany
                          and MLL_Movements.Part    = S_Artikel.Artikel)
         or can-find (first MLA_OnHand
                        where MLA_OnHand.Company = pACConnectionSvc:prpcCompany
                          and MLA_OnHand.Part    = S_Artikel.Artikel
                          and (   MLA_OnHand.OnHand         <> 0
                               or MLA_OnHand.ExternalOnHand <> 0 ))) then

    adm.method.cls.DMCMessageSvc:prpoInstance:ShowError('s_art00041':U).

  if      (   S_Artikel.Artikelart = {&pa_S_PT_ReusablePackage}
           or S_Artikel.Artikelart = {&pa_S_PT_ReusablePackagingAcc})
      and (   can-find (first MLL_Movements
                          where MLL_Movements.Company = pACConnectionSvc:prpcCompany
                            and MLL_Movements.Part    = S_Artikel.Artikel)
           or can-find (first MLA_OnHand
                          where MLA_OnHand.Company = pACConnectionSvc:prpcCompany
                            and MLA_OnHand.Part    = S_Artikel.Artikel
                            and (   MLA_OnHand.OnHand         <> 0
                                 or MLA_OnHand.ExternalOnHand <> 0 ))
           or can-find (first   M_LTPos
                          where M_LTPos.Firma      = {firma/mlartort.fir pACConnectionSvc:prpcCompany}
                            and M_LTPos.Packmittel = S_Artikel.Artikel))
    or    (   S_Artikel.Artikelart = {&pa_S_PT_ExpendablePackaging}
           or S_Artikel.Artikelart = {&pa_S_PT_ExpendablePackagingAcc})
      and  can-find (first   M_LTPos
                       where M_LTPos.Firma      = {firma/mlartort.fir pACConnectionSvc:prpcCompany}
                         and M_LTPos.Packmittel = S_Artikel.Artikel) then

    adm.method.cls.DMCMessageSvc:prpoInstance:ShowError('s_art00042':U).

  assign
    S_Artikel.Artikelart
    .

  /* When the product line is not defined but the average price surveillance  */
  /* is defined to the product line then an error will occur when we activate */
  /* the trigger. So we look if the user has changed this fields too.         */
  /* This fields are placed on two other viewer. So we have to ask this vie-  */
  /* wers to there field entries.                                             */

  if    S_Artikel.ArtikelGruppe        = '':U
    and S_Artikel.AvgPriceSurveillance = 1 then
  do:

    /* First we get all target viewers to this viewer */

    run get-link-handle (this-procedure, 'record-target':U, output cLinkList).

    /* To each record target object we ask the attributes to the product line */
    /* and the average price surveillance and if defined we set the value     */
    /* before the validate was done.                                          */

    do i = 1 to num-entries(cLinkList):

      run get-attribute in widget-handle(entry(i,cLinkList)) ('ProductLine':U).

      if return-value <> ? then
        S_Artikel.ArtikelGruppe = return-value.

      run get-attribute in widget-handle(entry(i,cLinkList)) ('AvgPriceSurveillance':U).

      if return-value <> ? then
        S_Artikel.AvgPriceSurveillance = integer(return-value).

    end. /* do i = 1 to num-entries(cLinkList) */

  end. /* if    S_Artikel.ArtikelGruppe        = '':U ... */

end. /* if S_Artikel.Artikelart <> ... */

/* Dispatch standard ADM method.                             */

/* Code placed here will execute PRIOR to standard behavior ------------------*/
&IF LOOKUP("SO","{&PA-MODULE}") > 0 
  AND (   LOOKUP("SB-QM-Master":U,"{&PA-OPTIONEN}":U) > 0
       OR LOOKUP("SB_CMPLNTS","{&PA-OPTIONEN}")       > 0) &THEN
  gcOldDescription = S_ArtikelSpr.Bezeichnung[1].
&ENDIF

run dispatch in this-procedure ( 'assign-record':U ) .

/* Code placed here will execute AFTER standard behavior.    */

if return-value <> 'adm-error':U then

  run notify('refresh-query,record-target':U).

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-source V-table-Win
PROCEDURE local-copy-source :
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
/* cIncDriverObj    OID of SBM_IncDriver that is matching to the created part */
/*----------------------------------------------------------------------------*/

define variable cIncDriverObj like SBM_IncDriver.SBM_IncDriver_Obj no-undo.

/* Buffers -------------------------------------------------------------------*/

define buffer S_ArtikelSpr                       for S_ArtikelSpr.
define buffer Buf_S_ArtikelSpr                   for S_ArtikelSpr.
&IF LOOKUP("Q_QM":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  define buffer bEBM_SamplePlanAssignment-Source for EBM_SamplePlanAssignment.
  define buffer bEBM_SamplePlanAssignment-Target for EBM_SamplePlanAssignment.
&ENDIF

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Dispatch standard ADM method.                             */

run dispatch in this-procedure ( 'copy-source':U ) .

/* Code placed here will execute AFTER standard behavior.    */

if     return-value <> 'adm-error':U
   and pa-created-records > '':U
   and can-do(pa-created-records,'S_Artikel':U) then
Kopieren:
do transaction on error undo, throw:

  /* Stammsatz kopieren */

  find first wt_S_Artikel_source
    no-error.

  if available wt_S_Artikel_source then
  do:

    /*------------------------------------------------------------------------*/
    /* In a new article, the weight must be confirmed separately              */
    /*------------------------------------------------------------------------*/

    if wt_S_Artikel_source.GewichtBestaetigt = yes then
      S_Artikel.GewichtBestaetigt = no.

    /*------------------------------------------------------------------------*/
    /* An archived part has to be opened, because otherwise it would          */
    /* not be posssible to add a part-supplier relationship.                  */
    /*------------------------------------------------------------------------*/

    if wt_S_Artikel_source.archiviert = yes then
    do:

      S_Artikel.archiviert = no.

      &IF LOOKUP("ML","{&PA-MODULE}") > 0 &THEN

        /* Inform on dearchiving copied part-storagearea relations            */

        if     adm.config.cls.DCCAppConfigSvc:prpoInstance:lParameterValue
                 ('SB_PartTemplCopyStorageAreas':U) = yes
           and can-find (first MLM_StorPartData
                 where MLM_StorPartData.Company = wt_S_Artikel_source.Firma
                   and MLM_StorPartData.Part    = wt_S_Artikel_source.Artikel) then

          adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
            ('mlaor00003':U,
             wt_S_Artikel_source.Artikel).

      &ENDIF /* ML */

    end. /* if wt_S_Artikel_source.archiviert = yes */

    &IF LOOKUP("WS","{&PA-MODULE}") > 0 &THEN
      S_Artikel.WEBShop = 0.
    &ENDIF

    /* In the case of pa_s_Traeger = 2, primary income driver group = part    */
    /* and activated synchronisation for this group, we overwrite the object  */
    /* ID of the delivered income driver (from the copied part) because there */
    /* should be the matching income driver from the newly created part in    */
    /* the field Driver_Obj. Otherwise we stick to the standard behavior and  */
    /* keep the income driver from the copied part. The following method      */
    /* checks all requirements and delivers the OID of the matching           */
    /* SBM_IncDriver.                                                         */

    cIncDriverObj = stamm.base.cls.SBCMasterFilesIncDriverAccSvc:prpoInstance:cIncDriverObjOfPrimaryGroup
                      (S_Artikel.Firma,
                       'Part':U,
                       S_Artikel.S_Artikel_Obj).

    if cIncDriverObj > '':U then
      S_Artikel.Driver_Obj = cIncDriverObj.

    /* Do ONE validate for all the changes above. Otherwise replication       */
    /* framework will create an entry for each change and will possibly       */
    /* refuse the creation of this item in the target database.               */

    validate S_Artikel.

    /*-----------------------------------------------------------------------*/
    /* Kopiere die Bezeichnungen                                             */
    /*-----------------------------------------------------------------------*/

    for each Buf_S_ArtikelSpr
      where Buf_S_ArtikelSpr.firma   = wt_S_Artikel_source.firma
        and Buf_S_ArtikelSpr.Artikel = wt_S_Artikel_source.Artikel
      no-lock
      by (if Buf_S_ArtikelSpr.Sprache = {&PA_DEFAULTSPRACHE} then
            1
          else
            2)
      on error undo, throw:

      /* suche zunächst einen evtl. vorhandenen Sprachsatz */

      find S_ArtikelSpr
        of S_Artikel
        where S_ArtikelSpr.Sprache = Buf_S_ArtikelSpr.Sprache
        exclusive-lock no-error.

      if not available S_ArtikelSpr then
      do:

        create S_ArtikelSpr.
        assign
          S_ArtikelSpr.Firma   = S_Artikel.Firma
          S_ArtikelSpr.Artikel = S_Artikel.Artikel
          S_ArtikelSpr.Sprache = Buf_S_ArtikelSpr.Sprache
          .

        validate S_ArtikelSpr.

      end.

      buffer-copy
        buf_S_ArtikelSpr
          except
            {&PA-SECOND-EXCEPT-FIELDS}
        to S_ArtikelSpr.

      validate S_ArtikelSpr.

    end. /* each spr */

    /* Nun s_kart00.p aufrufen */
    run stamm/proc/s_kart00.p(wt_S_Artikel_source.Artikel,
                              S_Artikel.Artikel,
                              pa-Firma).

    &IF LOOKUP("Q_QM":U,"{&PA-OPTIONEN}":U) > 0 &THEN
      /* Copy QM-Inspection plan                                              */

      for each bEBM_SamplePlanAssignment-Source
        where bEBM_SamplePlanAssignment-Source.Owning_Obj = wt_S_Artikel_source.S_Artikel_Obj
        no-lock
        on error undo, throw:

        create bEBM_SamplePlanAssignment-Target.

        buffer-copy bEBM_SamplePlanAssignment-Source
          except
            EBM_SamplePlanAssignment_Obj
            Owning_Obj
            ChangedBy
            ChangedDateTime
            CreatedBy
            CreationDateTime
          to bEBM_SamplePlanAssignment-Target
          assign
            bEBM_SamplePlanAssignment-Target.Owning_Obj = S_Artikel.S_Artikel_Obj
            .

        validate bEBM_SamplePlanAssignment-Target.

      end. /* for bEBM_SamplePlanAssignment-Source */
    &ENDIF
    
    &IF   LOOKUP("SO","{&PA-MODULE}") > 0 
      AND (    LOOKUP("SB-QM-Master":U,"{&PA-OPTIONEN}":U) > 0
            or LOOKUP("SB_CMPLNTS","{&PA-OPTIONEN}")       > 0) &THEN
      glCopyPart = yes.
    &ENDIF

    /* Individualschnittstelle Nachlauf Kopieren*/

    {&{&PA-XBasisName}_C_KOPIEREN}
    {&{&PA-XBasisName}_U_KOPIEREN}
    {&{&PA-XBasisName}_Q_KOPIEREN}
    {&{&PA-XBasisName}_KOPIEREN}
    {&{&PA-XBasisName}_Y_KOPIEREN}

  end. /* if available wt_S_Artikel_source */

end. /* Kopieren: do transaction */

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-CreateWorkflow V-table-Win
PROCEDURE local-CreateWorkflow :
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

define variable c_tmp as char no-undo.

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

if available S_Artikel then
  run basis/buro/proc/bbpver00.w
    (S_Artikel.Firma,
     'S_A':U,
     S_Artikel.S_Artikel_Obj,
     input-output c_tmp).


end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win
PROCEDURE local-delete-record :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* local Override                                                             */
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

/* --> UMO#CE2017-03-001-03 MDe Erzeugen temporärer Strukturen: Austausch von Poolteilen */
&IF LOOKUP("U_CE":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  define buffer gbuS_ArtAlternativ          for   S_ArtAlternativ.
  define buffer gbuUSL_ManuAlternPartUsage  for USL_ManuAlternPartUsage.
&ENDIF /* U_CE */
/* <-- UMO#CE2017-03-001-03 MDe Erzeugen temporärer Strukturen: Austausch von Poolteilen */

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* --> UMO#CE2017-03-001-03 MDe Erzeugen temporärer Strukturen: Austausch von Poolteilen */
&IF LOOKUP("U_CE":U,"{&PA-OPTIONEN}":U) > 0 &THEN
if branche.stamm.cls.USCPartManufacturerSvc:prpoInstance:lIsManufacturerAlternativePart(S_Artikel.Artikel) then
do:

  FE_gbuS_ArtAlternativ:
  for each gbuS_ArtAlternativ
    where gbuS_ArtAlternativ.Firma             = {firma/sartikel.fir pACConnectionSvc:prpcCompany}
      and gbuS_ArtAlternativ.AlternativArtikel = S_Artikel.Artikel
      and gbuS_ArtAlternativ.Typ               begins 'E':U
    no-lock,
    each gbuUSL_ManuAlternPartUsage
      where gbuUSL_ManuAlternPartUsage.Company             = {firma/sartikel.fir pACConnectionSvc:prpcCompany}
        and gbuUSL_ManuAlternPartUsage.S_ArtAlternativ_Obj = gbuS_ArtAlternativ.S_ArtAlternativ_Obj
        and gbuUSL_ManuAlternPartUsage.Priority            < 100
      no-lock
    on error undo, throw:

    adm.method.cls.DMCMessageSvc:prpoInstance:showError
      ('uspma00024':U,
       S_Artikel.Artikel).

  end. /* FE_gbuS_ArtAlternativ */
end. /* lIsManufacturerAlternativePart */
&ENDIF /* U_CE */
/* <-- UMO#CE2017-03-001-03 MDe Erzeugen temporärer Strukturen: Austausch von Poolteilen */

/* Execute standard behavior -------------------------------------------------*/

run dispatch('delete-record':U).

end procedure. /* local-delete-record */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-end-update V-table-Win 
PROCEDURE local-end-update :
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

run dispatch('end-update':U).

&IF   LOOKUP("SO","{&PA-MODULE}") > 0 
  AND (   LOOKUP("SB-QM-Master":U,"{&PA-OPTIONEN}":U) > 0
       or LOOKUP("SB_CMPLNTS","{&PA-OPTIONEN}")       > 0) &THEN
  
  if    available S_Artikel
    and available S_ArtikelSpr
    and (     S_ArtikelSpr.Bezeichnung [1] <> gcOldDescription
           or glCopyPart) then
           
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
   
   /* Reset copy part here, because now we are definitively done with copy process */
   glCopyPart = no.

&ENDIF

/* Code placed here will execute AFTER standard behavior ---------------------*/

end procedure. /* local-end-update */

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

gcKey-Lagergruppe = '0':U.

/* Execute standard behavior -------------------------------------------------*/

run dispatch('initialize':U).

/* Code placed here will execute AFTER standard behavior ---------------------*/

if return-value <> 'adm-error':U then
do:

  &IF    lookup("ML","{&PA-MODULE}") > 0
     and lookup("MD","{&PA-MODULE}") > 0 &THEN

    /* if multiple MRPUnits are allowed send ?. Otherwise 0 is the only */
    /* value which may be referred to. Undetermined value must be ?     */

    gcKey-Lagergruppe = (if can-find(ML_Lagergruppe   /* code checked by jp 20.11.2009 */
                                       where ML_Lagergruppe.Firma = {firma/mlort.fir pa-Firma}) then
                           '0':U
                         else
                           ?).
  &ENDIF

  {fnarg
    pa_lUISvcSetWidgetHiddenState
    "S_Artikel.H_Mediated:handle in frame {&FRAME-NAME},
     (pACConnectionSvc:prpcLocalization <> 'H':U)"}.

end.

end procedure. /* local-initialize */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MengeneinheitElektroAuftrag V-table-Win
PROCEDURE MengeneinheitElektroAuftrag :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Change the quantity unit in production order for electric BOM              */
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

&IF lookup ("PS", "{&PA-Module}") > 0 &THEN

  define buffer bPP_StkZeile for PP_StkZeile.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

  if adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage('psstk00005':U,
                                                            S_Artikel.Artikel) then
  Auftrag:
  do transaction
    on error undo Auftrag, leave Auftrag
    on endkey undo Auftrag, leave Auftrag:

    for each bPP_StkZeile
      where bPP_StkZeile.Firma            = {firma/ppauftra.fir pACConnectionSvc:prpcCompany}
        and bPP_StkZeile.Artikel          = S_Artikel.Artikel
        and bPP_StkZeile.IsElectroBOMLine = yes
      exclusive-lock
      on error undo Auftrag, leave Auftrag:

      bPP_StkZeile.Mengeneinheit = S_Artikel.StkME.

    end. /* for each bPP_StkZeile ... */

  end. /* transaction */

&ENDIF

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MengeneinheitElektroStandard V-table-Win
PROCEDURE MengeneinheitElektroStandard :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Change the quantity unit in BOM for electric BOM                           */
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

&IF lookup ("PS", "{&PA-Module}") > 0 &THEN

  define buffer bPMM_BomLine for PMM_BomLine.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

  if adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage('psstk00004':U,
                                                            S_Artikel.Artikel) then
  Standard:
  do transaction
    on error undo Standard, leave Standard
    on endkey undo Standard, leave Standard:

    for each bPMM_BomLine      /* code checked by Koehler_P 08.01.2013 */
      where bPMM_BomLine.Company            = {firma/pps.fir pACConnectionSvc:prpcCompany}
        and bPMM_BomLine.Part          = S_Artikel.Artikel
        and bPMM_BomLine.IsElectroBOMLine = yes
      exclusive-lock
      on error undo Standard, leave Standard:

      bPMM_BomLine.UnitOfMeasure = S_Artikel.StkMe.

    end. /* for each bPMM_BomLine */

  end. /* transaction */

&ENDIF

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mi_uciSendPart V-table-Win
PROCEDURE mi_uciSendPart :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Open a dialog to send parts to the wms                                     */
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
/* --> MO#CI2015-01-001 20.10.2015 AFa */
&IF LOOKUP("U_WMS":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  if available S_Artikel then
    run branche/gateway/proc/ug_wsp00.w(S_Artikel.S_Artikel_Obj, '':U).
  else
    run branche/gateway/proc/ug_wsp00.w('':U, '':U).
&ENDIF
/* <-- UMO#CI2015-01-001 20.10.2015 AFa */

end procedure. /* mi_uciSendPart */

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

{adm/template/incl/sndkycas.i "$KEY" "S_Artikel" " " "stamm/incl/s_artike.sl "}
{adm/template/incl/sndkycas.i "$STATKEY1" "S_Artikel" " " "stamm/incl/s_artike.sl "}
{adm/template/incl/sndkycas.i "PMM_BomHead_Obj" " " "cGetPMM_Bomline_Owning_Obj()" " "}
{adm/template/incl/sndkycas.i "Owning_Obj" "S_Artikel" "S_Artikel_Obj" " "}
{adm/template/incl/sndkycas.i "PMM_Bomline_Owning_Obj" " " "cGetPMM_Bomline_Owning_Obj()" " "}
{adm/template/incl/sndkycas.i "S_Artikel_Obj" "S_Artikel" "S_Artikel_Obj" " "}
{adm/template/incl/sndkycas.i "$STATKEY2" " " "'':U" " "}
{adm/template/incl/sndkycas.i "Firma" "S_Artikel" "Firma" " "}
{adm/template/incl/sndkycas.i "ImageNumber" "S_Artikel" "Bild" " "}
{adm/template/incl/sndkycas.i "Artikel" "S_Artikel" "Artikel" " "}
{adm/template/incl/sndkycas.i "Part" "S_Artikel" "Artikel" " "}
{adm/template/incl/sndkycas.i "ArtVar" " " "'':U" " "}
{adm/template/incl/sndkycas.i "Lagergruppe" " " "gcKey-Lagergruppe" " "}
{adm/template/incl/sndkycas.i "Nummer" " " "'0':U" " "}
{adm/template/incl/sndkycas.i "ArtikelGruppe" "S_Artikel" "ArtikelGruppe" " "}
{adm/template/incl/sndkycas.i "Bewertungsgruppe" "S_Artikel" "Bewertungsgruppe" " "}
{adm/template/incl/sndkycas.i "Sachbearbeiter" " " "'':U" " "}
{adm/template/incl/sndkycas.i "S_Artikel_Obj" "S_Artikel" "S_Artikel_Obj" " "}
{adm/template/incl/sndkycas.i "Rabattgruppe" "S_Artikel" "Rabattgruppe" " "}
{adm/template/incl/sndkycas.i "SBM_ValueFlowGroup_Obj" "S_Artikel" "SBM_ValueFlowGroup_Obj" " "}
{adm/template/incl/sndkycas.i "Driver_Obj" "S_Artikel" "Driver_Obj" " "}
{adm/template/incl/sndkycas.i "SBM_CustomsTariffNo_Obj" "S_Artikel" "SBM_CustomsTariffNo_Obj" " "}
{adm/template/incl/sndkycas.i "PartVariant" " " "'':U" " "}
{adm/template/incl/sndkycas.i "SBM_F_EcoCode_Obj" "S_Artikel" "SBM_F_EcoCode_Obj" " "}
{adm/template/incl/sndkycas.i "Custom_Owning_Obj" "S_Artikel" "S_Artikel_Obj" " "}
{adm/template/incl/sndkycas.i "Charge" " " "'':U" " "}

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
{adm/template/incl/snd-list.i "S_ArtikelSpr"}

/* Deal with any unexpected table requests before closing.                    */

{adm/template/incl/snd-end.i}

end procedure. /* send-records */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SelectDoc V-table-Win 
PROCEDURE SelectDoc :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* runs the dialog to select documents/drawings                               */
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

define variable cTemp as character  no-undo.

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

if available S_Artikel then

  run stamm/base/proc/sbpdoc00.w(             S_Artikel.S_Artikel_Obj,
                                 input-output cTemp).

end procedure. /* SelectDoc */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pa_UIMenmi_UCE_SendToBC V-table-Win
PROCEDURE pa_UIMenmi_UCE_SendToBC :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Sends all relevant Data for S_Artikel to Bom Connector                     */
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
&IF LOOKUP("U_CE":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  branche.stamm.cls.USCBOMConnectorSvc:prpoInstance:UpdatePartComplete
    ( S_Artikel.S_Artikel_Obj
    ).
&ENDIF

end procedure. /* pa_UIMenmi_UCE_SendToBC */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE weightCalculation V-table-Win
PROCEDURE weightCalculation :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* With this programme the weight calculation of a parts list structure is    */
/* carried out. Weights already confirmed are not changed any more or further */
/* resolved to below.                                                         */
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

&IF LOOKUP("P_","{&PA-MODULE}") > 0  &THEN

define variable dWeight  as decimal   initial 0 no-undo.
define variable cPartObj as character           no-undo.

/* Buffers -------------------------------------------------------------------*/

define buffer bS_Artikel for S_Artikel.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

if available S_Artikel then
do:

  cPartObj = S_Artikel.S_Artikel_Obj.

  /* ask the user if the weight should be recalculated if the weight was      */
  /* already confirmed                                                        */

  if S_Artikel.GewichtBestaetigt then
    adm.method.cls.DMCMessageSvc:prpoInstance:showError
      ('s_gew00001':U,
       S_Artikel.Artikel).

  run pa_UISvcStartInstanceByName('s_msgdialog_WeightCalc.dyn':U,
                                   adm.method.cls.DMCParameterStringSvc:cWriteValue
                                    ('':U,
                                     'MessageID':U,
                                     's_art00027':U),
                                   '':U,
                                   '':U).

  dWeight = pps.base.cls.PMCStandardBomSvc:prpoInstance:dWeightCalculation
             (S_Artikel.Artikel,
              '':U).

  if pa-fields-enabled then
    run set-link-attribute (this-procedure,'record-target':U, 'Gewicht="':U +  string(dWeight) + '"':U).

  else
  ChangeLoop:
  do transaction
    on error undo, throw
    on stop  undo, retry:

    if retry then
    do:

      find S_Artikel
        where S_Artikel.S_Artikel_Obj = cPartObj
        no-lock.

      leave ChangeLoop.

    end. /* if retry */

    find bS_Artikel
      where rowid(bS_Artikel) = rowid(S_Artikel)
      exclusive-lock.

    bS_Artikel.Lagergewicht = dWeight.

    run dispatch('row-available':U).

  end. /* transaction */

end. /* if available S_Artikel */

&ENDIF

end procedure. /* weightCalculation */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cGetPMM_Bomline_Owning_Obj V-table-Win
FUNCTION cGetPMM_Bomline_Owning_Obj returns character private
  (  ):
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Bestimme PMM_Bomline_Owning_Obj                                            */
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
/* cReturnValue  function return value                                        */
/*----------------------------------------------------------------------------*/

define variable cReturnValue as character no-undo.
/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

if available S_Artikel then
  cReturnValue = pps.base.cls.PMCStandardBomSvc:prpoInstance:cGetStandardBom
                    (S_Artikel.Artikel,
                     '':u).
else
  cReturnValue = ?.

return cReturnValue.

end function. /* cGetPMM_Bomline_Owning_Obj */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION pa_lUISvcObjectState V-table-Win
FUNCTION pa_lUISvcObjectState returns LOGICAL
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

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

case pcStateCode:

  when 'paSCcanUpdateAveragePrice':U then

    &IF LOOKUP("ML","{&PA-MODULE}") > 0 &THEN

      return     pa-fields-enabled = yes
             and not mawi.lager.cls.MLCOnHandInvSvc:prpoInstance:lIsOnHandAvailable
                       ((if available S_Artikel then
                           S_Artikel.Artikel
                         else
                           '':U),
                        '':U,
                        '':U,
                        '':U).
    &ELSE
      return no.
    &ENDIF

  when 'paSCIsStructure':U then
  do:

     &IF LOOKUP("P_","{&PA-MODULE}") > 0 &THEN

       return pps.base.cls.PMCStandardBomSvc:prpoInstance:lHasBOM
                ((if available S_Artikel then
                    S_Artikel.Artikel
                  else
                    '':U),
                 '':U).
     &ELSE
       return no.
     &ENDIF

  end.

  when 'paSCHasElektroStandard':u then
  do:

    &IF lookup ("PS", "{&PA-Module}") > 0 &THEN

      return can-find(first PMM_BomLine
                        where PMM_BomLine.Company          = {firma/pps.fir pACConnectionSvc:prpcCompany}
                          and PMM_BomLine.Part             = S_Artikel.Artikel
                          and PMM_BomLine.IsElectroBOMLine = yes).

    &ELSE
      return no.
    &ENDIF

  end.

  when 'paSCHasElektroWorkorder':u then
  do:

    &IF lookup ("PS", "{&PA-Module}") > 0 &THEN

        return can-find(first PP_StkZeile
                          where PP_StkZeile.Firma            = {firma/ppauftra.fir pACConnectionSvc:prpcCompany}
                            and PP_StkZeile.Artikel          = S_Artikel.Artikel
                            and PP_StkZeile.IsElectroBOMLine = yes).

    &ELSE
      return no.
    &ENDIF

  end.

  when 'paSCIsConfigPart':U then
  do:

    &IF lookup("MU","{&PA-Module}") > 0 &THEN

      if available S_Artikel then
        if  can-do({&pa_MU_PTList_ConfigurableProduction}, string(S_Artikel.Artikelart))
          or ( S_Artikel.Artikelart = {&pa_S_PT_PurchasedProduct}
              and can-find(first   E_ArtLief
                             where E_ArtLief.Firma                   = {firma/e_artli.fir pACConnectionSvc:prpcCompany}
                               and E_ArtLief.Artikel                 = S_Artikel.Artikel
                               and E_ArtLief.PCExternalConfiguration = yes))  then
          return yes.

      return no.

    &ELSE
      return no.
    &ENDIF

  end.

  when 'paSCIsVariantPart':U then
  do:
    &IF LOOKUP("P_","{&PA-MODULE}") > 0 &THEN

    return (if available S_Artikel then
              S_Artikel.ArtikelArt = {&pa_S_PT_VariantPart}
              else
                no).

    &endif

  end. /* when 'paSCIsVariantBom':U then */

  when 'paSCisEcoComActive':U then
    return (    S_Artikel.F_EcoTax          = yes
            and S_Artikel.SBM_F_EcoCode_Obj = '':U
            and not can-do({&pa_S_PTList_Set},
                           string(S_Artikel.ArtikelArt,'99':U))).

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

