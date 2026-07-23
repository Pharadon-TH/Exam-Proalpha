/******************************************************************************/
/* @COPYRIGHT@                                                                */
/* Project: Proalpha                                                          */
/*                                                                            */
/* Name   : XSCExportPartsJob.cls                                             */
/* Product: X - Individualanpassungen extern                                  */
/* Module : STAMM - Übergreifende Stammdaten                                  */
/*                                                                            */
/* Created: 9.5.0 as of 15.06.2026/thongdi_p                                  */
/* Current: @PAVERSION@ as of @PADATE@/@PALASTAUTHOR@                         */
/*                                                                            */
/*----------------------------------------------------------------------------*/
/* DESCRIPTION                                                                */
/*----------------------------------------------------------------------------*/
/*                                                                            */
/* Job (Process) for xs_ptc00.w                                               */
/*                                                                            */
/*----------------------------------------------------------------------------*/
/* HISTORY                                                                    */
/*----------------------------------------------------------------------------*/
/* @FILEHISTORY@                                                              */
/******************************************************************************/

&GLOBAL-DEFINE pa-Autor            thongdi_p
&GLOBAL-DEFINE pa-Version          @PAVERSION@
&GLOBAL-DEFINE pa-Datum            @PADATE@
&GLOBAL-DEFINE pa-Letzter          @PALASTAUTHOR@

&GLOBAL-DEFINE pa-GenVersion       OEA
&GLOBAL-DEFINE pa-ProgrammTyp      Class
&GLOBAL-DEFINE pa-Template         paooablclass.clsjet
&GLOBAL-DEFINE pa-TemplateVersion  1.00
&GLOBAL-DEFINE pa-XBasisName       XSCExportPartsJob_cls
&GLOBAL-DEFINE pa-NameSpace        1.00

&GLOBAL-DEFINE pa-Package          x.stamm.cls
&GLOBAL-DEFINE pa-Class            XSCExportPartsJob

{basis/incl/b__alp00.cdf}

using x.stamm.cls.XSCExportPartsJob.

class x.stamm.cls.XSCExportPartsJob
  use-widget-pool
  inherits 
    &IF DEFINED(BJCBaseJob_cls_Y_INHERITS) = 1 &THEN
      {&BJCBaseJob_cls_Y_INHERITS}
    &ELSEIF DEFINED(BJCBaseJob_cls_INHERITS) = 1 &THEN
      {&BJCBaseJob_cls_INHERITS}
    &ELSEIF DEFINED(BJCBaseJob_cls_Q_INHERITS) = 1 &THEN
      {&BJCBaseJob_cls_Q_INHERITS}
    &ELSEIF DEFINED(BJCBaseJob_cls_U_INHERITS) = 1 &THEN
      {&BJCBaseJob_cls_U_INHERITS}
    &ELSEIF DEFINED(BJCBaseJob_cls_C_INHERITS) = 1 &THEN
      {&BJCBaseJob_cls_C_INHERITS}
    &ELSE
      basis.job.cls.BJCBaseJob
    &ENDIF
  :
    
  define variable gcPartmin     like S_Artikel.Artikel    no-undo.
  define variable gcPartmax     like S_Artikel.Artikel    no-undo.
  define variable giPartTypemin like S_Artikel.ArtikelArt no-undo.
  define variable giPartTypemax like S_Artikel.ArtikelArt no-undo.
  define variable glCheck       as logical   no-undo.
  
  constructor protected XSCExportPartsJob 
    ( pcParameterString as character  ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Protected constructor to enforce DI framework usage                    */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* pcParameterString     Job parameter string                             */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    super( pcParameterString ).
    
  end constructor.
  
  
  method public static XSCExportPartsJob create
    ( pcParameterString as character ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Factory method to create instance via DI framework                     */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* pcParameterString     Job parameter string                             */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    {adm/method/incl/dm_fac01.if &ippConstructorParameters = "pcParameterString"}
    
  end method.
  
  
  method override protected void extractParameters
    (  ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Extracts parameters from parameter string                              */
    /*                                                                        */
    /*------------------------------------------------------------------------*/

    assign
      gcPartmin     = adm.method.cls.DMCParameterStringSvc:cReadValue
                       ( /* pcPString */ prpcParameterString,
                         /* pcKey     */ 'Partmin':U,
                         /* piEntry   */ 1 )
      
      gcPartmax     = adm.method.cls.DMCParameterStringSvc:cReadValue
                       ( /* pcPString */ prpcParameterString,
                         /* pcKey     */ 'Partmax':U,
                         /* piEntry   */ 1 )
      
      giPartTypemin = adm.method.cls.DMCParameterStringSvc:iReadValue
                       ( /* pcPString */ prpcParameterString,
                         /* pcKey     */ 'PartTypemin':U,
                         /* piEntry   */ 1 )
                     
      giPartTypemax = adm.method.cls.DMCParameterStringSvc:iReadValue
                       ( /* pcPString */ prpcParameterString,
                         /* pcKey     */ 'PartTypemax':U,
                         /* piEntry   */ 1 )   
                     
      glCheck       = adm.method.cls.DMCParameterStringSvc:lReadValue
                       ( /* pcPString */ prpcParameterString,
                         /* pcKey     */ 'Checkbox':U,
                         /* piEntry   */ 1 )                                                                                         
      .       
      
  end method.


  method override  protected void processing
    (  ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Performs the job processing logic                                      */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    x.stamm.cls.XSCExportSvc:prpoInstance:validatePart
      ( /* pcPartmin     */ gcPartmin,
        /* pcPartmax     */ gcPartmax,
        /* piPartTypemin */ giPartTypemin,
        /* piPartTypemax */ giPartTypemax ).
    
    x.stamm.cls.XSCExportSvc:prpoInstance:exportDataToCSV
      ( /* pcPartmin     */ gcPartmin,
        /* pcPartmax     */ gcPartmax,
        /* piPartTypemin */ giPartTypemin,
        /* piPartTypemax */ giPartTypemax,
        /* plCheck       */ glCheck ).    
    

  end method.
  
  
end class.