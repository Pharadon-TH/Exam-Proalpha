&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update Information" Include _INLINE
/* Actions: ? ? ? ? adm/support/proc/ds_pa_01.w */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include
/******************************************************************************/
/* @COPYRIGHT@                                                                */
/* Project: proALPHA                                                          */
/*                                                                            */
/* Name   : b__alp92.cdf                                                      */
/* Product: X            - Individualanpassungen extern                       */
/* Module : Basis/KERN   - Kernbereich                                        */
/*                                                                            */
/* Created: 52 as of 01.01.2010/Versioncontrol                                */
/* Current: @PAVERSION@ as of @PADATE@/@PALASTAUTHOR@                         */
/*                                                                            */
/*----------------------------------------------------------------------------*/
/* DESCRIPTION                                                                */
/*----------------------------------------------------------------------------*/
/*                                                                            */
/* Definition of USER-EXITS Partner                                           */
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

/*----------------------------------------------------------------------------*/
/* Compilerconstants  Partner                                                 */
/*----------------------------------------------------------------------------*/

{basis/incl/b__alp9x.cdf}

/*----------------------------------------------------------------------------*/
/* Compilerconstants Customer                                                 */
/*----------------------------------------------------------------------------*/

{basis/incl/b__alp9y.cdf}

/*----------------------------------------------------------------------------*/
/* Internal Include always empty on Customer System                           */
/*----------------------------------------------------------------------------*/

{basis/incl/b__alp9d.cdf}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow:
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB)
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 8.1
         WIDTH              = 55.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include


/* ***************************  Main Block  *************************** */

/*----------------------------------------------------------------------------*/
/* User-Exits                                                                 */
/*----------------------------------------------------------------------------*/

{&{&PA-XINCLBASISNAME}_CX}
{&{&PA-XINCLBASISNAME}_UX}
{&{&PA-XINCLBASISNAME}_QX}
{&{&PA-XINCLBASISNAME}_XX}
{&{&PA-XINCLBASISNAME}_YX}

/*----------------------------------------------------------------------------*/
/* Include Code                                                               */
/*----------------------------------------------------------------------------*/

&GLOB e_wbel00_w_XX                                      ~{eink/proc/e_wbel00.xxw &XX}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
