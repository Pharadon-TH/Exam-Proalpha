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
/* Name   : Template.p                                                        */
/* Product: STAMM - Übergreifende Stammdaten                                  */
/* Module : KERN - Kernfunktionen (alter Standard)                            */
/*                                                                            */
/* Created: 9.3 as of 19.09.2024/nop                                          */
/* Current: @PAVERSION@ as of @PADATE@/@PALASTAUTHOR@                         */
/*                                                                            */
/*----------------------------------------------------------------------------*/
/* DESCRIPTION                                                                */
/*----------------------------------------------------------------------------*/
/*                                                                            */
/* Änderung zwischen zwei Preislisten (Job-Programm)                          */
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

&GLOBAL-DEFINE pa-Autor             Michael Schmidt
&GLOBAL-DEFINE pa-Version           @PAVERSION@
&GLOBAL-DEFINE pa-Datum             @PADATE@
&GLOBAL-DEFINE pa-Letzter           @PALASTAUTHOR@

&GLOBAL-DEFINE pa-GenVersion       UIB
&GLOBAL-DEFINE pa-ProgrammTyp      Procedure
&GLOBAL-DEFINE pa-Template         adm/template/proc/dt_pro00.p
&GLOBAL-DEFINE pa-TemplateVersion  1.01

&GLOBAL-DEFINE pa-XBasisName       template_p

/*----------------------------------------------------------------------------*/
/* Definitions                                                                */
/*----------------------------------------------------------------------------*/

/* Parameters ----------------------------------------------------------------*/

/* Globals -------------------------------------------------------------------*/

{adm/template/incl/dt_job00.df}

/* SCOPEDs -------------------------------------------------------------------*/

/* Variables -----------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/* Buffers -------------------------------------------------------------------*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



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
         HEIGHT             = 6.95
         WIDTH              = 50.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure
/* ************************* Included-Libraries *********************** */

{basis/job/incl/bj_job00.lib}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME





&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure


/* ***************************  Main Block  *************************** */

/*----------------------------------------------------------------------------*/
/* Processing                                                                 */
/*----------------------------------------------------------------------------*/

/* Common pre-processing                                                      */

Main: do on error undo, leave:

  /* Extract parameters                                                         */

  {adm/incl/d__par01.if
     &Parameter      = "..."
     &ParameterListe = "pc_ParamListe"
     &Variable1      = "..."
  }

  /* Start processing                                                           */

  Processing:
  for each ...
    on error undo, throw:

    /* Show status and check for job canceling                                  */

    {adm/template/incl/dt_job11.if
      &AbbruchFkt = "leave Processing."
    }

  end.

  /*-------------------------------------------------------------------------*/
  /* gebe den Status zurück                                                  */
  /*-------------------------------------------------------------------------*/

  {adm/template/incl/dt_job07.if}

end. /* Main */

/*---------------------------------------------------------------------------*/
/* Ende s_vpae01.p                                                           */
/*---------------------------------------------------------------------------*/

{adm/template/incl/dt_job00.if}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
