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
/* Name   : xs_exp00.w                                                        */
/* Product: X            - Individualanpassungen extern                       */
/* Module : STAMM        - Übergreifende Stammdaten                           */
/*                                                                            */
/* Created: 9.5 as of 11.06.2026/thongdi_p                                    */
/* Current: @PAVERSION@ as of @PADATE@/@PALASTAUTHOR@                         */
/*                                                                            */
/*----------------------------------------------------------------------------*/
/* DESCRIPTION                                                                */
/*----------------------------------------------------------------------------*/
/*                                                                            */
/* Dialog For S_Kunde (Vorlauf)                                               */
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
&GLOBAL-DEFINE pa-XBasisName       xs_exp00_w
&GLOBAL-DEFINE pa-NameSpace        2.10
&GLOBAL-DEFINE pa-ZielProgramm 'bjvjob02.p#XSCExportPart-CustomerJob':U

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

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS giCustomer Btn_Start Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS giCustomer 

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
     SIZE 27 BY 1.5.

DEFINE BUTTON Btn_Start AUTO-GO 
     LABEL "Export":T8 
     SIZE 27 BY 1.5.

DEFINE VARIABLE giCustomer LIKE S_Kunde.Kunde
     LABEL "Customer":R18 
     VIEW-AS FILL-IN 
     SIZE 46.33 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     giCustomer AT ROW 1.5 COL 13.67 COLON-ALIGNED HELP
          ""
          LABEL "Customer":R18
     Btn_Start AT ROW 3 COL 4
     Btn_Cancel AT ROW 3 COL 42.5
     SPACE(3.49) SKIP(0.53)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Export Part-Customer":T60
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

/* SETTINGS FOR FILL-IN giCustomer IN FRAME Dialog-Frame
   LIKE = basis.S_Kunde.Kunde EXP-LABEL EXP-SIZE                        */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Export Part-Customer */
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


&Scoped-define SELF-NAME giCustomer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL giCustomer Dialog-Frame
ON LEAVE OF giCustomer IN FRAME Dialog-Frame /* Customer */
do:
  {adm/template/incl/dt_uit00.if
     &UserExitName = "ON_LEAVE_OF_Dialog-Frame"}


  {adm/template/incl/dt_uit01.if
     &UserExitName = "ON_LEAVE_OF_Dialog-Frame"}
end.

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
                   /* pcKey     */ 'Customer':U,
                   /* pcValue   */ giCustomer ).

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

