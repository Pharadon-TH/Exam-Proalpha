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
/************************************s******************************************/
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

  define variable cPrefix      as character   no-undo.
  define variable cNumber1     as character   no-undo.
  define variable cNumber2     as character   no-undo.
  define variable cOperation   as character   no-undo.
  define variable tDate        as date        no-undo.
  define variable cArtikelFrom as character   no-undo.
  define variable cArtikelTo   as character   no-undo.
  
  define variable dNum1        as decimal     no-undo.
  define variable dNum2        as decimal     no-undo.
  define variable cFormat      as character   no-undo.
  define variable dSum         as decimal     no-undo.
  define variable cDateformat  as character   no-undo.

  
  /* Extract parameters                                                         */

  {adm/incl/d__par01.if
     &Parameter      = "pcPrefix"
     &ParameterListe = "pc_ParamListe"
     &Variable1      = "cPrefix" 
  }
  
  {adm/incl/d__par01.if
     &Parameter      = "pcNumber"
     &ParameterListe = "pc_ParamListe"
     &Variable1      = "cNumber1"
     &Variable2      = "cNumber2"
  }
  
  {adm/incl/d__par01.if
     &Parameter      = "pcOperation"
     &ParameterListe = "pc_ParamListe"
     &Variable1      = "cOperation"
  }
  
  {adm/incl/d__par01.if
     &Parameter      = "pcDate"
     &ParameterListe = "pc_ParamListe"
     &Variable1      = "tDate"
     &cc_Date        = "true"
  }
  
  {adm/incl/d__par01.if
     &Parameter      = "pcArtikel"
     &ParameterListe = "pc_ParamListe"
     &Variable1      = "cArtikelFrom"
     &Variable2      = "cArtikelTo"
  }
    
  assign
    dNum1 = decimal(cNumber1)
    dNum2 = decimal(cNumber2)
    .
  
  /* case calculate */  
  case cOperation:
    when '+':U then 
      dSum = dNum1 + dNum2.
    when '-':U then
      dSum = dNum1 - dNum2.
    when '*':U then
      dSum = dNum1 * dNum2.
    when '/':U then
    do:
      if dNum2 <> 0 then
        dSum = dNum1 / dNum2.
      else 
        dSum = 0.
    end.
  end case.
  
  /* format date */
  if tDate <> ? then
    cDateformat = string(day(tDate)) + '-':U + 
                  string(month(tDate)) + '-':U + 
                  string(year(tDate)).
  
  /* Result format */
  cFormat = cPrefix + '_':U + string(dSum) + '_':U + cDateformat.  
  
  message cFormat. 
  
  /* check cArtikelFrom format S_Artikel? */
  find S_Artikel
  where S_Artikel.Firma   = {firma/sartikel.fir pACConnectionSvc:prpcCompany}
    and S_Artikel.Artikel = cArtikelFrom
  no-lock no-error.

  if not available S_Artikel then
    adm.method.cls.DMCMessageSvc:prpoInstance:showError
        ('xsads00006':U).
        
  /* check cArtikelTo format S_Artikel? */      
  find S_Artikel
  where S_Artikel.Firma   = {firma/sartikel.fir pACConnectionSvc:prpcCompany}
    and S_Artikel.Artikel = cArtikelTo
  no-lock no-error.

  if not available S_Artikel then
    adm.method.cls.DMCMessageSvc:prpoInstance:showError
        ('xsads00006':U).
    
  if cPrefix = '' then
  do:
    adm.method.cls.DMCMessageSvc:prpoInstance:showError
        ('xsads00001':U).
  end. /* if cPrefix = '' */ 
  
  else if cNumber1 = '' or cNumber2 = '' then
  do:
    adm.method.cls.DMCMessageSvc:prpoInstance:showError
        ('xsads00002':U).
  end. /* else if cNumber1 = '' or cNumber2 = '' */ 
  
  else if cOperation <> '+' and cOperation <> '-' and cOperation <> '*' and cOperation <> '/' then
  do:
    adm.method.cls.DMCMessageSvc:prpoInstance:showError
        ('xsads00003':U).
  end. /* else if cOperation <> '+,-,*,/' */ 
    
  else if tDate = ? then
  do:
    adm.method.cls.DMCMessageSvc:prpoInstance:showError
        ('xsads00004':U).
  end. /* else if tDate = ? */
  
  else if cArtikelFrom > cArtikelTo then
  do:
    adm.method.cls.DMCMessageSvc:prpoInstance:showError
        ('xsads00005':U).
  end. /* else if cArtikelFrom > cArtikelTo */
   
   
  Processing:     
  for each S_Artikel
    where S_Artikel.Firma   = {firma/sartikel.fir pACConnectionSvc:prpcCompany}
      and S_Artikel.Artikel >= cArtikelFrom
      and S_Artikel.Artikel <= cArtikelTo
    exclusive-lock:
      
      S_Artikel.Selektion = cFormat.
    
    for each MLM_StorPartData
      where MLM_StorPartData.Company = pACConnectionSvc:prpcCompany
        and MLM_StorPartData.Part    = S_Artikel.Artikel
      exclusive-lock:
      
      MLM_StorPartData.StorageInfo = cFormat.
                  
    end. /* for each MLM_StorPartData */  
  end. /* for each S_Artikel */
  
  /* reflesh Artikel*/ 
  define variable h_s_qart00_w as handle no-undo.
   
  h_s_qart00_w = adm.method.cls.DMCSessionSvc:hGetProgramHandleByInstanceName('s_qart00.w':U).
  
  if valid-handle(h_s_qart00_w) then  
    run dispatch in h_s_qart00_w ( 'open-query':U ).
   
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
