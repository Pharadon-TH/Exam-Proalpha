&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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
/* Name   : xs_ads99.w                                                        */
/* Product: X            - Individualanpassungen extern                       */
/* Module : STAMM        - Übergreifende Stammdaten                           */
/*                                                                            */
/* Created: 9.5 as of 05.06.2026/thongdi_p                                    */
/* Current: @PAVERSION@ as of @PADATE@/@PALASTAUTHOR@                         */
/*                                                                            */
/*----------------------------------------------------------------------------*/
/* DESCRIPTION                                                                */
/*----------------------------------------------------------------------------*/
/*                                                                            */
/* Dialog for table Änderung der Selektion in Artikel (Vorlauf)               */
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
&GLOBAL-DEFINE pa-XBasisName       xs_ads99_w
&GLOBAL-DEFINE pa-NameSpace        2.10
&GLOBAL-DEFINE pa-ZielProgramm 'xsvads90.p':U

/* Parameters ----------------------------------------------------------------*/

/* Globals -------------------------------------------------------------------*/

{adm/template/incl/dt_dlg01.df}

/* SCOPEDs -------------------------------------------------------------------*/


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

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Prefix Number1 Number2 Operation tDate ~
ArtikelFrom ArtikelTo Btn_Start Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS Prefix Number1 Number2 Operation tDate ~
ArtikelFrom ArtikelTo c_von c_bis 

/* Custom List Definitions                                              */
/* pa-YearFields,pa-ResetFields,List-3,List-4,List-5,List-6             */
&Scoped-define pa-ResetFields Dialog-Frame 
&Scoped-define List-6 Dialog-Frame 

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
     SIZE 12 BY 1.

DEFINE BUTTON Btn_Start AUTO-GO 
     LABEL "OK":T8 
     SIZE 12 BY 1.

DEFINE VARIABLE ArtikelFrom AS CHARACTER FORMAT "X(20)":U 
     LABEL "Artikel" 
     VIEW-AS FILL-IN 
     SIZE 26.5 BY 1 NO-UNDO.

DEFINE VARIABLE ArtikelTo AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 26.5 BY 1 NO-UNDO.

DEFINE VARIABLE c_bis AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE c_von AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE Number1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Number" 
     VIEW-AS FILL-IN 
     SIZE 26.5 BY 1 NO-UNDO.

DEFINE VARIABLE Number2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26.5 BY 1 NO-UNDO.

DEFINE VARIABLE Operation AS CHARACTER FORMAT "X(256)":U 
     LABEL "Operation" 
     VIEW-AS FILL-IN 
     SIZE 26.5 BY 1 NO-UNDO.

DEFINE VARIABLE Prefix AS CHARACTER FORMAT "X(256)":U 
     LABEL "PREFIX" 
     VIEW-AS FILL-IN 
     SIZE 26.5 BY 1 NO-UNDO.

DEFINE VARIABLE tDate AS DATE FORMAT "99/99/9999":U 
     LABEL "Date" 
     VIEW-AS FILL-IN 
     SIZE 26.5 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     Prefix AT ROW 2 COL 12 COLON-ALIGNED
     Number1 AT ROW 3.25 COL 12 COLON-ALIGNED
     Number2 AT ROW 3.25 COL 43.5 COLON-ALIGNED NO-LABEL
     Operation AT ROW 4.5 COL 12 COLON-ALIGNED
     tDate AT ROW 5.75 COL 12 COLON-ALIGNED
     ArtikelFrom AT ROW 8.5 COL 12 COLON-ALIGNED
     ArtikelTo AT ROW 8.5 COL 43.5 COLON-ALIGNED NO-LABEL
     Btn_Start AT ROW 10.5 COL 5.5
     Btn_Cancel AT ROW 10.5 COL 19.5
     c_von AT ROW 7.5 COL 21.5 COLON-ALIGNED NO-LABEL
     c_bis AT ROW 7.5 COL 53.5 COLON-ALIGNED NO-LABEL
     SPACE(15.16) SKIP(4.61)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Anderung der Selektion":T60
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
   FRAME-NAME 2 6 L-To-R                                                */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c_bis IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c_von IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Anderung der Selektion */
DO:
  {adm/template/incl/dt_uit00.if
     &UserExitName = "ON_WINDOW-CLOSE_OF_FRAME"}

  {adm/template/incl/dt_dlg09.if}

  {adm/template/incl/dt_uit01.if
     &UserExitName = "ON_WINDOW-CLOSE_OF_FRAME"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Start
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Start Dialog-Frame
ON CHOOSE OF Btn_Start IN FRAME Dialog-Frame /* OK */
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

{adm/incl/d__par00.if
&Parameter      = "pcPrefix"           
&ParameterListe = "pcParamliste"        
&Variable1      = "Prefix"           
}

{adm/incl/d__par00.if
&Parameter      = "pcNumber"           
&ParameterListe = "pcParamliste"        
&Variable1      = "Number1"
&Variable2      = "Number2"           
}

{adm/incl/d__par00.if
&Parameter      = "pcOperation"           
&ParameterListe = "pcParamliste"        
&Variable1      = "Operation"          
}

{adm/incl/d__par00.if
&Parameter      = "pcDate"           
&ParameterListe = "pcParamliste"        
&Variable1      = "tDate"          
}

{adm/incl/d__par00.if
&Parameter      = "pcArtikel"           
&ParameterListe = "pcParamliste"        
&Variable1      = "ArtikelFrom" 
&Variable2      = "ArtikelTo"          
}

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

