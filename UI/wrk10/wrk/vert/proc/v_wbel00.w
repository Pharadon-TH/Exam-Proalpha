&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          basis            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DECLARATIONS V-table-Win 

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

using stamm.base.cls.SBCAttachedDocumentSvo.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*****************************************************************************/
/*                                  (c) 2023 proALPHA Business Solutions GmbH */
/*                                           Auf dem Immel 8                  */
/*                                           67685 Weilerbach                 */
/*                                                                           */
/*  Projekt....: proALPHA                                                    */
/*                                                                           */
/*  Name.......: v_wbel00.w                                                  */
/*  Bereich....: VERT/KERN                                                   */
/*                                                                           */
/*  erstellt am: 23.01.1997                                                  */
/*  Autor......: Martin Wolf                                                 */
/*                                                                           */
/*  Version....: 9.3.2 vom 2023-06-23/Pasch, Uros                             */
/*                                                                           */
/*---------------------------------------------------------------------------*/
/*  AUFGABE                                                                  */
/*---------------------------------------------------------------------------*/
/*                                                                           */
/*  Hauptviewer zur Belegpflege                                              */
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
/* 2022-12-13 Warter, Per e0c2847018b84fe2631abcaa36f10c68f8e0c7ad            */
/*            PA-31634: pAX-eINVOICE: Send invoice to the outbox via menu ite */
/*            m without logic                                                 */
/* 2022-12-21 Krutkevicius, Linas 9f98b2bbc0f89bafc203428d297723c012ff5db6    */
/*            PA-25135: TDL: Nachfakturabelege sollen nicht an KEP-Dienstleis */
/*            ter gemeldet werden                                             */
/* 2022-12-21 Krutkevicius, Linas 07ce4c2d12fcd5c98d7d2d026cbe740fcfa83a0a    */
/*            PA-32405: ATLAS: Ausfuhranmeldung übertragen nicht im MIS zeige */
/*            n                                                               */
/* 2022-12-27 Warter, Per 91a53ed3d2da1d9523136bb589dd14229f4f3050            */
/*            PA-32868: pAX-eINVOICE: Unittest for Send invoice to the outbox */
/*             via menu item without logic                                    */
/* 2023-02-21 Schiffer, Ute d6acf81f113c96451db48b82a02cc48d8b934704          */
/*            PA-29251: Refactoring: HU/PL-correction invoice where propertie */
/*            s are the same for both countries                               */
/* 2023-03-15 Cernauskiene, Zivile (ext.) 4b362a39af001341e26d2aa25f1bc64dc60ae228 */
/*            PA-29176: eInvoice: Conditions for Sending one Invoice are met? */
/* 2023-03-21 Stegner, Kevin 27a190456b3b2ed314df8be20cc7725a4eefaf59         */
/*            PA-34912: Refactor cSendEInvoice from VBCSalesDocSvc class into */
/*             VFCEInvoiceSvc class                                           */
/* 2023-03-24 Ossaid, Samir 687d13c3c951092f06ab416f07c0cae71ca0c07c          */
/*            PA-33839: view and save the DMS credit documents using ray clie */
/*            nt                                                              */
/* 2023-03-24 Cernauskiene, Zivile (ext.) de5ef529f45a09620013d8b43e60d9fb498856c0 */
/*            PA-32344: eInvoice: Show Status on Invoice Header               */
/* 2023-04-05 Cernauskiene, Zivile (ext.) b8dea17dbc84cbaf3099617078204b6e723df816 */
/*            PA-32351: eInvoice: No Editing / Deletion of Invoices in Transm */
/*            ission Process allowed                                          */
/* 2023-04-20 Si?iovas, Rokas (ext.) e446f3da8ddbf284630fdc6ab71515198620d1bd */
/*            PA-33186: Toggle|Checkbox "Beleg anhängen" beim E-Mail-Versende */
/*            n eines Belegs ist per Default aktiviert|gesetzt                */
/* 2023-05-05 Ossaid, Samir b32e2b45b3544192f32f10204d2d5ae5990b1304          */
/*            PA-34791: Statistik: Bei einer Retoure (Fremdbestand) wird im F */
/*            alle einer Vereinnahmung und anschließender Wertgutschrift die  */
/* 2023-05-09 Ossaid, Samir ac43459bf0a234c9cbac0150ff90a128d621b416          */
/*            PA-36657: Consistency Checks Hit >> due to service changes in t */
/*            he program v_wbel00.w                                           */
/* 2023-05-12 Ossaid, Samir c814f32f05bd3559a9b5c7b7e35bcfd6d3813aa4          */
/*            PA-36790: ATLAS: shipping documents in need for customs declara */
/*            tion can't be released                                          */
/* 2023-06-23 Pasch, Uros 11e135f39334be4d8b3c8b10ba9f66b4d0790689            */
/*            PA-36618: Implementierung Versandparameter greifen nicht bei An */
/*            gebot für Kontakt ohne eigene Kundennummer                      */
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

&GLOBAL-DEFINE pa-Autor             Martin Wolf
&GLOBAL-DEFINE pa-Version           9.3.2
&GLOBAL-DEFINE pa-Datum             2023-06-23
&GLOBAL-DEFINE pa-Letzter           Pasch, Uros

&GLOBAL-DEFINE pa-GenVersion       UIB
&GLOBAL-DEFINE pa-ProgrammTyp      SmartViewer
&GLOBAL-DEFINE pa-Template         adm/template/proc/dt_viw00.w
&GLOBAL-DEFINE pa-TemplateVersion  1.04

&GLOBAL-DEFINE pa-XBasisName       v_wbel00_w


/* lokale Konstanten *********************************************************/

&Scop pa-hlp-fieldnames Empfaenger
&scop pa-hlp-keynames   Name

&SCOP PA-HLP-InitialHelpString gcInitialHelpString

/* s__adr00.lib */

&GLOBAL-DEFINE EXCLUDE-c_Postfachformat               yes
&GLOBAL-DEFINE EXCLUDE-c_Ortsformat                   yes
&GLOBAL-DEFINE EXCLUDE-cStaatsbezeichnung             yes
&GLOBAL-DEFINE EXCLUDE-komprimierte_Adresse           yes

/* v__bel00.lib */

&GLOBAL-DEFINE EXCLUDE-Abruf                          yes
&GLOBAL-DEFINE EXCLUDE-BelegPositionen_anlegen        yes
&GLOBAL-DEFINE EXCLUDE-MLL-Positionen_anlegen         yes
&GLOBAL-DEFINE EXCLUDE-SetAnlegen                     yes
&GLOBAL-DEFINE EXCLUDE-Fill_ttPosition                yes
&GLOBAL-DEFINE EXCLUDE-r_MLL_Kopf_anlegen             yes

/* v_wbel05.lib */
&GLOBAL-DEFINE EXCLUDE-PruefeSetBestandteile          yes
&GLOBAL-DEFINE EXCLUDE-ProcessSET                     yes
&GLOBAL-DEFINE EXCLUDE-use-CancelSet                  yes

/* v__zzi00.lib */

&GLOBAL-DEFINE EXCLUDE-AbgleichZahlungsziel           yes

/* EXTERNE DEFINITIONEN -----------------------------------------------------*/

{adm/template/incl/dt_viw00.df}

/* LOKALE OBJEKTE -----------------------------------------------------------*/
/* Variable ******************************************************************/
/*   Name               Funktion                                             */
/*   ------------------ ---------------------------------------------------- */
/* lSchlussrechnung    Schlussrechnung (true) oder "normaler" Beleg          */
/* cBereich            Bereich für Zustandsverwaltung                        */
/* gtPCopyDate         copy date (used in polish localization)               */
/*****************************************************************************/

define variable cTmp                as char                       no-undo.
define variable cBelegart           as char                       no-undo.
define variable cSatzId             as char                       no-undo.
define variable cSatzId_neu         as char                       no-undo.
define variable iKunde              as integer                    no-undo.
define variable lOK                 as logical                    no-undo.
define variable gcStaat             as char                       no-undo.
define variable glZuschlag_sperren  as logical                    no-undo.
define variable lSchlussrechnung    as logical                    no-undo.
define variable cBereich            as char                       no-undo.
define variable lSatz_offen         as logical                    no-undo.
define variable lArchivieren        as logical                    no-undo.
define variable cRunMode            as char                       no-undo.
define variable gceMail             as char                       no-undo.
define variable cLieferadresse      as char                       no-undo.
define variable cRechnungsadresse   as char                       no-undo.
define variable lBelegdrucken       as logical                    no-undo.
define variable cDruckprogramm      as char                       no-undo.
define variable cDruckvorlauf       as char                       no-undo.
define variable gcGeneratortyp      as char    init 'P':U         no-undo.
define variable lSpeichern          as logical                    no-undo.
define variable lCancel             as logical                    no-undo.
define variable glAttach            as logical                    no-undo.
define variable gcAttach            as character                  no-undo.
define variable glUpdate            as logical                    no-undo.
define variable glZustandPruefen    as logical init yes           no-undo.
define variable glPositionen        as logical init yes           no-undo.
define variable cFO_OP_Obj          as character                  no-undo.
define variable gcBestimmungsort    as character                  no-undo.
define variable glBelegsumme        as logical                    no-undo.
define variable glAdd               as logical                    no-undo.
define variable gcSMArt             as character                  no-undo.
define variable gcInitialHelpString as character                  no-undo.
define variable glBeleguebernahme   as logical                    no-undo.
define variable glDestroy           as logical                    no-undo.
define variable gcAddressInfoWinTitle as character                no-undo.
define variable giCustDeclState     as integer                    no-undo.
define variable glGedruckt          as logical                    no-undo.

define variable gcOIDBank           as character                  no-undo.
define variable gcBank              as character                  no-undo.
define variable gcAccount           as character                  no-undo.
define variable gcIBAN              as character                  no-undo.
define variable glOpenAdress        as logical init yes           no-undo.
define variable glModifyBank        as logical                    no-undo.
define variable gcTaxCodeOID        like V_BelegKopf.S_Steuer_Obj no-undo.

/* UrB--- placeholder until the old proceeding for adopting will die */

define variable gcOIDSourceDoc      as character                  no-undo.
define variable gcSourceDocType     as character                  no-undo.

&IF lookup("V_PKF":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  &IF LOOKUP("MU":U,"{&PA-MODULE}":U) > 0 &THEN
    define variable goPCRuntime as mawi.auf.cls.MUCConfRuntimeFacadeSvo no-undo.
  &ENDIF
&ENDIF

define variable gtPCopyDate      as date    init ?  no-undo.

  /* --> UMO#WH2017-04-002 ash Kundencenter: Drucken und Mailen */
  &IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  define variable gluRemote          as logical          no-undo.
  &ENDIF
  /* <-- UMO#WH2017-04-002 ash Kundencenter: Drucken und Mailen */

  /* --> UMO#WH2016-02-002 cpl Folgebelege aus Kundencenter generieren */
  define variable gluAdopting        as logical          no-undo.
  /* <-- UMO#WH2016-02-002 cpl Folgebelege aus Kundencenter generieren */

  &IF LOOKUP("U_CW":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  /* --> UMO#WH2015-10-001 cpl Kundencenter */
  define variable giuBelegPKS        as integer          no-undo.
  /* <-- UMO#WH2015-10-001 cpl Kundencenter */
  &ENDIF

  /* --> UMO#CM2017-05-001 tri Versandstückliste */
  &IF LOOKUP("U_CM":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  define variable gluVersand                as logical          no-undo.
  define variable gluNewDocument            as logical          no-undo.
  define variable gcuV_BelegKopf_Obj_Source as character        no-undo.
  define variable gcuV_BelegKopf_Obj_Target as character        no-undo.
  define variable giSource                  as integer          no-undo.
  &ENDIF
  /* <-- UMO#CM2017-05-001 tri Versandstückliste */

  /* --> UMO#CA2016-05-003 MOu Rahmenauftrag: Auftragsschnellerfassung */
  &IF LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  define variable gcuBelegkopf_Obj        like V_BelegKopf.V_BelegKopf_Obj  no-undo.
   define variable gcuBelegkopf_Obj-VUR   like V_BelegKopf.V_BelegKopf_Obj  no-undo.
  define variable giuKunde                like V_BelegKopf.Kunde            no-undo init 0.
  &ENDIF
  /* <-- UMO#CA2016-05-003 MOu */

  /* --> UMO#CA2016-05-003a MOu Rahmenauftrag: Auftragsschnellerfassung vereinfachen */
  &IF LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  define variable gcuArtikel-VUR like V_BelegPos.Artikel   no-undo.
  &ENDIF
  /* <-- UMO#CA2016-05-003a MOu Rahmenauftrag: Auftragsschnellerfassung vereinfachen */

  /* --> UMO#CE2018-07-001 MDe Auftragseingang Rahmenaufträge: Fehler bei Überlieferung */
  &IF LOOKUP("U_CE":U,"{&PA-OPTIONEN}":U) > 0
    OR LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN

  define buffer gbuV_BelegPos for V_BelegPos.

  &ENDIF
  /* <-- UMO#CE2018-07-001 MDe Auftragseingang Rahmenaufträge: Fehler bei Überlieferung */

  /* --> UMO#CA2016-05-003a MOu Rahmenauftrag: Auftragsschnellerfassung vereinfachen */
  &IF LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  define variable ghuHandle        as handle         no-undo.
  define variable ghuSourceHandle  as handle         no-undo.
  &ENDIF
  /* <-- UMO#CA2016-05-003a MOu Rahmenauftrag: Auftragsschnellerfassung vereinfachen */

  define variable gluQuoteVersioning as logical            no-undo.

  define variable glDMSAttachments   as logical initial no no-undo.

  define variable goAuthorityDataParameters as class stamm.base.cls.SBCAuthorityDataDio no-undo.

/* Buffer ********************************************************************/

define buffer Buf1_V_BelegKopf for V_BelegKopf.
define buffer Buf_V_BelegPos   for V_BelegPos.

/* Work-/Temp-Tables *********************************************************/

{stamm/incl/s__adr00.tdf &ippNoReferenceOnlySwitch = "yes"}

&IF LOOKUP("U_CW":U,"{&PA-OPTIONEN}":U) > 0 &THEN
{stamm/incl/s__adr00.tdf &ippNoReferenceOnlySwitch = "yes" &ippSuffix ="_UCW"}
&ENDIF

/* documents */
{vert/incl/v__doc00.tdf
  &ippSuffix= "-NEW"
  &ippNoReferenceOnlySwitch = "yes"}

/* Lines */
{vert/incl/v__doc03.tdf
  &ippSuffix= "-NEW"
  &ippNoReferenceOnlySwitch = "yes" }

/* sales BOM */
{vert/incl/v__doc05.tdf
  &ippSuffix= "-NEW"
  &ippNoReferenceOnlySwitch = "yes"}

{vert/incl/v__bel00.tdf
  &KopfTabelle              = "TT_V_BelegSumKopf"
  &PosTabelle               = "TT_V_BelegSumPo"
  &ippNoReferenceOnlySwitch = "YES"
}

define temp-table Kund_Adresse-TMP no-undo like S_Adresse.
define temp-table Lief_Adresse-TMP no-undo like S_Adresse.
define temp-table Rech_Adresse-TMP no-undo like S_Adresse.
define temp-table gtt_O_Notiz      no-undo like TD_O_Treffer.
define temp-table gtt_O_Selektion  no-undo like TD_O_Selektion.
define temp-table gtt_O_Treffer    no-undo like TD_O_Treffer.

/* Streams *******************************************************************/

define stream logStream.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define LAYOUT-VARIABLE CURRENT-WINDOW-layout

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES V_BelegKopf
&Scoped-define FIRST-EXTERNAL-TABLE V_BelegKopf


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR V_BelegKopf.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS V_BelegKopf.uCI_Sammellieferschein ~
V_BelegKopf.Kunde V_BelegKopf.Empfaenger V_BelegKopf.Wiedervorlage ~
V_BelegKopf.uAngebot V_BelegKopf.uAngebotsversion 
&Scoped-define ENABLED-TABLES V_BelegKopf
&Scoped-define FIRST-ENABLED-TABLE V_BelegKopf
&Scoped-Define ENABLED-OBJECTS btnuFreigabe 
&Scoped-Define DISPLAYED-FIELDS V_BelegKopf.uCI_Sammellieferschein ~
V_BelegKopf.Kunde V_BelegKopf.BelegNummer V_BelegKopf.Empfaenger ~
V_BelegKopf.Sachbearbeiter V_BelegKopf.Wiedervorlage ~
V_BelegKopf.AuftragsArt V_BelegKopf.BelegDatum V_BelegKopf.Interessent ~
V_BelegKopf.offen V_BelegKopf.SBM_ProfitCenter_Obj V_BelegKopf.uAngebot ~
V_BelegKopf.uAngebotsversion V_BelegKopf.H_Cancelled ~
V_BelegKopf.H_Corrected V_BelegKopf.H_InvoiceType ~
V_BelegKopf.ReverseInvoice V_BelegKopf.VBM_PreConfigVariant_Obj 
&Scoped-define DISPLAYED-TABLES V_BelegKopf
&Scoped-define FIRST-DISPLAYED-TABLE V_BelegKopf
&Scoped-Define DISPLAYED-OBJECTS V_Bele_PreConfigVariant_Obj_Info cISdINo ~
gcuCIBelegStatus gluCM_Versand V_Bele_SBM_ProfitCenter_Obj_Info ~
V_BelegKopf_Sachbearbeiter_Info gcBelegInfoRA c_Name-1 c_Name-2 c_Strasse ~
V_BelegKopf_Wiedervorlage_Info C_Ort V_BelegKopf_AuftragsArt_Info ~
V_BelegKopf_BelegDatum_Info 

/* Custom List Definitions                                              */
/* PA-CREATE-FIELDS,ADM-ASSIGN-FIELDS,PA-PROTECTED-FIELDS,PA-UPDATE-VARS,PA-PROMPT-FIELDS,PA-SEARCH-FIELDS */
&Scoped-define ADM-ASSIGN-FIELDS V_BelegKopf.Kunde V_BelegKopf.BelegNummer ~
V_BelegKopf.uAngebot V_BelegKopf.uAngebotsversion 
&Scoped-define PA-PROTECTED-FIELDS V_BelegKopf.Sachbearbeiter ~
V_BelegKopf.AuftragsArt V_BelegKopf.BelegDatum 
&Scoped-define PA-UPDATE-VARS btnuFreigabe 
&Scoped-define PA-SEARCH-FIELDS V_BelegKopf.Kunde V_BelegKopf.BelegNummer ~
V_BelegKopf.uAngebot V_BelegKopf.uAngebotsversion 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Konfiguration" V-table-Win _INLINE
/* Actions: ? adm/support/proc/ds_viw06.w ? ? ? */

&SCOP PA-MEMFIELD1 V_BelegKopf.BelegNummer
&SCOP PA-MEMORY1 BelegNummer
&SCOP PA-MEM1-WRITEONLY YES
&SCOP PA-MEMFIELD2 V_BelegKopf.Kunde
&SCOP PA-MEMORY2 Kunde
&SCOP PA-MEM2-WRITEONLY YES

&SCOP PA-CREATEWORKFLOWEVENT-TABLE      V_BelegKopf
&SCOP PA-CREATEWORKFLOWEVENT-OT    V_BelegKopf.Auftragsart
&SCOP PA-CREATEWORKFLOWEVENT-FIELD      Verteilergruppe


&SCOP PA-SMART gcSMArt

&SCOP PA-PRINT-PROCEDURE cDruckvorlauf

&SCOP PA-DMSCOLD-SUPPORT YES
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
&SCOP PA-OIDINFOFIELDS     V_BelegKopf.SBM_ProfitCenter_Obj,V_BelegKopf.VBM_PreConfigVariant_Obj
&SCOP PA-OIDINFOVARIABLES  V_Bele_SBM_ProfitCenter_Obj_Info,V_Bele_PreConfigVariant_Obj_Info
&SCOP PA-OIDINFOTARGETS    DBM_ShortDescription.ShortDesc1,DBM_ShortDescription.ShortDesc1
&SCOP PA-OIDINFOBASEFIELDS SBM_ProfitCenter_Obj,VBM_PreConfigVariant_Obj
/***
</Constants>
<InfoFields>
V_BelegKopf.AuftragsArt|Text|basis.S_AuftragsArtSpr.Bezeichnung|S_AuftragsArtSpr.Firma = {firma/saufart.fir pa-Firma};S_AuftragsArtSpr.AuftragsArt = input frame {&Frame-Name} V_BelegKopf.AuftragsArt|V_BelegKopf_AuftragsArt_Info
V_BelegKopf.Wiedervorlage|day|||V_BelegKopf_Wiedervorlage_Info
V_BelegKopf.BelegDatum|day|||V_BelegKopf_BelegDatum_Info
V_BelegKopf.Sachbearbeiter|Text|basis.BU_Benutzer.Name|BU_Benutzer.Benutzer = input frame {&Frame-Name} V_BelegKopf.Sachbearbeiter|V_BelegKopf_Sachbearbeiter_Info
V_BelegKopf.SBM_ProfitCenter_Obj|OIDReplacement|DBM_ShortDescription.ShortDesc1|SBM_ProfitCenter_Obj|V_Bele_SBM_ProfitCenter_Obj_Info
V_BelegKopf.VBM_PreConfigVariant_Obj|OIDReplacement|DBM_ShortDescription.ShortDesc1|VBM_PreConfigVariant_Obj|V_Bele_PreConfigVariant_Obj_Info
</InfoFields> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Dynamic InfoFields" V-table-Win _INLINE
/* Actions: ? ? ? ? adm/support/proc/ds_viw09.p */

&SCOPED-DEFINE pa-UpdateHiddenScreenvalues ~
  assign~
    V_BelegKopf.SBM_ProfitCenter_Obj:screen-value in frame {&FRAME-NAME} = (if available V_BelegKopf then V_BelegKopf.SBM_ProfitCenter_Obj else '':U)~
    V_BelegKopf.VBM_PreConfigVariant_Obj:screen-value in frame {&FRAME-NAME} = (if available V_BelegKopf then V_BelegKopf.VBM_PreConfigVariant_Obj else '':U)~
    V_BelegKopf.H_InvoiceType:screen-value in frame {&FRAME-NAME} = (if available V_BelegKopf then string(V_BelegKopf.H_InvoiceType, '9':U) else '':U)~
    .
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update Support" V-table-Win _INLINE
/* Actions: ? adm/support/proc/ds_sma00.w ? ? adm/support/proc/ds_viw00.p */
/* STRUCTURED-DATA
<ADDITIONAL-INFORMATION EDITABLE>
V_BelegKopf:Index = BelegNr
V_BelegKopf.offen = yes
V_BelegKopf.Belegart = cBelegart
V_BelegKopf.LfdNr = V_BelegKopf.LfdNr
</ADDITIONAL-INFORMATION EDITABLE>

<CONSTANTS>
*****/
&SCOP ENABLED-TABLES V_BelegKopf
&SCOP FIRST-ENABLED-TABLE V_BelegKopf
&SCOP PA-FIRST-INITIAL-VALUES~
  V_BelegKopf.Firma = ~{firma/vbelegko.fir pa-Firma}~
  V_BelegKopf.Belegart = cBelegart~
  V_BelegKopf.offen = yes~
  V_BelegKopf.BelegNummer = input frame ~{&Frame-Name} V_BelegKopf.BelegNummer~
  V_BelegKopf.LfdNr = V_BelegKopf.LfdNr~
  V_BelegKopf.Kunde = input frame ~{&FRAME-NAME} V_BelegKopf.Kunde~
  V_BelegKopf.uAngebot = input frame ~{&FRAME-NAME} V_BelegKopf.uAngebot~
  V_BelegKopf.uAngebotsversion = input frame ~{&FRAME-NAME} V_BelegKopf.uAngebotsversion
&SCOP PA-FIRST-CHECK~
  V_BelegKopf.BelegNummer = input frame ~{&Frame-Name} V_BelegKopf.BelegNummer
&SCOP PA-FIRST-COMPARE~
  V_BelegKopf.Firma = ~{firma/vbelegko.fir pa-Firma}~
  and V_BelegKopf.Belegart = cBelegart~
  and V_BelegKopf.offen = yes~
  and V_BelegKopf.BelegNummer = input frame ~{&Frame-Name} V_BelegKopf.BelegNummer~
  and V_BelegKopf.LfdNr = V_BelegKopf.LfdNr
&SCOP PA-FIRST-EXCEPT-FIELDS {&PA-FIRST-EXCEPT-FIELDS} Firma BelegArt ReferenzNr Kunde BelegNummer uAngebot uAngebotsversion AnlageBenutzer AnlageDatum AnlageZeit AenderungBenutzer AenderungDatum AenderungZeit V_BelegKopf_Obj
&SCOP PA-PRIMARY-FIELD V_BelegKopf.BelegNummer
/*****
</CONSTANTS> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Search Support" V-table-Win _INLINE
/* Actions: ? adm/support/xedit.w ? ? adm/support/proc/ds_viw03.p */
/* STRUCTURED-DATA
<BUILD-INFORMATION>
1.09

basis.V_BelegKopf.Kunde,basis.V_BelegKopf.BelegNummer,basis.V_BelegKopf.uAngebot,basis.V_BelegKopf.uAngebotsversion
</BUILD-INFORMATION>
<STATEMENTS>
*****/
&SCOP PA-SEARCH-ENABLE-STATEMENT~
  enable unless-hidden~
    V_BelegKopf.Kunde~
      when can-do(pa-supported-sortby,'Kunde':U)~
    V_BelegKopf.BelegNummer~
      when can-do(pa-supported-sortby,'BelegNummer':U)~
    V_BelegKopf.uAngebot~
      when can-do(pa-supported-sortby,'uAngebot':U)~
    V_BelegKopf.uAngebotsversion~
      when can-do(pa-supported-sortby,'uAngebotsversion':U)~
    with frame {&FRAME-NAME}.
&SCOP PA-SEARCH-DISABLE-STATEMENT~
  disable unless-hidden~
    V_BelegKopf.Kunde~
    V_BelegKopf.BelegNummer~
    V_BelegKopf.uAngebot~
    V_BelegKopf.uAngebotsversion~
    with frame {&FRAME-NAME}.
&SCOP PA-FIELDS-ENABLE-STATEMENT~
  enable unless-hidden~
    V_BelegKopf.uCI_Sammellieferschein~
      when not can-do(pa-disabled-fields,'V_BelegKopf.uCI_Sammellieferschein':U)~
    V_BelegKopf.Empfaenger~
      when not can-do(pa-disabled-fields,'V_BelegKopf.Empfaenger':U)~
    V_BelegKopf.Wiedervorlage~
      when not can-do(pa-disabled-fields,'V_BelegKopf.Wiedervorlage':U)~
    btnuFreigabe~
      when not can-do(pa-disabled-fields,'v_wbel00_w.btnuFreigabe':U)~
    with frame {&Frame-Name}.
&SCOP PA-FIELDS-DISABLE-STATEMENT~
  disable unless-hidden~
    V_BelegKopf.uCI_Sammellieferschein~
    V_BelegKopf.Empfaenger~
    V_BelegKopf.Wiedervorlage~
    btnuFreigabe~
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
Kunde||y|mawi.V_BelegKopf.Kunde||||||
BelegNummer||y|Mawi.V_BelegKopf.BelegNummer||||||
ShippingType||y|basis.V_BelegKopf.VersandArt||||||
DocumentOwning_Obj||y|basis.V_BelegKopf.V_BelegKopf_Obj||||||
Owning_Obj||y|basis.V_BelegKopf.V_BelegKopf_Obj||||||
P_Owning_Obj||y|basis.V_BelegKopf.V_BelegKopf_Obj||||||
Interessent||y|Mawi.V_BelegKopf.Interessent||||||
Textsprache||y|pa-Sprache||||||
FO_OP_Obj||y|cFO_OP_Obj||||||
ReferenzNr||y|mawi.V_BelegKopf.ReferenzNr||||||
BelegArt||y|mawi.V_BelegKopf.BelegArt||||||
$KEY||y|mawi.V_BelegKopf|vert/incl/v_belko.sl|||||
Schluessel||y|'':U||||||
Origin_Obj||y|basis.V_BelegKopf.V_BelegKopf_Obj||||||
V_BelegKopf_Obj||y|mawi.V_BelegKopf.V_BelegKopf_Obj||||||
Origin_Obj||y|mawi.V_BelegKopf.Origin_Obj||||||
JBT_Project_Obj||y|mawi.V_BelegKopf.JBT_Project_Obj||||||
SBM_BankDataAcc_Obj||y|mawi.V_BelegKopf.SBM_BankDataAcc_Obj||||||
AddressInfoWinTitle||y|gcAddressInfoWinTitle||||||
S_Kunde_Obj||y|basis.S_Kunde.S_Kunde_Obj||||||
MMM_CusRefOrder_Obj||y|mawi.V_BelegKopf.MMM_CusRefOrder_Obj||||||
Driver_Obj||y|mawi.V_BelegKopf.Driver_Obj||||||
SBM_BusinessCategory_Obj||y|mawi.V_BelegKopf.SBM_BusinessCategory_Obj||||||
SBM_ProfitCenter_Obj||y|mawi.V_BelegKopf.SBM_ProfitCenter_Obj||||||
SBM_FiscalText_Obj||y|mawi.V_BelegKopf.SBM_FiscalText_Obj||||||
SBM_TaxCase_Obj||y|mawi.V_BelegKopf.SBM_TaxCase_Obj||||||
S_Steuer_Obj||y|mawi.V_BelegKopf.S_Steuer_Obj||||||
uAngebot||y|basis.V_BelegKopf.uAngebot||||||
uAngebot_LfdNr||y|basis.V_BelegKopf.uAngebot_LfdNr||||||
uAngebotsversion||y|basis.V_BelegKopf.uAngebotsversion||||||
S_F_Journal_Obj||y|mawi.V_BelegKopf.S_F_Journal_Obj||||||
S_I_TaxExemption_Obj||y|mawi.V_BelegKopf.S_I_TaxExemption_Obj||||||
S_BankVerb_Obj||y|mawi.V_BelegKopf.S_BankVerb_Obj||||||
VBM_PreConfigVariant_Obj||y|mawi.V_BelegKopf.VBM_PreConfigVariant_Obj||||||
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
run set-attribute-list (
    'Keys-Accepted = ,
     Keys-External = ,
     Keys-Supplied = "Kunde,BelegNummer,ShippingType,DocumentOwning_Obj,Owning_Obj,P_Owning_Obj,Interessent,Textsprache,FO_OP_Obj,ReferenzNr,BelegArt,$KEY,Schluessel,Origin_Obj,V_BelegKopf_Obj,Origin_Obj,JBT_Project_Obj,SBM_BankDataAcc_Obj,AddressInfoWinTitle,S_Kunde_Obj,MMM_CusRefOrder_Obj,Driver_Obj,SBM_BusinessCategory_Obj,SBM_ProfitCenter_Obj,SBM_FiscalText_Obj,SBM_TaxCase_Obj,S_Steuer_Obj,uAngebot,uAngebot_LfdNr,uAngebotsversion,S_F_Journal_Obj,S_I_TaxExemption_Obj,S_BankVerb_Obj,VBM_PreConfigVariant_Obj"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "InfoTables" V-table-Win _INLINE
/* Actions: ? adm/support/proc/ds_sma00.w ? ? adm/support/proc/ds_tbl01.p */
/* STRUCTURED-DATA
<CONSTANTS>
***/
&SCOP EXTERNAL-TABLES V_BelegKopf
&SCOP PA-INTERNAL-TABLES ttS_Adresse
/***
</CONSTANTS>
<BUILD-INFORMATION>
1.01
</BUILD-INFORMATION>
<TABLES>
temp-db.ttS_Adresse|ttS_Adresse.Firma = {firma/s_adres.fir pACConnectionSvc:prpcCompany};ttS_Adresse.AdressNr = V_BelegKopf.AdressNr|
</TABLES>
<ADDITIONAL-INFORMATION EDITABLE></ADDITIONAL-INFORMATION EDITABLE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Window Title" V-table-Win _INLINE
/* Actions: ? adm/support/proc/ds_sma00.w ? ? adm/support/proc/ds_ttl00.p */
/* STRUCTURED-DATA
<TITLE-CODE EDITABLE></TITLE-CODE EDITABLE>
<CONSTANTS></CONSTANTS>  */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Skin Client Support" V-table-Win _INLINE
/* Actions: ? ? ? ? adm/support/proc/ds_skc00.p */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD luNewCreatedOrder V-table-Win 
FUNCTION luNewCreatedOrder returns logical
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD pa_lUISvcObjectState V-table-Win 
FUNCTION pa_lUISvcObjectState returns logical
  (pcStateCode as character) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* Define a variable to store the name of the active layout.            */
DEFINE VAR CURRENT-WINDOW-layout AS CHAR INITIAL "Master Layout":U NO-UNDO.

/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON btnuFreigabe 
     LABEL "Freigabe":T8 
     SIZE 15 BY 1.

DEFINE VARIABLE c_Name-1 LIKE V_BelegKopfAdr.Name1
     VIEW-AS FILL-IN 
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE c_Name-2 LIKE V_BelegKopfAdr.Name2
     VIEW-AS FILL-IN 
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE C_Ort AS CHARACTER FORMAT "x(40)":U 
     LABEL "Ort":R18 
     VIEW-AS FILL-IN 
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE c_Strasse AS CHARACTER FORMAT "x(40)":U 
     LABEL "Straße":R18 
     VIEW-AS FILL-IN 
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE cISdINo AS CHARACTER FORMAT "X(32)":U 
     LABEL "SdI-Nummer":R18 
     VIEW-AS FILL-IN 
     SIZE 32 BY 1 NO-UNDO.

DEFINE VARIABLE gcBelegInfoRA AS CHARACTER FORMAT "X(30)":U 
     LABEL "Rechnungsart":R18 
     VIEW-AS FILL-IN 
     SIZE 36 BY 1 NO-UNDO.

DEFINE VARIABLE gcuCIBelegStatus AS CHARACTER FORMAT "X(32)":U 
     VIEW-AS FILL-IN 
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE V_Bele_PreConfigVariant_Obj_Info AS CHARACTER FORMAT "X(80)":U 
     VIEW-AS FILL-IN 
     SIZE 24 BY 1 NO-UNDO.

DEFINE VARIABLE V_Bele_SBM_ProfitCenter_Obj_Info AS CHARACTER FORMAT "X(80)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE V_BelegKopf_AuftragsArt_Info AS CHARACTER FORMAT "x(30)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY 1 NO-UNDO.

DEFINE VARIABLE V_BelegKopf_BelegDatum_Info AS CHARACTER FORMAT "x(256)":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY 1 NO-UNDO.

DEFINE VARIABLE V_BelegKopf_Sachbearbeiter_Info AS CHARACTER FORMAT "X(35)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE V_BelegKopf_Wiedervorlage_Info AS CHARACTER FORMAT "x(256)":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY 1 NO-UNDO.

DEFINE IMAGE sDocInfo TRANSPARENT
     SIZE 4 BY 1.

DEFINE IMAGE sNoteInfo TRANSPARENT
     SIZE 4 BY 1.

DEFINE IMAGE sRecordState TRANSPARENT
     SIZE 4 BY 1.

DEFINE IMAGE sTextInfo TRANSPARENT
     SIZE 4 BY 1.

DEFINE VARIABLE gluCM_Versand AS LOGICAL INITIAL no 
     LABEL "Versandstückliste":L18 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     V_Bele_PreConfigVariant_Obj_Info AT ROW 8 COL 37 COLON-ALIGNED NO-LABEL
     cISdINo AT ROW 4 COL 81 COLON-ALIGNED
     btnuFreigabe AT ROW 2 COL 99
     gcuCIBelegStatus AT ROW 3 COL 95 COLON-ALIGNED NO-LABEL
     gluCM_Versand AT ROW 8 COL 87.5
     V_BelegKopf.uCI_Sammellieferschein AT ROW 8 COL 87.5
          VIEW-AS TOGGLE-BOX
          SIZE 24 BY 1
     V_Bele_SBM_ProfitCenter_Obj_Info AT ROW 4 COL 97 COLON-ALIGNED NO-LABEL
     V_BelegKopf_Sachbearbeiter_Info AT ROW 5 COL 97 COLON-ALIGNED NO-LABEL
     gcBelegInfoRA AT ROW 7 COL 81 COLON-ALIGNED
     V_BelegKopf.Kunde AT ROW 1 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY 1
     V_BelegKopf.BelegNummer AT ROW 1 COL 81 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY 1
     c_Name-1 AT ROW 2 COL 21 COLON-ALIGNED HELP
          ""
     c_Name-2 AT ROW 3 COL 21 COLON-ALIGNED HELP
          "" NO-LABEL
     V_BelegKopf.Empfaenger AT ROW 4 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 40 BY 1
     V_BelegKopf.Sachbearbeiter AT ROW 5 COL 81 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY 1
     c_Strasse AT ROW 5 COL 21 COLON-ALIGNED
     V_BelegKopf.Wiedervorlage AT ROW 6 COL 81 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY 1
     V_BelegKopf_Wiedervorlage_Info AT ROW 6 COL 93 COLON-ALIGNED NO-LABEL
     C_Ort AT ROW 6 COL 21 COLON-ALIGNED
     V_BelegKopf.AuftragsArt AT ROW 7 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY 1
     V_BelegKopf_AuftragsArt_Info AT ROW 7 COL 29 COLON-ALIGNED NO-LABEL
     V_BelegKopf.BelegDatum AT ROW 2 COL 81 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY 1
     V_BelegKopf_BelegDatum_Info AT ROW 2 COL 93 COLON-ALIGNED NO-LABEL
     V_BelegKopf.Interessent AT ROW 1 COL 33 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY 1
     V_BelegKopf.offen AT ROW 3 COL 83
          VIEW-AS TOGGLE-BOX
          SIZE 24 BY 1
     V_BelegKopf.SBM_ProfitCenter_Obj AT ROW 4 COL 81 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY 1
     V_BelegKopf.uAngebot AT ROW 2 COL 81 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY 1
     V_BelegKopf.uAngebotsversion AT ROW 2 COL 93 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.5 BY 1
     V_BelegKopf.H_Cancelled AT ROW 9 COL 23
          VIEW-AS TOGGLE-BOX
          SIZE 20 BY 1
     V_BelegKopf.H_Corrected AT ROW 9 COL 46.5
          VIEW-AS TOGGLE-BOX
          SIZE 20 BY 1
     V_BelegKopf.H_InvoiceType AT ROW 8 COL 81 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 36 BY 1
     V_BelegKopf.ReverseInvoice AT ROW 8 COL 83
          VIEW-AS TOGGLE-BOX
          SIZE 24 BY 1
     V_BelegKopf.VBM_PreConfigVariant_Obj AT ROW 8 COL 21 COLON-ALIGNED
          LABEL ""
          VIEW-AS FILL-IN 
          SIZE 16 BY 1
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
   External Tables: mawi.V_BelegKopf
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
         HEIGHT             = 9.38
         WIDTH              = 118.63.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{vert/incl/v__bel00.lib}
{stamm/incl/s__adr00.lib}
{adm/method/incl/dm_viw01.lib}
{vert/incl/v__zzi00.lib}
{vert/incl/v_wbel05.lib}
{vert/incl/v__inc00.lib}
&IF lookup("M_ATLAS","{&PA-OPTIONEN}") > 0 &THEN
  {mawi/incl/m__atl00.lib}
&ENDIF
/* --> UMO#CA2018-03-001b jpd Versandparameter - Frachtkosten */
&IF LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  {vert/incl/v__pfi01.lib}
&ENDIF
/* <-- UMO#CA2018-03-001b jpd Versandparameter - Frachtkosten */

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

/* SETTINGS FOR FILL-IN V_BelegKopf.AuftragsArt IN FRAME F-Main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN V_BelegKopf.BelegDatum IN FRAME F-Main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN V_BelegKopf.BelegNummer IN FRAME F-Main
   NO-ENABLE 2 6                                                        */
/* SETTINGS FOR BUTTON btnuFreigabe IN FRAME F-Main
   4                                                                    */
/* SETTINGS FOR FILL-IN c_Name-1 IN FRAME F-Main
   NO-ENABLE LIKE = basis.V_BelegKopfAdr.Name1 EXP-SIZE                 */
/* SETTINGS FOR FILL-IN c_Name-2 IN FRAME F-Main
   NO-ENABLE LIKE = basis.V_BelegKopfAdr.Name2 EXP-LABEL                */
/* SETTINGS FOR FILL-IN C_Ort IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c_Strasse IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cISdINo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gcBelegInfoRA IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gcuCIBelegStatus IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX gluCM_Versand IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX V_BelegKopf.H_Cancelled IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX V_BelegKopf.H_Corrected IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN V_BelegKopf.H_InvoiceType IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN V_BelegKopf.Interessent IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN V_BelegKopf.Kunde IN FRAME F-Main
   2 6                                                                  */
/* SETTINGS FOR TOGGLE-BOX V_BelegKopf.offen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX V_BelegKopf.ReverseInvoice IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN V_BelegKopf.Sachbearbeiter IN FRAME F-Main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN V_BelegKopf.SBM_ProfitCenter_Obj IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR IMAGE sDocInfo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR IMAGE sNoteInfo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR IMAGE sRecordState IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR IMAGE sTextInfo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN V_BelegKopf.uAngebot IN FRAME F-Main
   2 6                                                                  */
/* SETTINGS FOR FILL-IN V_BelegKopf.uAngebotsversion IN FRAME F-Main
   2 6                                                                  */
/* SETTINGS FOR FILL-IN V_Bele_PreConfigVariant_Obj_Info IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN V_Bele_SBM_ProfitCenter_Obj_Info IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN V_BelegKopf_AuftragsArt_Info IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN V_BelegKopf_BelegDatum_Info IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN V_BelegKopf_Sachbearbeiter_Info IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN V_BelegKopf_Wiedervorlage_Info IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN V_BelegKopf.VBM_PreConfigVariant_Obj IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */

/* _MULTI-LAYOUT-RUN-TIME-ADJUSTMENTS */

/* LAYOUT-NAME: "Kurzinfo"
   LAYOUT-TYPE: GUI
   EXPRESSION:  
   COMMENT:     
                                                                        */
RUN set-attribute-list ('Layout-Options="Master Layout,Kurzinfo"':U).

/* END-OF-LAYOUT-DEFINITIONS */

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

&Scoped-define SELF-NAME V_BelegKopf.AuftragsArt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL V_BelegKopf.AuftragsArt V-table-Win
ON leave OF V_BelegKopf.AuftragsArt IN FRAME F-Main /* Auftragsart */
do:
  {adm/template/incl/dt_uit00.if
     &UserExitName = "ON_LEAVE_OF_V_BelegKopf_AuftragsArt"}

  {adm/template/incl/dt_viw03.if}

  {adm/template/incl/dt_uit01.if
     &UserExitName = "ON_LEAVE_OF_V_BelegKopf_AuftragsArt"}
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME V_BelegKopf.BelegDatum
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL V_BelegKopf.BelegDatum V-table-Win
ON leave OF V_BelegKopf.BelegDatum IN FRAME F-Main /* Belegdatum */
do:
  {adm/template/incl/dt_uit00.if
     &UserExitName = "ON_LEAVE_OF_V_BelegKopf_BelegDatum"}

  {adm/template/incl/dt_viw03.if}

  {adm/template/incl/dt_uit01.if
     &UserExitName = "ON_LEAVE_OF_V_BelegKopf_BelegDatum"}
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnuFreigabe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnuFreigabe V-table-Win
ON CHOOSE OF btnuFreigabe IN FRAME F-Main /* Freigabe */
DO:
  /* --> UMO#CA2016-03-001 PWa Gutschriftsverfahren */

  {adm/template/incl/dt_uit00.if
     &UserExitName = "ON_CHOOSE_OF_btnuFreigabe"}

  &IF LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN
    run new-state ('uBelegfreigabe,record-target':U).
  &ENDIF
  /* <-- UMO#CA2016-03-001 PWa Gutschriftsverfahren */

  {adm/template/incl/dt_uit01.if
     &UserExitName = "ON_CHOOSE_OF_btnuFreigabe"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME V_BelegKopf.Sachbearbeiter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL V_BelegKopf.Sachbearbeiter V-table-Win
ON LEAVE OF V_BelegKopf.Sachbearbeiter IN FRAME F-Main /* Sachbearbeiter */
do:
  {adm/template/incl/dt_uit00.if
     &UserExitName = "ON_LEAVE_OF_V_BelegKopf_Sachbearbeiter"}

  {adm/template/incl/dt_viw03.if}

  {adm/template/incl/dt_uit01.if
     &UserExitName = "ON_LEAVE_OF_V_BelegKopf_Sachbearbeiter"}
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME V_BelegKopf.uAngebot
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL V_BelegKopf.uAngebot V-table-Win
ON leave OF V_BelegKopf.uAngebot IN FRAME F-Main /* Angebot */
do:
  {adm/template/incl/dt_uit00.if
     &UserExitName = "ON_LEAVE_OF_V_BelegKopf_uAngebot"}

  {adm/template/incl/dt_viw03.if}

  {adm/template/incl/dt_uit01.if
     &UserExitName = "ON_LEAVE_OF_V_BelegKopf_uAngebot"}
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME V_BelegKopf.Wiedervorlage
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL V_BelegKopf.Wiedervorlage V-table-Win
ON leave OF V_BelegKopf.Wiedervorlage IN FRAME F-Main /* Wiedervorlage */
do:
  {adm/template/incl/dt_uit00.if
     &UserExitName = "ON_LEAVE_OF_V_BelegKopf_Wiedervorlage"}

  {adm/template/incl/dt_viw03.if}

  {adm/template/incl/dt_uit01.if
     &UserExitName = "ON_LEAVE_OF_V_BelegKopf_Wiedervorlage"}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _check-record V-table-Win 
PROCEDURE _check-record :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  pcFunction   Art der Bearbeitung
  Notes:
------------------------------------------------------------------------------*/

define input parameter pcFunction as character no-undo.


if   (    pcFunction  = 'delete':U
      and not pa-fields-enabled)
  or (    pcFunction = 'update':U
      and not adm-new-record
      and glZustandPruefen = yes) then
do:

  /* Check and display the state of the record only once                      */

  glZustandPruefen = no.

  /* Sperrgrundprüfung Beleg */

  if available V_BelegKopf then
    basis.buro.cls.BBCWorkflowSvc:prpoInstance:showLockStatus
      (V_BelegKopf.V_BelegKopf_Obj,
       cBereich).

  /* Zustandsprüfung Kunden */

  if    available V_BelegKopf
    and available S_Kunde then

    basis.buro.cls.BBCWorkflowSvc:prpoInstance:showLockStatus
      (S_Kunde.S_Kunde_Obj,
       cBereich).

  /* Zustandsprüfung Interessent */

  &IF LOOKUP("VC","{&PA-MODULE}") > 0 &THEN

    if    available V_BelegKopf
      and available VC_Interessent then

      basis.buro.cls.BBCWorkflowSvc:prpoInstance:showLockStatus
        (VC_Interessent.VC_Interessent_Obj,
         cBereich).

  &ENDIF

end.

return.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Abrufsteuerung V-table-Win 
PROCEDURE Abrufsteuerung :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Aufruf des Programms zur Erfassung der Steuerungsinformationen zum         */
/* Abrufauftrag.                                                              */
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
/* cTemp            Hilfsvariable für Aufruf Dialogbox                        */
/* iAbrufverfahren  Merker für altes Abrufverfahren                           */
/* lFAB             Merker für Feinabrufe                                     */
/* lJiT             Merker für JiT-Abrufe                                     */
/*----------------------------------------------------------------------------*/

define variable cTemp           as character no-undo.
define variable iAbrufverfahren as integer   no-undo.
define variable lFAB            as logical   no-undo.
define variable lJiT            as logical   no-undo.

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

Main:
do on error undo Main, return error:

  /* Pflegeprogramm für die Abrufe schließen */

  run set-link-attribute in adm-broker-hdl (this-procedure,
                                            'record-target':U,
                                            'Abrufsteuerung=yes':U).

  if    available V_BelegKopf
    and V_BelegKopf.Belegart = 'VUA':U then
  do:

    /* Die wesentlichen alten Daten zwischenspeichern, um dann bei einer      */
    /* wesentlichen Änderung ein row-awailable schicken zu können, damit      */
    /* die dazu passenden Programme für die Abrufe geöffnet werden können.    */
    /* LAB muss man nicht überwachen, da diese immer erforderlich sind.       */

    assign
      iAbrufverfahren = V_BelegKopf.Abrufverfahren
      lFAB            = V_BelegKopf.FAB
      lJiT            = V_BelegKopf.JiT
      .

    run vert/proc/v_pbel24.w (input-output cTemp,
                                           rowid(V_BelegKopf)).

    if   iAbrufverfahren <> V_BelegKopf.Abrufverfahren
      or lFAB            <> V_BelegKopf.FAB
      or lJiT            <> V_BelegKopf.JiT then

      run notify ('row-available,record-target':U).

  end. /* if available V_BelegKopf ... */

  run set-link-attribute in adm-broker-hdl (this-procedure,
                                            'record-target':U,
                                            'Abrufsteuerung=no':U).

end. /* Main */

return.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-ParameterDialog V-table-Win 
PROCEDURE adm-ParameterDialog :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Opens the parameter dialog (used in the menu)                              */
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
/* lCanceled    parameter dialog has been left without saving                 */
/*----------------------------------------------------------------------------*/

define variable lLiefertermin as   logical             no-undo.
define variable lWunschtermin as   logical             no-undo.
define variable lLieferBed    as   logical             no-undo.
define variable lFracht       as   logical             no-undo.
define variable lLanguage     as   logical             no-undo.
define variable cstring       as   char                no-undo.
define variable lMRPRelease   as   logical             no-undo.
define variable lCanceled     as   logical             no-undo.
define variable cLanguage     like V_BelegKopf.Sprache no-undo.

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* the document must not be modified if it is archived */

if V_BelegKopf.offen = no then

  adm.method.cls.DMCMessageSvc:prpoInstance:showError
    ('dmtio00027':U).

cLanguage = V_BelegKopf.Sprache.

run vert/proc/v_pbel22.w (input-output cString,
                                       rowid(V_BelegKopf),
                                       V_BelegKopf.Belegart,
                                       V_BelegKopf.ReferenzNr,
                                output lLiefertermin,
                                output lWunschtermin,
                                output lLieferBed,
                                output lFracht,
                                output lLanguage,
                                output lMRPRelease,
                                output lCanceled).

/* If the Cancel-Button was pressed, then do not continue.                    */
/* 'ADM-ERROR' is attended in dm_tbr00.lib.                                   */

if lCanceled = yes then

  return 'ADM-ERROR':U.

/* can-find notwendig, wenn noch keine Position erfasst ist,                  */
/* aber der Container für die Positionserfassung schon vorhanden ist          */

if can-find (first V_BelegPos
               where V_BelegPos.Firma      = V_BelegKopf.Firma
                 and V_BelegPos.Belegart   = V_BelegKopf.Belegart
                 and V_BelegPos.ReferenzNr = V_BelegKopf.ReferenzNr) then
do:

  if lLiefertermin = yes then
  do:

    run set-link-attribute in adm-broker-hdl (this-procedure,
                                              'record-target':U,
                                              'Liefertermin=yes':U).

    run new-state ('refresh,record-target':U).

  end.

  if lWunschtermin = yes then
  do:

    run set-link-attribute in adm-broker-hdl (this-procedure,
                                              'record-target':U,
                                              'Wunschtermin=yes':U).

    run new-state ('refresh,record-target':U).

  end.

  if lMRPRelease = yes then

    run new-state ('refresh,record-target':U).

  if lLieferBed = yes then

    run set-link-attribute in adm-broker-hdl (this-procedure,
                                              'record-target':U,
                                              'LieferBed=yes':U).

  if lFracht = yes then

    run set-link-attribute in adm-broker-hdl (this-procedure,
                                              'record-target':U,
                                              'Fracht=yes':U).

end. /* if can-find (first V_BelegPos */

if lLanguage = yes then

  run set-link-attribute in adm-broker-hdl (this-procedure,
                                            'record-target':U,
                                            'TextComment=yes':U).

if cLanguage <> V_BelegKopf.Sprache then

  run set-link-attribute in adm-broker-hdl (this-procedure,
                                            'record-target':U,
                                            'DescSurcharges=yes':U).

&IF lookup("V_PKF":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  &IF lookup("MU":U,"{&PA-MODULE}":U) > 0 &THEN
    /* --> UMO#WH2015-07-010 cpl Strecke code checked <-- */
    if    V_BelegKopf.Konfiguration = yes
      and V_BelegKopf.Strecke       = no then

      run set-attribute-list ('KonfigProduct=yes':U).

    else

      run set-attribute-list ('KonfigProduct=no':U).

  &ENDIF
&ENDIF

&IF "{&pa_S_IncoTerm}":U = "1":U &THEN

  if can-do ('A,VUA':U, V_BelegKopf.Belegart) then
  do:

    if V_BelegKopf.Bestimmungsort >= 2 then

      run set-attribute-list ('Bestimmungsorte=yes':U).

    else

      run set-attribute-list ('Bestimmungsorte=no':U).

  end.

&ENDIF

run dispatch('display-protected-fields':U).

if return-value <> 'ADM-ERROR':U then
do:


  run notify ('display-protected-fields,record-target':U).

end.


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

{adm/template/incl/row-list.i "V_BelegKopf"}

/* Get the record ROWID's from the RECORD-SOURCE.                             */

{adm/template/incl/row-get.i}

/* FIND each record specified by the RECORD-SOURCE.                           */

{adm/template/incl/row-find.i "V_BelegKopf"}

/* Process the newly available records (i.e. display fields, open queries,    */
/* and/or pass records on to any RECORD-TARGETS).                             */

{adm/template/incl/row-end.i}

end procedure. /* adm-row-available */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Adopting V-table-Win 
PROCEDURE Adopting :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Manages the adopting with the new adopting services                        */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* ipcTargetDocType   document type of the new document                       */
/*                                                                            */
/* Examples ------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/*----------------------------------------------------------------------------*/

define input parameter ipcTargetDocType as character no-undo.

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

define variable lCompleteAdopting   as logical                                          no-undo.
define variable lProxy1             as logical                                          no-undo.
define variable lAdoptTextLines     as logical                                          no-undo.
define variable lNewPricing         as logical                                          no-undo.
define variable lAdoptSalesAgents   as logical                                          no-undo.
define variable cOIDOriginDocHeader as character                                        no-undo.
define variable cOIDDocHeaderNew    as character                                        no-undo.
define variable oAdoptingSvo        as class vert.base.cls.VBCAdoptingSalesDocumentsSvo no-undo.
define variable cSourceDocType      as character                                        no-undo.
define variable lUseTTAdress        as logical                                          no-undo.
define variable lAdoptAdresses      as logical                                          no-undo.
define variable lShowGeneralError   as logical init yes                                 no-undo.
define variable lConfiguredPart     as logical                                          no-undo.
define variable cSperrBereichKd     as character                                        no-undo.

 /* --> UMO#WH2015-07-010 cpl Streckenmix im Vertriebsbeleg */
 /* Versandarten beibehalten oder initialisieren */
 &IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
 define variable luKeepShippingType as logical no-undo.
 &ENDIF
 /* <-- UMO#WH2015-07-010 cpl Streckenmix im Vertriebsbeleg */

/* Buffers -------------------------------------------------------------------*/

define buffer bV_BelegKopf-Origin         for V_BelegKopf.
define buffer bV_BelegKopf-New            for V_BelegKopf.
define buffer bS_Kunde-Source             for S_Kunde.
define buffer bS_Kunde-Target             for S_Kunde.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* do-Block for catching errors */

do
on error undo, throw:

  /* clear the temp-tables for the new datas because in some special error    */
  /* cases the TT won't be cleared and after this copying is impossible       */

  run ClearAdoptingTempTables.

  /* create the class for adopting with the correct target document type */

  oAdoptingSvo = new vert.base.cls.VBCAdoptingSalesDocumentsSvo(ipcTargetDocType).

  &IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  if gluQuoteVersioning = yes then
  do:

    {adm/incl/d__par00.if
      &ParameterListe = "cTmp"
      &Parameter      = "&uQuoteVersioning"
      &Variable1      = "yes"
    }

    {adm/incl/d__par00.if
      &ParameterListe = "cTmp"
      &Parameter      = "uQuoteVersioningSourceDocOID"
      &Variable1      = "if available V_BelegKopf then
                           V_BelegKopf.V_BelegKopf_Obj
                         else
                           ?"
    }

  end. /* if gluQuoteVersioning = yes */
  else
  do:

    {adm/incl/d__par00.if
      &ParameterListe = "cTmp"
      &Parameter      = "&uQuoteVersioning"
      &Variable1      = "no"
    }

    {adm/incl/d__par00.if
      &ParameterListe = "cTmp"
      &Parameter      = "uQuoteVersioningSourceDocOID"
      &Variable1      = "'?':U"
    }

  end. /* else */
  &ENDIF

  /* if this is a complete adopting the process will be managed in v_pbel10.w */

  run vert/proc/v_pbel10.w (input-output cTmp,
                                         oAdoptingSvo:cGetOriginDocTypes(), /* doc types that can be adopted */
                                         ipcTargetDocType,                  /* target doc type               */
                                         lSchlussrechnung,
                                         yes,
                                  output lCompleteAdopting,
                                  output lProxy1,
                                  output cSatzId,                           /* needed for the old proceeding */
                                  output cOIDOriginDocHeader,
                                  output cSourceDocType) no-error.

  if (   cOIDOriginDocHeader = '':U
      or cOIDOriginDocHeader = ?) then

    return 'Abbruch':U.

  /* now the source document with it's OID and doc type is defined            */
  /* and the service object can be completed.                                 */

  assign
    oAdoptingSvo:prpcOIDSourceDocument = cOIDOriginDocHeader
    glZuschlag_sperren                 = lCompleteAdopting   /* if adopt completely then the dialog for the surcharges should not appear */
    .

  oAdoptingSvo:SetOriginDocType(cSourceDocType).

  /* first load the source document in the adoption service object */

  oAdoptingSvo:InitSourceDoc().

  /* now clear the temp-table because it should only contain 1 origin-header */

  empty temp-table ttVBT_DocumentHeaders-NEW.

  /* copy the details of the origin document header to the temp-table         */
  /* as initial values for v_paa_02.w                                         */

  create ttVBT_DocumentHeaders-NEW.

  find bV_BelegKopf-Origin
    where bV_BelegKopf-Origin.V_BelegKopf_Obj = cOIDOriginDocHeader
  no-lock.

  buffer-copy bV_BelegKopf-Origin
  except
    Aenderungdatum
    AenderungZeit
    Aenderungbenutzer
    Anlagedatum
    Anlagezeit
    Anlagebenutzer
  to ttVBT_DocumentHeaders-NEW.

  lConfiguredPart = can-find(first V_BelegPos
                               where V_BelegPos.Firma       = bV_BelegKopf-Origin.Firma
                                 and V_BelegPos.BelegArt    = bV_BelegKopf-Origin.Belegart
                                 and V_BelegPos.ReferenzNr  = bV_BelegKopf-Origin.ReferenzNr
                                 and (   can-find(S_Artikel
                                                    where S_Artikel.Firma      = {firma/sartikel.fir bV_BelegKopf-Origin.Firma}
                                                      and S_Artikel.Artikel    = V_BelegPos.Artikel
                                                      and S_Artikel.ArtikelArt = {&pa_S_PT_ConfiguredPart})
                                      or can-find(S_Artikel
                                                    where S_Artikel.Firma      = {firma/sartikel.fir bV_BelegKopf-Origin.Firma}
                                                      and S_Artikel.Artikel    = V_BelegPos.Artikel
                                                      and S_Artikel.ArtikelArt = {&pa_S_PT_VariantPart}))).

  /* now show the dialog for the new adopting parameters asking the user    */
  /* for the new details of the header, using a copy of the origin document */

  run vert/proc/v__bel31.w (             cSourceDocType,
                                         lConfiguredPart,
                                         ?,                                     /* prospect if called from CRM */
                                         gluQuoteVersioning,
                                         adm.config.cls.DCCAppConfigSvc:prpoInstance:lParameterValue('UCI_QuoteVersioningAdoptParamDialog':U),
                                  output lNewPricing,
                                  output lAdoptTextLines,
                                  output lAdoptSalesAgents,
                                  output lUseTTAdress,
                                  output lAdoptAdresses,
                            input-output table ttVBT_DocumentHeaders-NEW by-reference,

                           /* --> UMO#WH2015-07-010 cpl Streckenmix im Vertriebsbeleg */
                           /* Versandarten beibehalten oder initialisieren */
                           &IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
                           input-output table ttS_Adresse by-reference,
                           output luKeepShippingType).
                           &ELSE
                            input-output table ttS_Adresse by-reference).
                           &ENDIF
                           /* <-- UMO#WH2015-07-010 cpl Streckenmix im Vertriebsbeleg */

  /* if the adopting has been aborted */

  if return-value = 'Abbruch':U then
  do:

    /* clear the temp-tables for the new datas */

    run ClearAdoptingTempTables.
    return.

  end.

  /* Determine the workflow area to the check the status of the customer who  */
  /* should be used in the target document.                                   */

  cSperrBereichKd = (if    ttVBT_DocumentHeaders-NEW.Belegart        = 'R':U
                       and ttVBT_DocumentHeaders-NEW.Schlussrechnung = no
                       and not can-do('L,G':U,bV_BelegKopf-Origin.Belegart) then
                       'VUL':U
                     else
                       vert.base.cls.VBCSalesDocSvc:prpoInstance:cGetWorkflowArea
                         (ttVBT_DocumentHeaders-NEW.Belegart,
                          ttVBT_DocumentHeaders-NEW.Schlussrechnung)).

  find bS_Kunde-Source
    where bS_Kunde-Source.Firma = {firma/s_kunde.fir pa-firma}
      and bS_Kunde-Source.Kunde = bV_BelegKopf-Origin.Kunde
    no-lock.

  oAdoptingSvo:prplDifferentCustomer = (   bV_BelegKopf-Origin.Kunde    <> ttVBT_DocumentHeaders-NEW.Kunde
                                        &IF lookup ("VC","{&PA-MODULE}") > 0 &THEN
                                        or bV_BelegKopf-Origin.Interessent <>  ttVBT_DocumentHeaders-NEW.Interessent
                                        or (    bV_BelegKopf-Origin.Interessent = 0
                                            and        bS_Kunde-Source.AdressNr = 0 )
                                        &ELSE
                                        or bS_Kunde-Source.AdressNr = 0 /* if VC is not licensed: for the once only customer everything must be set like for a foreign customer */
                                        &ENDIF
                                        ).

  /* The status check must always be done for the actual selected customer of */
  /* the target document.                                                     */

  find bS_Kunde-Target
    where bS_Kunde-Target.Firma = {firma/s_kunde.fir pa-firma}
      and bS_Kunde-Target.Kunde = ttVBT_DocumentHeaders-NEW.Kunde
    no-lock no-error.

  /* Check the status of the customer who is set in the target document.      */

  if available bS_Kunde-Target then
  do:

    if basis.buro.cls.BBCWorkflowSvc:prpoInstance:lHasLockStatusWarningOrLock
         (bS_Kunde-Target.S_Kunde_Obj,
          cSperrBereichKd) then
    do:

      basis.buro.cls.BBCWorkflowSvc:prpoInstance:showLockStatus
        (bS_Kunde-Target.S_Kunde_Obj,
         cSperrBereichKd) no-error.

      if error-status:error then
      do:

        run ClearAdoptingTempTables.
        return.

      end. /* if error-status:error */

    end. /* if lHasLockStatusWarningOrLock */

  end. /* if available bS_Kunde-Target */

  /* if a customer address has been added in the dialog v__bel31.w then this  */
  /* address must be added as header address in the target document           */

  if    lUseTTAdress = yes
    and can-find(first ttS_Adresse) then

    oAdoptingSvo:AddCustomerAddress(table ttS_Adresse by-reference).

  /* set the the results of this dialog as properties for the adopting service object */

  assign
    oAdoptingSvo:prplAdoptText         = lAdoptTextLines
    oAdoptingSvo:prplAgentsOfOriginDoc = lAdoptSalesAgents
    oAdoptingSvo:prplNewPricing        = lNewPricing
    oAdoptingSvo:prplAdoptAdresses     = lAdoptAdresses

    /* --> UMO#WH2015-07-010 cpl Streckenmix im Vertriebsbeleg */
    /* Versandarten beibehalten oder initialisieren */
    &IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
    oAdoptingSvo:prpluKeepShippingType = luKeepShippingType
    &ENDIF
    /* <-- UMO#WH2015-07-010 cpl Streckenmix im Vertriebsbeleg */
    &IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
    oAdoptingSvo:prpluQuoteVersioning  = gluQuoteVersioning
    &ENDIF
    .

  /* ttVBT_DocumentHeaders-NEW now contains the new details of the header */

  /* now differ betwenn a complete adoption and an adoption where the user    */
  /* defines the single lines he want to be adopted                           */

  if lCompleteAdopting = no then
  do on error undo, throw:

    /* show the browser for choosing the lines */

    run vert/proc/v_pbel20.w (input-output cTmp,                               /* pa-container-in-update     */
                                           cSourceDocType,                     /* Belegart                   */
                                           ipcTargetDocType,                   /* Zielbelegart               */
                                           cSatzId,                            /* SatzId                     */
                                           ttVBT_DocumentHeaders-NEW.Kunde,    /* Kunde                      */
                                           0,                                  /* Kontakt                    */
                                           ?,                                  /* KOLager                    */
                                           no,                                 /* VFP                        */
                                           '':U,                               /* SatzIDRechnung             */
                                           yes,                                /* new proceeding             */
                                    output cSatzId_neu,                        /* SatzID_neu                 */
                                    output glZuschlag_sperren,                 /* Zuschlag_sperren           */
                              input-output table ttVBT_DocumentLines-NEW bind, /* the lines for adopting     */
                              input-output table ttVBT_SalesBOM-NEW bind).     /* the sales BOM for adopting */

    /* v_pbel20 set output cSatzID_neu = "cancel" by choosing button "Cancel" */

    if   cSatzId_neu = 'Cancel':U then
    do:

      /* clear the temp-tables for the new datas */

      run ClearAdoptingTempTables.
      return.

    end.

    /* Execute the adoption process */

    cOIDDocHeaderNew = oAdoptingSvo:cAdoptPerLine(table ttVBT_DocumentHeaders-NEW bind,
                                                  table ttVBT_DocumentLines-NEW bind,
                                                  table ttVBT_SalesBOM-NEW bind).

  end. /* if lCompleteAdopting = no */

  else
  do:

    /* execute the complete adoption */

    cOIDDocHeaderNew = oAdoptingSvo:cAdoptComplete(table ttVBT_DocumentHeaders-NEW by-reference).

  end. /* else do: if lCompleteAdopting = no */

  /* wenn es keine gültige OID ist, dann passiert nix */

  if adm.method.cls.DMCSessionSvc:cOwningTable(cOIDDocHeaderNew) = 'V_BelegKopf':U then

    find bV_BelegKopf-New
      where bV_BelegKopf-New.V_BelegKopf_Obj = cOIDDocHeaderNew
    no-lock.

  else
  do:

    lShowGeneralError = no.
    adm.method.cls.DMCMessageSvc:prpoInstance:showError
      ('s_bel00002':U).

  end. /* if adm.method.cls.DMCSessionSvc:cOwningTable(cOIDDocHeaderNew) = 'V_BelegKopf':U then... else */

  if available bV_BelegKopf-New then
  do:

    assign
      cSatzId_neu  = string(rowid(bV_BelegKopf-New))
      glOpenAdress = not lUseTTAdress
      .

    run Beleg_uebernommen.

  end. /* if available bV_BelegKopf-New then */
  
  /* if an error occurs show it */

  catch oError as Progress.Lang.Error:

    /* only show the Progress erros because all other errors has just been    */
    /* shown and only "display" would show them twice                         */

    (new adm.method.cls.DMCErrorFrw(oError)):displayProgressErrorsOnly().

    if lShowGeneralError then

      adm.method.cls.DMCMessageSvc:prpoInstance:showError
        ('s_bel00002':U).

    run ClearAdoptingTempTables.

  end catch.

end. /* do block for catching error */

/* the adopting process is finished now, so empty all TTs */

run ClearAdoptingTempTables.

end procedure. /* Adopting */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AdoptToBlanketOrder V-table-Win 
PROCEDURE AdoptToBlanketOrder :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Adopting an order in a Blanket Order                                       */
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

define variable lKomplett as logical no-undo.
define variable lVFP      as logical no-undo.

/* Buffers -------------------------------------------------------------------*/

define buffer Buf_V_BelegKopf for V_BelegKopf.
define buffer bS_Kunde        for S_Kunde.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

&IF LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN
if available V_BelegKopf then
do:
 /* set the Customer ID for the adopting program */
  {adm/incl/d__par00.if
    &Parameterliste = "cTmp"
    &Parameter      = "Kunde"
    &Variable1      = "V_BelegKopf.Kunde"
  }. 
end.                                           
&ENDIF

/* Auswahl des zu übernehmenden Belegkopfes */

run vert/proc/v_pbel10.w (input-output cTmp,
                                       &IF LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN
                                       'AVUR':U,
                                       &ELSE /* original */
                                       'A':U,
                                       &ENDIF
                                       'VUR':U,
                                       lSchlussrechnung,
                                       no,
                                output lKomplett,
                                output lVFP,
                                output cSatzId,
                                output gcOIDSourceDoc,
                                output gcSourceDocType).

if   cSatzId = ?
  or cSatzId = '':U then

  return 'Abbruch':U.

else
do:

  if lKomplett = yes then
  do:

    assign
      glZuschlag_sperren = yes
      cSatzId_neu        = cSatzId
      .

    run Beleg_uebernommen.

  end.
  else
  do:

    find Buf_V_BelegKopf
      where rowid(Buf_V_BelegKopf) = to-rowid(cSatzId)
      no-lock.

    iKunde = Buf_V_BelegKopf.Kunde.

    /* Check the blocking state of the customer here, because this status     */
    /* wasn't checked in v_bbel10.w for adopted documents with type 'A'.      */

    find bS_Kunde
      where bS_Kunde.Firma = {firma/s_kunde.fir pa-firma}
        and bS_Kunde.Kunde = iKunde
      no-lock.

    if basis.buro.cls.BBCWorkflowSvc:prpoInstance:lHasLockStatusWarningOrLock
         (bS_Kunde.S_Kunde_Obj,
          'VUR':U) then
    do:

      /* Show status of the current customer.                                 */

      basis.buro.cls.BBCWorkflowSvc:prpoInstance:showLockStatus
        (bS_Kunde.S_Kunde_Obj,
         'VUR':U) no-error.

      if error-status:error then
        return 'Abbruch':U.

    end.

    /* Positionsbearbeitung */

    run vert/proc/v_pbel20.w (input-output cTmp,
                                           'A':U,
                                           'VUR':U,
                                           cSatzId,
                                           iKunde,
                                           0,
                                           ?,
                                           no,
                                           '':U,
                                           no,
                                    output cSatzId_neu,
                                    output glZuschlag_sperren,
                              input-output table ttVBT_DocumentLines-NEW bind,
                              input-output table ttVBT_SalesBOM-NEW bind).

    if cSatzId_neu   = ?
      or cSatzId_neu = '':U then

      return 'Abbruch':U.

    run Beleg_uebernommen.

  end. /* keine Komplettübernahme */

end. /* Beleg ausgewählt */

end procedure. /* AdoptToBlanketOrder */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AdoptToCredit V-table-Win 
PROCEDURE AdoptToCredit :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Adopting an archived invoice to a credit                                   */
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

define variable lKomplett as logical no-undo.
define variable lVFP      as logical no-undo.

/* Buffers -------------------------------------------------------------------*/

define buffer Buf_V_BelegKopf   for V_BelegKopf.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

run vert/proc/v_pbel10.w (input-output cTmp,
                                       'R':U,
                                       'G':U,
                                       lSchlussrechnung,
                                       no,
                                output lKomplett,
                                output lVFP,
                                output cSatzId,
                                output gcOIDSourceDoc,
                                output gcSourceDocType).

if   cSatzId = ?
  or cSatzId = '':U then

  return 'Abbruch':U.

if lSchlussrechnung = no then
do:

  if lKomplett = yes then

    assign
      glZuschlag_sperren = yes
      cSatzId_neu        = cSatzId
      .

  else
  do:

    find Buf_V_BelegKopf
      where rowid(Buf_V_BelegKopf) = to-rowid(cSatzId)
      no-lock.

    iKunde = Buf_V_BelegKopf.Kunde.

    /* Positionsbearbeitung */

    run vert/proc/v_pbel20.w (input-output cTmp,
                                           Buf_V_BelegKopf.Belegart,
                                           cBelegart,
                                           cSatzId,
                                           iKunde,
                                           0,
                                           ?,
                                           no,
                                           '':U,
                                           no,              /* new proceeding */
                                    output cSatzId_neu,
                                    output glZuschlag_sperren,
                              input-output table ttVBT_DocumentLines-NEW bind,
                              input-output table ttVBT_SalesBOM-NEW bind).

    if   cSatzId_neu = ?
      or cSatzId_neu = '':U then

      return 'Abbruch':U.

  end. /* else if lKomplett = yes */

end. /* kein Schlussrechnungsbeleg */

else

  cSatzId_neu = cSatzId.

run Beleg_uebernommen.

end procedure. /* AdoptToCredit */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AdoptToDemoShippingDocument V-table-Win 
PROCEDURE AdoptToDemoShippingDocument :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Adopting a quote or an order to ta demo shipping document                  */
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

define variable lKomplett as logical no-undo.
define variable lVFP      as logical no-undo.
/* --> UMO#CM2017-05-001 tri Versandstückliste */
&IF LOOKUP("U_CM":U,"{&PA-OPTIONEN}":U) > 0 &THEN
define variable luBelegSuche      as logical   no-undo.
define variable cuOptions         as character no-undo.
define variable iuSource          as integer   no-undo.
&ENDIF
/* <-- UMO#CM2017-05-001 tri Versandstückliste */

/* Buffers -------------------------------------------------------------------*/

define buffer Buf_V_BelegKopf for V_BelegKopf.
/* --> UMO#CM2017-05-001 tri Versandstückliste */
&IF LOOKUP("U_CM":U,"{&PA-OPTIONEN}":U) > 0 &THEN
define buffer buV_BelegPos  for V_BelegPos.
define buffer buV_BelegKopf for V_BelegKopf.
&ENDIF
/* <-- UMO#CM2017-05-001 tri Versandstückliste */

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* --> UMO#CM2017-05-001 tri Versandstückliste */
&IF LOOKUP("U_CM":U,"{&PA-OPTIONEN}":U) > 0 &THEN
if gluVersand = yes then
do:
  {adm/incl/d__par00.if
    &ParameterListe = "cTmp"
    &Parameter      = "&ulVersand"
    &Variable1      = "yes"
  }
end. /* if gluVersand = yes */
else
do:
  {adm/incl/d__par00.if
    &ParameterListe = "cTmp"
    &Parameter      = "&ulVersand"
    &Variable1      = "no"
  }
end. /* else */

if gluVersand = yes then
do:

  {adm/incl/d__par00.if
    &ParameterListe = "cTmp"
    &Parameter      = "ulNewDocument"
    &Variable1      = "gluNewDocument"
  }

  if available V_BelegKopf
    and not gluNewDocument then
  do:

    {adm/incl/d__par00.if
      &ParameterListe = "cTmp"
      &Parameter      = "ucV_BelegKopf_SatzID"
      &Variable1      = "string(rowid(V_BelegKopf))"
    }

  end. /* if available V_BelegKopf */
  else do:

    {adm/incl/d__par00.if
      &ParameterListe = "cTmp"
      &Parameter      = "ucV_BelegKopf_SatzID"
      &Variable1      = "'':U"
    }

  end. /* else */

end. /* if gluVersand = yes */
else do:

  {adm/incl/d__par00.if
    &ParameterListe = "cTmp"
    &Parameter      = "ulNewDocument"
    &Variable1      = "yes"
  }

  {adm/incl/d__par00.if
    &ParameterListe = "cTmp"
    &Parameter      = "ucV_BelegKopf_SatzID"
    &Variable1      = "'':U"
  }

end. /* else */

if not gluVersand                    /* normale Belegübernahme */
  or (gluVersand and gluNewDocument) /* Neuanlage Versandstückliste */
then luBelegSuche = yes.
else do:

  find first buV_BelegPos
    where buV_BelegPos.Firma       = V_BelegKopf.Firma
      and buV_BelegPos.Belegart    = V_BelegKopf.Belegart
      and buV_BelegPos.ReferenzNr  = V_BelegKopf.ReferenzNr
      and buV_BelegPos.uCM_Versand = yes
    no-lock no-error.

  if available buV_BelegPos then
    find first buV_BelegKopf
      where buV_BelegKopf.Firma      = buV_BelegPos.Firma
        and buV_BelegKopf.Belegart   = buV_BelegPos.Herk_Belegart
        and buV_BelegKopf.ReferenzNr = buV_BelegPos.Herk_ReferenzNr
      no-lock no-error.

  if available buV_BelegKopf then
    assign
      cSatzId      = string(rowid(buV_BelegKopf))
      luBelegSuche = no
      .
  else
    return 'Abbruch':U.

end. /* else */

if luBelegSuche then
do:
&ENDIF
/* <-- UMO#CM2017-05-001 tri Versandstückliste */

run vert/proc/v_pbel10.w (input-output cTmp,
                                       'AUD':U,
                                       'VUD':U,
                                       lSchlussrechnung,
                                       no,
                                output lKomplett,
                                output lVFP,
                                output cSatzId,
                                output gcOIDSourceDoc,
                                output gcSourceDocType).

if   cSatzId = ?
  or cSatzId = '':U then

  return 'Abbruch':U.

/* --> UMO#CM2017-05-001 tri Versandstückliste */
&IF LOOKUP("U_CM":U,"{&PA-OPTIONEN}":U) > 0 &THEN
end. /* if luBelegSuche */

if gluVersand then
do:

  lKomplett = no.

  run branche/vert/proc/uvpshp01.w (output iuSource).

  if not {getwidgetattr last-event function string} = 'go':U then
    return 'Abbruch':U.

  if iuSource = 2 or iuSource = 3 then
  do on error undo, throw:

    giSource = iuSource.

    find Buf_V_BelegKopf
      where rowid(Buf_V_BelegKopf) = to-rowid(cSatzId)
      no-lock.

    assign
      gcuV_BelegKopf_Obj_Source = Buf_V_BelegKopf.V_BelegKopf_Obj
      gcuV_BelegKopf_Obj_Target = if gluNewDocument then
                                    '':U
                                  else
                                    V_BelegKopf.V_BelegKopf_Obj
      .


    assign
      cuOptions = adm.method.cls.DMCParameterStringSvc:cWriteValue
                    (cuOptions,
                     'Runmode':U,
                     'Update':U)
      cuOptions = adm.method.cls.DMCParameterStringSvc:cWriteValue
                    (cuOptions,
                     'Link1':U,
                     'yes':U)
      cuOptions = adm.method.cls.DMCParameterStringSvc:cWriteValue
                    (cuOptions,
                     'LinkType1':U,
                     'record':U)

      cuOptions = adm.method.cls.DMCParameterStringSvc:cWriteValue
                    (cuOptions,
                     'LinkSource1':U,
                     this-procedure)
      .

    run pa_UISvcStartInstanceByName
      ('uvpshp00.w':U,
       ctmp,
       '':U,
       cuOptions).

    finally:

      assign
        gcuV_BelegKopf_Obj_Source = '':U
        gcuV_BelegKopf_Obj_Target = '':U
        .

    end finally.

  end. /* if iuSource = 2 */

end. /* if gluVersand */
&ENDIF
/* <-- UMO#CM2017-05-001 tri Versandstückliste */

if lSchlussrechnung = no then
do:

  if lKomplett = yes then
  do:

    assign
      glZuschlag_sperren = yes
      cSatzId_neu        = cSatzId
      .

    run Beleg_uebernommen.

  end.
  else
  do:

    find Buf_V_BelegKopf
      where rowid(Buf_V_BelegKopf) = to-rowid(cSatzId)
      no-lock.

    iKunde = Buf_V_BelegKopf.Kunde.

    /* --> UMO#CM2017-05-001 tri Versandstückliste */
    &IF LOOKUP("U_CM":U,"{&PA-OPTIONEN}":U) > 0 &THEN
    if not gluVersand or iuSource = 1 then
    do:
    &ENDIF
    /* <-- UMO#CM2017-05-001 tri Versandstückliste */

    /* Positionsbearbeitung */

    run vert/proc/v_pbel20.w (input-output cTmp,
                                           Buf_V_BelegKopf.Belegart,
                                           cBelegart,
                                           cSatzId,
                                           iKunde,
                                           Buf_V_BelegKopf.Interessent,
                                           ?,
                                           no,
                                           '':U,
                                           no,              /* new proceeding */
                                    output cSatzId_neu,
                                    output glZuschlag_sperren,
                              input-output table ttVBT_DocumentLines-NEW bind,
                              input-output table ttVBT_SalesBOM-NEW bind).

    if   cSatzId_neu = ?
      or cSatzId_neu = '':U then

      return 'Abbruch':U.

    assign
      glZuschlag_sperren = yes
      .

    /* --> UMO#CM2017-05-001 tri Versandstückliste */
    &IF LOOKUP("U_CM":U,"{&PA-OPTIONEN}":U) > 0 &THEN
    end. /* if not gluVersand or iuSource = 1 */
    &ENDIF
    /* <-- UMO#CM2017-05-001 tri Versandstückliste */

    /* --> UMO#CM2017-05-001 tri Versandstückliste */
    &IF LOOKUP("U_CM":U,"{&PA-OPTIONEN}":U) > 0 &THEN
    if not gluVersand
      or (    gluVersand
          and gluNewDocument
          and iuSource = 1) then
    &ENDIF
    /* <-- UMO#CM2017-05-001 tri Versandstückliste */

    run Beleg_uebernommen.

  end.

end. /* kein Schlussrechnungsbeleg */
else
do:

  assign
    glZuschlag_sperren = yes
    cSatzId_neu        = cSatzId
    .

  run Beleg_uebernommen.

end.

/* --> UMO#CM2017-05-001 tri Versandstückliste */
&IF LOOKUP("U_CM":U,"{&PA-OPTIONEN}":U) > 0 &THEN
if gluVersand
  and not gluNewDocument then
  run new-state ('pole-position,record-target':U).
&ENDIF
/* <-- UMO#CM2017-05-001 tri Versandstückliste */

end procedure. /* AdoptToDemoShippingDocument */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AdoptToInvoice V-table-Win 
PROCEDURE AdoptToInvoice :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Adopting several document types to an invoice                              */
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

define variable lKomplett as logical no-undo.
define variable lVFP      as logical no-undo.

/* Buffers -------------------------------------------------------------------*/

define buffer Buf_V_BelegKopf   for V_BelegKopf.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

if lSchlussrechnung = no then

  run vert/proc/v_pbel10.w (input-output cTmp,
                                         'UG':U,
                                         'R':U,
                                         lSchlussrechnung,
                                         no,
                                  output lKomplett,
                                  output lVFP,
                                  output cSatzId,
                                  output gcOIDSourceDoc,
                                  output gcSourceDocType).

else

  run vert/proc/v_pbel10.w (input-output cTmp,
                                         'AdvPmtOrders':U,  /* advance payment orders (U, VUA, VSA) */
                                         'R':U,             /* target doc. type                     */
                                         lSchlussrechnung,
                                         no,
                                  output lKomplett,
                                  output lVFP,
                                  output cSatzId,
                                  output gcOIDSourceDoc,
                                  output gcSourceDocType).

if   cSatzId = ?
  or cSatzId = '':U then

  return 'Abbruch':U.

if lSchlussrechnung = no then
do:

  if lKomplett = yes then
  do:

    assign
      glZuschlag_sperren = yes
      cSatzId_neu        = cSatzId
      .

    run Beleg_uebernommen.

  end.
  else
  do:

    find Buf_V_BelegKopf
      where rowid(Buf_V_BelegKopf) = to-rowid(cSatzId)
      no-lock.

    iKunde = Buf_V_BelegKopf.Kunde.

    /* Positionsbearbeitung */

    run vert/proc/v_pbel20.w (input-output cTmp,
                                           Buf_V_BelegKopf.Belegart,
                                           cBelegart,
                                           cSatzId,
                                           iKunde,
                                           0,
                                           ?,
                                           no,
                                           '':U,
                                           no,              /* new proceeding */
                                    output cSatzId_neu,
                                    output glZuschlag_sperren,
                              input-output table ttVBT_DocumentLines-NEW bind,
                              input-output table ttVBT_SalesBOM-NEW bind).

    if   cSatzId_neu = ?
      or cSatzId_neu = '':U then

      return 'Abbruch':U.

    run Beleg_uebernommen.

  end. /* keine Komplettübernahme */

end. /* if lSchlussrechnung = no */
else
do:

  cSatzId_neu = cSatzId.

  run Beleg_uebernommen.

end.

end procedure. /* AdoptToInvoice */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AdoptToOrder V-table-Win 
PROCEDURE AdoptToOrder :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* adopting a quote to an order or copy an order into another order           */
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

define variable lKomplett as   logical                 no-undo.
define variable lVFP      as   logical                 no-undo.
define variable iContact  like V_BelegKopf.Interessent no-undo.

/* Buffers -------------------------------------------------------------------*/

define buffer Buf_V_BelegKopf   for V_BelegKopf.
define buffer Buf_S_Kunde       for S_Kunde.
&IF lookup ("VC","{&PA-MODULE}") > 0 &THEN
  define buffer bVC_Interessent for VC_Interessent.
&ENDIF

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Auswahl des zu übernehmenden Belegkopfes */

run vert/proc/v_pbel10.w (input-output cTmp,
                                       'AU':U,
                                       'U':U,
                                       lSchlussrechnung,
                                       no,
                                output lKomplett,
                                output lVFP,
                                output cSatzId,
                                output gcOIDSourceDoc,
                                output gcSourceDocType).

if   cSatzId = ?
  or cSatzId = '':U then

  return 'Abbruch':U.

else
do:

  if lKomplett = yes then
  do:

    assign
      glZuschlag_sperren = yes
      cSatzId_neu        = cSatzId
      .

    run Beleg_uebernommen.

  end.
  else
  do:

    find Buf_V_BelegKopf
      where rowid(Buf_V_BelegKopf) = to-rowid(cSatzId)
      no-lock.

    /* unterschiedliche KundenNr */

    if Buf_V_BelegKopf.Kunde <> input frame {&frame-name} V_BelegKopf.Kunde then
    do:

      if   input frame {&frame-name} V_BelegKopf.Kunde = ?
        or input frame {&frame-name} V_BelegKopf.Kunde = 0 then

        assign
          iKunde   = Buf_V_BelegKopf.Kunde
          iContact = Buf_V_BelegKopf.Interessent
          .

      else
      do:

        lOK = no. /* Init: Kunde gemäß Auftrag */

        &IF lookup ("VC","{&PA-MODULE}") > 0 &THEN

          /* Falls Interessent im Angebot mittlerweile dem Kunden entspricht, */
          /* -> Keine Abfrage, sondern automatisch Kunde gemäß Auftrag nehmen */

          if   not Buf_V_BelegKopf.Interessent > 0
            or not can-find(VC_Interessent
                              where VC_Interessent.Firma       = {firma/s_kunde.fir pa-Firma}
                                and VC_Interessent.Interessent = Buf_V_BelegKopf.Interessent
                                and VC_Interessent.Kunde       = input frame {&frame-name} V_BelegKopf.Kunde) then

        &ENDIF

        do:

          lOK = adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
                  ('v_bel00056':U,
                   string(Buf_V_BelegKopf.Kunde),
                   string(input frame {&frame-name} V_BelegKopf.Kunde)).

        end.

        if lOK = yes then

          assign
            iKunde   = Buf_V_BelegKopf.Kunde
            iContact = Buf_V_BelegKopf.Interessent
            .

        else
        do:

          find Buf_S_Kunde
            where Buf_S_Kunde.Firma = {firma/s_kunde.fir pa-firma}
              and Buf_S_Kunde.Kunde = input frame {&frame-name} V_BelegKopf.Kunde
            no-lock no-error.

          if available Buf_S_Kunde then
          do:

            iKunde = input frame {&frame-name} V_BelegKopf.Kunde.

            &IF lookup ("VC","{&PA-MODULE}") > 0 &THEN

              find first bVC_Interessent
                where bVC_Interessent.Firma = {firma/s_kunde.fir pACConnectionSvc:prpcCompany}
                  and bVC_Interessent.Kunde = iKunde
                no-lock no-error.

              if available bVC_Interessent then

                iContact = bVC_Interessent.Interessent.

            &ENDIF

            if Buf_S_Kunde.PreisGruppe <> Buf_V_BelegKopf.PreisGruppe then

              if adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
                   ('v_bel00167':U,
                    Buf_V_BelegKopf.PreisGruppe,
                    string(input frame {&frame-name} V_BelegKopf.Kunde),
                    Buf_S_Kunde.Preisgruppe)  = no then

                return 'Abbruch':U.

          end.  /* if available Buf_S_Kunde */

          else
          do:

            adm.method.cls.DMCMessageSvc:prpoInstance:showError
              ('s_trg00146':U,
               string(input frame {&frame-name} V_BelegKopf.Kunde)).

            return.

          end.

        end. /* else do  -> lOK = no */

      end. /* else do  ->  input frame {&frame-name} V_BelegKopf.Kunde > 0  */

    end. /* if Buf_V_BelegKopf.Kunde <> input frame {&frame-name} V_BelegKopf.Kunde */

    else

      assign
        iKunde   = Buf_V_BelegKopf.Kunde
        iContact = Buf_V_BelegKopf.Interessent
        .

    find Buf_S_Kunde
      where Buf_S_Kunde.Firma = {firma/s_kunde.fir pa-firma}
        and Buf_S_Kunde.Kunde = iKunde
      no-lock. /* must exist min. once-only customer */

    if basis.buro.cls.BBCWorkflowSvc:prpoInstance:lHasLockStatusWarningOrLock
         (Buf_S_Kunde.S_Kunde_Obj,
          'VU':U) then
    do:

      /* Zeige alle Zustände an */

      basis.buro.cls.BBCWorkflowSvc:prpoInstance:showLockStatus
        (Buf_S_Kunde.S_Kunde_Obj,
         'VU':U) no-error.

      if error-status:error then
        return 'Abbruch':U.

    end.

    /* Positionsbearbeitung */

    run vert/proc/v_pbel20.w (input-output cTmp,
                                           Buf_V_BelegKopf.Belegart,
                                           'U':U,
                                           cSatzId,
                                           iKunde,
                                           iContact,
                                           ?,
                                           no,
                                           '':U,
                                           no,     /* new proceeding */
                                    output cSatzId_neu,
                                    output glZuschlag_sperren,
                              input-output table ttVBT_DocumentLines-NEW bind,
                              input-output table ttVBT_SalesBOM-NEW bind).

    if   cSatzId_neu = ?
      or cSatzId_neu = '':U then

      return 'Abbruch':U.

    run Beleg_uebernommen.

  end. /* keine Komplettübernahme */

end. /* Beleg ausgewählt */

end procedure. /* AdoptToOrder */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AdoptToProFormaInvoice V-table-Win 
PROCEDURE AdoptToProFormaInvoice :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Adopting a quote, an order or a shipping document in a pro forma invoice   */
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

define variable lKomplett as logical no-undo.
define variable lVFP      as logical no-undo.

/* Buffers -------------------------------------------------------------------*/

define buffer Buf_V_BelegKopf for V_BelegKopf.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

run vert/proc/v_pbel10.w (input-output cTmp,
                                       'UAD':U,
                                       'VFP':U,
                                       lSchlussrechnung,
                                       no,
                                output lKomplett,
                                output lVFP,
                                output cSatzId,
                                output gcOIDSourceDoc,
                                output gcSourceDocType).

if   cSatzId = ?
  or cSatzId = '':U then

  return 'Abbruch':U.

if lSchlussrechnung = no then
do:

  if lKomplett = yes then
  do:

    assign
      glZuschlag_sperren = yes
      cSatzId_neu        = cSatzId
      .

    run Beleg_uebernommen.

  end.
  else
  do:

    find Buf_V_BelegKopf
      where rowid(Buf_V_BelegKopf) = to-rowid(cSatzId)
      no-lock.

    iKunde = Buf_V_BelegKopf.Kunde.

    /* Positionsbearbeitung */

    run vert/proc/v_pbel20.w (input-output cTmp,
                                           Buf_V_BelegKopf.Belegart,
                                           cBelegart,
                                           cSatzId,
                                           iKunde,
                                           Buf_V_BelegKopf.Interessent,
                                           ?,
                                           no,
                                           '':U,
                                           no,              /* new proceeding */
                                    output cSatzId_neu,
                                    output glZuschlag_sperren,
                              input-output table ttVBT_DocumentLines-NEW bind,
                              input-output table ttVBT_SalesBOM-NEW bind).

    if   cSatzId_neu = ?
      or cSatzId_neu = '':U then

      return 'Abbruch':U.

    run Beleg_uebernommen.

  end.

end. /* kein Schlussrechnungsbeleg */
else
do:

  cSatzId_neu = cSatzId.

  run Beleg_uebernommen.

end.

end procedure. /* AdoptToProFormaInvoice */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AdoptToShippingDocument V-table-Win 
PROCEDURE AdoptToShippingDocument :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Adopting an order or a pro forma invoice in a shipping document            */
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

define variable lKomplett as logical no-undo.
define variable lVFP      as logical no-undo.


/* Buffers -------------------------------------------------------------------*/

define buffer Buf_V_BelegKopf for V_BelegKopf.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Auswahl des zu übernehmenden Belegkopfes */

run vert/proc/v_pbel10.w (input-output cTmp,
                                       'UP':U,
                                       'L':U,
                                       lSchlussrechnung,
                                       no,
                                output lKomplett,
                                output lVFP,
                                output cSatzId,
                                output gcOIDSourceDoc,
                                output gcSourceDocType).

if   cSatzId = ?
  or cSatzId = '':U then

  return 'Abbruch':U.

else
do:

  if lKomplett = yes then
  do:

    assign
      glZuschlag_sperren = yes
      cSatzId_neu        = cSatzId
      .

    run Beleg_uebernommen.

  end.
  else
  do:

    find Buf_V_BelegKopf
      where rowid(Buf_V_BelegKopf) = to-rowid(cSatzId)
      no-lock.

    iKunde = Buf_V_BelegKopf.Kunde.

    /* Positionsbearbeitung */

    run vert/proc/v_pbel20.w (input-output cTmp,
                                           Buf_V_BelegKopf.Belegart,
                                           'L':U,
                                           cSatzId,
                                           iKunde,
                                           0,
                                           ?,
                                           lVFP,
                                           '':U,no,         /* new proceeding */
                                    output cSatzId_neu,
                                    output glZuschlag_sperren,
                              input-output table ttVBT_DocumentLines-NEW bind,
                              input-output table ttVBT_SalesBOM-NEW bind).

    if   cSatzId_neu = ?
      or cSatzId_neu = '':U then

      return 'Abbruch':U.

    run Beleg_uebernommen.

  end. /* keine Komplettübernahme */

end. /* Beleg ausgewählt */

end procedure. /* AdoptToShippingDocument */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Anhaenger V-table-Win 
PROCEDURE Anhaenger :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Sammeldruck Anhänger für Packmittel                                        */
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

define variable cParameter as character no-undo.

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

if not available V_BelegKopf then

  adm.method.cls.DMCMessageSvc:prpoInstance:showError
    ('dtviw00002':U).

{adm/incl/d__par00.if
  &Parameterliste = "cParameter"
  &Parameter      = "Belegart"
  &Variable1      = "V_BelegKopf.Belegart"
}

{adm/incl/d__par00.if
  &Parameterliste = "cParameter"
  &Parameter      = "ReferenzNr"
  &Variable1      = "V_BelegKopf.ReferenzNr"
}

run basis/job/proc/bjvjob00.w ('':U,
                               cParameter,
                               'mawi/proc/m_dpmi03.p':U).

return.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Anzahlungen V-table-Win 
PROCEDURE Anzahlungen :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Aufruf Übersicht der Vorgänge zum Anzahlungsgeschäft                       */
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

define variable cTemp as character no-undo.

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

&IF lookup("V_ANZ","{&PA-OPTIONEN}") > 0 &THEN

  if available V_BelegKopf then

    run vert/proc/v_panz00.w(input-output cTemp,
                                          V_BelegKopf.V_BelegKopf_Obj,
                                          V_BelegKopf.BelegNummer).

&ENDIF

return.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Archivieren V-table-Win 
PROCEDURE Archivieren :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Prüfung, ob der Beleg manuell archiviert werden darf. Ergebnis wird        */
/* in der Variablen lArchivieren gespeichert.                                 */
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

define variable cPruefBelegart as character no-undo.
define variable iSchleife      as integer   no-undo.
define variable cBelegartInfo  as character no-undo.
define variable cParamList     as character no-undo.

define variable cPartialPaym   as character no-undo.
define variable iPartialPaym   as integer   no-undo.
define variable dPartialPaym   as decimal   no-undo.

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

assign
  cParamList = adm.method.cls.DMCParameterStringSvc:cWriteValue(cParamList,'MessageID':U,'v_bel00079':U)
  cParamList = adm.method.cls.DMCParameterStringSvc:cWriteValue(cParamList,'SubstitutionList':U,V_BelegKopf.BelegNummer)
  .

run pa_UISvcStartInstanceByName ('v_msgdialog_ArchiveSalesDoc.dyn':U,
                                 cParamList,
                                 '':U,
                                 '':U).

case V_BelegKopf.Belegart:

  when 'A':U
    or when 'VUD':U then

    lArchivieren = yes.

  when 'VFP':U then
  do:

    if can-do('MLL,MLI':U,V_BelegKopf.Herk_BelegArt) then
      adm.method.cls.DMCMessageSvc:prpoInstance:showError
        ('v_bel00419':U,
         string(V_BelegKopf.BelegNummer)).

    &IF LOOKUP ('VF_INTRA',"{&PA-OPTIONEN}") > 0 &THEN

      if stamm.base.cls.SBCBusinessCategorySvc:prpoInstance:lHasCompanyIntraStatSales(V_BelegKopf.BelegDatum) then

        case pACConnectionSvc:prpcLocalization:

          {&{&PA-XBasisName}_C_Pruefe_Intra_Archiv}
          {&{&PA-XBasisName}_U_Pruefe_Intra_Archiv}
          {&{&PA-XBasisName}_Q_Pruefe_Intra_Archiv}
          {&{&PA-XBasisName}_Pruefe_Intra_Archiv}
          {&{&PA-XBasisName}_Y_Pruefe_Intra_Archiv}

          otherwise
          do:

            if V_BelegKopf.Meldepflicht = yes then

              for each Buf_V_BelegPos
                fields(lfdNr_SR PositionsNr Satzart)
                where Buf_V_BelegPos.Firma      = V_BelegKopf.Firma
                  and Buf_V_BelegPos.Belegart   = V_BelegKopf.Belegart
                  and Buf_V_BelegPos.ReferenzNr = V_BelegKopf.ReferenzNr
                no-lock
                on error undo, throw:

                if    Buf_V_BelegPos.Satzart = 'A':U
                  and not can-find(first S_IntraHandel
                                     where S_IntraHandel.Firma            = V_BelegKopf.Firma
                                       and S_IntraHandel.Herk_Belegart    = V_BelegKopf.BelegArt
                                       and S_IntraHandel.Herk_ReferenzNr  = V_BelegKopf.ReferenzNr
                                       and S_IntraHandel.Herk_LfdNr_SR    = Buf_V_BelegPos.LfdNr_SR
                                       and S_IntraHandel.Herk_PositionsNr = Buf_V_BelegPos.PositionsNr) then

                  adm.method.cls.DMCMessageSvc:prpoInstance:showError
                    ('vfdta00001':U,
                      string(V_BelegKopf.Belegnummer)).

              end. /* for each Buf_V_BelegPos */

          end. /* otherwise */

        end case. /* pACConnectionSvc:prpcLocalization */

    &ENDIF /* &IF lookup("VF_Intra","{&PA-OPTIONEN}") > 0 */

    lArchivieren = yes.

  end. /* Proformarechnungen */

  when 'VUR':U then
  do:

    assign
      lArchivieren   = yes
      cPruefBelegart = 'L,U,R':U
      .

    for each V_BelegPos /* code checked by Warter 08.12.2022 */
      fields (PositionsNr)
      where V_BelegPos.Firma      = V_BelegKopf.Firma
        and V_BelegPos.Belegart   = V_BelegKopf.Belegart
        and V_BelegPos.ReferenzNr = V_BelegKopf.ReferenzNr
      no-lock
      on error undo, throw:

      do iSchleife = 1 to num-entries(cPruefBelegart):

        find first Buf_V_BelegPos
          where Buf_V_BelegPos.Firma            = V_BelegKopf.Firma
            and Buf_V_BelegPos.Belegart         = entry(iSchleife,cPruefBelegart)
            and Buf_V_BelegPos.Herk_Belegart    = V_BelegKopf.Belegart
            and Buf_V_BelegPos.Herk_ReferenzNr  = V_BelegKopf.ReferenzNr
            and Buf_V_BelegPos.Herk_PositionsNr = V_BelegPos.PositionsNr
            and Buf_V_BelegPos.offen            = yes
          use-index Herkunft
          no-lock no-error.

        if available Buf_V_BelegPos then
        do:

          cBelegartInfo = {fnarg
                            pa_cStCchDocTypeDesc
                            "Buf_V_BelegPos.Belegart,
                             pa-Sprache,
                             {&pa_CchDesc}"}.

          adm.method.cls.DMCMessageSvc:prpoInstance:showError
            ('v_bel00075':U,
             string(V_BelegKopf.Belegnummer),
             cBelegartInfo).

        end. /* if available Buf_V_BelegPos */

      end. /* Belegschleife */

    end. /* for each V_BelegPos of V_BelegKopf */

  end. /* Rahmenaufträge */

  when 'VUA':U then
  do:

    if mawi.base.cls.MMCPickingSvc:prpoInstance:lDocumentIsInPicking(V_BelegKopf.V_BelegKopf_Obj) then

      adm.method.cls.DMCMessageSvc:prpoInstance:showError
        ('v_bel00100':U,
         string(V_BelegKopf.Belegnummer)).

    assign
      lArchivieren   = yes
      cPruefBelegart = 'L,U,R,G':U
      .

    for each V_BelegPos /* code checked by Warter 08.12.2022 */
      fields (PositionsNr KO_Lagerort)
      where V_BelegPos.Firma      = V_BelegKopf.Firma
        and V_BelegPos.Belegart   = V_BelegKopf.Belegart
        and V_BelegPos.ReferenzNr = V_BelegKopf.ReferenzNr
      no-lock
      on error undo, throw:

      if V_BelegPos.KO_Lagerort <> ? then
      do:

        for each ML_BelegPos
          fields (Belegart)
          where ML_BelegPos.Firma            = {firma/mlartort.fir pa-Firma}
            and ML_BelegPos.Belegart         = 'MLL':U
            and ML_BelegPos.Herk_Belegart    = V_BelegKopf.Belegart
            and ML_BelegPos.Herk_ReferenzNr  = V_BelegKopf.ReferenzNr
            and ML_BelegPos.Herk_PositionsNr = V_BelegPos.PositionsNr
          use-index Herkunft
          no-lock,
          first ML_BelegKopf
            where ML_BelegKopf.Firma      = ML_BelegPos.Firma
              and ML_BelegKopf.Belegart   = 'MLL':U
              and ML_BelegKopf.Referenznr = ML_BelegPos.ReferenzNr
              and ML_BelegKopf.offen      = yes
          no-lock
          on error undo, throw:

          cBelegartInfo = {fnarg
                            pa_cStCchDocTypeDesc
                            "'MLL':U,
                             pa-Sprache,
                             {&pa_CchDesc}"}.

          adm.method.cls.DMCMessageSvc:prpoInstance:showError
            ('v_bel00076':U,
             string(V_BelegKopf.Belegnummer),
             cBelegartInfo).

        end. /* for each ML_BelegPos */

      end.

      do iSchleife = 1 to num-entries(cPruefBelegart):

        find first Buf_V_BelegPos
          where Buf_V_BelegPos.Firma            = V_BelegKopf.Firma
            and Buf_V_BelegPos.Belegart         = entry(iSchleife,cPruefBelegart)
            and Buf_V_BelegPos.Herk_Belegart    = V_BelegKopf.Belegart
            and Buf_V_BelegPos.Herk_ReferenzNr  = V_BelegKopf.ReferenzNr
            and Buf_V_BelegPos.Herk_PositionsNr = V_BelegPos.PositionsNr
            and Buf_V_BelegPos.offen            = yes
          use-index Herkunft
          no-lock no-error.

        if available Buf_V_BelegPos then
        do:

          cBelegartInfo = {fnarg
                            pa_cStCchDocTypeDesc
                            "Buf_V_BelegPos.Belegart,
                             pa-Sprache,
                             {&pa_CchDesc}"}.

          adm.method.cls.DMCMessageSvc:prpoInstance:showError
            ('v_bel00076':U,
             string(V_BelegKopf.Belegnummer),
             cBelegartInfo).

        end. /* if available Buf_V_BelegPos */

      end. /* Belegschleife */

    end. /* for each V_BelegPos of V_BelegKopf */

  end. /* Abrufaufträge  */

  when 'U':U then
  do:

    if mawi.base.cls.MMCPickingSvc:prpoInstance:lDocumentIsInPicking(V_BelegKopf.V_BelegKopf_Obj) then

      adm.method.cls.DMCMessageSvc:prpoInstance:showError
        ('v_bel00100':U,
         string(V_BelegKopf.Belegnummer)).

    assign
      lArchivieren   = yes
      cPruefBelegart = 'L,R,G':U
      .

    for each V_BelegPos
      fields (PositionsNr Belegart ReferenzNr lfdNr_SR Artikel)
      where V_BelegPos.Firma      = V_BelegKopf.Firma
        and V_BelegPos.Belegart   = V_BelegKopf.Belegart
        and V_BelegPos.ReferenzNr = V_BelegKopf.ReferenzNr
      no-lock
      on error undo, throw:

      do iSchleife = 1 to num-entries(cPruefBelegart):

        find first Buf_V_BelegPos
          where Buf_V_BelegPos.Firma            = V_BelegKopf.Firma
            and Buf_V_BelegPos.Belegart         = entry(iSchleife,cPruefBelegart)
            and Buf_V_BelegPos.Herk_Belegart    = V_BelegKopf.Belegart
            and Buf_V_BelegPos.Herk_ReferenzNr  = V_BelegKopf.ReferenzNr
            and Buf_V_BelegPos.Herk_PositionsNr = V_BelegPos.PositionsNr
            and Buf_V_BelegPos.offen            = yes
          use-index Herkunft
          no-lock no-error.

        if available Buf_V_BelegPos then
        do:

          cBelegartInfo = {fnarg
                            pa_cStCchDocTypeDesc
                            "Buf_V_BelegPos.Belegart,
                             pa-Sprache,
                             {&pa_CchDesc}"}.

          adm.method.cls.DMCMessageSvc:prpoInstance:showError
            ('v_bel00078':U,
             string(V_BelegKopf.Belegnummer),
             cBelegartInfo).

        end. /* if available Buf_V_BelegPos */

      end. /* Belegschleife */

      &IF LOOKUP("E_","{&PA-MODULE}") > 0 &THEN

        if can-find(first E_BelegPos
                      where E_BelegPos.Firma               = {firma/ebelkop.fir pa-Firma}
                        and E_BelegPos.Belegart            = 'EB':U
                        and E_BelegPos.Coverage_MRPDocType = V_BelegPos.Belegart
                        and E_BelegPos.Coverage_Obj        = V_BelegPos.V_BelegPos_Obj
                        and E_BelegPos.Artikel             = V_BelegPos.Artikel) then

          /* answer no will return an error (message configuration) */

          adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
            ('v_bel00150':U,
             string(V_Belegkopf.Belegnummer)).

      &ENDIF

    end. /* for each V_BelegPos of V_BelegKopf */

    &IF lookup("V_ANZ","{&PA-OPTIONEN}") > 0 &THEN

      if V_BelegKopf.Schlussrechnung = yes then
      do:

        /* if this is a partial payment you only can archive an order  */
        /* manually if no document follows                             */

        run Anzahlung_pruefen(       V_BelegKopf.V_BelegKopf_Obj,
                                     'R':U,                      /* invoice is enough here because shipping document has been tested above */
                                     yes,                        /* test also for archived invoices  */
                              output cPartialPaym,
                              output iPartialPaym,
                              output dPartialPaym).

        if cPartialPaym > '':U then

          adm.method.cls.DMCMessageSvc:prpoInstance:showError
            ('v_bel00313':U,
             string(V_BelegKopf.Belegnummer)).

      end.

    &ENDIF

  end. /* Aufträge  */

  /* UrB: Re, GS manuell archivieren??? ----- */

  when 'R':U
    or when 'G':U then

    lArchivieren = yes.

  otherwise
  do:

    lArchivieren = no.
    return error.

  end.

end case.

if lArchivieren = yes then
do:

  /* --> UMO# LM Tour: Archivierte Aufträge von Transporten löschen */
  &IF LOOKUP("U_CW":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  for each V_BelegPos
     fields (V_BelegPos.uCW_TransportNr)
     where V_BelegPos.Firma      = V_BelegKopf.Firma
       and V_BelegPos.Belegart   = V_BelegKopf.Belegart
       and V_BelegPos.ReferenzNr = V_BelegKopf.ReferenzNr
     exclusive-lock
     on error undo, throw:
       assign
         V_BelegPos.uCW_TransportNr = 0
         .
  end.
  &ENDIF
  /* <-- UMO# LM Tour: Archivierte Aufträge von Transporten löschen */

  &IF LOOKUP("Q_AEBW":U,"{&PA-OPTIONEN}":U) > 0 &THEN
      basis.inwb.cls.BOCInwbSvc:prpoInstance:prplOaPArchiveDoc = yes.
  &ENDIF

  run dispatch in THIS-PROCEDURE ('update-record':U).

  if return-value <> 'adm-error':U then

    run new-state ('oeffne-query,record-source':U).

end.

catch oError as Progress.Lang.Error:

  lArchivieren = no.

  (new adm.method.cls.DMCErrorFrw(oError)):displayProgressErrorsOnly().

end catch.

&IF LOOKUP("Q_AEBW":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  finally:

    basis.inwb.cls.BOCInwbSvc:prpoInstance:prplOaPArchiveDoc = no.

  end finally.
&ENDIF

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Beleg_uebernommen V-table-Win 
PROCEDURE Beleg_uebernommen :
/*------------------------------------------------------------------------------
  Purpose:     Wenn Beleg erfolgreich übernommen, dann anzeigen und öffnen
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

define variable cTemp                 as character no-undo.
define variable iCounter              as integer   no-undo.

&IF lookup('S_XRechnung':U,"{&PA-OPTIONEN}":U) > 0 &THEN
  define variable cRouteID            as character no-undo.

  define buffer bV_BelegKopf-Source   for V_BelegKopf.
&ENDIF

define buffer Buf_V_BelegKopf         for V_BelegKopf.
define buffer Buf2_V_BelegKopf        for V_BelegKopf.
define buffer Buf2_V_BelegPos         for V_BelegPos.
define buffer V_BelegKopfAdr          for V_BelegKopfAdr.
define buffer VC_Interessent          for VC_Interessent.
define buffer S_Adresse               for S_Adresse.
define buffer bS_Kunde                for S_Kunde.
define buffer bV_BelegKopf-CopySource for V_BelegKopf.
&IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
define buffer buVC_InterBelegKopf     for VC_InterBelegKopf.
define buffer buVC_InterAktivitaet    for VC_InterAktivitaet.
&ENDIF

/* --> UMO#WH2015-07-010 cpl Streckenmix im Vertriebsbeleg */
/* Bei Auftrag in Lieferschein müssen wir pro benutzter Versandart einen Beleg anlegen */
/* in cSatz_ID-neu stehen die RowIds aller Lieferscheine */
/* Wenn wir mehrere haben, dann auch das Zuschlagsfenster aufmachen */

&IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
define variable cuParams_uvpbel03 as character     no-undo.
if num-entries(cSatzId_neu,{&PA-DELIMITER5}) > 1 then
do:

  adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage('uvbel00006':U).

  find Buf_V_BelegKopf
    where Buf_V_BelegKopf.V_BelegKopf_Obj = gcOIDSourceDoc
    no-lock no-error.

  if available Buf_V_BelegKopf then
    cSatzId = string(rowid(Buf_V_BelegKopf)).

  /* fill parameters for uvpbel03.w */
  {adm/incl/d__par00.if
    &ParameterListe = "cuParams_uvpbel03"
    &Parameter      = "Documents"
    &Variable1      = "cSatzId_neu"
  }

  {adm/incl/d__par00.if
    &ParameterListe = "cuParams_uvpbel03"
    &Parameter      = "Origin"
    &Variable1      = "cSatzId"
  }

  /* setting variables for later use */
  assign
    cSatzId_neu        = entry(num-entries(cSatzId_neu,{&PA-DELIMITER5}),cSatzId_neu,{&PA-DELIMITER5})
    glZuschlag_sperren = no
    .
end.
&ENDIF
/* <-- UMO#WH2015-07-010 cpl Streckenmix im Vertriebsbeleg */

do on error undo, return 'adm-error':U:

  glBeleguebernahme = yes.

  find Buf_V_BelegKopf
    where rowid(Buf_V_BelegKopf) = to-rowid(cSatzId_neu)
    no-lock no-error.

  if available Buf_V_BelegKopf then
  do:

    run set-link-attribute in adm-broker-hdl
      (this-procedure,
       'container-source':U,
       'Belegsprache=':U + Buf_V_BelegKopf.Sprache).

    if    pa-Sprache <> Buf_V_BelegKopf.Sprache
      and basis.user.cls.BUCUserPropertySvc:prpoInstance:cParameterValue
            ('V_':U + 'useDocLanguage_':U + Buf_V_BelegKopf.Belegart) = 'yes':U then

      run set-link-attribute in adm-broker-hdl (this-procedure,
                                                'container-source':U,
                                                'Sprache=':U + Buf_V_BelegKopf.Sprache).

  end. /* if available Buf_V_BelegKopf then */

  glBeleguebernahme = no.

  /* --> UMO#WH2016-02-002 cpl Folgebelege aus Kundencenter generieren */
  &IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  if not gluAdopting then
  do:
  &ENDIF
  /* <-- UMO#WH2016-02-002 cpl Folgebelege aus Kundencenter generieren */

  run check-modified in THIS-PROCEDURE ('check':U) no-error.

  /* Save the current rowid in case the add is cancelled. */

  assign
    adm-first-table    = rowid({&adm-tableio-first-table})
    adm-adding-record  = yes  /* Signal that it's add not copy. */
    adm-query-empty    = not available({&adm-tableio-first-table}) /* needed in Cancel */
    pa-created-records = '':U
    .

  run set-attribute-list ("ADM-NEW-RECORD=yes":U).

  /* --> UMO#WH2016-02-002 cpl Folgebelege aus Kundencenter generieren */
  &IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  end.
  &ENDIF
  /* <-- UMO#WH2016-02-002 cpl Folgebelege aus Kundencenter generieren */

  /* Erfassen eines neuen Beleges */

  Add-Trans:
  do transaction
    on error undo, throw:

    assign
      adm-create-complete = no  /* Signal whether Create succeeded. */
      cTemp               = '':U
      .

    if lSchlussrechnung = no then
    do:

      /* der aktuelle Beleg (bei Komplettübernahme) bzw. der Vorlagebeleg     */

      find Buf_V_BelegKopf
        where rowid(Buf_V_BelegKopf) = to-rowid(cSatzId)
        exclusive-lock no-error.

      /* prüfen Zuschläge übernommener Beleg */

      if    glZuschlag_sperren               = no
        and available Buf_V_BelegKopf
        and (   Buf_V_BelegKopf.Zuschlag[1] <> 0
             or Buf_V_BelegKopf.Zuschlag[2] <> 0
             or Buf_V_BelegKopf.Zuschlag[3] <> 0
             or Buf_V_BelegKopf.Zuschlag[4] <> 0) then
      do on error undo, throw:

        lOK = yes.

        find V_BelegKopf
          where rowid(V_BelegKopf) = to-rowid(cSatzId_neu)
          exclusive-lock.

        /* Initialisierung, Zuschläge werden im Dialog(v__bel21.w) übernommen */

        assign
          V_BelegKopf.Zuschlag[1]      = 0
          V_BelegKopf.Zuschlag[2]      = 0
          V_BelegKopf.Zuschlag[3]      = 0
          V_BelegKopf.Zuschlag[4]      = 0
          V_BelegKopf.proz_Zuschlag    = 0
          V_BelegKopf.ZuschlagHerkunft = '':U
          .

        validate V_BelegKopf.

        /* --> UMO#WH2017-04-017 cpl Streckenlieferschein: Kopfzuschläge */
        &IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
        if cuParams_uvpbel03 > '':U then
          /* Belegübersicht zur Pflege der Kopfzuschläge aufmachen */
          run branche/vert/proc/uvpbel03.w (input-output cuParams_uvpbel03) no-error.
        else do:
        &ENDIF
        /* <-- UMO#WH2017-04-017 cpl Streckenlieferschein: Kopfzuschläge  */


        if not can-find (first Buf2_V_BelegPos
                           where Buf2_V_BelegPos.Firma      = V_Belegkopf.Firma
                             and Buf2_V_BelegPos.Belegart   = V_Belegkopf.Belegart
                             and Buf2_V_BelegPos.ReferenzNr = V_Belegkopf.ReferenzNr
                             and Buf2_V_BelegPos.LfdNr_SR  >= 0
                             and Buf2_V_BelegPos.Satzart    = 'A':U) then
        do:

          {adm/incl/d__msg00.if
            &Meldung   = "'v_bel00153':U"
            &Liste     = "string(Buf_V_BelegKopf.Belegnummer)"
            &Rueckgabe = "lOK"
          }

        end.  /* if not can-find (first Buf2_V_BelegPos */

        /* A blanket order doesn't have any surcharges. */

        if    lOK = yes
          and V_BelegKopf.Belegart <> 'VUR':U then

          run vert/proc/v__bel21.w (to-rowid(cSatzId_neu),
                                    to-rowid(cSatzId)).

        /* --> UMO#WH2017-04-017 cpl Streckenlieferschein: Kopfzuschläge */
        &IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
        end.
        &ENDIF
        /* <-- UMO#WH2017-04-017 cpl Streckenlieferschein: Kopfzuschläge  */

      end.  /* if glZuschlag_sperren = no */

      /* Komplettübernahme */

        if    glZuschlag_sperren               = yes
          and available Buf_V_BelegKopf
          and (   Buf_V_BelegKopf.Zuschlag[1] <> 0
               or Buf_V_BelegKopf.Zuschlag[2] <> 0
               or Buf_V_BelegKopf.Zuschlag[3] <> 0
               or Buf_V_BelegKopf.Zuschlag[4] <> 0) then
        do:

        if not can-do('VFP,G,VUD,VUR':U,Buf_V_BelegKopf.Belegart) then
        do:

          find first Buf2_V_BelegPos
            where Buf2_V_BelegPos.Firma          = Buf_V_BelegKopf.Firma
              and Buf2_V_BelegPos.Belegart       = Buf_V_BelegKopf.Belegart
              and Buf2_V_BelegPos.ReferenzNr     = Buf_V_BelegKopf.ReferenzNr
              and Buf2_V_BelegPos.LfdNr_SR       = 0
              and Buf2_V_BelegPos.Herk_Belegart <> ?
            no-lock no-error.

          if available Buf2_V_BelegPos then

            find Buf2_V_BelegKopf
              where Buf2_V_BelegKopf.Firma      = Buf2_V_BelegPos.Firma
                and Buf2_V_BelegKopf.Belegart   = Buf2_V_BelegPos.Herk_Belegart
                and Buf2_V_BelegKopf.ReferenzNr = Buf2_V_BelegPos.Herk_ReferenzNr
              exclusive-lock no-error.

          /* If the predecessor document header contains surcharges, then it  */
          /* must be checked if value based parts of this header surcharge    */
          /* have already been adopted with one or more partial adoptions of  */
          /* several positions. In case of complete adoption and remaining    */
          /* header surcharge, the remaining surcharge has to be considered.  */

          if    available Buf2_V_BelegKopf
            and not can-do('A,G':U,Buf2_V_BelegKopf.Belegart)
            and not(    Buf2_V_BelegKopf.Belegart = 'U':U
                    and Buf_V_BelegKopf.Belegart  = 'U':U) then
          do:

            assign
              Buf_V_BelegKopf.Zuschlag[1]      = 0
              Buf_V_BelegKopf.Zuschlag[2]      = 0
              Buf_V_BelegKopf.Zuschlag[3]      = 0
              Buf_V_BelegKopf.Zuschlag[4]      = 0
              .

            /* The calculation of adoptable header surcharges for a complete  */
            /* adoption has to be similar with the calculation for partial    */
            /* adoptions in v__bel21.w.                                       */

            do iCounter = 1 to 4:

              Buf_V_BelegKopf.Zuschlag[iCounter] = (if Buf2_V_BelegKopf.Zuschlag[iCounter] >= 0 then
                                                      (if    Buf2_V_BelegKopf.Zuschlag[iCounter] - Buf2_V_BelegKopf.Zuschlag_ueber[iCounter]  > 0
                                                         and Buf2_V_BelegKopf.Zuschlag_ueber[iCounter]                                       >= 0 then
                                                         Buf2_V_BelegKopf.Zuschlag[iCounter] - Buf2_V_BelegKopf.Zuschlag_ueber[iCounter]
                                                       else
                                                         0)
                                                    else
                                                      (if    Buf2_V_BelegKopf.Zuschlag[iCounter] - Buf2_V_BelegKopf.Zuschlag_ueber[iCounter]  < 0
                                                         and Buf2_V_BelegKopf.Zuschlag_ueber[iCounter]                                       <= 0 then
                                                         Buf2_V_BelegKopf.Zuschlag[iCounter] - Buf2_V_BelegKopf.Zuschlag_ueber[iCounter]
                                                       else
                                                         0)).

              /* --> UMO#CA2018-03-001b jpd Versandparameter - Frachtkosten */
              &IF LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN
              if iCounter = {&pa_V_Frachtzuschlag}
                and can-do(' ,F':U, substring(Buf_V_BelegKopf.Zuschlagherkunft, iCounter, 1))
                and adm.config.cls.DCCAppConfigSvc:prpoInstance:iParameterValue('UCA_FreightCalcMode':U) > 1 then
                /* UCA_FreightCalcMode offers an option to recalculate freight charges  */
                /* in sequential documents. Setting 1 means "standard", in which case   */
                /* no recalculation is done.                                            */
                Buf_V_BelegKopf.Zuschlag[iCounter] = dFrachtzuschlag(buffer Buf_V_BelegKopf).
              &ENDIF
              /* <-- UMO#CA2018-03-001b jpd Versandparameter - Frachtkosten */

              /* --> UMO#CA2018-03-001c AF2 Versandparameter - Verpackungskosten */
              &IF LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN
              if can-do({&uCA_PackCostAllowedDocTypes}, Buf_V_BelegKopf.BelegArt)
                and iCounter = {&pa_V_Verpackungskostenzuschlag}
                and can-do(' ,V':U, substring(Buf_V_BelegKopf.Zuschlagherkunft, iCounter, 1)) then
                Buf_V_BelegKopf.Zuschlag[iCounter] = branche.vert.cls.UVCPricingSvc:prpoInstance:dCalcChargablePackagingCosts(buffer Buf_V_BelegKopf).
              &ENDIF
              /* <-- UMO#CA2018-03-001c AF2 Versandparameter - Verpackungskosten */

              /* The calculated remaining header surcharge for the complete   */
              /* adoption must also be updated in the predecessor document.   */

              Buf2_V_BelegKopf.Zuschlag_ueber[iCounter] = Buf2_V_BelegKopf.Zuschlag_ueber[iCounter] + Buf_V_BelegKopf.Zuschlag[iCounter].

              /* --> UMO#CA2018-03-001b jpd Versandparameter - Frachtkosten */
              &IF LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN
              if iCounter = {&pa_V_Frachtzuschlag}
                and can-do(' ,F':U, substring(Buf_V_BelegKopf.Zuschlagherkunft, iCounter, 1))
                and adm.config.cls.DCCAppConfigSvc:prpoInstance:iParameterValue('UCA_FreightCalcMode':U) > 1
                and Buf2_V_BelegKopf.Zuschlag_ueber[iCounter] > Buf2_V_BelegKopf.Zuschlag[iCounter] then
                Buf2_V_BelegKopf.Zuschlag_ueber[iCounter] = Buf2_V_BelegKopf.Zuschlag[iCounter].
              &ENDIF
              /* <-- UMO#CA2018-03-001b jpd Versandparameter - Frachtkosten */

              /* --> UMO#CA2018-03-001c AF2 Versandparameter - Verpackungskosten */
              &IF LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN
              if can-do({&uCA_PackCostAllowedDocTypes}, Buf_V_BelegKopf.BelegArt)
                and iCounter = {&pa_V_Verpackungskostenzuschlag}
                and can-do(' ,V':U, substring(Buf_V_BelegKopf.Zuschlagherkunft, iCounter, 1))
                and Buf2_V_BelegKopf.Zuschlag_ueber[iCounter] > Buf2_V_BelegKopf.Zuschlag[iCounter] then
                Buf2_V_BelegKopf.Zuschlag_ueber[iCounter] = Buf2_V_BelegKopf.Zuschlag[iCounter].
              &ENDIF
              /* <-- UMO#CA2018-03-001c AF2 Versandparameter - Verpackungskosten */

            end. /* do iCounter = 1 to 4 */

            validate Buf_V_BelegKopf.

            validate Buf2_V_BelegKopf.

          end. /* if available Buf2_V_BelegKopf */

        end. /* if not can-do('VFP,G,VUD,VUR':U,Buf_V_BelegKopf.Belegart) */

      end. /* if glZuschlag_sperren = yes */

      /* soll Angebot archiviert werden? */

      if    (can-do('U,VUR':U,cBelegart)
        &IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
             or gluQuoteVersioning = yes and cBelegart = 'A':U)
        &ELSE
            )
        &ENDIF
        and Buf_V_BelegKopf.Belegart = 'A':U
        and cSatzId_neu             <> ?
        and Buf_V_BelegKopf.offen then
      do:

        {adm/incl/d__msg00.if
          &Meldung   = "'v_bel00079':U"
          &Liste     = "string(Buf_V_BelegKopf.Belegnummer)"
          &Rueckgabe = "lOK"
        }

        if lOK then
        do:

          for each Buf_V_BelegPos
            where Buf_V_BelegPos.Firma      = Buf_V_BelegKopf.Firma
              and Buf_V_BelegPos.Belegart   = Buf_V_BelegKopf.Belegart
              and Buf_V_BelegPos.ReferenzNr = Buf_V_BelegKopf.ReferenzNr
            exclusive-lock
            on error  undo, throw
            on endkey undo, return 'adm-error':U:

            Buf_V_BelegPos.offen = no.
            validate Buf_V_BelegPos.

          end.

          Buf_V_BelegKopf.offen = no.
          validate Buf_V_BelegKopf.

        end.  /* if lOK */

      end. /* Auftrag aus Angebot */

    end. /* kein Schlussrechnungsbeleg */

    /* --> UMO#WH2016-02-002 cpl Folgebelege aus Kundencenter generieren */
    &IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
    if gluAdopting then
      return.
    &ENDIF
    /* <-- UMO#WH2016-02-002 cpl Folgebelege aus Kundencenter generieren */

    find V_BelegKopf
      where rowid(V_BelegKopf) = to-rowid(cSatzId_neu)
      exclusive-lock no-error.

    if not available V_BelegKopf then
    do on error undo, throw:

      /* lese Datensatz, damit beim direkten Update der zuletzt angewählte    */
      /* Beleg, der auch noch im Bildschirm steht angewählt wird              */

      find V_BelegKopf
        where rowid(V_BelegKopf) = adm-first-table    /* the selected document when starting to adopt  */
        no-lock.                                      /* must be available */

      return 'adm-error':U.

    end.

    /* Prüfe auf diversen */

    find S_Kunde
      where S_Kunde.Firma = {firma/s_kunde.fir pa-firma}
        and S_Kunde.Kunde = V_BelegKopf.Kunde
      no-lock.

    if    S_Kunde.AdressNr = 0
      and not can-find(V_BelegKopfAdr
                         where V_BelegKopfAdr.Firma      = V_BelegKopf.Firma
                           and V_BelegKopfAdr.Belegart   = V_BelegKopf.Belegart
                           and V_BelegKopfAdr.ReferenzNr = V_BelegKopf.ReferenzNr
                           and V_BelegKopfAdr.Typ        = 'K':U) then
    do:

      if V_BelegKopf.Interessent > 0 then
      do:

        find VC_Interessent
          where VC_Interessent.Firma       = {firma/s_kunde.fir pa-Firma}
            and VC_Interessent.Interessent = V_BelegKopf.Interessent
          no-lock.                         /* if the document contains a prospect this must exist */

        find S_Adresse
          where S_Adresse.Firma    = {firma/s_adres.fir pACConnectionSvc:prpcCompany}
            and S_Adresse.AdressNr = VC_Interessent.AdressNr
          no-lock.

        create V_BelegKopfAdr.
        buffer-copy
          S_Adresse
          except
            Anlagebenutzer
            Anlagedatum
            Anlagezeit
            Aenderungbenutzer
            Aenderungdatum
            Aenderungzeit
            Firma
          to V_BelegKopfAdr
          assign
            V_BelegKopfAdr.Firma      = V_BelegKopf.Firma
            V_BelegKopfAdr.BelegArt   = V_BelegKopf.BelegArt
            V_BelegKopfAdr.ReferenzNr = V_BelegKopf.ReferenzNr
            V_BelegKopfAdr.Typ        = 'K':U
            .
        validate V_BelegKopfAdr.

      end. /* Interessent */

      else
      do on error undo, throw:

        /* ttSAdresse has to be deleted because it contains the address of    */
        /* the customer of the document that actually is in the view an not   */
        /* the adress of the master document.                                 */

        if glOpenAdress = yes then
        do:

          delete ttS_Adresse.

          run OpenAddressViewer.

        end.

        /* Save the entered address only if it contains the minimum of data.  */
        /* This is necessary because the write-trigger of V_BelegKopfAdr will */
        /* throw an error-message and after accepting it the copy process     */
        /* will be aborted.                                                   */

        if    available ttS_Adresse
          and ttS_Adresse.Name1 <> '':U
          and ttS_Adresse.Staat <> '':U
          and ttS_Adresse.Ort   <> '':U  then
        do:

          create V_BelegKopfAdr.

          assign
            V_BelegKopfAdr.Firma      = V_BelegKopf.Firma
            V_BelegKopfAdr.Belegart   = V_BelegKopf.Belegart
            V_BelegKopfAdr.ReferenzNr = V_BelegKopf.ReferenzNr
            V_BelegKopfAdr.Typ        = 'K':U
            .
          validate V_BelegKopfAdr.

          buffer-copy
            ttS_Adresse
            except
              Anlagebenutzer
              Anlagedatum
              Anlagezeit
              Aenderungbenutzer
              Aenderungdatum
              Aenderungzeit
              Firma
            to V_BelegKopfAdr.

        end.

      end.

    end. /* diverser Kunde */

    if    V_BelegKopf.Belegart        = 'L':U
      and V_BelegKopf.Schlussrechnung = yes
      and can-do ('U,VUA':U,Buf_V_BelegKopf.Belegart) then

      Buf_V_BelegKopf.Schlussrechnung = yes.

    assign
      pa-created-records = 'V_BelegKopf':U
      adm-create-complete = yes
      .

    /* Check if the fields concern group and association has been changed in  */
    /* the customer master file over a period between creation and adopting   */
    /* of the predecessor document.                                           */

    if available V_BelegKopf then
    do on error undo, throw:

      /* Get the predecessor document to check possible differences between   */
      /* the predecessor document and the actual customer master file.        */

      find bV_BelegKopf-CopySource
        where bV_BelegKopf-CopySource.Firma      = V_BelegKopf.Firma
          and bV_BelegKopf-CopySource.Belegart   = V_BelegKopf.Herk_Belegart
          and bV_BelegKopf-CopySource.ReferenzNr = V_BelegKopf.Herk_ReferenzNr
        no-lock no-error.

      /* If the adopting should be done from an order to a shipping document, */
      /* an invoice, or proforma invoice, then a comparison between the       */
      /* predecessor document and the customer master file is needed.         */

      if (available bV_BelegKopf-CopySource
          and V_BelegKopf.Uebernahme
          and can-do ('U,VUA':U,V_BelegKopf.Herk_BelegArt)
          and can-do ('L,R,VFP':U,V_BelegKopf.Belegart)) then
      do:

        /* If there is a alternative invoice recipient, then get the origin   */
        /* customer master file from the service recipient.                   */

        /* Check for an available service recipient in the new document.      */

        if (    V_BelegKopf.Lieferung_an <> ?
            and V_BelegKopf.Lieferung_an  > 0) then

          find bS_Kunde
            where bS_Kunde.Firma = {firma/s_kunde.fir V_BelegKopf.Firma}
              and bS_Kunde.Kunde = V_BelegKopf.Lieferung_an
            no-lock no-error.

        /* In all other cases, get the customer master file from the customer */
        /* of the predecessor document.                                       */

        else

          find bS_Kunde
            where bS_Kunde.Firma = {firma/s_kunde.fir V_BelegKopf.Firma}
              and bS_Kunde.Kunde = bV_BelegKopf-CopySource.Kunde
            no-lock no-error.

        /* Get the assigned association from the predecessor document to      */
        /* check if the association was used for payment regulation.          */

        if available bS_Kunde then
        do:

          /* Check if an alternative invoice recipient is available and if    */
          /* the fields company group and association contain valid entries,  */
          /* like the assignment in v__bel00.lib. If v__bel00.lib wasn't used */
          /* for the adoption, it must be avoided that both fields contain    */
          /* invalid entries from an alternative invoice recipient.           */

          if (    V_BelegKopf.Kunde       <> bS_Kunde.Kunde
              and (   V_BelegKopf.Konzern <> bS_Kunde.Konzern
                   or V_BelegKopf.Konzern <> bV_BelegKopf-CopySource.Konzern)
              and (   V_BelegKopf.Verband <> bS_Kunde.Verband
                   or V_BelegKopf.Verband <> bV_BelegKopf-CopySource.Verband)) then
          do:

            assign
              V_BelegKopf.Konzern = bS_Kunde.Konzern
              V_BelegKopf.Verband = bS_Kunde.Verband
              .

            validate V_BelegKopf.

          end. /* if V_BelegKopf.Kunde <> bS_Kunde.Kunde */

          /* Question, if field association from the predecessor document     */
          /* should be loaded, or if the current available association from   */
          /* the customer master file should be kept in the target document.  */

          if bS_Kunde.Verband <> bV_BelegKopf-CopySource.Verband then
          do:

            if adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
                 ('v_bel00414':U,
                  string (bS_Kunde.Verband),
                  string (bV_BelegKopf-CopySource.Verband)) then
            do:

              /* If the answer is yes, then the entry from the predecessor    */
              /* document has to be assigned.                                 */

              V_BelegKopf.Verband = bV_BelegKopf-CopySource.Verband.

              validate V_BelegKopf.

            end. /* if lShowMessage v_bel00414 */

            else
            do:

              /* If the answer is no, then the entry from the actual customer */
              /* master file from the service recipient has to be assigned.   */

              V_BelegKopf.Verband = bS_Kunde.Verband.

              validate V_BelegKopf.

            end. /* else lShowMessage v_bel00414 */

          end. /* if bS_Kunde.Verband <> bV_BelegKopf-CopySource.Verband */

        end. /* if available bS_Kunde */

      end. /* if available bV_BelegKopf-CopySource and V_BelegKopf.Uebernahme */

    end. /* if available V_BelegKopf then do on error undo, throw */

    &IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
    if gluQuoteVersioning
      and not can-find(first VC_InterBelegKopf
                         where VC_InterBelegKopf.Firma       = {firma/s_kunde.fir  pACConnectionSvc:prpcCompany}
                           and VC_InterBelegKopf.Interessent = V_BelegKopf.Interessent
                           and VC_InterBelegKopf.BelegArt    = V_BelegKopf.BelegArt
                           and VC_InterBelegKopf.ReferenzNr  = V_BelegKopf.ReferenzNr) then
    do:

      find first buVC_InterBelegKopf
        where buVC_InterBelegKopf.Firma       = {firma/s_kunde.fir  pACConnectionSvc:prpcCompany}
          and buVC_InterBelegKopf.Interessent = Buf_V_BelegKopf.Interessent
          and buVC_InterBelegKopf.BelegArt    = Buf_V_BelegKopf.BelegArt
          and buVC_InterBelegKopf.ReferenzNr  = Buf_V_BelegKopf.ReferenzNr
        no-lock no-error.

      find first buVC_InterAktivitaet
        where buVC_InterAktivitaet.Firma       = {firma/s_kunde.fir pa-firma}
          and buVC_InterAktivitaet.Interessent = buVC_InterBelegKopf.Interessent
          and buVC_InterAktivitaet.VertAktNr   = buVC_InterBelegKopf.VertAktNr
        no-lock no-error.

      if    available buVC_InterBelegKopf
        and available buVC_InterAktivitaet then
      do:

        vert.crm.cls.VCCCustRelManSvc:prpoInstance:cAssignQuoteToSalesProject(V_BelegKopf.V_BelegKopf_Obj,
                                                                              buVC_InterAktivitaet.VC_InterAktivitaet_Obj).

        vert.crm.cls.VCCCustRelManSvc:prpoInstance:lAssignQuoteResultQuoteVersioning(V_BelegKopf.V_BelegKopf_Obj).

      end. /* if    available buVC_InterBelegKopf */

    end. /* if gluQuoteVersioning */
    &ENDIF

    catch oError as Progress.Lang.Error:

      run set-attribute-list ('ADM-NEW-RECORD=no':U).
      return 'adm-error':U.

    end catch.

  end. /* Add-Trans */

  &IF lookup('S_XRechnung':U,"{&PA-OPTIONEN}":U) > 0 &THEN

    /* Belegübernahme für die XRechnung.                         */
    /* Wenn der alte Belegkopf eine Leitweg-ID zugewiesen hatte, */
    /* übernimmt diese auch der neue Beleg.                      */

    find bV_BelegKopf-Source
      where bV_BelegKopf-Source.Firma      = V_BelegKopf.Firma
        and bV_BelegKopf-Source.BelegArt   = V_BelegKopf.Herk_BelegArt
        and bV_BelegKopf-Source.ReferenzNr = V_BelegKopf.Herk_ReferenzNr 
      no-lock no-error.

    if available bV_BelegKopf-Source then

      cRouteID = vert.fakt.cls.VFCXInvoiceSvc:prpoInstance:cGetRouteId(bV_BelegKopf-Source.V_BelegKopf_Obj).

    if cRouteID > '':U then

      vert.fakt.cls.VFCXInvoiceSvc:prpoInstance:saveRouteId(cRouteId,
                                                            V_BelegKopf.V_BelegKopf_Obj).

  &ENDIF

  /* den Ursprungsbeleg loslassen */

  release Buf_V_BelegKopf.
  release Buf_V_BelegPos.

  /* damit Query für die Adressen, den richtigen Satz bekommt */

  run notify ('row-available,record-target':U).

  run notify ('add-record, GROUP-ASSIGN-TARGET':U).

  if return-value = 'ADM-ERROR':U then
  do:

    run dispatch in this-procedure ('cancel-record':U).
    return 'ADM-ERROR':U.

  end.

  /* Display any fields assigned by CREATE. */
  /* MUSS NACH ADD-RECORD erfolgen, da ansonsten alte Werte angezeigt werden!! */

  glAdd = yes.

  run dispatch ('enable-fields':U).

  if return-value <> 'adm-error':u then
  do:

    glAdd = no.

    run new-state('update':U).   /* Signal that we're in a record update now. */

    run dispatch in this-procedure ('apply-entry':U).

    if vert.base.cls.VBCPolandHungarySpecialsSvc:prpoInstance:lIsACancellingInvoice_P
         (buffer V_BelegKopf) then
    do:

      run dispatch in this-procedure ('end-update':U).

      if return-value = 'adm-error':U then
        return 'adm-error':U.

    end. /* if lIsACancellingInvoice_P ... */

    else if vert.base.cls.VBCPolandHungarySpecialsSvc:prpoInstance:lIsACancellingInvoice_H
           (buffer V_BelegKopf) then
    do:

      run dispatch in this-procedure ('assign-record':U).

      if return-value = 'ADM-ERROR':U then
        return 'ADM-ERROR':U.
        
      run dispatch in this-procedure ('end-update':U).

      if return-value = 'ADM-ERROR':U then
        return 'ADM-ERROR':U.

    end. /* if lIsACancellingInvoice_H(..) */

  end. /* return-value <> 'adm-error' */

  else
  do:

    /* ein ggf. archiviertes Angebot wieder öffnen */

    if cBelegart       =  'U':U
      and cSatzId      <> ?
      and cSatzId_neu  <> ?
      and lOK          =  yes then Angebot:
      do transaction
      on error undo, return 'adm-error':U:

      find Buf_V_BelegKopf
        where rowid(Buf_V_BelegKopf) = to-rowid(cSatzId)
        exclusive-lock no-error.

      if     available Buf_V_BelegKopf
         and Buf_V_BelegKopf.Belegart = 'A':U then
      do:

        for each Buf_V_BelegPos
          where Buf_V_BelegPos.Firma      = Buf_V_BelegKopf.Firma
            and Buf_V_BelegPos.Belegart   = Buf_V_BelegKopf.Belegart
            and Buf_V_BelegPos.ReferenzNr = Buf_V_BelegKopf.ReferenzNr
          exclusive-lock
          on error undo Angebot, return 'adm-error':U:

          Buf_V_BelegPos.offen = yes.
          validate Buf_V_BelegPos.

        end.

        Buf_V_BelegKopf.offen = yes.
        validate Buf_V_BelegKopf.

      end.

    end.

  end. /* Fehlerfall */

  if   glZuschlag_sperren
    or lSchlussrechnung = yes then

    run new-state('Zuschlag,record-target':U).

end. /* do on error undo, return 'adm-error':U */

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Beleguebernahme V-table-Win 
PROCEDURE Beleguebernahme :
/*------------------------------------------------------------------------------
  Purpose:     Start der Belegübernahmefunktion (normale Vertriebbelege)
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

define variable lTempMLL as logical init no no-undo.

do on error undo, throw:

  glZuschlag_sperren = no.

  /* Check first if the current user has creation rights to this documenttype.*/

  run check-record ('create':U).
  
  case cBelegart:

    /* Belegübernahme Angebot --> Angebot ------------------------------------*/

    when 'A':U then

        run Adopting(cBelegart).

    /* Belegübernahme Angebot/Auftrag --> Auftrag ----------------------------*/

    when 'U':U then

      run AdoptToOrder.

    /* Belegübernahme Auftrag/Proformarechnung --> Lieferschein --------------*/

    when 'L':U then

      run AdoptToShippingDocument.

    /* Belegübernahme Auftrag/Gutschrift --> Rechnung ------------------------*/

    when 'R':U then

      run AdoptToInvoice.

    /* Belegübernahme Angebot/Auftrag/Lieferschein --> Proformarechnung ------*/

    when 'VFP':U then

      run AdoptToProFormaInvoice.

    /* Belegübernahme archivierte Rechnung --> Gutschrift --------*/

    when 'G':U then

      run AdoptToCredit.

    /* Belegübernahme Angebot --> Rahmenauftrag ----------------------------*/

    when 'VUR':U then

      run AdoptToBlanketOrder.

    /* Belegübernahme Angebot/Auftrag --> Demo-Lieferschein ------*/

    when 'VUD':U then

      run AdoptToDemoShippingDocument.

  end case.

  if    not return-value                  = 'Abbruch':U
    and pACConnectionSvc:prpcLocalization = 'P':U
    and available V_BelegKopf
    and V_BelegKopf.P_SplitPayment        = yes then
    adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
      ('s_splp0002':U).

  /* Aufruf Übernahmefunktion MLL nach L - wird später benötigt */

  if lTempMLL = yes then

    run Beleguebernahme_MLL.

end. /* transaction */

return.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Beleguebernahme_Auftragsposition V-table-Win 
PROCEDURE Beleguebernahme_Auftragsposition :
/*------------------------------------------------------------------------------
  Purpose:     Start der Belegübernahmefunktion (normale Vertriebbelege)
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

define variable cSatzIdRechnung as character no-undo.

define buffer Buf_V_BelegKopf for V_BelegKopf.

do on error undo, return error:

  if available V_BelegKopf then
  do:

    assign
      glZuschlag_sperren = yes
      cSatzId            = ?
      cSatzIdRechnung    = string(rowid(V_BelegKopf))
      .

    if cBelegart = 'R':U then
    do:

      /* --> UMO# LM2 Belegübernahme: Laufzeitfehler 132 */
      &IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
      if adm.config.cls.DCCAppConfigSvc:prpoInstance:lParameterValue('UCI_CollectiveShipment':U) then
        adm.method.cls.DMCMessageSvc:prpoInstance:showError('uvsam000002':U).
      &ENDIF
      /* <-- UMO# LM2 Belegübernahme: Laufzeitfehler 132 */

      /* Belegübernahme Auftragspositionen --> Rechnung ----------------------*/

      /* keine Sammelrechnungen */

      if can-find (first Buf_V_BelegPos
                     where Buf_V_BelegPos.Firma      = V_BelegKopf.Firma
                       and Buf_V_BelegPos.Belegart   = V_BelegKopf.Belegart
                       and Buf_V_BelegPos.ReferenzNr = V_BelegKopf.ReferenzNr
                       and Buf_V_BelegPos.LfdNr_SR   > 0) then
      do:

        {adm/incl/d__msg00.if
          &Meldung = "'v_bel00300':U"
          &Liste   = "string(input frame {&frame-name} V_BelegKopf.Belegnummer)"
        }

        return 'Abbruch':U.

      end.

      /* die Rechnung ist aus einem Auftrag bzw. mit dem Zwischenschritt      */
      /* Lieferschein entstanden                                              */

      if V_BelegKopf.AuftragsNr > 0 then
      do:

        find first Buf_V_BelegKopf               /* suche den offenen Auftrag */
          where Buf_V_BelegKopf.Firma       = V_BelegKopf.Firma
            and Buf_V_BelegKopf.Belegart    = 'U':U
            and Buf_V_BelegKopf.offen       = yes
            and Buf_V_BelegKopf.Belegnummer = V_BelegKopf.AuftragsNr
          no-lock no-error.

        if not available Buf_V_BelegKopf then
        do:

          {adm/incl/d__msg00.if
            &Meldung = "'v_bel00301':U"
            &Liste   = "string(input frame {&frame-name} V_BelegKopf.Belegnummer)"
          }

          return 'Abbruch':U.

        end.

        else

          cSatzId = string(rowid(Buf_V_BelegKopf)).

      end. /* if V_BelegKopf.LieferscheinNr > 0 */

      if   cSatzId = ?
        or cSatzId = '':U then
      do:

        {adm/incl/d__msg00.if
          &Meldung = "'v_bel00302':U"
          &Liste   = "string(input frame {&frame-name} V_BelegKopf.Belegnummer)"
        }

        return 'Abbruch':U.

      end.

      /* Positionsbearbeitung                                                 */
      /*                    nur offenen Auftragspositionen, die es noch nicht */
      /*                    in dieser Rechnung gibt                           */

      run vert/proc/v_pbel20.w (input-output cTmp,
                                             'U':U,
                                             'R':U,
                                             cSatzId,
                                             Buf_V_BelegKopf.Kunde,
                                             0,
                                             ?,
                                             no,
                                             cSatzIdRechnung,
                                             no,            /* new proceeding */
                                      output cSatzId_neu,
                                      output glZuschlag_sperren,
                                input-output table ttVBT_DocumentLines-NEW bind,
                                input-output table ttVBT_SalesBOM-NEW bind).

      if   cSatzId_neu = ?
        or cSatzId_neu = '':U then

        return 'Abbruch':U.

      glZuschlag_sperren = yes.

      run new-state ('pole-position,record-target':U).

    end.  /* if cBelegart = 'R':U */

    if cBelegart = 'L':U then
    do:

      /* --> UMO# LM2 Belegübernahme: Laufzeitfehler 132 */
      &IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
      if not branche.vert.cls.UVC_CISalesDocumentSvc:prpoInstance:lAreOrderlinesAdoptableToDeliverynote(V_BelegKopf.V_BelegKopf_Obj) then
        adm.method.cls.DMCMessageSvc:prpoInstance:showError('uvsam000001':U).

      &ENDIF
      /* <-- UMO# LM2 Belegübernahme: Laufzeitfehler 132 */

      /* Belegübernahme Auftragspositionen --> Lieferschein ------------------*/

      if can-find(first V_BelegPos
                  where V_BelegPos.Firma         = V_BelegKopf.Firma
                    and V_BelegPos.Belegart      = V_BelegKopf.Belegart
                    and V_BelegPos.ReferenzNr    = V_BelegKopf.ReferenzNr
                    and V_BelegPos.Herk_BelegArt = 'MLE':U) then

        adm.method.cls.DMCMessageSvc:prpoInstance:showError
          ('v_bel00315':U,
           string(input frame {&frame-name} V_BelegKopf.Belegnummer)).

      /* der Lieferschein ist aus einem Auftrag entstanden                    */

      if V_BelegKopf.Herk_Belegart = 'U':U then
      do:

        find first Buf_V_BelegKopf               /* suche den offenen Auftrag */
          where Buf_V_BelegKopf.Firma       = V_BelegKopf.Firma
            and Buf_V_BelegKopf.Belegart    = 'U':U
            and Buf_V_BelegKopf.offen       = yes
            and Buf_V_BelegKopf.Belegnummer = V_BelegKopf.AuftragsNr
          no-lock no-error.

        if not available Buf_V_BelegKopf then

          adm.method.cls.DMCMessageSvc:prpoInstance:showError
            ('v_bel00303':U,
             string(input frame {&frame-name} V_BelegKopf.Belegnummer),
             string(V_BelegKopf.AuftragsNr)).

        else

          cSatzId = string(rowid(Buf_V_BelegKopf)).

      end.  /* if V_BelegKopf.AuftragsNr > 0 */

      if   cSatzId = ?
        or cSatzId = '':U then

        adm.method.cls.DMCMessageSvc:prpoInstance:showError
          ('v_bel00304':U,
           string(input frame {&frame-name} V_BelegKopf.Belegnummer)).

      /* Positionsbearbeitung                                                */
      /*                   nur offenen Auftragspositionen, die es noch nicht */
      /*                   in diesem Lieferschein gibt                       */

      run vert/proc/v_pbel20.w (input-output cTmp,
                                             'U':U,
                                             'L':U,
                                             cSatzId,
                                             Buf_V_BelegKopf.Kunde,
                                             0,
                                             ?,
                                             no,
                                             cSatzIdRechnung,
                                             no,            /* new proceeding */
                                      output cSatzId_neu,
                                      output glZuschlag_sperren,
                                input-output table ttVBT_DocumentLines-NEW bind,
                                input-output table ttVBT_SalesBOM-NEW bind).

      if   cSatzId_neu = ?
        or cSatzId_neu = '':U then

        return 'Abbruch':U.

      glZuschlag_sperren = yes.

      run new-state ('pole-position,record-target':U).

    end. /* if cBelegart = 'L':U */

  end. /* if available V_BelegKopf */

end. /* transaction */

return.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BesteuerungAendern V-table-Win 
PROCEDURE BesteuerungAendern :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/*  Change taxation base for document (e.g. tax free)                         */
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

define variable cTemp                as   character                             no-undo.
define variable cTaxationFields      as   character                             no-undo.
define variable cTaxTerritory_Dept   like SBM_TaxTerritory.SBM_TaxTerritory_Obj no-undo.
define variable cTaxTerritory_Dest   like SBM_TaxTerritory.SBM_TaxTerritory_Obj no-undo.
define variable cTaxCountryStructure like V_BelegKopf.Tax_SBM_TaxTerritory_Obj  no-undo.

/* Buffers -------------------------------------------------------------------*/

define buffer bV_BelegKopf    for V_BelegKopf.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

if   not available V_BelegKopf
  or V_BelegKopf.offen = no then

  adm.method.cls.DMCMessageSvc:prpoInstance:showError('vsser00118':U).

find bV_BelegKopf
  where bV_BelegKopf.V_BelegKopf_Obj = V_BelegKopf.V_BelegKopf_Obj
  exclusive-lock no-wait no-error.

if    not available bV_BelegKopf
  and locked(bV_BelegKopf) then

  pACConnectionSvc:showRecordLockedMessage('V_BelegKopf':U, recid(V_BelegKopf)).

/* check if it is allowed to change the tax properties before calling this procedure*/

basis.buro.cls.BBCWorkflowSvc:prpoInstance:showLockStatus
  (bV_BelegKopf.V_BelegKopf_Obj,
   cBereich).

/* if we are only allowed to change the doc. date in the dialog then this will       */
/* have no effects on the tax determination (e.g. in an invoice for a shipping note) */

if vert.base.cls.VBCSalesTaxSvc:prpoInstance:lOnlyChangeDocDateAllowed
     (buffer bV_BelegKopf) = yes then

  run vert/proc/v_pbel16.w(input-output cTemp,
                           input        bV_BelegKopf.V_BelegKopf_Obj,
                           input        yes,              /* only field doc. date is allowed to change */
                           output       cTaxationFields,
                           output       cTaxTerritory_Dept,
                           output       cTaxTerritory_Dest,
                           output       cTaxCountryStructure).

else

  /* the 2nd parameter of lChangeTaxParameterAllowed says that we want to see */
  /* the error messages                                                       */

  if vert.base.cls.VBCSalesTaxSvc:prpoInstance:lChangeTaxParameterAllowed
       (bV_BelegKopf.V_BelegKopf_Obj,
        yes) = yes then

    run vert/proc/v_pbel16.w(input-output cTemp,
                             input        bV_BelegKopf.V_BelegKopf_Obj,
                             input        no,               /* all fields can be changed */
                             output       cTaxationFields,
                             output       cTaxTerritory_Dept,
                             output       cTaxTerritory_Dest,
                             output       cTaxCountryStructure).

run dispatch in THIS-PROCEDURE ('row-available':U).

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Bestimmungsorte V-table-Win 
PROCEDURE Bestimmungsorte :
/*------------------------------------------------------------------------------
  Purpose:     Aufruf des Programms zur Erfassung und Pflege von Bestimmungsorten
               in Abhängigkeit der Lieferadresse zum Abrufauftrag
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

define variable cString as character no-undo.

Main:
do on error undo Main, return error:

  &IF "{&pa_S_IncoTerm}":U = "1":U &THEN

    if V_BelegKopf.Belegart = 'VUA':U then

      run vert/auf/proc/vuport00.w (input-output cString,
                                                 V_BelegKopf.Belegart,
                                                 V_BelegKopf.ReferenzNr).

  &ENDIF

end.

return.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&IF DEFINED(EXCLUDE-cancelNumberAssignment) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelNumberAssignment Method-Library
procedure cancelNumberAssignment :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Flag number in number log as "cancelled"                                   */
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

if    adm-new-record           = yes
  and available V_BelegKopf
  and {fnarg
        pa_lNumRgIsUnique
        "V_BelegKopf.Firma,
         V_BelegKopf.BelegArt} = yes
  and lCancel                  = no
  and lSpeichern               = no then
do:

  if {fnarg
        pa_lNumRgLogCancel
        "V_BelegKopf.Firma,
         V_BelegKopf.BelegArt,
         V_BelegKopf.Belegnummer"} <> yes then

    return 'ADM-ERROR':U.

  /* avoid call of pa_lNumRgLogDelete in v_belkod.p */

  V_BelegKopf.BelegNummer = 0.

end.

end procedure. /* cancelNumberAssignment */


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ChangeDate V-table-Win 
PROCEDURE ChangeDate :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Change date of document                                                    */
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
define variable cTemp as character no-undo.

/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/
define buffer bV_BelegKopf    for V_BelegKopf.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

find bV_BelegKopf
  where bV_BelegKopf.V_BelegKopf_Obj = V_BelegKopf.V_BelegKopf_Obj
  exclusive-lock no-wait no-error.

if available bV_BelegKopf then
  run vert/fakt/proc/vfpdat00.w(input        bV_BelegKopf.V_BelegKopf_Obj,
                                input-output cTemp).

run dispatch in this-procedure ('row-available':U).

end procedure. /* ChangeDate */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CheckDestTerrStructureChange V-table-Win 
PROCEDURE CheckDestTerrStructureChange :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/*  check if the address of an once-only-customer has been changed with the   */
/*  effect that we have another destination address territory structure       */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/*  this is the menu-item postprocessing for mi_Adresse and is only relevant  */
/*  for the once-only-customer (Extras - Adresse)                             */
/*  If the document has already a delivery address then this delivery address */
/*  has priority, if not then we have to perform a new tax determination      */
/*  (will be done by the trigger if the territory structure changes)          */
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
/* cCountryIso_Dest            ISO alpha 2 code of destination country        */
/* cCommunityObj               community of states object id                  */
/* cTerritoryStructure_Dest    tax territory structure extent of destination  */
/*----------------------------------------------------------------------------*/

define variable cCountryIso_Dest         like SBM_TaxTerritory.IsoAlpha2Code        no-undo.
define variable cCommunityObj            like SBM_ComOfStates.SBM_ComOfStates_Obj   no-undo.
define variable cTerritoryStructure_Dest like V_BelegKopf.Dest_SBM_TaxTerritory_Obj no-undo.
define variable cCountry                 like S_Adresse.Staat           no-undo.
define variable cState                   like S_Adresse.Bundesland      no-undo.
define variable cCity                    like S_Adresse.Ort             no-undo.
define variable cZIPCode                 like S_Adresse.PLZ             no-undo.
define variable iAddrNo                  like S_Adresse.AdressNr        no-undo.
define variable cTargetISOCountry        like S_Staat.IsoAlpha2Code     no-undo.
define variable cTaxIDTargetCountry      like V_BelegKopf.TaxID         no-undo.
define variable lProspect                as   logical                   no-undo.

/* Buffers -------------------------------------------------------------------*/

define buffer bV_BelegKopfAdr for V_BelegKopfAdr.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

if glUpdate = yes then
do:

  /* at this point V_BelegKopf is always available and in exclusive-lock */

  find ttS_Adresse
    no-error.

  if available ttS_Adresse then
  do:

    /* at this point the document for the once-only-customer has already an   */
    /* address of type 'K', this has been done in local-add-record            */
    /* V_BelegKopfAdr record must be updated now(!), in assign-statement it   */
    /* would be too late otherwise we could not find the correct address if   */
    /* someome enters a delivery address                                      */

    find bV_BelegKopfAdr
      where bV_BelegKopfAdr.Firma      = V_BelegKopf.Firma
        and bV_BelegKopfAdr.Belegart   = V_BelegKopf.Belegart
        and bV_BelegKopfAdr.ReferenzNr = V_BelegKopf.ReferenzNr
        and bV_BelegKopfAdr.Typ        = 'K':U
      exclusive-lock.

    buffer-copy
      ttS_Adresse
      except
        Anlagebenutzer
        Anlagedatum
        Anlagezeit
        Aenderungbenutzer
        Aenderungdatum
        Aenderungzeit
        Firma
      to bV_BelegKopfAdr.

    validate bV_BelegKopfAdr.

    /* if the document has already a delivery address then changing the 'K'    */
    /* address does not have any effects on the document's destination address */
    /* territory structure because the delivery address has priority           */

    if not can-find(V_BelegKopfAdr
                      where V_BelegKopfAdr.Firma      = V_BelegKopf.Firma
                        and V_BelegKopfAdr.Belegart   = V_BelegKopf.Belegart
                        and V_BelegKopfAdr.ReferenzNr = V_BelegKopf.ReferenzNr
                        and V_BelegKopfAdr.Typ        = 'L':U) then
    do:

      /* at this point V_BelegKopf.Dest_SBM_TaxTerritory_Obj has been determined */
      /* in the trigger by customer's or prospect's master data. But it is       */
      /* possible that another address or even another country with a different  */
      /* structure has been entered in the address viewer.                       */
      /* determine the new territory structure of the destination address and compare it with the old one */

      cTaxIDTargetCountry = V_BelegKopf.TaxID.

      if V_BelegKopf.Versendung = no then
      do:  

        /* here we first need the geographical target country (without consideration       */
        /* of shipping) to search for a tax number.                                        */
        /* The existence of a tax number is important for TaxRelTargetAddressDetailsForDoc */
        /* for determining the destination address (b2b/b2c)                               */    

        assign
          cTargetISOCountry = stamm.base.cls.SBCTaxMasterFilesSvc:prpoInstance:cTargetISOCountryForDoc(V_BelegKopf.V_BelegKopf_Obj)
          &IF lookup ("VC","{&PA-MODULE}") > 0 &THEN
          lProspect         = (    V_BelegKopf.Interessent > 0
                               and can-find(S_Kunde
                                              where S_Kunde.Firma    = {firma/s_kunde.fir V_BelegKopf.Firma}
                                                and S_Kunde.Kunde    = V_BelegKopf.Kunde
                                                and S_Kunde.AdressNr = 0))
          &ENDIF      
          .

        if V_BelegKopf.TaxIDType  = {&pa_SB_TaxIDType_UStID} then

          cTaxIDTargetCountry = stamm.base.cls.SBCTaxMasterFilesSvc:prpoInstance:cDefaultBPSalesTaxIDOfCountry((if lProspect = yes then   
                                                                                                                  {&pa_S_ContactTaxID}
                                                                                                                else                      
                                                                                                                  {&pa_S_CustomerTaxID}),
                                                                                                               (if lProspect = yes then   
                                                                                                                  V_BelegKopf.Interessent
                                                                                                                else                      
                                                                                                                  V_BelegKopf.Kunde),
                                                                                                               cTargetISOCountry).

      end. /* if V_BelegKopf.Versendung = no */

      /* at this point V_BelegKopfAdr could have been deleted.                     */
      /* check if the destination tax territory structure has been changed, it     */
      /* can come out of a delivery address or of customer's master data, it might */
      /* be necessary to perform a new tax determination if it has been changed    */

      stamm.base.cls.SBCTaxMasterFilesSvc:prpoInstance:TaxRelTargetAddressDetailsForDoc
        (       V_BelegKopf.V_BelegKopf_Obj,
                cTaxIDTargetCountry,         /* pcTaxID: is only used if plshipping = no */
                V_BelegKopf.Versendung,      /* plShipping */       
         output cCountry,
         output cState,
         output cCity,
         output cZIPCode,
         output iAddrNo).

      assign
        cCountryIso_Dest         = {fnarg
                                     pa_cInternalStateCodeToIsoAlpha2Code
                                     "cCountry"}
        cCommunityObj            = stamm.base.cls.SBCTaxMasterFilesSvc:prpoInstance:cTaxRelCommunityOfTransaction
                                     (stamm.base.cls.SBCTaxMasterFilesSvc:prpoInstance:cIsoAlphaCodeOfTaxTerritory
                                        (V_BelegKopf.Dept_SBM_TaxTerritory_Obj[{&pa_SB_TaxTerritoryExt_Country}]),
                                      cCountryIso_Dest,
                                      V_BelegKopf.BelegDatum)
        cTerritoryStructure_Dest = stamm.base.cls.SBCTaxMasterFilesSvc:prpoInstance:cTerritoryStrExtentForAdressDetails
                                     (V_BelegKopf.BelegDatum,
                                      cCountry,
                                      cState,
                                      cCity,
                                      cZIPCode,
                                      iAddrNo)
        /* do not overwrite the 1st extent if it represents an US tax code (written by cTerritoryStrExtentForAdressDetails) */
        cTerritoryStructure_Dest[{&pa_SB_TaxTerritoryExt_Community}] = cCommunityObj when not (    pACConnectionSvc:prpcLocalization = 'USA':U
                                                                                               and cCountryIso_Dest                  = {&pa_SB_SalesTaxCountry})
        .

      if stamm.base.cls.SBCTaxMasterFilesSvc:prpoInstance:lTaxTerritoryExtentsAreEqual
           (cTerritoryStructure_Dest,
            V_BelegKopf.Dest_SBM_TaxTerritory_Obj) = no then

        if V_BelegKopf.steuerfrei_Ausnahme = no then

          vert.base.cls.VBCSalesTaxSvc:prpoInstance:ChangeDocDestTerritoryStructure
            (V_BelegKopf.V_BelegKopf_Obj,
             cTerritoryStructure_Dest).

        else

          /* if exception is active, then we do not automatically overwrite the        */
          /* destination address structure because it might have been manually changed */

          adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
            ('v_bel00046':U,
             string(V_BelegKopf.BelegNummer)).

    end.

    /* refresh all viewers */

    run notify('row-available,record-target':U).

  end. /* if available ttS_Adresse */

end. /* if glUpdate = yes then */

end procedure. /* CheckDestTerrStructureChange */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ClearAdoptingTempTables V-table-Win 
PROCEDURE ClearAdoptingTempTables :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Empties the temp-tables ttVBT_DocumentHeaders-NEW, ttVBT_DocumentLines-NEW */
/* and ttVBT_SalesBOM-NEW.                                                    */
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

empty temp-table ttVBT_DocumentHeaders-NEW.
empty temp-table ttVBT_DocumentLines-NEW.
empty temp-table ttVBT_SalesBOM-NEW.

end procedure. /* ClearAdoptingTempTables */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CustomersDeclaration V-table-Win 
PROCEDURE CustomersDeclaration :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Start transfer records to external system for ATLAS                        */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* pcPKS - PKS (selected menu item mode)                                      */
/*                                                                            */
/* Examples ------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/*----------------------------------------------------------------------------*/

define input parameter pcPKS as character no-undo.

/* Variables -----------------------------------------------------------------*/
/* cOptions       List with details of current invoice                        */
/* iMenuItemMode  Selected menu item mode                                     */
/*----------------------------------------------------------------------------*/

define variable cOptions      as character no-undo.
define variable iMenuItemMode as integer   no-undo.

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

Main:
do on error undo Main, leave Main:

  &IF lookup("M_ATLAS","{&PA-OPTIONEN}") > 0 &THEN

    iMenuItemMode = adm.method.cls.DMCParameterStringSvc:iReadValue
                      (pcPKS,
                       'MenuItem':U,
                       1).

    if    available V_BelegKopf
      and can-do('R,VFP':U,V_BelegKopf.Belegart)
      and pa-fields-enabled = no
      and stamm.base.cls.SBCLocalApplicationSvc:prpoInstance:lCheckModulsAndOptionsAtlas(no) then
    do:

      {adm/incl/d__par00.if
        &ParameterListe = "cOptions"
        &Parameter      = "&Belegart"
        &Variable1      = "V_BelegKopf.Belegart"
        &Variable2      = "V_BelegKopf.Belegart"
      }

      {adm/incl/d__par00.if
        &ParameterListe = "cOptions"
        &Parameter      = "Belegnummer"
        &Variable1      = "V_BelegKopf.Belegnummer"
        &Variable2      = "V_BelegKopf.Belegnummer"
      }

      {adm/incl/d__par00.if
        &ParameterListe = "cOptions"
        &Parameter      = "Kunde"
        &Variable1      = "V_BelegKopf.Kunde"
        &Variable2      = "V_BelegKopf.Kunde"
      }

      {adm/incl/d__par00.if
        &ParameterListe = "cOptions"
        &Parameter      = "Belegdatum"
        &Variable1      = "V_BelegKopf.Belegdatum"
        &Variable2      = "V_BelegKopf.Belegdatum"
      }

      {adm/incl/d__par00.if
        &ParameterListe = "cOptions"
        &Parameter      = "MenuItem"
        &Variable1      = "iMenuItemMode"
      }

      run vert/fakt/proc/vf_atl00.w (cOptions).

      giCustDeclState = pa_iCustDeclGetDeclState (V_BelegKopf.Firma,
                                                  'V_BelegKopf':U,
                                                  {vert/incl/v_belko.sl &Tabelle = "V_BelegKopf"}).

      run notify ('display-fields,record-target':U).

    end. /* if available V_BelegKopf then */

  &ENDIF

  return.

end. /* Main */

return error.

end procedure. /* CustomersDeclaration */

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

  if can-do(pcFields,'V_BelegKopf.AuftragsArt':U) then
    if V_BelegKopf_AuftragsArt_Info:private-data <> V_BelegKopf.AuftragsArt:screen-value then
    do:

      if input frame {&Frame-Name} V_BelegKopf.AuftragsArt = '':U then

        assign
          {setwidgetattr
             "V_BelegKopf_AuftragsArt_Info"
             "private-data"
             "'':U"}
          {setwidgetattr
             "V_BelegKopf_AuftragsArt_Info"
             "screen-value"
             "'':U"}
          V_BelegKopf_AuftragsArt_Info
          .

      else
      do:

        V_BelegKopf_AuftragsArt_Info
          = {fnarg
              pa_cDyCchOrderTypeDesc
              "pa-Firma,
               input frame {&Frame-Name} V_BelegKopf.AuftragsArt,
               pa-Sprache"}.

        if V_BelegKopf_AuftragsArt_Info <> ? then
          {setwidgetattr
             "V_BelegKopf_AuftragsArt_Info"
             "private-data"
             "V_BelegKopf.AuftragsArt:screen-value"}.

        else
          assign
            {setwidgetattr
               "V_BelegKopf_AuftragsArt_Info"
               "private-data"
               "string(?)"}

            V_BelegKopf_AuftragsArt_Info = '':U
            .

        {setwidgetattr
           "V_BelegKopf_AuftragsArt_Info"
           "screen-value"
           "V_BelegKopf_AuftragsArt_Info"}.

      end.

    end.

  if can-do(pcFields,'V_BelegKopf.Sachbearbeiter':U) then
    if V_BelegKopf_Sachbearbeiter_Info:private-data <> V_BelegKopf.Sachbearbeiter:screen-value then
    do:

      if input frame {&Frame-Name} V_BelegKopf.Sachbearbeiter = '':U then

        assign
          {setwidgetattr
             "V_BelegKopf_Sachbearbeiter_Info"
             "private-data"
             "'':U"}
          {setwidgetattr
             "V_BelegKopf_Sachbearbeiter_Info"
             "screen-value"
             "'':U"}
          V_BelegKopf_Sachbearbeiter_Info
          .

      else
      do:

        V_BelegKopf_Sachbearbeiter_Info
          = {fnarg
              pa_cDyCchUserName
              "input frame {&Frame-Name} V_BelegKopf.Sachbearbeiter,
               {&pa_CchDesc}"}.

        if V_BelegKopf_Sachbearbeiter_Info <> ? then
          {setwidgetattr
             "V_BelegKopf_Sachbearbeiter_Info"
             "private-data"
             "V_BelegKopf.Sachbearbeiter:screen-value"}.

        else
          assign
            {setwidgetattr
                "V_BelegKopf_Sachbearbeiter_Info"
                "private-data"
                "string(?)"}

            V_BelegKopf_Sachbearbeiter_Info = '':U
          .

          {setwidgetattr
             "V_BelegKopf_Sachbearbeiter_Info"
             "screen-value"
             "V_BelegKopf_Sachbearbeiter_Info"}.


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
  Purpose:     DMS-Integration
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

&IF lookup('O_','{&PA-MODULE}') > 0 &THEN
  {arch/incl/o__oat20.if}
&ENDIF

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dms-send-wordtext V-table-Win 
PROCEDURE dms-send-wordtext :
/*------------------------------------------------------------------------------
  Purpose:     DMS-Integration
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

&IF lookup('O_','{&PA-MODULE}') > 0 &THEN
  {arch/incl/o__wbm20.if}
&ENDIF

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EDINachricht V-table-Win 
PROCEDURE EDINachricht :
/*------------------------------------------------------------------------------
  Purpose:     Rechnung an EDI-Schnittstelle zum Versenden übergeben
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

define variable cOptions as character no-undo.

Main:
do on error undo, return error:

  &IF  LOOKUP("SD","{&PA-MODULE}") > 0
    or LOOKUP("SO","{&PA-MODULE}") > 0 &THEN

    if available V_BelegKopf then
    do:

      /* --> UMO#CA2016-04-011 MOu Kommissionierung: Mischpaletten erlauben (Version 2) */
      &IF LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN
      define variable cuMMT_Picking_ID    as character         no-undo.
      define variable luMischpalette      as logical init no   no-undo.

      if V_BelegKopf.Belegart = 'L':U then
        mawi.base.cls.MMCPackagingSvc:prpoInstance:uCheckDocument (V_BelegKopf.Belegart,
                                                                   V_BelegKopf.V_BelegKopf_Obj,
                                                                   input-output cuMMT_Picking_ID,
                                                                         output luMischpalette).

      if luMischpalette = yes then
        /* Der Beleg enthält Mischpaletten über mehrere Lieferscheine. Das Senden per EDI ist nur über den Transportbeleg möglich. */
        adm.method.cls.DMCMessageSvc:prpoInstance:showError
          ('uvsen00006':U).
      &ENDIF
      /* <-- UMO#CA2016-04-011 MOu */

      {adm/incl/d__par00.if
        &ParameterListe = "cOptions"
        &Parameter      = "Belegnummer"
        &Variable1      = "V_BelegKopf.Belegnummer"
        &Variable2      = "V_BelegKopf.Belegnummer"
      }

      {adm/incl/d__par00.if
        &ParameterListe = "cOptions"
        &Parameter      = "Kunde"
        &Variable1      = "V_BelegKopf.Kunde"
        &Variable2      = "V_BelegKopf.Kunde"
      }

      {adm/incl/d__par00.if
        &ParameterListe = "cOptions"
        &Parameter      = "Belegdatum"
        &Variable1      = "V_BelegKopf.Belegdatum"
        &Variable2      = "V_BelegKopf.Belegdatum"
      }

      {adm/incl/d__par00.if
        &ParameterListe = "cOptions"
        &Parameter      = "&Belegart"
        &Variable1      = "V_BelegKopf.Belegart"
      }

      run vert/proc/v__edi00.w(cOptions).

      run notify ('display-fields,record-target':U).

    end. /* if available V_BelegKopf then */

  &ENDIF

end. /* Main */

return.

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
               and ttS_Adresse.AdressNr = V_BelegKopf.AdressNr"
}

return.

end procedure. /* find-internal-tables */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-AdrDesc V-table-Win 
PROCEDURE get-AdrDesc :
/*------------------------------------------------------------------------------
  Purpose:     Suche und liefere Infos zum Ansprechpartner
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

/* Suche Ansprechpartner abh. von VC */

{vert/incl/v_wbel00.if
  &cc_Buf_S_Ansprech = "yes"
  &NotAvailableKopf  = "return ?."
  &AvailableAns      = "if available S_Ansprech then
                          return 'Ansprechpartner':T30.
                        else
                          return 'Kunde':T30."
}


end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-AdrName V-table-Win 
PROCEDURE get-AdrName :
/*------------------------------------------------------------------------------
  Purpose:     Suche und liefere Infos zum Ansprechpartner
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

/* Suche Ansprechpartner abh. von VC */

{vert/incl/v_wbel00.if
  &cc_Buf_S_Ansprech = "yes"
  &NotAvailableKopf  = "return ?."
  &AvailableAns      = "if available S_Ansprech then
                          return S_Ansprech.Name."
  &Nachlauf          = "find V_BelegKopfAdr
                          where V_BelegKopfAdr.Firma      = V_BelegKopf.Firma
                            and V_BelegKopfAdr.Belegart   = V_BelegKopf.Belegart
                            and V_BelegKopfAdr.ReferenzNr = V_BelegKopf.ReferenzNr
                            and V_BelegKopfAdr.Typ        = 'K':U
                          no-lock no-error.
                          return (if available ttS_Adresse then
                                    ttS_Adresse.Name1
                                  else
                                    ?)."
}

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-Homepage V-table-Win 
PROCEDURE get-Homepage :
/*------------------------------------------------------------------------------
  Purpose:     Suche und liefere Infos über Homepage des Kunden
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

  return (if available ttS_Adresse then
            ttS_Adresse.Homepage
          else
            ?).

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-iSource V-table-Win 
PROCEDURE get-iSource :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Liefere den Kenner   ob Produktionsauftrag = 2                             */
/*                    oder Teileplanung       = 3                             */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/*  Versandstückliste                                                         */
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

&IF LOOKUP("U_CM":U,"{&PA-OPTIONEN}":U) > 0 &THEN

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

  return string(giSource).

&ENDIF

end procedure. /* get-iSource */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-NewRecord V-table-Win 
PROCEDURE get-NewRecord :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Let the toolbar know if we handle a new sales document                     */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/* Used for the following localizations:                                      */
/* - Italy (I)                                                                */
/* - Hungary (H)                                                              */
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

define variable tCreation as datetime no-undo.
define variable tNow      as datetime no-undo.

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

if   (pACConnectionSvc:prpcLocalization = 'H':U
        and can-do('R,VFP':U, V_BelegKopf.Belegart))    
  or (pACConnectionSvc:prpcLocalization = 'I':U
        and can-do('R,G':U, V_BelegKopf.Belegart)) then
do:

  assign
    tNow      = now
    tCreation = datetime(month(V_BelegKopf.Anlagedatum),
                         day(V_BelegKopf.Anlagedatum),
                         year(V_BelegKopf.Anlagedatum),
                         integer(substring(V_BelegKopf.Anlagezeit, 1, 2)),
                         integer(substring(V_BelegKopf.Anlagezeit, 4, 2)),
                         integer(substring(V_BelegKopf.Anlagezeit, 7, 2)))
    .

  if tNow - tCreation < {&pa_S_NewDocTimeTolerance} then        
    return 'yes':U.  

end.

end procedure. /* get-NewRecord */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-TAPI# V-table-Win 
PROCEDURE get-TAPI# :
/*------------------------------------------------------------------------------
  Purpose:     Suche und liefere Telefonnummer für TAPI-Funktion
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

/* Suche Ansprechpartner abh. von VC */

{vert/incl/v_wbel00.if
  &cc_Buf_S_Ansprech = "yes"
  &NotAvailableKopf  = "return ?."
  &AvailableAns      = "if available S_Ansprech then
                          return trim(  S_Ansprech.Telefon
                                        + {&PA-DELIMITER3}
                                        + S_Ansprech.Handy,
                                      {&PA-DELIMITER3})."
  &Nachlauf          = "find V_BelegKopfAdr
                          where V_BelegKopfAdr.Firma      = V_BelegKopf.Firma
                            and V_BelegKopfAdr.Belegart   = V_BelegKopf.Belegart
                            and V_BelegKopfAdr.ReferenzNr = V_BelegKopf.ReferenzNr
                            and V_BelegKopfAdr.Typ        = 'K':U
                          no-lock no-error.
                        if available V_BelegKopfAdr then
                          return V_BelegKopfAdr.Telefon.
                        else
                            return (if available ttS_Adresse then
                                      trim(replace(  ttS_Adresse.Telefon
                                                   + {&PA-DELIMITER3}
                                                     + ttS_Adresse.Handy
                                                   + {&PA-DELIMITER3}
                                                     + ttS_Adresse.AutoTelefon,
                                                 {&PA-DELIMITER3} + {&PA-DELIMITER3},
                                                 {&PA-DELIMITER3}),
                                         {&PA-DELIMITER3})
                                    else
                                      ?)."
}

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-ulNewDocument V-table-Win 
PROCEDURE get-ulNewDocument :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Liefere den Kenner ob neuer Beleg angelegt werden soll                     */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/* UMO#CM2017-05-001 tri Versandstückliste                                    */
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

&IF LOOKUP("U_CM":U,"{&PA-OPTIONEN}":U) > 0 &THEN

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

  return string(gluNewDocument).

&ENDIF

end procedure. /* get-ulNewDocument */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-uV_BelegKopf_Obj_Source V-table-Win 
PROCEDURE get-uV_BelegKopf_Obj_Source :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/*  Liefere den Quellbeleg                                                    */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/* UMO#CM2017-05-001 tri Versandstückliste                                    */
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

&IF LOOKUP("U_CM":U,"{&PA-OPTIONEN}":U) > 0 &THEN

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

  return gcuV_BelegKopf_Obj_Source.

&ENDIF

end procedure. /* get-uV_BelegKopf_Obj_Source */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-uV_BelegKopf_Obj_Target V-table-Win 
PROCEDURE get-uV_BelegKopf_Obj_Target :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/*  Liefere den Zielbeleg                                                     */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/* UMO#CM2017-05-001 tri Versandstückliste                                    */
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

&IF LOOKUP("U_CM":U,"{&PA-OPTIONEN}":U) > 0 &THEN

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

  return gcuV_BelegKopf_Obj_Target.

&ENDIF

end procedure. /* get-uV_BelegKopf_Obj_Target */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HChangeInvoiceState V-table-Win 
PROCEDURE HChangeInvoiceState :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* call comment dialog, then change invoice state                             */
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

define variable cTemp    as character     no-undo.
define variable cComment as character     no-undo.
define variable lIsOk    as logical       no-undo.
/* Buffers -------------------------------------------------------------------*/

define buffer bSBT_H_KOBAK_Doc for SBT_H_KOBAK_Doc.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

run vert/fakt/proc/vfpkobh1.w(input-output cComment,
                                    output lIsOk,
                              input-output cTemp).

if lIsOk then
do:

  /* As the menu item to this procedure is only activated, if the line is     */
  /* available, we load the buffer without no-error. If something changed in  */
  /* the meantime, we want a runtime error.                                   */

  find bSBT_H_KOBAK_Doc
    where bSBT_H_KOBAK_Doc.Owning_Obj = V_BelegKopf.V_BelegKopf_Obj
      and bSBT_H_KOBAK_Doc.InvoiceStatus = 3
    exclusive-lock.

  assign
    bSBT_H_KOBAK_Doc.InvoiceStatus  = 6 /* state: invoice was processed manually */
    bSBT_H_KOBAK_Doc.Comment        = cComment
    .

end.

return.

END PROCEDURE. /* HChangeInvoiceState */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HExportOszlaXMLs V-table-Win 
PROCEDURE HExportOszlaXMLs :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* export XML files form SBT_H_KOBAK_Doc                                      */
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

define variable lDoWriteFile          as logical       no-undo.
define variable lCanWriteLogFile      as logical       no-undo.
define variable iLogfileErrorCounter  as integer       no-undo.
define variable iNumberOfFilesToWrite as integer       no-undo.
define variable iNumberOfFilesWriten  as integer       no-undo.
define variable cExportPath           as character     no-undo.
define variable cExportPathInitial    as character     no-undo.
define variable cOutFileName          as character     no-undo.
define variable cLogFileName          as character     no-undo.
define variable cLogFileEntry         as character     no-undo format 'x(60)':U.
define variable cOutFileNameBase      as character     no-undo.


/* Buffers -------------------------------------------------------------------*/

define buffer bSBT_H_KOBAK_Doc for SBT_H_KOBAK_Doc.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  if adm.method.cls.DMCSkinClientSvc:prplIsSkinClient then
    assign
      cExportPathInitial = pACStartupSvc:cParameterValue('Temp':U)
      cExportPath        = cExportPathInitial
      .
  else
&ENDIF
  do:

    /* get last used path                                                     */
    cExportPathInitial = basis.user.cls.BUCUserPropertySvc:prpoInstance:cParameterValue
                           ({&pa_V_H_KOBAKExportDirPathKey}).

    /* system-dialog get-dir does not accept undefined value as initial-dir   */
    if cExportPathInitial = ? then
      cExportPathInitial = '':U.

    /* get path                                                               */
    {adm/incl/d__os_02.if
      &P_CHARACTER-FIELD = "cExportPath"
      &P_INITIAL-DIR     = "cExportPathInitial"
      &P_TITLE           = "'Auswahl Verzeichnis':T40"
    }

  end. /* else (if adm.method.cls.DMCSkinClientSvc:prplIsSkinClient) */

if    cExportPath <> ?
  and cExportPath <> '':U then
do:

  /* remember selected path                                                   */

  basis.user.cls.BUCUserPropertySvc:prpoInstance:setParameterValue
    ({&pa_V_H_KOBAKExportDirPathKey},
     cExportPath).

  find bSBT_H_KOBAK_Doc
    where bSBT_H_KOBAK_Doc.Owning_Obj = V_BelegKopf.V_BelegKopf_Obj
    no-lock.

  assign
    cExportPath           =   replace(cExportPath, {&PA-BACKSLASH}, '/':U)
                            + '/':U
    cOutFileNameBase      =   cExportPath
                            + pa-Firma
                            + '_':U
                            + string(V_BelegKopf.BelegNummer)
                            + '_':U
    cLogFileName          =   cOutFileNameBase
                            + 'log.txt':U
    iNumberOfFilesToWrite = 0
    iNumberOfFilesWriten  = 0
    .

  /* find a file name for the log file that is not read only                  */

  if System.IO.File:Exists(cLogFileName) then
  do:

    assign
      file-info:file-name = cLogFileName
      lCanWriteLogFile    = index(file-info:file-type, 'W':U ) > 0
      .

    do    while not lCanWriteLogFile
      and iLogfileErrorCounter < 10:

      assign
        iLogfileErrorCounter  = iLogfileErrorCounter + 1
        cLogFileName          =   cOutFileNameBase
                                + replace(replace(string(now, '99-99-9999 hh:mm:ss.sss':U), ':':U, '':U), ',':U, '':U)
                                + 'log.txt':U
        file-info:file-name   = cLogFileName
        lCanWriteLogFile      = index(file-info:file-type, 'W':U ) > 0
        .

    end. /* do while not lCanWriteLogFile and iLogfileErrorCounter < 10 */

  end. /* if System.IO.File:Exists(cOutFileName) */

  output stream logStream to value(cLogFileName).

  /* process InvoiceXML                                                       */

  cLogFileEntry = 'InvoiceXML: ':U.

  if length(bSBT_H_KOBAK_Doc.InvoiceXML) > 0 then
  do:

    assign
      cOutFileName          =   cOutFileNameBase
                              + 'InvoiceXML.xml':U
      iNumberOfFilesToWrite = iNumberOfFilesToWrite + 1
      lDoWriteFile          = yes
      .

    if System.IO.File:Exists(cOutFileName) then
    do:

      /* ask user if file should be overwritten                               */

      lDoWriteFile = adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
                       ('d_brw00001':U, cOutFileName).

      if lDoWriteFile then
      do:

        /* check if file is read-only                                         */

        file-info:file-name = cOutFileName.

        if not index(file-info:file-type, 'W':U ) > 0 then
          assign
            cLogFileEntry =   cLogFileEntry
                            + {&pa_V_H_KOBAKLogText_ExportNotWittenReadOnly}
            lDoWriteFile  = no
            .

      end. /* if lDoWriteFile */

      else
        cLogFileEntry = cLogFileEntry + {&pa_V_H_KOBAKLogText_ExportNotWitten}.

    end. /* if System.IO.File:Exists(cOutFileName) */

    if lDoWriteFile then
    do:

      /* write file                                                           */

      copy-lob bSBT_H_KOBAK_Doc.InvoiceXML to FILE cOutFileName no-error.

      if System.IO.File:Exists(cOutFileName) then
        assign
          cLogFileEntry         =   cLogFileEntry
                                  + {&pa_V_H_KOBAKLogText_ExportSuccessful}
          iNumberOfFilesWriten  = iNumberOfFilesWriten + 1
          .

      else
        cLogFileEntry =   cLogFileEntry
                        + {&pa_V_H_KOBAKLogText_ExportFail}.

    end. /* if lWriteFile then do */

  end. /* if length(SBT_H_KOBAK_Doc.InvoiceXML) > 0 */

  else
    cLogFileEntry =   cLogFileEntry
                    + {&pa_V_H_KOBAKLogText_ExportNoData}.

  put stream logStream cLogFileEntry skip.

  /* process LastRequest                                                       */

  cLogFileEntry = 'LastRequest: ':U.

  if length(bSBT_H_KOBAK_Doc.LastRequest) > 0 then
  do:

    assign
      cOutFileName          =   cOutFileNameBase
                              + 'LastRequest.xml':U
      iNumberOfFilesToWrite = iNumberOfFilesToWrite + 1
      lDoWriteFile          = yes
      .

    if System.IO.File:Exists(cOutFileName) then
    do:

      /* ask user if file should be overwritten                               */

      lDoWriteFile = adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
                       ('d_brw00001':U, cOutFileName).

      if lDoWriteFile then
      do:

        /* check if file is read-only                                         */

        file-info:file-name = cOutFileName.

        if not index(file-info:file-type, 'W':U ) > 0 then
          assign
            cLogFileEntry =   cLogFileEntry
                            + {&pa_V_H_KOBAKLogText_ExportNotWittenReadOnly}
            lDoWriteFile  = no
            .

      end. /* if lDoWriteFile */

      else
        cLogFileEntry =   cLogFileEntry
                        + {&pa_V_H_KOBAKLogText_ExportNotWitten}.

    end. /* if System.IO.File:Exists(cOutFileName) */

    if lDoWriteFile then
    do:

      /* write file                                                           */

      copy-lob bSBT_H_KOBAK_Doc.LastRequest to FILE cOutFileName no-error.

      if System.IO.File:Exists(cOutFileName) then
        assign
          cLogFileEntry         =   cLogFileEntry
                                  + {&pa_V_H_KOBAKLogText_ExportSuccessful}
          iNumberOfFilesWriten  = iNumberOfFilesWriten + 1
          .

      else
        cLogFileEntry =   cLogFileEntry
                        + {&pa_V_H_KOBAKLogText_ExportFail}.

    end. /* if lWriteFile */

  end. /* if length(SBT_H_KOBAK_Doc.LastRequest) > 0 */

  else
    cLogFileEntry =   cLogFileEntry
                    + {&pa_V_H_KOBAKLogText_ExportNoData}.

  put stream logStream cLogFileEntry skip.

  /* process ProcessingResponse                                               */

  cLogFileEntry = 'ProcessingResponse: ':U.

  if length(bSBT_H_KOBAK_Doc.ProcessingResponse) > 0 then
  do:

    assign
      cOutFileName          =   cOutFileNameBase
                              + 'ProcessingResponse.xml':U
      iNumberOfFilesToWrite = iNumberOfFilesToWrite + 1
      lDoWriteFile          = yes
      .

    if System.IO.File:Exists(cOutFileName) then
    do:

      /* ask user if file should be overwritten                               */

      lDoWriteFile = adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
                       ('d_brw00001':U, cOutFileName).

      if lDoWriteFile then
      do:

        /* check if file is read-only                                         */

        file-info:file-name = cOutFileName.

        if not index(file-info:file-type, 'W':U ) > 0 then
          assign
            cLogFileEntry =   cLogFileEntry
                            + {&pa_V_H_KOBAKLogText_ExportNotWittenReadOnly}
            lDoWriteFile  = no
            .

      end. /* if lDoWriteFile */
      else
        cLogFileEntry =   cLogFileEntry
                        + {&pa_V_H_KOBAKLogText_ExportNotWitten}.

    end. /* if System.IO.File:Exists(cOutFileName) */

    if lDoWriteFile then
    do:

      /* write file                                                           */

      copy-lob bSBT_H_KOBAK_Doc.ProcessingResponse to FILE cOutFileName no-error.

      if System.IO.File:Exists(cOutFileName) then
        assign
          cLogFileEntry         =   cLogFileEntry
                                  + {&pa_V_H_KOBAKLogText_ExportSuccessful}
          iNumberOfFilesWriten  = iNumberOfFilesWriten + 1
          .
      else
        cLogFileEntry =   cLogFileEntry
                        + {&pa_V_H_KOBAKLogText_ExportFail}.

    end. /* if lWriteFile */

  end. /* if length(SBT_H_KOBAK_Doc.ProcessingResponse) > 0 */

  else
    cLogFileEntry =   cLogFileEntry
                    + {&pa_V_H_KOBAKLogText_ExportNoData}.

  put stream logStream cLogFileEntry skip.

  /* process TransmissionResponse                                                       */

  cLogFileEntry = 'TransmissionResponse: ':U.

  if length(bSBT_H_KOBAK_Doc.TransmissionResponse) > 0 then
  do:

    assign
      cOutFileName          =   cOutFileNameBase
                              + 'TransmissionResponse.xml':U
      iNumberOfFilesToWrite = iNumberOfFilesToWrite + 1
      lDoWriteFile          = yes
      .

    if System.IO.File:Exists(cOutFileName) then
    do:

      /* ask user if file should be overwritten                               */

      lDoWriteFile = adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
                       ('d_brw00001':U, cOutFileName).

      if lDoWriteFile then
      do:

        /* check if file is read-only                                         */

        file-info:file-name = cOutFileName.

        if not index(file-info:file-type, 'W':U ) > 0 then
          assign
            cLogFileEntry =   cLogFileEntry
                            + {&pa_V_H_KOBAKLogText_ExportNotWittenReadOnly}
            lDoWriteFile  = no
            .

      end. /* if lDoWriteFile */

      else
        cLogFileEntry =   cLogFileEntry
                        + {&pa_V_H_KOBAKLogText_ExportNotWitten}.

    end. /* if System.IO.File:Exists(cOutFileName) */


    if lDoWriteFile then
    do:

      /* write file                                                           */

      copy-lob bSBT_H_KOBAK_Doc.TransmissionResponse to FILE cOutFileName no-error.

      if System.IO.File:Exists(cOutFileName) then
        assign
          cLogFileEntry         =   cLogFileEntry
                                  + {&pa_V_H_KOBAKLogText_ExportSuccessful}
          iNumberOfFilesWriten  = iNumberOfFilesWriten + 1
          .

      else
        cLogFileEntry =   cLogFileEntry
                        + {&pa_V_H_KOBAKLogText_ExportFail}.

    end. /* if lWriteFile */

  end. /* if length(SBT_H_KOBAK_Doc.TransmissionResponse) > 0 */

  else
    cLogFileEntry =   cLogFileEntry
                    + {&pa_V_H_KOBAKLogText_ExportNoData}.

  put stream logStream cLogFileEntry skip.

  adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
    ('v_belh1020':U, string(iNumberOfFilesWriten), string(iNumberOfFilesToWrite)).

end. /* if cExportPath <> '':U */

finally:

  output stream logStream close.

  /* SkinClient: transfer output file to download folder of browser           */

  {adm/incl/d__os_01.if
    &P_FILENAME-WITH-PATH   = "cOutFileName"
    &P_DELETE-WHEN-FINISHED = "yes"
  }

  {adm/incl/d__os_01.if
    &P_FILENAME-WITH-PATH   = "cLogFileName"
    &P_DELETE-WHEN-FINISHED = "yes"
  }

end.

END PROCEDURE. /* HExportOszlaXMLs */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HParamCancInvoice V-table-Win 
PROCEDURE HParamCancInvoice :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* call parameter dialog for cancelling/correcting invoices                   */
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

define variable iFormNo        like V_BelegKopf.FormularNr      no-undo.
define variable iNoOfCopies    like V_BelegKopf.FormularAnzahl  no-undo.
define variable tDocDate       like V_BelegKopf.BelegDatum      no-undo.
define variable tTaxDate       like V_BelegKopf.H_TaxDate       no-undo.
define variable tIntraDate     like V_BelegKopf.H_IntraDate     no-undo.
define variable tValueDate     like V_BelegKopf.ValutaDatum     no-undo.
define variable iPaymentTerm   like V_BelegKopf.ZahlungsZiel    no-undo.
define variable cDomesticTaxID like V_BelegKopf.H_DomesticTaxID no-undo.
define variable cDocument_Obj  like V_BelegKopf.V_BelegKopf_Obj no-undo.

/* Buffers -------------------------------------------------------------------*/

define buffer Buf_V_BelegKopf for V_BelegKopf.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

if    available V_BelegKopf
  and can-do ({&pa_V_h_NoUpdateAfterPrint},V_BelegKopf.Belegart)
  and V_BelegKopf.gedruckt = yes then

  adm.method.cls.DMCMessageSvc:prpoInstance:showError
    ('v_belh0007':U,
     V_BelegKopf.Belegnummer:screen-value in frame {&FRAME-NAME}).

assign
  iFormNo        = V_BelegKopf.FormularNr
  iNoOfCopies    = V_BelegKopf.FormularAnzahl
  tDocDate       = V_BelegKopf.BelegDatum
  tTaxDate       = V_BelegKopf.H_TaxDate
  tIntraDate     = V_BelegKopf.H_IntraDate
  tValueDate     = V_BelegKopf.ValutaDatum
  iPaymentTerm   = V_BelegKopf.ZahlungsZiel
  cDomesticTaxID = V_BelegKopf.H_DomesticTaxID
  cDocument_Obj  = V_BelegKopf.V_BelegKopf_Obj
  .

run vert/proc/v_pbelh0.w (input-output iFormNo,
                          input-output iNoOfCopies,
                          input-output tDocDate,
                          input-output cDomesticTaxID,
                          input        cDocument_Obj,
                          input-output tTaxDate,
                          input-output tIntraDate,
                          input-output tValueDate,
                          input-output iPaymentTerm,
                          input        (V_BelegKopf.H_InvoiceType = 1)).

  if   iFormNo        <> V_BelegKopf.FormularNr
    or iNoOfCopies    <> V_BelegKopf.FormularAnzahl
    or tDocDate       <> V_BelegKopf.BelegDatum
    or cDomesticTaxID <> V_BelegKopf.H_DomesticTaxID
    or tTaxDate       <> V_BelegKopf.H_TaxDate
    or tIntraDate     <> V_BelegKopf.H_IntraDate
    or tValueDate     <> V_BelegKopf.ValutaDatum
    or iPaymentTerm   <> V_BelegKopf.ZahlungsZiel then
  do transaction
  on error  undo, leave
  on endkey undo, leave:

  find Buf_V_BelegKopf
    where rowid(Buf_V_BelegKopf) = rowid(V_BelegKopf)
    exclusive-lock.

  assign
    Buf_V_BelegKopf.FormularNr      = iFormNo        when (iFormNo        <> V_BelegKopf.FormularNr)
    Buf_V_BelegKopf.FormularAnzahl  = iNoOfCopies    when (iNoOfCopies    <> V_BelegKopf.FormularAnzahl)
    Buf_V_BelegKopf.BelegDatum      = tDocDate       when (tDocDate       <> V_BelegKopf.BelegDatum)
    Buf_V_BelegKopf.H_DomesticTaxID = cDomesticTaxID when (cDomesticTaxID <> V_BelegKopf.H_DomesticTaxID)
    Buf_V_BelegKopf.H_TaxDate       = tTaxDate       when (tTaxDate       <> V_BelegKopf.H_TaxDate)
    Buf_V_BelegKopf.H_IntraDate     = tIntraDate     when (tIntraDate     <> V_BelegKopf.H_IntraDate)
    Buf_V_BelegKopf.ValutaDatum     = tValueDate     when (tValueDate     <> V_BelegKopf.ValutaDatum)
    Buf_V_BelegKopf.ZahlungsZiel    = iPaymentTerm   when (iPaymentTerm   <> V_BelegKopf.ZahlungsZiel)
    .

  validate Buf_V_BelegKopf.

  run dispatch in this-procedure ('row-available':U).

end.

return.

end procedure. /* HParamCancInvoice */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HSetInvoiceFree V-table-Win 
PROCEDURE HSetInvoiceFree :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Release an invoice                                                         */
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

define variable lDocRelease  as logical        no-undo.
define variable lEDIRelease  as logical        no-undo.

/* Buffers -------------------------------------------------------------------*/

define buffer BufH_V_BelegKopf for V_BelegKopf.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

if available V_Belegkopf then
  do on error undo, throw:

    if V_BelegKopf.gedruckt = no then

      adm.method.cls.DMCMessageSvc:prpoInstance:ShowError
        ('v_belH0005':U,
         string(V_BelegKopf.Belegnummer)).

    if V_BelegKopf.gedruckt         = yes
      and V_BelegKopf.Belegfreigabe = no then

      lDocRelease = adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
                      ('v_belH0001':U,
                       string(V_BelegKopf.Belegnummer)).

    if lDocRelease = yes
      or stamm.base.cls.SBCBusProcTransmissionSvc:prpoInstance:iGetTransmissionState(V_BelegKopf.V_BelegKopf_Obj) = {&pa_SB_TransState_NoTrans} then
    do:

      &IF LOOKUP("SD":U,"{&PA-MODULE}":U) > 0
        OR lookup("SO":U,"{&PA-Module}":U) > 0  &THEN

        if stamm.base.cls.SBCBusProcTransmissionSvc:prpoInstance:lIsAgreementActive
          (S_Kunde.S_Kunde_Obj,
           V_BelegKopf.Belegart) = yes then
          lEDIRelease = adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
                          ('v_belH0004':U,
                           string(V_BelegKopf.Belegnummer)).

      &ENDIF

    end. /* EDI release */

    if lDocRelease   = yes
      or lEDIRelease = yes then
    do:

      find BufH_V_BelegKopf
        where rowid(BufH_V_BelegKopf) = rowid(V_BelegKopf)
        exclusive-lock.

      if lDocRelease = yes then
        BufH_V_BelegKopf.Belegfreigabe = yes.

      &IF LOOKUP("SD":U,"{&PA-MODULE}":U) > 0
        OR lookup("SO":U,"{&PA-Module}":U) > 0 &THEN

        if lEDIRelease = yes then
          stamm.base.cls.SBCBusProcTransmissionSvc:prpoInstance:SetTransmissionState
            (V_BelegKopf.V_BelegKopf_Obj,
             S_Kunde.S_Kunde_Obj,
             {&pa_SB_TransState_released}).

      &ENDIF

      validate BufH_V_BelegKopf.

      run dispatch in this-procedure ('row-available':U).

    end.  /* if lDocRelease or lEDIRelease */

  end. /* if available V_BelegKopf */

return.

end procedure. /* HSetInvoiceFree */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE I_CheckDMSDocuments V-table-Win 
PROCEDURE I_CheckDMSDocuments :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* checks if a invoice got DMS attachments                                    */
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
/*                                                                            */
/* cCatchwordIDList    list of catchwords as a character                      */
/* cCatchwordValueList list of values corresponding to cCatchwordIDList as    */
/*                     character                                              */
/* iTemp               local counter variable                                 */
/*                                                                            */
/*----------------------------------------------------------------------------*/

define variable cCatchwordIDList    as character     no-undo.
define variable cCatchwordValueList as character     no-undo.
define variable iTemp               as integer       no-undo.

/* Buffers -------------------------------------------------------------------*/

define buffer bJBT_Project for JBT_Project.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* reset data */

empty temp-table gtt_O_Selektion.
empty temp-table gtt_O_Treffer.
empty temp-table gtt_O_Notiz.

glDMSAttachments = no.

if V_BelegKopf.JBT_Project_Obj > '':U then

  find bJBT_Project
    where bJBT_Project.JBT_Project_Obj = V_BelegKopf.JBT_Project_Obj
    no-lock no-error.

assign
  cCatchwordIDList    =   string( {&pa_O_SW_Firma} )
                        + {&PA-DELIMITER1}
                        + string( {&pa_O_SW_Belegart} )
                        + {&PA-DELIMITER1}
                        + string( {&pa_O_SW_BelegNummer} )
                        + {&PA-DELIMITER1}
                        + string( {&pa_O_SW_ReferenzNr} )
                        + {&PA-DELIMITER1}
                        + string( {&pa_O_SW_ObjektID} )
                        + {&PA-DELIMITER1}
                        &IF LOOKUP("JB":U,"{&PA-MODULE}":U) > 0 &THEN
                          + string( {&pa_O_SW_Projekt} ) + {&PA-DELIMITER1}
                        &ENDIF
                        + string( {&pa_O_SW_Kunde} )
                        + {&PA-DELIMITER1}
                        + string( {&pa_O_SW_Betreff} )
                        + {&PA-DELIMITER1}
                        + string( {&pa_O_SW_Belegdatum} )
                        + {&PA-DELIMITER1}
                        + string( {&pa_O_SW_Sachbearbeiter} )
  cCatchwordValueList =   trim( string( V_BelegKopf.Firma) )
                        + {&PA-DELIMITER1}
                        + trim( string(V_BelegKopf.BelegArt ) )
                        + {&PA-DELIMITER1}
                        + trim( string( V_BelegKopf.BelegNummer) )
                        + {&PA-DELIMITER1}
                        + trim( string( V_BelegKopf.ReferenzNr ) )
                        + {&PA-DELIMITER1}
                        + trim( string( V_BelegKopf.V_BelegKopf_Obj ) )
                        + {&PA-DELIMITER1}
                        &IF LOOKUP ("JB":U,"{&PA-MODULE}":U) > 0 &THEN
                          + ( if available bJBT_Project then
                                ( trim( string( bJBT_Project.ProjectID ) ) + {&PA-DELIMITER1} )
                              else
                                '':U + {&PA-DELIMITER1} )
                        &ENDIF
                        + trim( string( V_BelegKopf.Kunde ) )
                        + {&PA-DELIMITER1}
                        + trim( string( V_BelegKopf.BelegInfo ) )
                        + {&PA-DELIMITER1}
                        + trim(  string( V_BelegKopf.BelegDatum, '{&PA_DATEFORMAT}':U ) )
                        + {&PA-DELIMITER1}
                        + trim( string( V_BelegKopf.Sachbearbeiter ) )
  .

do iTemp = 1 to num-entries( cCatchwordIDList, {&PA-DELIMITER1} ):

  create gtt_O_Selektion.

  assign
    gtt_O_Selektion.SchlagwortID = integer( entry( iTemp, cCatchwordIDList, {&PA-DELIMITER1} ) )
    gtt_O_Selektion.Wert_min     = entry( iTemp, cCatchwordValueList, {&PA-DELIMITER1} )
    gtt_O_Selektion.Wert_max     = entry( iTemp, cCatchwordValueList, {&PA-DELIMITER1} )
    .

end. /* do iTemp to num-entries( cCatchwordIDList, {&PA-DELIMITER1} ): */

arch.base.cls.OMCBGAPISvc:prpoInstance:CatchwordDMSResearch
  (       {&pa_O_DT_V_BelegKopf},
          999,
          pACConnectionSvc:prpcCompany,
          table gtt_O_Selektion,
   output table gtt_O_Notiz,
   output table gtt_O_Treffer).

find first gtt_O_Treffer
  no-error.

if available gtt_O_Treffer then
  glDMSAttachments = yes.

end procedure. /* I_CheckDMSDocuments */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE I_CheckNaturaType V-table-Win 
PROCEDURE I_CheckNaturaType :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Checks if the used Natura-Types are valid due to the legal change of       */
/* 01/01/2021                                                                 */  
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
/* lNaturaTypeValid - logical for invalid / valid natura type                 */
/*----------------------------------------------------------------------------*/

define variable lNaturaTypeValid as logical initial no no-undo. 

/* Buffers -------------------------------------------------------------------*/

define buffer bV_BelegPos for V_BelegPos.
define buffer bS_Steuer   for S_Steuer.  

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* First check Natura-Type of Document Head */

if    V_BelegKopf.ZuschlSum_Netto <> 0
  and V_BelegKopf.SteuerSatzZuschl = 0
  and V_BelegKopf.S_Steuer_Obj     > '':U then
do:

  find bS_Steuer
    where bS_Steuer.S_Steuer_Obj = V_BelegKopf.S_Steuer_Obj
    no-lock.

  lNaturaTypeValid = stamm.base.cls.SBCLocalizationITSvc:prpoInstance:lisNaturaKeyValid
                       (bS_Steuer.I_TaxNature).

  if not lNaturaTypeValid then
    adm.method.cls.DMCMessageSvc:prpoInstance:showError 
      ('v_beli0011':U,
       string(V_BelegKopf.Kunde),
       string(V_BelegKopf.BelegNummer),
       string(bS_Steuer.Steuer),
       string(stamm.base.cls.SBCTaxMasterFilesSvc:prpoInstance:dTaxRateOfTaxCodeObj(bS_Steuer.S_Steuer_Obj), 'z9.99':U)).   

end. /* if    V_BelegKopf.ZuschlSum_Netto <> 0 */

/* Check Natura-Type of Document Lines */

for each bV_BelegPos
  where bV_BelegPos.Firma      = V_BelegKopf.Firma
    and bV_BelegPos.BelegArt   = V_BelegKopf.BelegArt
    and bV_BelegPos.ReferenzNr = V_BelegKopf.ReferenzNr
    and bV_BelegPos.Satzart    = 'A':U
    and bV_BelegPos.SteuerSatz = 0 
  no-lock,
  each bS_Steuer
  where bS_Steuer.S_Steuer_Obj = bV_BelegPos.S_Steuer_Obj
  no-lock
  on error undo, throw:

  lNaturaTypeValid = stamm.base.cls.SBCLocalizationITSvc:prpoInstance:lisNaturaKeyValid
                       (bS_Steuer.I_TaxNature). 

  if not lNaturaTypeValid then
    adm.method.cls.DMCMessageSvc:prpoInstance:showError 
      ('v_beli0011':U,
       string(V_BelegKopf.Kunde),
       string(V_BelegKopf.BelegNummer),
       string(bS_Steuer.Steuer),
       string(stamm.base.cls.SBCTaxMasterFilesSvc:prpoInstance:dTaxRateOfTaxCodeObj(bS_Steuer.S_Steuer_Obj), 'z9.99':U)).              

end. /* for each bV_BelegPos */ 

end procedure. /* I_CheckNaturaType */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE I_SDITransmissionRelease V-table-Win 
PROCEDURE I_SDITransmissionRelease :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Releases a Document for SDI Transmission                                   */
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

define variable cPKS         as character no-undo.
define variable cDocTypeDesc as character no-undo.

/* Buffers -------------------------------------------------------------------*/

define buffer bSBM_I_eInvoicing for SBM_I_eInvoicing.
define buffer bS_Kunde          for S_Kunde.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

if not can-find(first V_BelegPos 
                where V_BelegPos.Firma      = V_BelegKopf.Firma
                  and V_BelegPos.BelegArt   = V_BelegKopf.BelegArt
                  and V_BelegPos.ReferenzNr = V_BelegKopf.ReferenzNr
                  and V_BelegPos.SatzArt    = 'A':U) then

  adm.method.cls.DMCMessageSvc:prpoInstance:showError
        ('vfsdii0010':U,
         V_BelegKopf.Firma,
         string(V_BelegKopf.Belegnummer)). 

  /* Check if the document type is allowed for SdI-Transmission on 01/01/2021 */

  if not stamm.base.cls.SBCLocalizationITSvc:prpoInstance:lisDocumentTypeValid
           (V_BelegKopf.I_DocumentType) then

    adm.method.cls.DMCMessageSvc:prpoInstance:showError
      ('v_beli0013':U,
       string(V_BelegKopf.Kunde),
       string(V_BelegKopf.BelegNummer),
       string(V_BelegKopf.I_DocumentType)).

/* Check if the Natura-Types from Tax-Keys are valid on 01/01/2021 */

run I_CheckNaturaType. 

/* First put general information into the PKS */

{adm/incl/d__par00.if
  &Parameter      = "SubstitutionList"
  &ParameterListe = "cPKS"
  &Variable1      = "V_BelegKopf.Firma + ',':U + string(V_BelegKopf.BelegNummer)"
}

run I_CheckDMSDocuments.

/* in case that the document has attachments in dms, put the corresponding message into PKS */

if glDMSAttachments then
do:

  {adm/incl/d__par00.if
    &Parameter      = "MessageID"
    &ParameterListe = "cPKS"
    &Variable1      = "'vfsdii0008':U"
  }

end. /* if glDMSAttachments */

else
do:

  {adm/incl/d__par00.if
    &Parameter      = "MessageID"
    &ParameterListe = "cPKS"
    &Variable1      = "'vfsdii0001':U"
  }

end. /* if glDMSAttachments else*/

run pa_UISvcStartInstanceByName in target-procedure
('vfmsgdialog_eInvoicing.dyn':U,
 cPKS,
 '':U,
 '':U).

find bS_Kunde
  where bS_Kunde.Firma = {firma/s_kunde.fir pa-Firma}
    and bS_Kunde.Kunde = V_BelegKopf.Kunde
  no-lock.

if bS_Kunde.I_PublicAdministrationCode = '':U then
do:
  
  cDocTypeDesc = {fnarg
                   pa_cStCchDocTypeDesc
                   "V_BelegKopf.BelegArt,
                    pACConnectionSvc:prpcLanguage,
                    {&pa_CchDesc}"}.  

  {adm/incl/d__par00.if
    &Parameter      = "MessageID"
    &ParameterListe = "cPKS"
    &Variable1      = "'vfsdii0006':U"
  }

  {adm/incl/d__par00.if
    &Parameter      = "SubstitutionList"
    &ParameterListe = "cPKS"
    &Variable1      = "  cDocTypeDesc + ',':U
                       + string(V_BelegKopf.BelegNummer) + ',':U
                       + string(V_BelegKopf.Kunde)"
  }

  run pa_UISvcStartInstanceByName in target-procedure
  ('vfmsgdialog_eInvoicing.dyn':U,
   cPKS,
   '':U,
   '':U).

  return.

end. /* if bS_Kunde.I_PublicAdministrationCode = '':U */

/* Check if customers domestic tax id is valid regading to the FatturaPA format */

if        length(bS_Kunde.inlaendische_SteuerNr) > 0
  and (   length(bS_Kunde.inlaendische_SteuerNr) < 11
       or length(bS_Kunde.inlaendische_SteuerNr) > 16 ) then
do:

  {adm/incl/d__par00.if
    &Parameter      = "MessageID"
    &ParameterListe = "cPKS"
    &Variable1      = "'vfsdii0011':U"
  }

  {adm/incl/d__par00.if
    &Parameter      = "SubstitutionList"
    &ParameterListe = "cPKS"
    &Variable1      = "  V_BelegKopf.Firma + ',':U
                       + string(V_BelegKopf.BelegNummer) + ',':U
                       + string(V_BelegKopf.Kunde)"
  }

  run pa_UISvcStartInstanceByName in target-procedure
  ('vfmsgdialog_eInvoicing.dyn':U,
   cPKS,
   '':U,
   '':U).

  return.

end. /* if        length(bS_Kunde.inlaendische_SteuerNr) > 0 */ 


run vert/proc/v_vbel20.p ( V_BelegKopf.Firma,
                           V_BelegKopf.BelegArt,
                           V_BelegKopf.ReferenzNr,
                           V_BelegKopf.Offen,
                           yes,
                           no,
                           output table TT_V_BelegSumKopf,
                           output table TT_V_BelegSumPo
                           ).

/* write record V_BelegKopfAdr */

{adm/incl/d__run03.if
  &Procedure   = "vert/base/proc/vbndoc06.p"
  &Arguments   = "V_BelegKopf.V_BelegKopf_Obj,
                  output table Kund_Adresse-TMP,
                  output table Lief_Adresse-TMP,
                  output table Rech_Adresse-TMP"
}


create bSBM_I_eInvoicing.

assign
  bSBM_I_eInvoicing.Owning_Obj = V_BelegKopf.V_BelegKopf_Obj
  bSBM_I_eInvoicing.Company    = V_BelegKopf.Firma /* code checked by Parameswaran_T 12.12.2018 */
  bSBM_I_eInvoicing.Type       = 0
  bSBM_I_eInvoicing.State      = 0
.

  validate bSBM_I_eInvoicing.
  run dispatch ( 'display-fields':U ).

end procedure. /* I_SDITransmissionRelease */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Kommissionieren V-table-Win 
PROCEDURE Kommissionieren :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Kommissionierlauf für den Auftrag starten                                  */
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

if     available V_BelegKopf
   and V_BelegKopf.Belegart = 'U':U
   and V_BelegKopf.offen    = yes

   /* --> UMO#WH2015-07-010 cpl Streckenmix im Vertriebsbeleg */
   &IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
   /* Commissioning is possible if at min one non drop-ship-line exits */
   and can-find(first V_BelegPos of V_BelegKopf
                where V_BelegPos.uCI_Vertriebsweg <> {&uCI_VertriebswegStrecke}) then
   &ELSE
   and V_BelegKopf.Strecke  = no then
   &ENDIF
   /* <-- UMO#WH2015-07-010 cpl Streckenmix im Vertriebsbeleg */


do:

  /* --> UMO#WH2016-02-002 cpl Folgebelege aus Kundencenter generieren */
  &IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  if not gluAdopting then
  &ENDIF
  /* <-- UMO#WH2016-02-002 cpl Folgebelege aus Kundencenter generieren */

  adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
    ('vupic00001':U,
     string(V_BelegKopf.Belegnummer)).

  run vert/auf/proc/vuvpic00.p(V_BelegKopf.V_BelegKopf_Obj,
                               today + {&pa_S_Liefertermin_Zukunft},
                               ?,       /* gpdTargetQty */
                               '':U,
                               V_BelegKopf.Belegart,
                               '':U,   /* only required for service orders */
                               yes).   /* show end message (vuvpic00.p doesn't  */
                                       /* care for this parameter in this       */
                                       /* special case, YES doesn't hurt)       */

end. /* if available V_BelegKopf */

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
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
/* cCountryIso_Dest            ISO alpha 2 code of destination country        */
/* cCommunityObj               community of states object id                  */
/* cTerritoryStructure_Dest    tax territory structure extent of destination  */
/*----------------------------------------------------------------------------*/

define variable cCountryIso_Dest         like SBM_TaxTerritory.IsoAlpha2Code        no-undo.
define variable cCommunityObj            like SBM_ComOfStates.SBM_ComOfStates_Obj   no-undo.
define variable cTerritoryStructure_Dest like V_BelegKopf.Dest_SBM_TaxTerritory_Obj no-undo.
define variable cTargetISOCountry        like S_Staat.IsoAlpha2Code     no-undo.
define variable cTaxIDTargetCountry      like V_BelegKopf.TaxID         no-undo.
define variable cCountry                 like S_Adresse.Staat           no-undo.
define variable cState                   like S_Adresse.Bundesland      no-undo.
define variable cCity                    like S_Adresse.Ort             no-undo.
define variable cZIPCode                 like S_Adresse.PLZ             no-undo.
define variable iAddrNo                  like S_Adresse.AdressNr        no-undo.
&if lookup("U_CM","{&PA-OPTIONEN}") > 0 &then
  define variable cPKS                   as   character                 no-undo.
&ENDIF

&IF LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN
define variable iTransportTime      like V_BelegKopf.Transportzeit       no-undo.
define variable cTransportTimeUnit  like V_BelegKopf.Zeiteinheit         no-undo.
define variable iPickTime           like V_BelegKopf.uCI_KommZeit        no-undo.
define variable cPickTimeUnit       like V_BelegKopf.uCI_KommZeiteinheit no-undo.
&ENDIF

/* Buffers -------------------------------------------------------------------*/
&if lookup("U_CM","{&PA-OPTIONEN}") > 0 &then
  define buffer   bMS_SNR         for MS_SNr.  
  define buffer   bS_Artikel      for S_Artikel.
&ENDIF

&IF LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  define buffer bV_BelegKopf-U    for V_BelegKopf.
  define buffer bV_BelegKopfAdr-L for V_BelegKopfAdr.
&ENDIF


/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

glAdd = yes.

if not lSchlussrechnung then  /* normaler Beleg */
do:

  define variable cTemp as character no-undo.

  run check-modified in THIS-PROCEDURE ('check':U) no-error.

  /* Save the current rowid in case the add is cancelled. */

  assign
    adm-first-table    = rowid({&adm-tableio-first-table})
    adm-adding-record  = yes  /* Signal that it's add not copy. */
    adm-query-empty    = not available({&adm-tableio-first-table}) /* needed in Cancel */
    pa-created-records = '':U
    .

  /* Prüfe die Freigabe der Funktion */

  run check-record ('create':U) no-error.
  if error-status:error then
    return 'ADM-ERROR':U.

  Vorlauf:
  do on error undo, throw:

    cTemp = '':U.

    /* --> UMO#CA2016-05-003 MOu Rahmenauftrag: Auftragsschnellerfassung */
    &IF LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN
    if giuKunde <> 0
      and giuKunde <> ? then
    do:
      {adm/incl/d__par00.if
        &ParameterListe = "cTemp"
        &Parameter      = "uKunde"
        &Variable1      = "giuKunde"
      }
    end.
      {adm/incl/d__par00.if
          &ParameterListe = "cTemp"
          &Parameter      = "uBelegkopf_Obj-VUR"
          &Variable1      = "gcuBelegkopf_Obj-VUR"
        }
    &ENDIF
    /* <-- UMO#CA2016-05-003 MOu */

    run vert/proc/v_pbel00.w (input-output cTemp,
                                           cBelegart,
                                           0,
                                    output cSatzId).

    find V_BelegKopf
      where rowid(V_BelegKopf) = to-rowid(cSatzId)
      no-lock no-error.

    if    available V_BelegKopf
      and pa-Sprache <> V_BelegKopf.Sprache
      and basis.user.cls.BUCUserPropertySvc:prpoInstance:cParameterValue
            ('V_':U + 'useDocLanguage_':U + V_BelegKopf.Belegart) = 'yes':U then

      run set-link-attribute in adm-broker-hdl (this-procedure,
                                                'container-source':U,
                                                'Sprache=':U + V_BelegKopf.Sprache).

      &if lookup("U_CM","{&PA-OPTIONEN}") > 0 &then

        if    available V_BelegKopf
          and V_BelegKopf.origin_Obj > '':U
          and adm.method.cls.DMCSessionSvc:cOwningTable(V_BelegKopf.origin_Obj) = 'MS_SNR':U then
        do:

          find bMS_SNR
            where bMS_SNR.MS_SNR_Obj = V_BelegKopf.origin_Obj
            no-lock no-error.

          if available bMS_SNR then
          do:

            find last bS_Artikel
              where bS_Artikel.Firma = {firma/sartikel.fir pACConnectionSvc:prpcCompany}
              no-lock.

            assign
              cPKS = adm.method.cls.DMCParameterStringSvc:cWriteValue(cPKS, 'SNRArt':U,       bMS_SNR.SNRArt)
              cPKS = adm.method.cls.DMCParameterStringSvc:cWriteValue(cPKS, 'Seriennummer':U, bMS_SNR.Seriennummer)
              cPKS = adm.method.cls.DMCParameterStringSvc:cWriteValue(cPKS,
                                                                      'Artikel':U,
                                                                      '':U,
                                                                      bS_Artikel.Artikel,
                                                                      bMS_SNR.ArtikelAktuell)
              cPKS = adm.method.cls.DMCParameterStringSvc:cWriteValue(cPKS, 'Herkunft':U,     '3':U) /* Product file */
              cPKS = adm.method.cls.DMCParameterStringSvc:cWriteValue(cPKS, 'TargetFn':U,     'SpareParts':U) /* Product file */
              .

          end.

          {adm/incl/d__run01.if
            &Programm = "vert/ange/proc/vnpang04.w"
            &Link1    = "'record':U"
            &Source1  = "this-procedure"
            &PKS      = "cPKS"
            &RunMode  = "'Update':U"
          }

        end.

      &ENDIF

    catch oError as Progress.Lang.Error:

      return 'adm-error':U.

    end catch.

  end.  /* Vorlauf */

  /* Erfassen eines neuen Beleges */

  Add-Trans:
  do on error undo, throw:       /* "transaction" has been removed because progress will lay the transaction scope automatically on the next "do on ... end." */

    adm-create-complete = no.

    find V_BelegKopf
      where rowid(V_BelegKopf) = to-rowid(cSatzId)
      exclusive-lock no-error.                        /* begin of transaction */

    if not available V_BelegKopf then
    do:

      /* lese datensatz, damit beim direkten Update der zuletzt angewählte    */
      /* Beleg, der auch noch im Bildschirm steht angewählt wird              */

      find V_BelegKopf
        where rowid(V_BelegKopf) = adm-first-table
        no-lock. /* if not available -> catch will return the adm-error */

      return 'adm-error':U.

    end.

    run set-attribute-list ("ADM-NEW-RECORD=yes":U).

    assign
      pa-created-records  = 'V_BelegKopf':U
      adm-create-complete = yes
      .

    catch oError as Progress.Lang.Error:

      run set-attribute-list ('ADM-NEW-RECORD=no':U).
      return 'adm-error':U.

    end catch.

  end. /* Add-Trans */

  /* Prüfe auf diversen */

  if    not can-do('VUR,VUA':U,cBelegart)
    and can-find (S_Kunde
                    where S_Kunde.Firma    = {firma/s_kunde.fir pa-firma}
                      and S_Kunde.Kunde    = V_BelegKopf.Kunde
                      and S_Kunde.AdressNr = 0
                    use-index Main) then
  do on error undo, throw:

    if V_BelegKopf.Interessent > 0 then
    do on error undo, throw:                /* transaction deleted because progress will lay the transaction scope automatically on the next "do on ... end." */

      find VC_Interessent
        where VC_Interessent.Firma       = {firma/s_kunde.fir pa-Firma}
          and VC_Interessent.Interessent = V_BelegKopf.Interessent
        no-lock.              /* the document contains a prospect so this record must exist */

      find S_Adresse
        where S_Adresse.Firma    = {firma/s_adres.fir pACConnectionSvc:prpcCompany}
          and S_Adresse.AdressNr = VC_Interessent.AdressNr
        no-lock.

      create V_BelegKopfAdr.
      buffer-copy
        S_Adresse
          except
            Anlagebenutzer
            Anlagedatum
            Anlagezeit
            Aenderungbenutzer
            Aenderungdatum
            Aenderungzeit
            Firma
        to V_BelegKopfAdr
        assign
          V_BelegKopfAdr.Firma      = V_BelegKopf.Firma
          V_BelegKopfAdr.Belegart   = V_BelegKopf.Belegart
          V_BelegKopfAdr.ReferenzNr = V_BelegKopf.ReferenzNr
          V_BelegKopfAdr.Typ        = 'K':U
          .
      validate V_BelegKopfAdr.

      &IF LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN

        if can-find(first USM_Versandparameter
                      where USM_Versandparameter.Company = {firma/usmvers.fir pACConnectionSvc:prpcCompany}
                      no-lock) then
        do on error undo, throw:

          create bV_BelegKopfAdr-L.
          buffer-copy
            V_BelegKopfAdr
              except
                AdressNr
                Anlagebenutzer
                Anlagedatum
                Anlagezeit
                Aenderungbenutzer
                Aenderungdatum
                Aenderungzeit
                Firma
                V_BelegKopfAdr_Obj
                Typ
            to bV_BelegKopfAdr-L
            assign
              bV_BelegKopfAdr-L.Firma      = V_BelegKopf.Firma
              bV_BelegKopfAdr-L.Belegart   = V_BelegKopf.Belegart
              bV_BelegKopfAdr-L.ReferenzNr = V_BelegKopf.ReferenzNr
              bV_BelegKopfAdr-L.Typ        = 'L':U
              .
          validate bV_BelegKopfAdr-L.
        end.

      &ENDIF

      /* catch of the block "if V_BelegKopf.Interessent > 0 then do on error */
      /* undo, throw:" will catch the error of this block                    */

    end. /* if V_BelegKopf.Interessent > 0 */
    else
    do on error undo, throw:

      find ttS_Adresse
        no-error.

      if available ttS_Adresse then
      do:

        delete ttS_Adresse.
        create ttS_Adresse.
        ttS_Adresse.Firma = {firma/s_adres.fir pACConnectionSvc:prpcCompany}.

      end.

      run OpenAddressViewer.

      find ttS_Adresse
        no-error.

      if    available ttS_Adresse
        and ttS_Adresse.Name1 <> '':U
        and ttS_Adresse.Staat <> '':U
        and ttS_Adresse.Ort   <> '':U then
      do on error undo, throw:

        create V_BelegKopfAdr.
        assign
          V_BelegKopfAdr.Firma      = V_BelegKopf.Firma
          V_BelegKopfAdr.Belegart   = V_BelegKopf.Belegart
          V_BelegKopfAdr.ReferenzNr = V_BelegKopf.ReferenzNr
          V_BelegKopfAdr.Typ        = 'K':U
          .
        validate V_BelegKopfAdr.

        buffer-copy
          ttS_Adresse
          except
            Anlagebenutzer
            Anlagedatum
            Anlagezeit
            Aenderungbenutzer
            Aenderungdatum
            Aenderungzeit
            Firma
          to V_BelegKopfAdr.

        validate V_BelegKopfAdr.

        &IF LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN

          if can-do('A,U,L,R,VFP':U, cBelegart)
            and can-find(first USM_Versandparameter
                           where USM_Versandparameter.Company = {firma/usmvers.fir pACConnectionSvc:prpcCompany}
                           no-lock) then
          do on error undo, throw:

            create bV_BelegKopfAdr-L.
            buffer-copy
              V_BelegKopfAdr
                except
                  AdressNr
                  Anlagebenutzer
                  Anlagedatum
                  Anlagezeit
                  Aenderungbenutzer
                  Aenderungdatum
                  Aenderungzeit
                  Firma
                  V_BelegKopfAdr_Obj
                  Typ
              to bV_BelegKopfAdr-L
              assign
                bV_BelegKopfAdr-L.Firma      = V_BelegKopf.Firma
                bV_BelegKopfAdr-L.Belegart   = V_BelegKopf.Belegart
                bV_BelegKopfAdr-L.ReferenzNr = V_BelegKopf.ReferenzNr
                bV_BelegKopfAdr-L.Typ        = 'L':U
                .
            validate bV_BelegKopfAdr-L.
          end.
  
        &ENDIF

        cTaxIDTargetCountry = V_BelegKopf.TaxID.

        if V_BelegKopf.Versendung = no then
        do:  

          /* here we first need the geographical target country (without consideration       */
          /* of shipping) to search for a tax number.                                        */
          /* The existence of a tax number is important for TaxRelTargetAddressDetailsForDoc */
          /* for determining the destination address (b2b/b2c)                               */    

          cTargetISOCountry = stamm.base.cls.SBCTaxMasterFilesSvc:prpoInstance:cTargetISOCountryForDoc(V_BelegKopf.V_BelegKopf_Obj).

          if V_BelegKopf.TaxIDType  = {&pa_SB_TaxIDType_UStID} then

            cTaxIDTargetCountry = stamm.base.cls.SBCTaxMasterFilesSvc:prpoInstance:cDefaultBPSalesTaxIDOfCountry({&pa_S_CustomerTaxID},
                                                                                                                 V_BelegKopf.Kunde,
                                                                                                                 cTargetISOCountry).

        end. /* if V_BelegKopf.Versendung = no */

        /* at this point V_BelegKopfAdr could have been deleted.                     */
        /* check if the destination tax territory structure has been changed, it     */
        /* can come out of a delivery address or of customer's master data, it might */
        /* be necessary to perform a new tax determination if it has been changed    */

        stamm.base.cls.SBCTaxMasterFilesSvc:prpoInstance:TaxRelTargetAddressDetailsForDoc
          (       V_BelegKopf.V_BelegKopf_Obj,
                  cTaxIDTargetCountry,         /* pcTaxID: is only used if plshipping = no */
                  V_BelegKopf.Versendung,      /* plShipping */       
           output cCountry,
           output cState,
           output cCity,
           output cZIPCode,
           output iAddrNo).

        /* determine the new territory structure of the destination address and compare it with the old one */

        assign
          cCountryIso_Dest         = {fnarg
                                       pa_cInternalStateCodeToIsoAlpha2Code
                                       "cCountry"}
          cCommunityObj            = stamm.base.cls.SBCTaxMasterFilesSvc:prpoInstance:cTaxRelCommunityOfTransaction
                                       (stamm.base.cls.SBCTaxMasterFilesSvc:prpoInstance:cIsoAlphaCodeOfTaxTerritory
                                          (V_BelegKopf.Dept_SBM_TaxTerritory_Obj[{&pa_SB_TaxTerritoryExt_Country}]),
                                        cCountryIso_Dest,
                                        V_BelegKopf.BelegDatum)
          cTerritoryStructure_Dest = stamm.base.cls.SBCTaxMasterFilesSvc:prpoInstance:cTerritoryStrExtentForAdressDetails
                                       (V_BelegKopf.BelegDatum,
                                        cCountry,
                                        cState,
                                        cCity,
                                        cZIPCode,
                                        iAddrNo)
          /* do not overwrite the 1st extent if it represents an US tax code (written by cTerritoryStrExtentForAdressDetails) */
          cTerritoryStructure_Dest[{&pa_SB_TaxTerritoryExt_Community}] = cCommunityObj when not (    pACConnectionSvc:prpcLocalization = 'USA':U
                                                                                                 and cCountryIso_Dest                  = {&pa_SB_SalesTaxCountry})
          .

        if stamm.base.cls.SBCTaxMasterFilesSvc:prpoInstance:lTaxTerritoryExtentsAreEqual
             (cTerritoryStructure_Dest,
              V_BelegKopf.Dest_SBM_TaxTerritory_Obj) = no then

          vert.base.cls.VBCSalesTaxSvc:prpoInstance:ChangeDocDestTerritoryStructure
            (V_BelegKopf.V_BelegKopf_Obj,
             cTerritoryStructure_Dest).

      end. /* if available ttS_Adresse */

      /* next catch will catch the error of this block                        */

    end. /* else: if V_BelegKopf.Interessent > 0 */

    &IF LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN

      if cBelegart = 'U':U
        and can-find(first USM_Versandparameter
                       where USM_Versandparameter.Company = {firma/usmvers.fir pACConnectionSvc:prpcCompany}
                       no-lock) then
      do on error undo, throw:

        find bV_BelegKopf-U
          where rowid(bV_BelegKopf-U) = rowid(V_BelegKopf)
          exclusive-lock no-wait no-error.
      
        if available bV_BelegKopf-U 
          and available bV_BelegKopfAdr-L then
        do:
      
          branche.vert.cls.UVC_CISalesDocumentSvc:prpoInstance:GetTransportTime
            (       bV_BelegKopf-U.Kunde,
                    bV_BelegKopf-U.VersandArt,
                    bV_BelegKopf-U.Lieferant,
                    bV_BelegKopf-U.LieferBedingung,
                    bV_BelegKopfAdr-L.Staat,
                    bV_BelegKopfAdr-L.PLZ,
             output iTransportTime,
             output cTransportTimeUnit,
             output iPickTime,
             output cPickTimeUnit).
        
          assign
            bV_BelegKopf-U.Transportzeit       = iTransportTime      when iTransportTime     <> ?
            bV_BelegKopf-U.Zeiteinheit         = cTransportTimeUnit  when cTransportTimeUnit <> ?
            bV_BelegKopf-U.uCI_KommZeit        = iPickTime           when iPickTime          <> ?
            bV_BelegKopf-U.uCI_KommZeiteinheit = cPickTimeUnit       when cPickTimeUnit      <> ?
            .
            
        end. /* if available bV_BelegKopf-U then */

      end. /* if cBelegart = 'U':U ... */
  
    &ENDIF

    catch oError as Progress.Lang.Error:

      (new adm.method.cls.DMCErrorFrw(oError)):display().

      run set-attribute-list ('ADM-NEW-RECORD=no':U).
      run dispatch('display-fields':U).

      return 'adm-error':U.

    end catch.

  end. /* diverser Kunde */

  /* Damit die Zustandsprüfung auf den aktuellen Kunden greift, hier die       */
  /* Stammsätze laden                                                          */

  find S_Kunde
    where S_Kunde.Firma = {firma/s_kunde.fir pa-firma}
      and S_Kunde.Kunde = V_BelegKopf.Kunde
    no-lock.

  &IF LOOKUP("VC","{&PA-MODULE}") > 0 &THEN

    find VC_Interessent
      where VC_Interessent.Firma       = {firma/s_kunde.fir pa-Firma}
        and VC_Interessent.Interessent = V_BelegKopf.Interessent
      no-lock no-error.

  &ENDIF

  /* damit Query für die Adressen, den richtigen Satz bekommt */

  run notify ('row-available':U).

  run notify ('add-record, GROUP-ASSIGN-TARGET':U).

  if return-value = 'ADM-ERROR':U then
  do:

    run dispatch in this-procedure ('cancel-record':U).
    return 'ADM-ERROR':U.

  end.

  /* Display any fields assigned by CREATE.                                    */
  /* MUSS NACH ADD-RECORD erfolgen, da ansonsten alte Werte angezeigt werden!! */

  {adm/incl/d__duh00.if
     &Var1     = "V_BelegKopf.Kunde"
     &Var2     = "V_BelegKopf.Belegnummer"
     &Var3     = "V_BelegKopf.Interessent"
     &WithFrame = "frame {&frame-name}"}

  glZustandPruefen = no.

  run dispatch ('enable-fields':U).

  if return-value <> 'adm-error':u then
  do:

    run new-state('update':U). /* Signal that we're in a record update now. */

    run dispatch in this-procedure ('apply-entry':U).

  end.

end. /* normaler Beleg */

else /* Schlussrechnung */
do:

  run Beleguebernahme no-error.

  if error-status:error then
  do:

    {adm/incl/d__msg00.if
      &Meldung = "'s_bel00002':U"
    }

    return 'adm-error':U.

  end.

end.

glAdd = no.

end procedure.

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

/* Buffers -------------------------------------------------------------------*/

define buffer Buf_SourceInvoice_V_BelegKopf for V_BelegKopf.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Code placed here will execute PRIOR to standard behavior. */

/* Test if there exists a line of another credit advice for the same invoice. */
/* Searching for another credit advice without any line is not possible with  */
/* good performance because there is no index for the table V_BelegKopf that  */
/* can be used.                                                               */

lSpeichern = yes.

if    lArchivieren = no
  and available V_BelegKopf
  and not cRunMode matches 'Slave*':U
  and not can-do(pa-disabled-functions,'delete':U)
  and glDestroy = no
  and (   not can-do('R,G':U, V_BelegKopf.Belegart)
       or not can-do('F,I':U, pACConnectionSvc:prpcLocalization))
  and not can-find (first V_BelegPos
                      where V_BelegPos.Firma      = V_BelegKopf.Firma
                        and V_BelegPos.Belegart   = V_BelegKopf.Belegart
                        and V_BelegPos.ReferenzNr = V_BelegKopf.ReferenzNr
                        and lookup(V_BelegPos.Satzart,'A,G,Z':U) > 0)
  and ( if pACConnectionSvc:prpcLocalization = 'H':U then
          not can-do ({&pa_V_H_NoUpdateAfterPrint}, V_BelegKopf.Belegart)
        else
          yes ) then
do:

  /* archive Invoice/credit without items   */

  if adm.config.cls.DCCAppConfigSvc:prpoInstance:lParameterValue('VB_ArchiveDocInsteadOfDelete':U) = yes then
    lSpeichern = yes.

  else
  do:

    /* If a credit advice without any line only with surcharges was taken over  */
    /* from an invoice, this invoice should contain surcharges too.             */

    if    V_BelegKopf.Belegart = 'G':U
      and V_BelegKopf.Uebernahme then
    do:

      find Buf_SourceInvoice_V_BelegKopf
        where Buf_SourceInvoice_V_BelegKopf.Firma      = V_BelegKopf.Firma
          and Buf_SourceInvoice_V_BelegKopf.Belegart   = 'R':U
          and Buf_SourceInvoice_V_BelegKopf.ReferenzNr = V_BelegKopf.Herk_ReferenzNr
      no-lock.

      if    Buf_SourceInvoice_V_BelegKopf.Zuschlag[1] = 0
        and Buf_SourceInvoice_V_BelegKopf.Zuschlag[2] = 0
        and Buf_SourceInvoice_V_BelegKopf.Zuschlag[3] = 0
        and Buf_SourceInvoice_V_BelegKopf.Zuschlag[4] = 0 then
      do:

        {adm/incl/d__msg00.if
          &Meldung    = "'v_bel00308':U"
          &Liste      = "string(Buf_SourceInvoice_V_BelegKopf.Belegnummer)"
          &Rueckgabe  = "lOK"
        }

      end. /* if Buf_SourceInvoice_V_BelegKopf.Zuschlag[1] = 0 */

      else

        lOK = no. /* this means: do not cancel  */

    end. /* if V_BelegKopf.Belegart = 'G':U and V_BelegKopf.Uebernahme  */

    else if V_BelegKopf.Belegart = 'G':U
      and not V_BelegKopf.Uebernahme then
    do:

      {adm/incl/d__msg00.if
        &Meldung    = "'v_bel00307':U"
        &Rueckgabe  = "lOK"
      }

    end. /* else if V_BelegKopf.Belegart = 'G':U  and not V_BelegKopf.Uebernahme*/

    else /* if V_BelegKopf.Belegart <> 'G':U then */
    do:

      {adm/incl/d__msg00.if
        &Meldung    = "'v_bel00009m':U"
        &Rueckgabe  = "lOK"
      }

    end.

    if lOK = yes then

      assign
        lSpeichern  = no
        lCancel     = yes
        .
  end.
end. /* available V_BelegKopf */

/* Dispatch standard ADM method.                             */

run dispatch in THIS-PROCEDURE ('assign-record':U).

if return-value <> 'adm-error':U then
do:

  /* --> UMO#CA2016-05-003 MOu Rahmenauftrag: Auftragsschnellerfassung */
  &IF LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  run new-state('U_CAupdateCallerObject,container-source':U).
  &ENDIF
  /* <-- UMO#CA2016-05-003 MOu */

  /* --> UMO#CA2016-03-001 PWa Gutschriftsverfahren */
  &IF LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN

    if V_BelegKopf.BelegArt = 'GSA':U
      and V_BelegKopf.uGSAStatus = {&uCA_CreditMemoState_InProcessing}
      and can-find (first V_BelegPos
        where V_BelegPos.Firma            = V_BelegKopf.Firma
          and V_BelegPos.BelegArt         = V_BelegKopf.BelegArt
          and V_BelegPos.ReferenzNr       = V_BelegKopf.ReferenzNr)
      and not can-find (first V_BelegPos
        where V_BelegPos.Firma            = V_BelegKopf.Firma
          and V_BelegPos.BelegArt         = V_BelegKopf.BelegArt
          and V_BelegPos.ReferenzNr       = V_BelegKopf.ReferenzNr
          and (V_BelegPos.uGSAAbweichung      = yes
                or V_BelegPos.uGSAgesperrt    = yes
                or V_BelegPos.uGSAFehler      = yes)) then

      V_BelegKopf.uGSAStatus = {&uCA_CreditMemoState_Released}.

  &ENDIF
  /* <-- UMO#CA2016-03-001 PWa Gutschriftsverfahren */

  /* first check if purchase order has been generated for any of the sales    */
  /* order position's                                                         */
  /* if there is already a purchase order generated then check if there are   */
  /* any changes in the following data:                                       */
  /* - delivery address in head doc changed                                   */
  /* - quantity in position changed                                           */
  /* - requested date in position changed                                     */
  /* - new position added                                                     */
  /* - delivery restriction in head doc chaged                                */
  /* - shipping instruction in head doc changed                               */
  /* - terms of delivery in head doc changed                                  */

  if     vert.base.cls.VBCSalesDocSvc:prpoInstance:lIsPurchaseOrderGeneratedForPos('':U, V_BelegKopf.V_BelegKopf_Obj) = yes
     and (   vert.base.cls.VBCSalesDocSvc:prpoInstance:lIsDeliveryAdressOfSalesOrderChanged(V_BelegKopf.V_BelegKopf_Obj)   = yes
          or vert.base.cls.VBCSalesDocSvc:prpoInstance:lIsQuantityOfSalesOrderPositionChanged(V_BelegKopf.V_BelegKopf_Obj) = yes
          or vert.base.cls.VBCSalesDocSvc:prpoInstance:lIsReqDateOfSalesOrderPositionChanged(V_BelegKopf.V_BelegKopf_Obj)  = yes
          or vert.base.cls.VBCSalesDocSvc:prpoInstance:lIsNewPositionForSalesOrderAdded(V_BelegKopf.V_BelegKopf_Obj)       = yes
          or vert.base.cls.VBCSalesDocSvc:prpoInstance:lIsDeliveryRestrOfSOChanged(V_BelegKopf.V_BelegKopf_Obj)            = yes
          or vert.base.cls.VBCSalesDocSvc:prpoInstance:lIsShipInstructionsOfSOChanged(V_BelegKopf.V_BelegKopf_Obj)         = yes
          or vert.base.cls.VBCSalesDocSvc:prpoInstance:lIsTermsOfDeliveryOfSOChanged(V_BelegKopf.V_BelegKopf_Obj)          = yes)
     and adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
           ('vuord00033':U) then
  do:

    /* start the Updatebrowser */

    {adm/incl/d__run01.if
      &Programm  = "vert/auf/proc/vupord00.w"
      &Link1     = "'record':U"
      &Source1   = "this-procedure"
      &RunMode   = "'Update':U"
    }

  end. /* (vert.base.cls.VBCSalesDocSvc:prpoInstance:lIsQuantityOfSalesOrderPositionChanged(V_BelegKopf.V_BelegKopf_Obj)... */

end.

if return-value = 'adm-error':U then

  lSpeichern = no.

end procedure.

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

define variable i as integer no-undo.

&IF LOOKUP("VS_REPAIR","{&PA-OPTIONEN}") > 0 &THEN
  define variable dStatisticsQuantity       as decimal no-undo.
  define variable lQtyIsNotCollectedFromVSC as logical no-undo.
&ENDIF

/* Buffers -------------------------------------------------------------------*/

&IF LOOKUP("U_CW":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  define buffer bttS_Adresse_UCW for temp-table ttS_Adresse.
&ENDIF

&IF LOOKUP("VS_REPAIR","{&PA-OPTIONEN}") > 0 &THEN
  define buffer bV_BelegPos       for V_BelegPos.
&ENDIF

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Code placed here will execute PRIOR to standard behavior. */

if available V_BelegKopf then
do:

  if S_Kunde.AdressNr = 0 then
  do:

    find ttS_Adresse
      no-error.

    find V_BelegKopfAdr
      where V_BelegKopfAdr.Firma      = V_BelegKopf.Firma
        and V_BelegKopfAdr.Belegart   = V_BelegKopf.Belegart
        and V_BelegKopfAdr.ReferenzNr = V_BelegKopf.ReferenzNr
        and V_BelegKopfAdr.Typ        = 'K':U
      exclusive-lock no-error.

    if    not available ttS_Adresse
      and available V_BelegKopfAdr then

      delete V_BelegKopfAdr.

    /* This segment is only needed when saving a sales document for a */
    /* once only customer. In case we are in a quote for a prospect   */
    /* there already is a V_BelegKopfAdr-entry (with AdressNr <> ?)   */
    /* and we don't want to overwrite this potentially already        */
    /* changed database entry. See also issue PA-12201.               */
    if    available ttS_Adresse 
      and ttS_Adresse.AdressNr = ? then
    do:

      /* Prüfung Mindestanforderung (Name1, Staat und Ort) */

      if   ttS_Adresse.Name1 = '':U
        or ttS_Adresse.Staat = '':U
        or ttS_Adresse.Ort   = '':U then

        adm.method.cls.DMCMessageSvc:prpoInstance:showError
          ('e_trg00085':U,
           string(V_BelegKopf.Belegnummer),
           string(V_BelegKopf.Belegdatum,'{&PA_DATEFORMAT}':U)).

      if not available V_BelegKopfAdr then
      do:

        create V_BelegKopfAdr.

        assign
          V_BelegKopfAdr.Firma      = V_BelegKopf.Firma
          V_BelegKopfAdr.Belegart   = V_BelegKopf.Belegart
          V_BelegKopfAdr.ReferenzNr = V_BelegKopf.ReferenzNr
          V_BelegKopfAdr.Typ        = 'K':U
          .

        validate V_BelegKopfAdr.

      end.

      buffer-copy
        ttS_Adresse
        except
          Anlagebenutzer
          Anlagedatum
          Anlagezeit
          Aenderungbenutzer
          Aenderungdatum
          Aenderungzeit
          Firma
        to V_BelegKopfAdr.

      validate V_BelegKopfAdr.

    end. /* if available ttS_Adresse */

  end. /* if S_Kunde.AdressNr = 0 then */

  if    S_Kunde.AdressNr = 0
    and not can-find (V_BelegKopfAdr
                        where V_BelegKopfAdr.Firma      = V_BelegKopf.Firma
                          and V_BelegKopfAdr.Belegart   = V_BelegKopf.Belegart
                          and V_BelegKopfAdr.ReferenzNr = V_BelegKopf.ReferenzNr
                          and V_BelegKopfAdr.Typ        = 'K':U) then

    adm.method.cls.DMCMessageSvc:prpoInstance:showError
      ('v_bel00062':U,
       string(V_BelegKopf.Kunde)).

  &IF LOOKUP("U_CW":U,"{&PA-OPTIONEN}":U) > 0 &THEN

    empty temp-table bttS_Adresse_UCW.

    if    available V_BelegKopf
      and can-do('U,L,A':U,V_BelegKopf.Belegart)
      and V_BelegKopf.uCW_DirectPrintInvoice
      and not branche.vert.cls.UVC_AdoptionSvc:prpoInstance:lDeliveryAdrEqualsInvoiceAdr(V_BelegKopf.V_BelegKopf_Obj, 
                                                                                         input-output table bttS_Adresse_UCW by-reference) then

      adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
        ('uvbel00037':U,
         string(V_BelegKopf.BelegNummer),
         V_BelegKopf.Belegart).

  &ENDIF

  if lArchivieren = yes then
  do:

    /* Avoiding to archive an order if there exits a quoted work order for    */
    /* one of its lines. Limited for orders because for a quote you can       */
    /* generate a quoted work order but this you can archive anytime.         */

    if V_BelegKopf.Belegart = 'U':U then
    do:

      &IF lookup("PP","{&pa-Module}") > 0 &THEN

        /* If there is any line that has a work order you can't archive manually the document */

        if can-find(first V_BelegPos
                      where V_BelegPos.Firma      = V_BelegKopf.Firma
                        and V_BelegPos.Belegart   = V_BelegKopf.Belegart
                        and V_BelegPos.ReferenzNr = V_BelegKopf.ReferenzNr
                        and V_BelegPos.lfdNr_SR   = 0
                        and can-find(first PP_Auftrag
                                       where PP_Auftrag.Firma           = {firma/ppauftra.fir V_BelegPos.Firma}
                                         and PP_Auftrag.Archived        = no
                                         and PP_Auftrag.AuftragsKennung = 'F':U
                                         and PP_Auftrag.Kunde           = V_BelegKopf.Kunde
                                         and PP_Auftrag.nicht_erster    = no
                                         and PP_Auftrag.Belegnummer     = V_BelegPos.Belegnummer
                                         and PP_Auftrag.PositionsNr     = V_BelegPos.PositionsNr
                                         and PP_Auftrag.Coverage_Obj    = V_BelegPos.V_BelegPos_Obj)) then
        do:

          /* Reset lArchivieren otherwise you could not leave the viewer.  */

          lArchivieren = no.

          adm.method.cls.DMCMessageSvc:prpoInstance:showError
            ('v_bel00164':U,
             string(input frame {&frame-name} V_BelegKopf.BelegNummer)).

        end. /* if can-find (first V_BelegPos) */

      &ENDIF

    end. /* if V_BelegKopf.Belegart = 'U':U */

    if lArchivieren = yes then 

    Archiv:
    do on error undo, return 'adm-error':U:


      /* offene Mengen als storniert verbuchen */

      if can-do('U,VUA,VUR,L,G':U,V_BelegKopf.Belegart) then /* UrB: L,G cannot be archived manually ----- */

        for each V_BelegPos
          where V_BelegPos.Firma      = V_BelegKopf.Firma
            and V_BelegPos.Belegart   = V_BelegKopf.Belegart
            and V_BelegPos.ReferenzNr = V_BelegKopf.ReferenzNr
          use-index Main
          exclusive-lock
          on error undo Archiv, return 'adm-error':U:

          if      V_BelegPos.Satzart                                  = 'A':U
             and (   (V_BelegPos.Menge - V_BelegPos.gelieferte_Menge) > 0
                  or V_BelegPos.stornierte_Menge                     <> 0) then
          do:

            assign
              V_BelegPos.stornierte_Menge = (V_BelegPos.Menge
                                             - V_BelegPos.gelieferte_Menge)
              .

            validate V_BelegPos.

          end.

          V_BelegPos.offen = no.
          validate V_BelegPos.

        end. /* for each V_BelegPos */

      /* Behandlung Angebote */

      if can-do('VUD,A,VFP':U,V_BelegKopf.Belegart) then

        for each V_BelegPos
          where V_BelegPos.Firma      = V_BelegKopf.Firma
            and V_BelegPos.Belegart   = V_BelegKopf.Belegart
            and V_BelegPos.ReferenzNr = V_BelegKopf.ReferenzNr
          use-index Main
          exclusive-lock
          on error undo Archiv, return 'adm-error':U:

          &IF LOOKUP ('VF_INTRA',"{&PA-OPTIONEN}") > 0 &THEN

            if stamm.base.cls.SBCBusinessCategorySvc:prpoInstance:lHasCompanyIntraStatSales(V_BelegKopf.BelegDatum) then

              case pACConnectionSvc:prpcLocalization:

                {&{&PA-XBasisName}_C_Intra_Archiv}
                {&{&PA-XBasisName}_U_Intra_Archiv}
                {&{&PA-XBasisName}_Q_Intra_Archiv}
                {&{&PA-XBasisName}_Intra_Archiv}
                {&{&PA-XBasisName}_Y_Intra_Archiv}

                otherwise
                do:

                  if    V_BelegKopf.Meldepflicht
                    and can-do('VFP':U,V_BelegKopf.Belegart)
                    and not can-find (first S_IntraHandel
                                        where S_IntraHandel.Firma            = V_BelegPos.Firma
                                          and S_IntraHandel.Herk_Belegart    = V_BelegPos.BelegArt
                                          and S_IntraHandel.Herk_ReferenzNr  = V_BelegPos.ReferenzNr
                                          and S_IntraHandel.Herk_LfdNr_SR    = V_BelegPos.LfdNr_SR
                                          and S_IntraHandel.Herk_PositionsNr = V_BelegPos.PositionsNr) then
                    undo Archiv, return 'adm-error':U.

                end.  /* otherwise */

              end case. /* pACConnectionSvc:prpcLocalization */

          &ENDIF /* &IF lookup("VF_Intra":U,"{&PA-OPTIONEN}":U) > 0 */

          if V_BelegPos.offen = yes then
          do:

            V_BelegPos.offen = no.
            validate V_BelegPos.

          end.

        end. /* for each V_BelegPos, aber nur 'VUD,A,VFP' */

      /* first try to set "offen" = no */

      V_BelegKopf.offen = no.

      /* fire the trigger - the trigger decides if it is possible to  */
      /* archive the document (set "offen" = no)                      */

      validate V_BelegKopf.

      /* Test if the trigger really set "offen" = no */

      find Buf1_V_BelegKopf
        where rowid(Buf1_V_BelegKopf) = rowid(V_BelegKopf)
        no-lock.

      if Buf1_V_BelegKopf.offen = yes then
      do:

        adm.method.cls.DMCMessageSvc:prpoInstance:showError
          ('v_bel00081':U,
           string(Buf1_V_BelegKopf.Belegnummer)).

        lArchivieren = no.

        undo Archiv, return 'adm-error':U.

      end.

    end. /* else do on error undo, return 'adm-error':U */

  end. /* if lArchivieren = yes */

  &IF LOOKUP("Q_GELANG","{&PA-OPTIONEN}") > 0 &THEN

    if lSpeichern = yes then

      vert.auf.cls.VUCEntryCertificateSvc:prpoInstance:showErrorIfEntryCertificateNecessary
        (buffer V_BelegKopf).

  &ENDIF

  /* Prüfung Bestimmungsort */
  /* Bei Angeboten, Aufträgen, Gutschriften und Abrufaufträgen                */
  /* muss nicht unbedingt eine Ortsangabe vorliegen. Bei Schluss- bzw.        */
  /* Teilrechnungen kommt diese evtl. aus dem Vorbeleg. bei allen             */
  /* anderen belegen muss ein Bestimmungsort angegeben werden.                */

  &IF "{&pa_S_IncoTerm}":U = "1":U &THEN

    if    V_BelegKopf.Bestimmungsort = 3
      and lSpeichern = yes
      and can-do('A,U,VUA,G,VUD,L,VFP,R':U,V_BelegKopf.Belegart)
      and not can-find(first V_BelegBestOrt
                         where V_BelegBestOrt.Firma      = V_BelegKopf.Firma
                           and V_BelegBestOrt.Belegart   = V_BelegKopf.Belegart
                           and V_BelegBestOrt.ReferenzNr = V_BelegKopf.ReferenzNr)
      and adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
            ('v_inc00001':U,
             string(input frame {&frame-name} V_BelegKopf.BelegNummer)) = no then

      return 'adm-error':U.

  &ENDIF

  /* assign the new bank data from the dialog */

  if    available S_Kunde
    and S_Kunde.AdressNr <> 0 then
  do:

    /* write even if gcOIDBank is empty because the bank could be set from    */
    /* a second bank to the main bank of the customer                         */

    if V_BelegKopf.SBM_BankDataAcc_Obj <> gcOIDBank then

      V_BelegKopf.SBM_BankDataAcc_Obj = gcOIDBank.

  end.
  else
  do:

    if V_BelegKopf.BankKonto <> gcAccount then

      V_BelegKopf.BankKonto = gcAccount.

    if V_BelegKopf.Bank <> gcBank then

      V_BelegKopf.Bank = gcBank.

    if V_BelegKopf.IBAN <> gcIBAN then

      V_BelegKopf.IBAN = gcIBAN.

  end.

  &IF LOOKUP("VS_REPAIR","{&PA-OPTIONEN}") > 0 &THEN 

    if    V_BelegKopf.Herk_BelegArt = 'VSC':U
      and V_BelegKopf.BelegArt      = 'G':U then
    do:
    
      for each bV_BelegPos
        where bV_BelegPos.Firma          = V_BelegKopf.Firma
           and bV_BelegPos.Belegart      = V_BelegKopf.Belegart
           and bV_BelegPos.ReferenzNr    = V_BelegKopf.ReferenzNr    
           and bV_BelegPos.BelegArt      = 'G':U
           and bV_BelegPos.Herk_BelegArt = 'VSC':U
           and bV_BelegPos.Wertposition  = yes
        no-lock
        on error undo, throw:
      
        assign
          dStatisticsQuantity       = vert.serv.cls.VSCCallSvc:prpoInstance:dCalcQuantityForValueCredit
                                          (bV_BelegPos.Origin_Obj,
                                           bV_BelegPos.V_BelegPos_Obj,
                                           bV_BelegPos.Menge)
          lQtyIsNotCollectedFromVSC = vert.serv.cls.VSCCallSvc:prpoInstance:lCheckReleaseOfCreditWhenQtyIsNotCollectedFromVSC
                                          (dStatisticsQuantity,
                                           bV_BelegPos.Menge,
                                           V_BelegKopf.BelegFreigabe)
          .
          
        if lQtyIsNotCollectedFromVSC then 
          
          leave.
      
      end. /* for each bV_BelegPos */
      
      if lQtyIsNotCollectedFromVSC then 
      
        V_BelegKopf.BelegFreigabe = (if adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage('vsser00233':U) then 
                                       yes
                                     else
                                       no).
                                     
    end. /* if    V_BelegKopf.Herk_BelegArt = 'VSC':U */
    
  &ENDIF
  
  validate V_BelegKopf.

  /* Dispatch standard ADM method.                             */
  run dispatch in this-procedure ('assign-statement':U).

  /* Code placed here will execute AFTER standard behavior.    */

end. /* if available V_BelegKopf then */

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win 
PROCEDURE local-cancel-record :
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

  /* Code placed here will execute PRIOR to standard behavior. */

  if    lookup(pACConnectionSvc:prpcLocalization,'I,H':U) > 0
    and adm-new-record = yes
    and can-do((if pACConnectionSvc:prpcLocalization = 'I':U then
                  'R,G':U
                else
                  {&pa_V_H_NoUpdateAfterPrint}), V_BelegKopf.Belegart) then
    return 'ADM-ERROR':U.

  if lCancel = no then
  do:

    if lSpeichern = no then
    do:

      glAdd = yes.  /* dass die Meldung:                                              */
                    /* dm-sma-00003/vupauf00.w                                        */
                    /* Die Umschaltung der Sprache ist im Update-Modus nicht möglich! */
                    /* nicht erscheint                                                */

      run cancelNumberAssignment no-error.

      if return-value = 'ADM-ERROR':U then
        return return-value.

      /* Dispatch standard ADM method.                                        */
      run dispatch in this-procedure ( 'cancel-record':U ) .

      if return-value = 'adm-error':U then

        return 'adm-error':U.

      gladd = no.   /* reset */

      /* Jetzt kann umgeschaltet werden.      */
      /* Der Beleg ist nicht im Update-Modus. */

      if    available V_BelegKopf
        and pa-Sprache <> V_BelegKopf.Sprache
        and basis.user.cls.BUCUserPropertySvc:prpoInstance:cParameterValue
              ('V_':U + 'useDocLanguage_':U + V_BelegKopf.Belegart) = 'yes':U then

        run set-link-attribute in adm-broker-hdl (this-procedure,
                                                  'container-source':U,
                                                  'Sprache=':U + V_BelegKopf.Sprache).

    end.
    else

      run dispatch in this-procedure ('update-record':U).

  end.  /* if lCancel = no */
  else
  do:

    run new-state('update-complete':U).

    &IF DEFINED(PA-CREATE-FIELDS) > 0 &THEN
       pa-add-on-enable = no.
    &ENDIF

  end.

  /* Code placed here will execute AFTER standard behavior.    */

  assign
    lSpeichern = no
    lCancel    = no
    .

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-config-end V-table-Win 
PROCEDURE local-config-end :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Action to be taken at the end of an external configuration                 */
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

if available V_BelegKopf then
do:

  find current V_belegkopf
  exclusive-lock no-wait no-error.

  /* If the record is not available exclusive here, something is wrong */
  if not available V_BelegKopf then
  do:

    run dispatch ('cancel-record':U).

    return 'adm-error':U.

  end.

end.

end procedure. /* local-config-end */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-config-start V-table-Win 
PROCEDURE local-config-start :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Action to be taken at start of an external configuration                   */
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

if available V_belegkopf then
  find current V_BelegKopf
  no-lock.

end procedure. /* local-config-start */

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
/* Examples ------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/*----------------------------------------------------------------------------*/

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

define variable cTmp1 as character no-undo.

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

if available V_BelegKopf then
  run basis/buro/proc/bbpver00.w (             V_BelegKopf.Firma,
                                               cBereich,
                                               V_BelegKopf.V_BelegKopf_Obj,
                                  input-output cTmp1).

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
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
/* lAnswer      Answer of the user                                            */
/* lFoundOrder  true if a purchase or work order is found                     */
/* lPartIsSet   true if one line of this document contains a set              */
/*----------------------------------------------------------------------------*/

&IF  lookup("E_","{&PA-MODULE}") > 0
  or lookup("PP","{&pa-Module}") > 0 &THEN

  define variable lAnswer     as logical init yes no-undo.
  define variable lFoundOrder as logical init no  no-undo.
  define variable lPartIsSet  as logical init no  no-undo.

&ENDIF

&IF lookup("JB","{&PA-MODULE}") > 0 &THEN
  define variable cPartsPlanObj as  character     no-undo.
&ENDIF

/* Buffers -------------------------------------------------------------------*/

&IF LOOKUP("E_","{&PA-MODULE}") > 0 &THEN

  define buffer bS_Artikel for S_Artikel.

  &IF lookup("MU":U,"{&PA-MODULE}":U) > 0 &THEN
    define buffer bV_BelegPos   for V_BelegPos.
  &ENDIF

&ENDIF

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Code placed here will execute PRIOR to standard behavior ------------------*/

/* check-record in adm-delete-record needs the current document state (open/  */
/* archived (V_BelegKopf.offen). This might have changed if the doc. has      */
/* just been archived in another session while it is still being displayed    */

find current V_BelegKopf
  no-lock.

if    V_Belegkopf.Belegart = 'U':U
  and V_Belegkopf.offen    = yes then
do:

  /* if there exists at least one archived line then deletion is not allowed */

  if can-find (first V_BelegPos
                 where V_BelegPos.Firma      = V_BelegKopf.Firma
                   and V_BelegPos.Belegart   = V_BelegKopf.Belegart
                   and V_BelegPos.ReferenzNr = V_BelegKopf.ReferenzNr
                   and V_BelegPos.offen      = no) then

    adm.method.cls.DMCMessageSvc:prpoInstance:showError
      ('vuord00010':U,
       string(V_Belegkopf.Belegnummer)).

  if can-find (first V_BelegPos
                 where V_BelegPos.Firma             = V_BelegKopf.Firma
                   and V_BelegPos.Belegart          = V_BelegKopf.Belegart
                   and V_BelegPos.ReferenzNr        = V_BelegKopf.ReferenzNr
                   and V_BelegPos.gelieferte_Menge <> 0) then

    adm.method.cls.DMCMessageSvc:prpoInstance:showError
      ('v_bel00165':U,
       string(V_Belegkopf.Belegnummer)).

end. /* if V_Belegkopf.Belegart = 'U':U and V_Belegkopf.offen = yes */

/* In case the document has already been send by INWB or EDI a deletion of the*/
/* document should always be considered carefully. Show a message for that    */
/* case.                                                                      */

if     stamm.base.cls.SBCBusProcTransmissionSvc:prpoInstance:iGetTransmissionState
         (V_BelegKopf.V_BelegKopf_Obj) = {&pa_SB_TransState_transmitted}
   and not adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
             ('sbinw00004':U,
              string(V_BelegKopf.BelegNummer)) then

  return 'adm-error':U.    

&IF  lookup("E_","{&PA-MODULE}") > 0
  or lookup("PP","{&pa-Module}") > 0
  or lookup("JB","{&pa-Module}") > 0 &THEN

if can-do('U,A':U,V_BelegKopf.Belegart) then
do:

  /* this block will be leaved if a work order and a set are found */

  AllLines:
  for each V_BelegPos
    fields (Firma BelegNummer PositionsNr BelegArt ReferenzNr LfdNr_SR
            Artikel ArtVar WertPosition V_BelegPos_Obj)
    where V_BelegPos.Firma      = V_BelegKopf.Firma
      and V_BelegPos.Belegart   = V_BelegKopf.Belegart
      and V_BelegPos.ReferenzNr = V_BelegKopf.ReferenzNr
      and V_BelegPos.LfdNr_SR   = 0
      and V_BelegPos.Satzart    = 'A':U
    no-lock
    on error  undo, return 'adm-error':U
    on endkey undo, return 'adm-error':U:

    /* deletion is possible, but we alert the user to this fact if            */
    /* there exists a work order for at least one line.                       */
    /* If a purchase order has already been generated for at least one line   */
    /* then deletion is no longer possible since we have the possibility to   */
    /* archive a single order line.                                           */

    &IF LOOKUP("E_","{&PA-MODULE}") > 0 &THEN

      /* you only can generate a purchase order for a sales order      */
      /* (not for value items)                                         */

      if    V_BelegKopf.BelegArt    = 'U':U
        and V_BelegPos.WertPosition = no then
      do:

        /* Test if this order contains a set. */

        if lPartIsSet = no then
        do:

          find bS_Artikel
            where bS_Artikel.Firma   = {firma/sartikel.fir V_BelegPos.Firma}
              and bS_Artikel.Artikel = V_BelegPos.Artikel
            no-lock.

          lPartIsSet = can-do({&pa_S_PTList_Set}, string(bS_Artikel.ArtikelArt)).

        end. /* if lPartIsSet = no */

        if vert.base.cls.VBCSalesDocSvc:prpoInstance:lIsPurchaseOrderGenerated
             (V_BelegPos.V_BelegPos_Obj,?) = yes then

          adm.method.cls.DMCMessageSvc:prpoInstance:showError
            ('v_trg00071':U,
             string(V_BelegPos.PositionsNr),
             string(V_BelegPos.Belegnummer)).

        &IF lookup("MU":U,"{&PA-MODULE}":U) > 0 &THEN

          /* Check Sublines too */

          for each bV_BelegPos
            fields (BelegNummer PositionsNr V_BelegPos_Obj)
            where bV_BelegPos.Firma          = V_BelegPos.Firma
              and bV_BelegPos.BelegArt       = V_BelegPos.BelegArt
              and bV_BelegPos.ReferenzNr     = V_BelegPos.ReferenzNr
              and bV_BelegPos.LfdNr_SR       = V_BelegPos.LfdNr_SR
              and bV_BelegPos.VarPositionsNr = V_BelegPos.PositionsNr
              and bV_BelegPos.PositionsNr   <> V_BelegPos.PositionsNr
            no-lock
            on error undo, throw:

            if vert.base.cls.VBCSalesDocSvc:prpoInstance:lIsPurchaseOrderGenerated
                 (bV_BelegPos.V_BelegPos_Obj,?) = yes then

              adm.method.cls.DMCMessageSvc:prpoInstance:showError
                ('v_trg00071':U,
                 string(bV_BelegPos.PositionsNr),
                 string(bV_BelegPos.Belegnummer)).

          end. /* for each bV_BelegPos */

        &ENDIF

      end. /* if V_BelegKopf.BelegArt = 'U':U */

    &ENDIF

    &IF lookup("PP","{&pa-Module}") > 0 &THEN

      /* for both: sales order and quote (a quoted work order could be generated) */
      /* Asking for the same part is necessary because if you delete a line the */
      /* work order still can exist and if you create a new line with the same  */
      /* number this work order will be found. That's the reason why we can't   */
      /* use here lIsWorkOrderGenerated. The case creating a line with the same */
      /* part can't be proved.                                                  */

      if    lFoundOrder = no
        and can-find (first PP_Auftrag
                        where PP_Auftrag.Firma           = {firma/ppauftra.fir V_BelegPos.Firma}
                          and PP_Auftrag.Archived        = no
                          and PP_Auftrag.Auftragskennung = 'F':U
                          and PP_Auftrag.Kunde           = V_BelegKopf.Kunde
                          and PP_Auftrag.nicht_erster    = no
                          and PP_Auftrag.Belegnummer     = V_BelegKopf.Belegnummer
                          and PP_Auftrag.PositionsNr     = V_BelegPos.PositionsNr
                          and PP_Auftrag.Coverage_Obj    = V_BelegPos.V_BelegPos_Obj
                          and PP_Auftrag.Artikel         = V_BelegPos.Artikel
                          and PP_Auftrag.ArtVar          = V_BelegPos.ArtVar)  then
      do:

        lFoundOrder = yes.

        if lPartIsSet = yes then

          leave AllLines.

      end. /* if lFoundOrder = no */

    &ENDIF
    
    &IF lookup("JB","{&PA-MODULE}") > 0 &THEN
  
      if    V_BelegPos.Belegart     = 'U':U
        and V_BelegPos.WertPosition = no then
      do:
        
        cPartsPlanObj = proj.base.cls.JBCDocAssignSvc:prpoInstance:cPartsPlanOfDemand(V_BelegPos.V_BelegPos_Obj).
    
        if cPartsPlanObj > '':U then
    
          proj.base.cls.JBCDocAssignSvc:prpoInstance:DeleteDocAssignSales(cPartsPlanObj).
          
      end.  /* if V_BelegPos.Belegart = 'U':U */
  
    &ENDIF  /* JB */

  end. /* for each V_BelegPos */
  
  &IF  lookup("E_","{&PA-MODULE}") > 0
    or lookup("PP","{&pa-Module}") > 0 &THEN

    /* showing both messages if necessary */
  
    if lFoundOrder = yes then
    do:
  
      {adm/incl/d__msg00.if
        &Meldung   = "'v_bel00168':U"
        &Liste     = "'Delimiter=':U + {&PA-DELIMITER5} + ',':U
                      + string(V_BelegKopf.Belegnummer)"
        &Rueckgabe = "lOK"
      }
  
      if lOK = no then
  
        return 'adm-error':U.
  
    end.
  
    if lPartIsSet = yes then
    do:
  
      {adm/incl/d__msg00.if
        &Meldung   = "'v_bel00170':U"
        &Liste   = "'Delimiter=':U + {&PA-DELIMITER5} + ',':U
                     + string(V_BelegKopf.BelegNummer)"
        &Rueckgabe = "lAnswer"
      }
  
      if lAnswer = no then
  
        return 'adm-error':U.
  
    end. /* if lPartIsSet = yes */
  
  &ENDIF  /* E_/PP */

end. /* if can-do('U,A':U,V_BelegKopf.Belegart) */

&ENDIF

/* --> UMO#CE2018-07-001 MDe Auftragseingang Rahmenaufträge: Fehler bei Überlieferung */
&IF LOOKUP("U_CE":U,"{&PA-OPTIONEN}":U) > 0
  OR LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN

if  ( available V_BelegKopf
  and V_BelegKopf.BelegArt = 'U':U ) then
do:

  FE_gbuV_BelegPos:
  for each gbuV_BelegPos
    where gbuV_BelegPos.Firma       = {firma/vbelegko.fir pACConnectionSvc:prpcCompany}
      and gbuV_BelegPos.BelegArt    = V_BelegKopf.BelegArt
      and gbuV_BelegPos.ReferenzNr  = V_BelegKopf.ReferenzNr
      and gbuV_BelegPos.LfdNr_SR    = 0
    no-lock
    on error undo, throw:

    if  ( gbuV_BelegPos.uCE_TypeOrderEntry  > {&uCE_OrderEntryBO_noOE}
      and gbuV_BelegPos.Herk_BelegArt       = 'VUR':U
      and gbuV_BelegPos.Herk_ReferenzNr    <> ?
      and gbuV_BelegPos.Herk_PositionsNr   <> ? ) then
    do on error undo, throw:

      find current gbuV_BelegPos
        exclusive-lock no-wait no-error.

      /* check lock status */

      if  ( not available gbuV_BelegPos
        and locked(gbuV_BelegPos) ) then
      do:
        pACConnectionSvc:showRecordLockedMessage('V_BelegPos':U,
                                                 recid(gbuV_BelegPos)).
        undo, throw new adm.method.cls.DMCGenericErr().
      end. /* V_BelegPos locked */

      /* set quantity to zero and use v_belpow.p to write    */
      /* order entry of corresponding blanket order position */

      gbuV_BelegPos.Menge = 0.
      validate gbuV_BelegPos.
      release gbuV_BelegPos.

    end. /* do */

  end. /* FE_gbuV_BelegPos */

end. /* available V_BelegKopf */

&ENDIF
/* <-- UMO#CE2018-07-001 MDe Auftragseingang Rahmenaufträge: Fehler bei Überlieferung */

  if vert.fakt.cls.VFCEInvoiceSvc:prpoInstance:lEInvoiceStatusPreventsModifyingDocument(
       V_BelegKopf.V_BelegKopf_Obj,
       V_BelegKopf.BelegArt) then
       
     adm.method.cls.DMCMessageSvc:prpoInstance:showError
       ('vfbel00002':U).

/* Execute standard behavior -------------------------------------------------*/

run dispatch('delete-record':U).

/* Code placed here will execute AFTER standard behavior ---------------------*/
if return-value <> 'adm-error':U then
do:

  /* --> UMO#CA2016-05-003 MOu Rahmenauftrag: Auftragsschnellerfassung */
  &IF LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  run new-state('U_CAupdateCallerObject,container-source':U).
  &ENDIF
  /* <-- UMO#CA2016-05-003 MOu */

end.

end procedure. /* local-delete-record */

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
/* Examples ------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/*----------------------------------------------------------------------------*/

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

define buffer bV_BelegPos  for V_BelegPos.

define Buffer bV_BelegKopf     for V_BelegKopf.
define Buffer bV_BelegKopf-U   for V_BelegKopf.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Code placed here will execute PRIOR to standard behavior ------------------*/

if available V_BelegKopf then
do
  on error undo, return 'adm-error':U:

  {fn
     pa_lUISvcSetWaitState}.

  if    pACConnectionSvc:prpcLocalization = 'F':U 
    and can-do('R,G':U,V_BelegKopf.BelegArt)
    and adm.config.cls.DCCAppConfigSvc:prpoInstance:lParameterValue('VB_ArchiveDocInsteadOfDelete':U) = yes 
    and not stamm.base.cls.SBCLocalizationFRSvc:prpoInstance:lAssignExceptionReasonForDelete(V_BelegKopf.V_BelegKopf_Obj) then
    return 'adm-error':U.

  /* Before the lines getting deleted we have to set the adopted surcharges   */
  /* of the origin document to 0. Otherwise the surcharges of the new invoice */
  /* that was created from the origin document again will be 0.               */

  if vert.base.cls.VBCSalesDocSvc:prpoInstance:lIsCollectiveInvoice
       (V_BelegKopf.V_BelegKopf_Obj) then

    for each bV_BelegPos
      where bV_BelegPos.Firma      = V_BelegKopf.Firma
        and bV_BelegPos.Belegart   = V_BelegKopf.Belegart
        and bV_BelegPos.ReferenzNr = V_BelegKopf.ReferenzNr
      no-lock
      on error undo, throw:

      find first bV_BelegKopf
        where bV_BelegKopf.Firma      = bV_BelegPos.Firma
          and bV_BelegKopf.Belegart   = bV_BelegPos.Herk_BelegArt
          and bV_BelegKopf.ReferenzNr = bV_BelegPos.Herk_ReferenzNr
        exclusive-lock no-error.

      if available bV_BelegKopf then
        assign
          bV_BelegKopf.Zuschlag_ueber[1] = 0
          bV_BelegKopf.Zuschlag_ueber[2] = 0
          bV_BelegKopf.Zuschlag_ueber[3] = 0
          bV_BelegKopf.Zuschlag_ueber[4] = 0
          .

    end. /* for each bV_BelegPos */

  /*--------------------------------------------------------------------------*/
  /* Abhängige Positionen müssen von hier aus gelöscht werden, da die         */
  /* Trigger der Position etc. auf den Belegkopf zugreifen, dieser würde      */
  /* jedoch nicht mehr zur Verfügung stehen                                   */
  /*--------------------------------------------------------------------------*/
  vert.base.cls.VBCSalesDocumentSvo:DeleteSalesDocLines
    (V_BelegKopf.V_BelegKopf_Obj) no-error.

  if error-status:error then
    return 'adm-error':U.

  finally:
    {fn
       pa_lUISvcResetWaitState}.
  end finally.

end.

if   adm.config.cls.DCCAppConfigSvc:prpoInstance:lParameterValue('VB_ArchiveDocInsteadOfDelete':U) = no
  or not can-do('R,G':U,cBelegart) then

  run dispatch('delete-statement':U).

else
do transaction:

  /* Invoice + credit note archived */

  find bV_BelegKopf
    where rowid(bV_BelegKopf) = rowid(V_BelegKopf)
    exclusive-lock no-error.

  if available bV_BelegKopf then
  do:

    assign
      bV_BelegKopf.offen             = false
      bV_BelegKopf.DMSStatus         = {&pa_O_DMSStatus_BelegLoeschbereit}
      bV_BelegKopf.Statistik_erzeugt = true
      bV_BelegKopf.Belegfreigabe     = true
      bV_BelegKopf.gedruckt          = true
      bV_BelegKopf.BelegInfo         = adm.config.cls.DCCAppConfigSvc:prpoInstance:cParameterValue('FB_PostingText_CancelOrg':U)
      bV_BelegKopf.Endbetrag         = 0
      bV_BelegKopf.Gesamtnetto       = 0
      bV_BelegKopf.Endbetrag_Brutto  = 0
      bV_BelegKopf.Gesamtbrutto      = 0
      bV_BelegKopf.Zuschlag[1]       = 0
      bV_BelegKopf.Zuschlag[2]       = 0
      bV_BelegKopf.Zuschlag[3]       = 0
      bV_BelegKopf.Zuschlag[4]       = 0
      bV_BelegKopf.Zuschlag_Ueber[1] = 0
      bV_BelegKopf.Zuschlag_Ueber[2] = 0
      bV_BelegKopf.Zuschlag_Ueber[3] = 0
      bV_BelegKopf.Zuschlag_Ueber[4] = 0
      bV_BelegKopf.ZuschlSum_Netto   = 0
      bV_BelegKopf.ZuschlSum_Brutto  = 0
      bV_BelegKopf.NettoSumme[11]    = 0
      bV_BelegKopf.NettoSummeGes[11] = 0
      bV_BelegKopf.BruttoSumme[11]   = 0
      bV_BelegKopf.ZuschlagHerkunft  = '':U
      bV_BelegKopf.proz_Zuschlag     = 0
      .

    &IF lookup ("V_Anz":U,"{&PA-OPTIONEN}":U) > 0 &THEN

      /* Auftrag beim löschen der Schlussrechnung wieder öffnen */

      if bV_BelegKopf.Belegart           = 'R':U
        and bV_BelegKopf.Schlussrechnung = true then
      do:

        /* zu einer Schlußrechnung kann und darf es nur einen Auftrag geben */

        find first bV_BelegKopf-U
          where bV_BelegKopf-U.V_BelegKopf_Obj = bV_BelegKopf.Origin_Obj
            and can-do('U,VUA':U,bV_BelegKopf-U.Belegart)
            and bV_BelegKopf-U.Belegnummer     = bV_BelegKopf.AuftragsNr
          exclusive-lock no-error.

        if available bV_BelegKopf-U then

          assign
            bV_BelegKopf-U.Belegfreigabe = yes
            bV_BelegKopf-U.offen = yes
            .

      end.

    &ENDIF  /* Anzahlungen */

    /* Bei Bezug zu Serviceauftrag, diesen suchen, öffnen und zurücksetzen */

    &IF lookup("VS_SAUF":U,"{&PA-OPTIONEN}":U) > 0 &THEN

      if V_BelegKopf.Herk_Belegart = 'VSA':U then
      do:

        find VS_Auftrag
          where VS_Auftrag.Firma       = V_BelegKopf.Firma
            and VS_Auftrag.Belegart    = V_BelegKopf.Herk_Belegart
            and VS_Auftrag.ReferenzNr  = V_BelegKopf.Herk_ReferenzNr
          exclusive-lock no-error.

        if available VS_Auftrag then
          assign
            VS_Auftrag.offen         = yes
            VS_Auftrag.Belegfreigabe = YES
            .

      end.

    &ENDIF

  end. /* if available bV_BelegKopf then do: */

end. /* else(adm.config.cls.DCCAppConfigSvc:prpoInstance:lParameterValue('VB_ArchiveDocInsteadOfDelete':U)) */

/* Code placed here will execute AFTER standard behavior ---------------------*/

end procedure. /* local-delete-statement */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
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

/* Flag setzen, damit während des Speicherns, wenn keine Teilepositionen      */
/* und die Abfrage nach dem Stornieren nicht zum Fehler 5407 führt.           */
/* Mit dem Destroy wird die Abfrage unterbunden.                              */

glDestroy = yes.

/* Execute standard behavior -------------------------------------------------*/

run dispatch('destroy':U).

/* Code placed here will execute AFTER standard behavior ---------------------*/

end procedure. /* local-destroy */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
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

/* Code placed here will execute PRIOR to standard behavior. */

/* Dispatch standard ADM method.                             */
run dispatch in this-procedure ('disable-fields':U).

/* Code placed here will execute AFTER standard behavior.    */

if return-value <> 'adm-error':U then
do:

  /* Behandlung manuelle Zahlungsziele bei Rechnungen/Gutschriften */

  if    available V_BelegKopf
    and can-do('R':U,V_BelegKopf.Belegart) then
  do:

    find S_ZahlZiel
      where S_ZahlZiel.Firma        = {firma/szahlzie.fir pa-Firma}
        and S_ZahlZiel.Archived     = no
        and S_ZahlZiel.Zahlungsziel = V_BelegKopf.Zahlungsziel
      no-lock no-error.

    if    available S_ZahlZiel
      and S_ZahlZiel.manuell = yes then

      run set-attribute-list ('Zahlungsziel=yes':U).

  end.

  &IF lookup("V_ANZ","{&PA-OPTIONEN}") > 0 &THEN

    if can-do('U,VUA,L':U,cBelegart) then

      run set-attribute-list ('FinalInvoice=no':U).

  &ENDIF

  &IF lookup("MU":U,"{&PA-MODULE}":U) > 0 &THEN

    if can-do('A,U':U,cBelegart) then

      run set-attribute-list ('KonfigProduct=no':U).

  &ENDIF

  lSatz_offen = no.

  run set-attribute-list ('ChangeAddress=no':U).
  run set-attribute-list ('ChangeParameter=no':U).
  run new-state ('Satz-geschlossen,container-source':U).

  run pa_UISvcApplyEventToWidgetByHandle
        ('entry':U,
         V_BelegKopf.Kunde:handle in frame {&frame-name}).

  /* ggf. Menupunkt für Fakturierung Streckenauftrag aktivieren */

  if    available V_BelegKopf
    and V_BelegKopf.offen = yes
    and can-do('U':U,V_BelegKopf.Belegart)

      /* --> UMO#WH2015-07-011 cpl Sammelstreckenfaktura */
      &IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
      and can-find(first V_BelegPos
                      of V_BelegKopf
                   where V_BelegPos.offen            = yes
                     and V_BelegPos.uCI_Vertriebsweg = {&uCI_VertriebswegStrecke}) then
      &ELSE
    and V_BelegKopf.Strecke = yes then
      &ENDIF
      /* <-- UMO#WH2015-07-011 cpl Sammelstreckenfaktura */

    run set-attribute-list ('Invoice=yes':U).

  assign
    glUpdate         = no
    glZustandPruefen = yes
    .

  run new-state ('Belegkopf-geschlossen,record-target':U).

  run set-attribute-list ('Bestimmungsorte=no':U).

  /* All global variables for modifying the bank data must be resetted here.  */
  /* Disable is called wether saving or aborting.                             */

  assign
    gcAccount    = '':U
    gcBank       = '':U
    gcIBAN       = '':U
    gcOIDBank    = '':U
    glModifyBank = no
    .

end. /* if return-value <> 'adm-error':U then */

end procedure.

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

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Code placed here will execute PRIOR to standard behavior. */

assign
  cLieferadresse    = '':U
  cRechnungsadresse = '':U
  gcBelegInfoRA     = '':U
  gcBestimmungsort  = '':U
  cFO_OP_Obj        = '':U
  giCustDeclState   = 0
  .

if adm-new-record = no then

  assign
    c_Name-1  = '':U
    c_Name-2  = '':U
    c_Strasse = '':U
    c_Ort     = '':U
    gcEMail   = '':U
    gcStaat   = '':U
    .

find first ttS_Adresse
  no-error.

if available ttS_Adresse
  and adm-new-record = no then
do:
  delete ttS_Adresse.
  create ttS_Adresse.
  ttS_Adresse.Firma = {firma/s_adres.fir pACConnectionSvc:prpcCompany}.
end.

if available V_BelegKopf then
do:

  if V_BelegKopf.Belegart = 'R':U then
  do:

    gcBelegInfoRA =
      (if    V_BelegKopf.Schlussrechnung = yes
         and V_BelegKopf.Teilrechnung    = no then
         pACConnectionSvc:cTranslatedString('factura-information':U,'1':u)
       else if V_BelegKopf.Schlussrechnung = yes
         and V_BelegKopf.Teilrechnung      = yes then
         pACConnectionSvc:cTranslatedString('factura-information':U,'2':u)
       else if V_BelegKopf.DFUGutschriftenanzeige = yes
         and V_BelegKopf.Gutschriftenanzeigeart   = 1 then
         pACConnectionSvc:cTranslatedString('factura-information':U,'5':u)
       else if V_BelegKopf.Schlussrechnung = no
         and V_BelegKopf.SAuftragsNr       = ?
         and vert.base.cls.VBCSalesDocSvc:prpoInstance:lIsCollectiveInvoice
               (V_BelegKopf.V_BelegKopf_Obj) = yes then

         pACConnectionSvc:cTranslatedString('factura-information':U,'3':u)

       else if V_BelegKopf.Schlussrechnung = no
         and V_BelegKopf.Teilrechnung      = no
         and can-find(first V_BelegPos
                        where V_BelegPos.Firma      = V_BelegKopf.Firma
                          and V_BelegPos.BelegArt   = V_BelegKopf.Belegart
                          and V_BelegPos.ReferenzNr = V_BelegKopf.ReferenzNr
                          and can-find(S_Artikel
                                         where S_Artikel.Firma      = {firma/sartikel.fir pa-firma}
                                           and S_Artikel.Artikel    = V_BelegPos.Artikel
                                           and S_Artikel.ArtikelArt = {&pa_S_PT_PartPayAndMarkdowns})) then
         pACConnectionSvc:cTranslatedString('factura-information':U,'4':u)
       else
         '':U).

    if gcBelegInfoRA = '':U then

      gcBelegInfoRA = {fnarg
                        pa_cStCchDocTypeDesc
                        "'R':U,
                         pa-Sprache,
                         {&pa_CchDesc}"}.

  end. /* if V_BelegKopf.Belegart = 'R':U */

  find S_Kunde
    where S_Kunde.Firma = {firma/s_kunde.fir pa-firma}
      and S_Kunde.Kunde = V_BelegKopf.Kunde
    no-lock.

  &IF LOOKUP("VC","{&PA-MODULE}") > 0 &THEN

    find VC_Interessent                /* code checked by Balg_U 21.02.2013 */
      where VC_Interessent.Firma       = {firma/s_kunde.fir pa-Firma}
        and VC_Interessent.Interessent = V_BelegKopf.Interessent
      no-lock no-error.                /* check if available will be done in v_wbel00.if */

  &ENDIF

  find V_BelegKopfAdr
    where V_BelegKopfAdr.Firma      = V_BelegKopf.Firma
      and V_BelegKopfAdr.Belegart   = V_BelegKopf.Belegart
      and V_BelegKopfAdr.ReferenzNr = V_BelegKopf.ReferenzNr
      and V_BelegKopfAdr.Typ        = 'K':U
    no-lock no-error.

  if     available V_BelegKopfAdr
    and (   (    V_BelegKopf.offen = yes
             and S_Kunde.AdressNr  = 0)
         or V_BelegKopf.offen      = no
         or not can-do('A,U,VUA,VUR':U,V_BelegKopf.Belegart)) then
  do:

    buffer-copy
      V_BelegKopfAdr except Firma
      to ttS_Adresse
      assign
        ttS_Adresse.Firma = {firma/s_adres.fir pACConnectionSvc:prpcCompany}
        c_Name-1 = V_BelegKopfAdr.Name1
        c_Name-2 = V_BelegKopfAdr.Name2
        gcEMail  = V_BelegKopfAdr.eMail
        gcStaat  = V_BelegKopfAdr.Staat
        .

    c_Ort     = c_AnzOrtsformat(V_BelegKopfAdr.Staat,
                                V_BelegKopfAdr.Bundesland,
                                V_BelegKopfAdr.PLZ,
                                V_BelegKopfAdr.Ort).

    c_Strasse = c_Strassenformat(V_BelegKopfAdr.Staat,
                                 V_BelegKopfAdr.Strasse,
                                 V_BelegKopfAdr.Hausnummer).

    /* Search for S_Adresse entry to get values of mobile phone */
    /* etc. numbers which are not stored in V_BelegKopfAdr      */

    if available VC_Interessent then
    do:

      find S_Adresse
        where S_Adresse.Firma    = {firma/s_adres.fir pACConnectionSvc:prpcCompany}
          and S_Adresse.AdressNr = VC_Interessent.AdressNr
        no-lock no-error.

      if available S_Adresse then
      do:

        assign
          ttS_Adresse.Autotelefon = S_Adresse.Autotelefon
          ttS_Adresse.Handy       = S_Adresse.Handy
          ttS_Adresse.Homepage    = S_Adresse.Homepage
          ttS_Adresse.Telefax2    = S_Adresse.Telefax2
          ttS_Adresse.Telefon2    = S_Adresse.Telefon2
          .

      end. /* available S_Adresse */
    end. /* available VS_Interessent */
  end. /* Belegadresse */
  else
  do:

    find S_Adresse
      where S_Adresse.Firma    = {firma/s_adres.fir pACConnectionSvc:prpcCompany}
        and S_Adresse.AdressNr = S_Kunde.AdressNr
      no-lock no-error.

    if available S_Adresse then
    do:

      buffer-copy
        S_Adresse to
        ttS_Adresse
        assign
          c_Name-1 = S_Adresse.Name1
          c_Name-2 = S_Adresse.Name2
          gcEMail  = S_Adresse.eMail
          gcStaat  = S_Adresse.Staat
          .

      c_Ort     = c_AnzOrtsformat(S_Adresse.Staat,
                                  S_Adresse.Bundesland,
                                  S_Adresse.PLZ,
                                  S_Adresse.Ort).

      c_Strasse = c_Strassenformat(S_Adresse.Staat,
                                   S_Adresse.Strasse,
                                   S_Adresse.Hausnummer).
    end.

  end. /* Stammadresse */

  run set-link-attribute in adm-broker-hdl
    (this-procedure,
     'record-target':U,
     'BelegDatum=':U + string(V_BelegKopf.BelegDatum)).

  run set-link-attribute in adm-broker-hdl
    (this-procedure,
     'record-target':U,
     'Versandart=':U + string(V_BelegKopf.Versandart)).

  run set-link-attribute in adm-broker-hdl
    (this-procedure,
     'record-target':U,
     'Staat=':U + gcStaat).

  /* Behandlung manuelle Zahlungsziele bei Rechnungen/Gutschriften */

  if    available V_BelegKopf
    and can-do('R':U,V_BelegKopf.Belegart) then
  do:

    find S_ZahlZiel
      where S_ZahlZiel.Firma        = {firma/szahlzie.fir pa-Firma}
        and S_ZahlZiel.Archived     = no
        and S_ZahlZiel.Zahlungsziel = V_BelegKopf.Zahlungsziel
      no-lock no-error.

    if    available S_ZahlZiel
      and S_ZahlZiel.manuell = yes then

      run set-attribute-list ('Zahlungsziel=yes':U).

    else

      run set-attribute-list ('Zahlungsziel=no':U).

  end.
  else

    run new-state ('kein_ZahlZiel,Container-Source':U).

  &IF lookup("FB","{&PA-MODULE}")   > 0
    and lookup("FO","{&PA-MODULE}") > 0 &THEN

    if    V_BelegKopf.offen = no
      and can-do ('R,G':U,V_BelegKopf.Belegart) then
    do:

      release FB_Buchung.
      release FO_OP.

      find first FB_Buchung
        where FB_Buchung.Firma           = {firma/fbbuchu.fir pa-Firma}
          and FB_Buchung.Konto           = V_BelegKopf.Kunde
          and FB_Buchung.Belegnummer     = V_BelegKopf.Belegnummer
          and FB_Buchung.Belegdatum      = V_BelegKopf.Belegdatum
          and FB_Buchung.Herk_Belegart   = V_BelegKopf.Belegart
          and FB_Buchung.Herk_ReferenzNr = V_BelegKopf.ReferenzNr
        use-index KontoBeleg
        no-lock no-error.

      if available FB_Buchung then

        find FO_OP
          where FO_OP.FB_Buchung_Obj = FB_Buchung.FB_Buchung_Obj
          no-lock no-error.

      cFO_OP_Obj = (if available FO_OP then
                      FO_OP.FO_OP_Obj
                    else
                      '':U).

    end. /* offene Rechnungen und Gutschriften */

  &ENDIF

  &IF lookup("M_ATLAS","{&PA-OPTIONEN}") > 0 &THEN

    if    can-do('U,L,VFP,VUD,R':U,V_BelegKopf.Belegart)
      and stamm.base.cls.SBCLocalApplicationSvc:prpoInstance:lCheckModulsAndOptionsAtlas(no) then

      giCustDeclState= pa_iCustDeclGetDeclState (V_BelegKopf.Firma,
                                                 'V_BelegKopf':U,
                                                 {vert/incl/v_belko.sl &Tabelle = "V_BelegKopf"}).

  &ENDIF

end. /* if available V_BelegKopf then */

if available V_BelegKopf then

  gcAddressInfoWinTitle = adm.method.cls.DMCParameterStringSvc:cWriteValue(gcAddressInfoWinTitle,
                                                                             'pa-AddressInfoTitleExtension':U,
                                                                             V_BelegKopf.Kunde).

  else

    gcAddressInfoWinTitle = adm.method.cls.DMCParameterStringSvc:cWriteValue(gcAddressInfoWinTitle,
                                                                             'pa-AddressInfoTitleExtension':U,
                                                                             '':U).

/* ggf. Menupunkt für Fakturierung Streckenauftrag aktivieren */

if    available V_BelegKopf
  and V_BelegKopf.offen = yes
  and can-do('U':U,V_BelegKopf.Belegart)

    /* --> UMO#WH2015-07-011 cpl Sammelstreckenfaktura */
    &IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
    and can-find(first V_BelegPos
                    of V_BelegKopf
                 where V_BelegPos.offen            = yes
                   and V_BelegPos.uCI_Vertriebsweg = {&uCI_VertriebswegStrecke}) then
    &ELSE
  and V_BelegKopf.Strecke = yes then
    &ENDIF
    /* <-- UMO#WH2015-07-011 cpl Sammelstreckenfaktura */

  run set-attribute-list ('Invoice=yes':U).

else

  run set-attribute-list ('Invoice=no':U).

if    available V_BelegKopf
  and V_BelegKopf.offen    = no
  and V_BelegKopf.Belegart = 'A':U then

  run set-attribute-list ('Dearchivierung=yes':U).

else

  run set-attribute-list ('Dearchivierung=no':U).

if available V_BelegKopf then
do:

  run set-link-attribute in adm-broker-hdl
    (this-procedure,
     'container-source':U,
     'Belegsprache=':U + V_BelegKopf.Sprache).

  if    pa-Sprache       <> V_BelegKopf.Sprache
    and glAdd             = no
    and glBeleguebernahme = no
    and basis.user.cls.BUCUserPropertySvc:prpoInstance:cParameterValue
          ('V_':U + 'useDocLanguage_':U + V_BelegKopf.Belegart) = 'yes':U then

    run set-link-attribute in adm-broker-hdl (this-procedure,
                                              'container-source':U,
                                              'Sprache=':U + V_BelegKopf.Sprache).

  if    V_BelegKopf.Belegart      = 'L':U
    and V_BelegKopf.Herk_Belegart = 'U':U then

    run set-attribute-list ('AddOrderLine=yes':U).

  else

    run set-attribute-list ('AddOrderLine=no':U).

end.  /* if available V_BelegKopf */

if    available V_BelegKopf
  and can-find(first SBM_I_eInvoicing
               where SBM_I_eInvoicing.Owning_Obj = V_BelegKopf.V_BelegKopf_Obj) then
  cISdINo =  substring(string(year(V_BelegKopf.BelegDatum)), 3, 2)
           + '/':U
           + string(V_BelegKopf.BelegNummer, '99999999':U)
           + '/':U
           + substring(string(V_BelegKopf.I_TaxRegisterKey), 1, 8).
else
  cISdINo = '':U.

/* Dispatch standard ADM method.                             */
run dispatch in this-procedure ('display-fields':U).

/* Code placed here will execute AFTER standard behavior.    */

if return-value <> 'adm-error':U then
do:

  &IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
    /* Basis Belegstatus */
    if available V_BelegKopf
      and can-do({&uCI_StatusDisplayHeadDocTypes},V_BelegKopf.BelegArt) then
    do:
      {adm/incl/d__run03.if
        &Procedure   = "branche/vert/proc/uvndoc00.p"
        &Arguments   = "input  V_BelegKopf.V_BelegKopf_Obj,
                        input  V_BelegKopf.BelegArt,
                        input  V_BelegKopf.ReferenzNr,
                        output gcuCIBelegStatus"
      }.
    end. /* do */
    else
      gcuCIBelegStatus = '':U.

    assign
      {setwidgetattr
         "gcuCIBelegStatus"
         "tooltip"
         "replace(gcuCIBelegStatus,'*':U,'':U)"
         "in frame {&FRAME-NAME}"}
      gcuCIBelegStatus                                     = entry(1,gcuCIBelegStatus,{&pa-eol})
      {setwidgetattr
         "gcuCIBelegStatus"
         "screen-value"
         "gcuCIBelegStatus"
         "in frame {&FRAME-NAME}"}
      .
    /* Basis Belegstatus */

  &ENDIF /* U_CI */

  &IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) = 0 &THEN

    /* Vorkonfigurationsvariante */

    {fnarg
      pa_lUISvcSetWidgetHiddenState
      "V_BelegKopf.VBM_PreConfigVariant_Obj:handle in frame {&FRAME-NAME},
       yes"}.

    {fnarg
      pa_lUISvcSetWidgetHiddenState
      "V_Bele_PreConfigVariant_Obj_Info:handle in frame {&FRAME-NAME},
       yes"}.

  &ELSE

    /* Vorkonfigurationsvariante */

    {fnarg
      pa_lUISvcSetWidgetHiddenState
      "V_BelegKopf.VBM_PreConfigVariant_Obj:handle in frame {&FRAME-NAME},
       no"}.

    {fnarg
      pa_lUISvcSetWidgetHiddenState
      "V_Bele_PreConfigVariant_Obj_Info:handle in frame {&FRAME-NAME},
       no"}.

  &ENDIF

  /* --> UMO#CM2017-05-001 tri Versandstückliste */
  &IF LOOKUP("U_CM":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  if available V_BelegKopf
    and V_BelegKopf.BelegArt = 'VUD':U then
  do:

    gluCM_Versand = can-find(first V_BelegPos
                             where V_BelegPos.Firma       = {firma/vbelegko.fir pACConnectionSvc:prpcCompany}
                               and V_BelegPos.BelegArt    = V_BelegKopf.BelegArt
                               and V_BelegPos.ReferenzNr  = V_BelegKopf.ReferenzNr
                               and V_BelegPos.uCM_Versand = yes
                             use-index Main).

    {adm/incl/d__duh00.if
       &Var1     = "gluCM_Versand"
       &WithFrame = "frame {&frame-name}"}

  end. /* if available V_BelegKopf */
  &ENDIF
  /* <-- UMO#CM2017-05-001 tri Versandstückliste */

  /* --> UMO#CA2016-03-001 PWa Gutschriftsverfahren */
  &IF LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN

    if available V_BelegKopf
      and V_BelegKopf.BelegArt = 'GSA':U then
    do:

      /* Button btnuFreigabe enablen/disablen */

      {fnarg
        pa_lUISvcSetWidgetSensitiveState
        "btnuFreigabe:handle in frame {&frame-name},
         (    not pa-fields-enabled
          and not cRunmode matches '*info*':U
          and available V_BelegKopf
          and V_BelegKopf.BelegArt = 'GSA':U
          and pa_lUISvcObjectState('upaSCGSA':U))"}.

    end. /* Gutschriftsanzeigen */

  &ENDIF
  /* <-- UMO#CA2016-03-001 PWa Gutschriftsverfahren */

  if pACConnectionSvc:prpcLocalization = 'H':U then

    if not available V_BelegKopf
      or not can-do('R':U,V_BelegKopf.BelegArt) then
    do:

      {fnarg
        pa_lUISvcSetWidgetHiddenState
        "V_BelegKopf.H_InvoiceType:handle in frame {&FRAME-NAME}, yes"}.

      {fnarg
        pa_lUISvcSetWidgetHiddenState
        "V_BelegKopf.H_Cancelled:handle in frame {&FRAME-NAME}, yes"}.

      {fnarg
        pa_lUISvcSetWidgetHiddenState
        "V_BelegKopf.H_Corrected:handle in frame {&FRAME-NAME}, yes"}.

    end. /* if not available V_BelegKopf */

    else
    do:

      {fnarg
        pa_lUISvcSetWidgetHiddenState
        "V_BelegKopf.H_InvoiceType:handle in frame {&FRAME-NAME}, no"}.

      {fnarg
        pa_lUISvcSetWidgetHiddenState
        "V_BelegKopf.H_Cancelled:handle in frame {&FRAME-NAME}, no"}.

      {fnarg
        pa_lUISvcSetWidgetHiddenState
        "V_BelegKopf.H_Corrected:handle in frame {&FRAME-NAME}, no"}.

    end. /* else (if not available V_BelegKopf) */

end. /* return-value <> 'adm-error' */

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

&IF lookup("V_ANZ","{&PA-OPTIONEN}") > 0 &THEN
  define buffer bV_BelegKopf for V_BelegKopf.
&ENDIF

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Code placed here will execute PRIOR to standard behavior. */

assign
  lSpeichern   = no
  lCancel      = no
  gcOIDBank    = V_BelegKopf.SBM_BankDataAcc_Obj
  gcBank       = V_BelegKopf.Bank
  gcAccount    = V_BelegKopf.BankKonto
  gcIBAN       = V_BelegKopf.IBAN
  gcTaxCodeOID = V_BelegKopf.S_Steuer_Obj
  .

/* Check and display the status when opening the record                       */
/* In case of adm-new-record enable-field is called twice                     */

if adm-new-record = no then
  glZustandPruefen = yes.

/* --> UMO#CA2016-03-001 PWa Gutschriftsverfahren */
&IF LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN

  define variable iuDocNoCreditMemo  as integer       no-undo.
  define variable iuDocNoShippingDoc   as integer       no-undo.
  define variable iuState          as integer       no-undo.

  if V_BelegKopf.BelegArt       = 'GSA':U
    and V_BelegKopf.uGSAStatus  = {&uCA_CreditMemoState_Archived} then
    adm.method.cls.DMCMessageSvc:prpoInstance:ShowError('uvgut000005':U).

  if V_BelegKopf.BelegArt = 'GSA':U then
  do:

    branche.vert.cls.UVC_CACreditMemoSvc:prpoInstance:StateOfPrecedingCreditMemo
                       (pa-Firma,
                        V_BelegKopf.BelegArt,
                        V_BelegKopf.Referenznr,
                        output iuDocNoCreditMemo,
                        output iuDocNoShippingDoc,
                        output iuState).

    if iuState < {&uCA_CreditMemoState_Archived} then
      adm.method.cls.DMCMessageSvc:prpoInstance:ShowError('uvgut000007':U,
                                                           string(iuDocNoCreditMemo),
                                                           string(iuDocNoShippingDoc)).

  end. /* if V_BelegKopf.BelegArt = 'GSA':U */

&ENDIF
/* <-- UMO#CA2016-03-001 PWa Gutschriftsverfahren */

if pACConnectionSvc:prpcLocalization = 'H':U then
do:

  if can-find(first Buf1_V_BelegKopf
              where Buf1_V_BelegKopf.Firma        = {firma/vbelegko.fir pa-firma}
                and Buf1_V_BelegKopf.Belegart     = cBelegart
                and Buf1_V_BelegKopf.offen        = yes
                and Buf1_V_BelegKopf.Belegnummer  = input frame {&frame-name} V_BelegKopf.Belegnummer
                and Buf1_V_BelegKopf.gedruckt     = yes
                and can-do({&pa_V_h_NoUpdateAfterPrint},V_BelegKopf.Belegart))
    and ADM-NEW-RECORD = no then

    adm.method.cls.DMCMessageSvc:prpoInstance:showError
      ('v_belh0007':U,
       V_BelegKopf.Belegnummer:screen-value in frame {&FRAME-NAME}).

  if cBelegArt = 'R':U
    and can-find(first Buf1_V_BelegKopf
                  where Buf1_V_BelegKopf.Firma         = {firma/vbelegko.fir pa-firma}
                    and Buf1_V_BelegKopf.Belegart      = cBelegart
                    and Buf1_V_BelegKopf.offen         = yes
                    and Buf1_V_BelegKopf.Belegnummer   = input frame {&frame-name} V_BelegKopf.BelegNummer
                    and Buf1_V_BelegKopf.H_InvoiceType = 1)
    and ADM-NEW-RECORD = no then

    adm.method.cls.DMCMessageSvc:prpoInstance:showError('v_belh1004':U).

end. /* if pACConnectionSvc:prpcLocalization = 'H':U then */

if    pACConnectionSvc:prpcLocalization = 'I':U
  and available V_BelegKopf
  and stamm.base.cls.SBCLocalizationITSvc:prpoInstance:lisDocumentBlockedBySDI(V_BelegKopf.V_BelegKopf_Obj) then

  adm.method.cls.DMCMessageSvc:prpoInstance:showError
    ('vfsdii0002':U,
     string(V_BelegKopf.Belegnummer)).

/* Check EInvoice status */

if    available V_BelegKopf 
  and vert.fakt.cls.VFCEInvoiceSvc:prpoInstance:lEInvoiceStatusPreventsModifyingDocument(
        V_BelegKopf.V_BelegKopf_Obj,
        V_BelegKopf.BelegArt) then

     adm.method.cls.DMCMessageSvc:prpoInstance:showError
       ('vfbel00002':U).

/* Dispatch standard ADM method.                             */
run dispatch in this-procedure ('enable-fields':U).

/* Code placed here will execute AFTER standard behavior.    */

if return-value <> 'adm-error':U then
do:

  /* --> UMO#CA2016-06-010 Versand Sammellieferschein */
  /* Sammellieferschein nur abschaltbar, nicht anschaltbar */
  {fnarg
    pa_lUISvcSetWidgetSensitiveState
    "V_BelegKopf.uCI_Sammellieferschein:handle in frame {&frame-name},
     (available S_Kunde and S_Kunde.uCI_Sammellieferschein and cBelegart <> 'L':U)"}.
  /* <-- UMO#CA2016-06-010 Versand Sammellieferschein */

  /* --> UMO#CA2016-03-001 PWa Gutschriftsverfahren */
  &IF LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN

    {fnarg
      pa_lUISvcDisableWidget
        "btnuFreigabe:handle in frame {&frame-name}"}.

  &ENDIF
  /* <-- UMO#CA2016-03-001 PWa Gutschriftsverfahren */

  &IF lookup("V_ANZ","{&PA-OPTIONEN}") > 0 &THEN

    if available V_BelegKopf then
    do:

      /* an order can only be marked as partial payment if                     */
      /* - it doesn't have a payment plan                                      */
      /* - it is no drop shipment - neither at header nor at item level (U_CI) */

      if   (    can-do('U,VUA':U,V_BelegKopf.Belegart)
            and not can-find(first VBT_DocPaymentLines
                               where VBT_DocPaymentLines.Owning_Obj = V_BelegKopf.V_BelegKopf_Obj)
            and not can-find(S_Versandart               /* drop shipment can't be a partial payment */
                               where S_VersandArt.Firma      = {firma/sversart.fir V_BelegKopf.Firma}
                                 and S_VersandArt.VersandArt = V_BelegKopf.VersandArt
                                 and S_VersandArt.Strecke    = yes)
            &IF LOOKUP("U_CI","{&PA-OPTIONEN}") > 0 &THEN
            and not can-find(first V_BelegPos
                               where V_BelegPos.Firma           = V_BelegKopf.Firma
                                 and V_BelegPos.BelegArt        = V_BelegKopf.BelegArt
                                 and V_BelegPos.ReferenzNr      = V_BelegKopf.ReferenzNr
                                 and V_BelegPos.Satzart         = 'A':U
                                 and V_BelegPos.uCI_Versandart <> ?
                                 and can-find(S_Versandart               /* drop shipment can't be a partial payment */
                                                where S_VersandArt.Firma      = {firma/sversart.fir V_BelegKopf.Firma}
                                                  and S_VersandArt.VersandArt = V_BelegPos.uCI_Versandart
                                                  and S_VersandArt.Strecke    = yes))
            &ENDIF
            )

        /* check if origin order of this delivery note is marked as */
        /* partial payment transaction                              */
        or (    V_BelegKopf.BelegArt = 'L':U
            and (     can-find(first bV_BelegKopf
                                 where bV_BelegKopf.V_BelegKopf_Obj = V_BelegKopf.Origin_Obj
                                   and can-do('U,VUA':U,bV_BelegKopf.Belegart)
                                   and bV_BelegKopf.offen           = yes
                                   and bV_BelegKopf.Belegnummer     = V_BelegKopf.AuftragsNr
                                   and bV_BelegKopf.Schlussrechnung = yes)
                 &IF   lookup("VS":U,"{&PA-MODULE}":U)        > 0
                   and lookup("VS_SAUF":U,"{&PA-OPTIONEN}":U) > 0 &THEN
                   or can-find(first VS_Auftrag
                                 where VS_Auftrag.VS_Auftrag_Obj = V_BelegKopf.Origin_Obj
                                   and VS_Auftrag.offen          = yes
                                   and VS_Auftrag.FinalInvoice   = yes)
                 &ENDIF
                )) then

        run set-attribute-list ('FinalInvoice=yes':U).

      else

        run set-attribute-list ('FinalInvoice=no':U).

    end.

  &ENDIF

  &IF lookup("V_PKF":U,"{&PA-OPTIONEN}":U) > 0 &THEN
    &IF lookup("MU","{&PA-MODULE}") > 0 &THEN

      if    available V_BelegKopf
        and can-do('A,U':U,V_BelegKopf.Belegart)
        and V_BelegKopf.Konfiguration = yes
        /* --> UMO#WH2015-07-010 cpl Strecke code checked <-- */
        and V_BelegKopf.Strecke       = no then

        run set-attribute-list ('KonfigProduct=yes':U).

    &ENDIF
  &ENDIF

  assign
    lArchivieren = no
    lSatz_offen  = yes
    .

  run set-attribute-list ('ChangeParameter=yes':U).
  run new-state ('Satz-geoeffnet,container-source':U).

  if ADM-NEW-RECORD = yes then

    run new-state ('Satz-neu,group-assign-target':U).

  run new-state ('Satz-geoeffnet,group-assign-target':U).
  run set-attribute-list ('Zahlungsziel=no':U).

  run set-attribute-list ('Invoice=no':U).
  run new-state ('Belegkopf-geoeffnet,record-target':U).

  if not can-find(V_BelegKopfAdr
                    where V_BelegKopfAdr.Firma      = V_BelegKopf.Firma
                      and V_BelegKopfAdr.Belegart   = V_BelegKopf.Belegart
                      and V_BelegKopfAdr.ReferenzNr = V_BelegKopf.ReferenzNr
                      and V_BelegKopfAdr.Typ        = 'K':U) then

    glUpdate = no.

  else

    glUpdate = yes.                  

  &IF "{&pa_S_IncoTerm}":U = "1":U &THEN

    if can-do('A,VUA':U,V_BelegKopf.Belegart)
      and V_BelegKopf.Bestimmungsort >= 2 then

      run set-attribute-list ('Bestimmungsorte=yes':U).

  &ENDIF

  /* set menu item sensitive state to change the address of once-only customer */

  run set-attribute-list ('ChangeAddress=':U + string(S_Kunde.AdressNr = 0)).

  &IF lookup("VF_Intra","{&PA-OPTIONEN}") > 0 &THEN

    if stamm.base.cls.SBCBusinessCategorySvc:prpoInstance:lHasCompanyIntraStatSales(V_BelegKopf.BelegDatum) then

      case pACConnectionSvc:prpcLocalization:

        {&{&PA-XBasisName}_C_Intra_Check}
        {&{&PA-XBasisName}_U_Intra_Check}
        {&{&PA-XBasisName}_Q_Intra_Check}
        {&{&PA-XBasisName}_Intra_Check}
        {&{&PA-XBasisName}_Y_Intra_Check}

        otherwise
        do:

          if can-do('R,G,L,VFP':U,V_BelegKopf.Belegart)
            and can-find(first S_IntraHandel
            where S_IntraHandel.Firma           = V_BelegKopf.Firma
              and S_IntraHandel.Herk_BelegArt   = V_BelegKopf.BelegArt
              and S_IntraHandel.Herk_ReferenzNr = V_BelegKopf.ReferenzNr) then
          do:

            run set-attribute-list ('ChangeAddress=no':U).
            run set-attribute-list ('ChangeParameter=no':U).

          end.

        end.  /* otherwise */

      end case.  /* pACConnectionSvc:prpcLocalization */

  &ENDIF   /* &IF lookup("VF_Intra":U,"{&PA-OPTIONEN}":U) > 0 */

  /* Wenn der Beleg bereits richtung Atlas übertragen wurde, dann einen       */
  /* Hinweis bringen, das ein Wiederholübertragung nicht möglich ist.         */

  &IF lookup("M_ATLAS","{&PA-OPTIONEN}") > 0 &THEN

    glGedruckt = V_BelegKopf.gedruckt.

    if    can-do('VFP,R':U,V_BelegKopf.Belegart)
      and stamm.base.cls.SBCLocalApplicationSvc:prpoInstance:lCheckModulsAndOptionsAtlas(no)
      and pa_iCustDeclGetDeclState (V_BelegKopf.Firma,
                                    'V_BelegKopf':U,
                                    {vert/incl/v_belko.sl &Tabelle = "V_BelegKopf"}) > {&pa_M_AtlasRequired} then
    do:

      {adm/incl/d__msg00.if
        &Meldung = "'m_atl00010':U"
        &Liste   = "string(V_BelegKopf.Belegnummer)"
      }

    end.

  &ENDIF

  /* Exits */

  {&{&PA-XBASISNAME}_C_ENABLE-FIELDS}
  {&{&PA-XBASISNAME}_U_ENABLE-FIELDS}
  {&{&PA-XBASISNAME}_Q_ENABLE-FIELDS}
  {&{&PA-XBASISNAME}_ENABLE-FIELDS}
  {&{&PA-XBASISNAME}_Y_ENABLE-FIELDS}

end. /* if return-value <> 'adm-error':U then */

end procedure.

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

define variable lTempZZ         as logical init no no-undo.
define variable cStaat          as character       no-undo.
define variable lVorValutaDatum as logical         no-undo.

&IF   LOOKUP("VF_INTRA","{&PA-OPTIONEN}")  > 0
  AND LOOKUP("VS_REPAIR","{&PA-OPTIONEN}") > 0 &THEN
  define variable cRepairOrder_Obj like VS_AuftragPos.VS_AuftragPos_Obj no-undo.
&ENDIF

&IF LOOKUP("VF_INTRA","{&PA-OPTIONEN}")  > 0 &THEN
  define variable cPartTypesWithoutIntraStat as character no-undo. 
&ENDIF

/* Buffers -------------------------------------------------------------------*/

&IF lookup("VF_INTRA","{&pa-Optionen}") > 0 &THEN
  define buffer bV_BelegKopfAdr for V_BelegKopfAdr.
  define buffer bS_Kunde        for S_Kunde.
  define buffer bS_Adresse      for S_Adresse.
  define buffer bML_Ort         for ML_Ort.
&ENDIF
define buffer bV_BelegPos       for V_BelegPos.
&IF lookup("M_ATLAS","{&PA-OPTIONEN}") > 0 &THEN
  define buffer bV_BelegStueli  for V_BelegStueli.
  define buffer b1S_Artikel     for S_Artikel.
  define buffer b2S_Artikel     for S_Artikel.
&ENDIF

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Code placed here will execute PRIOR to standard behavior. */

/* Dispatch standard ADM method.                             */
run dispatch in this-procedure ('end-update':U).

/* Code placed here will execute AFTER standard behavior.    */

if return-value <> 'adm-error':U then
do:

  if lSpeichern = no then
  do:

    run dispatch in THIS-PROCEDURE ('delete-record':U).
    if return-value = 'adm-error':U then
      return 'adm-error':U.

  end.
  else
  do:

    &IF lookup("VF_INTRA","{&pa-Optionen}") > 0 &THEN
      assign
        cStaat                     = stamm.base.cls.SBCBusinessCategorySvc:prpoInstance:prpcStaat
        cPartTypesWithoutIntraStat = stamm.base.cls.SBCBusinessCategorySvc:prpoInstance:cPartTypeListWithoutIntrastat
                                       (stamm.base.cls.SBCTaxMasterFilesSvc:prpoInstance:cIsoAlphaCodeOfTaxTerritory(V_BelegKopf.Dept_SBM_TaxTerritory_Obj[{&pa_SB_TaxTerritoryExt_Country}])) 
        .
      &IF DEFINED({&PA-XBasisName}_CR_pruefe_Intra) = 1 &THEN
        {&{&PA-XBasisName}_CR_pruefe_Intra}
      &ELSE

        if    stamm.base.cls.SBCBusinessCategorySvc:prpoInstance:lHasCompanyIntraStatSales(V_BelegKopf.BelegDatum) = yes
          and V_BelegKopf.Versendung            = yes

          /* --> UMO#WH2015-07-011 LM2 Sammelstreckenfaktura*/
          &IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
          and can-find(first V_BelegPos of V_BelegKopf
                         where V_BelegPos.uCI_Vertriebsweg <> {&uCI_VertriebswegStrecke})
          &ELSE /* original */
          and V_BelegKopf.Strecke               = no          /*-->UMO#WH2015-07-010 cpl Strecke code checked <--*/
          &ENDIF
          /* <-- UMO#WH2015-07-011 LM2 Sammelstreckenfaktura */

          and can-do('A,U,L,R,VFP,G':U,V_BelegKopf.BelegArt)
          and not (    V_BelegKopf.BelegArt     = 'VFP':U
                   and V_BelegKopf.Meldepflicht = no) then
        do:

          find bV_BelegKopfAdr
            where bV_BelegKopfAdr.Firma      = V_BelegKopf.Firma
              and bV_BelegKopfAdr.Belegart   = V_BelegKopf.Belegart
              and bV_BelegKopfAdr.ReferenzNr = V_BelegKopf.ReferenzNr
              and bV_BelegKopfAdr.Typ        = 'L':U
              and bV_BelegKopfAdr.Staat      > '':U
            no-lock no-error.

          if not available bV_BelegKopfAdr then

            find bV_BelegKopfAdr
              where bV_BelegKopfAdr.Firma      = V_BelegKopf.Firma
                and bV_BelegKopfAdr.Belegart   = V_BelegKopf.Belegart
                and bV_BelegKopfAdr.ReferenzNr = V_BelegKopf.ReferenzNr
                and bV_BelegKopfAdr.Typ        = 'K':U
                and bV_BelegKopfAdr.Staat      > '':U
              no-lock no-error.

          if not available bV_BelegKopfAdr then
          do:

            find bS_Kunde
              where bS_Kunde.Firma = {firma/s_kunde.fir V_BelegKopf.Firma}
                and bS_Kunde.Kunde = V_BelegKopf.Kunde
              no-lock.

            find bS_Adresse
              where bS_Adresse.Firma    = {firma/s_adres.fir V_BelegKopf.Firma}
                and bS_Adresse.AdressNr = bS_Kunde.AdressNr
              no-lock.

          end.

          if stamm.base.cls.SBCBusinessCategorySvc:prpoInstance:lHasTradePartnerIntrastat
               (if available bV_BelegKopfAdr then
                  bV_BelegKopfAdr.Staat
                else
                  bS_Adresse.Staat,
                V_Belegkopf.Belegdatum) = yes then

            /* Prüfungen zur Pos. */
            /* bei lagergeführten Teilen kommt es auf den Staat des Lagerortes an */

            DocLine:
            for each bV_BelegPos
              where bV_BelegPos.Firma               = V_BelegKopf.Firma
                and bV_BelegPos.BelegArt            = V_BelegKopf.Belegart
                and bV_BelegPos.ReferenzNr          = V_BelegKopf.ReferenzNr
                and bV_BelegPos.Satzart             = 'A':U
                and bV_BelegPos.Statistikwert_offen = 0
                and bV_BelegPos.offen               = yes
                and can-find(S_Artikel
                               where S_Artikel.Firma   = {firma/sartikel.fir bV_BelegPos.Firma}
                                 and S_Artikel.Artikel = bV_BelegPos.Artikel
                                 and lookup(string(S_Artikel.ArtikelArt), cPartTypesWithoutIntraStat) = 0)
              no-lock
              on error undo, throw:

              &IF LOOKUP("VS_REPAIR","{&PA-OPTIONEN}") > 0 &THEN

                /* For repaired parts in invoices or credit memos, it isn't   */
                /* necessary to make a check for intrastat. This process can  */
                /* be indentified by the current document line if it has an   */
                /* repair order as origin document. This condition must also  */
                /* be checked if the lines of the current document belong to  */
                /* a document chain of invoices and credit memos.             */

                if V_BelegKopf.SFertigDatum <> ? then

                  cRepairOrder_Obj = vert.base.cls.VBCSalesDocSvc:prpoInstance:cGetSourceDocLineObj
                                       ('VSA':U,
                                        bV_BelegPos.V_BelegPos_Obj).

                /* If the origin document of this line is not a repair order  */
                /* (this can be identified by using field SFertigDatum) then  */
                /* it must be checked, if it is relevant for intrastat.       */

                if    cRepairOrder_Obj > '':U
                  and can-find(VS_AuftragPos
                                 where VS_AuftragPos.VS_AuftragPos_Obj = cRepairOrder_Obj
                                   and VS_AuftragPos.AuftragsTyp       = {&pa_VS_RepairOrder}) then

                  next DocLine.

              &ENDIF /* ("VS_REPAIR","{&PA-OPTIONEN}") */

              if bV_BelegPos.Wertposition = yes
                or bV_BelegPos.LagerOrt   = ? then
              do:

                if      bV_BelegPos.Belegart      = 'G':U
                  or    bV_BelegPos.Belegart      = 'R':U
                    and bV_BelegPos.Herk_Belegart = 'G':U then

                  next DocLine.

                else
                do:

                  adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
                    ('v_bel00010':U,
                     string(bV_BelegPos.PositionsNr),
                     bV_BelegPos.Artikel).

                  leave DocLine.

                end.

              end. /* if bV_BelegPos.Wertposition = yes */
              else
              do:

                find bML_Ort
                  where bML_Ort.Firma    = {firma/mlort.fir bV_BelegPos.Firma}
                    and bML_Ort.Lagerort = bV_BelegPos.LagerOrt
                  no-lock.

                if can-find(S_Adresse
                              where S_Adresse.Firma    = {firma/s_adres.fir bV_BelegPos.Firma}
                                and S_Adresse.AdressNr = bML_Ort.AdressNr
                                and S_Adresse.Staat    = cStaat) then
                do:

                  /* hier angekommen besteht Intrastat-Pflicht */

                  adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
                    ('v_bel00010':U,
                     string(bV_BelegPos.PositionsNr),
                     bV_BelegPos.Artikel).

                  leave DocLine.

                end.

              end. /* if not bV_BelegPos.LagerOrt = ? */

            end. /* DocLine: for each bV_BelegPos */

        end. /* if V_BelegKopf.Versendung = yes and V_BelegKopf.Strecke = no and ... */

      &ENDIF

    &ENDIF

    if    glBelegsumme = yes
      and available V_BelegKopf
      and not can-do('VUD,VUA,VUR':U,V_BelegKopf.Belegart) then
    Belegsumme:
    do:

      /* Belesummen zum Belegkopf neue rechnen und speichern */

      if V_BelegKopf.Belegart = 'R':U then
      do:

        /* prüfe das ggf. manuelle Zahlungsziel */

        find S_ZahlZiel
          where S_ZahlZiel.Firma        = {firma/szahlzie.fir pa-Firma}
            and S_ZahlZiel.Archived     = no
            and S_ZahlZiel.Zahlungsziel = V_BelegKopf.Zahlungsziel
          no-lock no-error.

        if not available S_ZahlZiel then
          leave Belegsumme.

        if S_ZahlZiel.manuell = yes then
        do:

          run PruefeZahlungsziel(       pa-Firma,
                                        rowid(V_BelegKopf),
                                 output lTempZZ,
                                 output lVorValutaDatum).

          if lTempZZ = yes then
            leave Belegsumme.

        end.

      end. /* Rechnungen */

      run vert/proc/v_vbel21.p (pa-Firma,
                                V_BelegKopf.Belegart,
                                V_BelegKopf.ReferenzNr,
                                V_BelegKopf.offen,
                                no).

    end. /* if glBelegsumme = yes */

    /* Ereignis 16 (Ausfuhranmeldung erforderlich) auslösen. */

    {adm/template/incl/dt_dbg00.if
      &DebugLabel = "M_Atlas"
      &DebugLevel = "1"
      &Out        = "'v_wbel00.w 0':U"
    }

    &IF lookup("M_ATLAS","{&PA-OPTIONEN}") > 0 &THEN

      {adm/template/incl/dt_dbg00.if
        &DebugLabel = "M_Atlas"
        &DebugLevel = "1"
        &Out        = "'v_wbel00.w 1 ':U + V_BelegKopf.Belegart + ' ':U + V_BelegKopf.Herk_Belegart"
      }

      if    available V_BelegKopf
        and V_BelegKopf.Herk_Belegart        <> 'MLE':U
        and stamm.base.cls.SBCLocalApplicationSvc:prpoInstance:lCheckModulsAndOptionsAtlas(no)
        and (   can-do('U,VUD,L,VFP':U,V_BelegKopf.Belegart)
             or (    V_BelegKopf.Belegart       = 'R':U
                 and V_BelegKopf.Herk_Belegart <> 'VSA':U
                 and V_BelegKopf.Herk_Belegart <> 'VSW':U)) then
      do:

        {adm/template/incl/dt_dbg00.if
          &DebugLabel = "M_Atlas"
          &DebugLevel = "1"
          &Out        = "'v_wbel00.w 2':U"
        }

        /* Wenn eine Ausfuhranmeldung erforderlich ist, dann weiter. Ansonsten */
        /* ggf. das Ereignis 16 und den Zollstatus wieder löschen (der Beleg)  */
        /* konnte zuvor zollpflichtig gewesen sein).                           */

        if    V_BelegKopf.gedruckt = no
          and not can-do('2,4':U,string(giCustDeclState))
          and pa_iCustDeclIsDeclRequired (V_BelegKopf.Firma,
                                          V_BelegKopf.Belegart,
                                          vert.base.cls.VBCSalesDocSvc:prpoInstance:tGetReferenceDate(buffer V_BelegKopf),
                                          {vert/incl/v_belko.sl &Tabelle = "V_BelegKopf"}) > 0 then
        do:

          {adm/template/incl/dt_dbg00.if
            &DebugLabel = "M_Atlas"
            &DebugLevel = "1"
            &Out        = "'v_wbel00.w 3':U"
          }

          if    can-do('U,L,VUD,VFP,R':U,V_BelegKopf.Belegart)
            and pa_lCustDeclWriteDeclaration (pa-Firma,
                                              'V_BelegKopf':U,
                                              {vert/incl/v_belko.sl &Tabelle = "V_BelegKopf"},
                                              {&pa_M_AtlasRequired}) = no then
          do:

            {adm/template/incl/dt_dbg00.if
              &DebugLabel = "M_Atlas"
              &DebugLevel = "1"
              &Out        = "'v_wbel00.w 4':U"
            }

            return 'adm-error':U.

          end.

        end.
        else
        do:

          {adm/template/incl/dt_dbg00.if
            &DebugLabel = "M_Atlas"
            &DebugLevel = "1"
            &Out        = "'v_wbel00.w 5':U"
          }

          if    can-do('U,L,VUD,VFP,R':U,V_BelegKopf.Belegart)
            and glGedruckt           = yes
            and V_BelegKopf.gedruckt = no
            and pa_lCustDeclWriteDeclaration (V_BelegKopf.Firma,
                                              'V_BelegKopf':U,
                                              {vert/incl/v_belko.sl &Tabelle = "V_BelegKopf"},
                                              {&pa_M_AtlasCanceled}) = no then
          do:

            {adm/template/incl/dt_dbg00.if
              &DebugLabel = "M_Atlas"
              &DebugLevel = "1"
              &Out        = "'v_wbel00.w 6':U"
            }

            return 'adm-error':U.

          end.

        end.

        giCustDeclState = pa_iCustDeclGetDeclState (V_BelegKopf.Firma,
                                                    'V_BelegKopf':U,
                                                    {vert/incl/v_belko.sl &Tabelle = "V_BelegKopf"}).

        if pa_iCustDeclIsDeclRequired (V_BelegKopf.Firma,
                                       V_BelegKopf.Belegart,
                                       vert.base.cls.VBCSalesDocSvc:prpoInstance:tGetReferenceDate(buffer V_BelegKopf),
                                       {vert/incl/v_belko.sl &Tabelle = "V_BelegKopf"}) = 0 then
        do:

          {adm/template/incl/dt_dbg00.if
            &DebugLabel = "M_Atlas"
            &DebugLevel = "1"
            &Out        = "'v_wbel00.w 3':U"
          }

          if    can-do('U,L,VUD,VFP,R':U,V_BelegKopf.Belegart)
            and pa_lCustDeclWriteDeclaration (pa-Firma,
                                              'V_BelegKopf':U,
                                              {vert/incl/v_belko.sl &Tabelle = "V_BelegKopf"},
                                              {&pa_M_AtlasNeedless}) = no then
          do:

            {adm/template/incl/dt_dbg00.if
              &DebugLabel = "M_Atlas"
              &DebugLevel = "1"
              &Out        = "'v_wbel00.w 4':U"
            }

            return 'adm-error':U.

          end. /* if can-do('U,L,VUD,VFP,R':U,V_BelegKopf.Belegart) */

        end. /* if pa_iCustDeclIsDeclRequired (V_BelegKopf.Firma, */

        if    giCustDeclState   = 1
          and V_BelegKopf.offen = yes
          and can-do('U,L,VUD,VFP,R':U,V_BelegKopf.Belegart) then

          for each bV_BelegPos
            fields (Wertposition Gewicht PositionsNr LfdNr_SR Artikel Lagerort)
            where bV_BelegPos.Firma      = V_BelegKopf.Firma
              and bV_BelegPos.Belegart   = V_BelegKopf.Belegart
              and bV_BelegPos.ReferenzNr = V_BelegKopf.ReferenzNr
              and bV_BelegPos.Satzart    = 'A':U
            no-lock,
            first b1S_Artikel
            fields (ArtikelArt SBM_CustomsTariffNo_Obj)
            where b1S_Artikel.Firma   = {firma/sartikel.fir pa-Firma}
              and b1S_Artikel.Artikel = bV_BelegPos.Artikel
            no-lock
            on error undo, return 'adm-error':U:

            if not can-do({&pa_S_PTList_Set},string(b1S_Artikel.ArtikelArt)) then
            do:

              if bV_BelegPos.Lagerort <> ? then
              do:

                if b1S_Artikel.SBM_CustomsTariffNo_Obj = '':U then
                do:

                  {adm/incl/d__msg00.if
                    &Meldung = "'v_atl00001':U"
                    &Liste   = "bV_BelegPos.Artikel"
                  }

                end.

                if    bV_BelegPos.Wertposition = no
                  and bV_BelegPos.Gewicht      = 0 then
                do:

                  {adm/incl/d__msg00.if
                    &Meldung = "'v_atl00003':U"
                    &Liste   = "string(bV_BelegPos.PositionsNr)"
                  }

                end.

              end. /* if bV_BelegPos.Lagerort <> ? then */

            end.

            else

              for each bV_BelegStueli
                fields (Artikel)
                where bV_BelegStueli.Firma       = V_BelegKopf.Firma
                  and bV_BelegStueli.Belegart    = V_BelegKopf.Belegart
                  and bV_BelegStueli.ReferenzNr  = V_BelegKopf.ReferenzNr
                  and bV_BelegStueli.LfdNr_SR    = bV_BelegPos.lfdNr_SR
                  and bV_BelegStueli.PositionsNr = bV_BelegPos.PositionsNr
                  and bV_BelegStueli.Lagerort   <> ?
                no-lock,
                first b2S_Artikel
                fields (LagerGewicht SBM_CustomsTariffNo_Obj)
                where b2S_Artikel.Firma   = {firma/sartikel.fir pa-Firma}
                  and b2S_Artikel.Artikel = bV_BelegStueli.Artikel
                no-lock
                on error undo, return 'adm-error':U:

                if b2S_Artikel.SBM_CustomsTariffNo_Obj = '':U then
                do:

                  {adm/incl/d__msg00.if
                    &Meldung = "'v_atl00001':U"
                    &Liste   = "bV_BelegStueli.Artikel"
                  }

                end.

                if b2S_Artikel.LagerGewicht = 0 then
                do:

                  {adm/incl/d__msg00.if
                    &Meldung = "'v_atl00002':U"
                    &Liste   = "bV_BelegStueli.Artikel"
                  }

                end.

              end.

          end. /* for each bV_BelegPos */


        {adm/template/incl/dt_dbg00.if
          &DebugLabel = "M_Atlas"
          &DebugLevel = "1"
          &Out        = "'v_wbel00.w 7 Status: ':U + string(giCustDeclState)"
        }

        if V_BelegKopf.Verteilergruppe > '':U
          and cBereich <> 'VFSR':U then

          if giCustDeclState <> {&pa_M_AtlasRequired} then

            basis.buro.cls.BBCWorkflowSvc:prpoInstance:cancelWorkflow
              (V_BelegKopf.V_BelegKopf_Obj,
               V_BelegKopf.Firma,
               cBereich,
               16).

          else

            basis.buro.cls.BBCWorkflowSvc:prpoInstance:createWorkflow
              (V_BelegKopf.V_BelegKopf_Obj,
               V_BelegKopf.Firma,
               cBereich,
               16,
               V_BelegKopf.VerteilerGruppe,
               V_BelegKopf.AuftragsArt).

      end.

    &ENDIF

    run notify ('row-available':U).

    &IF  (    LOOKUP("VS","{&PA-MODULE}")        > 0
          AND LOOKUP("VS_CALL","{&PA-OPTIONEN}") > 0)
      or (    LOOKUP("MS","{&PA-MODULE}")        > 0
          AND LOOKUP("MS_PROD","{&PA-OPTIONEN}") > 0) &THEN

      if can-do('A,U':U,V_BelegKopf.Belegart) then

        adm.method.cls.DMCUISvc:addWindowTitleExtension
          ({fnarg
             pa_hADMGetFirstLinkHandle
             "target-procedure,
             'Container-Source':U"},
           (if vert.base.cls.VBCSalesDocSvc:prpoInstance:lIsDocumentForSpareParts
              (V_BelegKopf.Belegart,
               V_BelegKopf.Origin_Obj) = yes then
              'Ersatzteile':T20
            else
              '':U)).

    &ENDIF

  end. /* LSpeichern = yes */

end.  /* if return-value <> 'adm-error':U */

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
/* Examples ------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/*----------------------------------------------------------------------------*/

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

 define buffer VC_Interessent for VC_Interessent.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Code placed here will execute PRIOR to standard behavior. */

if lSchlussrechnung = yes then

  pa-hlp-string = adm.method.cls.DMCParameterStringSvc:cWriteValue(pa-hlp-string, 'Schlussrechnung':U, 'true':U).

else

  pa-hlp-string = adm.method.cls.DMCParameterStringSvc:cWriteValue(pa-hlp-string, 'Schlussrechnung':U, 'false':U).

pa-hlp-string = adm.method.cls.DMCParameterStringSvc:cWriteValue(pa-hlp-string, 'Kunde':U, input frame {&frame-name} V_BelegKopf.Kunde).

/* wird der Kunde firmenübergreifend geführt, so muß crtl+y auf Kunde         */
/* und crtl+a auf Empfaenger das entsprechende Firmeninclude verwenden        */

if   (    entry(4,pa-hlp-function) = 'Kunde':U
      and entry(1,pa-hlp-function) = 'E':U)
  or (    entry(4,pa-hlp-function) = 'Empfaenger':U
      and entry(1,pa-hlp-function) = 'A':U) then

  pa-hlp-string = adm.method.cls.DMCParameterStringSvc:cWriteValue(pa-hlp-string, 'Firma':U, {firma/s_kunde.fir pa-firma}).

else

  pa-hlp-string = adm.method.cls.DMCParameterStringSvc:cWriteValue(pa-hlp-string, 'Firma':U, pa-Firma).

/* Ggf. Kunde auf Interessent "mappen" */

&IF lookup ("VC","{&PA-MODULE}") > 0 &THEN

  if    available V_BelegKopf
    and not V_BelegKopf.Interessent > 0 then

    find first VC_Interessent
      where VC_Interessent.Firma = {firma/s_kunde.fir pa-Firma}
        and VC_Interessent.Kunde = input frame {&frame-name} V_BelegKopf.Kunde
      no-lock no-error.

  assign
    pa-hlp-string = adm.method.cls.DMCParameterStringSvc:cWriteValue
                      (pa-hlp-string,
                       'Kontenbereich':U,
                       if available V_BelegKopf
                          and V_BelegKopf.Interessent > 0
                          or available VC_Interessent then
                          1
                        else
                          0)
    pa-hlp-string = adm.method.cls.DMCParameterStringSvc:cWriteValue
                      (pa-hlp-string,
                       'Konto':U,
                       if available V_BelegKopf
                          and V_BelegKopf.Interessent > 0 then
                          V_BelegKopf.Interessent
                        else
                          (if available VC_Interessent then
                             VC_Interessent.Interessent
                           else
                             input frame {&frame-name} V_BelegKopf.Kunde))

    .
&ELSE

  assign
    pa-hlp-string = adm.method.cls.DMCParameterStringSvc:cWriteValue
                      (pa-hlp-string,
                       'Kontenbereich':U,
                         0)
    pa-hlp-string = adm.method.cls.DMCParameterStringSvc:cWriteValue
                      (pa-hlp-string,
                       'Konto':U,
                       input frame {&frame-name} V_BelegKopf.Kunde)
    .


&ENDIF

/* Die SML Suche mittels CRTL-F soll je nach Belegart einen eigenen           */
/* Eintrag aus dem Repository Hilfe verwenden. Dazu wird der Spaltenname      */
/* in pa-hlp-function manipuliert, damit je Belegart die passende             */
/* Definition im Repository gefunden wird.                                    */

/* Wurde CRTL-F für die BelegNummer gedrückt ? */

if    entry(1,pa-hlp-function)  = 'F':U
  and entry(4, pa-hlp-function) = 'BelegNummer':U then
do:

  case V_BelegKopf.Belegart :

    /* Angebote  */

    when 'A':U then

      assign
        entry(4,pa-hlp-function) = 'BelegNr-A':U
        entry(3,pa-hlp-function) = '':U
        .

    /* Aufträge  */

    when 'U':U then

      assign
        entry(4,pa-hlp-function) = 'BelegNr-U':U
        entry(3,pa-hlp-function) = '':U
        .

  end case.

end.

&IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
if    available V_BelegKopf
  and entry(4, pa-hlp-function) = 'uAngebot':U then
  pa-hlp-string = adm.method.cls.DMCParameterStringSvc:cWriteValue(pa-hlp-string, 'V_BelegKopf:ROWID':U, string(rowid(V_BelegKopf))).
&ENDIF

/* Dispatch standard ADM method.                             */
run dispatch in this-procedure ('help-begin':U).

/* Code placed here will execute AFTER standard behavior.    */

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-help-complete V-table-Win 
PROCEDURE local-help-complete :
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

define variable cTemp1 as character no-undo.

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Code placed here will execute PRIOR to standard behavior ------------------*/

/* Execute standard behavior -------------------------------------------------*/

run dispatch('help-complete':U).

/* Code placed here will execute AFTER standard behavior ---------------------*/

if return-value <> 'adm-error':U then
do:

  if can-do (pa-hlp-string,'key-name=Name':U) then
  do:

    cTemp1 = adm.method.cls.DMCParameterStringSvc:cReadValue(pa-hlp-string, 'S_Ansprech:ROWID':U, 1).

    if cTemp1 <> ? then
    do:

      find S_Ansprech
        where rowid(S_Ansprech) = to-rowid(cTemp1)
        no-lock no-error.

      if available S_Ansprech then

        V_Belegkopf.AnsprechNr = S_Ansprech.AnsprechNr.

    end.

  end.  /* if can-do (pa-hlp-string,'key-name=Name':U) */

end.  /* if return-value <> 'adm-error':U */

end procedure. /* local-help-complete */

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

&IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
DEFINE VARIABLE lbl-hndl AS WIDGET-HANDLE                      NO-UNDO.
DEFINE VARIABLE widg-pos AS DECIMAL                            NO-UNDO.
&ENDIF

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Code placed here will execute PRIOR to standard behavior. */

gcAddressInfoWinTitle = adm.method.cls.DMCParameterStringSvc:cWriteValue
                          ('':U,
                           'pa-AddressInfoFixTitle':U,
                           'Kundenadresse':T60).

&IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
run get-attribute ('belegart':U).
cBelegart = return-value.

if    cBelegart = 'A':U
  and adm.config.cls.DCCAppConfigSvc:prpoInstance:lParameterValue('UCI_QuoteVersioning':U) then
do:

  ASSIGN
    {setwidgetattr
       "V_BelegKopf.BelegDatum"
       "hidden"
       "yes"
       "in frame F-Main"}
    widg-pos = V_BelegKopf.BelegDatum:ROW IN FRAME F-Main
    {setwidgetattr
       "V_BelegKopf.BelegDatum"
       "row"
       "3"
       "in frame F-Main"}
    lbl-hndl = V_BelegKopf.BelegDatum:SIDE-LABEL-HANDLE IN FRAME F-Main
    {setwidgetattr
       "lbl-hndl"
       "row"
       "decimal(lbl-hndl:ROW + V_BelegKopf.BelegDatum:ROW IN FRAME F-Main - widg-pos)"}
    {setwidgetattr
       "V_BelegKopf.BelegDatum"
       "hidden"
       "no"
       "in frame F-Main"}
    .

  ASSIGN
    {setwidgetattr
       "V_BelegKopf_BelegDatum_Info"
       "hidden"
       "yes"
       "in frame F-Main"}
    {setwidgetattr
       "V_BelegKopf_BelegDatum_Info"
       "row"
       "3"
       "in frame F-Main"}
    {setwidgetattr
       "V_BelegKopf_BelegDatum_Info"
       "hidden"
       "no"
       "in frame F-Main"}
    .

  ASSIGN
    {setwidgetattr
       "gcuCIBelegStatus"
       "hidden"
       "yes"
       "in frame F-Main"}
    {setwidgetattr
       "gcuCIBelegStatus"
       "row"
       "4"
       "in frame F-Main"}
    {setwidgetattr
       "gcuCIBelegStatus"
       "hidden"
       "no"
       "in frame F-Main"}
    .

  ASSIGN
    {setwidgetattr
       "V_BelegKopf.offen"
       "hidden"
       "yes"
       "in frame F-Main"}
    {setwidgetattr
       "V_BelegKopf.offen"
       "row"
       "4"
       "in frame F-Main"}
    {setwidgetattr
       "V_BelegKopf.offen"
       "hidden"
       "no"
       "in frame F-Main"}
    .

  ASSIGN
    {setwidgetattr
       "V_BelegKopf.SBM_ProfitCenter_Obj"
       "hidden"
       "yes"
       "in frame F-Main"}
    widg-pos = V_BelegKopf.SBM_ProfitCenter_Obj:ROW IN FRAME F-Main
    {setwidgetattr
       "V_BelegKopf.SBM_ProfitCenter_Obj"
       "row"
       "5"
       "in frame F-Main"}
    lbl-hndl = V_BelegKopf.SBM_ProfitCenter_Obj:SIDE-LABEL-HANDLE IN FRAME F-Main
    {setwidgetattr
       "lbl-hndl"
       "row"
       "decimal(lbl-hndl:ROW + V_BelegKopf.SBM_ProfitCenter_Obj:ROW IN FRAME F-Main - widg-pos)"}
    {setwidgetattr
       "V_BelegKopf.SBM_ProfitCenter_Obj"
       "hidden"
       "no"
       "in frame F-Main"}
    .

  ASSIGN
    {setwidgetattr
       "V_Bele_SBM_ProfitCenter_Obj_Info"
       "hidden"
       "yes"
       "in frame F-Main"}
    {setwidgetattr
       "V_Bele_SBM_ProfitCenter_Obj_Info"
       "row"
       "5"
       "in frame F-Main"}
    {setwidgetattr
       "V_Bele_SBM_ProfitCenter_Obj_Info"
       "hidden"
       "no"
       "in frame F-Main"}
    .

  ASSIGN
    {setwidgetattr
       "V_BelegKopf.Sachbearbeiter"
       "hidden"
       "yes"
       "in frame F-Main"}
    widg-pos = V_BelegKopf.Sachbearbeiter:ROW IN FRAME F-Main
    {setwidgetattr
       "V_BelegKopf.Sachbearbeiter"
       "row"
       "6"
       "in frame F-Main"}
    lbl-hndl = V_BelegKopf.Sachbearbeiter:SIDE-LABEL-HANDLE IN FRAME F-Main
    {setwidgetattr
       "lbl-hndl"
       "row"
       "decimal(lbl-hndl:ROW + V_BelegKopf.Sachbearbeiter:ROW IN FRAME F-Main - widg-pos)"}
    {setwidgetattr
       "V_BelegKopf.Sachbearbeiter"
       "hidden"
       "no"
       "in frame F-Main"}
    .

  ASSIGN
    {setwidgetattr
       "V_BelegKopf_Sachbearbeiter_Info"
       "hidden"
       "yes"
       "in frame F-Main"}
    {setwidgetattr
       "V_BelegKopf_Sachbearbeiter_Info"
       "row"
       "6"
       "in frame F-Main"}
    {setwidgetattr
       "V_BelegKopf_Sachbearbeiter_Info"
       "hidden"
       "no"
       "in frame F-Main"}
    .

  ASSIGN
    {setwidgetattr
       "V_BelegKopf.Wiedervorlage"
       "hidden"
       "yes"
       "in frame F-Main"}
    widg-pos = V_BelegKopf.Wiedervorlage:ROW IN FRAME F-Main
    {setwidgetattr
       "V_BelegKopf.Wiedervorlage"
       "row"
       "7"
       "in frame F-Main"}
    lbl-hndl = V_BelegKopf.Wiedervorlage:SIDE-LABEL-HANDLE IN FRAME F-Main
    {setwidgetattr
       "lbl-hndl"
       "row"
       "decimal(lbl-hndl:ROW + V_BelegKopf.Wiedervorlage:ROW IN FRAME F-Main - widg-pos)"}
    {setwidgetattr
       "V_BelegKopf.Wiedervorlage"
       "hidden"
       "no"
       "in frame F-Main"}
    .

  ASSIGN
    {setwidgetattr
       "V_BelegKopf_Wiedervorlage_Info"
       "hidden"
       "yes"
       "in frame F-Main"}
    {setwidgetattr
       "V_BelegKopf_Wiedervorlage_Info"
       "row"
       "7"
       "in frame F-Main"}
    {setwidgetattr
       "V_BelegKopf_Wiedervorlage_Info"
       "hidden"
       "no"
       "in frame F-Main"}
    .

end. /* if cBelegart = 'A':U */
&ENDIF

/* Dispatch standard ADM method.                             */
run dispatch in this-procedure ('initialize':U).

/* Code placed here will execute AFTER standard behavior.    */

if return-value <> 'adm-error':U then
do:

  /* Option VU_BLDRU abfragen */

  assign

    lBelegdrucken = adm.config.cls.DCCAppConfigSvc:prpoInstance:lParameterValue
                      ('VU_OverridePrtMarkersInShipDoc':U)
    glBelegsumme  = adm.config.cls.DCCAppConfigSvc:prpoInstance:lParameterValue
                      ('VB_AutoSaveOfDocTotals':U)
    .

  run get-attribute ('belegart':U).
  cBelegart = return-value.

  run get-attribute ('Schlussrechnung':U).
  if return-value = 'true':U then
    lSchlussrechnung = yes.
  else
    lSchlussrechnung = no.

  case cBelegart:

    when 'A':U then
      assign
        cBereich       = 'VN':U
        cDruckprogramm = 'vert/ange/proc/vndang01.p':U
        cDruckvorlauf  = 'vert/ange/proc/vndang10.w':U
        .
    when 'U':U then
      assign
        cBereich       = 'VU':U
        cDruckprogramm = 'vert/auf/proc/vudauf01.p':U
        cDruckvorlauf  = 'vert/auf/proc/vudauf10.w':U
        .
    when 'VUA':U then
      assign
        cBereich       = 'VUA':U
        cDruckprogramm = 'vert/auf/proc/vudabr01.p':U
        cDruckvorlauf  = 'vert/auf/proc/vudabr10.w':U
        .
    when 'L':U then
      assign
        cBereich       = 'VUL':U
        cDruckprogramm = 'vert/auf/proc/vudlis01.p':U
        cDruckvorlauf  = 'vert/auf/proc/vudlis10.w':U
        .
    when 'VUD':U then
      assign
        cBereich       = 'VUD':U
        cDruckprogramm = 'vert/auf/proc/vuddls01.p':U
        cDruckvorlauf  = 'vert/auf/proc/vuddls10.w':U
        .
    when 'R':U then
      assign
        cBereich       = (if lSchlussrechnung = no then
                            'VFR':U
                          else
                            'VFSR':U)
        cDruckprogramm = 'vert/fakt/proc/vfdrec02.p':U
        cDruckvorlauf  = 'vert/fakt/proc/vfdrec10.w':U
        .
    when 'VFP':U then
      assign
        cBereich       = 'VFP':U
        cDruckprogramm = 'vert/fakt/proc/vfdpfr01.p':U
        cDruckvorlauf  = 'vert/fakt/proc/vfdpfr10.w':U
        .
    when 'G':U then
      assign
        cBereich       = 'VFG':U
        cDruckprogramm = 'vert/fakt/proc/vfdgut02.p':U
        cDruckvorlauf  = 'vert/fakt/proc/vfdgut10.w':U
        .
    when 'VUR':U then
      assign
        cBereich       = 'VUR':U
        cDruckprogramm = 'vert/auf/proc/vudrah01.p':U
        cDruckvorlauf  = 'vert/auf/proc/vudrah10.w':U
        .

  end case.

  /* RunMode abfragen */

  run request-attribute (this-procedure, 'container-source':U, 'pa-RunMode':U).

  cRunMode = return-value.

  if cRunMode matches '*Info':U then
  do:

    run set-attribute-list ('ChangeAddress=no':U).
    run set-attribute-list ('ChangeParameter=no':U).

  end.

  /* Interessent allenfalls bei Angeboten... */

  &IF lookup("VC":U,"{&PA-MODULE}":U) > 0 &THEN

    {fnarg
      pa_lUISvcSetWidgetHiddenState
        "V_BelegKopf.Interessent:handle in frame {&frame-name},
        (if cBelegart = 'A':U then
           no
         else
           yes)"}.

    {fnarg
      pa_lUISvcCreateLabel
      "V_BelegKopf.Kunde:handle in frame {&FRAME-NAME},
       (if cBelegart = 'A':U then
          'Kunde/Kontakt':R18
        else
          'Kunde':R18)"}.

  &ELSE

    {fnarg
      pa_lUISvcSetWidgetHiddenState
        "V_BelegKopf.Interessent:handle in frame {&frame-name},
        yes"}.

    {fnarg
      pa_lUISvcCreateLabel
      "V_BelegKopf.Kunde:handle in frame {&FRAME-NAME},
       'Kunde':R18"}.

  &ENDIF

  if cBelegart <> 'R':U then

    {fnarg
      pa_lUISvcSetWidgetHiddenState
        "gcBelegInfoRA:handle in frame {&frame-name},
        yes"}.

  {fnarg
    pa_lUISvcSetWidgetHiddenState
    "V_BelegKopf.ReverseInvoice:handle in frame {&frame-name},
     not (    (   cBelegart = 'R':U
               or cBelegart = 'G':U)
          and lSchlussrechnung                   = no
          and pACConnectionSvc:prpcLocalization <> 'H':U)"}.

  gcInitialHelpString = adm.method.cls.DMCParameterStringSvc:cWriteValue('':U, 'Belegart':U, cBelegart).

  &IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  gcInitialHelpString = adm.method.cls.DMCParameterStringSvc:cWriteValue(gcInitialHelpString, 'uBelegart':U, cBelegart).
  &ENDIF /* U_CI */

  run set-attribute-list ('check-modified-all=yes':U).

  /* ProfitCenter fields must only be shown if it is licensed */

  &IF LOOKUP("S_ProfCenter","{&PA-OPTIONEN}") = 0 &THEN

    {fnarg
      pa_lUISvcSetWidgetHiddenState
        "V_BelegKopf.SBM_ProfitCenter_Obj:handle in frame {&frame-name},
        yes"}.

    {fnarg
      pa_lUISvcSetWidgetHiddenState
        "V_Bele_SBM_ProfitCenter_Obj_Info:handle in frame {&frame-name},
        yes"}.

  &ENDIF

  /* --> UMO#CA2016-06-010 Versand Sammellieferschein */
  &IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  {fnarg
    pa_lUISvcSetWidgetHiddenState
      "V_BelegKopf.uCI_Sammellieferschein:handle in frame {&frame-name},
      not (cBelegart = 'A':U or cBelegart = 'U':U or cBelegart = 'L':U)"}.

  {setwidgetattr
     "V_BelegKopf.offen"
     "width"
     "10"
     "in frame {&FRAME-NAME}"}.

  &ELSE
  {fnarg
    pa_lUISvcSetWidgetHiddenState
      "V_BelegKopf.uCI_Sammellieferschein:handle in frame {&frame-name},
      yes"}.

  {fnarg
    pa_lUISvcSetWidgetHiddenState
      "gcuCIBelegStatus:handle in frame {&frame-name},
      yes"}.
  &ENDIF /* U_CI */
  /* <-- UMO#CA2016-06-010 Versand Sammellieferschein */

  /* --> UMO#CM2017-05-001 tri Versandstückliste */
  &IF LOOKUP("U_CM":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  if cBelegart <> 'VUD':U then
    {fnarg
      pa_lUISvcSetWidgetHiddenState
        "gluCM_Versand:handle in frame {&frame-name},
         yes"}.
  &ELSE
    {fnarg
      pa_lUISvcSetWidgetHiddenState
        "gluCM_Versand:handle in frame {&frame-name},
         yes"}.
  &ENDIF
  /* <-- UMO#CM2017-05-001 tri Versandstückliste */

  &IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  if    cBelegart <> 'A':U
    or not adm.config.cls.DCCAppConfigSvc:prpoInstance:lParameterValue('UCI_QuoteVersioning':U) then
  do:
    {fnarg
      pa_lUISvcSetWidgetHiddenState
        "V_BelegKopf.uAngebot:handle in frame {&frame-name},
         yes"}.
    {fnarg
      pa_lUISvcSetWidgetHiddenState
        "V_BelegKopf.uAngebotsversion:handle in frame {&frame-name},
         yes"}.
  end.
  &ELSE
  {fnarg
    pa_lUISvcSetWidgetHiddenState
      "V_BelegKopf.uAngebot:handle in frame {&frame-name},
       yes"}.
  {fnarg
    pa_lUISvcSetWidgetHiddenState
      "V_BelegKopf.uAngebotsversion:handle in frame {&frame-name},
       yes"}.
  &ENDIF

  if pACConnectionSvc:prpcLocalization <> 'H':U then
  do:

    {fnarg
      pa_lUISvcSetWidgetHiddenState
      "V_BelegKopf.H_InvoiceType:handle in frame {&FRAME-NAME},
      yes"}.

    {fnarg
      pa_lUISvcSetWidgetHiddenState
      "V_BelegKopf.H_Cancelled:handle in frame {&FRAME-NAME},
      yes"}.

    {fnarg
      pa_lUISvcSetWidgetHiddenState
      "V_BelegKopf.H_Corrected:handle in frame {&FRAME-NAME},
      yes"}.

  end. /* if pACConnectionSvc:prpcLocalization <> 'H':U then */

  if pACConnectionSvc:prpcLocalization = 'I':U then
  do:

    {fnarg
      pa_lUISvcSetWidgetHiddenState
      "V_BelegKopf.SBM_ProfitCenter_Obj:handle in frame {&FRAME-NAME},
      yes"}.

    {fnarg
      pa_lUISvcSetWidgetHiddenState
      "V_Bele_SBM_ProfitCenter_Obj_Info:handle in frame {&FRAME-NAME},
      yes"}.

  end.

  else

    {fnarg
      pa_lUISvcSetWidgetHiddenState
      "cISdINo:handle in frame {&FRAME-NAME},
      yes"}.

  {&{&PA-XBasisName}_C_local-initialize}
  {&{&PA-XBasisName}_U_local-initialize}
  {&{&PA-XBasisName}_Q_local-initialize}
  {&{&PA-XBasisName}_local-initialize}
  {&{&PA-XBasisName}_Y_local-initialize}

end. /* if return-value <> 'adm-error':U then */

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

run value(cDruckvorlauf)('&Belegart=':U + cBelegart).

run notify in THIS-PROCEDURE ('row-available':U).

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
/* Examples ------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/*----------------------------------------------------------------------------*/

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

define variable cParameter        as character           no-undo.
define variable cTelefax          as character init '':U no-undo.
define variable cName1            as character init '':U no-undo.
define variable cInfo             as character init '':U no-undo.
define variable cSchnittstelle    as character           no-undo.
define variable cMaschine         as character           no-undo.
define variable lKopien           as logical init yes    no-undo.
define variable lPositionen       as logical init yes    no-undo.
define variable lTemp2            as logical init no     no-undo.
define variable lHasDeliveredLine as logical init no     no-undo.
define variable cHCheck           as char init '':U      no-undo.
define variable gtHRefDate        as date                no-undo.
define variable gcHTaxCodeOID     as character           no-undo.

&IF LOOKUP("Q_GELANG":U,"{&PA-OPTIONEN}":U) > 0 &THEN
define variable cExportfile      as character   init  'c:/temp/test.pdf':U no-undo.
define variable lExport          as logical     init no  no-undo.
define variable iDocumentNumber  as integer              no-undo.
&ENDIF

/* Buffers -------------------------------------------------------------------*/

define buffer Buf_V_BelegKopf_Druck for V_BelegKopf.
define buffer BufH_V_BelegPos       for V_BelegPos.
define buffer BufH_S_Steuer         for S_Steuer.

&IF lookup ("VC","{&PA-MODULE}") > 0 &THEN
  define buffer bVC_Interessent     for VC_Interessent.
&ENDIF

&IF LOOKUP("Q_GELANG":U,"{&PA-OPTIONEN}":U) > 0 &THEN
define buffer bS_Kunde              for S_Kunde.
define buffer bVUT_EntryCertificate for VUT_EntryCertificate.
&ENDIF

if    pACConnectionSvc:prpcLocalization = 'P':U
  and available V_Belegkopf
  and can-do('R,G':U, V_BelegKopf.BelegArt)
  and V_BelegKopf.gedruckt              = no
  and S_Kunde.AdressNr                  = 0
  and V_BelegKopf.P_DomesticTaxID       = '':U then
  if adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
    ('v_belp0020':U,
     string(V_BelegKopf.BelegNummer),
     string(S_Kunde.Kunde)) <> yes then
     return 'ADM-ERROR':U.

if    pACConnectionSvc:prpcLocalization = 'H':U
  and available V_Belegkopf
  and can-do('R,G':U, V_BelegKopf.BelegArt)
  and V_BelegKopf.gedruckt              = no
  and V_Belegkopf.ValutaDatum          <> today
  and adm.method.cls.DMCMessageSvc:prpoInstance:lshowMessage
        ('v_belh0012':U,
         string(V_BelegKopf.ValutaDatum, '{&PA_DATEFORMAT}':U),
         string(V_BelegKopf.BelegNummer),
         string(today, '{&PA_DATEFORMAT}':U)) <> yes then
  return 'ADM-ERROR':U.

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

  if not available V_BelegKopf then
  do:

    {adm/incl/d__msg00.if
      &MELDUNG = "'dtviw00002':U"
    }

    return 'ADM-ERROR':U.

  end.

  if    pACConnectionSvc:prpcLocalization = 'H':U
    and V_BelegKopf.BelegArt              = 'R':U then
  do:

    goAuthorityDataParameters = new stamm.base.cls.SBCAuthorityDataDio('HU':U).

    if   V_BelegKopf.Zuschlag[1]   <> 0
      or V_BelegKopf.Zuschlag[2]   <> 0
      or V_BelegKopf.Zuschlag[3]   <> 0
      or V_BelegKopf.Zuschlag[4]   <> 0
      or V_BelegKopf.proz_Zuschlag <> 0 then

      adm.method.cls.DMCMessageSvc:prpoInstance:showError
        ('v_belh1018':U,
          string(V_BelegKopf.Belegnummer)).

    if    S_Kunde.H_Kobak           = yes
      and V_BelegKopf.gedruckt      = no
      and V_BelegKopf.Belegfreigabe = no
      and stamm.base.cls.SBCTaxMasterFilesSvc:prpoInstance:cIsoAlphaCodeOfTaxTerritory
            (V_BelegKopf.Dept_SBM_TaxTerritory_Obj[{&pa_SB_TaxTerritoryExt_Country}]) = 'HU':U then
    do:

      if not can-find(S_Firma
                       where S_Firma.Firma                           = V_BelegKopf.Firma
                         and goAuthorityDataParameters:prpcTaxNumber > '':U) then
         cHCheck = '- Behördenkommunikation: Feld ~"Steuernummer~"':T45 + '~n':U.

       if not can-find(S_Firma
                       where S_Firma.Firma      = V_BelegKopf.Firma
                         and S_Firma.Strasse    > '':U) then
         cHCheck = cHCheck + '- Firmenstamm: Feld "Straße"':T35 + '~n':U.

       if not can-find(S_Adresse
                       where S_Adresse.Firma    = {firma/s_adres.fir V_BelegKopf.Firma}
                         and S_Adresse.AdressNr = S_Kunde.AdressNr
                         and S_Adresse.Strasse  > '':U) then
         cHCheck = cHCheck + '- Rechnungsstamm: Feld ~"Straße~"':T35 + '~n':U.

       if not can-find(S_Waehrung
                       where S_Waehrung.Firma       = {firma/swaehrun.fir V_BelegKopf.Firma}
                         and S_Waehrung.Waehrung    = V_BelegKopf.Waehrung
                         and S_Waehrung.ISO_KurzBez > '':U) then
         cHCheck = cHCheck + '- Währungsstamm: Feld "KurzBez Währung"':T40 + '~n':U.

       for each BufH_V_BelegPos
         where BufH_V_BelegPos.Firma      = V_BelegKopf.Firma
           and BufH_V_BelegPos.BelegArt   = V_BelegKopf.BelegArt
           and BufH_V_BelegPos.ReferenzNr = V_BelegKopf.ReferenzNr
           and BufH_V_BelegPos.SatzArt    = 'A':U
         no-lock
         on error undo, throw:

         if BufH_V_BelegPos.S_Steuer_Obj = '':U then
         do:

           assign
             gtHRefDate    = (if V_Belegkopf.Lieferscheindatum <> ? then
                                V_Belegkopf.Lieferscheindatum
                              else
                                (if V_Belegkopf.Rechnungsdatum    <> ?
                                   and V_Belegkopf.Rechnungsdatum <> V_Belegkopf.Belegdatum then
                                   V_Belegkopf.Rechnungsdatum
                                 else
                                   V_Belegkopf.Belegdatum))
             gcHTaxCodeOID = stamm.base.cls.SBCTaxMasterFilesSvc:prpoInstance:cTaxCodeObjOfAccount
                              (BufH_V_BelegPos.Konto,
                               gtHRefDate)
             .

           find BufH_S_Steuer
             where BufH_S_Steuer.S_Steuer_Obj = gcHTaxCodeOID
             no-lock no-error.

         end. /* if gbV_BelegPos.S_Steuer_Obj = '':U then */

         else

           find BufH_S_Steuer
             where BufH_S_Steuer.S_Steuer_Obj = BufH_V_BelegPos.S_Steuer_Obj
             no-lock no-error.

         if    available BufH_S_Steuer
           and BufH_S_Steuer.H_TaxType       > 2
           and BufH_S_Steuer.H_TaxFreeReason = '':U then
         do:

           cHCheck = cHCheck + '- Feld ~"Beschreibung~" zum Steuerschlüssel':T80 + '~n':U.

           leave.

         end. 

         if    available BufH_S_Steuer
           and BufH_S_Steuer.H_TaxType              = 2
           and length(V_BelegKopf.H_DomesticTaxID) <> 13 then
         do:

           cHCheck = cHCheck + '- Rechnung: Feld ~"inl SteuerNr Format 99999999-9-99~"':T60 + '~n':U.

           leave.

         end.

       end. /* for each BufH_V_BelegPos */

       for each V_BelegPos
         where V_BelegPos.Firma      = V_BelegKopf.Firma
           and V_BelegPos.BelegArt   = V_BelegKopf.BelegArt
           and V_BelegPos.ReferenzNr = V_BelegKopf.ReferenzNr
           and V_BelegPos.SatzArt    = 'A':U
         no-lock
         on error undo, throw:

         if not can-find(S_ArtikelSpr
                         where S_ArtikelSpr.Firma          = {firma/sartikel.fir V_BelegKopf.Firma}
                           and S_ArtikelSpr.Artikel        = V_BelegPos.Artikel
                           and S_ArtikelSpr.Sprache        = {&pa_DefaultSprache}
                           and S_ArtikelSpr.Bezeichnung[1] > '':U) then
         do:

           cHCheck = cHCheck + '- Feld ~"Bezeichnung"~ zu mindestens einem Teil':T65 + '~n':U.

           leave.

         end. /* if not can-find(S_ArtikelSpr */

       end. /* for each V_BelegPos */

       for each V_BelegPos
         where V_BelegPos.Firma      = V_BelegKopf.Firma
           and V_BelegPos.BelegArt   = V_BelegKopf.BelegArt
           and V_BelegPos.ReferenzNr = V_BelegKopf.ReferenzNr
           and V_BelegPos.SatzArt    = 'A':U
         no-lock
         on error undo, throw:

         if not can-find(S_MengenEinheitSpr
                         where S_MengenEinheitSpr.Firma         = {firma/smngeinh.fir V_BelegKopf.Firma}
                           and S_MengenEinheitSpr.MengenEinheit = V_BelegPos.Mengeneinheit
                           and S_MengenEinheitSpr.Sprache       = {&pa_DefaultSprache}
                           and S_MengenEinheitSpr.KurzBez       > '':U) then
         do:

           cHCheck = cHCheck + '- Feld ~"KBez Mengeneinheit"~ zu mindestens einer Mengeneinheit':T80 + '~n':U.

           leave.

         end. /* if not can-find(S_MengenEinheitSpr */

       end. /* for each V_BelegPos */

       if cHCheck <> '':U then
         adm.method.cls.DMCMessageSvc:prpoInstance:showError
           ('v_belh1019':U,
             string(V_BelegKopf.Belegnummer),
             cHCheck).

       if    V_BelegKopf.H_DomesticTaxID = '':U
         and S_Kunde.H_NaturalPerson     = no
         and stamm.base.cls.SBCTaxMasterFilesSvc:prpoInstance:cIsoAlphaCodeOfTaxTerritory
               (V_BelegKopf.Dept_SBM_TaxTerritory_Obj[{&pa_SB_TaxTerritoryExt_Country}]) = 'HU':U
         and stamm.base.cls.SBCTaxMasterFilesSvc:prpoInstance:cIsoAlphaCodeOfTaxTerritory
               (V_BelegKopf.Dest_SBM_TaxTerritory_Obj[{&pa_SB_TaxTerritoryExt_Country}]) = 'HU':U then
         adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage('s_trgh0008':U).

    end. /* if S_Kunde.H_Kobak then */

  end. /* if V_BelegKopf.BelegArt      = 'R':U then */

  /* Zustandsprüfung und Anzeige zum Beleg */

  basis.buro.cls.BBCWorkflowSvc:prpoInstance:showLockStatus
    (V_BelegKopf.V_BelegKopf_Obj,
     cBereich).

  /* Zustandsprüfung und Anzeige zum Kunden */

  basis.buro.cls.BBCWorkflowSvc:prpoInstance:showLockStatus
    (S_Kunde.S_Kunde_Obj,
     cBereich).

  &IF lookup ("VC","{&PA-MODULE}") > 0 &THEN

  /* Zustandsprüfung und Anzeige zum Interessenten */

  find bVC_Interessent
    where bVC_Interessent.Firma       = {firma/s_kunde.fir pa-Firma}
      and bVC_Interessent.Interessent = V_BelegKopf.Interessent
    no-lock no-error.

  if available bVC_Interessent then
    basis.buro.cls.BBCWorkflowSvc:prpoInstance:showLockStatus
      (bVC_Interessent.VC_Interessent_Obj,
       cBereich).

  &ENDIF /* VC */


  /* Exits */

  {&{&PA-XBasisName}_C_LocalPrintCurrent}
  {&{&PA-XBasisName}_U_LocalPrintCurrent}
  {&{&PA-XBasisName}_Q_LocalPrintCurrent}
  {&{&PA-XBasisName}_LocalPrintCurrent}
  {&{&PA-XBasisName}_Y_LocalPrintCurrent}


  /* Document specific checks that may prevent printing. Errors are cast and  */
  /* displayed in case of failed checks, the current procedure will be left.  */

  run PrePrintChecks.

  /* check if manual delivery actions are allowed by delivery process         */

  if not stamm.base.cls.SBCDeliveryConfigSvc:prpoInstance:lManualDeliveryActionAllowed(V_BelegKopf.Kunde,
                                                                                       V_BelegKopf.BelegArt,
                                                                                       V_BelegKopf.SBM_ProfitCenter_Obj) then
    return 'ADM-ERROR':U.

  if cBelegart > '':U then
  do:

    /* Telefax-Nr suchen */

    if can-do('L,VUD,R,G,VFP':U,cBelegart) then
    do:

      find V_BelegKopfAdr
        where V_BelegKopfAdr.Firma      = V_BelegKopf.Firma
          and V_BelegKopfAdr.Belegart   = V_BelegKopf.Belegart
          and V_BelegKopfAdr.ReferenzNr = V_BelegKopf.ReferenzNr
          and V_BelegKopfAdr.Typ        = (if can-do('L,VUD':U,cBelegart) then
                                             'L':U
                                           else
                                             'R':U)
        no-lock no-error.

      if available V_BelegKopfAdr then
        assign
          cTelefax = V_BelegKopfAdr.Telefax
          cName1   = V_BelegKopfAdr.Name1
          .

      else
      do:

        find V_BelegKopfAdr
          where V_BelegKopfAdr.Firma      = V_BelegKopf.Firma
            and V_BelegKopfAdr.Belegart   = V_BelegKopf.Belegart
            and V_BelegKopfAdr.ReferenzNr = V_BelegKopf.ReferenzNr
            and V_BelegKopfAdr.Typ        = 'K':U
          no-lock no-error.

        if available V_BelegKopfAdr then
          assign
            cTelefax = V_BelegKopfAdr.Telefax
            cName1   = V_BelegKopfAdr.Name1
            .

        else
        do:

          find S_Adresse
            where S_Adresse.Firma    = {firma/s_adres.fir pACConnectionSvc:prpcCompany}
              and S_Adresse.AdressNr = S_Kunde.AdressNr
            no-lock no-error.

          if available S_Adresse then

            assign
              cTelefax = S_Adresse.Telefax
              cName1   = S_Adresse.Name1
              .

        end. /* keine abweichende Kopfadresse */

      end. /* abweichende Liefer/Rechnungsadresse */

    end. /* if can-do('L,VUD,R,G,VFP':U,cBelegart) */

    else
    do:

      find V_BelegKopfAdr
        where V_BelegKopfAdr.Firma      = V_BelegKopf.Firma
          and V_BelegKopfAdr.Belegart   = V_BelegKopf.Belegart
          and V_BelegKopfAdr.ReferenzNr = V_BelegKopf.ReferenzNr
          and V_BelegKopfAdr.Typ        = 'K':U
        no-lock no-error.

      if available V_BelegKopfAdr then

        assign
          cTelefax = V_BelegKopfAdr.Telefax
          cName1   = V_BelegKopfAdr.Name1
          .

      else
      do:

        find S_Adresse
          where S_Adresse.Firma    = {firma/s_adres.fir pACConnectionSvc:prpcCompany}
            and S_Adresse.AdressNr = S_Kunde.AdressNr
          no-lock no-error.

        if available S_Adresse then
          assign
            cTelefax = S_Adresse.Telefax
            cName1   = S_Adresse.Name1
            .

      end. /* keine abweichende Kopfadresse */

    end. /* übrige Belegarten */

    {adm/incl/d__par00.if
      &ParameterListe = "cParameter"
      &Parameter      = "ReferenzNr"
      &Variable1      = "V_BelegKopf.ReferenzNr"
      &Variable2      = "V_BelegKopf.ReferenzNr"
    }

    {adm/incl/d__par00.if
      &ParameterListe = "cParameter"
      &Parameter      = "Belegart"
      &Variable1      = "V_BelegKopf.Belegart"
    }

    {adm/incl/d__par00.if
      &ParameterListe = "cParameter"
      &Parameter      = "offen"
      &Variable1      = "V_BelegKopf.offen"
    }

    {adm/incl/d__par00.if
      &ParameterListe = "cParameter"
      &Parameter      = "&Telefax"
      &Variable1      = "cTelefax"
    }

    {adm/incl/d__par00.if
      &ParameterListe = "cParameter"
      &Parameter      = "&Name"
      &Variable1      = "cName1"
    }

    if glAttach then  /* der Aufruf kommt aus der Mailfunktion */
    do:

      assign
        lKopien     = no           /* nur einfach ausgeben */
        lPositionen = glPositionen
        .

      /* Parameter für Attachment Generierung */

      if entry(num-entries(gcAttach, '.':U), gcAttach, '.':U) = 'pdf':U then

        assign

          cSchnittstelle =  '$PDF-MAIL':U

          /* pdf wird über Windowsdrucker generiert */

          cMaschine = '$WinClient':U
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
        &ParameterListe = "cParameter"
        &Parameter      = "Attachment"
        &Variable1      = "gcAttach"
      }

    end. /* if glAttach then */

    if    pACConnectionSvc:prpcLocalization  = 'P':U
      and gtPCopyDate                       <> ? then
    do:

      {adm/incl/d__par00.if
        &ParameterListe = "cParameter"
        &Parameter      = "P_CopyDate"
        &Variable1      = "gtPCopyDate"
      }

      gtPCopyDate = ?.

    end. /* if pACConnectionSvc:prpcLocalization  = 'P':U ... */

    /* User Exits */

    {&{&PA-XBASISNAME}_C_LocalPrintCurrent_Parameter}
    {&{&PA-XBASISNAME}_U_LocalPrintCurrent_Parameter}
    {&{&PA-XBASISNAME}_Q_LocalPrintCurrent_Parameter}
    {&{&PA-XBASISNAME}_LocalPrintCurrent_Parameter}
    {&{&PA-XBASISNAME}_Y_LocalPrintCurrent_Parameter}

    &IF LOOKUP("Q_GELANG":U,"{&PA-OPTIONEN}":U) > 0 &THEN
    if    V_BelegKopf.BelegArt = 'L':U
      and V_BelegKopf.steuerfrei
      and V_BelegKopf.BelegDatum >= {&PA_VUT_EntryCertificate_StartDate} then
    do:

      lExport = vert.auf.cls.VUCEntryCertificateSvc:prpoInstance:lIsEntryCertificateNecessary
                  (yes,no,buffer V_BelegKopf).

      if    lExport                                                                = yes
        and adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage('vugel00000':U) = no then

        lExport = not adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage('vugel00001':U).

    end. /* if    V_BelegKopf.BelegArt = 'L':U */
    &ENDIF

    if not glAttach then
    do:

      /* Damit, wie bisher auch, alle Positionen beim LS gedruckt werden.     */
      /* Printing archived documents is also always for all lines (not        */
      /* for open lines only)                                                 */

      if   V_BelegKopf.Belegart = 'L':U
        or V_BelegKopf.offen    = no then

        lPositionen = no.

      lHasDeliveredLine = can-find (first V_BelegPos
                                      where V_BelegPos.Firma                = V_BelegKopf.Firma
                                        and V_BelegPos.Belegart             = V_BelegKopf.Belegart
                                        and V_BelegPos.ReferenzNr           = V_BelegKopf.ReferenzNr
                                        and V_BelegPos.Satzart              = 'A':U
                                        and (   V_BelegPos.offen            = no
                                             or V_BelegPos.gelieferte_Menge > 0
                                             or V_BelegPos.stornierte_Menge > 0 )).

      /* Bei LS und U fragen, ob alle Positionen oder nur die offenen         */
      /* ausgegeben werden sollen.                                            */

      if     adm.config.cls.DCCAppConfigSvc:prpoInstance:lParameterValue
               ('SB_PrintOptForDocOutput':U)  = yes
         and (    V_BelegKopf.Formularanzahl <> 1
              and (if pACConnectionSvc:prpcLocalization = 'H':U then
                     not can-do ({&pa_V_H_NoUpdateAfterPrint}, V_BelegKopf.Belegart)
                   else
                     yes)
               or (    can-do('U,VUA,L':U,V_BelegKopf.Belegart)
                   and V_BelegKopf.offen
                   and lHasDeliveredLine )) then
      do:

        lKopien = (V_BelegKopf.Formularanzahl <> 1).

        /* Exception for USA: always print all positions */

        if   pACConnectionSvc:prpcLocalization <> 'USA':U
          or V_BelegKopf.BelegArt              <> 'U':U then
        do:

          run stamm/proc/s_pbel00.w (             V_BelegKopf.Belegart,
                                                  (    can-do('U,VUA,L':U,V_BelegKopf.Belegart)
                                                   and V_BelegKopf.offen
                                                   and lHasDeliveredLine),
                                     input-output lKopien,
                                     input-output lPositionen,
                                          output lTemp2) no-error.
  
          if   error-status:error
            or lTemp2 then
            return 'ADM-ERROR':U.

        end. /* if    pACConnectionSvc:prpcLocalization <> 'USA':U */
        else

          lPositionen = no.

      end. /* if     adm.config.cls.DCCAppConfigSvc:prpoInstance:lParameterValue */

    end. /* if not glAttach */

    run PruefeSetPositionen(V_BelegKopf.Firma,
                            V_BelegKopf.BelegArt,
                            V_BelegKopf.ReferenzNr) no-error.
    if error-status:error then
      return 'ADM-ERROR':U.

    {adm/incl/d__par00.if
      &ParameterListe = "cParameter"
      &Parameter      = "Positionen"
      &Variable1      = "lPositionen"
    }

    {adm/incl/d__par00.if
      &ParameterListe = "cParameter"
      &Parameter      = "Kopien"
      &Variable1      = "lKopien"
    }

    run basis/job/proc/bjvjob00.w (cInfo,
                                   cParameter,
                                   cDruckprogramm) no-error.

    if error-status:error then
      return 'ADM-ERROR':U.

    &IF LOOKUP("Q_GELANG":U,"{&PA-OPTIONEN}":U) > 0 &THEN
    if lExport then 
    do transaction
      on error undo, throw:

      {adm/incl/d__par00.if
        &ParameterListe = "cParameter"
        &Parameter      = "DocumentType"
        &Variable1      = "'VUC':U"
      }

      find last bVUT_EntryCertificate
        where bVUT_EntryCertificate.Company         = V_BelegKopf.Firma
          and bVUT_EntryCertificate.DocumentType    = V_BelegKopf.BelegArt
          and bVUT_EntryCertificate.ReferenceNumber = V_BelegKopf.ReferenzNr
        exclusive-lock no-error.

      if not available bVUT_EntryCertificate then 
      do:

        find bS_Kunde
          where bS_Kunde.Firma = {firma/s_kunde.fir pACConnectionSvc:prpcCompany}
            and bS_Kunde.Kunde = V_BelegKopf.Kunde
          no-lock.

        iDocumentNumber = {fnarg
                            pa_iNumRgGetNextNumber
                            "pACConnectionSvc:prpcCompany,
                             'VUC':U"
                          }.

        create bVUT_EntryCertificate.
        assign
          bVUT_EntryCertificate.Company         = V_BelegKopf.Firma
          bVUT_EntryCertificate.DocumentType    = V_BelegKopf.BelegArt
          bVUT_EntryCertificate.ReferenceNumber = V_BelegKopf.ReferenzNr
          bVUT_EntryCertificate.DocumentNumber  = iDocumentNumber
          bVUT_EntryCertificate.DocumentDate    = V_BelegKopf.BelegDatum
          bVUT_EntryCertificate.Customer        = V_BelegKopf.Kunde
          bVUT_EntryCertificate.ShippingDocNo   = V_BelegKopf.BelegNummer
          bVUT_EntryCertificate.Owning_Obj      = bS_Kunde.S_Kunde_Obj
          .

        validate bVUT_EntryCertificate.

      end.

      assign
        bVUT_EntryCertificate.OutputDate = today
        bVUT_EntryCertificate.OutputTime = string(time,'HH:MM:SS':U)
        .

      validate bVUT_EntryCertificate.

      if glAttach then
      do:

        {adm/incl/d__par01.if
          &ParameterListe = "cParameter"
          &Parameter      = "Attachment"
          &Variable1      = "cExportfile"
        }

        entry(1,cExportfile,'.':U) = entry(1,cExportfile,'.':U) + '_gelang':U.

        {adm/incl/d__par00.if
          &ParameterListe = "cParameter"
          &Parameter      = "Attachment"
          &Variable1      = "cExportfile"
        }

        gcAttach = trim (gcAttach + ';':U + cExportfile, ';':U).

      end.

      run basis/job/proc/bjvjob00.w (cInfo,
                                     cParameter,
                                     cDruckprogramm) no-error.

      if error-status:error then
        return 'ADM-ERROR':U.

    end.
    &ENDIF

  end. /* if cBelegart > '':U then */

  run notify in THIS-PROCEDURE ('row-available':U).

  /*--------------------------------------------------------------------------*/
  /* bei Lieferschein wenn OPTION VU_BLDRU = ja und Druckmerker = ja,         */
  /*                  dann Abfrage auf Druckmerker zurücksetzen               */
  /*--------------------------------------------------------------------------*/

  if    V_BelegKopf.Belegart = 'L':U
    and V_BelegKopf.gedruckt = yes
    and lBelegdrucken        = yes
    and V_BelegKopf.offen    = yes then
  do:

    {adm/incl/d__msg00.if
      &Meldung   = "'v_bel00018':U"
      &Rueckgabe = "lOK"
    }

    if lOK then
      do transaction on error undo, return 'adm-error':U:

      find Buf_V_BelegKopf_Druck
        where rowid(Buf_V_BelegKopf_Druck) = rowid(V_BelegKopf)
        exclusive-lock.

      assign
        Buf_V_BelegKopf_Druck.gedruckt      = no
        Buf_V_BelegKopf_Druck.Belegfreigabe = no
        .

      run dispatch in this-procedure ('row-available':U).

    end.

  end.  /* if V_BelegKopf.Belegart    = 'L':U */

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
/* Examples ------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/*----------------------------------------------------------------------------*/

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

define variable gcAdressNr       as character     no-undo.
define variable hContainerSource as handle        no-undo.
&IF LOOKUP("U_CW":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  /* --> UMO#WH2015-10-001 cpl Kundencenter */
  define variable cuTemp             as character        no-undo.
&ENDIF

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Code placed here will execute PRIOR to standard behavior. */

/* Dispatch standard ADM method.                             */
run dispatch in this-procedure ('row-available':U).

/* Code placed here will execute AFTER standard behavior.    */

if return-value <> 'adm-error':U then
do:

  if available V_BelegKopf then
  do:

    hContainerSource = {fnarg
                         pa_hADMGetFirstLinkHandle
                         "this-procedure,
                          'container-source':U"}.

    /* If the record changes, the state must be checked and displayed         */

    glZustandPruefen = yes.

    &IF LOOKUP("U_CW":U,"{&PA-OPTIONEN}":U) > 0 &THEN
    /* --> UMO#WH2015-10-001 cpl Kundencenter */
    /*--- Nur ein mal positionieren, deshalb merken ---*/

    if giuBelegPKS = 0 then do:
      run get-link-handle in adm-broker-hdl (this-procedure,
                                             'container-source':U,
                                             output cuTemp).

      if num-entries(cuTemp) = 1
        and valid-handle(widget-handle(cuTemp)) then
      do:
        run get-attribute in widget-handle(cuTemp) ('uBeleg':U).

        if return-value <> ? then
          giuBelegPKS = integer(return-value).

      end. /* if num-entries... */

      if giuBelegPKS <> ?
        and giuBelegPKS > 0 then do:
        {setwidgetattr
           "V_BelegKopf.Belegnummer"
           "screen-value"
           "string(giuBelegPKS,V_BelegKopf.Belegnummer:format in frame {&frame-name})"
           "in frame {&frame-name}"}.

        /* page-down nur wenn nicht bereits aktuell (z.B. nicht beim ersten Satz) */
        if V_BelegKopf.Belegnummer <> giuBelegPKS then
          apply 'page-down':U to V_BelegKopf.Belegnummer in frame {&frame-name}.
      end.
    end.
    /* <-- UMO#WH2015-10-001 cpl Kundencenter */
    &ENDIF

    /* --> UMO#CA2016-05-003 MOu Rahmenauftrag: Auftragsschnellerfassung */
    &IF LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN

    /* if the Window Order was called from uvuauf00.w (VUR) */
    /* then we have to display the Doc with uBelegkopf_Obj  */

    if luNewCreatedOrder() then
    do:

      run get-attribute ('uBelegkopf_Obj':U).
      gcuBelegkopf_Obj = return-value.

      run get-attribute ('uBelegkopf_Obj-VUR':U).
      gcuBelegkopf_Obj-VUR = return-value.

      if gcuBelegkopf_Obj <> '':U
        and gcuBelegkopf_Obj <> ?
        and available V_Belegkopf
        and V_BelegKopf.V_BelegKopf_Obj <> gcuBelegkopf_Obj then
      do:
        /* if Order was deleted from Blanket Order in this case V_BelegKopf */
        /* will be not available (gcuBelegkopf_Obj still have the old Obj)  */

        find V_BelegKopf
          where V_BelegKopf.V_BelegKopf_Obj = gcuBelegkopf_Obj
          no-lock no-error.

        if available V_BelegKopf then
        do:
          giuKunde = V_BelegKopf.Kunde.

          {adm/incl/d__duh00.if
             &Var1     = "V_BelegKopf.BelegNummer"
             &Var2     = "V_BelegKopf.Kunde"
             &WithFrame = "frame {&FRAME-NAME}"}

          run dispatch ('get-next':U).
          run notify ('row-available':U).

          apply 'page-down':U to V_BelegKopf.Kunde in frame {&frame-name}.

        end. /* avail V_BelegKopf */

      end. /* if gcuBelegkopf_Obj <> '':U*/
    end. /* if luNewCreatedOrder() */
    &ENDIF
    /* <-- UMO#CA2016-05-003 MOu */

    if    V_BelegKopf.MRPRelease = yes
      and V_BelegKopf.offen      = yes  then

      run set-attribute-list ('MRPRelease=yes':U).

    else

      run set-attribute-list ('MRPRelease=no':U).

    if    V_BelegKopf.offen = yes then

      run set-attribute-list ('OPKunde=no':U).

    else

      run set-attribute-list ('OPKunde=yes':U).

    run request-attribute (this-procedure, 'container-source':U, 'PKS':U).

    gcAdressNr = adm.method.cls.DMCParameterStringSvc:cReadValue(return-value, 'AdressNr':U, 1).

    if gcAdressNr = 'no':U then
    do:

      find V_BelegKopfAdr
        where V_BelegKopfAdr.Firma      = V_BelegKopf.Firma
          and V_BelegKopfAdr.Belegart   = V_BelegKopf.Belegart
          and V_BelegKopfAdr.ReferenzNr = V_BelegKopf.ReferenzNr
          and V_BelegKopfAdr.Typ        = 'K':U
        no-lock no-error.

      if not available V_BelegKopfAdr then
      do:

        glZustandPruefen = no.

        run dispatch ('enable-fields':U).

        if return-value <> 'adm-error':U then
        do:

          run new-state('update':U).

          run OpenAddressViewer.

        end.

      end.  /* if not available V_BelegKopfAdr */

    end.  /* if gcAdressNr = 'no':U */

    &IF lookup("V_PKF":U,"{&PA-OPTIONEN}":U) > 0 &THEN
      &IF lookup("MU":U,"{&PA-MODULE}":U) > 0 &THEN

        if    can-do('A,U':U,V_BelegKopf.Belegart)
          and V_BelegKopf.Konfiguration = yes
          /* --> UMO#WH2015-07-010 cpl Strecke code checked <-- */
          and V_BelegKopf.Strecke       = no then

          run set-attribute-list ('KonfigProductInfo=yes':U).

        else

          run set-attribute-list ('KonfigProductInfo=no':U).

      &ENDIF
    &ENDIF

    if     V_BelegKopf.BelegArt = 'VFP':U
       and can-do('MLL,MLI':U, V_BelegKopf.Herk_BelegArt)
       and vert.base.cls.VBCSalesDocSvc:prpoInstance:lIsProFormaForShipDocToWarehouse
             (buffer V_BelegKopf) = yes then

      run set-attribute-list ('IsProFormaForShipDocToWH=yes':U).

    else
      run set-attribute-list ('IsProFormaForShipDocToWH=no':U).

    /* Set the window title for spare part quotes and spare part orders.      */

    &IF  (    LOOKUP("VS","{&PA-MODULE}")        > 0
          AND LOOKUP("VS_CALL","{&PA-OPTIONEN}") > 0)
      or (    LOOKUP("MS","{&PA-MODULE}")        > 0
          AND LOOKUP("MS_PROD","{&PA-OPTIONEN}") > 0) &THEN

      if can-do('A,U':U,V_BelegKopf.Belegart) then

        adm.method.cls.DMCUISvc:addWindowTitleExtension
          (hContainerSource,
           (if vert.base.cls.VBCSalesDocSvc:prpoInstance:lIsDocumentForSpareParts
              (V_BelegKopf.Belegart,
               V_BelegKopf.Origin_Obj) = yes then
              'Ersatzteile':T20
            else
              '':U)).

    &ENDIF

    if    can-do('R,G':U,V_BelegKopf.BelegArt)
      and pACConnectionSvc:prpcLocalization <> 'H':U then

      adm.method.cls.DMCUISvc:addWindowTitleExtension
        (hContainerSource,
         (if V_BelegKopf.ReverseInvoice = yes then
            'Korrektur':T20
          else
            '':U)).

  end. /* if available V_Belegkopf then */

end. /* if return-value <> 'adm-error':U then */

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-SendMail V-table-Win 
PROCEDURE local-SendMail :
/*------------------------------------------------------------------------------
  Purpose:     Sendet eine Mail
  Notes:
------------------------------------------------------------------------------*/

define variable cTemp           as character               no-undo.
define variable cEmail          as character               no-undo.
define variable cAnsprech       as character    init '':U  no-undo.
define variable cKunde          as character    init '':U  no-undo.
define variable cVertreter      as character    init '':U  no-undo.
define variable cSubject        as character    init ' ':U no-undo.
define variable cTemplateID     as character               no-undo.
define variable clMailBody      as longchar                no-undo.
define variable cMailOptions    as character               no-undo.
define variable lAttach         as logical                 no-undo.
define variable lSign           as logical                 no-undo.
define variable lPosEingabe     as logical                 no-undo.
define variable lPositionen     as logical      init yes   no-undo.
define variable oAttachDocument as SBCAttachedDocumentSvo  no-undo.

define buffer S_Ansprech          for S_Ansprech.
define buffer Buf_S_Adresse       for S_Adresse.
define buffer Buf_S_Vertreter     for S_Vertreter.
define buffer Buf_V_BelegKopfVert for V_BelegKopfVert.

fix-codepage(clMailBody) = 'utf-8':U.

if available V_BelegKopf then
do:

  /* Suche Ansprechpartner abh. von VC */

  {vert/incl/v_wbel00.if
    &AvailableAns = "if available S_Ansprech then
                       cAnsprech = S_Ansprech.EMail.
                     if V_BelegKopf.Belegart = 'VUD':U then
                       cRechnungsadresse = '':U."
  }

  lPosEingabe = (if    adm.config.cls.DCCAppConfigSvc:prpoInstance:lParameterValue
                         ('SB_PrintOptForDocOutput':U) = yes
                   and (   (    can-do ('U,VUA':U,V_BelegKopf.Belegart)
                            and V_BelegKopf.offen    = yes)
                        or (    V_BelegKopf.Belegart = 'L':U
                            and V_BelegKopf.offen    = yes
                            and can-find(first V_BelegPos
                                           where V_BelegPos.Firma      = V_BelegKopf.Firma
                                             and V_BelegPos.Belegart   = V_BelegKopf.Belegart
                                             and V_BelegPos.ReferenzNr = V_BelegKopf.ReferenzNr
                                             and V_BelegPos.offen      = no))) then
                   yes
                 else
                   no).

  /* Kunde */
  /* reload the customers address - the master could be modified in the meantime */

  if    available S_Kunde
    and S_Kunde.AdressNr <> 0 then
  do:

    /* load address in case the mail has been modified in the master */

    find S_Adresse
    where S_Adresse.Firma    = {firma/s_adres.fir pACConnectionSvc:prpcCompany}
      and S_Adresse.AdressNr = S_Kunde.AdressNr
    no-lock.

    gceMail = S_Adresse.EMail.

  end.

  cKunde = gcEMail.

  /* Vertreter */

  find first Buf_V_BelegKopfVert
    where Buf_V_BelegKopfVert.Firma      = V_BelegKopf.Firma
      and Buf_V_BelegKopfVert.Belegart   = V_BelegKopf.Belegart
      and Buf_V_BelegKopfVert.ReferenzNr = V_BelegKopf.ReferenzNr
      and can-find(S_KundeVertreter
                     where S_KundeVertreter.Firma          = {firma/skunvtr.fir pa-Firma}
                       and S_KundeVertreter.Kunde          = V_BelegKopf.Kunde
                       and S_KundeVertreter.Vertreter      = Buf_V_BelegKopfVert.Vertreter
                       and S_KundeVertreter.Hauptvertreter = yes)
    no-lock no-error.

  if available Buf_V_BelegKopfVert then
  do:

    find Buf_S_Vertreter
      where Buf_S_Vertreter.Firma     = {firma/svertret.fir pa-Firma}
        and Buf_S_Vertreter.Vertreter = Buf_V_BelegKopfVert.Vertreter
    no-lock no-error.

    if available Buf_S_Vertreter then

      find Buf_S_Adresse
        where buf_S_Adresse.Firma    = {firma/s_adres.fir pACConnectionSvc:prpcCompany}
          and Buf_S_Adresse.AdressNr = Buf_S_Vertreter.AdressNr
        no-lock no-error.

    if available Buf_S_Adresse then

      cVertreter = Buf_S_Adresse.EMail.

  end.  /* if available Buf_V_BelegKopfVert */

  assign
    cTemplateID     = stamm.base.cls.SBCEmailTemplatesSvc:prpoInstance:cDocumentTypeTemplateID(V_BelegKopf.V_BelegKopf_Obj)
    oAttachDocument = new SBCAttachedDocumentSvo(V_BelegKopf.BelegArt,
                                                 V_BelegKopf.Kunde,
                                                 V_BelegKopf.SBM_ProfitCenter_Obj)
    .

  {adm/incl/d__par00.if
    &Parameterliste = "cTemp"
    &Parameter      = "Ansprechpartner"
    &Variable1      = "cAnsprech"
  }

  {adm/incl/d__par00.if
    &Parameterliste = "cTemp"
    &Parameter      = "Kunde"
    &Variable1      = "cKunde"
  }

  {adm/incl/d__par00.if
    &Parameterliste = "cTemp"
    &Parameter      = "Lieferadresse"
    &Variable1      = "cLieferadresse"
  }

  {adm/incl/d__par00.if
    &Parameterliste = "cTemp"
    &Parameter      = "Rechnungsadresse"
    &Variable1      = "cRechnungsadresse"
  }

  {adm/incl/d__par00.if
    &Parameterliste = "cTemp"
    &Parameter      = "Bestimmungsort"
    &Variable1      = "gcBestimmungsort"
  }

  {adm/incl/d__par00.if
    &Parameterliste = "cTemp"
    &Parameter      = "Vertreter"
    &Variable1      = "cVertreter"
  }

  {adm/incl/d__par00.if
    &Parameterliste = "cTemp"
    &Parameter      = "PosEingabe"
    &Variable1      = "lPosEingabe"
  }

  {adm/incl/d__par00.if
    &Parameterliste = "cTemp"
    &Parameter      = "Positionen"
    &Variable1      = "lPositionen"
  }

  {adm/incl/d__par00.if
    &Parameterliste = "cTemp"
    &Parameter      = "Attachment"
    &Variable1      = "not(glUpdate)"
  }

  {adm/incl/d__par00.if
    &Parameterliste = "cTemp"
    &Parameter      = "V_Belegkopf_Obj"
    &Variable1      = "V_BelegKopf.V_BelegKopf_Obj"
  }

  {adm/incl/d__par00.if
    &Parameterliste = "cTemp"
    &Parameter      = "DocumentIsActive"
    &Variable1      = "V_BelegKopf.offen"
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

  run vert/proc/v__ema00.w(input-output cTemp).

  {adm/incl/d__par01.if
    &Parameterliste = "cTemp"
    &Parameter      = "AusPositionen"
    &Variable1      = "lPositionen"
    &Datentyp       = "logical"
  }

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

  {adm/incl/d__par01.if
    &Parameterliste = "cTemp"
    &Parameter      = "TemplateID"
    &Variable1      = "cTemplateID"
  }

  stamm.base.cls.SBCEmailTemplatesSvc:prpoInstance:PrepareMail(V_BelegKopf.V_BelegKopf_Obj,
                                                               cTemplateID,
                                                               output clMailBody,
                                                               output cSubject,
                                                               output cMailOptions).

  /* User-Exit für Betreff Die Variable cSubject kann hier zugewiesen werden */

  {&{&PA-XBasisName}_C_Subject}
  {&{&PA-XBasisName}_U_Subject}
  {&{&PA-XBasisName}_Q_Subject}
  {&{&PA-XBasisName}_Subject}
  {&{&PA-XBasisName}_Y_Subject}

  /* Damit beim LS wie bisher auch alle Positionen gedruckt werden            */

  if    adm.config.cls.DCCAppConfigSvc:prpoInstance:lParameterValue
          ('SB_PrintOptForDocOutput':U) = no
    and V_BelegKopf.Belegart            = 'L':U then
    lPositionen = no.

  assign
    cEmail = adm.method.cls.DMCParameterStringSvc:cReadValue(cTemp, 'Email':U, ?)
    cEmail = (if cEmail = ? then
                '':U
              else
                cEmail)
    cEmail = replace(cEmail,',':U,{&pa_D_MailParamDelimiter})
    .

  if lAttach = yes then
  do:

    assign
      cTemp        = pACStartupSvc:cParameterValue('Temp':U)
      gcAttach     = cTemp
                     + {&PA-BACKSLASH}
                     + string(V_BelegKopf.Belegnummer) + '.pdf':U
      glAttach     = yes
      glPositionen = lPositionen

      cMailOptions = adm.method.cls.DMCParameterStringSvc:cWriteValue(cMailOptions,'DeleteAttachments':U,yes).
      .

    if lSign = yes then
      cMailOptions = adm.method.cls.DMCParameterStringSvc:cWriteValue(cMailOptions,'SignAttachments':U,yes).

    /* Attachment erzeugen */

    /* --> UMO#WH2017-04-002 ash Kundencenter: Drucken und Mailen */
    &IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
    if gluRemote = yes then
      run local-print-current-record.
    else
    &ENDIF
    /* <-- UMO#WH2017-04-002 ash Kundencenter: Drucken und Mailen */
    run dispatch in this-procedure ('print-current-record':U).

    if return-value = 'ADM-ERROR':U then

      /* if an error occured is glAttach = yes and if you'll try to print it  */
      /* or send it again as a email nothing will happen as long as this      */
      /* window is open                                                       */

      glAttach = no.

    else
    do on error undo, throw:

      glAttach = no.

      /* Mit Attachment verschicken */

      adm.method.cls.DMCEMailSvc:prpoInstance:SendMail
        (cEmail,
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

        /* no matter which error occures glAttach must be set no */
        /* only then you can print or send this document again   */

        glAttach = no.

      end catch.

    end.

  end.  /* if lAttach */
  else

    adm.method.cls.DMCEMailSvc:prpoInstance:SendMail
      (cEmail,
       '':U,         /* CC      */
       '':U,         /* BCC     */
       cSubject,     /* Betreff */
       clMailBody,   /* Text    */
       '',
       yes,
       this-procedure,
       cMailOptions).

end. /* if available V_BelegKopf */

finally:

  if valid-object(oAttachDocument) then

    delete object oAttachDocument.

end. /* finally */

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-setup V-table-Win 
PROCEDURE local-setup :
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

/* Code placed here will execute PRIOR to standard behavior. */

  /* --> UMO#CA2016-03-001 PWa Gutschriftsverfahren */
  &IF LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN

    /* Einstellen Bereich und Druckprogramm                          */
    if cBelegart = 'GSA':U then
      assign
        cBereich       = 'VFGSA':U
        cDruckprogramm = 'branche/vert/proc/uvdgsa01.p':U
        cDruckvorlauf  = 'branche/vert/proc/uvdgsa10.w':U
        .

  &ENDIF
  /* <-- UMO#CA2016-03-001 PWa Gutschriftsverfahren */

/* Dispatch standard ADM method.                             */
run dispatch in this-procedure ('setup':U).

/* Code placed here will execute AFTER standard behavior.    */

if return-value <> 'adm-error':U then
do:

  /* --> UMO#CA2016-03-001 PWa Gutschriftsverfahren */
  &IF LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN

    {fnarg
      pa_lUISvcSetWidgetHiddenState
      "btnuFreigabe:handle in frame {&frame-name},
       cBelegart <> 'GSA':U"}.
  &ELSE
    {fnarg
      pa_lUISvcSetWidgetHiddenState
      "btnuFreigabe:handle in frame {&frame-name},
       yes"}.
  &ENDIF
  /* <-- UMO#CA2016-03-001 PWa Gutschriftsverfahren */

  run dispatch ('row-available':U).

  /* Focus zunächst auf Kundennummer */

  run pa_UISvcApplyEventToWidgetByHandle
        ('entry':U,
         V_BelegKopf.Kunde:handle in frame {&frame-name}).

end.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-SML V-table-Win 
PROCEDURE local-SML :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Super Override                                                             */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/* Die Sachmerkmalsleistenart wird in Abhängigkeit von der Belegart gesetzt   */
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

if available V_BelegKopf  then
do:

  case V_BelegKopf.BelegArt:

    /* Angebote  */

    when 'A':U then
      gcSMArt = 'VNA':U.

    /* Aufträge */

    when 'U':U then
      gcSMArt = 'VUU':U.

  end case.
end.
else
  gcSMArt = '':U.

run dispatch('SML':U).

/* Code placed here will execute AFTER standard behavior ---------------------*/

end procedure. /* local-SML */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
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

define variable lTemp           as logical       no-undo.
define variable lVorValutaDatum as logical       no-undo.

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Code placed here will execute PRIOR to standard behavior. */

/* Dispatch standard ADM method.                             */
run dispatch in this-procedure ('update-record':U).

/* Code placed here will execute AFTER standard behavior.    */

if return-value <> 'adm-error':U then
do:

  if    available V_BelegKopf
    and can-do('R':U,V_BelegKopf.Belegart) then
  do:

    find S_ZahlZiel
      where S_ZahlZiel.Firma        = {firma/szahlzie.fir pa-Firma}
        and S_ZahlZiel.Archived     = no
        and S_ZahlZiel.Zahlungsziel = V_BelegKopf.Zahlungsziel
      no-lock no-error.

    if    available S_ZahlZiel
      and S_ZahlZiel.manuell = yes then

      /* Prüfe Zahlziel und setze/entferne Ereignis */

      run PruefeZahlungsziel(       pa-Firma,
                                    rowid(V_BelegKopf),
                             output lTemp,
                             output lVorValutaDatum).

  end.

end. /* if return-value <> 'adm-error':U then */

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ModifyBankData V-table-Win 
PROCEDURE ModifyBankData :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Calls the dialog for modifying the bank data                               */
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

if glModifyBank = no then

  glModifyBank = yes.

run vert/proc/v_pbnk00.w (             V_BelegKopf.V_BelegKopf_Obj,
                          input-output gcOIDBank,
                          input-output gcBank,
                          input-output gcAccount,
                          input-output gcIBAN,
                          input-output cTmp).

end procedure. /* ModifyBankData */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenAddressViewer V-table-Win 
PROCEDURE OpenAddressViewer :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Opens the address viewer if it is necessary to modify the address          */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/* substitution for "onChoose of btn_Adresse"                                 */
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

define variable cPKS as character no-undo.

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

Main:
do on error undo Main, leave Main
  on endkey undo Main, leave Main:

  find ttS_Adresse
    no-error.

  if not available ttS_Adresse then
  do:

    create ttS_Adresse.
    ttS_Adresse.Firma = {firma/s_adres.fir pACConnectionSvc:prpcCompany}.

  end. /* if not available ttS_Adresse then */

  cPKS = adm.method.cls.DMCParameterStringSvc:cWriteValue(cPKS, 'AddressSourceTable':U, 'V_BelegKopfAdr':U).

  /* run display-fields again to refresh the ttS_Adresse entry which could */
  /* have been changed since opening the document for editing              */
  run dispatch in this-procedure ('display-fields':U). 

  run stamm/proc/s__adr20.w (input table ttS_Adresse by-reference,
                             input-output cPKS).

  assign
    c_Name-1  = ttS_Adresse.Name1
    c_Name-2  = ttS_Adresse.Name2
    c_Strasse = c_Strassenformat(ttS_Adresse.Staat,
                                 ttS_Adresse.Strasse,
                                 ttS_Adresse.Hausnummer)
    c_Ort     = c_AnzOrtsformat(ttS_Adresse.Staat,
                                ttS_Adresse.Bundesland,
                                ttS_Adresse.PLZ,
                                ttS_Adresse.Ort)
    .

  {adm/incl/d__duh00.if
     &Var1     = "c_name-1"
     &Var2     = "c_name-2"
     &Var3     = "c_Strasse"
     &Var4     = "c_Ort"
     &WithFrame = "frame {&FRAME-NAME}"}

end. /* Main */

end procedure. /* OpenAddressViewer */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE P_PrintCopy V-table-Win 
PROCEDURE P_PrintCopy :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Print an invoice copy with a user specified copy date                      */
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

define variable tDate as date initial ? no-undo.

/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

Main:
do on error  undo Main, retry Main
   on endkey undo Main, retry Main:

  if retry then
  do:

    gtpCopyDate = ?.

    return error.

  end.

  run vert/fakt/proc/vf_copp0.w (output tDate).

  if tDate <> ? then
  do:

    gtPCopyDate = tDate.

    run dispatch ('print-current-record':U).

  end. /* if tDate <> ? */

end. /* Main */

end procedure. /* P_PrintCopy */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE P_UpdateTaxation V-table-Win 
PROCEDURE P_UpdateTaxation :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Call Taxation Update Dialog                                                */
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

define variable tPostPeriodDate       as date      no-undo.
define variable tPostPeriodExRateDate as date      no-undo.
define variable tTaxPeriodDate        as date      no-undo.
define variable tTaxPeriodExRateDate  as date      no-undo.
define variable cTaxRegister          as character no-undo.
define variable lCashFlowPrinciple    as logical   no-undo.
define variable lSplitPayment         as logical   no-undo.
define variable tDateOfOriginalSale   as date      no-undo.

/* Buffers -------------------------------------------------------------------*/

define buffer bV_BelegKopf for V_BelegKopf.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

Main:
do on error  undo, return error
   on endkey undo, return error:

  assign
    tPostPeriodDate       = V_BelegKopf.P_PostPeriodDate
    tPostPeriodExRateDate = V_BelegKopf.P_PostPeriodExRateDate
    tTaxPeriodDate        = V_BelegKopf.P_TaxPeriodDate
    tTaxPeriodExRateDate  = V_BelegKopf.P_TaxPeriodExRateDate
    cTaxRegister          = V_BelegKopf.P_Steuerregister
    lCashFlowPrinciple    = V_BelegKopf.P_CashFlowPrinciple
    lSplitPayment         = V_BelegKopf.P_SplitPayment
    tDateOfOriginalSale   = V_BelegKopf.P_DateOfOriginalSale
    .

   run stamm/proc/s_ptaxp0.w(input        V_BelegKopf.V_BelegKopf_Obj,
                             input-output tPostPeriodDate,
                             input-output tPostPeriodExRateDate,
                             input-output tTaxPeriodDate,
                             input-output tTaxPeriodExRateDate,
                             input-output cTaxRegister,
                             input-output lCashFlowPrinciple,
                             input-output lSplitPayment,
                             input-output tDateOfOriginalSale).

  if tPostPeriodDate         <> V_BelegKopf.P_PostPeriodDate
    or tPostPeriodExRateDate <> V_BelegKopf.P_PostPeriodExRateDate
    or tTaxPeriodDate        <> V_BelegKopf.P_TaxPeriodDate
    or tTaxPeriodExRateDate  <> V_BelegKopf.P_TaxPeriodExRateDate
    or cTaxRegister          <> V_BelegKopf.P_Steuerregister
    or lCashFlowPrinciple    <> V_BelegKopf.P_CashFlowPrinciple
    or lSplitPayment         <> V_BelegKopf.P_SplitPayment
    or tDateOfOriginalSale   <> V_BelegKopf.P_DateOfOriginalSale then
  do:

    find bV_BelegKopf
      where bV_BelegKopf.Firma      = V_BelegKopf.Firma
        and bV_BelegKopf.Belegart   = V_BelegKopf.Belegart
        and bV_BelegKopf.ReferenzNr = V_BelegKopf.ReferenzNr
        and bV_BelegKopf.offen      = yes
      exclusive-lock.

    /* Tax period exchange rate date is not updated if intrastat is created */

    if bV_BelegKopf.P_TaxPeriodExRateDate <> tTaxPeriodExRateDate
      and can-find(first S_IntraHandel
                   where S_IntraHandel.Firma           = bV_BelegKopf.Firma
                     and S_IntraHandel.Herk_BelegArt   = bV_BelegKopf.BelegArt
                     and S_IntraHandel.Herk_ReferenzNr = bV_BelegKopf.ReferenzNr) then
    do:

      adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage('v_belp0021':U).

      tTaxPeriodExRateDate = bV_BelegKopf.P_TaxPeriodExRateDate.

    end. /* if bV_BelegKopf.P_TaxPeriodExRateDate <> tTaxPeriodExRateDate */

    assign
      bV_BelegKopf.P_NBP_ER_Date          = (if tPostPeriodExRateDate <> V_BelegKopf.P_PostPeriodExRateDate then
                                               ?
                                             else
                                               bV_BelegKopf.P_NBP_ER_Date)
      bV_BelegKopf.P_NBP_ER_Table         = (if tPostPeriodExRateDate <> V_BelegKopf.P_PostPeriodExRateDate then
                                               '':U
                                             else
                                               bV_BelegKopf.P_NBP_ER_Table)
      bV_BelegKopf.P_PostPeriodDate       = tPostPeriodDate
      bV_BelegKopf.P_PostPeriodExRateDate = tPostPeriodExRateDate
      bV_BelegKopf.P_TaxPeriodDate        = tTaxPeriodDate
      bV_BelegKopf.P_TaxPeriodExRateDate  = tTaxPeriodExRateDate
      bV_BelegKopf.P_Steuerregister       = cTaxRegister
      bV_Belegkopf.P_CashFlowPrinciple    = lCashFlowPrinciple
      bV_Belegkopf.P_SplitPayment         = lSplitPayment
      bV_Belegkopf.P_DateOfOriginalSale   = tDateOfOriginalSale
      bV_BelegKopf.gedruckt               = no
      bV_BelegKopf.BelegFreigabe          = no
      .

    validate bV_BelegKopf.

    run new-state ('P_TaxationChanged,record-target':U).

    run new-state ('special-fields,record-target':U).

  end.

end. /* Main */

end procedure. /* P_UpdateTaxation */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pa_UIMenmi_SendToLogisticsInterface V-table-Win 
PROCEDURE pa_UIMenmi_SendToLogisticsInterface :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Übertragen des Belegs an Logistikdienstleister                             */
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
define variable cOptions as character     no-undo.

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

&IF  LOOKUP("Q_TRANS","{&PA-OPTIONEN}") > 0 &THEN

  if available V_BelegKopf then
  do:

    {adm/incl/d__par00.if
      &ParameterListe = "cOptions"
      &Parameter      = "Belegnummer"
      &Variable1      = "V_BelegKopf.Belegnummer"
      &Variable2      = "V_BelegKopf.Belegnummer"
    }

    {adm/incl/d__par00.if
      &ParameterListe = "cOptions"
      &Parameter      = "Kunde"
      &Variable1      = "V_BelegKopf.Kunde"
      &Variable2      = "V_BelegKopf.Kunde"
    }

    {adm/incl/d__par00.if
      &ParameterListe = "cOptions"
      &Parameter      = "Belegdatum"
      &Variable1      = "V_BelegKopf.Belegdatum"
      &Variable2      = "V_BelegKopf.Belegdatum"
    }

    {adm/incl/d__par00.if
      &ParameterListe = "cOptions"
      &Parameter      = "&Belegart"
      &Variable1      = "V_BelegKopf.Belegart"
    }

    run vert/auf/proc/vu_tdl00.w(cOptions).

    run notify ('display-fields,record-target':U).

  end. /* if available V_BelegKopf then */

&ENDIF

end procedure. /* pa_UIMenmi_SendToLogisticsInterface */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pa_UIMenmi_UCWAnfrageGenerieren V-table-Win 
PROCEDURE pa_UIMenmi_UCWAnfrageGenerieren :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Generieren eines Anfragebelegs von bestimmten Angebotspositionen           */
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

&IF LOOKUP("U_CW":U,"{&PA-OPTIONEN}":U) > 0 &THEN

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/
define variable uiZaehler         as integer                   no-undo.
define variable uiLiefUebernahme  as integer                   no-undo.

define variable ulAngelegt        as logical                   no-undo.

define variable udPositionsNr     as decimal   init 1          no-undo.

define variable ucPKS             as character                 no-undo.
define variable ucPosListe        as character                 no-undo.

define variable uiDocumentNumber  like EA_AnfKopf.Belegnummer  no-undo.
define variable uiLfdNr           like EA_AnfKopf.LfdNr        no-undo init 0.

define variable ucText            as longchar                  no-undo.

/* Buffers -------------------------------------------------------------------*/
define buffer bV_BelegPos      for V_BelegPos.
define buffer bEA_AnfKopf      for EA_AnfKopf.
define buffer bEA_AnfPos       for EA_AnfPos.
define buffer bEA_AnfLieferant for EA_AnfLieferant.
define buffer bS_Artikel       for S_Artikel.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/
  if not available V_BelegKopf 
    or not can-find (first V_BelegPos
                     where V_BelegPos.Firma       = {firma/vbelegko.fir pACConnectionSvc:prpcCompany}
                       and V_BelegPos.BelegArt    = V_BelegKopf.BelegArt
                       and V_BelegPos.ReferenzNr  = V_BelegKopf.ReferenzNr) then
  do:
    adm.method.cls.DMCMessageSvc:prpoInstance:lShowMEssage('eaanf00017':U).
    return.
  end.

  run branche/eink/proc/uepang00.w (input-output ucPKS,
                                    string(rowid(V_Belegkopf))).
  {adm/incl/d__par01.if
    &ParameterListe = "ucPKS"
    &Parameter      = "Positionen"
    &Variable1      = "ucPosListe"
  }

  if {getwidgetattr last-event function string} = 'go':U 
    and ucPosListe > '':U then
  Main:
  do for bEA_AnfKopf transaction:

    {adm/incl/d__par01.if
      &ParameterListe = "ucPKS"
      &Parameter      = "Liefuebernahme"
      &Variable1      = "uiLiefUebernahme"
      &Datentyp       = "integer"
    }

    /* Erstmal den Kopf anlegen, ggf. nachher wieder löschen, wenn keine Positionen angelegt wurden */

    /* Trick, um temporär eine eindeutige Belegnummer zu haben          */
    uiLfdNr = -1.

    CreateHead:
    do while yes
      on error undo, throw:

      do while can-find(EA_AnfKopf
                          where EA_AnfKopf.Firma       = {firma/ebelkop.fir pACConnectionSvc:prpcCompany}
                            and EA_AnfKopf.offen       = yes
                            and EA_AnfKopf.Belegnummer = 0
                            and EA_AnfKopf.LfdNr       = uiLfdNr):

        uiLfdNr = uiLfdNr - 1.

      end. /* do while can-find(EA_AnfKopf */

      create bEA_AnfKopf.

      assign
        bEA_AnfKopf.Firma         = {firma/ebelkop.fir pACConnectionSvc:prpcCompany}
        bEA_AnfKopf.offen         = yes
        bEA_AnfKopf.LfdNr         = uiLfdNr
        bEA_AnfKopf.Wiedervorlage = today
        bEA_AnfKopf.Lagergruppe   = V_BelegKopf.Lagergruppe
        .

      validate bEA_AnfKopf no-error.

      if not error-status:error then

        leave CreateHead.

    end. /* CreateHead: */

    /* neue Belegnummer                                                 */

    {stamm/incl/s__num00.if
      &Tabelle       = "EA_AnfKopf"
      &Firma         = "{firma/ebelkop.fir pACConnectionSvc:prpcCompany}"
      &BelegArt      = "'EAA':U"
      &Offen         = "yes"
      &BelegNummer   = "uiDocumentNumber"
    }

    if uiDocumentNumber = ? then
      adm.method.cls.DMCMessageSvc:prpoInstance:showError('e_bel00106':U,
                                                          'EAA':U).

    assign
      bEA_AnfKopf.Belegnummer   = uiDocumentNumber
      bEA_AnfKopf.LfdNr         = 0
      bEA_AnfKopf.Wiedervorlage = today
      bEA_AnfKopf.Wunschtermin  = if V_Belegkopf.Wunschtermin < today then
                                    today
                                  else
                                    V_Belegkopf.Wunschtermin
      .

    /*--- Textposition anlegen ---*/

    create bEA_Anfpos.

    assign
      bEA_AnfPos.Firma             = bEA_AnfKopf.Firma
      bEA_AnfPos.ReferenzNr        = bEA_AnfKopf.ReferenzNr
      bEA_AnfPos.PositionsNr       = .1
      bEA_AnfPos.Satzart           = 'T':U
      .

    ucText = 'Kunde':T16 +
             ': ':U +
             string(V_Belegkopf.Kunde) +
             ' ':U +
             'Angebot':T7 +
             ': ':U +
             string(V_Belegkopf.BelegNummer).

    basis.text.cls.BTCTextSvc:prpoinstance:SaveText
      (V_Belegkopf.Firma,
       'EAANFP':U,
       bEA_AnfPos.EA_AnfPos_Obj,
       {&PA_DEFAULTSPRACHE},
       '':U,
       '',
       ucText).


    Verarbeitung:
    do uiZaehler = 1 to num-entries(ucPosListe,';':U)
      on error  undo Verarbeitung, next Verarbeitung
      on endkey undo Verarbeitung, leave Verarbeitung:

      /*--- Position holen ---*/
      find bV_BelegPos
        where bV_BelegPos.Firma       = pACConnectionSvc:prpcCompany
          and bV_BelegPos.BelegArt    = V_BelegKopf.BelegArt
          and bV_BelegPos.ReferenzNr  = V_BelegKopf.ReferenzNr
          and bV_BelegPos.LfdNr_SR    = 0
          and bV_BelegPos.PositionsNr = dec(entry(uiZaehler,ucPosListe,';':U))
        no-lock no-error.

      if not available bV_BelegPos  then
        next.

      /*--- Position anlegen ---*/

      create bEA_AnfPos.

      assign
        bEA_AnfPos.Firma                = bEA_AnfKopf.Firma
        bEA_AnfPos.ReferenzNr           = bEA_AnfKopf.ReferenzNr
        bEA_AnfPos.PositionsNr          = udPositionsNr
        bEA_AnfPos.Satzart              = 'A':U
        bEA_AnfPos.Artikel              = bV_BelegPos.Artikel
        bEA_AnfPos.ArtVar               = bV_BelegPos.ArtVar
        bEA_AnfPos.Menge                = bV_BelegPos.Menge
        bEA_AnfPos.Coverage_MRPDocType  = 'A':U
        bEA_AnfPos.Coverage_Obj         = bV_BelegPos.V_BelegPos_Obj
        .

      validate bEA_AnfPos.

      find bS_Artikel
        where bS_Artikel.Firma   = pACConnectionSvc:prpcCompany
          and bS_Artikel.Artikel = bV_BelegPos.Artikel
        no-lock.

      if can-do({&pa_S_PTList_OnceOnlyPartTypes}, string(bS_Artikel.ArtikelArt,'99':U)) then do:

        assign
          bEA_AnfPos.Bezeichnung[1] = bV_BelegPos.Bezeichnung[1]
          bEA_AnfPos.Bezeichnung[2] = bV_BelegPos.Bezeichnung[2]
          bEA_AnfPos.Bezeichnung[3] = bV_BelegPos.Bezeichnung[3]
          bEA_AnfPos.Bezeichnung[4] = bV_BelegPos.Bezeichnung[4]
          .

      end.

      if uiLiefUebernahme > 1 then
        for each E_ArtLief
          where E_ArtLief.Firma      = pACConnectionSvc:prpcCompany
            and E_ArtLief.Artikel    = bV_BelegPos.Artikel
            and E_ArtLief.archiviert = no
          no-lock
          on error undo, next:

          if uiLiefUebernahme = 2
            and not E_ArtLief.Hauptlieferant then
            next.

          if not can-find(first EA_AnfLieferant
                          where EA_AnfLieferant.Firma      = bEA_AnfKopf.Firma
                            and EA_AnfLieferant.ReferenzNr = bEA_AnfKopf.ReferenzNr
                            and EA_AnfLieferant.Lieferant  = E_ArtLief.Lieferant) then
          do:
            create bEA_AnfLieferant.
            assign
              bEA_AnfLieferant.Firma      = bEA_AnfKopf.Firma
              bEA_AnfLieferant.ReferenzNr = bEA_AnfKopf.ReferenzNr
              bEA_AnfLieferant.LfdNr      = 0
              bEA_AnfLieferant.Lieferant  = E_ArtLief.Lieferant
              .
            validate bEA_AnfLieferant.
          end.
        end. /* Lieferantenübernahme */


      release bEA_AnfPos.

      assign
        ulAngelegt    = yes
        udPositionsNr = udPositionsNr + 1
        .

    end. /* gewählte Positionen */

    /* Kein Position erfolgreich angelegt, dann löschen */
    if not ulAngelegt then
      delete bEA_AnfKopf.

  end. /* generieren Anfragebeleg */

  if ulAngelegt then
    adm.method.cls.DMCMessageSvc:prpoInstance:lshowMessage('uvang00001':U,
                                                            string(uiDocumentNumber)).

&ENDIF /* U_CW */

end procedure. /* pa_UIMenmi_UCWAnfrageGenerieren */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pa_UIMenmi_uCWNextTransports V-table-Win 
PROCEDURE pa_UIMenmi_uCWNextTransports :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Calls Dialog with next suitable Transports                                 */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/* UMO#WH2017-04-011 cpl Tourenplanung: Belege auf andere Transporte planen   */
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

&IF LOOKUP("U_CW":U,"{&PA-OPTIONEN}":U) > 0 &THEN

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/
define variable cParam as character   no-undo.

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

  if available V_BelegKopf then
  do:

    cParam = adm.method.cls.DMCParameterStringSvc:cwritevalue(cParam, 'Source_Obj':U, V_BelegKopf.V_BelegKopf_Obj).

    run branche/vert/proc/uvptra04.w (input-output cParam).

    run notify('display-fields, record-target':U).

  end.

&ENDIF /* U_CW */

end procedure. /* pa_UIMenmi_uCWNextTransports */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pa_UIMenmi_uEtikettendruck V-table-Win 
PROCEDURE pa_UIMenmi_uEtikettendruck :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Aufruf des Etikettenvorlaufs                                               */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/* UMO#WH2016-07-001 cpl Etiketten                                            */
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

&IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/
  define variable cParameter as character     no-undo.

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

  if available V_BelegKopf then
  do:

    {adm/incl/d__par00.if
      &ParameterListe = "cParameter"
      &Parameter      = "&whatToPrint"
      &Variable1      = "V_BelegKopf.V_BelegKopf_Obj"
    }

    run branche/vert/proc/uvdeti00.w(cParameter).

  end.

&ENDIF

end procedure. /* pa_UIMenmi_uEtikettendruck */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Packschein V-table-Win 
PROCEDURE Packschein :
/*------------------------------------------------------------------------------
  Purpose:     Programmaufruf für Ausgabe des Packscheins
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

define variable c_ParamListe as character no-undo.
define variable iFormularNr  as integer   no-undo.
define variable iAnzahl      as integer   no-undo.

define buffer bS_Kunde          for S_Kunde.
&IF lookup ("VC","{&PA-MODULE}") > 0 &THEN
  define buffer bVC_Interessent for VC_Interessent.
&ENDIF

/* Error if no record is available */
if not available V_BelegKopf then
  adm.method.cls.DMCMessageSvc:prpoInstance:ShowError('dtviw00002':U).

/* Zustandsprüfung und Anzeige zum Beleg */

basis.buro.cls.BBCWorkflowSvc:prpoInstance:showLockStatus
  (V_BelegKopf.V_BelegKopf_Obj,
   cBereich).

/* Zustandsprüfung und Anzeige zum Kunden */

find bS_Kunde
  where bS_Kunde.Firma = {firma/s_kunde.fir pa-Firma}
    and bS_Kunde.Kunde = V_BelegKopf.Kunde
  no-lock.

basis.buro.cls.BBCWorkflowSvc:prpoInstance:showLockStatus
  (bS_Kunde.S_Kunde_Obj,
   cBereich).

&IF lookup ("VC","{&PA-MODULE}") > 0 &THEN

  /* Zustandsprüfung und Anzeige zum Interessenten */

  find bVC_Interessent
    where bVC_Interessent.Firma       = {firma/s_kunde.fir pa-Firma}
      and bVC_Interessent.Interessent = V_BelegKopf.Interessent
    no-lock no-error.

  if available bVC_Interessent then
    basis.buro.cls.BBCWorkflowSvc:prpoInstance:showLockStatus
      (bVC_Interessent.VC_Interessent_Obj,
       cBereich).

&ENDIF /* VC */

run vert/proc/v_pfor00.w (input        'VUP':U,
                                output iFormularNr,
                                output iAnzahl).

if {getwidgetattr last-event function string} <> 'go':U then
  return error.

{adm/incl/d__par00.if
  &ParameterListe = "c_ParamListe"
  &Parameter      = "FormularNr"
  &Variable1      = "iFormularNr"
}

{adm/incl/d__par00.if
  &ParameterListe = "c_ParamListe"
  &Parameter      = "Anzahl"
  &Variable1      = "iAnzahl"
}

{adm/incl/d__par00.if
  &ParameterListe = "c_ParamListe"
  &Parameter      = "ReferenzNr"
  &Variable1      = "V_BelegKopf.ReferenzNr"
  &Variable2      = "V_BelegKopf.ReferenzNr"
}

/*  Need for List & Label                                                     */

{adm/incl/d__par00.if
  &ParameterListe = "c_ParamListe"
  &Parameter      = "Belegart"
  &Variable1      = "V_BelegKopf.Belegart"
}

run basis/job/proc/bjvjob00.w ('':U,
                               c_ParamListe,
                               'vert/auf/proc/vudpak01.p':U).

return.

end procedure.

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

define variable lZZiel            as logical             no-undo.
define variable lVorValutaDatum   as logical             no-undo.

/* Buffers -------------------------------------------------------------------*/

define buffer bS_ZahlZiel for S_ZahlZiel.
define buffer bV_BelegPos for V_BelegPos.
/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

if can-do('R':U,V_BelegKopf.Belegart) then
do:

  stamm.base.cls.SBCCreditTermsSvc:prpoInstance:CheckCreditTermAssignment
    ({firma/szahlzie.fir pa-Firma},
     V_BelegKopf.Zahlungsziel,
     V_BelegKopf.Kunde).

  /* prüfe das ggf. manuelle Zahlungsziel */

  find bS_ZahlZiel
    where bS_ZahlZiel.Firma        = {firma/szahlzie.fir pa-Firma}
      and bS_ZahlZiel.Zahlungsziel = V_BelegKopf.Zahlungsziel
    no-lock.

  if bS_ZahlZiel.manuell = yes then
  do:


    run PruefeZahlungsziel(       pa-Firma,
                                  rowid(V_BelegKopf),
                           output lZZiel,
                           output lVorValutaDatum).

    if   lVorValutaDatum then
      adm.method.cls.DMCMessageSvc:prpoInstance:showError
        ('v_bel00429':U,
         string(V_BelegKopf.Belegnummer)).                      

    if    lZZiel            = yes
      and V_Belegkopf.offen = yes then

      adm.method.cls.DMCMessageSvc:prpoInstance:showError
        ('v_bel00107':U,
          string(V_BelegKopf.Belegnummer)).

  end.

end. /* Rechnungen */

if V_BelegKopf.Belegart = 'R':U
 or (    V_BelegKopf.Belegart   = 'G':U
     and V_BelegKopf.Origin_Obj = '':U) then
do:

  /* Invoices with any head surcharges and without invoice lines can not be */
  /* processed in daily closing (this is validated in trigger v_belkow.p),  */
  /* so it must be avoided that this document can be printed and delivered  */
  /* to a customer.                                                         */

  if    (   V_BelegKopf.Zuschlag[1] <> 0
         or V_BelegKopf.Zuschlag[2] <> 0
         or V_BelegKopf.Zuschlag[3] <> 0
         or V_BelegKopf.Zuschlag[4] <> 0)
    and not can-find(first bV_BelegPos
                       where bV_BelegPos.Firma      = V_BelegKopf.Firma
                         and bV_BelegPos.Belegart   = V_BelegKopf.Belegart
                         and bV_BelegPos.ReferenzNr = V_BelegKopf.ReferenzNr
                         and bV_BelegPos.Satzart    = 'A':U) then

    adm.method.cls.DMCMessageSvc:prpoInstance:showError
      ('v_trg00150':U,
       string(V_BelegKopf.Belegnummer)).

  if pACConnectionSvc:prpcLocalization = 'I':U then
  do:

    if can-find(first S_I_TOPRate
                  where S_I_TOPRate.Firma        = {firma/szahlzie.fir pa-Firma}
                    and S_I_TOPRate.ZahlungsZiel = V_BelegKopf.Zahlungsziel) then
    do:

      run PruefeZahlungsziel(pa-Firma
                             + {&pa-Delimiter3}
                             + 'Rates':U,
                             rowid(V_BelegKopf),
                             output lZZiel,
                             output lVorValutaDatum).

      if lZZiel               = yes
        and V_BelegKopf.offen = yes then

       adm.method.cls.DMCMessageSvc:prpoInstance:showError
         ('s_zzii0007':U,
          string(V_BelegKopf.Belegnummer),
          string(V_BelegKopf.Zahlungsziel)).

    end. /* if can-find(first S_I_TOPRate */

  end. /* if pACConnectionSvc:prpcLocalization = 'I':U then */

end.

/* Prüfung Bestimmungsort */

&IF "{&pa_S_IncoTerm}":U = "1":U &THEN

  if     V_BelegKopf.Bestimmungsort = 3
     and V_BelegKopf.offen = yes
     and can-do('U,L,VUD,R,G,VFP':U,V_BelegKopf.Belegart)
     and lBestimmungsortVorh (pa-Firma,
                              V_BelegKopf.Belegart,
                              V_BelegKopf.ReferenzNr,
                              ?) = no then

    adm.method.cls.DMCMessageSvc:prpoInstance:showError
      ('v_inc00002':U,
         string(V_BelegKopf.Belegnummer),
         string(V_BelegKopf.Lieferbedingung),
         V_BelegKopf.IncoTerm).

&ENDIF

/* --> UMO#CA2016-08-012 MOu Kommissionierung:nur vollstän. erstell. Lieferschein drucken */
&IF LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN
if V_Belegkopf.Belegart = 'L':U
  and can-find(first MMT_Picking
                 where MMT_Picking.Company        = {firma/mlartort.fir pACConnectionSvc:prpcCompany}
                   and MMT_Picking.offen          = yes
                   and MMT_Picking.Target_DocType = 'L':U
                   and MMT_Picking.ShippingDocNo  = V_Belegkopf.Belegnummer) then

  adm.method.cls.DMCMessageSvc:prpoInstance:ShowError('uvbel00027':U,
                                                       string(V_Belegkopf.Belegnummer)).
&ENDIF
/* <-- UMO#CA2016-08-012 MOu */

if    pACConnectionSvc:prpcLocalization = 'H':U
  and V_BelegKopf.BelegArt              = 'R':U then
do:

  if    S_Kunde.H_Kobak
    and S_Kunde.H_NaturalPerson = no
    and stamm.base.cls.SBCTaxMasterFilesSvc:prpoInstance:cIsoAlphaCodeOfTaxTerritory
          (V_BelegKopf.Dept_SBM_TaxTerritory_Obj[{&pa_SB_TaxTerritoryExt_Country}]) = 'HU':U
    and stamm.base.cls.SBCTaxMasterFilesSvc:prpoInstance:cIsoAlphaCodeOfTaxTerritory
          (V_BelegKopf.Dest_SBM_TaxTerritory_Obj[{&pa_SB_TaxTerritoryExt_Country}]) = 'HU':U
    and not stamm.base.cls.SBCLocalizationHUSvc:prpoInstance:lIsDomesticTaxIDValid(S_Kunde.inlaendische_SteuerNr) then

    adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
      ('s_trgh0004':U,
        S_Kunde.inlaendische_SteuerNr,
        string(S_Kunde.Kunde)).

  if   V_BelegKopf.Zuschlag[1]   <> 0
    or V_BelegKopf.Zuschlag[2]   <> 0
    or V_BelegKopf.Zuschlag[3]   <> 0
    or V_BelegKopf.Zuschlag[4]   <> 0
    or V_BelegKopf.proz_Zuschlag <> 0 then

    adm.method.cls.DMCMessageSvc:prpoInstance:showError
      ('v_belh1018':U,
        string(V_BelegKopf.Belegnummer)).

end. /* if pACConnectionSvc:prpcLocalization = 'H':U */


end procedure. /* PrePrintChecks */

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

{adm/template/incl/sndkycas.i "Kunde" "V_BelegKopf" "Kunde" " "}
{adm/template/incl/sndkycas.i "BelegNummer" "V_BelegKopf" "BelegNummer" " "}
{adm/template/incl/sndkycas.i "ShippingType" "V_BelegKopf" "VersandArt" " "}
{adm/template/incl/sndkycas.i "DocumentOwning_Obj" "V_BelegKopf" "V_BelegKopf_Obj" " "}
{adm/template/incl/sndkycas.i "Owning_Obj" "V_BelegKopf" "V_BelegKopf_Obj" " "}
{adm/template/incl/sndkycas.i "P_Owning_Obj" "V_BelegKopf" "V_BelegKopf_Obj" " "}
{adm/template/incl/sndkycas.i "Interessent" "V_BelegKopf" "Interessent" " "}
{adm/template/incl/sndkycas.i "Textsprache" " " "pa-Sprache" " "}
{adm/template/incl/sndkycas.i "FO_OP_Obj" " " "cFO_OP_Obj" " "}
{adm/template/incl/sndkycas.i "ReferenzNr" "V_BelegKopf" "ReferenzNr" " "}
{adm/template/incl/sndkycas.i "BelegArt" "V_BelegKopf" "BelegArt" " "}
{adm/template/incl/sndkycas.i "$KEY" "V_BelegKopf" " " "vert/incl/v_belko.sl "}
{adm/template/incl/sndkycas.i "Schluessel" " " "'':U" " "}
{adm/template/incl/sndkycas.i "Origin_Obj" "V_BelegKopf" "V_BelegKopf_Obj" " "}
{adm/template/incl/sndkycas.i "V_BelegKopf_Obj" "V_BelegKopf" "V_BelegKopf_Obj" " "}
{adm/template/incl/sndkycas.i "Origin_Obj" "V_BelegKopf" "Origin_Obj" " "}
{adm/template/incl/sndkycas.i "JBT_Project_Obj" "V_BelegKopf" "JBT_Project_Obj" " "}
{adm/template/incl/sndkycas.i "SBM_BankDataAcc_Obj" "V_BelegKopf" "SBM_BankDataAcc_Obj" " "}
{adm/template/incl/sndkycas.i "AddressInfoWinTitle" " " "gcAddressInfoWinTitle" " "}
{adm/template/incl/sndkycas.i "S_Kunde_Obj" "S_Kunde" "S_Kunde_Obj" " "}
{adm/template/incl/sndkycas.i "MMM_CusRefOrder_Obj" "V_BelegKopf" "MMM_CusRefOrder_Obj" " "}
{adm/template/incl/sndkycas.i "Driver_Obj" "V_BelegKopf" "Driver_Obj" " "}
{adm/template/incl/sndkycas.i "SBM_BusinessCategory_Obj" "V_BelegKopf" "SBM_BusinessCategory_Obj" " "}
{adm/template/incl/sndkycas.i "SBM_ProfitCenter_Obj" "V_BelegKopf" "SBM_ProfitCenter_Obj" " "}
{adm/template/incl/sndkycas.i "SBM_FiscalText_Obj" "V_BelegKopf" "SBM_FiscalText_Obj" " "}
{adm/template/incl/sndkycas.i "SBM_TaxCase_Obj" "V_BelegKopf" "SBM_TaxCase_Obj" " "}
{adm/template/incl/sndkycas.i "S_Steuer_Obj" "V_BelegKopf" "S_Steuer_Obj" " "}
{adm/template/incl/sndkycas.i "uAngebot" "V_BelegKopf" "uAngebot" " "}
{adm/template/incl/sndkycas.i "uAngebot_LfdNr" "V_BelegKopf" "uAngebot_LfdNr" " "}
{adm/template/incl/sndkycas.i "uAngebotsversion" "V_BelegKopf" "uAngebotsversion" " "}
{adm/template/incl/sndkycas.i "S_F_Journal_Obj" "V_BelegKopf" "S_F_Journal_Obj" " "}
{adm/template/incl/sndkycas.i "S_I_TaxExemption_Obj" "V_BelegKopf" "S_I_TaxExemption_Obj" " "}
{adm/template/incl/sndkycas.i "S_BankVerb_Obj" "V_BelegKopf" "S_BankVerb_Obj" " "}
{adm/template/incl/sndkycas.i "VBM_PreConfigVariant_Obj" "V_BelegKopf" "VBM_PreConfigVariant_Obj" " "}

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

{adm/template/incl/snd-list.i "V_BelegKopf"}
{adm/template/incl/snd-list.i "ttS_Adresse"}

/* Deal with any unexpected table requests before closing.                    */

{adm/template/incl/snd-end.i}

end procedure. /* send-records */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SendDocmail V-table-Win 
PROCEDURE SendDocmail :
/*------------------------------------------------------------------------------
  Purpose:     Mail ohne UI verschicken
  Notes:
------------------------------------------------------------------------------*/

define variable cAdresse  as character no-undo.
define variable cAusgabe  as character no-undo.
define variable cTemp     as character no-undo.
define variable cBetreff  as character no-undo.
define variable cFilename as character no-undo.

/* reload the customers address - the master could be modified in the meantime */

if    available S_Kunde
  and S_Kunde.AdressNr <> 0 then
do:

  /* load address in case the mail has been modified in the master */

  find S_Adresse
  where S_Adresse.Firma    = {firma/s_adres.fir pACConnectionSvc:prpcCompany}
    and S_Adresse.AdressNr = S_Kunde.AdressNr
  no-lock.

  gceMail = S_Adresse.EMail.

end.

cAdresse = gcEMail.

/* Betreff auslesen */

cBetreff = V_BelegKopf.Beleginfo.

cTemp = pACStartupSvc:cParameterValue('Temp':U).

/* Abhängig von Generatortyp des hinterlegten Formulars wird */
/* entweder .txt oder .pdf verschickt                        */

case gcGeneratortyp:

  when 'P':U then

    assign
      cFilename = string(V_BelegKopf.Belegnummer) + '.txt':U
      cAusgabe  = cTemp
                  + {&PA-BACKSLASH}
                  + 'ausgabe.asc':U
      .

  when 'W':U then
    cFilename = string(V_BelegKopf.Belegnummer) + '.pdf':U.

end case.

assign
  gcAttach = cTemp
             + {&PA-BACKSLASH}
             + cFilename
  glAttach = yes
  .

run dispatch in this-procedure ('print-current-record':U).

if return-value <> 'ADM-ERROR':U then
do on error undo, throw:

  glAttach = no.

  /* Mit Attachment verschicken */

  /* Mit ASCII-Generator wurde nach Ausgabe.asc gedruckt - diese muss noch umkopiert werden */

  if gcGeneratortyp = 'P':U then

    os-copy value(cAusgabe) value(gcAttach).

  if adm.config.cls.DCCAppConfigSvc:prpoInstance:lParameterValue
       ('VB_OrderConfimWebShopViaEMail':U) = no then

    adm.method.cls.DMCEMailSvc:prpoInstance:SendMail
      (cAdresse,
       '':U,
       '':U,
       cBetreff,
       '':U,
       gcAttach,
       no,
       this-procedure,
       'DeleteAttachments=yes':U).

  /* catch DMCDialogCanceledErr to avoid buffer loss in this case */

  catch oError as adm.method.cls.DMCDialogCanceledErr:
    /* Cancel: do nothing */
  end.                              /* code checked by Matheis_U 17.03.2014 */

end.
else

  adm.method.cls.DMCEMailSvc:prpoInstance:SendMail
    (cAdresse,
     '':U,
     '':U,
     cBetreff,
     '':U,
     gcAttach,
     yes,
     this-procedure,
     'DeleteAttachments=yes':U).

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&IF DEFINED(EXCLUDE-SendEInvoice) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SendEInvoice Method-Library
procedure SendEInvoice :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Send document as an eInvoice to the outbox                                 */
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

if available V_BelegKopf then
  do:

    vert.fakt.cls.VFCEInvoiceSvc:prpoInstance:cSendEInvoice(V_BelegKopf.V_BelegKopf_Obj).

    run notify ('display-fields,record-target':U).

  end.

end procedure. /* SendEInvoice */


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetSelection V-table-Win 
PROCEDURE SetSelection :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Temporarily applies entry to V_BelegKopf.Empfaenger field so ALT+PageUp is */
/* functioning after update-complete or cancel-record in the position window  */
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

define input        parameter phPosWindow as handle     no-undo.

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

if pa-fields-enabled
  and valid-handle(phPosWindow)
  and V_BelegKopf.Empfaenger:hidden in frame {&frame-name}    = no
  and V_BelegKopf.Empfaenger:sensitive in frame {&frame-name} = yes then
do:

  run pa_UISvcApplyEventToWidgetByHandle
        ('entry':U,
         V_BelegKopf.Empfaenger:handle in frame {&frame-name}).
  
  run dispatch in phPosWindow('apply-entry':U).

end.

end procedure. /* SetSelection */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-cSatzId_neu V-table-Win 
PROCEDURE set-cSatzId_neu :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Setzt cSatzId_neu                                                          */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/* UMO#CM2017-05-001 tri Versandstückliste                                    */
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
define input parameter pcSatzId_neu as character no-undo.

&IF LOOKUP("U_CM":U,"{&PA-OPTIONEN}":U) > 0 &THEN

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

  cSatzId_neu = pcSatzId_neu.

&ENDIF

end procedure. /* set-cSatzId_neu */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SingleDocToFNA V-table-Win 
PROCEDURE SingleDocToFNA :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* turn over a single invoice to the financial accounting interface           */
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

define variable cParamListe as character   no-undo.

&IF lookup ("F_":U,"{&pa-Module}":U) > 0 &THEN
  define variable dPostingYear   like FS_Kopf.BuchungsJahr    no-undo.
  define variable iPostingPeriod like FS_Kopf.BuchungsPeriode no-undo.
&ENDIF

/* Buffers -------------------------------------------------------------------*/

&IF lookup ("F_":U,"{&pa-Module}":U) > 0 &THEN
  define buffer bFS_Kopf for  FS_Kopf.
&ENDIF

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

if adm.method.cls.DMCMessageSvc:prpoInstance:lshowMessage
     ('v_belp0014':U,
      string(input frame {&frame-name} V_BelegKopf.Belegnummer)) = yes then
do:

  {adm/incl/d__par00.if
    &ParameterListe = "cParamListe"
    &Parameter      = "V_BelegKopf_Obj"
    &Variable1      = "V_BelegKopf.V_BelegKopf_Obj"
  }

  do on error undo, return error:

    run vert/proc/v_vtag00.p(cParamListe).

  end.

  &IF lookup ("F_":U,"{&pa-Module}":U) > 0 &THEN

    /* calculate posting year and period */

    assign
      dPostingYear   = {fnarg
                         pa_dFiYearFYearOfDate
                         "pa-Firma,
                          today"}
      iPostingPeriod = {fnarg
                         pa_iFiYearPPerOfDate2
                         "pa-Firma,
                          today"}
      .

    /* get the last Kopfnummer (if the document was succesfully archived) */

    if V_BelegKopf.offen = no
      and can-find(first V_BelegPos
                   where V_BelegPos.Firma      = {firma/vbelegko.fir pa-Firma}
                     and V_BelegPos.Belegart   = V_BelegKopf.Belegart
                     and V_BelegPos.ReferenzNr = V_BelegKopf.ReferenzNr) then

      find last bFS_Kopf
        where bFS_Kopf.Firma           = {firma/fbbuchu.fir pa-Firma}
          and bFS_Kopf.Herkunft        = 'V':U
          and bFS_Kopf.Freigabe        = yes
          and bFS_Kopf.BuchungsJahr    = dPostingYear
          and bFS_Kopf.BuchungsPeriode = iPostingPeriod
          and bFS_Kopf.Fehler          = no
          and bFS_Kopf.Benutzer        = pACConnectionSvc:prpcUserID
        use-index Herkunft
      no-lock no-error.

    if available bFS_Kopf then
    do:

      {adm/incl/d__par00.if
        &ParameterListe = "cParamListe"
        &Parameter      = "HeadNumber"
        &Variable1      = "bFS_Kopf.KopfNummer"
      }

      {adm/incl/d__par00.if
        &ParameterListe = "cParamListe"
        &Parameter      = "Origin"
        &Variable1      = "'V':U"
      }

      do on error undo, return error:

        run fibu/proc/f_vtag00.p(cParamListe).

      end. /* do */

    end. /* if available bFS_Kopf */

  &ENDIF

  /* screen refresh, even if only posted to interface */

  run notify ('get-prev,record-source':U).

end.

return.

end procedure. /* SingleDocToFNA */

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

define input parameter p-issuer-hdl as handle    no-undo.
define input parameter p-state      as character no-undo.

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

case p-state:

  &IF LOOKUP("U_CW":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  /* --> UMO#WH2015-10-001 cpl Kundencenter */
  when 'xFakeAdd':U then do:
    /*--- hier adm-cancel-record austricksen, damit der Satz wie bei normaler ---*/
    /*--- Neuanlage gelöscht wird, sobald abgebrochen wird ---*/
    assign
      ADM-NEW-RECORD      = yes
      adm-adding-record   = yes
      adm-create-complete = yes
      .
  end.
  /* <-- UMO#WH2015-10-001 cpl Kundencenter */
  &ENDIF

  /* --> UMO#CM2016-07-001 Erwartete Erlöse in Projektkalkulation */
  &IF LOOKUP("U_CM":U,"{&PA-OPTIONEN}":U) > 0
    AND LOOKUP("JB":U,"{&PA-MODULE}":U) > 0 &THEN
    when 'uAuftragZugeordnet':U then
      run new-state('uAuftragZugeordnet,container-source':U).
  &ENDIF
  /* <-- UMO#CM2016-07-001 Erwartete Erlöse in Projektkalkulation */

  /* --> UMO#CA2016-05-003a MOu Rahmenauftrag: Auftragsschnellerfassung vereinfachen */
  &IF LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  when 'uBelegposArtikel-VUR':U then
  do:

    if not valid-handle (ghuHandle) then
      ghuHandle = {fnarg
                     pa_hADMGetFirstLinkHandle
                      "this-procedure,
                       'container-source':U"}.

    /* get the Handle from the calling Prog from vupauf00.w */

    if valid-handle (ghuHandle)
      and ghuHandle:name = 'vert/auf/proc/vupauf00.w':U then

      run get-uSourceHandle in ghuHandle
        (output ghuSourceHandle).

    if valid-handle(ghuSourceHandle)
      and ghuSourceHandle:name = 'branche/vert/proc/uvbauf00.w':U then

     run get-Part-VUR in ghuSourceHandle
          (output gcuArtikel-VUR).

    run set-link-attribute in adm-broker-hdl
      (this-procedure,
       'record-target':U,
       'uBelegposArtikel-VUR=':U + gcuArtikel-VUR).
  end.
  &ENDIF
  /* <-- UMO#CA2016-05-003a MOu Rahmenauftrag: Auftragsschnellerfassung vereinfachen */

  /* --> UMO#CM2017-05-001 tri Versandstückliste */
  &IF LOOKUP("U_CM":U,"{&PA-OPTIONEN}":U) > 0 &THEN
    when 'uVersandstuecklisteClosed':U then
    do:

      if   cSatzId_neu = ?
        or cSatzId_neu = '':U then

        return 'Abbruch':U.

      assign
        glZuschlag_sperren = yes
        .

      if gluNewDocument then
        run Beleg_uebernommen.

      gluNewDocument = no.

    end.
  &ENDIF
  /* <-- UMO#CM2017-05-001 tri Versandstückliste */

  when 'NewPosNotify':U then

    run new-state ('NewPosNotify,record-target':U).

  when 'Orderlines':U then
  do:

    run Beleguebernahme_Auftragspositionen no-error.

    if error-status:error then
    do:

      {adm/incl/d__msg00.if
        &Meldung = "'s_bel00002':U"
      }
      return.

    end.

  end.

  when 'Kommissionieren':U then
  do:

    run Kommissionieren no-error.

    if error-status:error then
      return.

  end.

  when 'Anzahlungen':U then
  do:

    &IF lookup("V_ANZ","{&PA-OPTIONEN}") > 0 &THEN

      run Anzahlungen no-error.

      if error-status:error then
        return.

    &ENDIF

  end.

  when 'EDIMessage':U then
  do:

    run EDINachricht no-error.

    if error-status:error then
      return.

  end.

  when 'Produktkonfiguration':U then
  do:

    run Varianten4 no-error.
    if error-status:error then
      return.

  end.

  when 'ProduktkonfigurationInfo':U then
  do:

    run Varianten4Info no-error.
    if error-status:error then
      return.

  end.

  when 'Beleguebernahme':U then
  do:

    run Beleguebernahme no-error.

    if error-status:error then
    do:

      {adm/incl/d__msg00.if
        &Meldung = "'s_bel00002':U"
      }
      return.

    end.

  end.

  when 'Satz_geaendert':U then

    run notify ('row-available':U).

  when 'Neuanlage':U then

    if V_BelegKopf.Kunde:sensitive in frame {&frame-name} = no then

      run dispatch ('update-record':U). /* code checked by Stegner_K 13.11.2017 */

  when 'Modus-BelegKopf':U then
  do:

    run set-link-attribute in adm-broker-hdl
          (this-procedure,
           'record-target':U,
           'UpdateKopf=':U + (if glUpdate = yes then
                                'yes':U
                              else
                                'no':U)).

  end.

  /* send updateSalesDocHeaderUI2 because one of its targets sends the updateSalesDocHeaderUI1 state  */
  /* and would create an infinit loop by sending updateSalesDocHeaderUI1                              */
  when 'updateSalesDocHeaderUI1':U then   

    run new-state ('updateSalesDocHeaderUI2,record-target':U).

  /* Object instance CASEs can go here to replace standard behavior
     or add new cases. */
  {adm/template/incl/dt_viw00.if}

  /* an order line was deleted: inform the browser which will inform others   */
  when 'PositionDeleted':U then
    run new-state('PositionDeleted,record-target':U).

end case.

/* wenn die Position geöffnet wird, muss auch der Kopf geöffnet werden */

if    return-value <> 'adm-error':U
  and p-state       = 'Update-Start-Pos':U
  and glUpdate = no
  and available V_BelegKopf then
do:

  {fn pa_lADMCheckContainerLock}.

  glZustandPruefen = no.

  run dispatch ('enable-fields':U).

  if return-value <> 'adm-error':u then

    run new-state('update':U).

  glZustandPruefen = yes.

end.

/* If an order was adopted to an PPmt Invoice, then refresh the bill-to   */
/* address, which may have been adopted as well.                          */

&IF lookup ("V_Anz":U,"{&PA-OPTIONEN}":U) > 0 &THEN

  if    p-state              = 'update-complete':U
    and available V_BelegKopf
    and V_BelegKopf.Belegart = 'R':U then

    run new-state('address-modified,record-target':U).

&ENDIF

/* Maybe the tax code has been changed during the creation of a new line.     */
/* In this case we have to refresh the combo.                                 */
/* We do no longer disable the combo since PA-10302 except for cancellation   */
/* invoices / credit notes (V_BelegKopf.ReverseInvoice)                       */

if    p-state                       = 'update-complete':U
  and gcTaxCodeOID                  > '':U
  and available V_BelegKopf
  and V_BelegKopf.S_Steuer_Obj     <> gcTaxCodeOID
  and V_BelegKopf.Uebernahme        = yes
  and V_Belegkopf.Schlussrechnung   = no
  and V_Belegkopf.Teilrechnung      = no
  and (   V_BelegKopf.Belegart      = 'R':U
       or (    V_BelegKopf.Belegart = 'G':U
           and can-find(first V_BelegPos
                          where V_BelegPos.Firma      = V_BelegKopf.Firma
                            and V_BelegPos.Belegart   = V_BelegKopf.Belegart
                            and V_BelegPos.ReferenzNr = V_BelegKopf.ReferenzNr
                            and V_BelegPos.Satzart    = 'A':U))) then

  run new-state('TaxCodeChanged,record-target':U).

/* State is sent by the child when closing the record. When then child-record */
/* is opened again, the state ofe the document must be checked and displayed. */

if can-do('update-complete,text-modified':U, p-state) then
  glZustandPruefen = yes.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE uAdopting V-table-Win 
PROCEDURE uAdopting :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* this is an interface for adopting if the viewer is only used as code       */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/* UMO#WH2016-02-002 cpl Folgebelege aus Kundencenter generieren              */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* ipcV_BelegKopf_Obj   - Source Document Header Obj                          */
/* ipcTargetDocType     - Target Document Type                                */
/* ipiTypOfAdopt        - Complete or by Line Adoption                        */
/* ipiPurchaseReference - Purchase Order RefNo for filtering a push to        */
/*                        a drop ship shipping document (only CW)             */
/* iTransport            i Transportnummber for transportclean creation of    */
/*                         ShippingDocument                                   */
/* opcNewV_BelegKopf_Id - New created Head oBj                                */
/*                                                                            */
/* Examples ------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/*----------------------------------------------------------------------------*/
  define input  parameter ipcV_BelegKopf_Obj     like V_BelegKopf.V_BelegKopf_Obj no-undo.
  define input  parameter ipcTargetDocType       as character                     no-undo.
  define input  parameter ipiTypOfAdopt          as integer                       no-undo.
  &IF LOOKUP("U_CW":U,"{&PA-OPTIONEN}":U) > 0 &THEN
    /* --> UMO#WH2017-04-017 cpl Streckenlieferschein */
    define input  parameter ipiPurchaseReference   like E_BelegPos.ReferenzNr       no-undo.
    /* <-- UMO#WH2017-04-017 cpl Streckenlieferschein */
    /* --> UMO#WH2016-11-001 cpl Tourenplanung */
    define input  parameter ipTransport            like V_SendungKopf.Belegnummer   no-undo.
    /* <-- UMO#WH2016-11-001 cpl Tourenplanung */
  &ENDIF
  /* --> UMO#CA2016-04-014a AJa Versandmonitor - Lieferscheingenerierung */
  /* --> UMO#386033 MDe Versandmonitor: Funktion Lieferschein erstellen nach CCI */
  define input  parameter ipcProcHandle          as character     no-undo.
  /* <-- UMO#386033 MDe Versandmonitor: Funktion Lieferschein erstellen nach CCI */
  /* <-- UMO#CA2016-04-014a AJa Versandmonitor - Lieferscheingenerierung */
  define output parameter opcNewV_BelegKopf_Id as character no-undo.

&IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

  if pa-Firma = ? then
    pa-Firma = pACConnectionSvc:prpcCompany.

  /* for slightly other behavior in standard procedures we use a global */
  gluAdopting = yes.

  if ipcTargetDocType = 'MKB':U then
  do:
    find V_BelegKopf
      where V_BelegKopf.V_BelegKopf_Obj = ipcV_BelegKopf_Obj
      no-lock.
    run Kommissionieren.
  end.
  else do:

    /* set the global Variable to Target DocType */
    cBelegart   = ipcTargetDocType .

      /* set the Object ID for the adopting program, so no filter is needed */
    {adm/incl/d__par00.if
      &Parameterliste = "cTmp"
      &Parameter      = "uV_BelegKopf_Obj"
      &Variable1      = "ipcV_BelegKopf_Obj"
    }

    {adm/incl/d__par00.if
      &Parameterliste = "cTmp"
      &Parameter      = "utypeOfAdopt"
      &Variable1      = "ipiTypOfAdopt"
    }

    &IF LOOKUP("U_CW":U,"{&PA-OPTIONEN}":U) > 0 &THEN
    /* --> UMO#WH2017-04-017 cpl Streckenlieferschein */
    {adm/incl/d__par00.if
      &Parameterliste = "cTmp"
      &Parameter      = "uPurchaseReference"
      &Variable1      = "ipiPurchaseReference"
    }
    /* <-- UMO#WH2017-04-017 cpl Streckenlieferschein  */

    /* --> UMO#WH2016-11-001 cpl Tourenplanung */
    {adm/incl/d__par00.if
      &Parameterliste = "cTmp"
      &Parameter      = "uTransportToAdopt"
      &Variable1      = "ipTransport"
    }
    /* <-- UMO#WH2016-11-001 cpl Tourenplanung */
    &ENDIF

    /* --> UMO#CA2016-04-014a AJa Versandmonitor - Lieferscheingenerierung */
    /* --> UMO#386033 MDe Versandmonitor: Funktion Lieferschein erstellen nach CCI */
    if ipcProcHandle > '':U then
    do:
      {adm/incl/d__par00.if
        &Parameterliste = "cTmp"
        &Parameter      = "uProcHandle"
        &Variable1      = "ipcProcHandle"
      }
    end.
    /* <-- UMO#386033 MDe Versandmonitor: Funktion Lieferschein erstellen nach CCI */
    /* <-- UMO#CA2016-04-014a AJa Versandmonitor - Lieferscheingenerierung */

    run BelegUebernahme.

    opcNewV_BelegKopf_Id = cSatzId_neu.
  end.

&ENDIF

end procedure. /* uAdopting */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE uCreateReservation V-table-Win 
PROCEDURE uCreateReservation :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Create reservation for every open lines for order. Reserve quantity        */
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
&IF LOOKUP("U_CW":U,"{&PA-OPTIONEN}":U) > 0 &THEN
/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

if available V_BelegKopf
  and V_BelegKopf.offen = yes then
  run branche/vert/proc/uvpbel04.w(V_BelegKopf.V_BelegKopf_Obj).

&ENDIF

end procedure. /* uCreateReservation */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE uPrintDokument V-table-Win 
PROCEDURE uPrintDokument :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Print document from Kundencenter                                           */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/* UMO#WH2017-04-002 ash Kundencenter: Drucken und Mailen                     */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* ipcV_BelegKopf_Obj as Dokument Object (V_belegkopf)                        */
/*                                                                            */
/* Examples ------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/*----------------------------------------------------------------------------*/
define input  parameter ipcV_BelegKopf_Obj     as character no-undo.

&IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

  run uSetParameter(ipcV_BelegKopf_Obj).

  find S_Kunde
    where S_Kunde.Firma = {firma/s_kunde.fir pACConnectionSvc:prpcCompany}
      and S_Kunde.Kunde = V_BelegKopf.Kunde
    no-lock no-error.

  if available S_Kunde then
    run local-print-current-record.

&ENDIF

end procedure. /* uPrintDokument */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE uQuoteVersioning V-table-Win 
PROCEDURE uQuoteVersioning :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Create a new Version of a Quote                                            */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/* triggered by menu of instance                                              */
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
&IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

do on error undo, throw:

  gluQuoteVersioning = yes.

  run Beleguebernahme.

  finally:
    gluQuoteVersioning = no.
  end finally.

end. /* do */

&ENDIF

return.

end procedure. /* uQuoteVersioning */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE use-Bestimmungsort V-table-Win 
PROCEDURE use-Bestimmungsort :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

define input parameter pcBestimmungsort as character no-undo.

  gcBestimmungsort = pcBestimmungsort.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE use-Generatortyp V-table-Win 
PROCEDURE use-Generatortyp :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

define input parameter pcGeneratortyp as character no-undo.

gcGeneratortyp = pcGeneratortyp.


end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE use-Lieferadresse V-table-Win 
PROCEDURE use-Lieferadresse :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

define input parameter pc_Lieferadresse as character no-undo.

cLieferadresse = pc_Lieferadresse.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE use-Rechnungsadresse V-table-Win 
PROCEDURE use-Rechnungsadresse :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

define input parameter pc_Rechnungsadresse as character no-undo.

cRechnungsadresse = pc_Rechnungsadresse.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE uSendMail V-table-Win 
PROCEDURE uSendMail :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* SendMail document from Kundencenter                                        */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/* UMO#WH2017-04-002 ash Kundencenter: Drucken und Mailen                     */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* ipcV_BelegKopf_Obj as Dokument Object (V_belegkopf)                        */
/*                                                                            */
/* Examples ------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/*----------------------------------------------------------------------------*/
define input  parameter ipcV_BelegKopf_Obj     as character no-undo.

&IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

  run uSetParameter(ipcV_BelegKopf_Obj).

  if available V_BelegKopf then
  do:
    find S_Kunde
      where S_Kunde.Firma = {firma/s_kunde.fir pACConnectionSvc:prpcCompany}
        and S_Kunde.Kunde = V_BelegKopf.kunde
      no-lock no-error.
    find V_BelegKopfAdr
    where V_BelegKopfAdr.Firma      = V_BelegKopf.Firma
      and V_BelegKopfAdr.Belegart   = V_BelegKopf.Belegart
      and V_BelegKopfAdr.ReferenzNr = V_BelegKopf.ReferenzNr
      and V_BelegKopfAdr.Typ        = 'K':U
    no-lock no-error.

    if      available V_BelegKopfAdr
       and ((V_BelegKopf.offen    = yes
            and S_Kunde.AdressNr  = 0)
             or V_BelegKopf.offen = no) then
      gcEMail  = V_BelegKopfAdr.EMail.

    else
    do:

      find S_Adresse
        where S_Adresse.Firma    = {firma/s_adres.fir pACConnectionSvc:prpcCompany}
          and S_Adresse.AdressNr = S_Kunde.AdressNr
        no-lock no-error.

      if available S_Adresse then
        gcEMail  = S_Adresse.EMail.

    end. /* Stammadresse */


    /* if gluRemote = yes than execute Local-print for PDf whitout Dispath */
    gluRemote = yes.

    run local-SendMail.

  end.

&ENDIF

end procedure. /* uSendMail */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE uSetParameter V-table-Win 
PROCEDURE uSetParameter :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Set Parameter for Email and Print for Kundencenter                         */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/* UMO#WH2017-04-002 ash Kundencenter: Drucken und Mailen                     */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* ipcV_BelegKopf_Obj as Dokument Object (V_belegkopf)                        */
/*                                                                            */
/* Examples ------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/*----------------------------------------------------------------------------*/
define input  parameter ipcV_BelegKopf_Obj     as character no-undo.

&IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

  if pa-Firma = ? then
    pa-Firma = pACConnectionSvc:prpcCompany.

  find V_BelegKopf
    where V_BelegKopf.V_BelegKopf_Obj = ipcV_BelegKopf_Obj
    no-lock.
  if available V_BelegKopf then
  do:
    cBelegart = V_BelegKopf.BelegArt.
    case cBelegart:

      when 'A':U then
        assign
          cBereich       = 'VN':U
          cDruckprogramm = 'vert/ange/proc/vndang01.p':U
          cDruckvorlauf  = 'vert/ange/proc/vndang10.w':U
          .
      when 'U':U then
        assign
          cBereich       = 'VU':U
          cDruckprogramm = 'vert/auf/proc/vudauf01.p':U
          cDruckvorlauf  = 'vert/auf/proc/vudauf10.w':U
          .
      when 'VUA':U then
        assign
          cBereich       = 'VUA':U
          cDruckprogramm = 'vert/auf/proc/vudabr01.p':U
          cDruckvorlauf  = 'vert/auf/proc/vudabr10.w':U
          .
      when 'L':U then
        assign
          cBereich       = 'VUL':U
          cDruckprogramm = 'vert/auf/proc/vudlis01.p':U
          cDruckvorlauf  = 'vert/auf/proc/vudlis10.w':U
          .
      when 'VUD':U then
        assign
          cBereich       = 'VUD':U
          cDruckprogramm = 'vert/auf/proc/vuddls01.p':U
          cDruckvorlauf  = 'vert/auf/proc/vuddls10.w':U
          .
      when 'R':U then
        assign
          cBereich       = (if lSchlussrechnung = no then
                              'VFR':U
                            else
                              'VFSR':U)
          cDruckprogramm = 'vert/fakt/proc/vfdrec02.p':U
          cDruckvorlauf  = 'vert/fakt/proc/vfdrec10.w':U
          .
      when 'VFP':U then
        assign
          cBereich       = 'VFP':U
          cDruckprogramm = 'vert/fakt/proc/vfdpfr01.p':U
          cDruckvorlauf  = 'vert/fakt/proc/vfdpfr10.w':U
          .
      when 'G':U then
        assign
          cBereich       = 'VFG':U
          cDruckprogramm = 'vert/fakt/proc/vfdgut02.p':U
          cDruckvorlauf  = 'vert/fakt/proc/vfdgut10.w':U
          .
      when 'VUR':U then
        assign
          cBereich       = 'VUR':U
          cDruckprogramm = 'vert/auf/proc/vudrah01.p':U
          cDruckvorlauf  = 'vert/auf/proc/vudrah10.w':U
          .

    end case.
   end.

&ENDIF

end procedure. /* uSetParameter */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE uVersandstuecklisteCreate V-table-Win 
PROCEDURE uVersandstuecklisteCreate :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Start der Belegübernahmefunktion für Versandstückliste                     */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/*  UMO#CM2017-05-001 tri Versandstückliste                                   */
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

&IF LOOKUP("U_CM":U,"{&PA-OPTIONEN}":U) > 0 &THEN

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

  do on error undo, throw:

    assign
      gluVersand     = yes
      gluNewDocument = yes
      .

    run Beleguebernahme.

    finally:
      gluVersand = no.
    end finally.

  end. /* do */

  return.

&ENDIF

end procedure. /* uVersandstuecklisteCreate */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE uVersandstuecklisteUpdate V-table-Win 
PROCEDURE uVersandstuecklisteUpdate :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Start der Belegübernahmefunktion für Versandstückliste                     */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/* UMO#CM2017-05-001 tri Versandstückliste                                    */
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

&IF LOOKUP("U_CM":U,"{&PA-OPTIONEN}":U) > 0 &THEN

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

  do on error undo, throw:

    assign
      gluVersand     = yes
      gluNewDocument = no
      .

    run Beleguebernahme.

    finally:
      gluVersand = no.
    end finally.

  end. /* do */

  return.

&ENDIF

end procedure. /* uVersandstuecklisteUpdate */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Varianten4 V-table-Win 
PROCEDURE Varianten4 :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Komplettkonfiguration:                                                     */
/* Erfasse und Pflege der Variantenmerkmale bei Teileart 04 in Logik          */
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

define variable lFolgebeleg as logical no-undo.

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

Main:
do on error undo Main, return error:

  &IF LOOKUP("MU":U,"{&PA-MODULE}":U) > 0 &THEN

    &IF lookup("V_PKF":U,"{&PA-OPTIONEN}":U) > 0 &THEN

      lFolgebeleg = no.

      if V_BelegKopf.Belegart = 'U':U then
      do:

        Folgebeleg:
        for each V_BelegPos
          where V_BelegPos.Firma      = V_BelegKopf.Firma
            and V_BelegPos.Belegart   = V_BelegKopf.Belegart
            and V_BelegPos.ReferenzNr = V_BelegKopf.ReferenzNr
            and V_BelegPos.LfdNR_SR   = 0
          no-lock
          on error  undo Folgebeleg, leave Folgebeleg
          on endkey undo Folgebeleg, leave Folgebeleg:

          if   (    V_BelegPos.gelieferte_Menge  <> 0
                and V_BelegPos.offen              = yes)
            or mawi.base.cls.MMCPickingSvc:prpoInstance:lDocLineIsInPicking(V_BelegPos.V_BelegPos_Obj)
            or can-find (first Buf_V_BelegPos
                           where Buf_V_BelegPos.Firma            = V_BelegPos.Firma
                             and Buf_V_BelegPos.Belegart         = 'L':U
                             and Buf_V_BelegPos.Herk_Belegart    = V_BelegPos.Belegart
                             and Buf_V_BelegPos.Herk_ReferenzNr  = V_BelegPos.ReferenzNr
                             and Buf_V_BelegPos.Herk_PositionsNr = V_BelegPos.PositionsNr)
            or can-find (first Buf_V_BelegPos
                           where Buf_V_BelegPos.Firma            = V_BelegPos.Firma
                             and Buf_V_BelegPos.Belegart         = 'R':U
                             and Buf_V_BelegPos.Herk_Belegart    = V_BelegPos.Belegart
                             and Buf_V_BelegPos.Herk_ReferenzNr  = V_BelegPos.ReferenzNr
                             and Buf_V_BelegPos.Herk_PositionsNr = V_BelegPos.PositionsNr) then
          do:

            lFolgebeleg = yes.

            leave Folgebeleg.

          end.  /* if (V_BelegPos.gelieferte_Menge  <> 0 */

          if V_BelegPos.KO_Lagerort <> ?
            and can-find(first ML_BelegPos
                         where ML_BelegPos.Firma            = {firma/mlartort.fir V_BelegPos.Firma}
                           and ML_BelegPos.Belegart         = 'MLL':U
                           and ML_BelegPos.Herk_Belegart    = V_BelegPos.Belegart
                           and ML_BelegPos.Herk_ReferenzNr  = V_BelegPos.ReferenzNr
                           and ML_BelegPos.Herk_PositionsNr = V_BelegPos.PositionsNr
                           and ML_BelegPos.offen            = yes) then
          do:

            lFolgebeleg = yes.

            leave Folgebeleg.

          end.

          &IF lookup("PP","{&pa-Module}") > 0 &THEN

            if can-find (first PP_Auftrag
                           where PP_Auftrag.Firma           = {firma/ppauftra.fir V_BelegPos.Firma}
                             and PP_Auftrag.Archived        = no
                             and PP_Auftrag.Auftragskennung = 'F':U
                             and PP_Auftrag.Kunde           = V_BelegKopf.Kunde
                             and PP_Auftrag.nicht_erster    = no
                             and PP_Auftrag.Belegnummer     = V_BelegPos.Belegnummer
                             and PP_Auftrag.PositionsNr     = V_BelegPos.PositionsNr
                             and PP_Auftrag.Coverage_Obj    = V_BelegPos.V_BelegPos_Obj) then
            do:

              lFolgebeleg = yes.

              leave Folgebeleg.

            end.

            if can-find (first PP_Auftrag
                           where PP_Auftrag.Firma           = {firma/ppauftra.fir V_BelegPos.Firma}
                             and PP_Auftrag.Archived        = yes
                             and PP_Auftrag.Auftragskennung = 'F':U
                             and PP_Auftrag.Kunde           = V_BelegKopf.Kunde
                             and PP_Auftrag.nicht_erster    = no
                             and PP_Auftrag.Belegnummer     = V_BelegPos.Belegnummer
                             and PP_Auftrag.PositionsNr     = V_BelegPos.PositionsNr
                             and PP_Auftrag.Coverage_Obj    = V_BelegPos.V_BelegPos_Obj) then
            do:

              lFolgebeleg = yes.

              leave Folgebeleg.

            end.

          &ENDIF

          &IF lookup("E_","{&pa-Module}") > 0 &THEN

            if can-find (first E_BelegPos
                           where E_BelegPos.Firma               = {firma/ebelkop.fir V_BelegPos.Firma}
                             and E_BelegPos.Belegart            = 'EB':U
                             and E_BelegPos.Coverage_MRPDocType = 'U':U
                             and E_BelegPos.Coverage_Obj        = V_BelegPos.V_BelegPos_Obj
                             and E_BelegPos.Artikel             = V_BelegPos.Artikel
                             and E_BelegPos.offen               = yes) then
             do:

              lFolgebeleg = yes.

              leave Folgebeleg.

            end.

          &ENDIF

        end.  /* for each V_BelegPos */

      end.  /* if V_BelegKopf.Belegart = 'U':U */

      if lFolgebeleg = yes then
      do:

        {adm/incl/d__msg00.if
          &Meldung = "'v_bel00050':U"
          &Liste   = "string(V_BelegKopf.Belegnummer)"
        }

        return.

      end.

      /* .NET configurator */
      &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
      if mawi.auf.cls.MUCConfRuntimeFacadeSvo:lUseDotNetRuntime({&pa_MU_ConfigDocumentHeader}, '':U) then
      do:

        goPCRuntime = mawi.auf.cls.MUCConfRuntimeFacadeSvo:oCreateInstance({&pa_MU_ConfigDocumentHeader}, adm-broker-hdl).
        goPCRuntime:RegisterCallback('finished':U, 'Varianten4-PostProcessing':U, this-procedure).
        goPCRuntime:ExeConfigDocumentHeader(V_BelegKopf.V_BelegKopf_Obj).

      end.

      /* C++ configurator */
      else
      do
      on error undo, throw:

        /* For PK2 and modal configuration we need to block pA */

          if not adm.method.cls.DMCSessionSvc:prplClassicUI then
            basis.base.cls.BMCMainWindowSvc:DisableMainForm(yes).

        run mawi/auf/proc/mu_var01.p (V_BelegKopf.Firma,
                                      rowid(V_BelegKopf),
                                      0,
                                     {&pa_MU_ConfigDocumentHeader}).

        run Varianten4-PostProcessing.

        finally:
            if not adm.method.cls.DMCSessionSvc:prplClassicUI then
              basis.base.cls.BMCMainWindowSvc:EnableMainForm(yes).
        end.

      end.
      &ENDIF
    &ELSE

      adm.method.cls.DMCMessageSvc:prpoInstance:showError('muvar00051':U, 'V_PKF':U).

    &ENDIF

  &ENDIF

end. /* Main */

return.

end procedure. /* Varianten4 */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Varianten4-PostProcessing V-table-Win 
PROCEDURE Varianten4-PostProcessing :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/*  Varianten4-PostProcessig                                                  */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/*                                                                            */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/*----------------------------------------------------------------------------*/

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

run new-state ('refresh,record-target':U).

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Varianten4Info V-table-Win 
PROCEDURE Varianten4Info :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Komplettkonfiguration:                                                     */
/* Anzeigen der Variantenmerkmale bei Teileart 04 in Logik                    */
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

&IF LOOKUP("MU":U,"{&PA-MODULE}":U) > 0 &THEN

  &IF lookup("V_PKF":U,"{&PA-OPTIONEN}":U) > 0 &THEN

    /* .NET configurator */
    &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
    if mawi.auf.cls.MUCConfRuntimeFacadeSvo:lUseDotNetRuntime({&pa_MU_ConfigDocumentHeaderInfo}, '':U) then
    do:

      goPCRuntime = mawi.auf.cls.MUCConfRuntimeFacadeSvo:oCreateInstance({&pa_MU_ConfigDocumentHeaderInfo}, adm-broker-hdl).
      goPCRuntime:ExeConfigDocumentHeader(V_BelegKopf.V_BelegKopf_Obj).

    end.

    /* C++ configurator */
    else
    do
    on error undo, throw:

      /* For PK2 and modal configuration we need to block pA */

        if not adm.method.cls.DMCSessionSvc:prplClassicUI then
          basis.base.cls.BMCMainWindowSvc:DisableMainForm(yes).

      run mawi/auf/proc/mu_var01.p (V_BelegKopf.Firma,
                                    rowid(V_BelegKopf),
                                    0,
                                    {&pa_MU_ConfigDocumentHeaderInfo}).

      finally:
          if not adm.method.cls.DMCSessionSvc:prplClassicUI then
            basis.base.cls.BMCMainWindowSvc:EnableMainForm(yes).
      end.

    end.
    &ENDIF
  &ELSE

    adm.method.cls.DMCMessageSvc:prpoInstance:showError('muvar00051':U, 'V_PKF':U).

  &ENDIF
&ENDIF

end procedure. /* Varianten4Info */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Withdrawal V-table-Win 
PROCEDURE Withdrawal :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Create a new shipment document by a customers withdrawal                   */
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

define variable cTemp as character no-undo.

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

Main:
do on error undo Main, leave Main
  on endkey undo Main, leave Main:

  run mawi/lager/proc/mlpbel27.w (             cBelegart,
                                        output cSatzId_neu,
                                        output cSatzId,
                                  input-output cTemp) no-error.

  if   error-status:error
    or cSatzId_neu = '':U
    or cSatzId_neu = ? then

    leave Main.

  run Beleg_uebernommen.

  return.

end.

return.

end procedure. /* Withdrawal */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE XMLExportInvoice V-table-Win 
PROCEDURE XMLExportInvoice :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Start XML-Export for invoices and credits. Only for Austria                */
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

&IF lookup ("VC","{&PA-MODULE}") > 0 &THEN
  define buffer bVC_Interessent for VC_Interessent.
&ENDIF

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Zugangssperre im Prüfungsmodus (InfoOnly) */

{stamm/incl/s_vgdp01.if}

if    available V_BelegKopf
  and can-do('R,G':U,V_BelegKopf.Belegart) then
do:

  /* Zustandsprüfung und Anzeige zum Beleg */

  basis.buro.cls.BBCWorkflowSvc:prpoInstance:showLockStatus
    (V_BelegKopf.V_BelegKopf_Obj,
     cBereich).

  /* Zustandsprüfung und Anzeige zum Kunden */

  basis.buro.cls.BBCWorkflowSvc:prpoInstance:showLockStatus
    (S_Kunde.S_Kunde_Obj,
     cBereich).

  &IF lookup ("VC","{&PA-MODULE}") > 0 &THEN

    /* Zustandsprüfung und Anzeige zum Interessenten */

    find bVC_Interessent
      where bVC_Interessent.Firma       = {firma/s_kunde.fir pa-Firma}
        and bVC_Interessent.Interessent = V_BelegKopf.Interessent
      no-lock no-error.

    if available bVC_Interessent then
      basis.buro.cls.BBCWorkflowSvc:prpoInstance:showLockStatus
        (bVC_Interessent.VC_Interessent_Obj,
         cBereich).

  &ENDIF /* VC */

  if adm.method.cls.DMCMessageSvc:prpoInstance:lShowMessage
       ('v_rga00001':U,
        (if V_Belegkopf.Belegart = 'R':U then
           'Rechnung':U
         else
           'Gutschrift':U)) = yes then

    run vert/proc/v_vrec00.p(rowid(V_BelegKopf)).

end. /* if available V_BelegKopf then */

return.

end procedure. /* XMLExportInvoice */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK  _PROCEDURE CURRENT-WINDOW-layouts _LAYOUT-CASES
PROCEDURE CURRENT-WINDOW-layouts:
  DEFINE INPUT PARAMETER layout AS CHARACTER                     NO-UNDO.
  DEFINE VARIABLE lbl-hndl AS WIDGET-HANDLE                      NO-UNDO.
  DEFINE VARIABLE widg-pos AS DECIMAL                            NO-UNDO.

  /* Copy the name of the active layout into a variable accessible to   */
  /* the rest of this file.                                             */
  CURRENT-WINDOW-layout = layout.

  CASE layout:
    WHEN "Master Layout" THEN DO:
      ASSIGN
         V_BelegKopf.AuftragsArt:HIDDEN IN FRAME F-Main    = yes
         widg-pos = V_BelegKopf.AuftragsArt:COL IN FRAME F-Main 
         V_BelegKopf.AuftragsArt:COL IN FRAME F-Main       = 23
         lbl-hndl = V_BelegKopf.AuftragsArt:SIDE-LABEL-HANDLE IN FRAME F-Main 
         lbl-hndl:COL = lbl-hndl:COL + V_BelegKopf.AuftragsArt:COL IN FRAME F-Main  - widg-pos
         V_BelegKopf.AuftragsArt:HIDDEN IN FRAME F-Main    = no
         V_BelegKopf.AuftragsArt:HIDDEN IN FRAME F-Main    = no.

      ASSIGN
         V_BelegKopf.BelegDatum:HIDDEN IN FRAME F-Main     = no.

      ASSIGN
         gcBelegInfoRA:HIDDEN IN FRAME F-Main              = no.

      ASSIGN
         V_BelegKopf.H_Cancelled:HIDDEN IN FRAME F-Main    = yes
         V_BelegKopf.H_Cancelled:ROW IN FRAME F-Main       = 9
         V_BelegKopf.H_Cancelled:HIDDEN IN FRAME F-Main    = no.

      ASSIGN
         V_BelegKopf.H_Corrected:HIDDEN IN FRAME F-Main    = yes
         V_BelegKopf.H_Corrected:ROW IN FRAME F-Main       = 9
         V_BelegKopf.H_Corrected:HIDDEN IN FRAME F-Main    = no.

      ASSIGN
         V_BelegKopf_AuftragsArt_Info:HIDDEN IN FRAME F-Main = yes
         V_BelegKopf_AuftragsArt_Info:COL IN FRAME F-Main  = 31
         V_BelegKopf_AuftragsArt_Info:WIDTH IN FRAME F-Main = 32
         V_BelegKopf_AuftragsArt_Info:HIDDEN IN FRAME F-Main = no
         V_BelegKopf_AuftragsArt_Info:HIDDEN IN FRAME F-Main = no.

      ASSIGN
         V_BelegKopf_BelegDatum_Info:HIDDEN IN FRAME F-Main = no.

    END.  /* Master Layout Layout Case */

    WHEN "Kurzinfo":U THEN DO:
      ASSIGN
         V_BelegKopf.AuftragsArt:HIDDEN IN FRAME F-Main    = yes
         widg-pos = V_BelegKopf.AuftragsArt:COL IN FRAME F-Main 
         V_BelegKopf.AuftragsArt:COL IN FRAME F-Main       = 22.5
         lbl-hndl = V_BelegKopf.AuftragsArt:SIDE-LABEL-HANDLE IN FRAME F-Main 
         lbl-hndl:COL = lbl-hndl:COL + V_BelegKopf.AuftragsArt:COL IN FRAME F-Main  - widg-pos.

      ASSIGN
         V_BelegKopf.BelegDatum:HIDDEN IN FRAME F-Main     = yes.

      ASSIGN
         gcBelegInfoRA:HIDDEN IN FRAME F-Main              = yes.

      ASSIGN
         V_BelegKopf.H_Cancelled:HIDDEN IN FRAME F-Main    = yes
         V_BelegKopf.H_Cancelled:ROW IN FRAME F-Main       = 8
         V_BelegKopf.H_Cancelled:HIDDEN IN FRAME F-Main    = no.

      ASSIGN
         V_BelegKopf.H_Corrected:HIDDEN IN FRAME F-Main    = yes
         V_BelegKopf.H_Corrected:ROW IN FRAME F-Main       = 8
         V_BelegKopf.H_Corrected:HIDDEN IN FRAME F-Main    = no.

      ASSIGN
         V_BelegKopf_AuftragsArt_Info:HIDDEN IN FRAME F-Main = yes
         V_BelegKopf_AuftragsArt_Info:COL IN FRAME F-Main  = 26.5
         V_BelegKopf_AuftragsArt_Info:WIDTH IN FRAME F-Main = 34.

      ASSIGN
         V_BelegKopf_BelegDatum_Info:HIDDEN IN FRAME F-Main = yes.

    END.  /* Kurzinfo Layout Case */

  END CASE.
END PROCEDURE.  /* CURRENT-WINDOW-layouts */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION luNewCreatedOrder V-table-Win 
FUNCTION luNewCreatedOrder returns logical
  (  ) :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* return if the Order was created and called from uvbauf00.w                 */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/* UMO# MOu Auftragsschnellerfassung (aus VUR): Fenster aktualisieren         */
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

&IF LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN

/* Variables -----------------------------------------------------------------*/
/* lNewCreatedOrder  function return value                                    */
/*----------------------------------------------------------------------------*/

  define variable lNewCreatedOrder as logical init no no-undo.

  define variable  i           as integer init 2 no-undo.

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

  StackTrace:
  do while program-name(i) <> ?:

    if program-name(i) matches '*callDoc*uvbauf00.w*':U then
    do:
      lNewCreatedOrder = yes.
      leave StackTrace.
    end.

    i = i + 1.

  end.

  return lNewCreatedOrder.

&ENDIF

end function. /* luNewCreatedOrder */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION pa_lUISvcObjectState V-table-Win 
FUNCTION pa_lUISvcObjectState returns logical
  (pcStateCode as character):
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

/* Buffers -------------------------------------------------------------------*/

define buffer bV_BelegKopf for V_BelegKopf.  

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

case pcStateCode:

  /* --> UMO#CA2016-05-003a Mohamed Ouadi Rahmenauftrag: Funktion 'weitere Kunden' für CA freigeben */
  &IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
    when 'uSCShowFurtherCustomers':U then
      &IF LOOKUP("U_CE":U,"{&PA-OPTIONEN}":U) > 0
        OR LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN
        return yes.
      &ELSE
        return no.
      &ENDIF
  &ENDIF
  /* <-- UMO#CA2016-05-003a Mohamed Ouadi Rahmenauftrag: Funktion 'weitere Kunden' für CA freigeben */

  /* --> UMO#CA2016-03-001 PWa Gutschriftsverfahren */
  &IF LOOKUP("U_CA":U,"{&PA-OPTIONEN}":U) > 0 &THEN

    when 'upaSCGSA':U then
    do:

      if available V_BelegKopf
        and (V_BelegKopf.uGSAStatus       = {&uCA_CreditMemoState_Archived}
               or V_BelegKopf.uGSAStatus  = {&uCA_CreditMemoState_Posted}) then
        return no.
      else
        return yes.

    end.

    when 'upaSCGSAFreigegeben':U then
    do:

      if available V_BelegKopf
        and V_BelegKopf.uGSAStatus       = {&uCA_CreditMemoState_Released} then
        return yes.
      else
        return no.

    end.

  &ENDIF
  /* <-- UMO#CA2016-03-001 PWa Gutschriftsverfahren */

  /* --> UMO#CM2017-05-001 tri Versandstückliste */
  &IF LOOKUP("U_CM":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  when 'uCanUpdateShippingList':U then do:

    return can-find(first V_BelegPos
                      where V_BelegPos.Firma       = V_BelegKopf.Firma
                        and V_BelegPos.Belegart    = V_BelegKopf.Belegart
                        and V_BelegPos.ReferenzNr  = V_BelegKopf.ReferenzNr
                        and V_BelegPos.uCM_Versand = yes).

  end.
  &ENDIF
  /* <-- UMO#CM2017-05-001 tri Versandstückliste */

  &IF LOOKUP("U_CW":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  when 'upaSCCanCreateReservation':U then do:

     return(    available V_BelegKopf
            and V_BelegKopf.offen = yes
            and can-find(first V_BelegPos
                          where V_BelegPos.Firma       = V_BelegKopf.Firma
                            and V_BelegPos.Belegart    = V_BelegKopf.Belegart
                            and V_BelegPos.ReferenzNr  = V_BelegKopf.ReferenzNr
                            and V_BelegPos.offen       = yes)).

  end.
  &ENDIF

  when 'paSCisDocumentOpen':U then

    return(    available V_BelegKopf
           and V_BelegKopf.offen = yes).

  when 'paSCcanModifyFinalInvoiceDate':U then

    return (    available V_BelegKopf
            and V_BelegKopf.offen = yes
            and not can-find (first VBT_DocPaymentLines
                              where VBT_DocPaymentLines.Owning_Obj = V_BelegKopf.Origin_Obj)).           


  &IF defined(pAXeINVOICE-FeatureFlag) = 1 &THEN
  
    when 'paSCCanSendEInvoice':U then

      return vert.fakt.cls.VFCEInvoiceSvc:prpoInstance:lCanSendEInvoice(buffer V_BelegKopf).

    when 'paSCisVisibleEInvoice':U then

      return vert.fakt.cls.VFCEInvoiceSvc:prpoInstance:lIsVisibleMenuItemEInvoice().

    when 'paSCisEInvoiceStatusNotSent':U then

      return if not available V_BelegKopf then 
               yes
             else 
               not vert.fakt.cls.VFCEInvoiceSvc:prpoInstance:lEInvoiceStatusPreventsModifyingDocument
                     (V_BelegKopf.V_BelegKopf_Obj,
                      V_BelegKopf.BelegArt).

  &ENDIF

  when 'paSCPurchaseOrdersPossible':U then

    return (    available V_BelegKopf
            and V_BelegKopf.BelegArt   = 'U':U
            and V_BelegKopf.offen      = yes
            and V_BelegKopf.MRPRelease = yes
            and adm.config.cls.DCCAppConfigSvc:prpoInstance:lParameterValue
                  ('VU_CreatePOFromOrder':U) = yes).

  when 'paSCisAustrianLocalization':U then

    return (pACConnectionSvc:prpcLocalization = 'A':U).

  when 'paSCisInvoiceComplete':U then

    return (    available V_BelegKopf
            and V_BelegKopf.gedruckt = yes
            and (   V_BelegKopf.BelegArt = 'G':U
                 or (    V_BelegKopf.Belegart = 'R':U
                     and can-find (first V_BelegPos
                                     where V_BelegPos.Firma      = V_BelegKopf.Firma
                                       and V_BelegPos.BelegArt   = V_BelegKopf.BelegArt
                                       and V_BelegPos.ReferenzNr = V_BelegKopf.ReferenzNr
                                       and V_BelegPos.Satzart    = 'A':U)))).

  &IF LOOKUP("V_ANZ","{&PA-OPTIONEN}") > 0 &THEN

    when 'paSCisPaymentSchedulePossible':U then

      return (    available V_BelegKopf

              /* --> UMO#WH2015-07-011 LM2 Sammelstreckenfaktura*/
              &IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
              and not can-find(first V_BelegPos
                                 where V_BelegPos.Firma            = V_BelegKopf.Firma
                                   and V_BelegPos.BelegArt         = V_BelegKopf.BelegArt
                                   and V_BelegPos.ReferenzNr       = V_BelegKopf.ReferenzNr
                                   and V_BelegPos.uCI_Vertriebsweg = {&uCI_VertriebswegStrecke})).
              &ELSE /* original */
              and V_BelegKopf.Strecke = no).
              &ENDIF
              /* <-- UMO#WH2015-07-011 LM2 Sammelstreckenfaktura */

  &ENDIF

  when 'paSCSparePartDocument':U then

    &IF   LOOKUP("U_CM","{&PA-OPTIONEN}") > 0 
      AND LOOKUP("P_","{&PA-MODULE}")     > 0 &THEN

      return yes.

    &ELSE

      &IF  (    LOOKUP("VS","{&PA-MODULE}")        > 0
            AND LOOKUP("VS_CALL","{&PA-OPTIONEN}") > 0)
        or (    LOOKUP("MS","{&PA-MODULE}")        > 0
            AND LOOKUP("MS_PROD","{&PA-OPTIONEN}") > 0) &THEN

          return (    available V_BelegKopf
                  and vert.base.cls.VBCSalesDocSvc:prpoInstance:lIsDocumentForSpareParts
                        (V_BelegKopf.Belegart,
                         V_BelegKopf.Origin_Obj)).

      &ELSE

        return no.

      &ENDIF

    &ENDIF

  when 'paSCisProFormaForShipDocToWH':U then
  do:

    run get-attribute in this-procedure ('IsProFormaForShipDocToWH':U).
    return (return-value = 'yes':U).

  end. /* when 'paSCisProFormaForShipDocToWH':U */

  when 'paSCPisInvoiceCopy':U then
    return (   pACConnectionSvc:prpcLocalization <> 'P':U
            or     available V_BelegKopf
               and V_BelegKopf.BelegArt           = 'R':U).

  when 'paSCisUpdateTaxationAllowed':U then
    return (   pACConnectionSvc:prpcLocalization <> 'P':U
            or     available V_BelegKopf          = yes
               and V_BelegKopf.offen              = yes
            and   (available V_BelegKopf = yes
               and not vert.fakt.cls.VFCEInvoiceSvc:prpoInstance:lEInvoiceStatusPreventsModifyingDocument(
                         V_BelegKopf.V_BelegKopf_Obj,
                         V_BelegKopf.BelegArt))).

  when 'paSCisFNATransferAllowed':U then
    return (    available V_BelegKopf          = yes
            and V_BelegKopf.Belegfreigabe      = yes
            and V_BelegKopf.offen              = yes
            and not (stamm.base.cls.SBCBusProcTransmissionSvc:prpoInstance:iGetTransmissionState
                       (V_BelegKopf.V_BelegKopf_Obj) = {&pa_SB_TransState_released})).

  &IF LOOKUP("U_CI":U,"{&PA-OPTIONEN}":U) > 0 &THEN
  when 'paSCisuQuoteVersioning':U then

      return adm.config.cls.DCCAppConfigSvc:prpoInstance:lParameterValue('UCI_QuoteVersioning':U).
  &ENDIF

  when 'paSCisHParamsEditable':U then

    if pACConnectionSvc:prpcLocalization = 'H':U then

      return (    available V_BelegKopf
              and vert.base.cls.VBCPolandHungarySpecialsSvc:prpoInstance:lIsAForeignNonRegularInvoice_H_P(buffer V_BelegKopf)
              and V_BelegKopf.gedruckt = no).

  when 'paSC_H_isKOBAKRelevant':U then

    if pACConnectionSvc:prpcLocalization = 'H':U then

      return (    available V_BelegKopf
              and can-find ( first SBT_H_KOBAK_Doc
                             where SBT_H_KOBAK_Doc.Owning_Obj = V_BelegKopf.V_BelegKopf_Obj)).

  when 'paSC_H_canChangeKOBAKStateToManual':U then
    return     pACConnectionSvc:prpcLocalization = 'H':U
           and can-find(SBT_H_KOBAK_Doc
                          where SBT_H_KOBAK_Doc.Owning_Obj    = V_BelegKopf.V_BelegKopf_Obj
                            and SBT_H_KOBAK_Doc.InvoiceStatus = 3).

  when 'paSC_H_canExportKobakXMLs':U then
    return     pACConnectionSvc:prpcLocalization = 'H':U
           and can-find(SBT_H_KOBAK_Doc
                          where SBT_H_KOBAK_Doc.Owning_Obj = V_BelegKopf.V_BelegKopf_Obj).

  when 'paSC_I_isInSDIProcess':U then
      return (    available V_BelegKopf
              and not stamm.base.cls.SBCLocalizationITSvc:prpoInstance:lisDocumentBlockedBySDI(V_BelegKopf.V_BelegKopf_Obj)).

  when 'paSC_I_SdIRecordAvailable':U then
        return can-find(first SBM_I_eInvoicing
                          where SBM_I_eInvoicing.Owning_Obj = V_BelegKopf.V_BelegKopf_Obj).

  when 'paSCisTDLPossible':U then
    return     available V_BelegKopf
           and basis.inwb.cls.BOCLogisticsInterfaceSvc:prpoInstance:lHasValidConfiguration
                 (V_BelegKopf.BelegArt,
                  V_BelegKopf.VersandArt)
           and not vert.fakt.cls.VFCPostBillingSvc:prpoInstance:lDocIsRGGeneratedFromVPB(V_BelegKopf.V_BelegKopf_Obj).

  when 'paSCisShippingExists':U then
    return     available V_BelegKopf
           and basis.inwb.cls.BOCLogisticsInterfaceSvc:prpoInstance:lIsShipmentExisting
                 (V_BelegKopf.V_BelegKopf_Obj).

  when 'paSCisDropShippingExists':U then
    return     available V_BelegKopf
           and stamm.base.cls.SBCDropShippingSvc:prpoInstance:lDropShippingInfoExisting(V_BelegKopf.V_BelegKopf_Obj).
  
  &IF lookup("M_ATLAS","{&PA-OPTIONEN}") > 0 &THEN
    when 'paSCisAtlasRequestExportValid':U then
      return giCustDeclState = {&pa_M_AtlasDeclared}.
  
    when 'paSCisAtlasRequestAllowed':U then
      return vert.fakt.cls.VFCAtlasSvc:prpoInstance:lRequestExport().

    when 'paSCisConnected':U then
      return     available V_BelegKopf 
             and not (   can-find(first bV_BelegKopf
                                    where bV_BelegKopf.Firma           = {firma/vbelegko.fir pACConnectionSvc:prpcCompany}
                                      and bV_BelegKopf.Origin_Obj      = V_Belegkopf.V_BelegKopf_Obj
                                      and bV_BelegKopf.BelegArt        = 'R':U)
                      or can-find(first bV_BelegKopf
                                    where bV_BelegKopf.Firma           = {firma/vbelegko.fir pACConnectionSvc:prpcCompany}
                                      and bV_BelegKopf.Origin_Obj      = V_Belegkopf.V_BelegKopf_Obj
                                      and bV_BelegKopf.BelegArt        = 'VFP':U)).

    when 'paSCisCustDeclarationPossible':U then
    do:

      run request-attribute (this-procedure, 'container-source':U, 'pa-RunMode':U).

      if return-value matches '*Info':U then

        return no.

      else

        return yes.

    end. /* when 'paSCisCustDeclarationPossible':U */
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

