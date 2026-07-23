/******************************************************************************/
/* @COPYRIGHT@                                                                */
/* Project: Proalpha                                                          */
/*                                                                            */
/* Name   : XSCExportPart-CustomerJob.cls                                     */
/* Product: X - Individualanpassungen extern                                  */
/* Module : STAMM - Übergreifende Stammdaten                                  */
/*                                                                            */
/* Created: 9.5.0 as of 12.06.2026/thongdi_p                                  */
/* Current: @PAVERSION@ as of @PADATE@/@PALASTAUTHOR@                         */
/*                                                                            */
/*----------------------------------------------------------------------------*/
/* DESCRIPTION                                                                */
/*----------------------------------------------------------------------------*/
/*                                                                            */
/* Jop OO for S_Kunde                                                         */
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
&GLOBAL-DEFINE pa-XBasisName       XSCExportPart-CustomerJob_cls
&GLOBAL-DEFINE pa-NameSpace        1.00

&GLOBAL-DEFINE pa-Package          x.stamm.cls
&GLOBAL-DEFINE pa-Class            XSCExportPart-CustomerJob

{basis/incl/b__alp00.cdf}

using x.stamm.cls.XSCExportPart-CustomerJob.

class x.stamm.cls.XSCExportPart-CustomerJob
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
  
  define variable giCustomer like S_Kunde.Kunde no-undo.

   
  constructor protected XSCExportPart-CustomerJob 
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
  
  
  method public static XSCExportPart-CustomerJob create
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
      giCustomer = adm.method.cls.DMCParameterStringSvc:iReadValue
                   ( /* pcPString */ prpcParameterString,
                     /* pcKey     */ 'Customer':U,
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
    
    
    x.stamm.cls.XSCExportCsvSvc:prpoInstance:validateCustomer
      ( /* piCustomer */ giCustomer ).
        
    x.stamm.cls.XSCExportCsvSvc:prpoInstance:exportDataToCSV
      ( /* piCustomer */ giCustomer ).
 

  end method.


     
  
end class.