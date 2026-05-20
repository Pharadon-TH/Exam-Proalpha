&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          temp-db          PROGRESS
          basis            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DECLARATIONS V-table-Win 

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

using stamm.base.cls.SBCAttachedDocumentSvo.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update Information" V-table-Win _INLINE
/* Actions: ? ? ? ? adm/support/proc/ds_pa_01.w */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE TT_E_BelegPos NO-UNDO LIKE TD_E_BelegPos.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*****************************************************************************/
/*                                  (c) 2023 proALPHA Business Solutions GmbH */
/*                                           Auf dem Immel 8                  */
/*                                           67685 Weilerbach                 */
/*                                                                           */
/*  Projekt....: proALPHA                                                    */
/*                                                                           */
/*  Name.......: e_wbel00.w                                                  */
/*  Bereich....: EINK/KERN                                                   */
/*                                                                           */
/*  erstellt am: 02.01.1997                                                  */
/*  Autor......: Ingrid Gründer                                              */
/*                                                                           */
/*  Version....: 9.3.2 vom 2023-11-09/Herrmann, Bernd                         */
/*                                                                           */
/*---------------------------------------------------------------------------*/
/*  AUFGABE                                                                  */
/*---------------------------------------------------------------------------*/
/*                                                                           */
/*  Pflege der primären Felder von Bestellungen                              */
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
/* 2022-01-21 Ossaid, Samir 56ba6303d58a6b01708eb4431c81fcce83c5e7ad          */
/*            PA-25005: LVS-relevante Bestellung löschen: Meldung zeigt falsc */
/*            he Belegnummer an                                               */
/* 2022-03-01 Junker, Michael 8cf47d2d846a770386dfa27077cae085834f3121        */
/*            PA-25682:  &IF {&PA_VERSION} GE '5.1':U in höheren Versionen un */
/*            nötig                                                           */
/* 2022-03-14 Fleer, Thomas 1188982f4dfc190da485a35acaf237247dae9988          */
/*            PA-25708: Rücklieferung: Beim Löschen aufpoppen des Chargenausw */
/*            ahlbrowsers und Lagerplatzbrowsers                              */
/* 2022-04-06 Kozak, Alexander 8be9e658b3d2492574f20b00e4dadbc25cfafc4c       */
/*            PA-26357: Bestellung: Ereignis 80 für Mindestbestellwert wird n */
/*            icht immer ausgelöst                                            */
/* 2022-05-16 Matheis, Ute 4cefbd5f0da87c8b356d5affd1ec2df7032f43d6           */
/*            PA-26727: Einkaufsbelege: mehrfache Zustandsanzeige bei Neuanla */
/*            ge / Änderung von Notiz                                         */
/* 2022-05-27 Spielberger, Nicole b48effff2b54573cc5c2fb111754808f818806ee    */
/*            PA-27251: Archivierung Rücklieferung: Lzf s_-com-00110 bei eing */
/*            erichteter Compliance                                           */
/* 2022-09-02 Schmitt, Markus 865e6eeae083126184c8d874ecc4be8520c6fafd        */
/*            PA-29347: Intrastat - Lieferschein an Lager: Statistischer Wert */
/*             wird falsch ermittelt (Gesamt-Durchschnittpreis über Wertgrupp */
/* 2022-10-06 Mikalauskas, Justinas (ext.) 7b1db45f1b3bd81addb3a594adb51b8b087ad391 */
/*            PA-29959: Lieferantencall > Rücklieferung: Beim öffnen der Lief */
/*            erantencall Position über Info > Positionen in der Belegverknüp */
/* 2022-11-21 Crispi, Maja 6effd2feaadcbb5d0c4d0cf2a2ef411dfa2128b7           */
/*            PA-30729: Bestellung: Demo 9.Master, Menüpunkt 'LS an Lager gen */
/*             (Komplettbeistellung)' inaktiv, in der Demo 7.2Master ist dies */
/* 2023-02-01 Herrmann, Bernd 3012f7146fcba8bf3a5016e08a884787101da373        */
/*            PA-32181: DMS file call corrections for Purchasing on identifie */
/*            d code                                                          */
/* 2023-02-06 Ramonas, Saulius (ext.) fee3c7d29a46093b1d0fac371fa65753653444c3 */
/*            PA-30987: Bestellung: Wenn man eine Bestellung in einen abweich */
/*            enden Lieferanten kopiert, wird durch Sperre auf Ursprungsliefe */
/* 2023-04-20 Si?iovas, Rokas (ext.) e446f3da8ddbf284630fdc6ab71515198620d1bd */
/*            PA-33186: Toggle|Checkbox "Beleg anhängen" beim E-Mail-Versende */
/*            n eines Belegs ist per Default aktiviert|gesetzt                */
/* 2023-07-18 Herrmann, Bernd de6c5d2c663e89367222aa25b103814dfdd98034        */
/*            PA-36389: Bestellung (mit Lieferplan): Abbildung des gesetzten  */
/*            ACM Parameters zu Bestellpositionen (offen vs. bereits geliefer */
/* 2023-08-03 Herrmann, Bernd 0d3a612a409ac635a6bc7c0dc334d70735879640        */
/*            PA-36389: Bestellung (mit Lieferplan): Abbildung des gesetzten  */
/*            ACM Parameters zu Bestellpositionen (offen vs. bereits geliefer */
/*            PA-38852: Rückbau Issue PA-36389 in 9.3.1                       */
/* 2023-11-09 Herrmann, Bernd bbdd971fffaa5d038b45f7b7bbd5a47b373b3bfd        */
/*            PA-31333: Belastungsanzeige: Bei Archivierung einer Rücklieferu */
/*            ng kann ein Benutzer ohne Berechtigung fälschlicherweise eine B */
/*****************************************************************************/

/*----------------------------------------------------------------------     */
/*          This .W file was created with the Progress UIB.                  */
/*----------------------------------------------------------------------     */

/* Create an unnamed pool to store all the widgets created
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

create widget-pool.

/*---------------------------------------------------------------------------*/
/* Definitionen                                                              */
/*---------------------------------------------------------------------------*/

/* KONSTANTEN ---------------------------------------------------------------*/
/* Systemkonstanten **********************************************************/

&GLOBAL-DEFINE pa-Autor             Ingrid Gründer
&GLOBAL-DEFINE pa-Version           9.3.2
&GLOBAL-DEFINE pa-Datum             2023-11-09
&GLOBAL-DEFINE pa-Letzter           Herrmann, Bernd

&GLOBAL-DEFINE pa-GenVersion       UIB
&GLOBAL-DEFINE pa-ProgrammTyp      SmartViewer
&GLOBAL-DEFINE pa-Template         adm/template/proc/dt_viw00.w
&GLOBAL-DEFINE pa-TemplateVersion  1.00

&GLOBAL-DEFINE pa-XBasisName       e_wbel00_w


/* lokale Konstanten *********************************************************/

&SCOP PA-AddRecordProcedure CreateNewRecord

&Scoped-define pa-ENABLE-check lFelderEnablen()

/* EXTERNE DEFINITIONEN -----------------------------------------------------*/

{adm/template/incl/dt_viw00.df}


/* LOKALE OBJEKTE -----------------------------------------------------------*/
/* Variable ******************************************************************/
/*   Name               Funktion                                             */
/*   ------------------ ---------------------------------------------------- */
/*****************************************************************************/

define variable glArchivieren         as logical   init no    no-undo.
define variable gcBelegArt            as character            no-undo.
define variable gcBereich             as character            no-undo.
define variable gcDruckprogramm       as character            no-undo.
define variable gceMail               as character            no-undo.
define variable gcBestelladresse      as character init '':U  no-undo.
define variable gcLieferadresse       as character init '':U  no-undo.
define variable gcRechnungsadresse    as character init '':U  no-undo.
define variable glAttach              as logical   init no    no-undo.
define variable glPositionen          as logical              no-undo.
define variable gcAttach              as character            no-undo.
define variable gcBestimmungsort      as character            no-undo.
define variable gcAddressInfoWinTitle as character            no-undo.
define variable glEditorUpdateDenied  as logical              no-undo.
define variable glZustandPruefen      as logical   init yes   no-undo.

/* --> UMO#CI2015-01-001 AFa LVS-Schnittstelle */
&IF LOOKUP("U_WMS":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  define variable gluLVSArchivieren     as logical       no-undo.
  define variable gcuE_BelegKopf_Obj    as character     no-undo.
&ENDIF
/* <-- UMO#CI2015-01-001 AFa LVS-Schnittstelle */

/* Buffer ********************************************************************/

/* Work-/Temp-Tables *********************************************************/

{stamm/incl/s__adr00.tdf
  &ippNoReferenceOnlySwitch = "yes"}

{info/mawi/incl/im_dlk00.pds &ippNoReferenceOnlySwitch = "yes"}

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
&Scoped-define EXTERNAL-TABLES E_BelegKopf
&Scoped-define FIRST-EXTERNAL-TABLE E_BelegKopf


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR E_BelegKopf.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS E_BelegKopf.Lieferant E_BelegKopf.Empfaenger ~
E_BelegKopf.Wiedervorlage 
&Scoped-define ENABLED-TABLES E_BelegKopf
&Scoped-define FIRST-ENABLED-TABLE E_BelegKopf
&Scoped-Define DISPLAYED-FIELDS E_BelegKopf.Lieferant ~
E_BelegKopf.BelegNummer E_BelegKopf.BelegDatum E_BelegKopf.offen ~
E_BelegKopf.Empfaenger E_BelegKopf.CatalogPurchOrder ~
E_BelegKopf.SBM_ProfitCenter_Obj E_BelegKopf.Sachbearbeiter ~
E_BelegKopf.AuftragsArt E_BelegKopf.Wiedervorlage 
&Scoped-define DISPLAYED-TABLES E_BelegKopf
&Scoped-define FIRST-DISPLAYED-TABLE E_BelegKopf
&Scoped-Define DISPLAYED-OBJECTS gcName1 E_BelegKopf_BelegDatum_Info ~
gcName2 gcStrasse E_Bele_SBM_ProfitCenter_Obj_Info gcOrt ~
E_BelegKopf_Sachbearbeiter_Info E_BelegKopf_AuftragsArt_Info ~
E_BelegKopf_Wiedervorlage_Info 

/* Custom List Definitions                                              */
/* PA-CREATE-FIELDS,ADM-ASSIGN-FIELDS,PA-PROTECTED-FIELDS,PA-UPDATE-VARS,PA-PROMPT-FIELDS,PA-SEARCH-FIELDS */
&Scoped-define ADM-ASSIGN-FIELDS E_BelegKopf.Lieferant ~
E_BelegKopf.BelegNummer 
&Scoped-define PA-PROTECTED-FIELDS E_BelegKopf.BelegDatum ~
E_BelegKopf.SBM_ProfitCenter_Obj E_BelegKopf.Sachbearbeiter ~
E_BelegKopf.AuftragsArt 
&Scoped-define PA-SEARCH-FIELDS E_BelegKopf.Lieferant ~
E_BelegKopf.BelegNummer 

/* _UIB-PREPROCESSOR-BLOCK-END */
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
&SCOP PA-OIDINFOFIELDS     E_BelegKopf.SBM_ProfitCenter_Obj
&SCOP PA-OIDINFOVARIABLES  E_Bele_SBM_ProfitCenter_Obj_Info
&SCOP PA-OIDINFOTARGETS    DBM_ShortDescription.ShortDesc1
&SCOP PA-OIDINFOBASEFIELDS SBM_ProfitCenter_Obj
/***
</Constants>
<InfoFields>
E_BelegKopf.BelegDatum|day|||E_BelegKopf_BelegDatum_Info
E_BelegKopf.AuftragsArt|Text|Basis.S_AuftragsArtSpr.Bezeichnung|S_AuftragsArtSpr.Firma = {firma/saufart.fir pa-Firma};S_AuftragsArtSpr.AuftragsArt = input frame {&Frame-Name} E_BelegKopf.AuftragsArt|E_BelegKopf_AuftragsArt_Info
E_BelegKopf.Wiedervorlage|day|||E_BelegKopf_Wiedervorlage_Info
E_BelegKopf.Sachbearbeiter|Text|basis.BU_Benutzer.Name|BU_Benutzer.Benutzer = input frame {&Frame-Name} E_BelegKopf.Sachbearbeiter|E_BelegKopf_Sachbearbeiter_Info
E_BelegKopf.SBM_ProfitCenter_Obj|OIDReplacement|DBM_ShortDescription.ShortDesc1|SBM_ProfitCenter_Obj|E_Bele_SBM_ProfitCenter_Obj_Info
</InfoFields> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Dynamic InfoFields" V-table-Win _INLINE
/* Actions: ? ? ? ? adm/support/proc/ds_viw09.p */

&SCOPED-DEFINE pa-UpdateHiddenScreenvalues ~
  assign~
    E_BelegKopf.SBM_ProfitCenter_Obj:screen-value in frame {&FRAME-NAME} = (if available E_BelegKopf then E_BelegKopf.SBM_ProfitCenter_Obj else '':U)~
    .

&SCOPED-DEFINE pa-UpdateHiddenProtectedFieldScreenvalues ~
  assign~
    E_BelegKopf.SBM_ProfitCenter_Obj:screen-value in frame {&FRAME-NAME} = (if available E_BelegKopf then E_BelegKopf.SBM_ProfitCenter_Obj else '':U)~
    .
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update Support" V-table-Win _INLINE
/* Actions: ? adm/support/proc/ds_sma00.w ? ? adm/support/proc/ds_viw00.p */
/* STRUCTURED-DATA
<ADDITIONAL-INFORMATION EDITABLE>
E_BelegKopf:Index = Beleg
E_BelegKopf.offen = yes
E_BelegKopf.Belegart = gcBelegArt
E_BelegKopf.LfdNr = E_BelegKopf.LfdNr
</ADDITIONAL-INFORMATION EDITABLE>

<CONSTANTS>
*****/
&SCOP ENABLED-TABLES E_BelegKopf
&SCOP FIRST-ENABLED-TABLE E_BelegKopf
&SCOP PA-FIRST-INITIAL-VALUES~
  E_BelegKopf.Firma = ~{firma/ebelkop.fir pa-Firma}~
  E_BelegKopf.Belegart = gcBelegArt~
  E_BelegKopf.offen = yes~
  E_BelegKopf.BelegNummer = input frame ~{&Frame-Name} E_BelegKopf.BelegNummer~
  E_BelegKopf.LfdNr = E_BelegKopf.LfdNr~
  E_BelegKopf.Lieferant = input frame ~{&FRAME-NAME} E_BelegKopf.Lieferant
&SCOP PA-FIRST-CHECK~
  E_BelegKopf.BelegNummer = input frame ~{&Frame-Name} E_BelegKopf.BelegNummer
&SCOP PA-FIRST-COMPARE~
  E_BelegKopf.Firma = ~{firma/ebelkop.fir pa-Firma}~
  and E_BelegKopf.Belegart = gcBelegArt~
  and E_BelegKopf.offen = yes~
  and E_BelegKopf.BelegNummer = input frame ~{&Frame-Name} E_BelegKopf.BelegNummer~
  and E_BelegKopf.LfdNr = E_BelegKopf.LfdNr
&SCOP PA-FIRST-EXCEPT-FIELDS {&PA-FIRST-EXCEPT-FIELDS} Firma BelegArt ReferenzNr Lieferant BelegNummer AnlageBenutzer AnlageDatum AnlageZeit AenderungBenutzer AenderungDatum AenderungZeit E_BelegKopf_Obj
&SCOP PA-PRIMARY-FIELD E_BelegKopf.BelegNummer
/*****
</CONSTANTS> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Search Support" V-table-Win _INLINE
/* Actions: ? adm/support/proc/ds_sma00.w ? ? adm/support/proc/ds_viw03.p */
/* STRUCTURED-DATA
<BUILD-INFORMATION>
1.09

basis.E_BelegKopf.Lieferant,basis.E_BelegKopf.BelegNummer
</BUILD-INFORMATION>
<STATEMENTS>
*****/
&SCOP PA-SEARCH-ENABLE-STATEMENT~
  enable unless-hidden~
    E_BelegKopf.Lieferant~
      when can-do(pa-supported-sortby,'Lieferant':U)~
    E_BelegKopf.BelegNummer~
      when can-do(pa-supported-sortby,'BelegNummer':U)~
    with frame {&FRAME-NAME}.
&SCOP PA-SEARCH-DISABLE-STATEMENT~
  disable unless-hidden~
    E_BelegKopf.Lieferant~
    E_BelegKopf.BelegNummer~
    with frame {&FRAME-NAME}.
&SCOP PA-FIELDS-ENABLE-STATEMENT~
  enable unless-hidden~
    E_BelegKopf.Empfaenger~
      when not can-do(pa-disabled-fields,'E_BelegKopf.Empfaenger':U)~
    E_BelegKopf.Wiedervorlage~
      when not can-do(pa-disabled-fields,'E_BelegKopf.Wiedervorlage':U)~
    with frame {&Frame-Name}.
&SCOP PA-FIELDS-DISABLE-STATEMENT~
  disable unless-hidden~
    E_BelegKopf.Empfaenger~
    E_BelegKopf.Wiedervorlage~
    with frame {&Frame-Name}.
/*****
</STATEMENTS> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Konfiguration" V-table-Win _INLINE
/* Actions: ? adm/support/proc/ds_viw06.w ? ? ? */

&SCOP PA-CREATEWORKFLOWEVENT-TABLE      E_BelegKopf
&SCOP PA-CREATEWORKFLOWEVENT-OT    E_BelegKopf.Auftragsart
&SCOP PA-CREATEWORKFLOWEVENT-FIELD      Verteilergruppe


&SCOP PA-PRINT-PROCEDURE eink/proc/e_dbel10.w

&SCOP PA-DMSCOLD-SUPPORT YES
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/proc/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
Firma||y|MaWi.E_BelegKopf.Firma||||||
Lieferant||y|MaWi.E_BelegKopf.Lieferant||||||
ShippingType||y|basis.E_BelegKopf.VersandArt||||||
S_Lieferant_Obj||y|cLieferant_Obj()||||||
BelegArt||y|MaWi.E_BelegKopf.BelegArt||||||
ReferenzNr||y|MaWi.E_BelegKopf.ReferenzNr||||||
$KEY||y|MaWi.E_BelegKopf|eink/incl/e_belko.sl|||||
Origin_Obj||y|basis.E_BelegKopf.E_BelegKopf_Obj||||||
E_BelegKopf_Obj||y|MaWi.E_BelegKopf.E_BelegKopf_Obj||||||
AddressInfoWinTitle||y|gcAddressInfoWinTitle||||||
EditorUpdateDenied||y|glEditorUpdateDenied||||||
Driver_Obj||y|MaWi.E_BelegKopf.Driver_Obj||||||
S_Kostenstelle_Obj||y|MaWi.E_BelegKopf.S_Kostenstelle_Obj||||||
SBM_ProfitCenter_Obj||y|MaWi.E_BelegKopf.SBM_ProfitCenter_Obj||||||
SBM_TaxCase_Obj||y|MaWi.E_BelegKopf.SBM_TaxCase_Obj||||||
SBM_FiscalText_Obj||y|MaWi.E_BelegKopf.SBM_FiscalText_Obj||||||
S_I_TaxExemption_Obj||y|MaWi.E_BelegKopf.S_I_TaxExemption_Obj||||||
Owning_Obj||y|basis.E_BelegKopf.E_BelegKopf_Obj||||||
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
run set-attribute-list (
    'Keys-Accepted = ,
     Keys-External = ,
     Keys-Supplied = "Firma,Lieferant,ShippingType,S_Lieferant_Obj,BelegArt,ReferenzNr,$KEY,Origin_Obj,E_BelegKopf_Obj,AddressInfoWinTitle,EditorUpdateDenied,Driver_Obj,S_Kostenstelle_Obj,SBM_ProfitCenter_Obj,SBM_TaxCase_Obj,SBM_FiscalText_Obj,S_I_TaxExemption_Obj,Owning_Obj"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "InfoTables" V-table-Win _INLINE
/* Actions: ? adm/support/proc/ds_sma00.w ? ? adm/support/proc/ds_tbl01.p */
/* STRUCTURED-DATA
<CONSTANTS>
***/
&SCOP EXTERNAL-TABLES E_BelegKopf
&SCOP PA-INTERNAL-TABLES ttS_Adresse
/***
</CONSTANTS>
<BUILD-INFORMATION>
1.01
</BUILD-INFORMATION>
<TABLES>
temp-db.ttS_Adresse|ttS_Adresse.Firma = {firma/s_adres.fir pACConnectionSvc:prpcCompany};ttS_Adresse.AdressNr = E_BelegKopfAdr.AdressNr|
</TABLES>
<ADDITIONAL-INFORMATION EDITABLE></ADDITIONAL-INFORMATION EDITABLE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Skin Client Support" V-table-Win _INLINE
/* Actions: ? ? ? ? adm/support/proc/ds_skc00.p */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cLieferant_Obj V-table-Win 
FUNCTION cLieferant_Obj returns character
  (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD lFelderEnablen V-table-Win 
FUNCTION lFelderEnablen returns logical
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD lIsRepairOrderLine V-table-Win 
FUNCTION lIsRepairOrderLine returns logical
  ( pcDocumentType like E_BelegPos.Belegart,
    piReferenceNo  like E_BelegPos.ReferenzNr,
    pdLineNo       like E_BelegPos.PositionsNr )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD lProvPartSensitive V-table-Win 
FUNCTION lProvPartSensitive returns logical
  ( plPartialProviding as logical )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD pa_lUISvcObjectState V-table-Win 
FUNCTION pa_lUISvcObjectState returns logical
  ( pcStateCode as character  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE E_Bele_SBM_ProfitCenter_Obj_Info AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE E_BelegKopf_AuftragsArt_Info AS CHARACTER FORMAT "x(30)":U 
     VIEW-AS FILL-IN 
     SIZE 28 BY 1 NO-UNDO.

DEFINE VARIABLE E_BelegKopf_BelegDatum_Info AS CHARACTER FORMAT "x(256)":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY 1 NO-UNDO.

DEFINE VARIABLE E_BelegKopf_Sachbearbeiter_Info AS CHARACTER FORMAT "X(35)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE E_BelegKopf_Wiedervorlage_Info AS CHARACTER FORMAT "x(256)":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY 1 NO-UNDO.

DEFINE VARIABLE gcName1 LIKE E_BelegKopfAdr.Name1
     VIEW-AS FILL-IN 
     SIZE 36 BY 1 NO-UNDO.

DEFINE VARIABLE gcName2 LIKE E_BelegKopfAdr.Name2
     VIEW-AS FILL-IN 
     SIZE 36 BY 1 NO-UNDO.

DEFINE VARIABLE gcOrt AS CHARACTER FORMAT "x(40)":U 
     LABEL "Ort":R18 
     VIEW-AS FILL-IN 
     SIZE 36 BY 1 NO-UNDO.

DEFINE VARIABLE gcStrasse AS CHARACTER FORMAT "x(40)":U 
     LABEL "Straße":R18 
     VIEW-AS FILL-IN 
     SIZE 36 BY 1 NO-UNDO.

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
     E_BelegKopf.Lieferant AT ROW 1 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY 1
     E_BelegKopf.BelegNummer AT ROW 1 COL 81 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY 1
     gcName1 AT ROW 2 COL 21 COLON-ALIGNED HELP
          ""
     E_BelegKopf.BelegDatum AT ROW 2 COL 81 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY 1
     E_BelegKopf_BelegDatum_Info AT ROW 2 COL 93 COLON-ALIGNED NO-LABEL
     gcName2 AT ROW 3 COL 21 COLON-ALIGNED HELP
          "" NO-LABEL
     E_BelegKopf.offen AT ROW 3 COL 83
          VIEW-AS TOGGLE-BOX
          SIZE 16 BY 1
     E_BelegKopf.Empfaenger AT ROW 4 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 36 BY 1
     E_BelegKopf.CatalogPurchOrder AT ROW 4 COL 83
          VIEW-AS TOGGLE-BOX
          SIZE 20.5 BY .79
     gcStrasse AT ROW 5 COL 21 COLON-ALIGNED
     E_BelegKopf.SBM_ProfitCenter_Obj AT ROW 5.5 COL 81 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY 1
     E_Bele_SBM_ProfitCenter_Obj_Info AT ROW 5.5 COL 101 COLON-ALIGNED NO-LABEL
     gcOrt AT ROW 6 COL 21 COLON-ALIGNED
     E_BelegKopf.Sachbearbeiter AT ROW 6.5 COL 81 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY 1
     E_BelegKopf_Sachbearbeiter_Info AT ROW 6.5 COL 97 COLON-ALIGNED NO-LABEL
     E_BelegKopf.AuftragsArt AT ROW 7.5 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY 1
     E_BelegKopf_AuftragsArt_Info AT ROW 7.5 COL 29 COLON-ALIGNED NO-LABEL
     E_BelegKopf.Wiedervorlage AT ROW 7.5 COL 81 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY 1
     E_BelegKopf_Wiedervorlage_Info AT ROW 7.5 COL 93 COLON-ALIGNED NO-LABEL
     sRecordState AT ROW 1 COL 95
     sTextInfo AT ROW 1 COL 99
     sNoteInfo AT ROW 1 COL 103
     sDocInfo AT ROW 1 COL 107
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: MaWi.E_BelegKopf
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
   Temp-Tables and Buffers:
      TABLE: TT_E_BelegPos T "?" NO-UNDO temp-db TD_E_BelegPos
   END-TABLES.
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
         HEIGHT             = 8.13
         WIDTH              = 118.67.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{stamm/incl/s__adr00.lib}
{adm/method/incl/dm_viw01.lib}
{basis/text/incl/bt_txt00.lib}
{eink/incl/e__buc00.lib}
/* --> UMO#CA2015-10-002 PWa Packmittel - Poolbuchungen */
&IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
{branche/mawi/incl/um_pmi00.lib}
&ENDIF
/* <-- UMO#CA2015-10-002 PWa Packmittel - Poolbuchungen */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN E_BelegKopf.AuftragsArt IN FRAME F-Main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN E_BelegKopf.BelegDatum IN FRAME F-Main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN E_BelegKopf.BelegNummer IN FRAME F-Main
   NO-ENABLE 2 6                                                        */
/* SETTINGS FOR TOGGLE-BOX E_BelegKopf.CatalogPurchOrder IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN E_Bele_SBM_ProfitCenter_Obj_Info IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN E_BelegKopf_AuftragsArt_Info IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN E_BelegKopf_BelegDatum_Info IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN E_BelegKopf_Sachbearbeiter_Info IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN E_BelegKopf_Wiedervorlage_Info IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gcName1 IN FRAME F-Main
   NO-ENABLE LIKE = basis.E_BelegKopfAdr.Name1 EXP-SIZE                 */
/* SETTINGS FOR FILL-IN gcName2 IN FRAME F-Main
   NO-ENABLE LIKE = basis.E_BelegKopfAdr.Name2 EXP-SIZE                 */
/* SETTINGS FOR FILL-IN gcOrt IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gcStrasse IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN E_BelegKopf.Lieferant IN FRAME F-Main
   2 6                                                                  */
/* SETTINGS FOR TOGGLE-BOX E_BelegKopf.offen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN E_BelegKopf.Sachbearbeiter IN FRAME F-Main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN E_BelegKopf.SBM_ProfitCenter_Obj IN FRAME F-Main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR IMAGE sDocInfo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR IMAGE sNoteInfo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR IMAGE sRecordState IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR IMAGE sTextInfo IN FRAME F-Main
   NO-ENABLE                                                            */
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

&Scoped-define SELF-NAME E_BelegKopf.AuftragsArt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL E_BelegKopf.AuftragsArt V-table-Win
ON leave OF E_BelegKopf.AuftragsArt IN FRAME F-Main /* Auftragsart */
do:
  {adm/template/incl/dt_uit00.if
     &UserExitName = "ON_LEAVE_OF_E_BelegKopf_AuftragsArt"}

  {adm/template/incl/dt_viw03.if}

  {adm/template/incl/dt_uit01.if
     &UserExitName = "ON_LEAVE_OF_E_BelegKopf_AuftragsArt"}
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME E_BelegKopf.BelegDatum
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL E_BelegKopf.BelegDatum V-table-Win
ON leave OF E_BelegKopf.BelegDatum IN FRAME F-Main /* Belegdatum */
do:
  {adm/template/incl/dt_uit00.if
     &UserExitName = "ON_LEAVE_OF_E_BelegKopf_BelegDatum"}

  {adm/template/incl/dt_viw03.if}

  {adm/template/incl/dt_uit01.if
     &UserExitName = "ON_LEAVE_OF_E_BelegKopf_BelegDatum"}
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME E_BelegKopf.Sachbearbeiter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL E_BelegKopf.Sachbearbeiter V-table-Win
ON leave OF E_BelegKopf.Sachbearbeiter IN FRAME F-Main /* Sachbearbeiter */
do:
  {adm/template/incl/dt_uit00.if
     &UserExitName = "ON_LEAVE_OF_E_BelegKopf_Sachbearbeiter"}

  {adm/template/incl/dt_viw03.if}

  {adm/template/incl/dt_uit01.if
     &UserExitName = "ON_LEAVE_OF_E_BelegKopf_Sachbearbeiter"}
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME E_BelegKopf.Wiedervorlage
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL E_BelegKopf.Wiedervorlage V-table-Win
ON leave OF E_BelegKopf.Wiedervorlage IN FRAME F-Main /* Wiedervorlage */
do:
  {adm/template/incl/dt_uit00.if
     &UserExitName = "ON_LEAVE_OF_E_BelegKopf_Wiedervorlage"}

  {adm/template/incl/dt_viw03.if}

  {adm/template/incl/dt_uit01.if
     &UserExitName = "ON_LEAVE_OF_E_BelegKopf_Wiedervorlage"}
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN
    run dispatch in THIS-PROCEDURE ('initialize':U).
  &ENDIF

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-_check-record) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _check-record Method-Library
procedure _check-record :
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
/* pcFunction - Art der Bearbeitung                                           */
/*                                                                            */
/* Examples ------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/*----------------------------------------------------------------------------*/

define input parameter pcFunction as character no-undo.

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

if   (    pcFunction  = 'delete':U
      and not pa-fields-enabled)
  or (    pcFunction = 'update':U
      and not adm-new-record
      and glZustandPruefen = yes) then
do:
  
  /* Check and display the state of the record only once                      */
  
  glZustandPruefen = no.
  
  if available E_BelegKopf then

    basis.buro.cls.BBCWorkflowSvc:prpoInstance:showLockStatus
      (E_BelegKopf.E_BelegKopf_Obj,
      gcBereich).
       
  if    available E_BelegKopf
    and available S_Lieferant then

    basis.buro.cls.BBCWorkflowSvc:prpoInstance:showLockStatus
      (S_Lieferant.S_Lieferant_Obj,
       gcBereich).
       
end. /* if   (    pcFunction  = 'delete':U */

end procedure. /* _check-record */


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AddressDialog V-table-Win 
PROCEDURE AddressDialog :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Starts address dialog of purchase order header for once only suppliers.    */
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

define variable cCountryIso_Dept         like SBM_TaxTerritory.IsoAlpha2Code        no-undo.
define variable cCommunityObj            like SBM_ComOfStates.SBM_ComOfStates_Obj   no-undo.
define variable cTerritoryStructure_Dept like E_BelegKopf.Dept_SBM_TaxTerritory_Obj no-undo.

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

{eink/incl/e_pbel01.if}

/* determine the new territory structure of the departure address and compare */
/* it with the old one                                                        */

assign
  cCountryIso_Dept         = {fnarg
                               pa_cInternalStateCodeToIsoAlpha2Code
                               "ttS_Adresse.Staat"}
  cCommunityObj            = stamm.base.cls.SBCTaxMasterFilesSvc:prpoInstance:cTaxRelCommunityOfTransaction
                               (cCountryIso_Dept,
                                stamm.base.cls.SBCTaxMasterFilesSvc:prpoInstance:cIsoAlphaCodeOfTaxTerritory
                                  (E_BelegKopf.Dest_SBM_TaxTerritory_Obj[{&pa_SB_TaxTerritoryExt_Country}]),
                                E_BelegKopf.BelegDatum)
  cTerritoryStructure_Dept = stamm.base.cls.SBCTaxMasterFilesSvc:prpoInstance:cTerritoryStrExtentForAdressDetails
                               (E_BelegKopf.BelegDatum,
                                ttS_Adresse.Staat,
                                ttS_Adresse.Bundesland,
                                ttS_Adresse.Ort,
                                ttS_Adresse.PLZ,
                                ttS_Adresse.AdressNr)
  cTerritoryStructure_Dept[{&pa_SB_TaxTerritoryExt_Community}] = cCommunityObj
  .

if stamm.base.cls.SBCTaxMasterFilesSvc:prpoInstance:lTaxTerritoryExtentsAreEqual
     (cTerritoryStructure_Dept,
      E_BelegKopf.Dept_SBM_TaxTerritory_Obj) = no then
do:

  eink.base.cls.EBCPurchaseDocSvc:prpoInstance:ChangeDocDeptTerritoryStructure
    (E_BelegKopf.E_BelegKopf_Obj,
     cTerritoryStructure_Dept).

  run new-state('refresh,record-target':U).

end. /* if stamm.base.cls.SBCTaxMasterFilesSvc ... */

end procedure. /* AddressDialog */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-ParameterDialog V-table-Win 
PROCEDURE adm-ParameterDialog :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Starts parameter dialog of purchase order header                           */
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

define variable cTemp   as character no-undo.
define variable lCancel as logical   no-undo.

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

if    available E_BelegKopf
  and E_BelegKopf.offen = yes then
do:

  run eink/proc/e_pbel02.w
    (input        string(rowid(E_BelegKopf)),
           output lCancel,
     input-output cTemp).

  /* If the Cancel-Button was pressed, then do not continue.                  */
  /* 'ADM-ERROR' is attended in dm_tbr00.lib.                                 */

  if lCancel = yes then

    return 'ADM-ERROR':U.

  run notify ('display-protected-fields,record-target':U).

  run dispatch ('display-protected-fields':U).

  if return-value <> 'ADM-ERROR':U then
    run new-state ('refresh,record-target':U).

end.  /* if available E_BelegKopf then */

end procedure. /* ParameterDialog */

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

{adm/template/incl/row-list.i "E_BelegKopf"}

/* Get the record ROWID's from the RECORD-SOURCE.                             */

{adm/template/incl/row-get.i}

/* FIND each record specified by the RECORD-SOURCE.                           */

{adm/template/incl/row-find.i "E_BelegKopf"}

/* Process the newly available records (i.e. display fields, open queries,    */
/* and/or pass records on to any RECORD-TARGETS).                             */

{adm/template/incl/row-end.i}

end procedure. /* adm-row-available */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AufrufLiefBeistFA V-table-Win 
PROCEDURE AufrufLiefBeistFA :
/*------------------------------------------------------------------------------
  Purpose:     Sind für den aktuellen Beleg Fremdbeistellungen möglich, so wird
               die ReferenzNr des aktuellen Beleges zurückgegeben. Wenn keine
               Fremdbeistellungen möglich sind, so wird 0 zurückgegeben.
  Parameters:  output piReferenzNr
  Notes:
------------------------------------------------------------------------------*/

define output parameter piReferenzNr as integer no-undo init 0.

&IF LOOKUP("MB":U,"{&PA-MODULE}":U) > 0 &THEN

  define buffer E_BelegPos for E_BelegPos.

  AufrufLiefBeistFA_Main:
  do transaction
    on error undo, throw:

    if available E_BelegKopf then
    do:

      /* Zustand des Lieferanten für den Zielbeleg prüfen */

      find S_Lieferant
        where S_Lieferant.Firma     = {firma/sliefera.fir pa-firma}
          and S_Lieferant.Lieferant = E_BelegKopf.Lieferant
        no-lock no-error.

      if available S_Lieferant then
      do:

        /*--------------------------------------------------------------------*/
        /* Sperre S_Lieferant für MLL                                         */
        /*--------------------------------------------------------------------*/

        if basis.buro.cls.BBCWorkflowSvc:prpoInstance:lHasLockStatusWarningOrLock
             (S_Lieferant.S_Lieferant_Obj,
              'MLL':U) then

          basis.buro.cls.BBCWorkflowSvc:prpoInstance:showLockStatus
            (S_Lieferant.S_Lieferant_Obj,
             'MLL':U).

      end. /* if available S_Lieferant */

      Positionen:
      for each E_BelegPos
        where E_BelegPos.Firma               = {firma/ebelkop.fir pa-Firma}
          and E_BelegPos.Belegart            = E_BelegKopf.Belegart
          and E_BelegPos.ReferenzNr          = E_BelegKopf.ReferenzNr
          and E_BelegPos.Coverage_MRPDocType = 'PPF':U
          and E_BelegPos.Coverage_Obj       <> ?
          and can-find (S_Artikel
                          where S_Artikel.Firma      = {firma/sartikel.fir pa-Firma}
                            and S_Artikel.Artikel    = E_BelegPos.Artikel
                            and S_Artikel.ArtikelArt = {&pa_S_PT_OutsourcedOperation})
        no-lock
        on error undo, throw:

        find MB_Aktivitaet
          where MB_Aktivitaet.MB_Aktivitaet_Obj = E_BelegPos.Coverage_Obj
            and MB_Aktivitaet.Artikel           > '':U
          no-lock no-error.

        if available MB_Aktivitaet then
        do:

          piReferenzNr = E_BelegKopf.ReferenzNr.

          leave Positionen.

        end.

      end. /* for each E_BelegPos */

    end. /* available E_BelegKopf */

    catch oError as Progress.Lang.Error:

      (new adm.method.cls.DMCErrorFrw(oError)):displayProgressErrorsOnly().

      adm.method.cls.DMCMessageSvc:prpoInstance:showError
        ('mlbel00006':U).

    end catch.

  end. /* AufrufLiefBeistFA_Main */

&ENDIF /* &IF LOOKUP("PP":U,"{&PA-MODULE}":U) > 0 */

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CreateNewRecord V-table-Win 
PROCEDURE CreateNewRecord :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Create a new record by using a dialog-box                                  */
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
/* cSatzId             rowid of the new record                                */
/*----------------------------------------------------------------------------*/

define variable cTemp   as character no-undo.
define variable cSatzId as character no-undo.

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

{&{&PA-XBASISName}_C_CreateNewRecord_Header}
{&{&PA-XBASISName}_U_CreateNewRecord_Header}
{&{&PA-XBASISName}_Q_CreateNewRecord_Header}
{&{&PA-XBASISName}_CreateNewRecord_Header}
{&{&PA-XBASISName}_Y_CreateNewRecord_Header}

/* Open a dialog-box for new entry */

run eink/proc/e_pbel00.w (input        gcBelegart,
                                output cSatzId,
                          input-output cTemp).

if cSatzId = ? then

  undo, throw new adm.method.cls.DMCErrorErr().

do transaction
  on error undo, throw:

  find E_BelegKopf
    where rowid(E_BelegKopf) = to-rowid(cSatzId)
    exclusive-lock.

end.

{eink/incl/e_pbel12.if}

{&{&PA-XBASISName}_C_CreateNewRecord_Trailer}
{&{&PA-XBASISName}_U_CreateNewRecord_Trailer}
{&{&PA-XBASISName}_Q_CreateNewRecord_Trailer}
{&{&PA-XBASISName}_CreateNewRecord_Trailer}
{&{&PA-XBASISName}_Y_CreateNewRecord_Trailer}

return.

end procedure. /* CreateNewRecord */

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

  if can-do(pcFields,'E_BelegKopf.AuftragsArt':U) then
    if E_BelegKopf_AuftragsArt_Info:private-data <> E_BelegKopf.AuftragsArt:screen-value then
    do:

      if input frame {&Frame-Name} E_BelegKopf.AuftragsArt = '':U then

        assign
          {setwidgetattr E_BelegKopf_AuftragsArt_Info private-data '':U}
          {setwidgetattr E_BelegKopf_AuftragsArt_Info screen-value '':U}
          E_BelegKopf_AuftragsArt_Info
          .

      else
      do:

        E_BelegKopf_AuftragsArt_Info
          = {fnarg
              pa_cDyCchOrderTypeDesc
              "pa-Firma,
               input frame {&Frame-Name} E_BelegKopf.AuftragsArt,
               pa-Sprache"}.

        if E_BelegKopf_AuftragsArt_Info <> ? then
          {setwidgetattr E_BelegKopf_AuftragsArt_Info private-data E_BelegKopf.AuftragsArt:screen-value}.
        else
          assign
            {setwidgetattr E_BelegKopf_AuftragsArt_Info private-data string(?)}
            E_BelegKopf_AuftragsArt_Info = '':U
            .

        {setwidgetattr E_BelegKopf_AuftragsArt_Info screen-value E_BelegKopf_AuftragsArt_Info}.

      end.

    end.

  if can-do(pcFields,'E_BelegKopf.Sachbearbeiter':U) then
    if E_BelegKopf_Sachbearbeiter_Info:private-data <> E_BelegKopf.Sachbearbeiter:screen-value then
    do:

      if input frame {&Frame-Name} E_BelegKopf.Sachbearbeiter = '':U then

        assign
          {setwidgetattr E_BelegKopf_Sachbearbeiter_Info private-data '':U}
          {setwidgetattr E_BelegKopf_Sachbearbeiter_Info screen-value '':U}
          E_BelegKopf_Sachbearbeiter_Info
          .

      else
      do:

        E_BelegKopf_Sachbearbeiter_Info
          = {fnarg
              pa_cDyCchUserName
              "input frame {&Frame-Name} E_BelegKopf.Sachbearbeiter,
               {&pa_CchDesc}"}.

        if E_BelegKopf_Sachbearbeiter_Info <> ? then
          {setwidgetattr E_BelegKopf_Sachbearbeiter_Info private-data E_BelegKopf.Sachbearbeiter:screen-value}.
        else
          assign
            {setwidgetattr E_BelegKopf_Sachbearbeiter_Info private-data string(?)}
            E_BelegKopf_Sachbearbeiter_Info              = '':U
            .

        {setwidgetattr E_BelegKopf_Sachbearbeiter_Info screen-value E_BelegKopf_Sachbearbeiter_Info}.


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
/*------------------------------------------------------------------------------
  Purpose:     Übertragung der XML-Daten an DM-Office
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

&IF lookup('O_':U,'{&PA-MODULE}':U) > 0 &THEN
  {arch/incl/o__oat31.if}
&ENDIF

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dms-send-wordtext V-table-Win 
PROCEDURE dms-send-wordtext :
/*------------------------------------------------------------------------------
  Purpose:     Übertragung der XML-Daten an DM-Office
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

&IF lookup('O_':U,'{&PA-MODULE}':U) > 0 &THEN
  {arch/incl/o__wbm31.if}
&ENDIF

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE find-internal-tables V-table-Win  adm/support/proc/ds_rec03.p
PROCEDURE find-internal-tables :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Finds internal tables of a SmartViewer                                     */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/* FOR INTERNAL USE ONLY                                                      */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* <NONE>                                                                     */
/*                                                                            */
/*----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

{adm/template/incl/dt_fin00.if
  &TABLE    = "ttS_Adresse"
  &WHERE    = "where ttS_Adresse.Firma = {firma/s_adres.fir pACConnectionSvc:prpcCompany}
               and ttS_Adresse.AdressNr = E_BelegKopfAdr.AdressNr"
}

return.

end procedure. /* find-internal-tables */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generiereMLL V-table-Win 
PROCEDURE generiereMLL : 
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Erzeuge den Lieferschein an Lager zu allen Positionen des Beleges  für die */
/* eine Beistellung erfolgen soll.                                            */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* plTeilbeistellung   i   Soll Beistellung nur für eine Teilmenge erfolgen?  */
/* piReferenzNr        o   Referenznummer der aktuellen Bestellung            */
/*                                                                            */
/*----------------------------------------------------------------------------*/

define input  parameter plTeilbeistellung as logical no-undo.
define output parameter piReferenzNr      as integer no-undo init ?.

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

define variable iNummer              as   integer                                no-undo.
define variable iPositionsNr         as   integer                                no-undo.
define variable iAktLagerort         as   integer                                no-undo init ?.
define variable iMRPArea             like ML_Lagergruppe.Lagergruppe             no-undo.
define variable dMenge               as   decimal decimals 3                     no-undo.
define variable cTemp                as   character                              no-undo.
&IF lookup ("E_INTRA","{&PA-OPTIONEN}") > 0 &THEN
  define variable lIntrastatRelevant like ML_BelegKopf.ReportObligation          no-undo.
  define variable dAverageCosts      as   decimal extent {&pa_MM_Fraction_Count} no-undo.
&ENDIF

/* Buffers -------------------------------------------------------------------*/

define buffer S_Artikel        for S_Artikel.
define buffer E_BelegPos       for E_BelegPos.
define buffer E_BelegPosBei    for E_BelegPosBei.
define buffer ML_BelegKopf     for ML_BelegKopf.
define buffer ML_BelegPos      for ML_BelegPos.
define buffer bMMM_CusRefOrder for MMM_CusRefOrder.
define buffer b1ML_Ort         for ML_Ort.
define buffer b2ML_Ort         for ML_Ort.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

generiereMLL_Main:
do for ML_BelegKopf transaction
  on error undo, throw:

  if available E_BelegKopf then
  do:

    /* Zustand des Lieferanten für den Zielbeleg prüfen */

    find S_Lieferant
      where S_Lieferant.Firma     = {firma/sliefera.fir pa-firma}
        and S_Lieferant.Lieferant = E_BelegKopf.Lieferant
      no-lock no-error.

    if available S_Lieferant then

      /*----------------------------------------------------------------------*/
      /* Sperre S_Lieferant für MLL                                           */
      /*----------------------------------------------------------------------*/

      if basis.buro.cls.BBCWorkflowSvc:prpoInstance:lHasLockStatusWarningOrLock
           (S_Lieferant.S_Lieferant_Obj,
            'MLL':U) then

        basis.buro.cls.BBCWorkflowSvc:prpoInstance:showLockStatus
          (S_Lieferant.S_Lieferant_Obj,
           'MLL':U).

    /*------------------------------------------------------------------------*/
    /* Check hold of document header                                          */
    /*------------------------------------------------------------------------*/

    if basis.buro.cls.BBCWorkflowSvc:prpoInstance:lHasLockStatusWarningOrLock
      (E_BelegKopf.E_BelegKopf_Obj,
       'MLL':U) then

      basis.buro.cls.BBCWorkflowSvc:prpoInstance:showLockStatus
        (E_BelegKopf.E_BelegKopf_Obj,
         'MLL':U).

    find current E_BelegKopf
      exclusive-lock.

    empty temp-table TT_E_BelegPos.

    if plTeilbeistellung then
    do:

      /* Fülle die Temp-Table mit den Bestellpositionen mit kommissionsbe-    */
      /* zogener Beistellung. Je Position können die Beistellmengen in Ab-    */
      /* hängigkeit der Positionsmenge festgelegt werden.                     */

      run eink/proc/e_ubei00.w (input        E_BelegKopf.BelegArt,
                                input        E_BelegKopf.ReferenzNr,
                                      output table TT_E_BelegPos,
                                input-output cTemp).

      if not can-find (first TT_E_BelegPos
                         where TT_E_BelegPos.Menge <> 0) then
      do
        on error undo, return:

        adm.method.cls.DMCMessageSvc:prpoInstance:showError('mlbel00007':U).

      end. /* if not can-find (first TT_E_BelegPos */

    end. /* if plTeilbeistellung */

    /* Die Anzahl der Beistellpositionen je Bestellbeleg sollte sich auf   */
    /* wenige Positionen beschränken, so dass die Definition eines Indizes */
    /* überflüssig sein dürfte.                                            */

    Beistellpositionen:
    for each E_BelegPosBei                   /* Code checked by wl 07.10.2002 */
      where E_BelegPosBei.Firma      = {firma/ebelkop.fir pa-Firma}
        and E_BelegPosBei.Belegart   = E_BelegKopf.Belegart
        and E_BelegPosBei.ReferenzNr = E_BelegKopf.ReferenzNr
        and E_BelegPosBei.Lagerort  <> ?
        and E_BelegPosBei.Lagerort  <> E_BelegPosBei.KO_Lagerort
      no-lock,
    first E_BelegPos
      where E_BelegPos.Firma       = {firma/ebelkop.fir pa-Firma}
        and E_BelegPos.BelegArt    = E_BelegKopf.BelegArt
        and E_BelegPos.ReferenzNr  = E_BelegKopf.ReferenzNr
        and E_BelegPos.PositionsNr = E_BelegPosBei.PositionsNr
        and E_BelegPos.offen       = yes
      no-lock
      break by E_BelegPosBei.KO_Lagerort
            by E_BelegPosBei.PositionsNr
            by E_BelegPosBei.BeistellNr
      on error undo, throw:

      if plTeilbeistellung then
      do:

        find TT_E_BelegPos
          where TT_E_BelegPos.PositionsNr = E_BelegPosBei.PositionsNr
          no-error.

        if   not available TT_E_BelegPos
          or TT_E_BelegPos.Menge = 0 then

          next Beistellpositionen.

      end. /* if plTeilbeistellung then */

      find S_Artikel
        where S_Artikel.Firma   = {firma/sartikel.fir pa-Firma}
          and S_Artikel.Artikel = E_BelegPosBei.Beistellartikel
        no-lock.

      /* Zustand des Teiles prüfen */

      if basis.buro.cls.BBCWorkflowSvc:prpoInstance:lHasLockStatusWarningOrLock
           (S_Artikel.S_Artikel_Obj,
            'S_A':U) then

        basis.buro.cls.BBCWorkflowSvc:prpoInstance:showLockStatus
          (S_Artikel.S_Artikel_Obj,
           'S_A':U).

      /* Zustand des Teils für Zielbeleg prüfen */

      if basis.buro.cls.BBCWorkflowSvc:prpoInstance:lHasLockStatusWarningOrLock
           (S_Artikel.S_Artikel_Obj,
            'MLL':U) then

        basis.buro.cls.BBCWorkflowSvc:prpoInstance:showLockStatus
          (S_Artikel.S_Artikel_Obj,
           'MLL':U).

      /* If parts are privided partially, then TT_E_BelegPos.Menge is yet  */
      /* the correct quantity for the shipping document to warehouse.      */
      /* Over adoption is not possible. Therefore deduce the yet delivered */
      /* quantity.                                                         */

      dMenge = ((if lIsRepairOrderLine(E_BelegPos.BelegArt,
                                       E_BelegPos.ReferenzNr,
                                       E_BelegPos.PositionsNr) = no then
                   (if available TT_E_BelegPos then
                      round(E_BelegPosBei.Mengenfaktor * TT_E_BelegPos.Menge,
                            E_BelegPosBei.Nachkomma)
                    else
                      round(E_BelegPosBei.Mengenfaktor * E_BelegPos.Menge,
                            E_BelegPosBei.Nachkomma))
                 else
                   E_BelegPosBei.ProvidedPartQuantity)
                - E_BelegPosBei.gelieferte_Menge).

      if dMenge = 0 then
        next Beistellpositionen.

      /* Müssen noch Teile beigestellt werden, so ist der Ziellagerort das */
      /* Konsignationslager. Wurde hingegen zuviel beigestellt (z.B. wenn  */
      /* die Bestellmenge reduziert wurde), so muss die Menge vom Konsig-  */
      /* nationslager auf das Beistelllager gebucht werden.                */

      if   (    dMenge        > 0
            and iAktLagerort <> E_BelegPosBei.KO_Lagerort)
        or (    dMenge       <  0
            and iAktLagerort <> E_BelegPosBei.Lagerort) then
      do:

        iPositionsNr = 0.

        /*--------------------------------------------------------------------*/
        /* vergebe Belegnummer                                                */
        /*--------------------------------------------------------------------*/

        {stamm/incl/s__num00.if
          &Tabelle       = "ML_BelegKopf"
          &Firma         = "{firma/mlartort.fir pa-Firma}"
          &BelegArt      = "'MLL':U"
          &BelegArtBeleg = "'MLL':U"
          &Offen         = "yes"
          &BelegNummer   = "iNummer"
        }

        if iNummer = ? then

          adm.method.cls.DMCMessageSvc:prpoInstance:showError
            ('e_bel00002':U).

        /*--------------------------------------------------------------------*/
        /* erzeuge ML_BelegKopf                                               */
        /*--------------------------------------------------------------------*/

        create ML_BelegKopf.

        assign
          ML_BelegKopf.Firma            = {firma/mlartort.fir pa-Firma}
          ML_BelegKopf.BelegArt         = 'MLL':U
          ML_BelegKopf.Belegnummer      = iNummer
          ML_BelegKopf.offen            = yes
          ML_BelegKopf.Lagerort         = (if dMenge > 0 then
                                             E_BelegPosBei.KO_Lagerort
                                           else
                                             E_BelegPosBei.Lagerort)
          ML_BelegKopf.Herk_BelegArt    = E_BelegKopf.BelegArt
          ML_BelegKopf.Herk_Belegnummer = E_BelegKopf.BelegNummer
          ML_BelegKopf.Herk_BelegDatum  = E_BelegKopf.BelegDatum
          ML_BelegKopf.AuftragsArt      = E_BelegKopf.AuftragsArt
          iAktLagerort                  = ML_BelegKopf.Lagerort
          .

        validate ML_BelegKopf.

        assign
          ML_BelegKopf.Konto            = E_BelegKopf.Lieferant
          ML_BelegKopf.Empfaenger       = E_BelegKopf.Empfaenger
          ML_BelegKopf.LieferHinweis    = E_BelegKopf.LieferHinweis
          ML_BelegKopf.BelegInfo        = E_BelegKopf.BelegInfo
          ML_BelegKopf.Lieferbedingung  = E_BelegKopf.Lieferbedingung
          ML_BelegKopf.Versandart       = E_BelegKopf.Versandart
          ML_BelegKopf.Bestelldatum     = E_BelegKopf.Belegdatum
          ML_BelegKopf.Uebernahme       = yes
          ML_BelegKopf.BelegDatum       = today
          .

        &IF LOOKUP("S_ProfCenter","{&PA-OPTIONEN}") > 0 &THEN

          mawi.lager.cls.MLCShippingDocSvc:prpoInstance:InitChooseProfitCenterDocAdopt
            (       E_BelegKopf.SBM_ProfitCenter_Obj, /* Adopted, source document */
                    E_BelegKopf.SBM_ProfitCenter_ID,
                    ML_BelegKopf.Belegart,            /* Target document Type     */
                    ML_BelegKopf.Lagerort,
                    ML_BelegKopf.Belegdatum,
             output ML_BelegKopf.SBM_ProfitCenter_Obj,
             output ML_BelegKopf.SBM_Profitcenter_ID).

        &ENDIF /* S_ProfCenter */

        /* Übernahme der Belegtexte */

        if adm.config.cls.DCCAppConfigSvc:prpoInstance:lParameterValue
             ('EB_CopyTextToShipDocToWH':U) = yes then

          assign
            ML_BelegKopf.Kopftext[1]  = E_BelegKopf.KopfText[1]
            ML_BelegKopf.Kopftext[2]  = E_BelegKopf.KopfText[2]
            ML_BelegKopf.Kopftext[3]  = E_BelegKopf.KopfText[3]
            ML_BelegKopf.Kopftext[4]  = E_BelegKopf.KopfText[4]
            ML_BelegKopf.Bemerkung[1] = E_BelegKopf.Bemerkung[1]
            ML_BelegKopf.Bemerkung[2] = E_BelegKopf.Bemerkung[2]
            ML_BelegKopf.Bemerkung[3] = E_BelegKopf.Bemerkung[3]
            .

        validate ML_BelegKopf.

        /*--------------------------------------------------------------------*/
        /* Erzeuge einen COLD-Job                                             */
        /*--------------------------------------------------------------------*/

        &IF LOOKUP ("O_COLD","{&PA-OPTIONEN}") > 0 &THEN

          {arch/incl/o__col00.if
            &FIRMA    = "ML_BelegKopf.Firma"
            &BELEGART = "ML_BelegKopf.BelegArt"
            &ROWID    = "rowid(ML_BelegKopf)"
            &ACTION   = "'UI':U"
          }

        &ENDIF

      end. /* if (dMenge > 0 ... */

      if   E_BelegPosBei.KommLager = 2
        or mawi.base.cls.MMCCROSvc:prpoInstance:lIsExternalCRO(E_BelegPos.MMM_CusRefOrder_Obj) then

        find bMMM_CusRefOrder
          where bMMM_CusRefOrder.MMM_CusRefOrder_Obj = E_BelegPos.MMM_CusRefOrder_Obj
          no-lock no-error.

      iPositionsNr = iPositionsNr + 1.

      create ML_BelegPos.

      assign
        ML_BelegPos.Firma               = ML_BelegKopf.Firma
        ML_BelegPos.BelegArt            = ML_BelegKopf.BelegArt
        ML_BelegPos.ReferenzNr          = ML_BelegKopf.ReferenzNr
        ML_BelegPos.BelegNummer         = ML_BelegKopf.BelegNummer
        ML_BelegPos.SatzArt             = 'A':U
        ML_BelegPos.PositionsNr         = iPositionsNr
        ML_BelegPos.Artikel             = E_BelegPosBei.BeistellArtikel
        ML_BelegPos.ArtVar              = E_BelegPosBei.ArtVar
        ML_BelegPos.Herk_BelegArt       = E_BelegPosBei.BelegArt
        ML_BelegPos.Herk_ReferenzNr     = E_BelegPosBei.ReferenzNr
        ML_BelegPos.Herk_PositionsNr    = E_BelegPosBei.PositionsNr
        ML_BelegPos.Herk_BeistellNr     = E_BelegPosBei.BeistellNr
        ML_BelegPos.MMM_CusRefOrder_Obj = (if available bMMM_CusRefOrder then
                                             bMMM_CusRefOrder.MMM_CusRefOrder_Obj
                                           else
                                             '':U)
        ML_BelegPos.MMM_CusRefOrder_ID  = (if available bMMM_CusRefOrder then
                                             bMMM_CusRefOrder.MMM_CusRefOrder_ID
                                           else
                                             '':U)
        .

      validate ML_BelegPos.

      if dMenge > 0 then
      do:

        /* Behandlung kommissionsgesteuert disponierter Beistellteile         */

        {eink/incl/e__bei00.if}

      end. /* if dMenge > 0 */

      /* now we have to reservate the quantity of the current line            */

      find b1ML_Ort
        where b1ML_Ort.Firma    = {firma/mlort.fir pa-Firma}
          and b1ML_Ort.LagerOrt = (if dMenge > 0 then
                                     E_BelegPosBei.LagerOrt
                                   else
                                     E_BelegPosBei.KO_Lagerort)
        no-lock.

      /* Das Zwischenlager bestimmen                                      */

      iMRPArea = mawi.dispo.cls.MDCMRPAreaSvc:prpoInstance:iGetMRPAreaPart
                   (ML_BelegPos.Artikel,
                    (if dMenge > 0 then
                       E_BelegPosBei.LagerOrt
                     else
                       E_BelegPosBei.KO_Lagerort)).

      find b2ML_Ort                 /* Code checked by wl 04.11.2010 */
        where b2ML_Ort.Firma        = {firma/mlort.fir pa-Firma}
          and b2ML_Ort.Lagergruppe  = iMRPArea
          and b2ML_Ort.StorageType  = {&pa_ML_TransitStorArea}
        no-lock no-error.

      if not available b2ML_Ort then

        adm.method.cls.DMCMessageSvc:prpoInstance:showError
          ('mlort00009':U,
           string(iMRPArea)).

      mawi.base.cls.MMCReservationSvc:prpoInstance:TransferPosting
         (ML_BelegPos.ML_BelegPos_Obj,               /* Origin                                                  */
          'MLL':U,                                   /* DocType                                                 */
          E_BelegKopf.BelegArt,                      /* DocType Origin                                          */
          b1ML_Ort.ML_Ort_Obj,                       /* Storage Area Source                                     */
          b2ML_Ort.ML_Ort_Obj,                       /* Storage Area Target                                     */
          S_Artikel.S_Artikel_Obj,                   /* Part                                                    */
          ML_BelegPos.ArtVar,                        /* Variant                                                 */
          ML_BelegPos.MMM_CusRefOrder_Obj,           /* CRO                                                     */
          ML_BelegKopf.Belegdatum,                   /* DocumentDate                                            */
          abs(dMenge),                               /* Quantity (E_BelegPosBei.Mengenfaktor is yet resprected) */
          1,                                         /* Quantity factor                                         */
          S_Artikel.LagerME,                         /* Quantity Unit                                           */
          'LUB':U,                                   /* PostingCode                                             */
          &IF LOOKUP("MC","{&PA-MODULE}") > 0 &THEN  /* Option                                                  */
            if    lIsRepairOrderLine(E_BelegPos.BelegArt,
                                     E_BelegPos.ReferenzNr,
                                     E_BelegPos.PositionsNr)
              and can-find (S_Artikel
                              where S_Artikel.Firma      = {firma/sartikel.fir E_BelegPosBei.Firma}
                                and S_Artikel.Artikel    = E_BelegPosBei.BeistellArtikel
                                and S_Artikel.Chargenart > '':U) then
              {&pa_MM_ReserveInSilentMode} + ',':U + {&pa_MC_ReserveLotStrategyMANInSilentMode}
            else
          &ENDIF
          '':U).

      &IF LOOKUP("MC","{&PA-MODULE}") > 0 &THEN

        ML_BelegPos.ChargenListe = mawi.charge.cls.MCCLotStrategiesSvc:prpoInstance:cReviewReservationLotList
                                     (ML_BelegPos.ML_BelegPos_Obj).

      &ENDIF

      /* Übertrage die zu übernehmenden Inhalte in den neuen Satz *************/

      assign
        ML_BelegPos.LagerOrt     = (if dMenge > 0 then
                                      E_BelegPosBei.LagerOrt
                                    else
                                      E_BelegPosBei.KO_Lagerort)
        ML_BelegPos.Menge        = abs(dMenge)
        ML_BelegPos.offene_Menge = (if lIsRepairOrderLine(E_BelegPos.BelegArt,
                                                          E_BelegPos.ReferenzNr,
                                                          E_BelegPos.PositionsNr) = no then
                                      max(0,round(E_BelegPosBei.Mengenfaktor * E_BelegPos.Menge,
                                                  E_BelegPosBei.Nachkomma)
                                            - E_BelegPosBei.gelieferte_Menge
                                            - round(dMenge,
                                                    E_BelegPosBei.Nachkomma))
                                    else
                                      dMenge)
        .

      &IF lookup ("E_INTRA","{&PA-OPTIONEN}") > 0 &THEN

        if stamm.base.cls.SBCBusinessCategorySvc:prpoInstance:lHasCompanyIntraStatPurchasing(ML_BelegKopf.Belegdatum) then

          case pACConnectionSvc:prpcLocalization:

            {&{&PA-XBasisName}_C_Intra_Line}
            {&{&PA-XBasisName}_U_Intra_Line}
            {&{&PA-XBasisName}_Q_Intra_Line}
            {&{&PA-XBasisName}_Intra_Line}
            {&{&PA-XBasisName}_Y_Intra_Line}

            otherwise
            do:

              /* check if line is relevant for intrastat, if so then set intradata fields */

              run mawi/lager/proc/mlvint01.p(       ML_BelegPos.ML_BelegPos_Obj,
                                                    ML_BelegPos.Lagerort,
                                             output lIntrastatRelevant).

              if lIntrastatRelevant = yes then

                assign
                  ML_BelegPos.SBM_CustomsTariffNo_Obj = stamm.base.cls.SBCCustomsTariffNoSvc:prpoInstance:cGetValidCustomsTariffNo
                                                          (S_Artikel.SBM_CustomsTariffNo_Obj,ML_BelegKopf.BelegDatum)
                  dAverageCosts                       = mawi.lager.cls.MLCInventoryValSvc:prpoInstance:dAverageValue(ML_BelegPos.Artikel,
                                                                                                                     ML_BelegPos.Lagerort)
                                                                                                                    
                  ML_BelegPos.StatAccount             = round(  dAverageCosts[{&pa_MM_Fraction_Total}]
                                                              * ML_BelegPos.Menge,
                                                              (if pACConnectionSvc:prpcLocalization <> 'A':U then
                                                                 0
                                                               else
                                                                 2))
                  ML_BelegPos.StatQuantity            = ML_BelegPos.Menge / S_Artikel.BME_Faktor
                  .

            end. /* otherwise */

          end case. /* pACConnectionSvc:prpcLocalization */

      &ENDIF

      validate ML_BelegPos.

      /* --> UMO#CA2015-10-002 PWa Packmittel - Poolbuchungen */
      /* Erzeugen LSL aus Bestellung - Verpackung erzeugen */
      &IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN

        run uNewPackaging(pa-Firma,
                          '':U,
                          ML_BelegPos.ML_BelegPos_Obj).
      &ENDIF
      /* <-- UMO#CA2015-10-002 PWa Packmittel - Poolbuchungen */

      piReferenzNr = E_BelegKopf.ReferenzNr.

      &IF lookup ("E_INTRA":U,"{&PA-OPTIONEN}":U) > 0 &THEN

        if stamm.base.cls.SBCBusinessCategorySvc:prpoInstance:lHasCompanyIntraStatPurchasing(ML_BelegKopf.Belegdatum) then

          case pACConnectionSvc:prpcLocalization:

            {&{&PA-XBasisName}_C_Intra_Header}
            {&{&PA-XBasisName}_U_Intra_Header}
            {&{&PA-XBasisName}_Q_Intra_Header}
            {&{&PA-XBasisName}_Intra_Header}
            {&{&PA-XBasisName}_Y_Intra_Header}

            otherwise
            do:

              /* check if doc header is still relevant for intrastat */

              run mawi/lager/proc/mlvint01.p(       ML_BelegKopf.ML_BelegKopf_Obj,
                                                    ?,
                                             output lIntrastatRelevant).

              assign
                ML_BelegKopf.ReportObligation         = (lIntrastatRelevant = yes)
                ML_BelegKopf.SBM_BusinessCategory_Obj = (if lIntrastatRelevant = yes then
                                                           stamm.base.cls.SBCBusinessCategorySvc:prpoInstance:cGetDefaultBusinessCategoryOIDSubcontracting(ML_BelegKopf.BelegDatum)    /* zur Lohnveredelung */
                                                         else
                                                           stamm.base.cls.SBCBusinessCategorySvc:prpoInstance:cGetBusinessCategoryUndefinedOID())   /* undefined */
                .

            end. /* otherwise */

          end case. /* pACConnectionSvc:prpcLocalization */

      &ENDIF

    end. /* for each E_BelegPosBei */

  end. /* available E_BelegKopf */

  catch oError as Progress.Lang.Error:

   (new adm.method.cls.DMCErrorFrw(oError)):displayProgressErrorsOnly().

    adm.method.cls.DMCMessageSvc:prpoInstance:showError
      ('mlbel00007':U).

  end catch.

end. /* generiereMLL_Main */

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-AdrDesc V-table-Win 
PROCEDURE get-AdrDesc :
/*------------------------------------------------------------------------------
  Purpose:     Liefert die Beschreibung zum aktuellen Objekt
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

  if available E_BelegKopf then

    if    input frame {&frame-name} E_BelegKopf.Empfaenger <> '':U
      and can-find (first S_Ansprech
                      where S_Ansprech.Firma         = {firma/sliefera.fir pa-firma}
                        and S_Ansprech.Kontenbereich = 2
                        and S_Ansprech.Konto         = E_BelegKopf.Lieferant
                        and S_Ansprech.Name          = input frame {&frame-name} E_BelegKopf.Empfaenger
                        and (   S_Ansprech.Telefon   > '':U
                             or S_Ansprech.Handy     > '':U)) then

      return 'Ansprechpartner':T30.

    else
      return 'Lieferant':T30.

  else
    return ?.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-AdrName V-table-Win 
PROCEDURE get-AdrName :
/*------------------------------------------------------------------------------
  Purpose:     Liefert den Namen des aktuellen Adressobjektes
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

  define buffer S_Ansprech for S_Ansprech.

  if available E_BelegKopf then
  do:

    if input frame {&frame-name} E_BelegKopf.Empfaenger <> '':U then
    do:

      find first S_Ansprech
        where S_Ansprech.Firma         = {firma/sliefera.fir pa-firma}
          and S_Ansprech.Kontenbereich = 2
          and S_Ansprech.Konto         = E_BelegKopf.Lieferant
          and S_Ansprech.Name          = input frame {&frame-name} E_BelegKopf.Empfaenger
          and (   S_Ansprech.Telefon   > '':U
               or S_Ansprech.Handy     > '':U)
        no-lock no-error.

      if available S_Ansprech then
        return S_Ansprech.Name.

    end.

    find E_BelegKopfAdr
      where E_BelegKopfAdr.Firma      = E_BelegKopf.Firma
        and E_BelegKopfAdr.Belegart   = E_BelegKopf.Belegart
        and E_BelegKopfAdr.ReferenzNr = E_BelegKopf.ReferenzNr
        and E_BelegKopfAdr.Typ        = 'A':U
      no-lock no-error.

    if available E_BelegKopfAdr then
      return E_BelegKopfAdr.Name1.

    else if available S_Adresse then
      return S_Adresse.Name1.
    else
      return ?.

  end. /* if available E_BelegKopf */
  else
    return ?.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-ChangeTaxationBase V-table-Win 
PROCEDURE get-ChangeTaxationBase :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Checks if the Taxation Base can be changed                                 */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/* This Procedure use the global buffer E_BelegKopf                           */
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

if    not pa-fields-enabled
  and available E_BelegKopf
  and eink.base.cls.EBCPurchaseDocSvc:prpoInstance:lIsTaxationChangeable(E_BelegKopf.E_BelegKopf_Obj) = yes then
  return 'yes':U.
else
  return 'no':U.

end procedure. /* get-ChangeTaxationBase */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-DeliveryProvPartsExtOperation V-table-Win 
PROCEDURE get-DeliveryProvPartsExtOperation :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Checks if we can call the Delivery of Provided Parts for External Opera-   */
/* tions                                                                      */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/* This Procedure use the global buffer E_BelegKopf                           */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* <none>                                                                     */
/*                                                                            */
/*----------------------------------------------------------------------------*/

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

define variable lFremdarbeitVorhanden as logical no-undo init no.

/* Buffers -------------------------------------------------------------------*/

define buffer Buf_E_BelegPos  for E_BelegPos.
&IF LOOKUP("MB":U,"{&PA-MODULE}":U) > 0 &THEN
  define buffer MB_Aktivitaet for MB_Aktivitaet.
&ENDIF

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

&IF LOOKUP("MB":U,"{&PA-MODULE}":U) > 0 &THEN

  if available E_BelegKopf then

    for each Buf_E_BelegPos
      fields (Coverage_Obj)
      where Buf_E_BelegPos.Firma               = E_BelegKopf.Firma
        and Buf_E_BelegPos.BelegArt            = E_BelegKopf.BelegArt
        and Buf_E_BelegPos.ReferenzNr          = E_BelegKopf.ReferenzNr
        and Buf_E_BelegPos.Coverage_MRPDocType = 'PPF':U
        and Buf_E_BelegPos.Coverage_Obj       <> ?
        and can-find (S_Artikel
          where S_Artikel.Firma                = {firma/sartikel.fir pa-Firma}
            and S_Artikel.Artikel              = Buf_E_BelegPos.Artikel
            and S_Artikel.ArtikelArt           = {&pa_S_PT_OutsourcedOperation})
      no-lock
      on error undo, throw:

      find MB_Aktivitaet
        where MB_Aktivitaet.MB_Aktivitaet_Obj = Buf_E_BelegPos.Coverage_Obj
          and MB_Aktivitaet.Artikel           > '':U
        no-lock no-error.

      if available MB_Aktivitaet then
      do:

        if {fnarg
             pa_lProvPartIsModus52
             "pACConnectionSvc:prpcCompany"} = no then
        do:

          lFremdarbeitVorhanden = yes.

          leave.

        end.
        /* in Modus 52 External Operation must have a consignment area */
        else if MB_Aktivitaet.Konsignationslager <> ? then
        do:

          lFremdarbeitVorhanden = yes.

          leave.

        end.

      end. /* if available MB_Aktivitaet */

    end. /* for each Buf_E_BelegPos */

&ENDIF

return string(lFremdarbeitVorhanden,'yes/no':U).

end procedure. /* get-DeliveryProvPartsExtOperation */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-empfaenger V-table-Win 
PROCEDURE get-empfaenger :
/*------------------------------------------------------------------------------
  Purpose:     Liefert den aktuell eingetragenen Empfänger
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

return E_BelegKopf.Empfaenger:screen-value in frame {&frame-name}.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-HasDocumentPosition V-table-Win 
PROCEDURE get-HasDocumentPosition :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Checks if the Document has at least one position                           */
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

if can-find (first E_BelegPos
               where E_BelegPos.Firma      = E_BelegKopf.Firma
                 and E_BelegPos.BelegArt   = E_BelegKopf.BelegArt
                 and E_BelegPos.ReferenzNr = E_BelegKopf.ReferenzNr) then
  return 'yes':U.
else
  return 'no':U.

end procedure. /* get-HasDocumentPosition */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-Homepage V-table-Win 
PROCEDURE get-Homepage :
/*------------------------------------------------------------------------------
  Purpose:     Liefert Homepage zum aktuellen Objekt
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

if available S_Adresse then
  return S_Adresse.Homepage.
else
  return ?.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-Tapi# V-table-Win 
PROCEDURE get-Tapi# :
/*------------------------------------------------------------------------------
  Purpose:     Liefert die aktuelle Telefonnummer
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

define buffer S_Ansprech for S_Ansprech.

if available E_BelegKopf then
do:

  if input frame {&frame-name} E_BelegKopf.Empfaenger <> '':U then
  do:

    find first S_Ansprech
      where S_Ansprech.Firma         = {firma/sliefera.fir pa-firma}
        and S_Ansprech.Kontenbereich = 2
        and S_Ansprech.Konto         = E_BelegKopf.Lieferant
        and S_Ansprech.Name          = input frame {&frame-name} E_BelegKopf.Empfaenger
        and (   S_Ansprech.Telefon   > '':U
             or S_Ansprech.Handy     > '':U)
      no-lock no-error.

    if available S_Ansprech then
      return trim(  S_Ansprech.Telefon
                    + {&PA-DELIMITER3}
                    + S_Ansprech.Handy,
                  {&PA-DELIMITER3}).

  end.

  find E_BelegKopfAdr
    where E_BelegKopfAdr.Firma      = E_BelegKopf.Firma
      and E_BelegKopfAdr.Belegart   = E_BelegKopf.Belegart
      and E_BelegKopfAdr.ReferenzNr = E_BelegKopf.ReferenzNr
      and E_BelegKopfAdr.Typ        = 'A':U
    no-lock no-error.

  if available E_BelegKopfAdr then
    return E_BelegKopfAdr.Telefon.

  else if available S_Adresse then
    return trim(replace(  S_Adresse.Telefon
                          + {&PA-DELIMITER3}
                          + S_Adresse.Handy
                          + {&PA-DELIMITER3}
                          + S_Adresse.AutoTelefon,
                        {&PA-DELIMITER3} + {&PA-DELIMITER3},
                        {&PA-DELIMITER3}),
                {&PA-DELIMITER3}).
  else
    return ?.

end. /* if available E_BelegKopf */
else
  return ?.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-UserUpdateAllowed V-table-Win 
PROCEDURE get-UserUpdateAllowed :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Checks if the current user can update the record                           */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/* This Procedure use the global buffer E_BelegKopf                           */
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

if    available E_BelegKopf
  and E_BelegKopf.offen
  and not can-do(pa-disabled-functions,'update':U) then
  return 'yes':U.
else
  return 'no':U.

end procedure. /* get-UserUpdateAllowed */

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
/*----------------------------------------------------------------------------*/

/* Variables -----------------------------------------------------------------*/
/* iReferenceNoEBA  reference number of generated debit demo (used as flag)   */
/* iDocNoEBA        document number of generated debit demo  (used in message)*/
/* iNoLinesEBA      number of lines of generated debit demo (used in message) */
/*----------------------------------------------------------------------------*/

define variable lRueckgabe                  as   logical                    no-undo.
define variable lAdoptOrderType             as   logical                    no-undo.
define variable iReferenceNoEBA             like E_BelegKopf.ReferenzNr     no-undo.
define variable iDocNoEBA                   like E_BelegKopf.Belegnummer    no-undo.
define variable iNoLinesEBA                 as   integer                    no-undo.
define variable cPKS                        as   character                  no-undo.

/* Buffers -------------------------------------------------------------------*/

define buffer bS_Lieferant      for S_Lieferant.
&IF lookup("EB_DESADV":U,"{&pa-Optionen}":U) > 0 &THEN
  define buffer bE_BelegPos     for E_BelegPos.
  define buffer EBT_DeliveryPos for EBT_DeliveryPos.
  define buffer EBT_Delivery    for EBT_Delivery.
  define buffer EBT_DesAdv      for EBT_DesAdv.
&ENDIF

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

find bS_Lieferant
  where bS_Lieferant.Firma     = {firma/sliefera.fir pa-Firma}
    and bS_Lieferant.Lieferant = E_BelegKopf.Lieferant
  no-lock.

if glArchivieren = yes then
do:

  &IF lookup("EB_DESADV":U,"{&pa-Optionen}":U) > 0 &THEN

    for each bE_BelegPos
      where bE_BelegPos.Firma      = {firma/ebelkop.fir pa-Firma}
        and bE_BelegPos.BelegArt   = E_BelegKopf.BelegArt
        and bE_BelegPos.ReferenzNr = E_BelegKopf.ReferenzNr
        and bE_BelegPos.offen      = yes
      no-lock
      on error undo, throw:

      find first EBT_DeliveryPos
        where EBT_DeliveryPos.Source_Obj = bE_BelegPos.E_BelegPos_Obj
          and EBT_DeliveryPos.offen      = yes
        no-lock no-error.

      if available EBT_DeliveryPos then
      do:

        find EBT_Delivery
          where EBT_Delivery.EBT_Delivery_Obj = EBT_DeliveryPos.EBT_Delivery_Obj
          no-lock.

        find EBT_DesAdv
          where EBT_DesAdv.EBT_DesAdv_Obj = EBT_Delivery.EBT_DesAdv_Obj
          no-lock.

        glArchivieren = no.

        adm.method.cls.DMCMessageSvc:prpoInstance:showError
          ('ebdea00052':U,
           string(bE_BelegPos.PositionsNr),
           string(EBT_DesAdv.BelegNummer) + '/':U + EBT_Delivery.LieferscheinNr,
           string(EBT_DeliveryPos.PositionsNr)).

      end. /* if available EBT_DeliveryPos */

    end. /* for each bE_BelegPos */

  &ENDIF

  if pa-fields-enabled then
  do:

    assign
      cPKS = adm.method.cls.DMCParameterStringSvc:cWriteValue(cPKS, 'MessageID':U, 'e_bel00035':U)
      cPKS = adm.method.cls.DMCParameterStringSvc:cWriteValue(cPKS, 'SubstitutionList':U, input frame {&frame-name} E_BelegKopf.Belegnummer)
      .

    run pa_UISvcStartInstanceByName
      ('e_msgdialog_archive.dyn':U,
       cPKS,
       '':U,
       '':U) no-error.

    lRueckgabe = not error-status:error.

  end. /* if pa-fields-enabled */
  else
    lRueckgabe = yes.

  if not lRueckgabe then
  do:

    glArchivieren = no.
    return 'adm-error':U.

  end.
  else 
    Archiv: 
    do on error undo, return 'adm-error':U:

    /* offene Restmengen als Fehlmengen verbuchen */

    if can-do('EB,EAB,ERL':U,E_BelegKopf.Belegart) then
    do:

      lRueckgabe = no.

      if E_BelegKopf.BelegArt = 'ERL':U then
      do:

        /* Prüfung Bestimmungsort                                            */
        /* Bei Bestellungen, Abrufbestellungen und Rahmenbestellungen        */
        /* muss nicht unbedingt eine Ortsangabe vorliegen.                   */

        &IF "{&pa_S_IncoTerm}":U = "1":U &THEN

          if    E_BelegKopf.Bestimmungsort    = 3
            and not can-find(E_BelegKopfAdr
                               where E_BelegKopfAdr.Firma      = E_BelegKopf.Firma
                                 and E_BelegKopfAdr.Belegart   = 'ERL':U
                                 and E_BelegKopfAdr.ReferenzNr = E_BelegKopf.ReferenzNr
                                 and E_BelegKopfAdr.Typ        = 'E':U)
            and adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
                  ('v_inc00001':U,
                   E_BelegKopf.BelegNummer:screen-value in frame {&frame-name}) = no then

            return 'adm-error':U.

        &ENDIF

        find first E_BelegPos
          where E_BelegPos.Firma      = {firma/ebelkop.fir pa-Firma}
            and E_BelegPos.Belegart   = E_BelegKopf.Belegart
            and E_BelegPos.ReferenzNr = E_BelegKopf.ReferenzNr
            and E_BelegPos.offen      = yes
            and E_BelegPos.SatzArt    = 'A':U
          no-lock no-error.

        if available E_BelegPos then
        do:

          /* Wenn es sich nicht um eine Rücklieferung vom Lager handelt. */

          if can-find (E_WE_Pos
                         where E_WE_Pos.Firma       = {firma/ebelkop.fir pa-Firma}
                           and E_WE_Pos.ReferenzNr  = E_BelegPos.Herk_ReferenzNr
                           and E_WE_Pos.PositionsNr = E_BelegPos.Herk_PositionsNr) then
          do:

            /* The sales return document contains lines that require no re-   */
            /* placement delivery. If you are expecting a supplier invoice    */
            /* for these lines, you should create a debit memo. If no supp-   */
            /* lier invoice is expected, you should not create a debit memo.  */
            /* Do you want to create a debit memo for the document lines?     */

            if can-find (first E_BelegPos
                           where E_BelegPos.Firma       = {firma/ebelkop.fir pa-Firma}
                             and E_BelegPos.Belegart    = E_BelegKopf.Belegart
                             and E_BelegPos.ReferenzNr  = E_BelegKopf.ReferenzNr
                             and E_BelegPos.offen       = yes
                             and E_BelegPos.SatzArt     = 'A':U
                             and E_BelegPos.WareLiefern = no
                             and E_BelegPos.Menge       > 0) then

              assign
                glArchivieren = no
                lRueckgabe    = adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
                                  ('e_bel00042':U)
                .

            /* This sales return document contains lines that require a re-   */
            /* placement delivery!                                            */
            /* Do you want to create debit memos for all such lines now?      */

            if can-find (first E_BelegPos
                           where E_BelegPos.Firma       = {firma/ebelkop.fir pa-Firma}
                             and E_BelegPos.BelegArt    = E_BelegKopf.BelegArt
                             and E_BelegPos.ReferenzNr  = E_BelegKopf.ReferenzNr
                             and E_BelegPos.offen       = yes
                             and E_BelegPos.SatzArt     = 'A':U
                             and E_BelegPos.WareLiefern = yes
                             and E_BelegPos.KoAuftrag   = no
                             and E_BelegPos.FehlMenge   <
                                   E_BelegPos.Menge - E_BelegPos.gelieferte_Menge) then

              assign
                glArchivieren = no
                lRueckgabe    = adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
                                  ('e_bel00058':U)
                .

          end. /* if can-find (E_WE_Pos ... */

          /* Wenn es sich um eine Rücklieferung vom Lager handelt */

          else
          do:

            /* This sales return document contains lines for which no replace-*/
            /* ment delivery was requested. Do you want to create a debit     */
            /* memo for these document lines?                                 */

            if can-find (first E_BelegPos
                           where E_BelegPos.Firma       = {firma/ebelkop.fir pa-Firma}
                             and E_BelegPos.BelegArt    = E_BelegKopf.BelegArt
                             and E_BelegPos.ReferenzNr  = E_BelegKopf.ReferenzNr
                             and E_BelegPos.offen       = yes
                             and E_BelegPos.SatzArt     = 'A':U
                             and E_BelegPos.WareLiefern = no
                             and E_BelegPos.Menge       > 0) then

              assign
                glArchivieren = no
                lRueckgabe    = adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
                                  ('e_bel00065':U)
                .

            /* This sales return document contains lines that require a re-   */
            /* placement delivery!                                            */
            /* Do you want to create debit memos for all such lines now?      */

            if can-find (first E_BelegPos
                           where E_BelegPos.Firma       = {firma/ebelkop.fir pa-Firma}
                             and E_BelegPos.Belegart    = E_BelegKopf.Belegart
                             and E_BelegPos.ReferenzNr  = E_BelegKopf.ReferenzNr
                             and E_BelegPos.offen       = yes
                             and E_BelegPos.SatzArt     = 'A':U
                             and E_BelegPos.WareLiefern = yes
                             and E_BelegPos.KoAuftrag   = no
                             and E_BelegPos.FehlMenge   <
                                   E_BelegPos.Menge - E_BelegPos.gelieferte_Menge) then

              assign
                glArchivieren = no
                lRueckgabe    = adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
                                  ('e_bel00058':U)
                .

          end. /* not available E_WE_Pos */

        end. /* available E_BelegPos */

        /* Debit memo can only be generated if the program e_pbla00.w has been*/
        /* released and the function security for new entries is allowed.     */

        if    lRueckgabe
          and pACSecuritySvc:lCanRun('e_pbla00.w':U,yes,?)
          and basis.user.cls.BUCFunctionSecuritySvc:prpoInstance:lCheckFunctionSecurityForInstance        
                ('e_pbla00.w':U,
                 'create':U,
                 pACConnectionSvc:prpcUserID,
                 pACConnectionSvc:prpcCompany) then
          adm.method.cls.DMCMessageSvc:prpoInstance:showError('e_bel00201':U).

        if    lRueckgabe              = yes
          and E_BelegKopf.Auftragsart > '':U then

          lAdoptOrderType = adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
                                  ('e_bel00062':U,
                                   E_BelegKopf.Auftragsart).

      end. /* if E_BelegKopf.BelegArt = 'ERL':U */

      /* Check status of document header and supplier for category E_EBA      */
      /* (Debit Memo) only once.                                              */
      /* The following lock status are called only for returns, because       */
      /* lRueckgabe has to be yes.                                            */

      if can-find (first E_BelegPos
           where E_BelegPos.Firma      = {firma/ebelkop.fir pa-Firma}
             and E_BelegPos.Belegart   = E_BelegKopf.Belegart
             and E_BelegPos.ReferenzNr = E_BelegKopf.ReferenzNr
             and E_BelegPos.offen      = yes
             and E_BelegPos.SatzArt    = 'A':U
             and E_BelegPos.Menge      > 0
             and E_BelegPos.KoAuftrag  = no
             and lRueckgabe            = yes) then
      do:

        /* Check lock level document header for document type EBA (Debit Memo) */

        basis.buro.cls.BBCWorkflowSvc:prpoInstance:showLockStatus
          (E_BelegKopf.E_BelegKopf_Obj,
           'E_EBA':U).

        basis.buro.cls.BBCWorkflowSvc:prpoInstance:showLockStatus
          (bS_Lieferant.S_Lieferant_Obj,
           'E_EBA':U).

      end. /* if can-find (first E_BelegPos */

      for each E_BelegPos
        where E_BelegPos.Firma      = {firma/ebelkop.fir pa-Firma}
          and E_BelegPos.Belegart   = E_BelegKopf.Belegart
          and E_BelegPos.ReferenzNr = E_BelegKopf.ReferenzNr
        exclusive-lock
        on error undo Archiv, return 'ADM-ERROR':U:

        /* The following method is called only for returns, because           */
        /* lRueckgabe has to be yes.                                          */

        if    (   (    E_BelegPos.SatzArt                     = 'A':U
                   and E_BelegPos.Menge                       > 0
                   and E_BelegPos.offen                       = yes)
               or (    E_BelegPos.SatzArt                     = 'T':U
                   and adm.config.cls.DCCAppConfigSvc:prpoInstance:lParameterValue
                         ('EB_CopyReturnTextsForDebitMemo':U) = yes))
          and E_BelegPos.KoAuftrag                            = no
          and lRueckgabe                                      = yes then

          eink.base.cls.EBCPurchaseDocSvc:prpoInstance:GenerateDebitMemoOfReturn(input-output iReferenceNoEBA,  /* flag, if a debit memo header is present */
                                                                                 input        E_BelegPos.E_BelegPos_Obj,
                                                                                 input        lAdoptOrderType,
                                                                                       output iDocNoEBA,
                                                                                       output iNoLinesEBA).

        assign
          E_BelegPos.FehlMenge = max(0,E_BelegPos.Menge
                                       - E_BelegPos.gelieferte_Menge)
          E_BelegPos.offen     = &IF lookup("EB_DESADV":U,"{&pa-Optionen}":U) > 0 &THEN
                                   can-find (first EBT_DeliveryPos
                                     where EBT_DeliveryPos.Source_Obj = E_BelegPos.E_BelegPos_Obj
                                       and EBT_DeliveryPos.offen      = yes)
                                 &ELSE
                                   no
                                 &ENDIF
          .

        validate E_BelegPos.

        if E_BelegPos.Satzart  = 'A':U then
        do:

          if E_BelegPos.BelegArt = 'EAB':U then

            run eink/proc/e_veab00.p (E_BelegPos.E_BelegPos_Obj) no-error.

          else

            run eink/proc/e_vbel00.p (E_BelegPos.E_BelegPos_Obj) no-error.

          if error-status:error then

            return 'ADM-ERROR':U.

        end. /* if E_BelegPos.Satzart  = 'A':U */

      end. /* for each E_BelegPos */

      if lRueckgabe = yes then

        adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
          ('e_bel00050':U,
           string(iDocNoEBA),
           string(iNoLinesEBA)).

      /* Belegköpfe ohne Artikelposition müssen extra archiviert werden */

      if not can-find (first E_BelegPos
                         where E_BelegPos.Firma      = {firma/ebelkop.fir pa-Firma}
                           and E_BelegPos.Belegart   = E_BelegKopf.Belegart
                           and E_BelegPos.ReferenzNr = E_BelegKopf.ReferenzNr
                           and E_BelegPos.Satzart    = 'A':U) then
      do:

        E_BelegKopf.offen = no.

        validate E_BelegKopf.

      end. /* not can-find (first E_BelegPos */

      /* Create workflow for archived purchase order */

      if    E_BelegKopf.Belegart = 'EB':U
        and E_BelegKopf.offen     = no 
        and info.base.cls.IBCDocumentInfoSvc:prpoInstance:lDocIsTransferred
              (E_BelegKopf.E_BelegKopf_Obj) = yes then
        basis.buro.cls.BBCWorkflowSvc:prpoInstance:createWorkflow
          (E_BelegKopf.E_BelegKopf_Obj,
           E_BelegKopf.Firma,
           'E_EB':U,
           39,
           E_BelegKopf.VerteilerGruppe,
           E_BelegKopf.Auftragsart).        

    end. /* if can-do('EB,EAB,ERL':U,E_BelegKopf.BelegArt) */

  end. /* Archiv */

end. /* if glArchivieren = yes */

/* Check min order value and run workflow event 80                            */

if E_BelegKopf.BelegArt = 'EB':U then
  eink.base.cls.EBCPurchaseDocSvc:prpoInstance:StartMinOrderValueWorkflow(buffer E_BelegKopf).

/* Dispatch standard ADM method.                             */

run dispatch in this-procedure ( 'assign-statement':U ) .

/* Code placed here will execute AFTER standard behavior.    */

if return-value <> 'ADM-ERROR':U then
do:

  /* Prüfung Bestimmungsort:                                                */
  /* Bei Bestellungen und Abrufbestellungen muss nicht unbedingt eine Orts- */
  /* angabe vorliegen. Bei Rücklieferungen kommt diese evtl. aus dem Vor-   */
  /* beleg. Sonst muss ein Bestimmungsort angegeben werden.                 */

  &IF "{&pa_S_IncoTerm}":U = "1":U &THEN

    if E_BelegKopf.Bestimmungsort = 3 then
    do:

      if    can-do('EB,EAB':U,E_BelegKopf.BelegArt)
        and not can-find(first E_BelegKopfAdr
                           where E_BelegKopfAdr.Firma      = E_BelegKopf.Firma
                             and E_BelegKopfAdr.BelegArt   = E_BelegKopf.BelegArt
                             and E_BelegKopfAdr.ReferenzNr = E_BelegKopf.ReferenzNr
                             and E_BelegKopfAdr.Typ        = 'E':U)
        and adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
              ('v_inc00001':U,
               E_BelegKopf.BelegNummer:screen-value in frame {&frame-name}) = no then

        return 'adm-error':U.

      if    E_BelegKopf.BelegArt = 'ERL':U
        and not can-find(first E_BelegKopfAdr
                           where E_BelegKopfAdr.Firma      = E_BelegKopf.Firma
                             and E_BelegKopfAdr.BelegArt   = E_BelegKopf.BelegArt
                             and E_BelegKopfAdr.ReferenzNr = E_BelegKopf.ReferenzNr
                             and E_BelegKopfAdr.Typ        = 'E':U) then

        adm.method.cls.DMCMessageSvc:prpoInstance:showError
          ('v_inc00002':U,
           string(E_BelegKopf.Belegnummer),
           string(E_BelegKopf.Lieferbedingung),
           E_BelegKopf.IncoTerm).

    end. /* if E_BelegKopf.Bestimmungsort = 3 */

  &ENDIF /* &IF "{&pa_S_IncoTerm}":U = "1":U &THEN */

    run notify ('display-fields,record-target':U).

  if bS_Lieferant.AdressNr = 0 then
  do:

    find ttS_Adresse
      no-error.

    find E_BelegKopfAdr
      where E_BelegKopfAdr.Firma      = E_BelegKopf.Firma
        and E_BelegKopfAdr.BelegArt   = E_BelegKopf.BelegArt
        and E_BelegKopfAdr.ReferenzNr = E_BelegKopf.ReferenzNr
        and E_BelegKopfAdr.Typ        = 'A':U
      exclusive-lock no-error.

    if not available E_BelegKopfAdr then
    do:

      create E_BelegKopfAdr.

      assign
        E_BelegKopfAdr.Firma      = E_BelegKopf.Firma
        E_BelegKopfAdr.BelegArt   = E_BelegKopf.BelegArt
        E_BelegKopfAdr.ReferenzNr = E_BelegKopf.ReferenzNr
        E_BelegKopfAdr.Typ        = 'A':U
        .

      validate E_BelegKopfAdr.

    end. /* if not available E_BelegKopfAdr */

    if available ttS_Adresse then

      buffer-copy
        ttS_Adresse
        except
          Anlagebenutzer
          Anlagedatum
          Anlagezeit
          Aenderungbenutzer
          Aenderungdatum
          Aenderungzeit
          AdressNr
          Firma
        to E_BelegKopfAdr.

  end. /* if bS_Lieferant.AdressNr = 0 */

  /* Refresh the info window 'supplier address' */

  run notify ('row-available':U).

end. /* if return-value <> 'ADM-ERROR':U */

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win
procedure local-cancel-record :
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

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Check min order value and run workflow event 80                            */ 

if    available E_BelegKopf
  and E_BelegKopf.BelegArt = 'EB':U then
  eink.base.cls.EBCPurchaseDocSvc:prpoInstance:StartMinOrderValueWorkflow(buffer E_BelegKopf).

/* Execute standard behavior -------------------------------------------------*/

run dispatch('cancel-record':U).

end procedure. /* local-cancel-record */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-createWorkflow V-table-Win 
PROCEDURE local-createWorkflow :
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

define variable cTmp as character no-undo.

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

if available E_BelegKopf then
  run basis/buro/proc/bbpver00.w
    (E_BelegKopf.Firma,
     'E_':U + E_BelegKopf.BelegArt,
     E_BelegKopf.E_BelegKopf_Obj,
     input-output cTmp).

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-statement V-table-Win 
PROCEDURE local-delete-statement :
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
&IF LOOKUP("M_Pack-Plus","{&PA-OPTIONEN}") > 0 &THEN
  define variable lPackageInvolved as logical init no no-undo.    
&ENDIF
&IF LOOKUP("U_WMS":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  define variable iDocumentNumber like E_BelegKopf.BelegNummer no-undo.
&ENDIF
/* Buffers -------------------------------------------------------------------*/

define buffer bML_Ort    for ML_Ort.
define buffer bS_Artikel for S_Artikel.
&IF LOOKUP("M_Pack-Plus","{&PA-OPTIONEN}") > 0 &THEN
  define buffer bMLL_Movements      for MLL_Movements.
  define buffer bMML_PackageLogItem for MML_PackageLogItem.
&ENDIF  
/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Code placed here will execute PRIOR to standard behavior. */

/* In case the document has already been send by INWB or EDI a deletion of the*/
/* document should always be considered carefully. Show a message for that    */
/* case.                                                                      */

if     stamm.base.cls.SBCBusProcTransmissionSvc:prpoInstance:iGetTransmissionState
         (E_BelegKopf.E_BelegKopf_Obj) = {&pa_SB_TransState_transmitted}
   and not adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
             ('sbinw00004':U,
              string(E_BelegKopf.BelegNummer)) then

  return 'adm-error':U.  

&IF "{&pa_ER_Belastungskorrektur}":U = "2":U &THEN  

  if    E_BelegKopf.Belegart                      = 'EBA':U
    and can-find(first E_BelegPos
                   where E_BelegPos.Firma         = E_BelegKopf.Firma
                     and E_BelegPos.Belegart      = E_BelegKopf.Belegart
                     and E_BelegPos.ReferenzNr    = E_BelegKopf.ReferenzNr
                     and E_BelegPos.Herk_Belegart = 'ERR':U)
  and not stamm.base.cls.SBCPostingPeriodSvc:prpoInstance:lPostingPeriodIsOpen
        ({&pa_SB_PostPeriodType_Material},
         E_BelegKopf.BelegDatum)
  and mawi.base.cls.MMCPostingSvc:prpoInstance:lAskContinuePosting(E_BelegKopf.Belegdatum) = no then

  return 'ADM-ERROR':U.

&ENDIF /* &IF "{&pa_ER_Belastungskorrektur}":U = "2":U */

if    E_BelegKopf.Belegart                   = 'ERL':U
  and can-find(first E_BelegPos
                 where E_BelegPos.Firma      = E_BelegKopf.Firma
                   and E_BelegPos.Belegart   = E_BelegKopf.Belegart
                   and E_BelegPos.ReferenzNr = E_BelegKopf.ReferenzNr
                   and E_BelegPos.Satzart    = 'A':U
                   and E_BelegPos.offen      = yes)
  and not stamm.base.cls.SBCPostingPeriodSvc:prpoInstance:lPostingPeriodIsOpen
        ({&pa_SB_PostPeriodType_Material},
         E_BelegKopf.BelegDatum)
  and mawi.base.cls.MMCPostingSvc:prpoInstance:lAskContinuePosting(E_BelegKopf.Belegdatum) = no then

  return 'ADM-ERROR':U.

/* --> UMO#CI2015-01-001 AFa LVS-Schnittstelle */
&IF LOOKUP("U_WMS":U,"{&PA-OPTIONEN}":U) > 0 &THEN
if branche.gateway.cls.UGC_CIWarehouseManagementSystem:prpoInstance:lSentToWMS(E_BelegKopf.E_BelegKopf_Obj) then
do:

  /* Es soll keine Meldung beim Archivieren angezeigt werden */
  gluLVSArchivieren = yes.

  iDocumentNumber = E_BelegKopf.BelegNummer.
  
  run paCntrEvt_ArchiveDocument.

  gluLVSArchivieren = no.

  adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
    ('ugwms00056':U,
     string(iDocumentNumber)).

  return 'adm-error':U.

end.
&ENDIF
/* <-- UMO#CI2015-01-001 AFa LVS-Schnittstelle */

for each E_BelegPos
  where E_BelegPos.Firma      = E_BelegKopf.Firma
    and E_BelegPos.BelegArt   = E_BelegKopf.BelegArt
    and E_BelegPos.ReferenzNr = E_BelegKopf.ReferenzNr
  exclusive-lock
  on error  undo, return 'ADM-ERROR':U
  on endkey undo, return 'ADM-ERROR':U:

  /* For returns we have to reservate the quantity. */

  if    E_BelegPos.Belegart  = 'ERL':U
    and E_BelegPos.LagerOrt <> ? then
  do:

    &IF lookup ("M_Pack":U,"{&PA-OPTIONEN}":U) > 0 &THEN

      /* Delete packaging. Returns must be handeled here, because the record  */
      /* which is about to be deleted is still needed in m_ltposd.p in order  */
      /* to post back packaging. There it would not found if deletion would   */
      /* happen in the delete trigger of E_BelegPos.                          */

      run mawi/proc/m_vpmi04.p(E_BelegPos.Firma,
                               'E':U,
                               {&pa_MM_PackagingDelivery}, /* Function Code 4 */
                               '':U,
                               '':U,
                               E_BelegPos.Belegart,
                               E_BelegKopf.E_BelegKopf_Obj,
                               E_BelegPos.Belegart,
                               E_BelegPos.E_BelegPos_Obj,
                               E_BelegPos.offen).

    &ENDIF /* &IF lookup ("M_Pack":U,"{&PA-OPTIONEN}":U) > 0 &THEN */

    find bML_Ort
      where bML_Ort.Firma    = {firma/mlort.fir pa-Firma}
        and bML_Ort.Lagerort = E_BelegPos.LagerOrt
      no-lock.

    find bS_Artikel
      where bS_Artikel.Firma   = {firma/sartikel.fir pa-Firma}
        and bS_Artikel.Artikel = E_BelegPos.Artikel
      no-lock.

    /* Reservate the return quantity */

    &IF LOOKUP("M_Pack-Plus","{&PA-OPTIONEN}") > 0 &THEN

      /* we delete a delivery position with packaging */

      if      E_BelegPos.BelegArt = 'ERL':U 
          and can-find(first bMLL_Movements
                        where bMLL_Movements.Origin_Obj = E_BelegPos.E_BelegPos_Obj
                          and can-find(first bMML_PackageLogItem
                                        where bMML_PackageLogItem.Reference_Obj = bMLL_Movements.MLL_Movements_Obj))then

        lPackageInvolved = yes.

    &ENDIF

    if not can-do({&pa_M_PTList_PackagingReturnable}, string(bS_Artikel.ArtikelArt)) then
  
      mawi.base.cls.MMCReservationSvc:prpoInstance:deleteDocumentPosSilent
        (E_BelegPos.E_BelegPos_Obj,                 /* Origin                 */  
         bS_Artikel.S_Artikel_Obj,                  /* Object-ID Part         */
         bML_Ort.ML_Ort_Obj,                        /* Object-ID Storage Area */
         (if    E_BelegPos.Herk_Belegart = ?        /* PostingCode            */ 
            and E_BelegPos.WareLiefern   = no
            and bML_Ort.StorageType     <> {&pa_ML_ExternalOwnedStorArea} then
            'RLZ':U
          else
            'ERL':U)).     

  end. /* if    E_BelegPos.Belegart  = 'ERL':U */

  /* CAUTION: It isn't necessary to call e_vbel00.p or e_veab00.p. The MRP    */
  /*          accounts will be deleted in the delete triggers e_belpod.p or   */
  /*          e_belptd.p.                                                     */

  delete E_BelegPos.

end. /* for each E_BelegPos */

/* Dispatch standard ADM method.                             */
run dispatch in this-procedure ( 'delete-statement':U ) .

/* Code placed here will execute AFTER standard behavior ---------------------*/

end procedure. /* local-delete-statement */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&IF DEFINED(EXCLUDE-local-disable-fields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields Method-Library
procedure local-disable-fields :
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

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Execute standard behavior -------------------------------------------------*/

run dispatch('disable-fields':U).

if return-value <> 'adm-error':U then
  
  glZustandPruefen = yes.

end procedure. /* local-disable-fields */


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Code placed here will execute PRIOR to standard behavior. */

{eink/incl/e_pbel03.if
  &eMail = "gceMail"
}

/* Dispatch standard ADM method.                             */
run dispatch in this-procedure ( 'display-fields':U ) .

/* Code placed here will execute AFTER standard behavior.    */

if return-value <> 'ADM-ERROR':U then

  /* If an archived document is shown, because it was the last one processed, */
  /* then do not allow to modify corresponding texts.                         */

  glEditorUpdateDenied = (    available E_BelegKopf
                          and E_BelegKopf.offen = no).

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
/*----------------------------------------------------------------------------*/

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Code placed here will execute PRIOR to standard behavior. */

/* Dispatch standard ADM method.                             */
run dispatch in this-procedure ( 'enable-fields':U ) .

/* Code placed here will execute AFTER standard behavior.    */

if return-value <> 'ADM-ERROR':U then

  glArchivieren = no.
  
  if adm-new-record = no then

    glZustandPruefen = yes.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-help-begin V-table-Win 
PROCEDURE local-help-begin :
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

assign
  pa-hlp-string = adm.method.cls.DMCParameterStringSvc:cWriteValue(pa-hlp-string, 'Belegart':U, gcBelegArt)
  pa-hlp-string = adm.method.cls.DMCParameterStringSvc:cWriteValue(pa-hlp-string, 'Lieferant':U, input frame {&frame-name} E_BelegKopf.Lieferant)
  pa-hlp-string = adm.method.cls.DMCParameterStringSvc:cWriteValue(pa-hlp-string, 'Kontenbereich':U, 2)
  pa-hlp-string = adm.method.cls.DMCParameterStringSvc:cWriteValue(pa-hlp-string, 'Konto':U, input frame {&frame-name} E_BelegKopf.Lieferant)
  .

/* wird der Lieferant firmenübergreifend geführt, so muß crtl+y auf Lieferant */
/* und crtl+a auf Empfaenger das entsprechende Firmeninclude verwenden        */

if   (    entry(4,pa-hlp-function) = 'Lieferant':U
      and entry(1,pa-hlp-function) = 'E':U)
  or (    entry(4,pa-hlp-function) = 'Empfaenger':U
      and entry(1,pa-hlp-function) = 'A':U) then

  pa-hlp-string = adm.method.cls.DMCParameterStringSvc:cWriteValue(pa-hlp-string, 'Firma':U, {firma/sliefera.fir pa-firma}).

/* Dispatch standard ADM method.                             */
run dispatch in this-procedure ( 'help-begin':U ) .

/* Code placed here will execute AFTER standard behavior.    */

end procedure.

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

gcAddressInfoWinTitle = adm.method.cls.DMCParameterStringSvc:cWriteValue
                          ('':U,
                           'pa-AddressInfoFixTitle':U,
                           'Lieferantenadresse':T60).

/* Dispatch standard ADM method.                             */
run dispatch in this-procedure ('initialize':U ) .

/* Code placed here will execute AFTER standard behavior.    */

if return-value <> 'ADM-ERROR':U then
do:

  run get-attribute ('Belegart':U).
  gcBelegArt = return-value.

  case gcBelegArt:

    when 'EB':U then
      assign
        gcBereich       = 'E_EB':U
        gcDruckprogramm = 'eink/proc/e_dbes31.p':U
        .

    when 'EAB':U then
      assign
        gcBereich       = 'E_EAB':U
        gcDruckprogramm = 'eink/proc/e_dabr31.p':U
        .

    when 'EBA':U then
      assign
        gcBereich       = 'E_EBA':U
        gcDruckprogramm = 'eink/proc/e_dbla31.p':U
        .

    when 'ERL':U then
      assign
        gcBereich       = 'E_ERL':U
        gcDruckprogramm = 'eink/proc/e_drli31.p':U
        .

  end. /* case gcBelegArt */

  &IF lookup ("S_ProfCenter","{&PA-OPTIONEN}") = 0 &THEN

    {fnarg
      pa_lUISvcSetWidgetHiddenState
      "E_BelegKopf.SBM_ProfitCenter_Obj:handle in frame {&FRAME-NAME},
       yes"}.

  &ENDIF

end. /* if return-value <> 'ADM-ERROR':U */

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-print V-table-Win 
PROCEDURE local-print :
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

run eink/proc/e_dbel10.w ('&Belegart=':U + gcBelegArt).

run notify ('display-fields,record-target':U).

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-print-current-record V-table-Win 
PROCEDURE local-print-current-record :
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

define variable cParameterliste as character           no-undo.
define variable cName1          as character           no-undo.
define variable cTelefax        as character           no-undo.
define variable cInfo           as character init '':U no-undo.
define variable cSchnittstelle  as character           no-undo.
define variable cMaschine       as character           no-undo.
define variable lKopien         as logical init yes    no-undo.
define variable lPositionen     as logical init yes    no-undo.
define variable lTemp2          as logical init no     no-undo.

/* Buffers -------------------------------------------------------------------*/

/* User Exits */

{&{&PA-XBASISNAME}_C_LocalPrintCurrent_Definition}
{&{&PA-XBASISNAME}_U_LocalPrintCurrent_Definition}
{&{&PA-XBASISNAME}_Q_LocalPrintCurrent_Definition}
{&{&PA-XBASISNAME}_LocalPrintCurrent_Definition}
{&{&PA-XBASISNAME}_Y_LocalPrintCurrent_Definition}

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Zugangssperre im Prüfungsmodus (InfoOnly) */

{stamm/incl/s_vgdp01.if
  &FehlerFkt = "return 'ADM-ERROR':U."
}

if not available E_BelegKopf then

  adm.method.cls.DMCMessageSvc:prpoInstance:ShowError('dtviw00002':U).

/* Zustandsprüfung und Anzeige zum Beleg */

basis.buro.cls.BBCWorkflowSvc:prpoInstance:showLockStatus
  (E_BelegKopf.E_BelegKopf_Obj,
   gcBereich).

find S_Lieferant
  where S_Lieferant.Firma     = {firma/sliefera.fir pa-Firma}
    and S_Lieferant.Lieferant = E_BelegKopf.Lieferant
  no-lock.

/* Zustandsprüfung und Anzeige zum Lieferanten */

basis.buro.cls.BBCWorkflowSvc:prpoInstance:showLockStatus
  (S_Lieferant.S_Lieferant_Obj,
   gcBereich).

/* check if manual delivery actions are allowed by delivery process         */

if not stamm.base.cls.SBCDeliveryConfigSvc:prpoInstance:lManualDeliveryActionAllowed(E_BelegKopf.Lieferant,
                                                                                     E_BelegKopf.BelegArt,
                                                                                     E_BelegKopf.SBM_ProfitCenter_Obj) then
  return 'ADM-ERROR':U.

/* Parameter übergeben */

{adm/incl/d__par00.if
  &ParameterListe = "cParameterliste"
  &Parameter      = "Belegart"
  &Variable1      = "E_BelegKopf.Belegart"
}


{adm/incl/d__par00.if
  &ParameterListe = "cParameterliste"
  &Parameter      = "ReferenzNr"
  &Variable1      = "E_BelegKopf.ReferenzNr"
}

find E_BelegKopfAdr
  where E_BelegKopfAdr.Firma      = E_BelegKopf.Firma
    and E_BelegKopfAdr.Belegart   = E_BelegKopf.Belegart
    and E_BelegKopfAdr.ReferenzNr = E_BelegKopf.ReferenzNr
    and E_BelegKopfAdr.Typ        = 'B':U
  no-lock no-error.

if    available E_BelegKopfAdr
  and E_BelegKopfAdr.Telefax <> '':U then

  assign
    cTelefax = E_BelegKopfAdr.Telefax
    cName1   = E_BelegKopfAdr.Name1
    .

else
do:

  /* Ermittlung von Name1 und Faxnummer, über diverse Adresse oder Lieferant */

  {eink/incl/e_pbel06.if
    &Name1   = "cName1"
    &Telefax = "cTelefax"
    &Tabelle = "E_BelegKopf"
  }

end.

/* Abfüllen von Name1 und Faxnummer */

{adm/incl/d__par00.if
  &ParameterListe = "cParameterliste"
  &Parameter      = "&Telefax"
  &Variable1      = "cTelefax"
}

{adm/incl/d__par00.if
  &ParameterListe = "cParameterliste"
  &Parameter      = "&Name"
  &Variable1      = "cName1"
}

lPositionen = adm.config.cls.DCCAppConfigSvc:prpoInstance:lParameterValue
                ('EB_PrintOpenDocumentLinesOnly':U).

/* Document specific checks that may prevent printing. Errors are cast and  */
/* displayed in case of failed checks, the current procedure will be left.  */

run PrePrintChecks.


if glAttach then                     /* der Aufruf kommt aus der Mailfunktion */
do:

  assign
    lKopien     = no                                  /* nur einfach ausgeben */
    lPositionen = glPositionen
    .

  /* Parameter für Attachment Generierung */

  if entry(num-entries(gcAttach, '.':U), gcAttach, '.':U) = 'pdf':U then

    assign
      cSchnittstelle = '$PDF-MAIL':U
      /* pdf wird über Windowsdrucker generiert */
      cMaschine      = '$WinClient':U
      .

  else
    assign
      cMaschine      = 'default':U
      cSchnittstelle = 'Datei':U
      .

  {adm/incl/d__par00.if
    &ParameterListe = "cInfo"
    &Parameter      = "Schnittstelle"
    &Variable1      = "cSchnittstelle"
  }

  {adm/incl/d__par00.if
    &ParameterListe = "cInfo"
    &Parameter      = "Maschine"
    &Variable1      = "cMaschine"
  }

  {adm/incl/d__par00.if
    &ParameterListe = "cInfo"
    &Parameter      = "keineAbfrage"
    &Variable1      = "yes"
  }

  {adm/incl/d__par00.if
    &ParameterListe = "cParameterliste"
    &Parameter      = "Attachment"
    &Variable1      = "gcAttach"
  }

end. /* if glAttach */

/* User Exits */

{&{&PA-XBASISNAME}_C_LocalPrintCurrent_Parameter}
{&{&PA-XBASISNAME}_U_LocalPrintCurrent_Parameter}
{&{&PA-XBASISNAME}_Q_LocalPrintCurrent_Parameter}
{&{&PA-XBASISNAME}_LocalPrintCurrent_Parameter}
{&{&PA-XBASISNAME}_Y_LocalPrintCurrent_Parameter}

if    not glAttach
  and adm.config.cls.DCCAppConfigSvc:prpoInstance:lParameterValue
      ('SB_PrintOptForDocOutput':U) = yes then
do:

  lKopien = (E_BelegKopf.Formularanzahl <> 1).

  run stamm/proc/s_pbel00.w (             E_BelegKopf.Belegart,
                                          yes,
                             input-output lKopien,
                             input-output lPositionen,
                                   output lTemp2) no-error.

  if     error-status:error
     or lTemp2 then
    return 'ADM-ERROR':U.

end. /* if not glAttach */

{adm/incl/d__par00.if
  &ParameterListe = "cParameterliste"
  &Parameter      = "Positionen"
  &Variable1      = "lPositionen"
}

{adm/incl/d__par00.if
  &ParameterListe = "cParameterliste"
  &Parameter      = "Kopien"
  &Variable1      = "lKopien"
}

run basis/job/proc/bjvjob00.w (cInfo,
                               cParameterliste,
                               gcDruckprogramm) no-error.

if error-status:error then
  return 'ADM-ERROR':U.

run notify in THIS-PROCEDURE ('row-available':U).

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&IF DEFINED(EXCLUDE-local-row-available) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available Method-Library
procedure local-row-available :
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

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Execute standard behavior -------------------------------------------------*/

run dispatch('row-available':U).

if return-value <> 'adm-error':U then
do:
  
  glZustandPruefen = yes.

end.

end procedure. /* local-row-available */


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-SendMail V-table-Win 
PROCEDURE local-SendMail :
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

define variable cTemp           as character              no-undo.
define variable cEmail          as character init '':U    no-undo.
define variable cAnsprech       as character init '':U    no-undo.
define variable cLieferant      as character init '':U    no-undo.
define variable cSubject        as character init ' ':U   no-undo.
define variable cTemplateID     as character              no-undo.
define variable clMailBody      as longchar               no-undo.
define variable cMailOptions    as character              no-undo.
define variable lAttach         as logical                no-undo.
define variable lSign           as logical                no-undo.
define variable oAttachDocument as SBCAttachedDocumentSvo no-undo.

/* Buffers -------------------------------------------------------------------*/

define buffer bS_Ansprech         for S_Ansprech.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

fix-codepage(clMailBody) = 'utf-8':U.

if available E_BelegKopf then
do:

  /* Ansprechpartner */

  if input frame {&frame-name} E_BelegKopf.Empfaenger <> '':U then
  do:

    find first bS_Ansprech
      where bS_Ansprech.Firma         = {firma/sliefera.fir pa-firma}
        and bS_Ansprech.Kontenbereich = 2
        and bS_Ansprech.Konto         = E_BelegKopf.Lieferant
        and bS_Ansprech.Name          = input frame {&frame-name} E_BelegKopf.Empfaenger
      no-lock no-error.

    if available bS_Ansprech then
      cAnsprech = bS_Ansprech.EMail.

  end.

  if E_BelegKopf.Belegart = 'EBA':U then
    gcLieferadresse = '':U.



  /* Lieferant */

  /* reload the supplier's e-mail address - it could be modified in the master in the meantime */

  if    available S_Lieferant
    and S_Lieferant.AdressNr <> 0 then
  do:

    find S_Adresse
      where S_Adresse.Firma    = {firma/s_adres.fir pACConnectionSvc:prpcCompany}
        and S_Adresse.AdressNr = S_Lieferant.AdressNr
      no-lock.

    gceMail = S_Adresse.EMail.

  end.

  assign
    cLieferant      = gcEMail
    cTemplateID     = stamm.base.cls.SBCEmailTemplatesSvc:prpoInstance:cDocumentTypeTemplateID(E_BelegKopf.E_BelegKopf_Obj)
    oAttachDocument = new SBCAttachedDocumentSvo(E_BelegKopf.BelegArt,
                                                 E_BelegKopf.Lieferant,
                                                 E_BelegKopf.SBM_ProfitCenter_Obj)
    .

  {adm/incl/d__par00.if
    &Parameterliste = "cTemp"
    &Parameter      = "Ansprechpartner"
    &Variable1      = "cAnsprech"
  }

  {adm/incl/d__par00.if
    &Parameterliste = "cTemp"
    &Parameter      = "Lieferant"
    &Variable1      = "cLieferant"
  }

  {adm/incl/d__par00.if
    &Parameterliste = "cTemp"
    &Parameter      = "Bestelladresse"
    &Variable1      = "gcBestelladresse"
  }

  {adm/incl/d__par00.if
    &Parameterliste = "cTemp"
    &Parameter      = "Lieferadresse"
    &Variable1      = "gcLieferadresse"
  }

  {adm/incl/d__par00.if
    &Parameterliste = "cTemp"
    &Parameter      = "Rechnungsadresse"
    &Variable1      = "gcRechnungsadresse"
  }

  {adm/incl/d__par00.if
    &Parameterliste = "cTemp"
    &Parameter      = "Bestimmungsort"
    &Variable1      = "gcBestimmungsort"
  }

  {adm/incl/d__par00.if
    &Parameterliste = "cTemp"
    &Parameter      = "Attachment"
    &Variable1      = "not pa-fields-enabled"
  }

  {adm/incl/d__par00.if
    &Parameterliste = "cTemp"
    &Parameter      = "posEingabe"
    &Variable1      = "yes"
  }

  {adm/incl/d__par00.if
    &Parameterliste = "cTemp"
    &Parameter      = "E_Belegkopf_Obj"
    &Variable1      = "E_Belegkopf.E_Belegkopf_Obj"
  }

  {adm/incl/d__par00.if
    &Parameterliste = "cTemp"
    &Parameter      = "TemplateID"
    &Variable1      = "cTemplateID"
  }

  {adm/incl/d__par00.if
    &Parameterliste = "cTemp"
    &Parameter      = "AttachDocument"
    &Variable1      = "oAttachDocument:prplAttachDocument"
  }

  run eink/proc/e__ema00.w (input-output cTemp).

  {adm/incl/d__par01.if
    &Parameterliste = "cTemp"
    &Parameter      = "Attachment"
    &Variable1      = "lAttach"
    &Datentyp       = "logical"
    &cc_Log         = "yes"
  }

  {adm/incl/d__par01.if
    &Parameterliste = "cTemp"
    &Parameter      = "SignAttachments"
    &Variable1      = "lSign"
    &Datentyp       = "logical"
    &cc_Log         = "yes"
  }

  assign
    cEmail = adm.method.cls.DMCParameterStringSvc:cReadValue(cTemp, 'Email':U, ?)
    cEmail = (if cEmail = ? then
                '':U
              else
                cEmail)
    cEmail = replace(cEmail,',':U,{&pa_D_MailParamDelimiter})
    .


  {adm/incl/d__par01.if
    &Parameterliste = "cTemp"
    &Parameter      = "TemplateID"
    &Variable1      = "cTemplateID"
  }

  stamm.base.cls.SBCEmailTemplatesSvc:prpoInstance:PrepareMail(E_BelegKopf.E_BelegKopf_Obj,
                                                               cTemplateID,
                                                               output clMailBody,
                                                               output cSubject,
                                                               output cMailOptions).
  {&{&PA-XBASISNAME}_C_Subject}
  {&{&PA-XBASISNAME}_U_Subject}
  {&{&PA-XBASISNAME}_Q_Subject}
  {&{&PA-XBASISNAME}_Subject}
  {&{&PA-XBASISNAME}_Y_Subject}

  if lAttach then
  do:

    {adm/incl/d__par01.if
      &Parameterliste = "cTemp"
      &Parameter      = "AusPositionen"
      &Variable1      = "glPositionen"
      &Datentyp       = "logical"
      &cc_Log         = "yes"
    }

    assign

      /* Attachment liegt im temp-Verzeichnis des Clients */

      cTemp        = pACStartupSvc:cParameterValue('Temp':U)

      gcAttach     = cTemp
                     + {&PA-BACKSLASH}
                     + string(E_BelegKopf.Belegnummer) + '.pdf':U

      glAttach     = yes

      cMailOptions = adm.method.cls.DMCParameterStringSvc:cWriteValue(cMailOptions,'DeleteAttachments':U,yes).
      .

    if lSign = yes then
      cMailOptions = adm.method.cls.DMCParameterStringSvc:cWriteValue(cMailOptions,'SignAttachments':U,yes).

    /* Attachment erzeugen */

    run dispatch in this-procedure ('print-current-record':U).

    if return-value <> 'ADM-ERROR':U then
    do on error undo, throw:

      glAttach = no.

      /* Mit Attachment verschicken */

      adm.method.cls.DMCEMailSvc:prpoInstance:SendMail
        ( cEmail,
          '':U,        /* CC      */
          '':U,        /* BCC     */
          cSubject,    /* Betreff */
          clMailBody,  /* Text    */
          gcAttach,
          yes,
          this-procedure,
          cMailOptions).

      /* catch DMCDialogCanceledErr to avoid buffer loss in this case */

      catch oError as adm.method.cls.DMCDialogCanceledErr:

        /* Cancel: do nothing */

      end. /* code checked by Fichter 17.03.2014 */

    end. /* if return-value <> 'ADM-ERROR':U */

  end. /* if lAttach */
  else

    adm.method.cls.DMCEMailSvc:prpoInstance:SendMail
      ( cEmail,
        '':U,        /* CC      */
        '':U,        /* BCC     */
        cSubject,    /* Betreff */
        clMailBody,  /* Text    */
        '':U,
        yes,
        this-procedure,
        cMailOptions).

end. /* if available E_BelegKopf */

finally:

  if valid-object(oAttachDocument) then

    delete object oAttachDocument.

end. /* finally */

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pa_UIMenmi_SendToLogisticsInterface V-table-Win 
PROCEDURE pa_UIMenmi_SendToLogisticsInterface :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Menu item event handler                                                    */
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

if available E_BelegKopf then
  basis.inwb.cls.BOCLogisticsInterfaceSvc:prpoInstance:lCreateOrUpdateMessage
    (E_BelegKopf.E_BelegKopf_Obj).

end procedure. /* pa_UIMenmi_SendToLogisticsInterface */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PackagingLabel V-table-Win 
PROCEDURE PackagingLabel :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Multi-Print for all Packaging Labels                                       */
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

&IF lookup ("M_Pack":U,"{&PA-OPTIONEN}":U) > 0 &THEN

  /* Variables ---------------------------------------------------------------*/
  /* cParameter         Parameter list given to the job program.              */
  /*--------------------------------------------------------------------------*/

  define variable cParameter as character no-undo.

  /* Buffers -----------------------------------------------------------------*/

  /*--------------------------------------------------------------------------*/
  /* Processing                                                               */
  /*--------------------------------------------------------------------------*/

  if not available E_BelegKopf then

    adm.method.cls.DMCMessageSvc:prpoInstance:showError('dtviw00002':U).

  assign
    cParameter = adm.method.cls.DMCParameterStringSvc:cInsertValue(cParameter,
                                                                   'Belegart':U,
                                                                   E_BelegKopf.Belegart)
    cParameter = adm.method.cls.DMCParameterStringSvc:cInsertValue(cParameter,
                                                                   'ReferenzNr':U,
                                                                   string(E_BelegKopf.ReferenzNr))
    .

  run basis/job/proc/bjvjob00.w ('':U,       /* Options */
                                 cParameter,
                                 'mawi/proc/m_dpmi03.p':U).

&ENDIF /* &IF lookup ("M_Pack":U,"{&PA-OPTIONEN}":U) > 0 &THEN */

end procedure. /* PackagingLabel */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE paCntrEvt_ArchiveDocument V-table-Win 
PROCEDURE paCntrEvt_ArchiveDocument :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Archive the Document.                                                      */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/* Used for the document types EB, ERL and EAB                                */
/* Return with different "replace goods" sign must be archived for each posi- */
/* tion.                                                                      */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* <none>                                                                     */
/*                                                                            */
/*----------------------------------------------------------------------------*/

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

define variable cPKS   as character no-undo.

/* Buffers -------------------------------------------------------------------*/

define buffer Buf_E_BelegPos for E_BelegPos.
define buffer bER_BelegPos   for ER_BelegPos.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

basis.buro.cls.BBCWorkflowSvc:prpoInstance:showLockStatus
  (E_BelegKopf.E_BelegKopf_Obj,
   gcBereich).

if can-do('EB,EAB':U,E_BelegKopf.Belegart) then
do:

  &IF lookup ("E_ANZ":U,"{&PA-OPTIONEN}":U) > 0 &THEN

    if   can-find(first ER_BelegPos
            where ER_BelegPos.Firma           = {firma/ebelkop.fir pa-firma}
              and ER_BelegPos.Belegart        = 'ERZ':U
              and ER_BelegPos.Herk_BelegArt   = E_BelegKopf.BelegArt
              and ER_BelegPos.Herk_ReferenzNr = E_BelegKopf.ReferenzNr
              and ER_BelegPos.uebernommen     = no)
      or can-find(first ER_BelegPos
            where ER_BelegPos.Firma           = {firma/ebelkop.fir pa-firma}
              and ER_BelegPos.Belegart        = 'ERZ':U
              and ER_BelegPos.Herk_BelegArt   = E_BelegKopf.BelegArt
              and ER_BelegPos.Herk_ReferenzNr = E_BelegKopf.ReferenzNr
              and ER_BelegPos.uebernommen     = yes
              and can-find(first bER_BelegPos
                where bER_BelegPos.Firma            = {firma/ebelkop.fir pa-firma}
                  and bER_BelegPos.Belegart         = 'ERR':U
                  and bER_BelegPos.Herk_BelegArt    = ER_BelegPos.BelegArt
                  and bER_BelegPos.Herk_ReferenzNr  = ER_BelegPos.ReferenzNr
                  and bER_BelegPos.Herk_PositionsNr = ER_BelegPos.PositionsNr
                  and bER_BelegPos.verbucht         = no)) then
    do
      on error undo, return:

      adm.method.cls.DMCMessageSvc:prpoInstance:showError
        ('errec00163':U).

    end. /* if can-find(first ER_BelegPos */

  &ENDIF

  glArchivieren = yes.

end. /* if can-do('EB,EAB':U,E_BelegKopf.Belegart) */

else if E_BelegKopf.BelegArt = 'ERL':U then
do:

  if    E_BelegKopf.Belegart                     = 'ERL':U
    and can-find (first E_BelegPos
                    where E_BelegPos.Firma       = E_BelegKopf.Firma
                      and E_BelegPos.Belegart    = E_BelegKopf.Belegart
                      and E_BelegPos.ReferenzNr  = E_BelegKopf.ReferenzNr
                      and E_BelegPos.WareLiefern = yes
                      and E_BelegPos.Lagerort   <> ?)
                      and not lSaveRecord(pa-Firma,
                                          E_BelegKopf.Belegdatum) then
  do:

    glArchivieren = no.

    return.

  end. /* if    E_BelegKopf.Belegart       = 'ERL':U */

  find first E_BelegPos
    where E_BelegPos.Firma      = {firma/ebelkop.fir pa-Firma}
      and E_BelegPos.BelegArt   = E_BelegKopf.BelegArt
      and E_BelegPos.ReferenzNr = E_BelegKopf.ReferenzNr
      and E_BelegPos.offen      = yes
      and E_BelegPos.SatzArt    = 'A':U
    no-lock no-error.

  if available E_BelegPos then
  do:

    glArchivieren = yes.

    for each Buf_E_BelegPos
      where Buf_E_BelegPos.Firma      = {firma/ebelkop.fir pa-Firma}
        and Buf_E_BelegPos.BelegArt   = E_BelegKopf.BelegArt
        and Buf_E_BelegPos.ReferenzNr = E_BelegKopf.ReferenzNr
        and Buf_E_BelegPos.offen      = yes
        and Buf_E_BelegPos.SatzArt    = 'A':U
      no-lock
      on error undo, throw:

      /* Wenn Belegpositionen mit und ohne WareLiefern vorhanden sind     */
      /* sollen Belegpositionen einzeln archiviert werden.                */

      if Buf_E_BelegPos.WareLiefern <> E_BelegPos.WareLiefern then
      do:

        adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
          ('e_bel00060':U).

        glArchivieren = no.

        return.

      end. /* if E_BelegPos.WareLiefern <> E_BelegPos.WareLiefern */

    end. /* for each Buf_E_BelegPos */

  end. /* if available E_BelegPos */
  else
    glArchivieren = yes.

end. /* if E_BelegKopf.BelegArt = 'ERL':U */

/* In case of deleting and document was sent to WMS, the document is not in   */
/* update-modus                                                               */

if not pa-fields-enabled then
do:

  /* When the user has changed the document number without refeshing the    */
  /* document then we have to refresh the display now.                      */

  if input frame {&frame-name} E_BelegKopf.Belegnummer <> E_BelegKopf.Belegnummer then
    apply 'page-down':U to E_BelegKopf.Belegnummer in frame {&FRAME-NAME}.

  assign
    cPKS = adm.method.cls.DMCParameterStringSvc:cWriteValue(cPKS, 'MessageID':U, 'e_bel00035':U)
    cPKS = adm.method.cls.DMCParameterStringSvc:cWriteValue(cPKS, 'SubstitutionList':U, input frame {&frame-name} E_BelegKopf.Belegnummer)
    .

  /* --> UMO#CI2015-01-001 AFa LVS-Schnittstelle */
  &IF LOOKUP("U_WMS":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  /* WMS Docs are archived, not deleted, so no question needed*/
  if not gluLVSArchivieren then
  &ENDIF
  /* <-- UMO#CI2015-01-001 AFa LVS-Schnittstelle */

  run pa_UISvcStartInstanceByName
    ('e_msgdialog_archive.dyn':U,
     cPKS,
     '':U,
     '':U) no-error.

  if error-status:error then

    glArchivieren = no.

end. /* if not pa-fields-enabled */

if glArchivieren = yes then
do:

  &IF LOOKUP("Q_AEBW":U,"{&PA-OPTIONEN}":U) > 0 &THEN
    basis.inwb.cls.BOCInwbSvc:prpoInstance:prplOaPArchiveDoc = yes.
  &ENDIF

  /* --> UMO#CI2015-01-001 AFa LVS-Schnittstelle */
  &IF LOOKUP("U_WMS":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  gcuE_BelegKopf_Obj = E_BelegKopf.E_BelegKopf_Obj.
  &ENDIF
  /* <-- UMO#CI2015-01-001 AFa LVS-Schnittstelle */

  /* Only In case of deleting and document was sent to WMS, the document is   */
  /* not in update-modus. In this Case there is no update                     */
  
  if  pa-fields-enabled then
  do:
    
  run dispatch ('update-record':U).

  if return-value = 'adm-error':U then
    return error.
  end. 

  run notify ('open-query,record-source':U).

  /* --> UMO#CI2015-01-001 AFa LVS-Schnittstelle */
  &IF LOOKUP("U_WMS":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  branche.gateway.cls.UGC_CIWarehouseManagementSystem:prpoInstance:SentDocToWMS(gcuE_BelegKopf_Obj).
  &ENDIF
  /* <-- UMO#CI2015-01-001 AFa LVS-Schnittstelle */

end. /* if glArchivieren = yes */

return.

&IF LOOKUP("Q_AEBW":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  finally:

    basis.inwb.cls.BOCInwbSvc:prpoInstance:prplOaPArchiveDoc = no.

  end finally.
&ENDIF

end procedure. /* paCntrEvt_ArchiveDocument */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE paCntrEvt_ChangeTaxationBase V-table-Win 
PROCEDURE paCntrEvt_ChangeTaxationBase :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Changes the Taxation Base (Call the Taxation Dialog)                       */
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

define variable lAbbruch as logical init no no-undo.

/* Buffers -------------------------------------------------------------------*/

define buffer bE_BelegKopf for E_BelegKopf.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

if not available E_BelegKopf then
  return.

/* Check whether the document is opened by another user. */

find bE_BelegKopf
  where bE_BelegKopf.E_BelegKopf_Obj = E_BelegKopf.E_BelegKopf_Obj
  exclusive-lock no-wait no-error.

if    not available bE_BelegKopf
  and locked(bE_BelegKopf) then

  pACConnectionSvc:showRecordLockedMessage('E_BelegKopf':U, recid(E_BelegKopf)).


run eink/proc/e_pbel12.w (       rowid(E_BelegKopf),
                          output lAbbruch).

if lAbbruch = yes then
  return.

run dispatch ('row-available':U).

if return-value = 'ADM-ERROR':U then
  return error.

end procedure. /* paCntrEvt_ChangeTaxationBase */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE paCntrEvt_CopyDocument V-table-Win 
PROCEDURE paCntrEvt_CopyDocument :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Copy a document with all positions                                         */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/* First we get a selection of all posible purchase documents as template to  */
/* copy into the new purchase document. This new document will be created     */
/* with all positions where we have an active part-supplier relationship.     */
/* If the new position is not assigned to a blanket purchase order then the   */
/* prices of the copied position with be used.                                */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* <none>                                                                     */
/*                                                                            */
/*----------------------------------------------------------------------------*/

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

define variable cSatzID           as character no-undo.
define variable cTeile            as character no-undo.
define variable cTmp              as character no-undo.
define variable dKurs             as decimal   decimals 10 no-undo.
define variable dKursAlt          as decimal   decimals 10 no-undo.
define variable dKursNeu          as decimal   decimals 10 no-undo.
define variable i                 as integer   no-undo.
define variable iPositionsNr      as integer   no-undo init 0.
define variable lPreisfind        as logical   no-undo.
define variable lPreisfindPos     as logical   no-undo.
define variable lPreisUmre        as logical   no-undo.
define variable cHerk_Belegart    as character no-undo.
define variable iHerk_ReferenzNr  as integer   no-undo init 0.
define variable dHerk_PositionsNr as decimal   no-undo.
define variable tGueltigkeit      as date      no-undo.

/* Buffers -------------------------------------------------------------------*/

define buffer Buf_E_BelegKopf for E_BelegKopf.
define buffer Buf_E_BelegPos  for E_BelegPos.
define buffer Buf_E_RA_Kopf   for E_RA_Kopf.
define buffer Buf_E_RA_Pos    for E_RA_Pos.
define buffer Buf_E_RA_Preis  for E_RA_Preis.
define buffer E_ArtLiefBei    for E_ArtLiefBei.
define buffer E_BelegPosBei   for E_BelegPosBei.
define buffer Buf_S_Artikel   for S_Artikel.
define buffer bS_Lieferant    for S_Lieferant.
define buffer bE_BelegPos-New for E_BelegPos.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

if E_BelegKopf.BelegArt = 'EB':U then
do:

  /* Auswahl des zu kopierenden Bestellkopfes */

  run eink/proc/e_pbes10.w (input-output cTmp,
                                  output cSatzID,
                            input        cLieferant_Obj()).

  if   cSatzID = ?
    or cSatzID = '':U then
    return.

  find Buf_E_BelegKopf
    where rowid(Buf_E_BelegKopf) = to-rowid(cSatzID)
    no-lock.

  /* If the selected Order has an origin document of Blanket order which has */
  /* a metal assigned to its position, copying should not be allowed         */

  if can-find(first E_BelegPos
    where E_BelegPos.Firma             = Buf_E_BelegKopf.Firma
      and E_BelegPos.Belegart          = Buf_E_BelegKopf.Belegart
      and E_BelegPos.ReferenzNr        = Buf_E_BelegKopf.ReferenzNr
      and can-find(E_RA_Pos
        where E_RA_Pos.Firma           = E_BelegPos.Firma
          and E_RA_Pos.Belegart        = 'ERA':U
          and E_RA_Pos.ReferenzNr      = E_BelegPos.Herk_ReferenzNr
          and E_RA_Pos.PositionsNr     = E_BelegPos.Herk_PositionsNr
          and can-find(first SBT_Metal
            where SBT_Metal.Owning_Obj = E_RA_Pos.E_RA_Pos_Obj))) then

    adm.method.cls.DMCMessageSvc:prpoInstance:showError('sbmet00024':U).

  /* Prüfe, ob zum Lieferanten bzw. zum Beleg für die Beistellung Zustände  */
  /* existieren, sofern der zu kopierende Beleg Positionen mit Beistell-    */
  /* positionen besitzt und zum neuen Lieferant für das bestellte Teil eine */
  /* Teile-Lieferanten-Beziehung existiert.                                 */

  if can-find(first E_BelegPos
    where E_BelegPos.Firma              = Buf_E_BelegKopf.Firma
      and E_BelegPos.Belegart           = Buf_E_BelegKopf.Belegart
      and E_BelegPos.ReferenzNr         = Buf_E_BelegKopf.ReferenzNr
      and E_BelegPos.Satzart            = 'A':U
      and can-find(E_ArtLief
        where E_ArtLief.Firma           = {firma/e_artli.fir pa-Firma}
          and E_ArtLief.Artikel         = E_BelegPos.Artikel
          and E_ArtLief.Lieferant       = E_BelegKopf.Lieferant)
      and can-find(first E_BelegPosBei
        where E_BelegPosBei.Firma       = E_BelegPos.Firma
          and E_BelegPosBei.Belegart    = E_BelegPos.Belegart
          and E_BelegPosBei.ReferenzNr  = E_BelegPos.ReferenzNr
          and E_BelegPosBei.PositionsNr = E_BelegPos.PositionsNr)) then
  do:

    find bS_Lieferant
      where bS_Lieferant.Firma     = {firma/sliefera.fir pa-Firma}
        and bS_Lieferant.Lieferant = E_BelegKopf.Lieferant
      no-lock.

    basis.buro.cls.BBCWorkflowSvc:prpoInstance:showLockStatus
      (bS_Lieferant.S_Lieferant_Obj,
       'E_BBei':U).

    basis.buro.cls.BBCWorkflowSvc:prpoInstance:showLockStatus
      (E_BelegKopf.E_BelegKopf_Obj,
       'E_BBei':U).

  end. /* if can-find(first E_BelegPos */

  /* Prüfe, ob eines der in der Vorlage bzw. der Teile-Lieferanten-Beziehung*/
  /* verwendeten Beistellteile inzwischen mit einem Zustand zum Bereich     */
  /* 'Beistellung' versehen ist.                                            */

  /* Erstelle zuerst eine Liste der Beistellteile aus E_ArtLiefBei und an-  */
  /* schließend prüfe, ob zusätzliche Beistellteile zugeordnet wurden.      */

  cTeile = '':U.

  for each Buf_E_BelegPos
    where Buf_E_BelegPos.Firma      = Buf_E_BelegKopf.Firma
      and Buf_E_BelegPos.Belegart   = Buf_E_BelegKopf.Belegart
      and Buf_E_BelegPos.ReferenzNr = Buf_E_BelegKopf.ReferenzNr
      and Buf_E_BelegPos.Satzart    = 'A':U
    no-lock
    on error undo, throw:

    for each E_ArtLiefBei
      where E_ArtLiefBei.Firma     = {firma/e_artli.fir pa-Firma}
        and E_ArtLiefBei.Artikel   = Buf_E_BelegPos.Artikel
        and E_ArtLiefBei.Lieferant = E_BelegKopf.Lieferant
      no-lock
      on error undo, throw:

      cTeile = adm.method.cls.DMCStringSvc:cStringListAddItem
                 (cTeile,
                  E_ArtLiefBei.BeistellArtikel,
                  {&PA-DELIMITER1}).

    end. /* for each E_ArtLiefBei */

    for each E_BelegPosBei
      where E_BelegPosBei.Firma       = Buf_E_BelegPos.Firma
        and E_BelegPosBei.Belegart    = Buf_E_BelegPos.Belegart
        and E_BelegPosBei.ReferenzNr  = Buf_E_BelegPos.ReferenzNr
        and E_BelegPosBei.PositionsNr = Buf_E_BelegPos.PositionsNr
      no-lock
      on error undo, throw:

      cTeile = adm.method.cls.DMCStringSvc:cStringListAddItem
                 (cTeile,
                  E_BelegPosBei.BeistellArtikel,
                  {&PA-DELIMITER1},
                  no).

    end. /* for each E_BelegPosBei */

    if cTeile > '':U then

      do i = 1 to num-entries(cTeile,{&PA-DELIMITER1}):

        find Buf_S_Artikel
          where Buf_S_Artikel.Firma   = {firma/sartikel.fir pa-Firma}
            and Buf_S_Artikel.Artikel = entry(i,cTeile,{&PA-DELIMITER1})
          no-lock no-error.

        if available Buf_S_Artikel then
          basis.buro.cls.BBCWorkflowSvc:prpoInstance:showLockStatus
            (Buf_S_Artikel.S_Artikel_Obj,
             'E_BBei':U).

      end. /* do i = 1 to num-entries(cTeile,{&PA-DELIMITER1}) */

  end. /* for each Buf_E_BelegPos */

  if Buf_E_BelegKopf.Lieferant = E_BelegKopf.Lieferant then
  do:

    lPreisfind = no.

    if Buf_E_BelegKopf.Waehrung <> E_BelegKopf.Waehrung then

      /* Beträge umrechnen, wenn Bestellkopf andere Währung als kopierter */
      /* Bestellkopf hat und die Lieferanten identisch sind, d.h. keine   */
      /* Preisfindung für die neuen Positionen stattfinden soll ?         */

      if adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
           ('e_bel00036':U,
            {fnarg
              pa_cCurShortDescOfCurrency
              "pa-Firma,
               Buf_E_BelegKopf.Waehrung"},
            {fnarg
              pa_cCurShortDescOfCurrency
              "pa-Firma,
               E_BelegKopf.Waehrung"}) = yes then
        lPreisUmre = yes.
      else
        lPreisfind = yes.

  end. /* if Buf_E_BelegKopf.Lieferant = E_BelegKopf.Lieferant */
  else
    assign
      lPreisfind = yes
      lPreisUmre = no
      .

  Positionslauf:
  for each Buf_E_BelegPos
    where Buf_E_BelegPos.Firma               = Buf_E_BelegKopf.Firma
      and Buf_E_BelegPos.BelegArt            = Buf_E_BelegKopf.BelegArt
      and Buf_E_BelegPos.ReferenzNr          = Buf_E_BelegKopf.ReferenzNr
      and Buf_E_BelegPos.Coverage_MRPDocType = '':U
    no-lock
    on error undo, throw:

    if    Buf_E_BelegKopf.Lieferant <> E_BelegKopf.Lieferant
      and Buf_E_BelegPos.SatzArt     = 'A':U then
    do:

      find E_ArtLief
        where E_ArtLief.Firma     = {firma/e_artli.fir pa-Firma}
          and E_ArtLief.Artikel   = Buf_E_BelegPos.Artikel
          and E_ArtLief.Lieferant = E_BelegKopf.Lieferant
        no-lock no-error.

      if not available E_ArtLief then
        next Positionslauf.

    end.

    if lPreisUmre then

      assign
        dKursNeu = (if E_BelegKopf.Waehrung <> 0 then
                     {fnarg
                       pa_dCurGetExchangeRate
                       "E_BelegKopf.Firma,
                        E_BelegKopf.Waehrung,
                        E_BelegKopf.BelegDatum,
                        string({&pa_E_Kurs}),
                        E_BelegKopf.Lieferant,
                        E_BelegKopf.E_BelegKopf_Obj"}
                    else
                      1)
        dKursAlt = (if E_BelegKopf.Waehrung <> 0 then
                     {fnarg
                       pa_dCurGetExchangeRate
                       "Buf_E_BelegKopf.Firma,
                        Buf_E_BelegKopf.Waehrung,
                        Buf_E_BelegKopf.BelegDatum,
                        string({&pa_E_Kurs}),
                        Buf_E_BelegKopf.Lieferant,
                        Buf_E_BelegKopf.E_BelegKopf_Obj"}
                    else
                      1)
        dKurs    = dKursAlt / dKursNeu
        .

    else

      dKurs = 1.

    assign
      iPositionsNr = iPositionsNr + 1
      tGueltigkeit = (if adm.config.cls.DCCAppConfigSvc:prpoInstance:lParameterValue
                           ('EB_BlanketPurOrderToPriceValidity':U) = yes then
                        E_BelegKopf.Preisgueltigkeit
                      else
                        E_BelegKopf.BelegDatum)
      .

    /* Bezug zu Rahmenbestellung herstellen ? */

    find Buf_E_RA_Pos     /* Code checked by wl 04.06.2003 */
      where Buf_E_RA_Pos.Firma     = {firma/ebelkop.fir pa-firma}
        and Buf_E_RA_Pos.Belegart  = 'ERA':U
        and Buf_E_RA_Pos.offen     = yes
        and Buf_E_RA_Pos.Lieferant = E_BelegKopf.Lieferant
        and Buf_E_RA_Pos.Artikel   = Buf_E_BelegPos.Artikel
        and Buf_E_RA_Pos.ArtVar    = Buf_E_BelegPos.ArtVar
        and can-find(Buf_E_RA_Kopf
          of Buf_E_RA_Pos
          where Buf_E_RA_Kopf.gueltig_ab   <= tGueltigkeit
            and (Buf_E_RA_Kopf.gueltig_bis  = ?
              or Buf_E_RA_Kopf.gueltig_bis >= tGueltigkeit)
            and Buf_E_RA_Kopf.Waehrung      = E_BelegKopf.Waehrung)
      no-lock no-error.

    /* gibt es einen oder mehrere in Frage kommenden Rahmenaufträge, so Übersicht */

    assign
      cHerk_BelegArt    = ?
      iHerk_ReferenzNr  = ?
      dHerk_PositionsNr = ?
      .

    if   (   ambiguous Buf_E_RA_Pos
          or available Buf_E_RA_Pos)
      and adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
            ('e_bel00110':U,
             string(iPositionsNr)) = yes then

      run eink/proc/e_urah02.w (             E_BelegKopf.Firma,
                                             E_BelegKopf.Lieferant,
                                             tGueltigkeit,
                                             E_BelegKopf.Waehrung,
                                             Buf_E_BelegPos.Artikel,
                                             Buf_E_BelegPos.ArtVar,
                                             'E_EB':U,
                                             no,
                                input-output cHerk_BelegArt,
                                input-output iHerk_ReferenzNr,
                                input-output dHerk_PositionsNr).

    /* Stammte vorheriger Preis aus Rahmenbestellung und wurde jetzt */
    /* keine Zuordnung zu einer Rahmenbestellung getroffen, dann die */
    /* Preisermittlung durchführen und alte Preise nicht übernehmen. */

    lPreisfindPos = (if    Buf_E_BelegPos.Herk_BelegArt = 'ERA':U
                       and cHerk_BelegArt               = ? then
                       yes
                     else
                       lPreisfind).

    /* Jetzt die Position anlegen.                                   */

    create bE_BelegPos-New.

    assign
      bE_BelegPos-New.Firma               = E_BelegKopf.Firma
      bE_BelegPos-New.BelegArt            = 'EB':U
      bE_BelegPos-New.ReferenzNr          = E_BelegKopf.ReferenzNr
      bE_BelegPos-New.PositionsNr         = (if adm.config.cls.DCCAppConfigSvc:prpoInstance:lParameterValue('EB_CopyPurchaseOrderLineNo':U) = yes then
                                               Buf_E_BelegPos.PositionsNr
                                             else
                                               iPositionsNr)
      bE_BelegPos-New.Lieferant           = E_BelegKopf.Lieferant
      bE_BelegPos-New.SatzArt             = Buf_E_BelegPos.SatzArt
      bE_BelegPos-New.Artikel             = Buf_E_BelegPos.Artikel
      bE_BelegPos-New.ArtVar              = Buf_E_BelegPos.ArtVar
      bE_BelegPos-New.TextSchluessel      = Buf_E_BelegPos.TextSchluessel
      bE_BelegPos-New.MMM_CusRefOrder_ID  = Buf_E_BelegPos.MMM_CusRefOrder_ID
      bE_BelegPos-New.MMM_CusRefOrder_Obj = Buf_E_BelegPos.MMM_CusRefOrder_Obj
      /* Attribute the quantity here in order to assure a correct Schedule    */
      /* Price and On Order Quantity.                                         */
      bE_BelegPos-New.Menge               = Buf_E_BelegPos.Menge
      .

    /* hier bereits KopierPosition zuweisen, damit in der Preisfindung */
    /* bei fehlendem Preis (oder Preis in anderer Währung) und Über-   */
    /* nahme bzw. Umrechnung des Preises keine Fehlermeldung erscheint.*/

    bE_BelegPos-New.KopierPosition = (if   lPreisfindPos       = no
                                        or (    lPreisUmre     = yes
                                            and cHerk_BelegArt = ?) then
                                        yes
                                      else
                                        no
                                     ).

    validate bE_BelegPos-New.

    buffer-copy
      Buf_E_BelegPos
        except
          Firma
          BelegArt
          ReferenzNr
          PositionsNr
          Lieferant
          TextSchluessel
          Artikel
          ArtVar
          SatzArt
          AnlageBenutzer
          AnlageDatum
          AnlageZeit
          AenderungBenutzer
          AenderungDatum
          AenderungZeit
          offen
          gelieferte_Menge
          Fehlmenge
          Einzelpreis
          Wert_RZ_1
          Wert_RZ_2
          Wert_RZ_3
          Wert_RZ_4
          Wert_RZ_5
          Wert_RZ_Art_1
          Wert_RZ_Art_2
          Wert_RZ_Art_3
          Wert_RZ_Art_4
          Wert_RZ_Art_5
          proz_RZ_1
          proz_RZ_2
          proz_RZ_3
          proz_RZ_4
          proz_RZ_5
          proz_RZ_Art_1
          proz_RZ_Art_2
          proz_RZ_Art_3
          proz_RZ_Art_4
          proz_RZ_Art_5
          Warenwert
          Warenwert_offen
          Preisherkunft
          Preiseinheit
          Preisfaktor
          Preisbezug
          WareLiefern
          Zugangstermin       /* wird im Trigger gesetzt */
          Liefertermin
          SB_Dispo
          Herk_Belegart
          Herk_ReferenzNr
          Herk_PositionsNr
          Coverage_MRPDocType
          Coverage_Obj
          KopierPosition
          MMM_CusRefOrder_ID
          MMM_CusRefOrder_Obj
          &IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
          uCI_ArrivalDate
          uCI_ReqDeliveryDate
          &ENDIF
          E_BelegPos_Obj
      to bE_BelegPos-New.

    if E_BelegKopf.Wunschtermin >= today then
      bE_BelegPos-New.Wunschtermin = E_BelegKopf.Wunschtermin.
    else if bE_BelegPos-New.Wunschtermin < today then
      bE_BelegPos-New.Wunschtermin = today.

    /* keine Preisfindung oder Preis wird umgerechnet, dann die Preise */
    /* jetzt zuweisen (wurden bei buffer-copy nicht berücksichtigt)    */

    if    bE_BelegPos-New.KopierPosition
      and cHerk_BelegArt = ? then
      assign
        bE_BelegPos-New.Einzelpreis   = Buf_E_BelegPos.Einzelpreis
        bE_BelegPos-New.Wert_RZ_1     = Buf_E_BelegPos.Wert_RZ_1
        bE_BelegPos-New.Wert_RZ_2     = Buf_E_BelegPos.Wert_RZ_2
        bE_BelegPos-New.Wert_RZ_3     = Buf_E_BelegPos.Wert_RZ_3
        bE_BelegPos-New.Wert_RZ_4     = Buf_E_BelegPos.Wert_RZ_4
        bE_BelegPos-New.Wert_RZ_5     = Buf_E_BelegPos.Wert_RZ_5
        bE_BelegPos-New.Wert_RZ_Art_1 = Buf_E_BelegPos.Wert_RZ_Art_1
        bE_BelegPos-New.Wert_RZ_Art_2 = Buf_E_BelegPos.Wert_RZ_Art_2
        bE_BelegPos-New.Wert_RZ_Art_3 = Buf_E_BelegPos.Wert_RZ_Art_3
        bE_BelegPos-New.Wert_RZ_Art_4 = Buf_E_BelegPos.Wert_RZ_Art_4
        bE_BelegPos-New.Wert_RZ_Art_5 = Buf_E_BelegPos.Wert_RZ_Art_5
        bE_BelegPos-New.proz_RZ_1     = Buf_E_BelegPos.proz_RZ_1
        bE_BelegPos-New.proz_RZ_2     = Buf_E_BelegPos.proz_RZ_2
        bE_BelegPos-New.proz_RZ_3     = Buf_E_BelegPos.proz_RZ_3
        bE_BelegPos-New.proz_RZ_4     = Buf_E_BelegPos.proz_RZ_4
        bE_BelegPos-New.proz_RZ_5     = Buf_E_BelegPos.proz_RZ_5
        bE_BelegPos-New.proz_RZ_Art_1 = Buf_E_BelegPos.proz_RZ_Art_1
        bE_BelegPos-New.proz_RZ_Art_2 = Buf_E_BelegPos.proz_RZ_Art_2
        bE_BelegPos-New.proz_RZ_Art_3 = Buf_E_BelegPos.proz_RZ_Art_3
        bE_BelegPos-New.proz_RZ_Art_4 = Buf_E_BelegPos.proz_RZ_Art_4
        bE_BelegPos-New.proz_RZ_Art_5 = Buf_E_BelegPos.proz_RZ_Art_5
        bE_BelegPos-New.Preisherkunft = Buf_E_BelegPos.Preisherkunft
        bE_BelegPos-New.Preiseinheit  = Buf_E_BelegPos.Preiseinheit
        bE_BelegPos-New.Preisfaktor   = Buf_E_BelegPos.Preisfaktor
        bE_BelegPos-New.Preisbezug    = Buf_E_BelegPos.Preisbezug
        .

    if cHerk_BelegArt <> ? then
    do:

      assign
        bE_BelegPos-New.Herk_BelegArt    = cHerk_BelegArt
        bE_BelegPos-New.Herk_ReferenzNr  = iHerk_ReferenzNr
        bE_BelegPos-New.Herk_PositionsNr = dHerk_PositionsNr
        .

      find last Buf_E_RA_Preis
        where Buf_E_RA_Preis.Firma       = E_BelegKopf.Firma
          and Buf_E_RA_Preis.BelegArt    = cHerk_BelegArt
          and Buf_E_RA_Preis.ReferenzNr  = iHerk_ReferenzNr
          and Buf_E_RA_Preis.PositionsNr = dHerk_PositionsNr
          and Buf_E_RA_Preis.gueltig_ab <= E_BelegKopf.Preisgueltigkeit
        no-lock no-error.

      if not available Buf_E_RA_Preis then
        find last Buf_E_RA_Preis
          where Buf_E_RA_Preis.Firma       = E_BelegKopf.Firma
            and Buf_E_RA_Preis.BelegArt    = cHerk_BelegArt
            and Buf_E_RA_Preis.ReferenzNr  = iHerk_ReferenzNr
            and Buf_E_RA_Preis.PositionsNr = dHerk_PositionsNr
            and Buf_E_RA_Preis.gueltig_ab <= E_BelegKopf.Belegdatum
          no-lock.

      find Buf_E_RA_Pos
        where Buf_E_RA_Pos.Firma       = E_BelegKopf.Firma
          and Buf_E_RA_Pos.Belegart    = cHerk_BelegArt
          and Buf_E_RA_Pos.ReferenzNr  = iHerk_ReferenzNr
          and Buf_E_RA_Pos.PositionsNr = dHerk_PositionsNr
        no-lock.

      assign
        bE_BelegPos-New.Einzelpreis   = Buf_E_RA_Preis.Einzelpreis
        bE_BelegPos-New.Wert_RZ_1     = Buf_E_RA_Preis.Wert_RZ_1
        bE_BelegPos-New.Wert_RZ_2     = Buf_E_RA_Preis.Wert_RZ_2
        bE_BelegPos-New.Wert_RZ_3     = Buf_E_RA_Preis.Wert_RZ_3
        bE_BelegPos-New.Wert_RZ_4     = Buf_E_RA_Preis.Wert_RZ_4
        bE_BelegPos-New.Wert_RZ_5     = Buf_E_RA_Preis.Wert_RZ_5
        bE_BelegPos-New.Wert_RZ_Art_1 = Buf_E_RA_Preis.Wert_RZ_Art_1
        bE_BelegPos-New.Wert_RZ_Art_2 = Buf_E_RA_Preis.Wert_RZ_Art_2
        bE_BelegPos-New.Wert_RZ_Art_3 = Buf_E_RA_Preis.Wert_RZ_Art_3
        bE_BelegPos-New.Wert_RZ_Art_4 = Buf_E_RA_Preis.Wert_RZ_Art_4
        bE_BelegPos-New.Wert_RZ_Art_5 = Buf_E_RA_Preis.Wert_RZ_Art_5
        bE_BelegPos-New.proz_RZ_1     = Buf_E_RA_Preis.proz_RZ_1
        bE_BelegPos-New.proz_RZ_2     = Buf_E_RA_Preis.proz_RZ_2
        bE_BelegPos-New.proz_RZ_3     = Buf_E_RA_Preis.proz_RZ_3
        bE_BelegPos-New.proz_RZ_4     = Buf_E_RA_Preis.proz_RZ_4
        bE_BelegPos-New.proz_RZ_5     = Buf_E_RA_Preis.proz_RZ_5
        bE_BelegPos-New.proz_RZ_Art_1 = Buf_E_RA_Preis.proz_RZ_Art_1
        bE_BelegPos-New.proz_RZ_Art_2 = Buf_E_RA_Preis.proz_RZ_Art_2
        bE_BelegPos-New.proz_RZ_Art_3 = Buf_E_RA_Preis.proz_RZ_Art_3
        bE_BelegPos-New.proz_RZ_Art_4 = Buf_E_RA_Preis.proz_RZ_Art_4
        bE_BelegPos-New.proz_RZ_Art_5 = Buf_E_RA_Preis.proz_RZ_Art_5
        bE_BelegPos-New.Preisherkunft = 'RRRRRRRRRR':U
        bE_BelegPos-New.Preiseinheit  = Buf_E_RA_Pos.Preiseinheit
        bE_BelegPos-New.Preisfaktor   = Buf_E_RA_Pos.Preisfaktor
        bE_BelegPos-New.Preisbezug    = Buf_E_RA_Pos.Preisbezug
        .

    end. /* if cHerk_BelegArt */

    if    dKurs         <> 1
      and cHerk_Belegart = ? then
      assign
        bE_BelegPos-New.Einzelpreis = round(Buf_E_BelegPos.Einzelpreis * dKurs,E_BelegKopf.WaehrungNK)
        bE_BelegPos-New.Wert_RZ_1   = round(Buf_E_BelegPos.Wert_RZ_1   * dKurs,E_BelegKopf.WaehrungNK)
        bE_BelegPos-New.Wert_RZ_2   = round(Buf_E_BelegPos.Wert_RZ_2   * dKurs,E_BelegKopf.WaehrungNK)
        bE_BelegPos-New.Wert_RZ_3   = round(Buf_E_BelegPos.Wert_RZ_3   * dKurs,E_BelegKopf.WaehrungNK)
        bE_BelegPos-New.Wert_RZ_4   = round(Buf_E_BelegPos.Wert_RZ_4   * dKurs,E_BelegKopf.WaehrungNK)
        bE_BelegPos-New.Wert_RZ_5   = round(Buf_E_BelegPos.Wert_RZ_5   * dKurs,E_BelegKopf.WaehrungNK)
        .

    validate bE_BelegPos-New.

    eink.base.cls.EBCPurchaseDocSvc:prpoInstance:copyPurchaseOrderLineDependingData
      (Buf_E_BelegPos.E_BelegPos_Obj,
       Buf_E_BelegKopf.E_BelegKopf_Obj,
       bE_BelegPos-New.E_BelegPos_Obj,
       E_BelegKopf.E_BelegKopf_Obj).

    run eink/proc/e_vbel00.p (bE_BelegPos-New.E_BelegPos_Obj).

  end. /* for each Buf_E_BelegPos */

end. /* E_BelegKopf.BelegArt = 'EB':U */

/* Aktualisieren der Positionsanzeige */

run new-state ('Refresh,record-target':U).

return.

end procedure. /* paCntrEvt_CopyDocument */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE paCntrEvt_EDIMessage V-table-Win 
PROCEDURE paCntrEvt_EDIMessage :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Transfer the Document to the EDI-Interface.                                */
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

define variable cOptions as character no-undo.

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

&IF  LOOKUP("SD","{&PA-MODULE}") > 0
  or LOOKUP("SO","{&PA-MODULE}") > 0 &THEN

  if available E_BelegKopf then
  do:

    {adm/incl/d__par00.if
      &ParameterListe = "cOptions"
      &Parameter      = "Belegnummer"
      &Variable1      = "E_BelegKopf.Belegnummer"
      &Variable2      = "E_BelegKopf.Belegnummer"
    }

    {adm/incl/d__par00.if
      &ParameterListe = "cOptions"
      &Parameter      = "Lieferant"
      &Variable1      = "E_BelegKopf.Lieferant"
      &Variable2      = "E_BelegKopf.Lieferant"
    }

    {adm/incl/d__par00.if
      &ParameterListe = "cOptions"
      &Parameter      = "Belegdatum"
      &Variable1      = "E_BelegKopf.Belegdatum"
      &Variable2      = "E_BelegKopf.Belegdatum"
    }

    {adm/incl/d__par00.if
      &ParameterListe = "cOptions"
      &Parameter      = "&Belegart"
      &Variable1      = "E_BelegKopf.Belegart"
    }

    run eink/proc/e__edi00.w(cOptions).

    run notify ('display-fields,record-target':U).

  end. /* if available E_BelegKopf */

&ENDIF

return.

end procedure. /* paCntrEvt_EDIMessage */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE paCntrEvt_SendArchivedDocument V-table-Win 
PROCEDURE paCntrEvt_SendArchivedDocument :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Send archived document (currently only purchase order)                     */
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

&IF  LOOKUP("SD":U,"{&PA-MODULE}":U) > 0
  OR LOOKUP("SO":U,"{&PA-MODULE}":U) > 0 &THEN
  define buffer bS_Lieferant for S_Lieferant.
&ENDIF

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

&IF  LOOKUP("SD":U,"{&PA-MODULE}":U) > 0
  OR LOOKUP("SO":U,"{&PA-MODULE}":U) > 0 &THEN

  find bS_Lieferant
    where bS_Lieferant.Firma     = {firma/sliefera.fir E_BelegKopf.Firma}
      and bS_Lieferant.Lieferant = E_BelegKopf.Lieferant
    no-lock.

  /* check lock status of supplier and purchase order document */

  if basis.buro.cls.BBCWorkflowSvc:prpoInstance:lHasLockStatusLock
    (E_BelegKopf.E_BelegKopf_Obj,
     'E_EB':U) then
    adm.method.cls.DMCMessageSvc:prpoInstance:showError
      ('e_bel00184':U,
       string(E_BelegKopf.BelegNummer)).

  if basis.buro.cls.BBCWorkflowSvc:prpoInstance:lHasLockStatusLock
    (bS_Lieferant.S_Lieferant_Obj,
     'E_EB':U) then
    adm.method.cls.DMCMessageSvc:prpoInstance:showError
      ('mddis00025':U,
       string(bS_Lieferant.Lieferant)).

  /* If transmission state was resetted then we must set release state again  */

  if stamm.base.cls.SBCBusProcTransmissionSvc:prpoInstance:iGetTransmissionState
      (E_BelegKopf.E_BelegKopf_Obj) = {&pa_SB_TransState_NoTrans} then
    stamm.base.cls.SBCBusProcTransmissionSvc:prpoInstance:SetTransmissionState
      (E_BelegKopf.E_BelegKopf_Obj,
       S_Lieferant.S_Lieferant_Obj,
       {&pa_SB_TransState_released}).

  stamm.base.cls.SBCBusProcTransmissionSvc:prpoInstance:sendMessage(E_BelegKopf.E_BelegKopf_Obj).

&ENDIF

end procedure. /* paCntrEvt_SendArchivedDocument */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PrePrintChecks V-table-Win 
PROCEDURE PrePrintChecks :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Performs document specific checks, that must be fullfilled before printing */
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

/* Prüfung Bestimmungsort */

&IF "{&pa_S_IncoTerm}":U = "1":U &THEN

  if E_BelegKopf.Bestimmungsort = 3
    and E_BelegKopf.offen = yes
    and can-do('EB,EAB,ERL':U,E_BelegKopf.BelegArt)
    and not can-find(E_BelegKopfAdr
                       where E_BelegKopfAdr.Firma      = E_BelegKopf.Firma
                         and E_BelegKopfAdr.Belegart   = E_BelegKopf.BelegArt
                         and E_BelegKopfAdr.ReferenzNr = E_BelegKopf.ReferenzNr
                         and E_BelegKopfAdr.Typ        = 'E':U) then

    adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
      ('v_inc00002':U,
       string(E_BelegKopf.BelegNummer),
       string(E_BelegKopf.Lieferbedingung),
       E_BelegKopf.IncoTerm).

&ENDIF


end procedure. /* PrePrintChecks */

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

if available E_BelegKopf then

  run stamm/base/proc/sbpdoc00.w(             E_BelegKopf.E_BelegKopf_Obj,
                                 input-output cTemp).

end procedure. /* SelectDoc */

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

{adm/template/incl/sndkycas.i "Firma" "E_BelegKopf" "Firma" " "}
{adm/template/incl/sndkycas.i "Lieferant" "E_BelegKopf" "Lieferant" " "}
{adm/template/incl/sndkycas.i "ShippingType" "E_BelegKopf" "VersandArt" " "}
{adm/template/incl/sndkycas.i "S_Lieferant_Obj" " " "cLieferant_Obj()" " "}
{adm/template/incl/sndkycas.i "BelegArt" "E_BelegKopf" "BelegArt" " "}
{adm/template/incl/sndkycas.i "ReferenzNr" "E_BelegKopf" "ReferenzNr" " "}
{adm/template/incl/sndkycas.i "$KEY" "E_BelegKopf" " " "eink/incl/e_belko.sl "}
{adm/template/incl/sndkycas.i "Origin_Obj" "E_BelegKopf" "E_BelegKopf_Obj" " "}
{adm/template/incl/sndkycas.i "E_BelegKopf_Obj" "E_BelegKopf" "E_BelegKopf_Obj" " "}
{adm/template/incl/sndkycas.i "AddressInfoWinTitle" " " "gcAddressInfoWinTitle" " "}
{adm/template/incl/sndkycas.i "EditorUpdateDenied" " " "glEditorUpdateDenied" " "}
{adm/template/incl/sndkycas.i "Driver_Obj" "E_BelegKopf" "Driver_Obj" " "}
{adm/template/incl/sndkycas.i "S_Kostenstelle_Obj" "E_BelegKopf" "S_Kostenstelle_Obj" " "}
{adm/template/incl/sndkycas.i "EBT_SupplierCallHeader_Obj" "TT_IK_VerkBelegKopf" "Header_Obj" " "}
{adm/template/incl/sndkycas.i "SBM_ProfitCenter_Obj" "E_BelegKopf" "SBM_ProfitCenter_Obj" " "}
{adm/template/incl/sndkycas.i "SBM_TaxCase_Obj" "E_BelegKopf" "SBM_TaxCase_Obj" " "}
{adm/template/incl/sndkycas.i "SBM_FiscalText_Obj" "E_BelegKopf" "SBM_FiscalText_Obj" " "}
{adm/template/incl/sndkycas.i "S_I_TaxExemption_Obj" "E_BelegKopf" "S_I_TaxExemption_Obj" " "}
{adm/template/incl/sndkycas.i "Owning_Obj" "E_BelegKopf" "E_BelegKopf_Obj" " "}

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

{adm/template/incl/snd-list.i "E_BelegKopf"}
{adm/template/incl/snd-list.i "ttS_Adresse"}

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
/*----------------------------------------------------------------------------*/

define input parameter p-issuer-hdl as handle    no-undo.
define input parameter p-state      as character no-undo.

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

/* State is sent by the child when closing the record. When then child-record */
/* is opened again, the state ofe the document must be checked and displayed. */

if can-do('update-complete,text-modified':U, p-state) then

  glZustandPruefen = yes.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE uCreateDropShipShippingDoc V-table-Win 
PROCEDURE uCreateDropShipShippingDoc :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Start PushAdoption to create a dropshipment Shipping Document              */
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

/* --> UMO#WH2017-04-017 cpl Streckenlieferschein */
&IF LOOKUP("U_CW":U,"{&PA-OPTIONEN}":U) > 0 &THEN
define variable cParameterliste as character     no-undo.
&ENDIF
/* <-- UMO#WH2017-04-017 cpl Streckenlieferschein */

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* --> UMO#WH2017-04-017 cpl Streckenlieferschein */
&IF LOOKUP("U_CW":U,"{&PA-OPTIONEN}":U) > 0 &THEN

if not adm.config.cls.DCCAppConfigSvc:prpoInstance:lParameterValue('UV_ShippingDocForDropShipment':U) then
  adm.method.cls.DMCMessageSvc:prpoInstance:showError('udcfg00001':U,
                                                      'UV_ShippingDocForDropShipment':U).

if available E_BelegKopf then
do:
  {adm/incl/d__par00.if
    &ParameterListe = "cParameterliste"
    &Parameter      = "DocumentObj"
    &Variable1      = "E_BelegKopf.E_BelegKopf_Obj"
  }

  run branche/vert/proc/uvpbel01.w (input-output cParameterliste) no-error.
end.
&ENDIF
/* <-- UMO#WH2017-04-017 cpl Streckenlieferschein  */

end procedure. /* uCreateDropShipShippingDoc */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE use-Bestelladresse V-table-Win 
PROCEDURE use-Bestelladresse :
/*------------------------------------------------------------------------------
  Purpose:     Belegt die Variable der Bestelladresse
  Parameters:  input pcBestelladresse
  Notes:
------------------------------------------------------------------------------*/

define input parameter pcBestelladresse as character no-undo.

gcBestelladresse = pcBestelladresse.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE use-Bestimmungsort V-table-Win 
PROCEDURE use-Bestimmungsort :
/*------------------------------------------------------------------------------
  Purpose:     Belegt die Variable des Bestimmungsortes
  Parameters:  input pcBestimmungsort
  Notes:
------------------------------------------------------------------------------*/

define input parameter pcBestimmungsort as character no-undo.

gcBestimmungsort = pcBestimmungsort.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE use-Lieferadresse V-table-Win 
PROCEDURE use-Lieferadresse :
/*------------------------------------------------------------------------------
  Purpose:     Belegt die Variable der Lieferadresse
  Parameters:  input pcLieferadresse
  Notes:
------------------------------------------------------------------------------*/

define input parameter pcLieferadresse as character no-undo.

gcLieferadresse = pcLieferadresse.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE use-Rechnungsadresse V-table-Win 
PROCEDURE use-Rechnungsadresse :
/*------------------------------------------------------------------------------
  Purpose:     Belegt die Variable der Rechnungsadresse
  Parameters:  input pcRechnungsadresse
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

define input parameter pcRechnungsadresse as character no-undo.

gcRechnungsadresse = pcRechnungsadresse.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cLieferant_Obj V-table-Win 
FUNCTION cLieferant_Obj returns character
  (  ):
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* return S_Lieferant_Obj                                                     */
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

define buffer bS_Lieferant for S_Lieferant.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

if available E_BelegKopf then
  find bS_Lieferant
    where bS_Lieferant.Firma     = {firma/sliefera.fir pa-firma}
      and bS_Lieferant.Lieferant = E_BelegKopf.Lieferant
    no-lock no-error.

return (if available bS_Lieferant then
          bS_Lieferant.S_Lieferant_Obj
        else
          '':U).

end function. /* cLieferant_Obj */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION lFelderEnablen V-table-Win 
FUNCTION lFelderEnablen returns logical
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Eine Rücklieferung darf nicht bearbeitet werden, sofern zu einer
            Rücklieferposition bereits ein Intrahandels-Datensatz generiert
            wurde.
    Notes:
------------------------------------------------------------------------------*/

&IF lookup("E_Intra":U,"{&PA-OPTIONEN}":U) > 0 &THEN

  /*-----------------------------------------------------------------------*/
  /* Intrahandelsstatistik                                                 */
  /*-----------------------------------------------------------------------*/
  /* ein bereits gemeldeter Beleg kann nicht mehr bearbeitet werden.       */
  /*-----------------------------------------------------------------------*/
  if stamm.base.cls.SBCBusinessCategorySvc:prpoInstance:lHasCompanyIntraStatPurchasing(E_BelegKopf.Belegdatum) then

    case pACConnectionSvc:prpcLocalization:

      {&{&PA-XBasisName}_C_Intra_Check}
      {&{&PA-XBasisName}_U_Intra_Check}
      {&{&PA-XBasisName}_Q_Intra_Check}
      {&{&PA-XBasisName}_Intra_Check}
      {&{&PA-XBasisName}_Y_Intra_Check}

      otherwise
      do:

        if    available E_BelegKopf
          and E_BelegKopf.BelegArt = 'ERL':U
          and can-find (first S_IntraHandel
                          where S_IntraHandel.Firma           = E_BelegKopf.Firma
                            and S_IntraHandel.Herk_BelegArt   = E_BelegKopf.BelegArt
                            and S_IntraHandel.Herk_ReferenzNr = E_BelegKopf.ReferenzNr) then
        do
          on error undo, return no:

          adm.method.cls.DMCMessageSvc:prpoInstance:showError
            ('e_bel00053':U).

        end.

      end. /* otherwise */

    end case. /* pACConnectionSvc:prpcLocalization */

&ENDIF

return yes.

end function.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION lIsRepairOrderLine V-table-Win 
FUNCTION lIsRepairOrderLine returns logical
  ( pcDocumentType like E_BelegPos.Belegart,
    piReferenceNo  like E_BelegPos.ReferenzNr,
    pdLineNo       like E_BelegPos.PositionsNr ) :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Check if the current line is generated to a repair order                   */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* pcDocumentType  document type                                              */
/* piReferenceNo   reference number                                           */
/* pdLineNo        line number                                                */
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

&IF lookup ("VS_Repair":U,"{&PA-OPTIONEN}":U) > 0 &THEN

  return can-find(E_BelegPos
                    where E_BelegPos.Firma                                  = {firma/ebelkop.fir pa-Firma}
                      and E_BelegPos.BelegArt                               = pcDocumentType
                      and E_BelegPos.ReferenzNr                             = piReferenceNo
                      and E_BelegPos.PositionsNr                            = pdLineNo
                      and can-find (first VS_AuftragMKT
                                      where VS_AuftragMKT.VS_AuftragMKT_Obj = E_BelegPos.Coverage_Obj
                                        and VS_AuftragMKT.Auftragstyp       = {&pa_VS_RepairOrder})
                      and can-find(first E_BelegPosBei
                                     where E_BelegPosBei.Firma              = E_BelegPos.Firma
                                       and E_BelegPosBei.BelegArt           = E_BelegPos.BelegArt
                                       and E_BelegPosBei.ReferenzNr         = E_BelegPos.ReferenzNr
                                       and E_BelegPosBei.PositionsNr        = E_BelegPos.PositionsNr)).

&ELSE
  return no.
&ENDIF

end function. /* lIsRepairOrderLine */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION lProvPartSensitive V-table-Win 
FUNCTION lProvPartSensitive returns logical
  ( plPartialProviding as logical ) :  
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Check if the providing part menuitem should be sensitive                   */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* plPartialProviding   Sign partial providing                                */
/*                                                                            */
/* Examples ------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/*----------------------------------------------------------------------------*/

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

define buffer bE_BelegPosBei for E_BelegPosBei.
define buffer bE_BelegPos    for E_BelegPos.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

if available E_BelegKopf then
do:

  if ({fnarg
        pa_lProvPartIsModus52
        "pACConnectionSvc:prpcCompany"} = no) then
    
    for each bE_BelegPosBei
      where bE_BelegPosBei.Firma      = E_BelegKopf.Firma
        and bE_BelegPosBei.BelegArt   = E_BelegKopf.BelegArt
        and bE_BelegPosBei.ReferenzNr = E_BelegKopf.ReferenzNr
        /* storage area and consignment area must be valid and different */
        /* storage area -> consigment area                               */
        and bE_BelegPosBei.Lagerort  <> ?
        and bE_BelegPosBei.Lagerort  <> bE_BelegPosBei.KO_Lagerort
      no-lock
      on error undo, throw:

      find bE_BelegPos
        where bE_BelegPos.Firma       = bE_BelegPosBei.Firma
          and bE_BelegPos.BelegArt    = bE_BelegPosBei.BelegArt
          and bE_BelegPos.ReferenzNr  = bE_BelegPosBei.ReferenzNr
          and bE_BelegPos.PositionsNr = bE_BelegPosBei.PositionsNr
        no-lock.

      if   round(bE_BelegPosBei.Mengenfaktor * bE_BelegPos.Menge, bE_BelegPosBei.Nachkomma)
         - bE_BelegPosBei.gelieferte_Menge <> 0 then

        return yes.

    end. /* for each bE_BelegPosBei */

  &IF lookup ("VS_Repair":U,"{&PA-OPTIONEN}":U) > 0 &THEN

    if    plPartialProviding   = no
      and E_BelegKopf.BelegArt = 'EB':U then

      for each bE_BelegPos
        where bE_BelegPos.Firma       = E_BelegKopf.Firma
          and bE_BelegPos.BelegArt    = E_BelegKopf.BelegArt
          and bE_BelegPos.ReferenzNr  = E_BelegKopf.ReferenzNr
        no-lock
        on error undo, throw:

        if lIsRepairOrderLine(bE_BelegPos.BelegArt,
                              bE_BelegPos.ReferenzNr,
                              bE_BelegPos.PositionsNr) then
          return yes.

      end. /* for each bE_BelegPos */

  &ENDIF

end. /* if available E_BelegKopf */

return no.

end function. /* lProvPartSensitive */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION pa_lUISvcObjectState V-table-Win 
FUNCTION pa_lUISvcObjectState returns logical
  ( pcStateCode as character  ) :
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

define variable lPurchaseOrder_Archivable as   logical init yes              no-undo.

&IF lookup ("VS_Repair":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  define variable hContainer              as   handle                        no-undo.
  define variable dAdoptableQtyPP         like TD_E_BelegPosBei.Gesamtmenge  no-undo.
&ENDIF

/* Buffers -------------------------------------------------------------------*/

&IF lookup ("VS_Repair","{&PA-OPTIONEN}") > 0 &THEN
  define buffer bE_BelegPos for E_BelegPos.
&ENDIF.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

case pcStateCode:

  when 'paSCisCROBasedPartialProvidedParts':U then

    return lProvPartSensitive(yes).

  when 'paSCisCROBasedPartialProvPartsVisible':U then

    return ({fnarg
              pa_lProvPartIsModus52
              "pACConnectionSvc:prpcCompany"} = no).

  when 'paSCisCROBasedProvidedParts':U then

    return lProvPartSensitive(no).

  when 'paSCisCROBasedProvidedPartsVisible':U then
  do:

    &IF lookup ("VS_Repair":U,"{&PA-OPTIONEN}":U) > 0 &THEN

      /* The document type was set in local-initialize. This code will be     */
      /* reached after this code, so we have to get the document type asking  */
      /* the current container.                                               */

      run get-link-handle IN adm-broker-hdl
        (input  this-procedure,
         input  'container-source':U,
         output hContainer).

      if valid-handle(hContainer) then
      do:

        run get-attribute in hContainer ('Belegart':U).
        gcBelegart = return-value.

      end. /* if valid-handle(hContainer) */

    &ENDIF

    return (     {fnarg
                   pa_lProvPartIsModus52
                   "pACConnectionSvc:prpcCompany"} = no
            &IF lookup ("VS_Repair":U,"{&PA-OPTIONEN}":U) > 0 &THEN
              or gcBelegart = 'EB':U
            &ENDIF
           ).

  end. /* when 'paSCisCROBasedProvidedPartsVisible':U */

  when 'paSCisOnceOnlySupplier':U then

    return (   not available S_Lieferant
            or S_Lieferant.AdressNr = 0).

  when 'paSCisDocumentArchivable':U then
  do:

    /* Check if the purchase order was generated from a repair order. It      */
    /* mustn't be possible to archive a purchase order, if there are still    */
    /* adoptable provided parts.                                              */

    &IF lookup ("VS_Repair","{&PA-OPTIONEN}") > 0 &THEN

      if    available E_BelegKopf
        and E_BelegKopf.BelegArt = 'EB':U then

        /* Check every purchase order line for a remaining stock quantity. If */
        /* the purchase order line was generated from a sevaral repair order  */
        /* line and a stock quantity is still available, the purchase order   */
        /* must not be archivable.                                            */

        DocumentArchivable:
        for each bE_BelegPos
          fields (Belegart E_BelegPos_Obj)
          where bE_BelegPos.Firma      = E_BelegKopf.Firma
            and bE_BelegPos.BelegArt   = E_BelegKopf.Belegart
            and bE_BelegPos.ReferenzNr = E_BelegKopf.ReferenzNr
          no-lock
          on error undo, throw:

          if eink.base.cls.EBCPurchaseDocSvc:prpoInstance:lIsRepairOrderDocumentLine
                  (bE_BelegPos.E_BelegPos_Obj) then
          do:

            dAdoptableQtyPP = eink.base.cls.EBCPurchaseDocSvc:prpoInstance:dAdoptableRepairProvPartsToEWE
                                (bE_BelegPos.E_BelegPos_Obj).

            lPurchaseOrder_Archivable = dAdoptableQtyPP = 0.

            if lPurchaseOrder_Archivable = no then
              leave DocumentArchivable.

          end. /* if lIsRepairOrderDocumentLine */

        end. /* for each bE_BelegPos */

    &ENDIF.

    return (    pa-fields-enabled
            and available E_BelegKopf
            and E_BelegKopf.offen = yes
            and lPurchaseOrder_Archivable).

  end. /* when 'paSCisDocumentArchivable':U */

  when 'paSCisDocumentArchivedAndTransmitted':U then
    return (    pa-fields-enabled = no
            and available E_BelegKopf
            and E_BelegKopf.Belegart = 'EB':U
            and E_BelegKopf.offen    = no 
            and (   E_BelegKopf.CatalogPurchOrder = yes
                 or info.base.cls.IBCDocumentInfoSvc:prpoInstance:lDocIsTransferred
                      (E_BelegKopf.E_BelegKopf_Obj) = yes)).    

  when 'paSCisTDLPossible':U then
    return     available E_BelegKopf 
           and basis.inwb.cls.BOCLogisticsInterfaceSvc:prpoInstance:lHasValidConfiguration
                 (E_BelegKopf.BelegArt,
                  E_BelegKopf.VersandArt).

  when 'paSCisShippingExists':U then
    return     available E_BelegKopf
           and basis.inwb.cls.BOCLogisticsInterfaceSvc:prpoInstance:lIsShipmentExisting
                 (E_BelegKopf.E_BelegKopf_Obj).

  when 'paSCisDropShippingExists':U then
    return     available E_BelegKopf
           and stamm.base.cls.SBCDropShippingSvc:prpoInstance:lDropShippingInfoExisting(E_BelegKopf.E_BelegKopf_Obj).

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

