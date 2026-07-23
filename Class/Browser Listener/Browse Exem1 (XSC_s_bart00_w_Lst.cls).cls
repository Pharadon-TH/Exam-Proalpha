/******************************************************************************/
/* @COPYRIGHT@                                                                */
/* Project: Proalpha                                                          */
/*                                                                            */
/* Name   : XSC_s_bart00_w_Lst.cls                                            */
/* Product: X - Individualanpassungen extern                                  */
/* Module : STAMM - Übergreifende Stammdaten                                  */
/*                                                                            */
/* Created: 9.5.0 as of 11.06.2026/thongdi_p                                  */
/* Current: @PAVERSION@ as of @PADATE@/@PALASTAUTHOR@                         */
/*                                                                            */
/*----------------------------------------------------------------------------*/
/* DESCRIPTION                                                                */
/*----------------------------------------------------------------------------*/
/*                                                                            */
/* Browse Listener for s_bart00.w                                             */
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
&GLOBAL-DEFINE pa-XBasisName       XSC_s_bart00_w_Lst_cls
&GLOBAL-DEFINE pa-NameSpace        1.00

&GLOBAL-DEFINE pa-Package          x.stamm.cls
&GLOBAL-DEFINE pa-Class            XSC_s_bart00_w_Lst

/* TODO: Remove this comment and the include below unless you need to reference
         compiler constants in your class. Activate the definition file only if
         necessary to avoid increased compile times.
{basis/incl/b__alp00.cdf}
*/

using x.stamm.cls.XSC_s_bart00_w_Lst.
using adm.method.cls.DMIBrowseEventLst.
using adm.method.cls.DMIUIProcedureEventLst.
using adm.method.cls.DMIWindowEventLst.
using adm.method.cls.DMCBrowseSvo.
using adm.method.cls.DMCUIProcedureSvo.
using adm.method.cls.DMCWindowSvo.
using adm.method.cls.DMIBrowseEventLst.
using adm.method.cls.DMIUIProcedureEventLst.
using adm.method.cls.DMIWindowEventLst.
using adm.method.cls.DMCWidgetSvo.

class x.stamm.cls.XSC_s_bart00_w_Lst
  use-widget-pool
  implements DMIBrowseEventLst,
             DMIUIProcedureEventLst,
             DMIWindowEventLst:
  
  define variable goxFirstCustomer as DMCWidgetSvo no-undo.
  define variable ghS_Artikel      as handle       no-undo.
  
  constructor protected XSC_s_bart00_w_Lst
    (  ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Protected constructor to enforce DI framework usage                    */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    super().
    
  end constructor.
  
  
  method public static XSC_s_bart00_w_Lst create
    (  ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Factory method to create instance via DI framework                     */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    {adm/method/incl/dm_fac01.if}
    
  end method.
  
  
  method public void subscribeUIProcedureEvents
    ( poUIProcedure as DMCUIProcedureSvo ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Subscription method for ui procedure events.                           */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* poUIProcedure     Ui procedure instance.                               */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    
    
  end method.
  
  
  method public void subscribeBrowseEvents
    ( poBrowse as DMCBrowseSvo ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Subscription method for browse procedure events.                       */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* poBrowse     Browse procedure instance.                                */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    poBrowse:prpoEventsBrowse:subscribeOnRowDisplay-PostProcessing(this-object, 'OnRowDisplay-PostProcessing':U).
    
  end method.
  
  
  method public void subscribeWindowEvents
    ( poWindow as DMCWindowSvo ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Subscription method for window events.                                 */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* poWindow     Window instance.                                          */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
      
  end method.


  method public void OnRowDisplay-PostProcessing
    ( poBrowse as DMCBrowseSvo ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* OnRowDisplay-PostProcessing                                            */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* poBrowse                                                               */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
     
    
    define buffer bS_ArtKunde for S_ArtKunde.
    define variable cFirstCustomer as character no-undo.
        
    assign
      ghS_Artikel      = poBrowse:hBuffer()
      goxFirstCustomer = poBrowse:oGetWidget('xFirstCustomer':U)
      .
      
    if    valid-object(goxFirstCustomer) 
      and valid-handle(ghS_Artikel) then
    do:
      
      find first bS_ArtKunde
        where bS_ArtKunde.Firma   = {firma/sartkund.fir pACConnectionSvc:prpcCompany}
          and bS_ArtKunde.Artikel = ghS_Artikel::Artikel     
        no-lock no-error.
               
      if available bS_ArtKunde then        
        goxFirstCustomer:setScreenValue(string(bS_ArtKunde.Kunde)). 
      
      else
        goxFirstCustomer:setScreenValue('':U).          
      
    end. /* if    valid-object(goxFirstCustomer) 
              and valid-handle(ghS_Artikel) */
     
  end method.
  
  
end class.