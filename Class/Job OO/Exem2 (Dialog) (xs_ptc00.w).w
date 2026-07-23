&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          basis            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DECLARATIONS Dialog-Frame 

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update Information" Dialog-Frame _INLINE
/* Actions: ? ? ? ? adm/support/proc/ds_pa_01.w */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/******************************************************************************/
/* @COPYRIGHT@                                                                */
/* Project: Proalpha                                                          */
/*                                                                            */
/* Name   : xs_ptc00.w                                                        */
/* Product: X            - Individualanpassungen extern                       */
/* Module : STAMM        - Übergreifende Stammdaten                           */
/*                                                                            */
/* Created: 9.5 as of 15.06.2026/thongdi_p                                    */
/* Current: @PAVERSION@ as of @PADATE@/@PALASTAUTHOR@                         */
/*                                                                            */
/*----------------------------------------------------------------------------*/
/* DESCRIPTION                                                                */
/*----------------------------------------------------------------------------*/
/*                                                                            */
/* Dialog for xs_ptc00.w (Vorlauf)                                            */
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

create widget-pool.

/* Procedure Information -----------------------------------------------------*/

&GLOBAL-DEFINE pa-Autor            thongdi_p
&GLOBAL-DEFINE pa-Version          @PAVERSION@
&GLOBAL-DEFINE pa-Datum            @PADATE@
&GLOBAL-DEFINE pa-Letzter          @PALASTAUTHOR@

&GLOBAL-DEFINE pa-GenVersion       UIB
&GLOBAL-DEFINE pa-ProgrammTyp      PrintDialog
&GLOBAL-DEFINE pa-Template         adm/template/dt_dlg02.w
&GLOBAL-DEFINE pa-TemplateVersion  3.01
&GLOBAL-DEFINE pa-XBasisName       xs_ptc00_w
&GLOBAL-DEFINE pa-NameSpace        2.10
&GLOBAL-DEFINE pa-ZielProgramm 'bjvjob02.p#XSCExportPartsJob':U

/* Parameters ----------------------------------------------------------------*/

/* Globals -------------------------------------------------------------------*/

{adm/template/incl/dt_dlg01.df}

/* SCOPEDs -------------------------------------------------------------------*/

&GLOBAL-DEFINE pa-WflArea
&GLOBAL-DEFINE pa-WflCompany

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES S_Artikel

/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define QUERY-STRING-Dialog-Frame FOR EACH S_Artikel SHARE-LOCK
&Scoped-define OPEN-QUERY-Dialog-Frame OPEN QUERY Dialog-Frame FOR EACH S_Artikel SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-Dialog-Frame S_Artikel
&Scoped-define FIRST-TABLE-IN-QUERY-Dialog-Frame S_Artikel


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Artikel_min Artikel_max ArtikelArt_min ~
ArtikelArt_max Check_box Btn_Start Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS Artikel_min Artikel_max ArtikelArt_min ~
ArtikelArt_max Check_box c_bis c_von 

/* Custom List Definitions                                              */
/* pa-YearFields,pa-ResetFields,List-3,List-4,List-5,List-6             */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "InfoFields" Dialog-Frame _INLINE
/* Actions: ? ? ? ? adm/support/proc/ds_inf01.p */
/* STRUCTURED-DATA
<Build-Information>
1.02
</Build-Information>
<Constants></Constants>
<InfoFields></InfoFields> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Dynamic InfoFields" Dialog-Frame _INLINE
/* Actions: ? ? ? ? adm/support/proc/ds_viw09.p */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "FieldDefinitions" Dialog-Frame _INLINE
/* Actions: ? ? ? ? adm/support/proc/ds_dlg01.p */
/* STRUCTURED-DATA
<DATA></DATA>
<FRAME>
****/
define frame f_dummy
with side-labels width 255 stream-io.
/****
</FRAME> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Skin Client Support" Dialog-Frame _INLINE
/* Actions: ? ? ? ? adm/support/proc/ds_skc00.p */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel":T8 
     SIZE 12 BY 1 DROP-TARGET.

DEFINE BUTTON Btn_Start AUTO-GO 
     LABEL "Export":T8 
     SIZE 12 BY 1.

DEFINE VARIABLE Artikel_max LIKE S_Artikel.Artikel
     VIEW-AS FILL-IN 
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE Artikel_min LIKE S_Artikel.Artikel
     LABEL "Part":R18 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE ArtikelArt_max AS INTEGER FORMAT "z9":U INITIAL 99 
     VIEW-AS FILL-IN 
     SIZE 4 BY 1 NO-UNDO.

DEFINE VARIABLE ArtikelArt_min AS INTEGER FORMAT "z9":U INITIAL 0 
     LABEL "PartType":R18 
     VIEW-AS FILL-IN 
     SIZE 4 BY 1 NO-UNDO.

DEFINE VARIABLE c_bis AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE c_von AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE Check_box AS LOGICAL INITIAL no 
     LABEL "Relation with Customer" 
     VIEW-AS TOGGLE-BOX
     SIZE 25.5 BY .79 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Dialog-Frame FOR 
      S_Artikel SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     Artikel_min AT ROW 3 COL 13 COLON-ALIGNED HELP
          ""
          LABEL "Part":R18
     Artikel_max AT ROW 3 COL 51 COLON-ALIGNED HELP
          "" NO-LABEL
     ArtikelArt_min AT ROW 4 COL 13 COLON-ALIGNED
     ArtikelArt_max AT ROW 4 COL 51 COLON-ALIGNED NO-LABEL
     Check_box AT ROW 5.5 COL 53.5
     Btn_Start AT ROW 7 COL 5.5
     Btn_Cancel AT ROW 7 COL 20.5
     c_bis AT ROW 1.5 COL 51 COLON-ALIGNED NO-LABEL
     c_von AT ROW 1.58 COL 13 COLON-ALIGNED NO-LABEL
     SPACE(60.32) SKIP(6.61)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Export Parts":T60
         DEFAULT-BUTTON Btn_Start CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,DB-Fields
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Dialog-Frame 
/* ************************* Included-Libraries *********************** */

{adm/method/incl/dm_dlg00.lib}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   FRAME-NAME L-To-R                                                    */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN Artikel_max IN FRAME Dialog-Frame
   LIKE = basis.S_Artikel.Artikel EXP-HELP EXP-SIZE                     */
/* SETTINGS FOR FILL-IN Artikel_min IN FRAME Dialog-Frame
   LIKE = basis.S_Artikel.Artikel EXP-LABEL EXP-HELP EXP-SIZE           */
/* SETTINGS FOR FILL-IN c_bis IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c_von IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX Dialog-Frame
/* Query rebuild information for DIALOG-BOX Dialog-Frame
     _TblList          = "basis.S_Artikel"
     _Options          = "SHARE-LOCK"
     _Query            is OPENED
*/  /* DIALOG-BOX Dialog-Frame */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Export Parts */
DO:
  {adm/template/incl/dt_uit00.if
     &UserExitName = "ON_WINDOW-CLOSE_OF_FRAME"}

  {adm/template/incl/dt_dlg09.if}

  {adm/template/incl/dt_uit01.if
     &UserExitName = "ON_WINDOW-CLOSE_OF_FRAME"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Artikel_min
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Artikel_min Dialog-Frame
ON leave OF Artikel_min IN FRAME Dialog-Frame /* Part */
DO:
  {adm/template/incl/dt_uit00.if
     &UserExitName = "ON_LEAVE_OF_Artikel_min"}
          
  {adm/template/incl/dt_dlg00.if &MAX-FELD = "Artikel_max"}

  {adm/template/incl/dt_uit01.if
     &UserExitName = "ON_LEAVE_OF_Artikel_min"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ArtikelArt_min
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ArtikelArt_min Dialog-Frame
ON leave OF ArtikelArt_min IN FRAME Dialog-Frame /* PartType */
DO:
  {adm/template/incl/dt_uit00.if
     &UserExitName = "ON_LEAVE_OF_ArtikelArt_min"}

  {adm/template/incl/dt_dlg00.if &MAX-FELD = "ArtikelArt_max"}
  
  
  {adm/template/incl/dt_uit01.if
     &UserExitName = "ON_LEAVE_OF_ArtikelArt_min"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Start
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Start Dialog-Frame
ON CHOOSE OF Btn_Start IN FRAME Dialog-Frame /* Export */
DO:
  {adm/template/incl/dt_uit00.if
     &UserExitName = "ON_CHOOSE_OF_Btn_Start"}

  {adm/template/incl/dt_btn01.if}

  {adm/template/incl/dt_uit01.if
     &UserExitName = "ON_CHOOSE_OF_Btn_Start"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

{adm/template/incl/dt_dlg00.i}

run initialize in this-procedure.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.

  /* Wait-for go of frame                                                     */

  {adm/template/incl/dt_dlg11.if}

END.
RUN disable_UI.


{adm/template/incl/dt_dlg08.if}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignData Dialog-Frame  adm/support/proc/ds_dlg10.p
PROCEDURE assignData :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Assign screen values to parameter string                                   */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* pcParamListe  List with data in Proalpha String format                     */
/*                                                                            */
/*----------------------------------------------------------------------------*/

define       output parameter pcParamListe as character     no-undo.

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Assign Screen Buffer                                                       */

{adm/template/incl/dt_dlg12.if}

/* Assign Default Values                                                      */


pcParamListe = adm.method.cls.DMCParameterStringSvc:cWriteValue
                 ( /* pcPString */ pcParamListe,
                   /* pcKey     */ 'Partmin':U,
                   /* pcValue   */ Artikel_min ).

                   
pcParamListe = adm.method.cls.DMCParameterStringSvc:cWriteValue
                 ( /* pcPString */ pcParamListe,
                   /* pcKey     */ 'Partmax':U,
                   /* pcValue   */ Artikel_max ).        
                   
                   
pcParamListe = adm.method.cls.DMCParameterStringSvc:cWriteValue
                 ( /* pcPString */ pcParamListe,
                   /* pcKey     */ 'PartTypemin':U,
                   /* pcValue   */ ArtikelArt_min ).

                   
pcParamListe = adm.method.cls.DMCParameterStringSvc:cWriteValue
                 ( /* pcPString */ pcParamListe,
                   /* pcKey     */ 'PartTypemax':U,
                   /* pcValue   */ ArtikelArt_max ).  

                   
pcParamListe = adm.method.cls.DMCParameterStringSvc:cWriteValue
                 ( /* pcPString */ pcParamListe,
                   /* pcKey     */ 'Checkbox':U,
                   /* pcValue   */ Check_box ).                                      

                                                                   
/* Default Code                                                               */

{adm/template/incl/dt_dlg07.if}

return.

end procedure. /* assignData */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame 
PROCEDURE disable_UI :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* DISABLE the User Interface                                                 */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/* Here we clean-up the user-interface by deleting dynamic widgets we have    */
/* created and/or hide frames.  This procedure is usually called when we are  */
/* ready to "clean-up" after running                                          */
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

{adm/template/incl/dt_dlg06.if}

end procedure. /* disable_UI */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame 
PROCEDURE enable_UI :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* ENABLE the User Interface                                                  */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/* Here we display/view/enable the widgets in the user-interface.             */
/* In addition, OPEN all queries associated with each FRAME and BROWSE.       */
/* These statements here are based on the "Other Settings" section of the     */
/* widget Property Sheets.                                                    */
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

{adm/template/incl/dt_dlg03.if}

end procedure. /* enable_UI */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initialize Dialog-Frame  adm/support/proc/ds_dlg02.p
PROCEDURE initialize :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Initialization                                                             */
/*                                                                            */
/* Notes ---------------------------------------------------------------------*/
/*                                                                            */
/* - Initialization of variables                                              */
/* - Assign format                                                            */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* <none>                                                                     */
/*                                                                            */
/*----------------------------------------------------------------------------*/

/* Variables -----------------------------------------------------------------*/
/* lExternalValueAvailable     Flag                                           */
/*----------------------------------------------------------------------------*/

define variable lExternalValueAvailable as logical       no-undo.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Initialize maximum values (use external data, if available)                */

/*{adm/incl/d__par01.if                                    */
/*  &ParameterListe = "pc_Options"                         */
/*  &Parameter      = "Artikel"                            */
/*  &Variable1      = "Artikel_min"                        */
/*  &Variable2      = "Artikel_max"                        */
/*  &Flag           = "lExternalValueAvailable"            */
/*}                                                        */
/*                                                         */
/*if not lExternalValueAvailable then                      */
/*do:                                                      */
/*  {adm/template/incl/dt_dlg04.if                         */
/*    &Variable = "Artikel_min"                            */
/*  }                                                      */
/*  find last S_Artikel                                    */
/*    where S_Artikel.Firma = {firma/sartikel.fir pa-Firma}*/
/*    use-index Main                                       */
/*    no-lock no-error.                                    */
/*  if available S_Artikel then                            */
/*    Artikel_max = S_Artikel.Artikel.                     */
/*end. /* not lExternalValueAvailable */                   */


/* Copy setup from dummy frame                                                */



/* Default Code                                                               */

{adm/template/incl/dt_dlg01.if}

end procedure. /* initialize */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE process-data Dialog-Frame  adm/support/proc/ds_dlg04.p
PROCEDURE process-data :
/* Description ---------------------------------------------------------------*/
/*                                                                            */
/* Save data into parameter string and start processing                       */
/*                                                                            */
/* Parameters ----------------------------------------------------------------*/
/*                                                                            */
/* <none>                                                                     */
/*                                                                            */
/*----------------------------------------------------------------------------*/

/* Variables -----------------------------------------------------------------*/
/* c_ParamListe        Parameter string                                       */
/* c_Options           Options of target program                              */
/* c_ZielProgramm      Target Program                                         */
/*----------------------------------------------------------------------------*/

define variable c_ParamListe   as character     no-undo.
define variable c_Options      as character     no-undo.
define variable c_ZielProgramm as character     no-undo.

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

run assignData in this-procedure (output c_ParamListe).

{adm/template/incl/dt_dlg02.if}

end procedure. /* process-data */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

